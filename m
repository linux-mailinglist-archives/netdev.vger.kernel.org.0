Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12A2601159
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiJQOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJQOmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:42:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A379153D09;
        Mon, 17 Oct 2022 07:42:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HEDxQZ013231;
        Mon, 17 Oct 2022 14:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=DmBCXH7h9kp+I+krRHgw9K8Ay+1RuXEyKdLF60Fk07w=;
 b=a/pWLId+KJNkd02kPRlfEaDE76FIBEA3R5Cbb+0S87nUJPBga4hgPnWAeDknISiydlzf
 XcTVmIz49hSmjzPsmwD+CYCG4NKvMkJXJWHnz7j61JhWzN1OTrZ8/bhF8D465u62D5d1
 1Cl2fIZnhxg3JWH9kBwWFpWoVr5xkBHZb4zLkqIPplL321JEEkUF6UGvQBfDxemV9Z3q
 gWhW3XtIYnBcx8vl199AZ0nvD0NPMPCgqdMs8HRrkQQowB15Wg0Exp5VJaOhPyBBudSe
 6wvIfEx9hFogOPmr4iUf4BkpSNvnA9bbkIGawIV85v8km4MqeKq5jOK8+yGJ34fBMWJF zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2j0ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 14:42:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HCXRIB036443;
        Mon, 17 Oct 2022 14:42:20 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hteqgqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 14:42:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nfl9KF9MUSCoD6MG250xah7+w/yriH2hKfofzgrCvNDs89gEFe5sYFBqzyfPkGHrxKcw5JcLh9vgbgR/2/KpuT0kaH5b8s0e4scf86Q4+75lpBJE9EX8xB7osZK4fstHsxyfonT/eV9a+7/TszFjziDMv+QqFMnf3qRBlNDQaPix/qw2Fhx3nHnXSm7VGYMENxopv1VXThL3WGebaKSpDn9P4vEo5I8SMTfGqdvgZXczfBICXiiufozApwHdbGtB/6xcGjYEy4nAGMfsZQSqUJLlkDWITxERJpfyeCUPFj1iGhcy54H/9KEBqLNvTtpWw1nf22WRj02sJsF5ii0O5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmBCXH7h9kp+I+krRHgw9K8Ay+1RuXEyKdLF60Fk07w=;
 b=SoYHFhJzeHxBmR1FvpetxJd/zJ/I47wInZyn8WtDMnqVoSHQ1PVgzaFQPl7N8srcDpsEkwgJjJXo7+EkHTDkS5YCA44hUgPdPS+GzmBL8OdrYVvzzd4VpgphvlLesB0Iqmxca9vTQ9l1pjqcwUksM29ryfF87kxmnfx3Duc5sWH+PcMnqI1VV2cJ8O3dsZi5WPLZbHsfabeWHe//TYSmzN8liSjda24KiYyln0utBUKV9HKSBfNV+UB46ckZYdDqVNMb3kyAubP+fAaVbTe7ef89WNDl/7nYdQuNd5jw56lCkmmBfmgqXWGmyy2CRPG6/s3qXypP4kx6DfH8Nw6s4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmBCXH7h9kp+I+krRHgw9K8Ay+1RuXEyKdLF60Fk07w=;
 b=L8aZb4bHmWfzsmdBLvhqWKNl13Ogjx0YqOTvNlywgo/naPLSL4303CpWyQU71dIjnCFSK/f9yK9a7ulmaoaN1d0em/hy+m0XRBbTiR3cT+Jl9zAC2sJU/dISWzPGPMOH2gvz/cWi7W11ljzmtHlZu0Nu9S/YOiOVlNXU15ghzsw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5007.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 14:42:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Mon, 17 Oct 2022
 14:42:17 +0000
Date:   Mon, 17 Oct 2022 17:42:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Fix a couple error codes
Message-ID: <Y01pwtBmShqds6tv@kadam>
References: <Y01oqQHl8ItXuR5H@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y01oqQHl8ItXuR5H@kili>
X-ClientProxiedBy: MR1P264CA0201.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DS7PR10MB5007:EE_
X-MS-Office365-Filtering-Correlation-Id: b5822abd-4764-4b37-b2c0-08dab04dca0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXCUfv6DbQdBPo92QADBIkEoJebMJIp78IJ12mO2J/8QOAtkYBtXfF5Ex/NHouGwygNCgq5nJ3N4oUGjThJ7t0A8YjjP+CFP4DCXO2XmCQfA533+k9dUNDybJi7rqRf/Vlk4XufW0eg1XzidxqqyMC3NfmEa7U2dDBLeJeiNa+hbEZ+deDBjcDnGxjCm2gBXCBN9amuO8UAcgyK8rQfOwfHajBNuvQavy1z5vJwI8efI5FWDjqlFBxAr14cq7NXwCvkzZO0rU+Z5OqpYKmuDm+w/fdhBkph5E0SPN5+5VLYm0hh0S4XbkDbjyvQVoFz5hxjWD9hpne2YPNcEuiGIoJoreBCD1984v4Ld2qJkC0v8gHXTzdjs05pjil8fAf2CE4lasMrG8ttuCrXag+/H6Mcs5COpfNSCOuFNIh7kBXYMifX/91oOj6iGyFPYv8m7aLu52mAit47ybywOQgB+gJYyZGvfh4VsGQhWng+Y+G/09+dNIrBsCsMRgh6B182UG1NwWYb67bm6A5oXkmfBVoc3ra7B4EhoXUQz2+/T/LcZawH3PD2PrLeJUSRuDsL4wG80eW52+TElJKxuqAn6PjE2OuvubC6dh/0QmefSfQFPvJNCEDRhdZ9M8JKd3CplDm8pm5rZgwFIyTaTlpWr6yGjEEgfPNKL2i7isVqTOYX9bLRsYB9+bt5Yd6n1iUYYOqBp4k87uGfuOcDw+GP5VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(6506007)(9686003)(26005)(66556008)(66476007)(8676002)(66946007)(4326008)(110136005)(316002)(54906003)(44832011)(5660300002)(7416002)(2906002)(41300700001)(8936002)(6666004)(478600001)(6512007)(6486002)(86362001)(558084003)(186003)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e0qZrmtXAmI9YlXsGctta9Vp0IVp4dGLIlkFpdfxtRiFB6dhECl+pq7DfqYZ?=
 =?us-ascii?Q?HZR/2j7eC1an70+rBZgMBgli3DKurMORHnQgU6pgbMkcRP0gpZpCVgAJnZaq?=
 =?us-ascii?Q?2FpmL5s0WlEi1Iq1kB6BZ//E4H4LsgMXQNNCBM4VvBphIZLcUciTJIGXLZyP?=
 =?us-ascii?Q?O3QP9Rn+yqzMvLrrT9fAi+i7GZRsxZCGFfmTjK1NTHaZ0P7xJ7Jn7QzWbBxu?=
 =?us-ascii?Q?RfVy+ETuenEU0zpL4ZSnYkbQqq5KKAnWSZJ1j6tKf2zrNUZo3X7qWzVIQ3jo?=
 =?us-ascii?Q?2+73I7qV44TVfpa3DFq/JtpfefmYdof9HxMO+w734xEaz5dKNj7NyXaVDQZL?=
 =?us-ascii?Q?DQWUoVR7CqcaLfpCNsZ70glUXYGgS1QIQHGPMNz9DG8QMRXyoBZVWRx8lfWV?=
 =?us-ascii?Q?QGAFT87Ugp+K0u7B6c3xwRRqY7ZYfsLQD17SL0V4PFtILx/YIl29CY7LjAL/?=
 =?us-ascii?Q?NpPRAsMewNh9G0xholIkqgL+2x9bFPAwVUsDZSRS1mv0Upi0STrD4pX5nHJX?=
 =?us-ascii?Q?/WQIYfiJzMDKvo22LLCJQcdxMwd2UVQKH0RHOc+ldrLD2n+eReSMEwe4uRzZ?=
 =?us-ascii?Q?VxJFfVyFB3ViLURQ0YPVxMvRiv030KFgtyoxoAhw2qCt2uaw/CL1JQteYor9?=
 =?us-ascii?Q?kAtPrBymXxaQ12uD0MN971G6oi03QcladGCR1wWuVzT85TP3/rao9iEnHWCv?=
 =?us-ascii?Q?8AT0JWfkRe/L+rCiW2D06B+rj6INEQVUCsyMkkPA4zH6X0TE2qZpOZX987sn?=
 =?us-ascii?Q?jbzkvYh/iMyJVHs0IjRqhN+4+neefbKRoSEBqraOpF43XA78q6jR8CAotUhB?=
 =?us-ascii?Q?GO4Rypq/NIZsX8iwa3v77SwjG8VQFAiMMF5P8mwPcMCkOTEwKvwjyJ9ozxsS?=
 =?us-ascii?Q?GeCvHUZejc3PZoaXiIRdF/+ipSwEufsyyX67oGzSD8R/qRwv5eIeYi3E0n4E?=
 =?us-ascii?Q?7ga1PABrCYLB7YDEgG4S50aXkVRoVa6LKMdfYUhOlr3iKE7GYAdAESXyPFGH?=
 =?us-ascii?Q?h24Wa5uo2GmVaqhobaTajlTxBFpH1nVnYslIa8izHHgONAv61h5m2hQJprx4?=
 =?us-ascii?Q?T+wrO80x+XSfZniK8ZtyFNMF1IqfA1f0pLzz9PPzuA83oAX7dfYeKelyhRpB?=
 =?us-ascii?Q?UhMaqDWzGVrrsSaPFJdPMUk2jtta15s4rS6nxHJbNM/MkpE5W1yuFblhpkxz?=
 =?us-ascii?Q?YkTv871Vv6fSpZSMPsxpcNUIwNdUvS7xfaJEliGVqe6owaleZSd6P8wnPxGz?=
 =?us-ascii?Q?5ZQLtOUsuk+y4tOeM7guJRWFzGNuloPQvY8EsvoglNVszLvBVZ63yjmQFNvx?=
 =?us-ascii?Q?ajmELb5enSH7V1s/tVJlMqUDQ+ajQ59ZtHWt768iD/1oy6e6/MegUXZYkTrg?=
 =?us-ascii?Q?Zr63CO+mZ75phcuHRm7o82MiUEoKKKeiSepIZouxVQQkyXuugj8TJpePSX3Y?=
 =?us-ascii?Q?XNiRb72EE3sABAer5mcZVlTYT86hTZET0cLEKKflbKyl9TdhJWlinFcUCMKT?=
 =?us-ascii?Q?Q5Sb62EbdR8SC/RDFU4eeqrTTvoe19M473V5h1rwqjo1Ay1TCT2uQsNjUoE/?=
 =?us-ascii?Q?EzTlSoXv70yWORgzL9Fomx9n1VGhvVtmSaOjEjZ9Wig5T2DbTlfZFH0DNJD7?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5822abd-4764-4b37-b2c0-08dab04dca0d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 14:42:17.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ur51a5bXgk77SyPEzY5tmDSyzdhDOiL/ij4mE44vFQ4lTCt2b/y8ZhKXgd4mdmTemAJQPGuefa9PntrKeg7Lnv8da6LZ6eqtOMU7UdO32pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5007
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_11,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=722 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170084
X-Proofpoint-ORIG-GUID: QucKSeJL27_I_GHBKXHnvzQQmjoerG7Q
X-Proofpoint-GUID: QucKSeJL27_I_GHBKXHnvzQQmjoerG7Q
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I meant [PATCH net].  I checked that this could apply to net and then
I still sent it with net-next.  Sorry!

regards,
dan carpenter

