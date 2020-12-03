Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A12CE02D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgLCUwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:52:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbgLCUwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:52:23 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B3KntQ6028301;
        Thu, 3 Dec 2020 12:51:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=doUSHIlqz24LJ/YBdoSw4f1bAqJPFXAwnOVAVLueu1s=;
 b=qwzPcLAKF/7/yIIDlZRtZWW7zeLCaDG85LtfVKYWBERQJAqXOgcreb2Txie/auroW42H
 YTO9s8Zdxj0jhs+Gm1Kik3eu4IWVTQ3pAHm4vmO8kAjzOQhxFjhBZPpQzdncUpUAr9Rc
 6WZm8fJRyetO5hvC9OZ9ol7s7w8Ezw3D7Rg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3576828j5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 12:51:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:51:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WffKTw/H7+KvNAXHPqO10G+wS3el6PEqbvJqGjvXftjCqxkOFNKbgIPC2Wbvoa3cAHXElC5NIhufnLjX52GAh5tByjSwEM5W4+iuAuLqidhycChfDF/7fyYIk3J3ImCTDe6GMV6KAzMwJBQwLNVAtF1WXa9CbJ8GwXNd2FjmXWou3/WLXIv4efuawkehAj0MJ21bhqIWauf7S+iwmWJz9V9w+xs1+opK3BPqM3zYC4OYeIX/PgGulrWuX2OIdOPU8vl36FnMT0+m9gIlSkQZVzzVOcnIs+lYhQusyjp5AL83SiubbgJzQNRCEZslPDGJ5e9iPnZ4DOT5FX80LpLJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doUSHIlqz24LJ/YBdoSw4f1bAqJPFXAwnOVAVLueu1s=;
 b=m5yJSQPuTwKMoHxRi9kdFKJiZVPrEmlcFxiSgEjpZxXRXloAhrX/IxFcDpKwlLR4zlBwpm6VRfrGXEHBYeGYJKqs9KUbxLVfGkBDIPNjcA+ImDqKFK9aKlnadcN1okCswD+l+fPZ+YLLwNZxfW+L05oCIlqZF8gYXb111YAf1lQeIv4AqP7tDNqj9NOOWD+3Chz0yQxKGL26CNXcPxG25clMMZFct/LP54lnGFGI+88wkKOjiDbW/i6lO+lQ90m8jYv6QcObn+8XwnNTYt+n+oMUskhbLoaVPz/19r18LHfRkninShouhx1PjHbht3DuPVFEt537vPluyznRXPsn2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doUSHIlqz24LJ/YBdoSw4f1bAqJPFXAwnOVAVLueu1s=;
 b=Me8BhdUyhxZZyzQnJY59ufT7zSm0vuZGNH/xDmFORuVqnH6azytToc+n2AO3dpE+BoRSD2eJDbjiFVTa/JdJpH7uKq+v1gnCB6EEsEeThZQf+SktYUMLaL33Qq83OFogNi4zajtfWHXU0nC+ZVeG7oB4PhtU9wmBVoMAfeLhkWw=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3255.namprd15.prod.outlook.com (2603:10b6:a03:107::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 20:51:16 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.020; Thu, 3 Dec 2020
 20:51:16 +0000
Date:   Thu, 3 Dec 2020 12:51:10 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Prankur gupta <prankgup@fb.com>
CC:     <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/2] Add support to set window_clamp from bpf
 setsockops
Message-ID: <20201203205110.kqfq2r2wtqongs5x@kafai-mbp.dhcp.thefacebook.com>
References: <20201202213152.435886-1-prankgup@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202213152.435886-1-prankgup@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:4ddc]
X-ClientProxiedBy: MWHPR19CA0057.namprd19.prod.outlook.com
 (2603:10b6:300:94::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4ddc) by MWHPR19CA0057.namprd19.prod.outlook.com (2603:10b6:300:94::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 20:51:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c24ad1c3-1c3f-470c-0c7c-08d897cd2d9f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3255F2BD87933121C96D49B5D5F20@BYAPR15MB3255.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6hYdWDlpRoKJAZDd/nWI1YI4XUAKvMGgNMGD7TGSR5y2tZw4EaTb9duv3Zcyeb6ZD8ud9Ooo5W32ZxD9Vwz/dBusAFt91F/7vK1COzvn+QRscBCkJT/0RqlYd8tUKE0jIXjNs+ohbhH9FSyvkT/oPMBxLD+ciLoD0fzNlwz4B6Vpf9kXbxhmj4OnLDVYgUOB5CM2kMe7JeiGO7IyCHWXeJ3GqBKsbhouHF+lWv5ojqEUdio2Z5hyBE7reAEpZAcXEFzZ6+db4RzVq8QNsKCC6KUCBK///oAH1p934+31lgw2xXl75tr9UF7O8ylddhcFiTeMOWGnq8pkxNy2zf/FFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(2906002)(6506007)(316002)(55016002)(8676002)(7696005)(9686003)(52116002)(478600001)(8936002)(6636002)(6666004)(4744005)(66556008)(66476007)(66946007)(5660300002)(1076003)(6862004)(16526019)(186003)(4326008)(450100002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FLXYq3M4ZwbHslybAMTdCm9Kzbouff0rMaG+pPyMlW8Yi2Kd9aBmn54nnAWK?=
 =?us-ascii?Q?GcPKljpuyzRuW2SYIaLVhYVX+AqKkKfnX4flmJA1LpLw/lLetHodiSb1HHJn?=
 =?us-ascii?Q?mj/+okb/reN7TCvU1hr741t1ZfexDo4aIo6ejOUXdz3ZWZkcbreM2vHov7Fs?=
 =?us-ascii?Q?uejmF6TvqsbZM5lyCDz4ROZSj3JS5A3MG8rxhC58NG/qREvGx1gr897Hjins?=
 =?us-ascii?Q?Dn73LpdYqYOvzeylZasuzv19MUVNtPOu+zYMZlqlx1x48DuKqzELK+gr/aC6?=
 =?us-ascii?Q?zQKFnk09Y+kw8KjcThlwleDiK5jLya3z6qWK20DMK9ZM5EMN7y5ysPpcgc+K?=
 =?us-ascii?Q?+bpyOisaa00HoNb9l0drAvI+dlNqIq4h1PaFq7wIDWntYwDqZ2p3hhftK8XZ?=
 =?us-ascii?Q?sWVpkxk0Kedu1cT8bmKaL7wSICjSKC23/9qsJ60TQmWY6m8F8VVTpmb0n6u0?=
 =?us-ascii?Q?MgYm+DPF0x6H/Qdlrx0fPiV8YLpWqkLbJaqlrfD9hXuqH4m/wVl+JLI8NqXs?=
 =?us-ascii?Q?fhEiPvO5EMNMSMe4yLS5sI3giZdtFPkieq3rTMhmy+PPtlJp6F1NfntlTYsD?=
 =?us-ascii?Q?rtYTlKy+q3kQe2YVL5yRl0PbM6Hqkn3TWyhd8ielvNXqb6RaBGF2tSbNLjoW?=
 =?us-ascii?Q?TUAKJbCHrAB/QLpRYCmI+joKOQFtBZUPwSk02Bm+7sKL8SNmCnSGrjMaauhl?=
 =?us-ascii?Q?alTUB+nkytzD91GodCZPFEt3uQFS0CqTkntzdWBEMJ+DSwDZBaGSb3RgZboT?=
 =?us-ascii?Q?x6TDEvK9fJHqRDOTy7uT633HnCHUd2L39tDSQAcVL2JvF3ARVgKLM9rB/lg+?=
 =?us-ascii?Q?FBLZhs7sxaKus/YmiLQWFgXbw35HhoLrW3ueKexOJBKrj66W4VGUV6Y6jvfF?=
 =?us-ascii?Q?v43fFPZx0NRCzGIMx8J6lPfGs3AN1NWO+yhoZ2D6LHFTqLehQxS2dBs9cwHB?=
 =?us-ascii?Q?RvW6SYx5/MnHhq1ysIOie5Ho1TeATsAOpbu9Uqig12Fn5YsCuA+vLGTYiIOc?=
 =?us-ascii?Q?xSHPJzV4H18vcksm++XxCHfKOw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c24ad1c3-1c3f-470c-0c7c-08d897cd2d9f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 20:51:16.4971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6g/gQxTUD3XoAxlNuN7cPnY7pAf/qsR/cv3M4YTpzQxlSsdGO8W9m+CBWRSVeJ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3255
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=999 suspectscore=1 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:31:50PM -0800, Prankur gupta wrote:
> This patch contains support to set tcp window_field field from bpf setsockops.
> 
> v2: Used TCP_WINDOW_CLAMP setsockopt logic for bpf_setsockopt (review comment addressed)
> 
> v3: Created a common function for duplicated code (review comment addressed)
> 
> v4: Removing logic to pass struct sock and struct tcp_sock together (review comment addressed)
nit.  A short line even for cover letter.

Acked-by: Martin KaFai Lau <kafai@fb.com>
