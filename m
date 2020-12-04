Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549202CE53B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLDBmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:42:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgLDBmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:42:09 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B41f67R026167;
        Thu, 3 Dec 2020 17:41:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=m5PU1r70KIzMmdM+6iZQfopJ7c8bAeQXyRfy9HYs5+k=;
 b=lPGUDq0i75pexlNON0YGZPOL6BuTDmnqrO1Adj2GmXppWJqlcYm2PR2si+1TX5Hu1fIu
 TcGZOY7G6FLNRpaIaLYliHj0MWpnFE0Cwrjq2EdFOOv+9Shls3s42NKaV7/w8Wixfuh8
 6XF7O4bwGSjeixI/2LzBtzxWzFJH2CKUxbA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfkja7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 17:41:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 17:39:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcBcZV4Q3YvRuslYa6YlcsuHcPj1rTVg9y0NEUVVgQYJoymKGCJx4Kjc9NjO1cYcTGpaUDyJX4EGY6yf+3/4KwWkJWthxhud+F4/C1BlCEJKABBspUG1/DXbQqPOGaw0hwkPGsHA80TLTBNxjTIhYfmUGRgyBwWrgahw20luALdOY/egusJaP76FFsNKHCt0YIprd1R2b9YUBUG456hwIhudz4xhwjFJ+W6m9q46fcmfcBBxqICaN84pkD8q56tVEjzeVI4snHRewKM6r1psWGqyh40WOJwjZ9IVQVRw6ZEY96tQJ9EkiMg4POpbPfoQiLqleIF0o5pgS9SXZnb0lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5PU1r70KIzMmdM+6iZQfopJ7c8bAeQXyRfy9HYs5+k=;
 b=KQ6qr71ykv8htazcyb65kxux31buKBCLpX1mzo1dmxLRah5zL9n0H8lQtIE/MwrcMsiUyPBzlmD4Mv+YF+dViyryngq63p6skYSPWRPQ5RCMGf7zatSnCL2REGyY2Eq3qlNjKLE2eDWibursP8cbw9SAhtERL8vlnAQ4C+IC7qriH+7mO5nq2zZ16jcsvM4k4mtuYUHG3DPvUsToB/dRM00TFWtY8TzkRKzZXFh6s03ri14kpkvqwiTKXXgH4ZmetoB8PvqyS+cqzM36h8GfhWE/gkTI+OoTXWJPq1xciQCVLHa7c68GfMwR/J6aZwpRIu2yGClrLScBBnAVDR8k3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5PU1r70KIzMmdM+6iZQfopJ7c8bAeQXyRfy9HYs5+k=;
 b=YjRJpLXJuZvB38quxQ1hdAbD8CumW9s3o4ezG0OTSJBoCwvH/34NIvKYX5Y8faiqErwwYtB9gU/YY1C8CMk8ii7l7p2772lHKalBo0ruW8ID40tYz6RQMSGr2civ5YvkobGXTA7iCOdU4KUbGgzp5yYN92M1W1395GevUhHNO8I=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3302.namprd15.prod.outlook.com (2603:10b6:a03:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 01:39:29 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 01:39:29 +0000
Date:   Thu, 3 Dec 2020 17:39:22 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florent Revest <revest@chromium.org>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 5/6] bpf: Add an iterator selftest for
 bpf_sk_storage_get
Message-ID: <20201204013917.32ctfr2jcy5lr5md@kafai-mbp.dhcp.thefacebook.com>
References: <20201202205527.984965-1-revest@google.com>
 <20201202205527.984965-5-revest@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202205527.984965-5-revest@google.com>
X-Originating-IP: [2620:10d:c090:400::5:4ddc]
X-ClientProxiedBy: MWHPR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:300:116::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4ddc) by MWHPR07CA0016.namprd07.prod.outlook.com (2603:10b6:300:116::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 01:39:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e1f21c0-f6bf-4a6f-5fc3-08d897f570d5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33024292331F007D4FE0F0EDD5F10@BYAPR15MB3302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0LQpqeQCOBrHBoqYy7uaxs6zgBRixB0ClOkXEkoGsDEPwiD9MhbDZGKgvbbFgnqJovDsQgeXIK6HIPFVegy64Rzc/wXw91gm6jUjzHcx2Lv5tYRp18H61P0m1eN+31wQWjrshWt59dcGWipwt4br1FTzjikWpAIytzurClYEDpNucEZRZQ7fR70+WFp2dyzLHyDk7seQp+/15Lhv5BiqISpEC6DMAqG8pYp/CGp3qkZJKlxObhYpV5xbfxTXE46YCgK6tctcE3WulFjQl5nue2vOLYuzTKgbxuHaSdZmVbUKIAnRYzbFdkgPhc5GJtHUeVh1UviWNCoyCAususKQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(86362001)(316002)(7416002)(6666004)(1076003)(478600001)(66556008)(66476007)(4744005)(66946007)(5660300002)(6506007)(52116002)(7696005)(4326008)(8936002)(186003)(2906002)(9686003)(16526019)(55016002)(8676002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ODeF8fPNN3fDqmtFhJud1aFb/cyTMz05Bpsz0TtAlp+kkDwEZOpe5yxlSGv7?=
 =?us-ascii?Q?GL0MJM4xM9aVjk79AHuKkjBBrO5ptC0FeK/9a2gaosEaUbJAU7SEvK8tHR6Z?=
 =?us-ascii?Q?GWlnk4r6o5oAz5/gJYVwYFQV2BqsQUEGrwAtRKB7EXmmUR+UHehQSapFx2sT?=
 =?us-ascii?Q?QNdPYP1y1HKn1hLflzh/62tJi82glvHg2Aro4cpxJWcAVurhtaLzYHPNrJI5?=
 =?us-ascii?Q?FomEVbw5YcFINUwjVBOGPZnP1gxL7Chp29ZlV3g/9+iNG0Y6NBWyhPNoVV51?=
 =?us-ascii?Q?l8aww6sGEVEM9Ony0NOTVgbj2JzHnab4lQ/9o2xgmQOxwfvx+jR6vwok84mz?=
 =?us-ascii?Q?KGD2Si9wP6b25kq0SarXjxLYmVJtOcHjQOpxJO8dsIVvyTURewtkOly9slxr?=
 =?us-ascii?Q?MyPci/r38FITpHENNujqCWHLc6QOyKMX5CH+aO5GJWno2GtX+NS0PiDfPcDk?=
 =?us-ascii?Q?5LWtjAbyo2dud/XI1nVAHPQGNBTP/upJrdKzCUdjcbhIz2VewGZVyGhaa+jl?=
 =?us-ascii?Q?cNwtRyoxy0n4evoESVNRtBQZapFMDahjQsC602qBZlIR4xu+jlKDLCy+a/ke?=
 =?us-ascii?Q?AoJ8xQKMXoppF0j/ZgfapyyihWYOgj06xkLmbMBnvjh126L9iEI54U2sUw/7?=
 =?us-ascii?Q?wy4RQIgfCya+blssZmSMIYO0faYplJaA+lkBslblTVH1ZME5D//h1DMrefs9?=
 =?us-ascii?Q?OCPLpgfar2YkjGIdMDtbUzkin/6JyJ0lR6sQY9DyL2/DPQEeoMp7AYLDtxoz?=
 =?us-ascii?Q?afRTvhkbH1+6p5mTsKe4npD+b2brYP7KEJVRX+XpVz970T43kpSZca7z1e1w?=
 =?us-ascii?Q?+lwvAeddXYGA2o4oMtJkKXeoczPAt/+NLSyBPuA2/HW5JecMl9guhCtg2MeA?=
 =?us-ascii?Q?viQMZcNjfoc6mUbxYVrIkpDlkz6U9nVpsctRK/fmMQx0hR948T9WauywIDoF?=
 =?us-ascii?Q?H/vo3wffpxMzzZ9+bV6L54guGBWTZwDE7+r0/HDDq+eI521LTBFet+ioJNYk?=
 =?us-ascii?Q?dKLCIWnrPT6kFugFGKdrTSSoXw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1f21c0-f6bf-4a6f-5fc3-08d897f570d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 01:39:29.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvdIk846Lg0O187uocYpmIxAwjk0xfZ/TFEEykN7GSQmxTaWj19+smUQcOO07Eac
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=786 malwarescore=0 spamscore=0 suspectscore=1 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 09:55:26PM +0100, Florent Revest wrote:
> The eBPF program iterates over all files and tasks. For all socket
> files, it stores the tgid of the last task it encountered with a handle
> to that socket. This is a heuristic for finding the "owner" of a socket
> similar to what's done by lsof, ss, netstat or fuser. Potentially, this
> information could be used from a cgroup_skb/*gress hook to try to
> associate network traffic with processes.
> 
> The test makes sure that a socket it created is tagged with prog_tests's
> pid.
Acked-by: Martin KaFai Lau <kafai@fb.com>
