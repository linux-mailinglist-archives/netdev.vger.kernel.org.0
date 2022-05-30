Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931685376C6
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiE3IWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiE3IVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:21:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A122C264E;
        Mon, 30 May 2022 01:21:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U7tgiJ032624;
        Mon, 30 May 2022 08:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=8W/Qr7GW+a5noC4Ymc+o5KHLvWFwOSj/ipiDYV1VxbQ=;
 b=RwBo4mv5bkT/jBO11H1WjHUFKof/vzWlPXV1IKaDAooKJipCO7oVvlqAiuT1jdEcP+Z+
 Aa4OtCkzYxUO8R/QKtodj7GTrQygqgKWleejSrC3AkInU5wTq+b6723QoiIe9HNBABQl
 OUop+E7y67++78LBXzlyu4n4Qyu1qo71KPZ+PMGNo0PN+ZLE/DbzkxXiBUwUKY67YM+E
 /yYPqGCjBeN1fSFTXW2rJJWf3EXSksRFwjbaa2sZHfAvNR7Ip+xfK7/L+MjM26yAP4sX
 uS+Ulxa0a5ZYwlDsrjgW0C1mmFaF+T1C4kHbwkcy+NbWG/80JBmJ8kTbp30Pjl+UQIon 7A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcahjd26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 08:20:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24U8BMKB011450;
        Mon, 30 May 2022 08:20:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8jvysmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 08:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ahq19epU6OmrPSMXqyTKI26gWsp6q5daGQfI4qLqZWafF59XeCVELLAEKtE8zD+k7GlSrQwWEgWd2hnwHfugFkyaz3SMVNuE9ofaoPdof4e/EC/3C/uCFkeOacgaj8IWw/30Fu+FkprQsj0YujyED074dggHd0YQVhkrx4o+Io/9KPxp3OBUfszgYOoKR0gDAdsvaOchT2xecnfFTx9hdtZECeXz9FFIJ8DLq71QSUeepWYmoKmVJFO9MAgFkQrgdJv9ujGdZp/pCu7OSbdkXBWmKY8eqmpYYl31Dky8nPmYM1bQyY/AN1rnpZDDmNbkDkHvpkqPHrZdBI04UxYeDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W/Qr7GW+a5noC4Ymc+o5KHLvWFwOSj/ipiDYV1VxbQ=;
 b=EDVCJF17YGDBcSVLkt91TSQrOjzMmWHtpn7zsAa5jL7iUVWJL4GF/tI6wRXbTRlY7YGd+71Cx4d0yVnPh155wK3sGcjy6OtQonGbAwyqsTfc69r1QuilyPCt6VbddaVPY4KnDPVEstF8F4OAveMt4dVbWN2YVM0dyxWMnhNQfnW+MhXJyFrSIUlA6dY7PHmJ8/bmR4zJaLyd7mFTUXcqwoF47YfkM8/EzkcL92/9nzrnsRi+sxeNdtAgjhLN3RDtyxNBNBhyrfo7heOsV+DjQJ/2uCvNcSuUHobdzZXnCFBkxUKitWIH8iIOOanJwxsPxhZJP2gttoJt7H8mIEc+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W/Qr7GW+a5noC4Ymc+o5KHLvWFwOSj/ipiDYV1VxbQ=;
 b=sAKXPZ8gb0n7Ym2OVkEkZEO93iX+IZvCLZ1ix9qVTFQ7QpPRWgnOFAAENWKIzn4RIPhzc1ZCIparSqxHjOYPEgev1ciitMIuuBfs1c6IfEetXs23gkNBsZeya6X/IGu7qlewcPLgWQhyh2WnOpONk9TblG0apUO8ICMucta2qIY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4404.namprd10.prod.outlook.com
 (2603:10b6:303:90::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 08:20:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 08:20:53 +0000
Date:   Mon, 30 May 2022 11:20:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] fix a common error of while loop condition in error
 path
Message-ID: <20220530082034.GN2146@kadam>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::15)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be4967f9-59bd-48f9-e1c8-08da42155056
X-MS-TrafficTypeDiagnostic: CO1PR10MB4404:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4404B2C276DB6CF65084F8CD8EDD9@CO1PR10MB4404.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVkcQLK5Z0qUg2W9QghhczkPkwcH9T0ZvHwupks5+Gg7aRb9vSCecDpnxprUrGa+xoL2PuXJGKNMAAWVs/j+8qtziyotx5Mnj/Y5bfYdfsRJ4zYnxqZM6hY4cWjziWSzRiTReecfQfSkfSvzjp4yfflVJrQelZ5yausWqhAbaDxqOpkf7AI7uYnG2qNdENvPkSweFausdyJMw/xuaxjhHnAJ6Bb4QQhgTZ45xSEN0Cpc9ecEjUSQDmq3sH3RG/TTBWHtn4Cq/UzQSPw7E2HA40Y6KPah7BB5XaUXmF40MYFsbpLntrBqlKjW0aWyt6p/89eTE27bmOQD8awfLN0eqJ4rqS72sIlGBvAuudd7aF2f1MeAWHL6wE66/b6uAEbzZzq907RNcIwlsDr3cUjJEH8pqZC8w09RrsDxkIP91Y67H3kwgBvPWHCQBrJbcwrMJ8NJjWfo4s9HdXrvfntSgNuM98pVkdtSw+r7v2wbA6XH2oco2UZvmFFhd42TzOU7oTzazKE4LHQHCARI1KK0uyAwYHdNXiCGMua4hrtOTR+DrxJscNh1gbpvYZT/irZS8696aAzgnN4PlG2IBlqFTc4znVK2k8iBY4i8zWIR+1TmDOjeYZ8fTEg/tL5hFF9Zyk22jFh5pkwUyVKpTrLCW2FivNARyJAmK2BFmjagapkeslIN4Ce1tRULr0UsO3HP+Ev2QM+K0blSGqwoYkaArQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(2906002)(86362001)(186003)(1076003)(26005)(4744005)(38350700002)(5660300002)(38100700002)(316002)(33656002)(44832011)(6512007)(8936002)(4326008)(8676002)(33716001)(66476007)(66556008)(508600001)(66946007)(6666004)(6486002)(6916009)(52116002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W0DneNdmu1ae6Vo+eh2nYbGh5qZLGrMsRpkxod2fulVvoKF3CwIzvY3sNRr2?=
 =?us-ascii?Q?jlNDKjsmlcMSsxJG1mfi7qZUO3PxAOiP5DPwy3jyQ4EuZKoWFES/a8djPZLE?=
 =?us-ascii?Q?EzWI+oKyodyQZgLOYxhRblbLl1sj267siBzkuZYvyW3YV1wDGEIio3RNEGL5?=
 =?us-ascii?Q?lP29sjhytyPBjb4SSsqis8VPR+04dnxxknFstq39lWI2Y5Ctr29gWAgm37Sg?=
 =?us-ascii?Q?ghDo43FteT/ATA1rZ8UC2ph4/b+DOf2hZ9lM6dcktth28rW8FvI6XQ85emSL?=
 =?us-ascii?Q?Mdth1Q01qKSTkHzkjHVogaFbapW85ahWPRQisTM0IkjUhFR7l4DUksaQZckg?=
 =?us-ascii?Q?m8UZvv0NztztTxXsubf2CGASPQtKFY+rYkhmpp3QJv2VLUY8RjPhwyJGFLQD?=
 =?us-ascii?Q?QEh2XfgV2hbdQvelp5hiqTu2mKrtqxZFc0o8j6lZDph7yMqQm/dFwSXUE2ID?=
 =?us-ascii?Q?6d04pCm1l+/jzMBAPYq9vUYwb/kHO5/OI606r06bClxTxmqT5DGZKQPxzZmK?=
 =?us-ascii?Q?VfcvJpTh5Mdvx6nKmUJMcAshr3zMlTysGYYy/rXt+iHMEwg9Ky81Q5ZiCq0W?=
 =?us-ascii?Q?Y7vXkqPK1VdaxNWy3qWfTeFBZ9Bk60y3yVjvWP0caIoekdTFjH+kAj5BDXyL?=
 =?us-ascii?Q?NN+cBehYR/bQ3xDPqIeT3b+UsYv7JicDOdzyOJeyYZAcCbwxSt4CcrVr4CrL?=
 =?us-ascii?Q?uYag5fcqMU54yAiZpU97aWHy4zjVUdpOSlGErvmPgiX+BYSjyE3gj0QlhA/o?=
 =?us-ascii?Q?UNBiXFNPSVgAnAe7Hllt3Pbz62j8WaW8aze7CBrYUE00/Hl6jjXcKxVZoZOf?=
 =?us-ascii?Q?ptHOgvlYYXtcYeKFfhJM57JYN/7YaXLORmxjUXKq/vMUDSt51X+DOvrtNYox?=
 =?us-ascii?Q?/4GRPEeI0cTzKTHB0k/CUnMXV9RTbAwpq1pySvCAe+MqykLtbcYgv/rKBh9Q?=
 =?us-ascii?Q?JpAZWjDqwboRn8dvePZ8SoyXVLaQCtGp4r0a8HK4Rgt7ICGbPQKMqJlM2LfK?=
 =?us-ascii?Q?kEF+hzy5t94Kbwv2bHXzYCOiSDMVnDvys0DC4hGl8thkMYyoUoxVExHq6o37?=
 =?us-ascii?Q?y80qWke+61aERKZuZLvZoPVSMoB3NOkJ5ETMiuLTay7CwcNUqr4JuwPViXG9?=
 =?us-ascii?Q?999svY0HRQ/BSrzFMB/ht11pLhMBpRrmDAYceaXZUZ+jCtyC1bHVIGie/yiY?=
 =?us-ascii?Q?HM63rxYufjICo9DEQ2DPZW8c5dkyN9usD1dGRih4ttqlF2JB2m21kJUMBPWQ?=
 =?us-ascii?Q?Q/zD2FypXA0WPCx14Wk9/j2w9tCdHxNLOg9PlruJb6bM/XDF8ZRNTwsvTRQ1?=
 =?us-ascii?Q?fmNof4fZ3OJlVnWUrUnFXqxAdCln0EPMToQFJsdpze2zhJHTHdTSyYrllXqu?=
 =?us-ascii?Q?HUSn35xPVc0D1r+snXjlYdWZk/nST8czstD6yaP0M3Kw2pJgmgm0FW0bcJgw?=
 =?us-ascii?Q?Dy6ERrqr9s2XGbgzwo5CmW05ueEHcipTiiKN7rSd5ZT1CIsGth3CFOnlcTDX?=
 =?us-ascii?Q?VE52CF4IEa3rdYAM5LhE6BrDU4YNc22sJQN4yWrGdbtI2/VKtMR997qseBPk?=
 =?us-ascii?Q?+X08IHK40yw0IrtnLA8xC5QQbRoRQs1t3dcRchpqNVu6LjZ/sQs/NyI8HNO/?=
 =?us-ascii?Q?MfIHwD2zSdPt2IL1FyvBaE9y0+PWg9tlnvMHPG/9hiEPU9H19YvdOAJjy+CP?=
 =?us-ascii?Q?XllP8hHoE7cWIdn4V22vXyDmYn1+Qpvt6E9z3m43NyVpKPqPuwARi1MjpcH5?=
 =?us-ascii?Q?k4wzOYK0ciQuUlfxS6qlKeojuNUfSSo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be4967f9-59bd-48f9-e1c8-08da42155056
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 08:20:53.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nZe/IiG0f1I2UhhfQ0dKiwx1OuXLRE0oEmKm3yHHIgzCD+zWONFYQeo4Z8geE726a2sP//LE292D22li4Gv2rRwZI6OeAdZA9bpYZxIPsKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4404
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_02:2022-05-27,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=939 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300043
X-Proofpoint-ORIG-GUID: vvcZqiDtZAHMnPQOVgOu699pf8QYdcJC
X-Proofpoint-GUID: vvcZqiDtZAHMnPQOVgOu699pf8QYdcJC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 29, 2022 at 11:34:50PM +0800, Chengguang Xu wrote:
> There is a common error of while loop condition which misses
> the case '(--i) == 0' in error path. This patch series just
> tries to fix it in several driver's code.
> 
> Note: I'm not specialist of specific drivers so just compile tested
> for the fixes.

These are all correct.  Thank you.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


