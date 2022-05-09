Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77E51FD2A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiEIMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiEIMtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:49:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4178D1FB540;
        Mon,  9 May 2022 05:45:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249AjuBI024470;
        Mon, 9 May 2022 12:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=oc4oCQXzY/2Mv6UbQ2zKcAG5jEiOjf0uCDHAf8bARis=;
 b=QDpZkN6k7Rg5D9wUHCgMslOvGI9ETDnTyjoFrjwefVAqIu82pZL5FMtaDOPvoICJ0q/x
 bg5bqvBW74mxkvIJKAi2Z2MnPuSdhzmNzhvSS29fDkHmTrAdXAjoa9GwpPrI75c6Ekiu
 dLf87RfspNECLT3Rb4hsoJLVsUrY/LKcl7pgGnieS6tSxdHtggYPho8QuZYpI7thuVqp
 gbCEIWIOnfxLpNw80xSnw4QAQxwfhsMr7g3eIQE2xcbukg+tl5jxChYKVWUzXXWLvS+d
 FRuwnWZ0BxIhlNFRAXAlunEXbiT7ASzmkvHBpOYaMBoDaeI9OicGH31+5ApQ7yFXjJWF SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0k8y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 May 2022 12:44:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 249Catif002144;
        Mon, 9 May 2022 12:44:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf7823mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 May 2022 12:44:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/A9cvi7Cg1csoDSVeR9Yt6he/RDDaFMZIlUWuh+C1WEOQfATHbMRnI6dSJz/b/QRC9Ii6/GRtGB3SgIG1yEwnYO899RM467FXB8AAlwtv/9oiITKmeQ+YPlXsnbBIkSGdDziNsLnp/TaYA5GaRs+M2TDFBuR3hdH4mXkGnX2HXYrJLOEZ3hqz5EplZ/mqAW5noC+JmpMJ7ktWoEo3Ii4Cr3ZjAl0egbbXO1cq2H4ZyMjmSW6yWdg2EUFK8spw7NIvebJJRzxCSfUBUig1si8/6o1Fx/xqbfBHIqwc9MTR/btjU6OP6huRSOPlNY3SHsirOT23ruiGKugFFulRnSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc4oCQXzY/2Mv6UbQ2zKcAG5jEiOjf0uCDHAf8bARis=;
 b=LRdgNcEq0k28pJYFYKceJT2WvnJeRwHCVxoMUMpbw009pJVj696m3Eq+WKb8KAJ30Yeqg1GnAO7aPGcHsTbmfRyj2I515eE9+GI9bGHdwivB4I3DWg68yJtPO4q7KQ+pjY1gRwBhKR+ebKGymOfOxiX9seQXNBZewbNkQgAzNNUfLDH7cR6szzKi/xJS7yNJZ+mQ+XvXm376/ovuJHJO6yFDUr0oumyz2cb703fLLs/K45+IeJAvvRNnyxgjgNko7n5a3RltGDHRcugDxwccKZ/Nev/lF6DayDg9wHqR7Ye0JQcdwgvRvxVwTCqft65UYupGTTHzrKwmspvdJvMMmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc4oCQXzY/2Mv6UbQ2zKcAG5jEiOjf0uCDHAf8bARis=;
 b=rSJvLdGXXpTx5/OldoYS2z4QCZXTtrcM5+pOHdAKXpdmIf649sBSiHRj2Kwp1xkVoeUOXRwCrxwGoR/1h023IyqC4fyCbBxZeYEXEuFtmLV+jSi43NpiE0YC+YH6FOUutFQQC0+cQK/rjCgiGR+bZlz5d0/86a9Q4udwGEbyZQA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN6PR10MB2526.namprd10.prod.outlook.com
 (2603:10b6:805:40::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 12:44:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 12:44:44 +0000
Date:   Mon, 9 May 2022 15:44:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ozgur <ozgurk@ieee.org>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x25: remove redundant pointer dev
Message-ID: <20220509124427.GG4009@kadam>
References: <20220508214500.60446-1-colin.i.king@gmail.com>
 <CAADfD8wApw_v+uDTijY1K89WRJ_f7tkHmz=6LR086yMjEU4mWQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADfD8wApw_v+uDTijY1K89WRJ_f7tkHmz=6LR086yMjEU4mWQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0103.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b426c073-50a5-449e-8c73-08da31b9b131
X-MS-TrafficTypeDiagnostic: SN6PR10MB2526:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2526CEED8D665B2E39C363388EC69@SN6PR10MB2526.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWBwniF1K8Ln1J5coOH6Cd7KwgWuBR7ABjAV3EXLCHJSPPLNQ64PR+dTtEZaYo4mRHjSx3XjDp2jjk5N6KHi8Vpg1twxhdAn7r3NWByTxLI5V9AUOba2NYHqghkgIzpoeZ45MLLXJRFzKKbITAFPwC2oNGyCMx45KULaPOLgoqcJ23b4lBJeNE3FuReCWr97LC0VpNDKx3uP/Ygi3kyW6RdMcypX7kwl2bzLcmlW7C7n1Bu0hzxx5kwmWL9EiKy4SrizJxKz78lvFE/gnSDJIUzp5Az8mkO6Sai70x7piAf6xqoKdm8xKDknAnG+eogfUNbV8vnn7uqb6ZI9btQkANdcX8X3wrvs2hbBSEMHUVEPJ+0m9BuHRs774S/zVHw8e7lStbpeQZVBXJKYbHUOJ4nvGwE3gGJEqGcLzA/B79g/Ie8zNddIzwpLN7N4KhY9K4opsuFfsF6YmPAJZPoHtT9wogi5XGfVqXPMvbs9ITRvWw63OdXnPzI0PawDDFQHomVfPiXtPPFfViPk/m79LniJZwx/NTx85ZH2vKlj34IWsC5Qvr3tU2lTNa7+qHYbRdFjKcCS9bINX+GoqZ2qtQDL0FPceXwNYM6idWRnlmSnNUAmmZED1RLlPf8pQLVDBDhSH3h3u+15/VuBzejix0LIFd7QLHN9ru+8/sKUUIGxbIzJezdYgCpzH7OhEa7TjrnCIrBnm6FJ3w7jfj6rbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(33656002)(5660300002)(7416002)(1076003)(44832011)(66556008)(2906002)(66946007)(66476007)(4326008)(8676002)(316002)(8936002)(86362001)(6486002)(6916009)(186003)(508600001)(6512007)(9686003)(26005)(6666004)(6506007)(52116002)(53546011)(33716001)(54906003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dFuJnoDBlbM6zQ0obIS0k57Cl2lNeB/NgEiD9lr07RmRBNtFVm8BU9d5+Poh?=
 =?us-ascii?Q?Je3oCBn5Hi1WmiHQpbdJV4KO6txjoZF06U66WHHxG/W+3oDYCwG49Ut/jzji?=
 =?us-ascii?Q?KCGK0acBrpQDZreqEsXgPXnhv59IFwkbBTB17yxUB3E4ot+5q+aQ3jTSgilG?=
 =?us-ascii?Q?7fOBw9pGKLROiFIv+hIYCWXVrgWJMNNEWDbstzBqcCpLCwAuE7nopV7D2rBh?=
 =?us-ascii?Q?Cl9IRXvQVb6nvi+eWVlq3GSFYs8JpjPAZ5FuwXuM+1xvVAsFH4QMA5CBL0P0?=
 =?us-ascii?Q?nVsDdUkUvFrTa1Wt3K6+IOoU4W8+L4ZNxu52/9286wdKi14XcrK6C2IOz6Pe?=
 =?us-ascii?Q?sxL5+2Is3u5dzLKYCvPtJv7EpT1vMLytQttLfWmr83p7OeRlaYfMWqcsRLNM?=
 =?us-ascii?Q?umK4w5H7PhvsE3I4zHdrMvex3N567sDpPB7uL3GyNv6gPWbfXijlt6h1YgWP?=
 =?us-ascii?Q?rhg7TeoGQXjlz0RLV/FWHOBsyPC514pFMimGBpVaf9VdQspTVE7ji6IouPu4?=
 =?us-ascii?Q?QSvkUCpUS4kTgOa1kbe+Au1if9PvMfMANpEZj1XgvjbyfjEPZPZ9XqO9GAQx?=
 =?us-ascii?Q?2c9g/1pBRYZDS1JghlArTRCzFPWiPovqdefBa1reABovCEC1dR9D6sC6kBbM?=
 =?us-ascii?Q?FSXzhpXmIk54R0dOVQCYH/iAFgzYn/zuDta/zBLGhwR6IDTBCokNU3SxfpTt?=
 =?us-ascii?Q?GSdEEGu5gGfXmIJxJSHvmr4dAg4DFWGKnzJHFDz+uq95Kt50Z8l+5rOSAbYP?=
 =?us-ascii?Q?82j1KzMkv065eztKSdDMnSpsTb9rOLxwr9LAMdhAJp9Teyrr/rKvy7vP0bNb?=
 =?us-ascii?Q?UumJASjhSb7T7CtxcN0dG0TdagfufZ2bTU+5o3OeT4DIazdrb0HpZwXrJd1e?=
 =?us-ascii?Q?+bHgCG3Ua4RlPX9xRXL94ABq3JBmCGpyGChWE81MKdLGLbTBETcSixYab82a?=
 =?us-ascii?Q?jYT4IsFTpIMCidXeAbujZA7NODc2tuTGnclALVvilwzLBmhsQezv53hhpBCE?=
 =?us-ascii?Q?+I5vMUltJVdE+4nSFMKltwZIiVMGjCuwOnH4bGwIcBMZSQwFGEFgV7KR79+5?=
 =?us-ascii?Q?x7HpBMivgT2FxxbiJhGP0Mh5iewrenwTBW48Yj+b9beJgROLa1B8lthXlKrc?=
 =?us-ascii?Q?7JAz+pdYGoWsBvNQWn/J77anxPUiLl1/KJTh3WcAfkAJdJ/yhzJ4hoyHChVb?=
 =?us-ascii?Q?gTFC0ltgPiyfhxzFEyLjkGp5EMb+vNj6eamjmbxgu/7T17N+gNDt2UAkaQQM?=
 =?us-ascii?Q?vuHqoBE3FoxZsfKB5xQdTzU7YX53WsIyLv8BZXq4ftvKBRFiVUnYNF7dtCTa?=
 =?us-ascii?Q?r2QYQSTdYxcco9DB1Skpro3x7rj7yDSXrA0j9K5uMqV/j+oqh4OdLBOfwDeC?=
 =?us-ascii?Q?qOvWXW++dpGZXYM+YYKACed7r45ikBq30eoA57M1ouiQmjAqn+yK7CHIDJ7c?=
 =?us-ascii?Q?4pFVo45jt6ZP2KyGpFTQsM21HEKGIssq6TwVEVqx29pO4DBSOltu0Gn6RQgn?=
 =?us-ascii?Q?+cgXgzHOSJBJijA+DhlgAAyMJ1rt4/QnwnzHYvV947lXwaPcBtWsWw9U5Noy?=
 =?us-ascii?Q?H/R+njVFuoj6SsYkxWjas8yTU+6qswERJiIJAvVfVLjUGFdXtOeCVS1CVzAd?=
 =?us-ascii?Q?e12sJjIkBn137/27T4WqCzdbtlGAjHbjYnScGGirpAsXlPjnGHhZWK+ny5oh?=
 =?us-ascii?Q?23C5BJlI9HCjNk9H3NZB2TJ16W3YMzowcxo0n7CoWD3LXfxtUmRTQFzZxecm?=
 =?us-ascii?Q?/ino4ubQRogXe5zhMiV8FIBDa5E4CzE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b426c073-50a5-449e-8c73-08da31b9b131
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 12:44:44.2402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cc4ZuZ3+JR+FqDyhWr1vFqHGA1NMVP0xNjCP9E4s/eWzgzWaaSnESLK1LC/QLS+pb181IopJA5vyZZDUplBlSU+DhX7WihcMln/+DhAVu3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2526
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-09_03:2022-05-09,2022-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090071
X-Proofpoint-ORIG-GUID: cJJGshmzwhQbYfIaf2ZfMBaGRRTC7NxB
X-Proofpoint-GUID: cJJGshmzwhQbYfIaf2ZfMBaGRRTC7NxB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 04:57:40AM +0400, Ozgur wrote:
> On Mon, May 9, 2022 at 1:45 AM Colin Ian King <colin.i.king@gmail.com> wrote:
> >
> > Pointer dev is being assigned a value that is never used, the assignment
> > and the variable are redundant and can be removed. Also replace null check
> > with the preferred !ptr idiom.
> >
> 
> Hello,
> 
> *dev pointer is device assign global linked list and shouldnt be
> touched by the driver so *dev wont get any value right?

Why are you talking about "*dev" instead of "dev"?

> Also seems to use this while network interface is initializing because
> some activation information and stats information is also kept here,
> for example, open *dev will call when ifconfig is called from.
> 
> route, link, forward these inital activate and move all values with
> net_device *dev?

It's not clear what you are saying...

When I review these kinds of patches I ask:
1) Does Colin's patch change run time behavior?  Obviosly not.
2) Is the current code buggy?  Sometimes when there is a static checker
   warning it indicates a typo in the code.  I do not see a bug in the
   original code before Colin's patch.
3) What was the author's original intent?  This code predates git but
   I think the "dev" was just a going to be a shorter name to type than
   "x25->neighbour->dev".

I honestly have no idea what you are saying.  At first I thought you
might be saying that this is stub code.  But that seems wrong.  Also we
do not allow stub code in the kernel.

regards,
dan carpenter

