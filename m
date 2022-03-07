Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF804D00EB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243110AbiCGORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbiCGORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:17:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DDF8E1BC;
        Mon,  7 Mar 2022 06:16:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BjMHp009281;
        Mon, 7 Mar 2022 14:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=90kFYoCQON2ftRVvtaKx4I/l1oKiA1yAdSarljk4za4=;
 b=z00FjUCDOLaCkBNLyIzNNeG4j9eBJcnk+T08FHzWHfAFsSnF08H5eZTsIUZSBMovibOr
 8SW8CH1pxS5jK20hxJ7/MNa3a1ziecreUXdvUmzIUds/i9X62VUXUhVCKMGQf+SfJh4Q
 eNeumCXUWKtG03uyNMO/X4OJsBWoG8PmYZm2uw28XyUq4mZNPgLHuW1YO0UbHYVq+Q5H
 aAnhXgjgmX7qIKwNYIRt37+le+DXcxR/7BjPA38Oc0Kmd2qThTIfs4rqrzqldrX4JQst
 B5fCulCJ4DVRNScInzVzeUr0I2VjeW4rIHf8S27xrv18PI4XDDDv2/fAsVKV+yZr345I lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0kyxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:16:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227EFE1j100980;
        Mon, 7 Mar 2022 14:16:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 3ekvytjpe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BW65WyEVnUY8ZN87XzOqxkF3CeLql2Vb2Y5gLGi972gddeWCwfkAe1a9iJT2yL8g84qBMFpzk4NRvgkb0Dk/ikchp+5aSQhmlUAT97IwMyNrN8worslO71VJIgwlZ6c9NcMVee04zwytnyBRzFCVqFaIKrHTrH4Dbv+T5HYU0Mzrdb/o2NeOUPRhtPloF8S0dqC+pxEOEYuaDkWcxbx6z5AyyiJOkC1OwbTEeMF7O7zZemuBxphBAjRS2EXRCt4mpqtARM8aB+1JxNu97fX3OVIX/yMBS1dPwTZ67q6x54XgRdQgh7YXae69ZOt0PrBUv2EFyNov8+eny7pmi7Re0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90kFYoCQON2ftRVvtaKx4I/l1oKiA1yAdSarljk4za4=;
 b=YiwBRPd5l2yPhbVQ1BbVYHuYwd9BORNHl4oSPyl58EwvvMETZDkIFikwPNaRIdthKigzq7raj50l9w2HVxeTwTeT3JMnMTj1RbGaQ/a+mjcKHJWoaEhzg5vsOOpcTZljMdl2fNmmz3Eil2pWfXfEwKUs/C5dLeY4fg5vQRJpxjRS1T17qOXWdYPqNJRNsgozxGbDZ9Z5uz08fjBQCw8fsvEBWxybw0/Q0TsNqxL5PpnU+6WXf+G8aKJeQWPMisuRztAoXuTqmoMQJ9IR8ABIPPuCqng7EFj7JVmsOcGwYWaC3uYeC0VAyoc0f8UA3bfR8/IYEyzmeSz2N3IKYyx+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90kFYoCQON2ftRVvtaKx4I/l1oKiA1yAdSarljk4za4=;
 b=sasu7POJiktFrjEMF0xN2s9/zuV9MGPG7d9QfLoPbXnC+R6COJANCiNkQIUHfkkuU427qZG4E9JUgZdAHJ1/Se87fjP76aXABTMBmbAp4P6gVLo5qfF1RStbVcFYXRcVjNsNQr8QjsKrfu4L9knlZ5A5HilCJqoLRefBTNFBnHU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5807.namprd10.prod.outlook.com
 (2603:10b6:303:19a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 14:16:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 14:16:10 +0000
Date:   Mon, 7 Mar 2022 17:15:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] vxlan_core: delete unnecessary condition
Message-ID: <20220307141552.GC3315@kadam>
References: <20220307125735.GC16710@kili>
 <c568979a-d3da-c577-840f-ca6689f7400f@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c568979a-d3da-c577-840f-ca6689f7400f@blackwall.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: CT2P275CA0032.ZAFP275.PROD.OUTLOOK.COM
 (2603:1086:100:a::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f7d8e9-f3f0-420f-b783-08da00450788
X-MS-TrafficTypeDiagnostic: MW5PR10MB5807:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58071EDBE3A341C07A845AD08E089@MW5PR10MB5807.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSgGCwUQA3T/YeW6DmniKAx4NcIB0n+etHYnAnFyEjqvpxVTGKOXie/qB+DnhiTxba6AozJhyDDbuZTE29cF0htEy0ONLtpib4KeVpL8kOl/DlOt95HhrjhcZW1FyZUEOqXtOBnJPBanWokSOeSpNk5rQwJOr0cOPI8oWtQOzz04/7yy9JtwThUlw++aL0zjuKMX39ts6urLaOC2xKSreDKABLBmHvFMoXZkF4xZX435ugkLa9O2TUDOEHlyOHDpgbPLUCZDb9jrKk3xAzdhyQbJeFXeA5JOuhUOlIYEz7LZVdWs3W1DvUKlJd4+puurH9btmHxW2G60IjWjoQEARNi9ZspmBmrCcXDCr5+h87k2id7fBUGit+i24DEo6t3BFVPJ9Ee0g3gRFQ/rIRlUQZMNONxpccLVfgJCPCAAu+YW5O0AM0knOgNbs4697DV05JgW0psncNjq4+4qoMR9QAQ5olPicjZmwfKtLHkHdZ4lIZNWt9OAxN1n/PuxdL+Effj6DQOsbvIKC2YeK18N2uii+LMaQ93bmMHjjz/3nQAx//KYzdHmLgt0ltEBPHptqKYMTWlGj7QsTIW864KIWi4SqKtN4iALTY1PGg4arDP4HOB9kXGRdBLpU+w64KjoNWIfsMhMII1Lq+V6Rzj01WZiGEMNlfOIphJ8LOhXdWCxgEtx1YP8N61eSRZZmHX596BHyvEJnpZ1Z9XIdvgQ3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(4744005)(2906002)(5660300002)(6666004)(44832011)(38100700002)(52116002)(33656002)(6916009)(54906003)(1076003)(33716001)(186003)(53546011)(6512007)(9686003)(6506007)(8936002)(26005)(316002)(6486002)(508600001)(8676002)(86362001)(4326008)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0aivEQ7nS0VPvYfNwMXN9HG47Zc7Qp7BhDna0id70nWUBc840tvCA96E5T45?=
 =?us-ascii?Q?x9b46SQ9PE/OEk+coogzfAqXqSKBTvFjtOSoKC5bpAcFShr6EpLFKa0K7ayh?=
 =?us-ascii?Q?u8AJYjP/lbG6wt+NCBZCIQsD3R8KNlW2peRawAgTWS68CdV5Xm7yXWGzDpUu?=
 =?us-ascii?Q?j5eHZk1QqyXH9Jxy7828IurSwWgNQhsbquGfyHDtOE2S+Rawze3R0IwwdAA3?=
 =?us-ascii?Q?yjcdrCqIQTekjMXIDBo2y2QD23QpTEoz31PjnxY6g0Y5jtQmR5GOmNZ70Ss4?=
 =?us-ascii?Q?NcmsOHHgBoVtB1NuBKOs+rUiwP9+E2GCRTqBaQ/xlkMtAf4yN/07hOX0LVU1?=
 =?us-ascii?Q?XLfOKj+TioYY9D9gVOYcz/cH7NJdHVhmQ9do+Nc9H/CeKbUX1Pkyr+Hkf7Lf?=
 =?us-ascii?Q?oCVW4+mSaPmugrpdhZ8WDiVVA+h68wDO4Av7dtGkizsf8+JGANExFxr7ZG2R?=
 =?us-ascii?Q?HXnNInFLnJbVE4hlh505wYqYMupB7mm+VnBXf0R/PyEnH8xd40UJfF5/6os0?=
 =?us-ascii?Q?5670a/ZzAh5uDg5fDQHIbqis6Mzm8fo22K3U+G7uQLZAjv7e86AaIA48Itig?=
 =?us-ascii?Q?FmvQmaCebi83CRhjG1OpJhznQGC18a9lc8yFJRik5psnvFxOSIH599Ws/nUD?=
 =?us-ascii?Q?rp8Cm+Gw0GjusxC2QqRHJd1b/Nf5ZvAX+m2OFs9Hmzm1xHnI5vhaFCyz6sni?=
 =?us-ascii?Q?hT0HrfQoiVEJyQZpZnSa8mga6zwSCGHH5ktPY+ONLAWzNLYwa9ieuwczW5cC?=
 =?us-ascii?Q?5GRgiETOz7yUeu6geIIAn5k0sI+i4jqVP8r5gd4/QNfPHuwPtOiKR17v/xj4?=
 =?us-ascii?Q?riX2jeZmH7TrHaWSHUA+ysx1qDaJAX2Ba5NCBPqi9hyOXPqEsifhizSXsHwT?=
 =?us-ascii?Q?cqQajoNaY5bjjY6qdL4tZAOeCyINvCnR6R5cFYzQjvfrhh9+rrT8cEVWhDHm?=
 =?us-ascii?Q?QZ/whrkTRBix8FrI0QARkWQQVu5E/77Eyl1z0IBG+kHCs79F+ifA50PPVkHB?=
 =?us-ascii?Q?jCaaAdQ68yxpLn6RFsXpMinkfQBI/sXmc/VgNzGHQPADX+m5kf+edUsqee1Y?=
 =?us-ascii?Q?BmvBvkUyDH9Upl8vdcsprwWVbuQsmZQQ79AROUy4YaDYAjwR56uge1av1/N8?=
 =?us-ascii?Q?9tO5eo0b/jfG2r7+WeCRy12mkyHNBob+9J5qOSnp8OiZ3P2PN16kEtoWPnF9?=
 =?us-ascii?Q?8Adoq3Hv6y+LNg5uvwDPDTU6K+xyDf/1/jELkWMOc83Zn8mTNyhyfNW4tbdd?=
 =?us-ascii?Q?pTeHwy86D5jm4JJbCo+iTdaWdBpbxCrMsSHB99FmlHna7Oc0spOjm4uRhUJp?=
 =?us-ascii?Q?b7LJO5q4rYlt6cmsu4ftpNbM/nBWczwTSliZE8e2kWVc29aBZ/VDSxS2W7fF?=
 =?us-ascii?Q?vP5FBHgbizoFH7p/DsJV4BjvmgfZyITh05KI/Qm46t9JgcIGEamxRnaimb6w?=
 =?us-ascii?Q?/puSamygMAogJCVwtD6ckbF0qHMIheBsA/Ye2fi2B4+5d2kw1/s5eun+vfyW?=
 =?us-ascii?Q?vLYhdd5zghJ3StcDlZxfRXrhb+S0OLJXef7uoNcy/3GtaZVMTc6DOWyaSyff?=
 =?us-ascii?Q?pq6goL6xyGJL6aPFh4A41pGBhZgsp1Khm9h8n1KUJQzPIHC223lK/flsN9i/?=
 =?us-ascii?Q?3PgMDmyUtZAn77fuzhUvTJgWj8FRk4zMRKR2k8EbV68pwAYhB0rxxqMCr1Lj?=
 =?us-ascii?Q?/BbZCQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f7d8e9-f3f0-420f-b783-08da00450788
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 14:16:10.6896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wexHYV72VPTw97l3LGN7iwLSm9OKdY7TLkURynHN/qrUDTARDXZ6L0G7cED8a2qFPsB8Ph3ILY4+utgJc2j/G+w5Qv9dgRKqACO4tHJozGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070083
X-Proofpoint-ORIG-GUID: 9WBspPsum19_AqFxTenqtR7XmSB4sI9i
X-Proofpoint-GUID: 9WBspPsum19_AqFxTenqtR7XmSB4sI9i
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 03:05:49PM +0200, Nikolay Aleksandrov wrote:
> On 07/03/2022 14:57, Dan Carpenter wrote:
> > The previous check handled the "if (!nh)" condition so we know "nh"
> > is non-NULL here.  Delete the check and pull the code in one tab.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This not a bug so a Fixes tag is innappropriate, however for reviewers
> > this was introduced in commit 4095e0e1328a ("drivers: vxlan: vnifilter:
> > per vni stats")
> 
> No, it was not introduced by that commit.
> It was introduced by commit:
>  1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")

Yeah.  Sorry.  No idea how I got that wrong.

regards,
dan carpenter

