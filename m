Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B656354B3C1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiFNOqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiFNOqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:46:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A962E684;
        Tue, 14 Jun 2022 07:46:48 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EEjHtg028231;
        Tue, 14 Jun 2022 14:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=1Z3u5aBfK+eyAYz+x977l6SESiK+lwpY05ehV9powGQ=;
 b=WlkjLp8yzdqjymLaIJrgUaLaP2g780YN5hrSYKqyejbNi+hBOTYipjlGDov8tyihbbze
 rtRfHbi4O2ln96qckKQX0OPucTKPKWjLo4Mu/qTt09JGpdWprNeq4bvr7HpcXowUu2La
 nffs2blMw4BkyNssjLBxEorRy2E1PbMJ+K1aheT8O94cEjk9e/4q6sdW+ZnjmZ3MXF85
 x/zKLhYIAFgTp/Jb8UxUlpJIsYw+dkO7Xk3XpsWxmVXwDNxbazTDrVTABIyw4JBXKErz
 kK7F1lNGgQdXflT6n9eWIOmRds/CV8C3kiRoAGmSQTwpX469NaQ9Iun7Ol4RGbt4ECsx jA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjns61b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 14:46:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25EEjegh017074;
        Tue, 14 Jun 2022 14:46:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7my04x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 14:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFcglJa4+CkOFIBEhZ8snwlGSqx6BnBlOe1qRJs62FglZ7BBfnmQ074sLThKPacLoHnAHiQfu12sTfZzK216MBR4TLhi3EVBoaPT+D4bdisXf8rkk2FrG3u6ML7EE49sRfTChN9vf0jPpZ9kvluiNlLGv9T5eKq5OEHlS9VTUd1he3SrQQYDBfbuq25or/4HvAyXnrz3yJMYpGloOSi8pEtLJjX+Eo0W/ffzTlkz+rmGHPMsSmpbrPDYn0w/8qjc+Ia6IdsCH5r8UoZH/uRYdnJJZ6vEfxAOnNqs/x4Nm/Agb80sIPAXyzp+bw9g/uguJGhydiDcmSfJxjWrUbjcNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Z3u5aBfK+eyAYz+x977l6SESiK+lwpY05ehV9powGQ=;
 b=NQUayyaIAs/RXsnI3M/vMjc+kzAxiMWU+4e8RfseYW++DlZY5TesddphX+qIi75ZdSwdzGx1vTBXm4t4HOoaiWfpOncQHLCAC8z6UO5przY3EJXO2PCXsHh0R+8yuJrvLCDXSMKQj3MzEcs+crikhOMjYQJH0r0lgqJzZ8dJ5oyinyl286qLEJfxnaW0iIeqE3xefQvY4NjGQhRSVo4Ah/2YqxD9mfJyYI/F+tAf/NGwR9S6e5WRrF/3oPea3KgL3V4/YVBnHyBi/ICiODPmDyaHREb/uLAIIPvnBLq6Oqlhy7xGa8f87dpP4kNt1Plk2b0VVosrULdiTVyQa91/pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Z3u5aBfK+eyAYz+x977l6SESiK+lwpY05ehV9powGQ=;
 b=phaLWY4GeVopa68gVWRP0+0OFSlduOrraa1f63b57pg+16vb25weXDb3+GtnGrn2SSgUNu985mJgF22+0rQl60HH1nVTtmsfyrNe97pUZnkbid9/tZ08JcIOfkQw+pRF9E2t6yxh9+txRp0uAnqdeES6XLak3gioOXkIJ9aj8NQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Tue, 14 Jun
 2022 14:46:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 14:46:27 +0000
Date:   Tue, 14 Jun 2022 17:46:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Zhen Chen <chenzhen126@huawei.com>
Cc:     syzbot <syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Subject: Re: [syzbot] WARNING: ODEBUG bug in route4_destroy
Message-ID: <20220614144602.GJ2146@kadam>
References: <000000000000a81af205cb2e2878@google.com>
 <0c0468ae-5fe3-a71f-c987-18475756caca@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c0468ae-5fe3-a71f-c987-18475756caca@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0005.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa1f2ee-aa3b-49b1-c4fa-08da4e14a911
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB57015E4D7C687D454E2C8C928EAA9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zWIki+rwrUAWlfGa4foQDVGCFWiJng21SC85Bwbd5I/JYxSWibrxvizxKdtQFWOs9/LEGhIeOeYRPxKlXrqp2KWsXmZtB0KAp7xC822W9Wa2e4kP1kvxeRowz118kwaCPo57kd/tVkgXozSUyPVy9rm/dzwGdaZJcGUnf84TD3ogQSKMNUkyVVAmQZsCn9ainivSZwzcSirE+xvFe2XshTlamunFiGZOfY2vRap0paRnL1eUuU9IAxkVpvkmyqhEMvPRZBdDMcm0USBLzVe4s/qvz8u1/rmBc2b8Mfr3vMzzqx+i1iOZMFwjAYYR4xR408LkMu25poGeoImTWyolO4WcaDndKmceUyVcBZVraCMNYNc0azm1AcAEExkv0vZVFl7JZVXtj1FPu0ZKES/w2435Lxq30CRgRaccVzvBxWDrLoH2uSYoBYUqzTLPn/gQtH56yN/zbt9rnNEmfsz2/dOLm4zjbA3LdrpABHxnlQpId8s45AMqFFQyZQWPoLeR/16ZjJYrrZhGz0szVIYacXtCXr+QBrHIKvjn4jApbxq5liZEJaDtdqMNjIWPqZQTnH49S+PH8KkDzm01y11m7CaA6s445XlmL3lvxu5rIYmiLjDIerJfS+bDuwSQb3JOFAp1SWcl+khIf71PZNrdY3bVS4TIt+JASVSqRrl72QV7megylkrFfFAUxJ/z8Ya7gk7Hq7fL6pA8MG0mT5rqU29EU7tUwnRPNVHfTws1+vmoNaV0SkvePgIbv9o1EBMcM9vpRCMnNZpan9ZRm8T5BDEKZwoUUukIFxuyjc4tzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(966005)(2906002)(38350700002)(38100700002)(4326008)(66476007)(5660300002)(83380400001)(6666004)(508600001)(66946007)(66556008)(44832011)(33716001)(6916009)(9686003)(316002)(8676002)(86362001)(6512007)(6486002)(6506007)(33656002)(52116002)(26005)(1076003)(186003)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zABqUpgDa7FleZhOo20/F0hADVuVXhE6xp96gGFN7ZBDM/d93XJWNKfE48Tj?=
 =?us-ascii?Q?q5dvHB5E/GIEnuRqtIoqggfL1czZpwBlB+5FqymLSpjJULeyf4eJndjtf3I1?=
 =?us-ascii?Q?RSXdIR6JXx5ZBJdj1+qe7n/pTaBcjCjsNQ317u6sTM9wRqfiet5ZG/7RfCSC?=
 =?us-ascii?Q?6l+vvMty1KaPBoMUERqaAMbHKzhCzu99+2yZBo7BZEJrljOxlazlliihFiF+?=
 =?us-ascii?Q?kYnKw3l+unreRGzfofr4aOJfu5UajgPeJxUZXNH1l1ReHiIM9syx2RC6NpiM?=
 =?us-ascii?Q?v+bU1S8XaHvFBkFYA/dA3ISjbobs5koKhmnVYn1rxg/wgyFMGb8OE4SGlPHe?=
 =?us-ascii?Q?XLbZfP69W0SXq/ji0tKpFABYa0KDZtuavw7zX3SdbeQ+uliUr2aGQabHkvcV?=
 =?us-ascii?Q?N5qtxK+yhDqqklNWLFj9dZ6z5La0CngNZ0t6Mra5bnrTV2KP9Ikgzi+oBLJx?=
 =?us-ascii?Q?4ToVcg6WvJTKqU2TYWOZ9thrYbMOeiqomPDurYQyyTv0Y7LIY1nPsmn96Dxw?=
 =?us-ascii?Q?1DaxuGKR40vG0Kf9dqRP6bVA4rb2yT7zcf23jyLcAKn/z8VqdfC8S5vERSR4?=
 =?us-ascii?Q?ViFvyREVSLnybRgriost/jtqIqtE95ch8nqkvkkoZfDG25rNkdNYiQUzfe7I?=
 =?us-ascii?Q?8qF+6gqO8xcrcHYVazwxIrG0f0WDRF5Fjllf9cVTHxlpTON4ISaUS74/Afb1?=
 =?us-ascii?Q?hEKE45Nb/GRgB2s3U8vcbenk8GizllcRlR/3NDlu4wvcr8gUjzo2zS5FmB6t?=
 =?us-ascii?Q?uFtKu0ycFS9EFQoXSxUsMyuKjWdVJ5hRmoCBRPNoclS9tPl3JZGTof40a1GX?=
 =?us-ascii?Q?lf9Pf+DlJ34XBIswlZmeABcDdHCdmaowT+0oFR7biIRTFoIo0e16RpUzH8Zl?=
 =?us-ascii?Q?DoU15mkiUtK+c2l2cvHVWvIzmwr0Q9Lr6cGbh3beLu5dRKcHb70TPS32JmTG?=
 =?us-ascii?Q?+mE6GZeWVMNeS+WAq//gwz5UkgQQeLwqGCGtGpV2WBP612xKVKpSJSDhtbne?=
 =?us-ascii?Q?1InJO8aImGKT7SPkQ9TARy4lTyMmM8r9TlhhdLupbJOF5P/cEPIZEUpA9o0W?=
 =?us-ascii?Q?1r1zluhiabYa1D5WjUfYFxnd1fCBwsowiDEINe+oX2qwOnmcfKMvdya86fNT?=
 =?us-ascii?Q?cjw6DWmyAbuLSxmGY6+tMHwOnubtrYMOsxgF9UPtbhPvsXZ2dol35YIw2aaK?=
 =?us-ascii?Q?Lw6+zuyTu9K8zp6NqnMNpDyRiqGw2Iw89BLwppqKodwtYrzw/c53OgsicNQU?=
 =?us-ascii?Q?zeSgVzAchuVzozyW9H1I9QOu+h59xuoWRK71k2uWzo2G8kQ7s5LMrUn4CTRQ?=
 =?us-ascii?Q?exb/KZJjFAwDCzOvHKRJB0IFY8wqjhJQZVPottHxy9buflIQuHKbnFgV4f07?=
 =?us-ascii?Q?9Les2T/VeY/iGVtqwLOMTeaxufzygtq+zkL6m7YOBh53/7Z99rOTW4OnAypL?=
 =?us-ascii?Q?HArbBBmH3YMiV25tpSMg2TPygAqw6kR/M7HArItcGhl5XTlApGLLqINAgaFJ?=
 =?us-ascii?Q?/yLFRSJ6Jgi48+zqwlHRe//CQeFpTX0B9o06gOpyjAcYQo1ePsRAN1u9CLrz?=
 =?us-ascii?Q?/ab30bKjsvcmVmMXgmjzlNCWJxX4Tk4tZ3kz1e5eJPCRz84BgvsRyRKVhFvY?=
 =?us-ascii?Q?ODFtnmndmSUItkudEVKpdlRlki0bfdWEfzkVwmp+wF6FDFHmiTj/Z/pQGc7f?=
 =?us-ascii?Q?FI51s5g7fT4sEinPk+nTq/9QRxlA+ocaTA1woeEqtbxuucsxe159u7OEh/o8?=
 =?us-ascii?Q?mAPYf0Vp9JS7pU4nEBOg7DxsFMXaQ4A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa1f2ee-aa3b-49b1-c4fa-08da4e14a911
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 14:46:27.1516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60q2Fwr5EqrmS/B5quBFrUpBRXzHIfk5xGa0H3qeuwiRvdai5EjkOy/QS8IaqlAv3TCXGwaSfovZvhXePqEnNUsvYvn3/ZlP4zb/lDfeZiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-14_05:2022-06-13,2022-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140058
X-Proofpoint-GUID: OdAU3QbrJdaDWmvtZ6s2rHLnt3eTvJ2U
X-Proofpoint-ORIG-GUID: OdAU3QbrJdaDWmvtZ6s2rHLnt3eTvJ2U
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 10:35:44PM +0800, 'Zhen Chen' via syzkaller-bugs wrote:
> 
> This looks like  route4_destroy is deleting the 'fold' which has been
> freed by tcf_queue_work in route4_change. It means 'fold' is still in
> the table.
> I have tested this patch on syzbot and it works well, but I am not
> sure whether it will introduce other issues...
> 
> diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
> index a35ab8c27866..758c21f9d628 100644
> --- a/net/sched/cls_route.c
> +++ b/net/sched/cls_route.c
> @@ -526,7 +526,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
>  	rcu_assign_pointer(f->next, f1);
>  	rcu_assign_pointer(*fp, f);
>  
> -	if (fold && fold->handle && f->handle != fold->handle) {
> +	if (fold && f->handle != fold->handle) {
                                 ^^^^^^^^^^^^
There is still a dereference here so your patch doesn't make sense. :/

regards,
dan carpenter

>  		th = to_hash(fold->handle);
>  		h = from_hash(fold->handle >> 16);
>  		b = rtnl_dereference(head->table[th]);
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0c0468ae-5fe3-a71f-c987-18475756caca%40huawei.com.
