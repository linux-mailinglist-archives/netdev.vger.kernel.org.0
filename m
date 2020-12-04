Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8A2CE6A9
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgLDDnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:43:35 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25552 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgLDDne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607053345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s8KrzQEMJsK3eWKkpXa05FVwfV8GWFvODLPoRsqUO8g=;
        b=mzcE/yrKseY3+V2rmt16kcMJwvJZHGGiKf7DpgpJwVlh7WH8TPeXA9a+74mXBqL++J9yaA
        WMtZ45muPux8LooZDT77SWG9XyNb3OO80XEwGDYffgYivsaRA5EQbIZaSzMa5oOfY3ryom
        2V8ah87MT+eMPuJJK1CJa+k44jtQk1o=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2054.outbound.protection.outlook.com [104.47.2.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-2S3CfSOWPwSa7iCpxZQ4UQ-1; Fri, 04 Dec 2020 04:42:23 +0100
X-MC-Unique: 2S3CfSOWPwSa7iCpxZQ4UQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQIeYFzQjMi5MAkcSDdbIuMZtpeBwCc/AErL2Z2lFr+pESgBYPGcrPmqtiTl2+LtRpzTC+4sBJ0apJ8Hb+ESmXDgJMEztUpLGzkidNIAUGNoQgtbma4/TJ6IHx54APmkFaCZB6sSh2djKwhvZaiyTNkvCie1h6H2/gTM1Jzlx0shOipXZ0uOQWZR0jkj6c/xjRyJ6ihR6rrPf0YaCwcUIakqE4XzxHmMOmDX9KwRFa2OZO3C1P6g1RryQ4UO1FhLVdztAd2D4XqtRk91KiLvKcW8+htCpb6owQKAjWe+yCIoQy3h9ZK9z/l9ZuLEkhJ9MLV1hkHZX9lCcM0cmrP2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8KrzQEMJsK3eWKkpXa05FVwfV8GWFvODLPoRsqUO8g=;
 b=B/Lxf9Dxr7gywXWqmOeG8KdgHmiWkaPxVkyZgZITPslDq06ClvxVVQbIE8YqYwk62aUYSzZBjnMMJenIzKLIv2lWiBboI9Y6k1BwsyFLyblQw7b6n3iul7JPYO3Q6H3jwHi5Xi8sBh2RYUAqeM3wnQ3uR52sf1P07DMrOvEyNySv7romk/k4QrFeTAoSfVCXgHIphCdIwuByR47idnCQzyJu8nlKyKyZy/t7oC8amBIBXZ1R41Bm8WFSjcYSUom31eADs4SeaX3hc0fbyLFQ9t1o9O3bOqs7C5SKyYR+f0baTvIezpH6A7qAEei8WXpB0+2FlE7l8YYjNJXdJDcxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB4474.eurprd04.prod.outlook.com (2603:10a6:5:3c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Fri, 4 Dec
 2020 03:42:22 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.037; Fri, 4 Dec 2020
 03:42:22 +0000
Date:   Fri, 4 Dec 2020 11:42:13 +0800
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf, x64: bump the number of passes to 64
Message-ID: <20201204034213.GA16653@GaryWorkstation>
References: <20201203091252.27604-1-glin@suse.com>
 <8fbcb23d-d140-48fb-819d-61f49672d9bd@gmail.com>
 <20201203181431.t2l63nifzprxqc26@ast-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203181431.t2l63nifzprxqc26@ast-mbp>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR06CA0076.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::17) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR06CA0076.eurprd06.prod.outlook.com (2603:10a6:208:fa::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 03:42:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 417405da-a79f-4b1b-371f-08d898069be5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4474:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4474DF58CD47A6433CF5DDF2A9F10@DB7PR04MB4474.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KVnqIocJljltET++vlZnU7Dh875GoBgucOA5b8ZgNAenC+ZKPhGIHmqmArL/jOw9jeXd5KI7dzWm+CE/DXR83/A4pniG9lBe0LwNevhNRp71YF4er8pUCOr42UkxG+I1R25jSNNk0jnNFum18h+Ol9qwA1/lVg9CXgtLEqYMQo71z2AjVOOPbnVgUTkZP/3cUNQ/OsNjWSanPRDsG5PGNwChARYlrQS3UDKkG0YdLE1bs05wtlcmyaMf3bDElgwNdpEdlFNIuGygZijgZ7eKx4OMHfPcsONo9oO8PrMXKjfpS/cCwgWP1QgH1Q45PErqbBzCIcwNgXpoXuoa/QDD/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(366004)(136003)(6916009)(53546011)(5660300002)(33716001)(54906003)(86362001)(6496006)(83380400001)(4326008)(52116002)(55236004)(478600001)(55016002)(8676002)(1076003)(956004)(9686003)(66556008)(33656002)(66946007)(8936002)(186003)(16526019)(26005)(2906002)(316002)(107886003)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QbujSv06ftT0GjsYV6or64/p97WUbCK5ZYD+alKEDH0wA6tT1JDfU23ohcHN?=
 =?us-ascii?Q?T7u74ve+VW2hdOBrlXuDBEbcu+mW5VQ8TLCJ7mKqk4eykLun6bMJPk+GJxHo?=
 =?us-ascii?Q?NTwGhouMCVTQue7WP2RqwJExqPiG3DkpfqcmrHqMspjses4YSnxfSlo52e7K?=
 =?us-ascii?Q?L2bUua/AgUnTO7h/RbCH5xVi6ubdTRAoUz6/Xfmef6U7su2kepKGGMslMj5q?=
 =?us-ascii?Q?k+BLeRNPObhZqPDYisj01VNsrr6YYm9xVzRAB0Fa3jnS1xlxGZ3Qb8cUDm6N?=
 =?us-ascii?Q?JlL2FP3Ai4sR5GozCiwMQJ/pHU9Hr2YUVFwt3m95wEvdQyrUZ/xpDmv6olnd?=
 =?us-ascii?Q?fIOUW1yVAhoOtmmqiu+nBNBs/qXdWBQY5ved0a1S/+B+ggtUzu6vRFhmCj0a?=
 =?us-ascii?Q?TPWO6sb/T3b7IrGfw7EW/cUbD8sbId5CU8yE5J9SkQR3Ba16vpwDH4X3yBM2?=
 =?us-ascii?Q?4IfwtqEd7OQvE+4P35iLz14Twkq7vbSdmC4sL2+WZhOBZbMi9wjS7+tT67HF?=
 =?us-ascii?Q?6kekiPEP942Zy6L+j6mvpGx7QjAgyUQFQhTe539h0lTn5+cbTmvkZHm3F0PN?=
 =?us-ascii?Q?hBUrCzryxWqYP+80QcvRSapPdtFZjXfhKF4shjxSqglCU0EiCMKuDNCj1Vtd?=
 =?us-ascii?Q?dYpcPRRJbC3KenMXQXQ1wjaK5nYBFQPZpgCTSJYp4bkOy+ZENwyMUSvDsrLy?=
 =?us-ascii?Q?2OYBAs8K3tKjuVhdrpqJiZvvYXTViCr6m6heS1VhCm5VB4VlRNNokr4kmOxy?=
 =?us-ascii?Q?6ZConPafuPPEME51vu1yzmmFUqssD1W7fjwQ7AljyZCXh5e/eCz4F5EahotD?=
 =?us-ascii?Q?wSWnrw/nsogCcO0RIXdQhMmvbHa6Do44H77A7BfiQIJfkeou3+eKqqg785oJ?=
 =?us-ascii?Q?e5K5qIvguzq0H8mbmh0XEFekBJgrOwEZoIKOG2gV/xFQLsss1huC+5mJjHlh?=
 =?us-ascii?Q?6y79xISRGJknpVzE0ivW6Gggv99AHWZ1YwvQd216WSydOIo1IUDMVBAi8ZcZ?=
 =?us-ascii?Q?3vUf?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417405da-a79f-4b1b-371f-08d898069be5
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 03:42:22.7238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfGNfbzmlKr6MmEyH2NYuDuuyIcf4Xti1Va6y3eQmJDN57ZabVq8JZkDUSrAgJ+u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4474
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:14:31AM -0800, Alexei Starovoitov wrote:
> On Thu, Dec 03, 2020 at 12:20:38PM +0100, Eric Dumazet wrote:
> > 
> > 
> > On 12/3/20 10:12 AM, Gary Lin wrote:
> > > The x64 bpf jit expects bpf images converge within the given passes, but
> > > it could fail to do so with some corner cases. For example:
> > > 
> > >       l0:     ldh [4]
> > >       l1:     jeq #0x537d, l2, l40
> > >       l2:     ld [0]
> > >       l3:     jeq #0xfa163e0d, l4, l40
> > >       l4:     ldh [12]
> > >       l5:     ldx #0xe
> > >       l6:     jeq #0x86dd, l41, l7
> > >       l8:     ld [x+16]
> > >       l9:     ja 41
> > > 
> > >         [... repeated ja 41 ]
> > > 
> > >       l40:    ja 41
> > >       l41:    ret #0
> > >       l42:    ld #len
> > >       l43:    ret a
> > > 
> > > This bpf program contains 32 "ja 41" instructions which are effectively
> > > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > > bpf jit should optimize those "ja 41" instructions out when translating
> > > the bpf instructions into x86_64 machine code. However, do_jit() can
> > > only remove one "ja 41" for offset==0 on each pass, so it requires at
> > > least 32 runs to eliminate those JMPs and exceeds the current limit of
> > > passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > > is set even though it's legit as a classic socket filter.
> > > 
> > > Since this kind of programs are usually handcrafted rather than
> > > generated by LLVM, those programs tend to be small. To avoid increasing
> > > the complexity of BPF JIT, this commit just bumps the number of passes
> > > to 64 as suggested by Daniel to make it less likely to fail on such cases.
> > > 
> > 
> > Another idea would be to stop trying to reduce size of generated
> > code after a given number of passes have been attempted.
> > 
> > Because even a limit of 64 wont ensure all 'valid' programs can be JITed.
> 
> +1.
> Bumping the limit is not solving anything.
> It only allows bad actors force kernel to spend more time in JIT.
> If we're holding locks the longer looping may cause issues.
> I think JIT is parallel enough, but still it's a concern.
> 
> I wonder how assemblers deal with it?
> They probably face the same issue.
> 
> Instead of going back to 32-bit jumps and suddenly increase image size
> I think we can do nop padding instead.
> After few loops every insn is more or less optimal.
> I think the fix could be something like:
>   if (is_imm8(jmp_offset)) {
>        EMIT2(jmp_cond, jmp_offset);
>        if (loop_cnt > 5) {
>           EMIT N nops
>           where N = addrs[i] - addrs[i - 1]; // not sure about this math.
>           N can be 0 or 4 here.
>           // or may be NOPs should be emitted before EMIT2.
>           // need to think it through
>        }
>   }
This looks promising. Once we switch to nop padding, the image is likely
to converge soon. Maybe we can postpone the padding to the last 5 passes
so that do_jit() could optimize the image a bit more.

> Will something like this work?
> I think that's what you're suggesting, right?
> 
Besides nop padding, the optimization for 0 offset jump also has to be
disabled since it's actually the one causing image shrinking in my case.

Gary Lin

