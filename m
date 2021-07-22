Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03153D2EAC
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 23:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhGVUVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:21:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230455AbhGVUVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 16:21:33 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MKvhQc011952;
        Thu, 22 Jul 2021 14:01:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2Cvh5hRRL0xvPMX/+M+/eKcXifJ0dyjIXKLRmCKBnuo=;
 b=TtedLKXLfTjPKRtAuTPeeAN0VPxFZHxrOOIPNYUrBCbj4NLyqpjuAwHibsavIdEMw76X
 IgUD9JvmVjFwpzgC++BwLmuSqM+FdZTdrsHrFYFd2igdPCEgsU+C8TwygYslpbgqFeln
 qKU71F4xGQ8siO1oQViBPv/TXWN8YX13WvE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39y9af32ek-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Jul 2021 14:01:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 14:01:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKcBeIqAl2chNXdK9j/PNm6LB/jqCgpzM0sTNUPD8GnDhCI/m6jO6NKy1fLbWaYRSMUJ3IezjOhreIl/uJ0QQcX5diglkqAChqBf1n7KtoPO1lg1Ln716yj5Rz1nS/mZcOqPq0VHRktCinqX0eI7h9IX4MEllZ0nAVIuypp/n0pukSnSGybFaf3lLjsTaNPBz2ezU7jjx3pWmteia4vhpigx8ZtLW5afkw44+XyU17sIVdoyqrtDfJuK5XS5ONj464PjMyxQbxbZQmb+AHKfbqiBRcDq9o0vbRY/oRS6COYaeRthWZir0amwggD62ZWF3N6yFezL5H688V+sMTBUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cvh5hRRL0xvPMX/+M+/eKcXifJ0dyjIXKLRmCKBnuo=;
 b=G3+VKxQN2jHhbuVwJmQjfHP5YY+fTmJtXgjPamamI9NKegOWgSkw3UZpg0UP+AU5xmJ9TLLak2gj+GXdj2SkzlwpfOGuPF54YXDnSPI0P+wNpqj1P1IUSTo4i4zn7PAUODy00/Twm5U/zE/MnHDnxuQMsIJGltsEkTphY/A+0Ta7qm84yKgQ8uU2HtMRdU9mDd9UFjsZnK7HN/NX8bbeXlN6H6nuGjtNfWBHht9athL3eIMgCyEMv+M+V/4YUnyHTEckchTr5JWPQnPVOUynTn9XnIShE0G8UTzcDxMrQMc7U2SjEJNUkP49NzflnntJgodn9v434IvI8H0v/AsyDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MW2PR1501MB2171.namprd15.prod.outlook.com (2603:10b6:302:13::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 21:01:47 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9d22:c005:431:c65c]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9d22:c005:431:c65c%4]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 21:01:47 +0000
Date:   Thu, 22 Jul 2021 14:01:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do
 bpf_(get|set)sockopt
Message-ID: <20210722210144.qrnpycup4rmejvnx@kafai-mbp.dhcp.thefacebook.com>
References: <20210701200535.1033513-1-kafai@fb.com>
 <d5ffdaf5-08e5-2b28-d891-73d507bae5fa@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d5ffdaf5-08e5-2b28-d891-73d507bae5fa@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0139.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::24) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b2b8) by SJ0PR13CA0139.namprd13.prod.outlook.com (2603:10b6:a03:2c6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Thu, 22 Jul 2021 21:01:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a6138b5-0252-439a-087b-08d94d53eb1e
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2171:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR1501MB21711F0BDD630A02F4DAD2C5D5E49@MW2PR1501MB2171.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UP0tMJSzU45pEEN1hd2j3biLsReop5Q+MBSzKBtXBwB9bthZ7gMjA8JrbT8TmyHopgghrqpZERTlzaEUQpz5pkmA3lubZDQczqdzFPLhco/OMcbvMNgKHRr2tCrFlJxWZe3nxvxRQg8yyBcZzrP+Cv9cXuEjJN8FLtjn4JOiCqo343UWl/i0G7xldxV5cYpqn2kCBTpS+6rKbDepHmj7BphKTSddBw+rK6N9EHiPkNIN/wCWA5MSFObC/Uy28V0Nd1dOh2kAoknyJ1F0qjeSrcHhIwkQAOHk/btwCX9Qc2EtluyuR+IB85Sr24kXF3LqEorpB3FpPL5NTvwlFWGmxRfYI0OE2SZ+q6izco3I6huoESEM6TwgHcVy8YQQkNNsRVCUOw928iZ0/vxK18jyLqN4rudM0gYPildZ6S/2lVfPO4dyVvFR2lDD51jOK3ImCqY21QKwMZZRa7IfEqgQqWzQSS8wGJlYG2e+XQ8prIDpZ/VugSahvUm0A7Nug7oUNWOJ+UudJnun6RGFkMqAXNFmM0BJqQmvh0Jr9b0iL7HfBSt2CWV0O+VIgZmw8YqxrzTigBaJus7kK+RnvU6E+tYEDkhPD7/a7iPWeCp0a5jkymXfGUeU/4HRwBXIlDesFmMaXNzTfTyqNbGnlFz73w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(9686003)(83380400001)(508600001)(7696005)(6506007)(53546011)(2906002)(8936002)(6916009)(54906003)(8676002)(1076003)(38100700002)(66946007)(186003)(316002)(66476007)(66556008)(55016002)(4326008)(86362001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?USxf+rgLWvWzeP3fQSjYi11hvuBPR6r7pszGV8Ni6u289BHXmYkwZiEnbBxY?=
 =?us-ascii?Q?TI5eR2ad8J5tR8fO1wjiWvU+c59G0tkWkgn41jnspQKyeSKPjXMVEfaCatCv?=
 =?us-ascii?Q?9TCLdeWFCA0Ewwyq2ZQljzZSoQ3xBTLTTviYghHgf1mDwyq8QLjXF7xTammx?=
 =?us-ascii?Q?SgU4XLu380HPhoZbe9afieMBSH0B22KGqLrZSGefFdLBGMYyCoMaf/BbeGsP?=
 =?us-ascii?Q?jdA6tmmVwlSb+FY+gxPKCRH1IVIui2p3aAJ+dLaPMwMXml7NhrQiOG+dMfVw?=
 =?us-ascii?Q?zHaqmCfHgM44QKQyNuHOoyJD+nRIJxC0yeCeL0EIfiB7shlA0TXbYQbqfHOV?=
 =?us-ascii?Q?Q1YMaq0PFewvKLJJFR7WTlxXnepWbRfjmUxyNxuNsat/2qDKlgmjT0yCT0CJ?=
 =?us-ascii?Q?rL30oO0HkNmu5/cjhvvktnV5PjNk/FBTED9Ih1SMNDs1fDC/sUVFghz/iJa8?=
 =?us-ascii?Q?+CRmhw0axCET4cGRI0rXVr/FJLfA+Sl11cHhUkIkr6vcPO3cTbYg+wDsfnoc?=
 =?us-ascii?Q?I7W+7Pi7B3AZG491y27qd4OMSRNQTGewOcQFms/LNapEeR57qBo0aJJTJlUO?=
 =?us-ascii?Q?tq6aIEpZLRsC2pWkPT3Mkub2rcjDXqchiOYQbCPfilAwpvoacXhwyOzl0oKi?=
 =?us-ascii?Q?GaVnU+RtvV50Mn/KB1LlLqUpS7GWYo0fsWBgI66MXiKl1CNqvTEa99zFb1/N?=
 =?us-ascii?Q?UxJ5auYy3c9VQ9PGXYdw4d3KnY1bOpvPSP+18fPHHudyQyW0it+zD6nAGQX1?=
 =?us-ascii?Q?K6ld4PWQp+jRBG8uLekKhNHQl2G+zwcxfMxGhmLpuxG9VXQYLJOCbAbncLAF?=
 =?us-ascii?Q?xNCG9K8/HyA1sx9oEmvVecx6wCME0KTRpYw1Z7gZugW845uWZc96IulX3y4X?=
 =?us-ascii?Q?/lWMU8qbhRidj3v94wqf9h0N1jw+vWcydQrV1xfGZoEE/bwXGd8w2ra/8jDC?=
 =?us-ascii?Q?zR50/TmBiQ9GwsPAd5M+ZMW2nHn2lSDKKFON4JgxiA4uEy/UDkLEs5YjTz8Z?=
 =?us-ascii?Q?30aJJ4zo6aeDz9f2u6wgLgcUoekgTbmKa+etxXuXVcaObzn/rzqNz7F0IXo+?=
 =?us-ascii?Q?bKgFN8Lw3Locw5p9njSimvriGx2I97nsfHA4AK1ELFrYJ2O/4v3/WMqVhEjf?=
 =?us-ascii?Q?YhJ8vg7IsMjxLQSlwDUKrU1FSv4xo3Ib+Ah3dQMPzpan2kAzwUmBiMqntrEU?=
 =?us-ascii?Q?7c4ZAiZpBw2UmS0yLH9nFbQUt8P3hzH3etzZISzTswxjcc9ORLlr/TU2gaRp?=
 =?us-ascii?Q?ZCz0l52W1I1budtq/HWU8tbRZdnYjH62dduTm2dzHXmaidqZPSO4oopst0tx?=
 =?us-ascii?Q?Kz0+vgqcPNO2Pj7Zok7eivwaHCVlhVhxWc6aKDxlSOrEQw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6138b5-0252-439a-087b-08d94d53eb1e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 21:01:47.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPwawOnpFaimCTwyyfICGMmy3jhzRjSr/yVSvWP5dkW5HBzHAyWhcat0ZWiQtdx9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2171
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: NBF1dgkslvIdWoVEc9TW0sTShye-8Z7x
X-Proofpoint-ORIG-GUID: NBF1dgkslvIdWoVEc9TW0sTShye-8Z7x
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_12:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 mlxlogscore=709 suspectscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 03:25:39PM +0200, Eric Dumazet wrote:
> 
> 
> On 7/1/21 10:05 PM, Martin KaFai Lau wrote:
> > This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> > 
> > With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> > restarting the applications to pick up the new tcp-cc, this set
> > allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> > It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> > bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> > into all the fields of a tcp_sock, so there is a lot of flexibility
> > to select the desired sk to do setsockopt(), e.g. it can test for
> > TCP_LISTEN only and leave the established connections untouched,
> > or check the addr/port, or check the current tcp-cc name, ...etc.
> > 
> > Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> > 
> > Patch 5 is to have the tcp seq_file iterate on the
> > port+addr lhash2 instead of the port only listening_hash.
> > 
> > Patch 6 is to have the bpf tcp iter doing batching which
> > then allows lock_sock.  lock_sock is needed for setsockopt.
> > 
> > Patch 7 allows the bpf tcp iter to call bpf_(get|set)sockopt.
> > 
> > v2:
> > - Use __GFP_NOWARN in patch 6
> > - Add bpf_getsockopt() in patch 7 to give a symmetrical user experience.
> >   selftest in patch 8 is changed to also cover bpf_getsockopt().
> > - Remove CAP_NET_ADMIN check in patch 7. Tracing bpf prog has already
> >   required CAP_SYS_ADMIN or CAP_PERFMON.
> > - Move some def macros to bpf_tracing_net.h in patch 8
> > 
> > Martin KaFai Lau (8):
> >   tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
> >   tcp: seq_file: Refactor net and family matching
> >   bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
> >   tcp: seq_file: Add listening_get_first()
> >   tcp: seq_file: Replace listening_hash with lhash2
> >   bpf: tcp: bpf iter batching and lock_sock
> >   bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
> >   bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter
> 
> For the whole series :
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Sorry for the delay.
> 
> BTW, it seems weird for new BPF features to use /proc/net "legacy"
> infrastructure and update it.
bpf iter uses seq_file, so the initial bpf_iter_tcp reuses most
of the pieces from /proc/net/tcp.

This set refactored a few things such that the bpf_iter_tcp only
shares the legacy tcp_seek_last_pos(), so the dependency on
/proc/net/tcp should be less going forward.

A similar modification could also be done to bpf_iter_udp in the future.

Thanks for the review!
