Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D244BF15D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiBVFbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:31:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBVFbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:31:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442627A996;
        Mon, 21 Feb 2022 21:30:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M2thRc011659;
        Tue, 22 Feb 2022 05:30:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : content-transfer-encoding :
 in-reply-to : mime-version; s=corp-2021-07-09;
 bh=vvqqnuFeRxlMWfnchLHLK5HDvOMRoceCn5y5Oul1dqM=;
 b=AFq893pHZYsuF2Ju4DIMGXAFkbjq+nkDmouPvzW0aZ1VQam02jK6m0JjGSfRqDL8TsPI
 8tIidLglTcNYGWLaDQ0qNsbUgn8KL5AErQdQqhtYItmjcB96fgA69PM0q3AOkoJZ8oh1
 cleC+OGL+thEmCh6Dhi6nXI6B/3bJJuSsCwdYD8owJFnDrXw7HYM/4OoSaTCbNitF/ME
 p60avsaMBoRXhESYm8higgR6MxMOzPKe6xDytQRLyqTr2368xUiskfK4I1++1Po4KRNk
 6RiQJb0UZRMlGT1LHKOdY2xFKQad8pGfkSHAyb2jH3zT9xk5/0h4+mzWOmaZ4d/INyCf Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3earebnsqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 05:30:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21M5FXxo159098;
        Tue, 22 Feb 2022 05:30:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3eannty4ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 05:30:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMlB6tO7pZsRwvsoUYrzRPxE9F0CDsRRlpOdRkexYaJCj3rxG0COxjq57d3IyVyBuyjr1OBZfQcOOODRXHx4jkidQ0cdBJuWPK2PgojhZusNmRo5yB5CwZsSVVd/ZekvX7Ip32WwS1P4A0961dOJgoSLrhGSkUNMleQHDW0S7dHCuL7qN49czgVb2AEF2/e5QRTyriai6L353U+hp747G9ZZ04yVQXp08Wh8qNMDNNKIQyXtisaQpl4z3ZgjoReg6dbpdNeFsZgBeXaSmNJo+wFLOjkCQmFDlclQLQsesHPdzReBeVLGHRnik1wFo1asAzYoHAFkp/LDC9m7HLqsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4l+fmTwhe8+7dyy3y0fjZpjI75h5mpMLrdhzGC71gk=;
 b=TAbOo4XVsxHB0fdXE7IE803fSrRHl734ibKyvFnaQIk2onKvgcXPdKu7rbDbAwge3A84tPhw/Toop7aq+TAe/l88aU57iGjWl8GibQebW9cGTIL3EFSelC2Qpmho1zY9zGhuiFuzsPYQ5wiCxUndxUC/MhnHhc4CBb1jqdKvD1pmqDH8FjCspXUZOW/RMI9T4WIFbaWEfbsyP2+K6KY6FOl9oY5zC8LQHWJ7qXTsBWsycTbqZwjnSeKpOAUutoF62i8ftOhTlxB8/1Sjt/88vLk8PgI1vJhSP1hqzZHYTUmHk8RpRmHAC6GEdkrHqGS4HxYxXYLEffe64tpfXCMyyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E4l+fmTwhe8+7dyy3y0fjZpjI75h5mpMLrdhzGC71gk=;
 b=i/WPoi6KR74m5eRCgZpDwCzdGdkbBcfk1X0nFIG529im23eaTye4IHSrAWDshljAuZahvWjJWa90lk48c6+XNr8iRn89uzzzuCihC67xpNmpWjjB0tbxqUcjAPnrzZmnkrkN35L6SPjjtx2CGjSW9QTpw5uPb5K0kgqgHOw/XvI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB3759.namprd10.prod.outlook.com
 (2603:10b6:208:185::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 05:30:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 05:30:31 +0000
Date:   Tue, 22 Feb 2022 08:30:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Asias He <asias@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <202202220707.AM3rKUcP-lkp@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221114916.107045-1-sgarzare@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a56b1505-b9ad-4796-4673-08d9f5c470f5
X-MS-TrafficTypeDiagnostic: MN2PR10MB3759:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3759F258AA4591B202BD735C8E3B9@MN2PR10MB3759.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMh2nR3/SSaLfLIW2nYKled398+rCvGr4aN8GqiL6Z1of7dJhd5SZdmOuG0xnat56jtjUT+J5VCzyX37ZDP7VdXYsgFZtbDFdEOcYayV0aNiWYBJ9kOory30uHFNHwhdUr+trZGSf0gSTf1GrVoCYymu7CWlk/AvMVwqo2baNKqxMLQ6TIdnHBV3JxKAPjbqnznix2UHlEn5rEoFL597vje2pUPJerQlH9UJexGUQPz4heIKGSD0//++pDZ8IkHoqiRUVfyIU27PxaF68CTjbwGfIz4h9GMQX0N2zMS/D6ru0UAbGHgcYrnPmBTfPHxWj9iuaK37SiAcj8atdUJErUVc076ff4FFtzn1LBTwcPCnheBQ7UQGOp0LQ6vA4xWJz0dnUBIn+5HuAi6l4XIE5Zry/Y04W+miw0xmxUWhnuyJ4QmXx+bdJaYAmqGQni78RrXwEb2miNs9YJOcnxoXcz1VwyVge8R4nxam7YU7/0FAce2+gvl5IeG66Xv2KfUZU2/Q7lntl9O7OL5j6Vrc3X84CgEV0yknH9XqtnG3SDiFk2oArTtOHWXQbhe4MWd4+SrXDuwa/ekk8Ceq0orTfAwr0zZLqGgVtwh9kTnLKoSE8eLjQ0R8sVUALyWsA3yrQukzAK4j7GIhR5QlN3aLHWxkfCFNwvs0xYkrULTMPbaJXK26kAEJXoLQLtB5QVtJ1qRju26OLTei0oR3vPC2MQ1FHWwDhB1QkZkPeCsHR0yNQzNJGA38HqV1SGmFRNw4YyvH0Iw6HVi6UpPJr+3/UTw1sXMW46fhoyShcjWbyXlr1YuJVFXeh0vjU76hFnV9x3xT+Nq4Dwlbqxf9+FNfNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(9686003)(6512007)(6506007)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(8936002)(44832011)(36756003)(2906002)(7416002)(54906003)(4326008)(8676002)(6486002)(186003)(26005)(966005)(110136005)(66574015)(83380400001)(86362001)(316002)(66946007)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?DupoMAYxO4Ag8VOUCizWUVbkL3lL+UcMtn8sRuTyFprZsdDW1t+efV2q4j?=
 =?iso-8859-1?Q?qb6DpgmdmzSW1y1Y7qdwUpEVADsD4BDp+X7Vw3k7Xx2xneM7/dZslhWdFS?=
 =?iso-8859-1?Q?AajBvhAM6l8b5dFc93dy0wMMwKk3nYXMgeh++BgBm4EsjBf/Bd6lETCABB?=
 =?iso-8859-1?Q?V8DZw5cyI1NKB87IAcUqk7av+zR+riY1ggRX57ox7QxoKj29+wf0NVmjQy?=
 =?iso-8859-1?Q?a9CHiTN0J0W7sxZ9cQwmHOz+9KZfNC4a05RxjG7Z+zy0WkpBnRKEImuLrn?=
 =?iso-8859-1?Q?p7cM3z76U82MgjGdRAgr87RSzuGbyx3bkkAUZha1VhUar/LbZswemTCmC+?=
 =?iso-8859-1?Q?NgP1cs+J6o0+3U8IT10KkTOMvmBd2B+kO5SnCn7NLXlcXesfjoD0MvEQ5r?=
 =?iso-8859-1?Q?1+SNcVtBm1MK5h6zzsNetstfUFHch5/+y2dtLqOpchy5u6J0a2B8bZRyaL?=
 =?iso-8859-1?Q?n5I19s3rtF1VDBhJR4WnEfl7eaLUgzxASs1/ETTA5LV4j/CUBz0JP78P4v?=
 =?iso-8859-1?Q?xku+MIG9WQ/FD60XDT+4hA2HMAJYMsM4Vi32m/dXUt8VU+SyK5KgIkNUO3?=
 =?iso-8859-1?Q?HzSlcH5qNet+kgowNsrVxEBWTgNc59JMbR0GwIp0L3JVnj7ktHXDxhfRRr?=
 =?iso-8859-1?Q?PU9G+VT9XSpgO0YbMHcUJhAlMPOL61k8In0g/MGBWmP/6q6GWYBBcm3tbg?=
 =?iso-8859-1?Q?eU3GfFbQ+1xMeYF78+h6LUcc8WbFrmEVtv5w1qHnKcBrJaey6/0MeYBDop?=
 =?iso-8859-1?Q?16QsXfbDOnt+dyHu2s+NbnUYzqFsEthsj3/r0/TkEqXLZb+4qSFKw7n4DA?=
 =?iso-8859-1?Q?zPVGnYNhWoTJ9QeXsrYRItVmAhrdLQmVsbRf6QBPaYIFQkdY8+j7ECb7n5?=
 =?iso-8859-1?Q?xnRDzAOABIW/dkUXDga03/zXhRiqHLrtSQsiZo584aN8sabyempWAasEyZ?=
 =?iso-8859-1?Q?gAkB/ulX5sQqiHwkMkzeoO9p/6TJTq5UrYwPpingDwIH+0JJUAb5qKuAvb?=
 =?iso-8859-1?Q?lkXzc0LMuh+bVRZ3MxDjioZkWpKMD0d4BVIBX53V3sKrP3Q4o9sd/MWMfA?=
 =?iso-8859-1?Q?vww+BiliIFd4a1MOwtqri9cvMDMxeg39fc4bQA4uodukd4f1Jf/rORh47C?=
 =?iso-8859-1?Q?tQhIQSoi3yOl9AKGKVEgBl/YJZ4HjRG2f+BMZI2J55gHZYMIqGGU0LTT9c?=
 =?iso-8859-1?Q?MMFRRU6a7AK+7j9deMpNAVudKyE/HyjomAg1hxrl8hpffz6VDwwg6/NE9t?=
 =?iso-8859-1?Q?Eg3AdHqm3Jrtk1RGVKMj4FYc29bE4IMvuK6nQRzIx+ly55kxSrAwABG36X?=
 =?iso-8859-1?Q?THa2ryqY+cbdei6ck2OQGuFfji8fIVD9MfUczu+cix/wRH9/ZGRpsAwVeO?=
 =?iso-8859-1?Q?ecYJLYo6XXzKdxFrRq3dlnEsv0YWfzfV6titaWAViJ11YBEInfFYULaWrh?=
 =?iso-8859-1?Q?Q5lMQ60pJXjhuOvQHX6oeDiaQPZwFMZOQEkHSsInJDY0N3vLA9QLtTJkbH?=
 =?iso-8859-1?Q?zH38efn73q3IY6bXZtr2AwXSvOxgj05dY0MIEh+9kUmsWvVq41IT/LHBfy?=
 =?iso-8859-1?Q?pJ51Lsy+NvmKuzaPCc4fLDfUURUVuWG0WmRm9FeB/a40odkBpWuG4bX4cy?=
 =?iso-8859-1?Q?gNVTaExM6A6CA3hwz21NxlG1fFLCrnA/OlaOy+opRjl+XqHphK7zKefgde?=
 =?iso-8859-1?Q?j4dAkREmlGUCtd0EGg3+Wnspw301nNgNmZQjZlbvSM2L07cr//MtoXam7k?=
 =?iso-8859-1?Q?5tbQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56b1505-b9ad-4796-4673-08d9f5c470f5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 05:30:30.9653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBxV4m5AQJET+FL1WKil9PZ+ZdmvGe9MGszRBTOuWnPGLwMFr4aF1veTB5cCn3fquoGuUTQmcu1CypAzmODFIMTyuBnxvE6Fq73b3YU7SeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220032
X-Proofpoint-ORIG-GUID: J2duwGvUQJN2q0vilUVN2G3PJ1Eop8Cy
X-Proofpoint-GUID: J2duwGvUQJN2q0vilUVN2G3PJ1Eop8Cy
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FAKE_REPLY_C,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

url:    https://github.com/0day-ci/linux/commits/Stefano-Garzarella/vhost-vsock-don-t-check-owner-in-vhost_vsock_stop-while-releasing/20220221-195038
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: x86_64-randconfig-m031-20220221 (https://download.01.org/0day-ci/archive/20220222/202202220707.AM3rKUcP-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/vhost/vsock.c:655 vhost_vsock_stop() error: uninitialized symbol 'ret'.

vim +/ret +655 drivers/vhost/vsock.c

3ace84c91bfcde Stefano Garzarella 2022-02-21  632  static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
433fc58e6bf2c8 Asias He           2016-07-28  633  {
433fc58e6bf2c8 Asias He           2016-07-28  634  	size_t i;
433fc58e6bf2c8 Asias He           2016-07-28  635  	int ret;
433fc58e6bf2c8 Asias He           2016-07-28  636  
433fc58e6bf2c8 Asias He           2016-07-28  637  	mutex_lock(&vsock->dev.mutex);
433fc58e6bf2c8 Asias He           2016-07-28  638  
3ace84c91bfcde Stefano Garzarella 2022-02-21  639  	if (check_owner) {
433fc58e6bf2c8 Asias He           2016-07-28  640  		ret = vhost_dev_check_owner(&vsock->dev);
433fc58e6bf2c8 Asias He           2016-07-28  641  		if (ret)
433fc58e6bf2c8 Asias He           2016-07-28  642  			goto err;
3ace84c91bfcde Stefano Garzarella 2022-02-21  643  	}

"ret" not initialized on else path.

433fc58e6bf2c8 Asias He           2016-07-28  644  
433fc58e6bf2c8 Asias He           2016-07-28  645  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
433fc58e6bf2c8 Asias He           2016-07-28  646  		struct vhost_virtqueue *vq = &vsock->vqs[i];
433fc58e6bf2c8 Asias He           2016-07-28  647  
433fc58e6bf2c8 Asias He           2016-07-28  648  		mutex_lock(&vq->mutex);
247643f85782fc Eugenio Pérez      2020-03-31  649  		vhost_vq_set_backend(vq, NULL);
433fc58e6bf2c8 Asias He           2016-07-28  650  		mutex_unlock(&vq->mutex);
433fc58e6bf2c8 Asias He           2016-07-28  651  	}
433fc58e6bf2c8 Asias He           2016-07-28  652  
433fc58e6bf2c8 Asias He           2016-07-28  653  err:
433fc58e6bf2c8 Asias He           2016-07-28  654  	mutex_unlock(&vsock->dev.mutex);
433fc58e6bf2c8 Asias He           2016-07-28 @655  	return ret;
433fc58e6bf2c8 Asias He           2016-07-28  656  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

