Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AECB53224C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 06:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiEXEtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 00:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiEXEtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 00:49:21 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A784D633B0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 21:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653367757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qEatQu7GlL9FpW/y5wTtBNxS6zPmDAp2WMyhLYa5AEs=;
        b=Ih4yCKj3vgW2/+3kBON9GtCAlp29hQqAr9UxzUFoHnquKHXfF+ApHwdQCY8am6ZfeuLcZR
        sf/yGMGHnOc5DXuzrjuFXVFPrAGetGfokV7txmR5bp6IVqI4ZJP1Gn1LJE9hO+pHpjg/15
        zUlBqA94wEbtTLtlpE8j+tK1uB/7jB8=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-ExXv73ttNmqStGktdK6ouQ-1; Tue, 24 May 2022 06:49:14 +0200
X-MC-Unique: ExXv73ttNmqStGktdK6ouQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0vZDS5pfiNUIXPrb7yDMQx5qT9cZLF0Jb+tZ4NEYDtzP6RcVelKeCadTRBwFXO3zdXAQCrNczQpb743xt6P3wHMum+hHRSg8oGCfjbG1EJfRqHx/NJp6rwtpkXadagGRk4SrEuhwKlF0wXpmmEyx79Zu1qtodI4924dx/4qayZW3NK/G854SINAYJ0gNRtbZKVIJHmwmi1VETlSihu/MbUqmXj6m0xCaBoKjh4M5yYGKXPgP6mh+FsHi5QiPXoJMJbFuMjRgyVsyVF85J7hagpm8OpQNx24AOucJaPJOSu/5Cc9UCB1aQmIxUOiVx2po/OSK94ixity37Fd/dHsig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEatQu7GlL9FpW/y5wTtBNxS6zPmDAp2WMyhLYa5AEs=;
 b=KlNFareGt6z5V6CPMZmjyf/f+8h1IHXCIBc4io24SVwSN/koqjcly3Fy9FmDC/aSwkhWO0jQoZClSiBAOGh83ldmrMzLwgb5QJPgn9oq9A9DDu4J4/Dj/SRwGsy0n4737t7ETysWxtFVHY4EiamDpSdNDcRsT1X2ABe0nr8l9xG/zdTEg9AeMel/Kn20rfu+HZjuZBqT5u9I4lbeWqV5EX2Edusr0FUg8thqnYWjo2b60UOTr8SWfiW81GOnRFKUPMWxgZKG5h+3KvmXfD+ozHhJSK6/INC6kM6e+vZfIbDzIs7vYqMfd8T8xMFiH0pwiyfQ3p7aJQyca1Yo+x8BVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by AM9PR04MB8505.eurprd04.prod.outlook.com (2603:10a6:20b:40a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 04:49:12 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 04:49:12 +0000
Date:   Tue, 24 May 2022 12:49:02 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add reason of rejection in
 ld_imm64
Message-ID: <Yoxjvvm9poTC3Atv@syu-laptop>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
 <20220520113728.12708-5-shung-hsi.yu@suse.com>
 <7301b9cc-fdb1-cd4c-2dda-eb97018546a6@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7301b9cc-fdb1-cd4c-2dda-eb97018546a6@fb.com>
X-ClientProxiedBy: AS9PR06CA0537.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::34) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84067594-0d6d-4efa-9fc7-08da3d40bf66
X-MS-TrafficTypeDiagnostic: AM9PR04MB8505:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB85056D0149B0F2B026B0293ABFD79@AM9PR04MB8505.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qj/nN35iPuMg9HEueYDKdEE3zqVmNwb3rV9EuWJnKQNsC9Sb8dn0ENjaQwB1jN8QcW2zetNcC44ixwWiQXrJg9fn52Gjj1P464PCnxlJoJDQjcvbruOPCbc4g7V4F5nXOn/Os2BwnXSLghK/F4XtrExvhAeZA6NYTfFcmVbrfSkuJ+oRj12S+i814b0/7x771YsQ9rFLpDmtyq+XzWZxcQ+CD4MwUNBKoj4A4skjhTvFX27Oetm6itaHW1iHLoguC3cLwzDRC2w1qGA7rWRmfyRiBmCEvstgHl9ksqTIM9pmPhEERWB2c/d/8eT/rDkj6KYJ8pEVR+TfIGUZjSZIWOP23NLPj41s6Fu7VECi4pKcAIw9x+mzgFXZS+Rb1EEHSWOknKaaF2qCSXMUvvS/DiqQ8PJByMBgeaCOgVQZjJxd0m2jT6k4ng6rwM62PM1ewkqNe4rK/QdSeQcvtQ8kWpLbdKs0Nc+K4rV0m2BEUmmdtYyWnBAWnNc+I8AqTrq58Ux2ZGE8zRyeALGJMzViFySRrJ44DhS9FwryMSy+dtlGa8+qVO8l+hV82eO2LQaZtdiiE9UPDvWKVh3brer+N2P+b/t3mVfvpx3U6Q1p51CLbTd9SRFV4uP9lgZjJuyfoZmb6VuzxQghcAltxASNKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(7416002)(5660300002)(26005)(38100700002)(54906003)(316002)(6916009)(6486002)(6666004)(508600001)(6506007)(53546011)(9686003)(6512007)(186003)(83380400001)(4326008)(8676002)(66946007)(66476007)(66556008)(86362001)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2o0M2RMY294cC9sZ0VSYUlrY2k3VFMrNzh4Zk1ZUjgyR0ZIVC9VaDJmOXRK?=
 =?utf-8?B?eDdYNUdUQk03L2lxMmZFeW52eTltc3dLcWhZMVVLWElEbENla3dnVVNwYzF6?=
 =?utf-8?B?YXFOUlBxcGgwa1ZNeWhKdHB3Qmp6TUdzWThFT3hWcjZXMVdDd2RCUVVjRXhX?=
 =?utf-8?B?WTdCRERlNUYyc0pCdDR4TTBtYUpYR0NzTG02bkRyUnJRdk55U3A0R214OGxt?=
 =?utf-8?B?aEhSUzBQdTVKTDVHV3pWSWNLVERjOGlGb0lTVFhMTUw2MjhkaTJ6dkRsUWZj?=
 =?utf-8?B?Nkp6R1YwM3dnL01pckFLRldmSE1wd3lIZ1grbWQ3QlNOZFlPTUJ2VWI4TC8z?=
 =?utf-8?B?S1g5N0RPYTJvUHRIZ3lXTzlsRk9WR0wrV3d2OFRidXM4NkkrblJqNXdSdXlq?=
 =?utf-8?B?Q0k4bE5mSkY3K09MRjJwOE5oZmlTRjhQbURwLzhBSndpaDNNN2V4QVFCZkxM?=
 =?utf-8?B?Ukp5VEtMWFQ4NkxBbE8vWWM2aGJsRWRFZklJR2NFZ21HQW9vSDdPcWNONVJT?=
 =?utf-8?B?Smh4WXBZbkZjMzZQNUdhUVVNRUVXV2d2RXdKdnVSZFRudzhHTGJoTVRIcTVP?=
 =?utf-8?B?U1JJak1zL3ZaNGlVaWNSZVVvOXE0amdOVUw4N1B1WkpYN1VEc3BxQTArODhU?=
 =?utf-8?B?OUdpQWRpN1J4dzg4V2M2MUJFZWlCZTRBL2RpUTM0ZytnaGdtWXBoQnBRNytT?=
 =?utf-8?B?clFFVlhqNUFOaDNTUkJBd2JhZE9GaU5HUC9NNjJOaHdMMnRJY3dsTzhCcWZo?=
 =?utf-8?B?bk5vTktTZkdBSGJ5SlpoZjdUYzA2Q1R5TXM0THJSSnhYZUtIU1BTMWI3V0N0?=
 =?utf-8?B?MDFyRnpEUmc3U2FyRTZaWDBla1RHMGExU0FRenY1TnNXMG53bFhRT0g4Z3BQ?=
 =?utf-8?B?N3ZUVWdNQS9uUmVKNUlVdTBOTnhtUEtJTmVTYTgxd2xwZzQrRnZZalA2YWVq?=
 =?utf-8?B?OG42NFluY1RGS3k5VXFBZDR5dHBqZjd3UTdWdVQ4WWo0ZURLTUtRc2xZYkw5?=
 =?utf-8?B?SjBUZ2lMbWRUTXhRL1ZmV01sREpkRS9hblp4bGxDZWo2bWdmb04wZk5icUVN?=
 =?utf-8?B?SzEyR1lpWHI2MWIvamhHNnRxZG9BRlFVd1lueEJNMXRvOG0raXRhM0NMYXV4?=
 =?utf-8?B?RG9hMFV4eHVmWnhyRmUvSkkrMjlyRzdWdHgvUUxJYzdjaGphdnNSSVoyaWtZ?=
 =?utf-8?B?T3RrakRDVkJKbTFDTE9pekdJU01xZVBkVEswUStxRTkvREFma1A0dXhGUVlt?=
 =?utf-8?B?MEI4Y08rdk9kNWNtSURGZFovWVR3K3llRXltQ1IvNDNZSG1wbzJDVEJQZjVB?=
 =?utf-8?B?SXFKdEtTejNGelYrb2h5WDZTaS9jWkkrYWVjWVRaYXdGdU9yTzNGbmRad08x?=
 =?utf-8?B?VnBwT2g1alc5MmNpZm1WUks3aU9iOHZiaklQaE94cUJXcDA3ME9lRHNlWHNO?=
 =?utf-8?B?ZTFPdmJaV1hwMHdBUmlOYjFlRjJJWTZIOWZObFNvc0V3dnk2ci9pK014b2NN?=
 =?utf-8?B?SWRCYmxhRnE4amRHK0lXTUIzL3liYTNkZ3U4alN3ZC9FRnNEeDdub0JLWmJr?=
 =?utf-8?B?bkl4Q3FIS2pQalE3MHFJeTBwTlIxUW1LNXQvQU9ObC9iQUYwTys4NUNWbmlk?=
 =?utf-8?B?SWVSY05tVDNEemQ0TTlVUVVuSmZFdnhNcmh1dm5DVld3T1lTdW5JTHVYMkV1?=
 =?utf-8?B?V3p4QWtibWFPRHlBSE9janB4VGI3VENPMC9MeHhuMXJ2cnhtSlVPdlpuazI1?=
 =?utf-8?B?Q3lUYk9EN0FOMlE5WlVBU0MzNkVTYk1rTXpNdFh0Rkt6eWhRUVpEVDJveDRL?=
 =?utf-8?B?YXNuTmZvL21VR05kSGZITWgwc2ZwTStuWDRDSElyTEdndzY2ZjhQaDkrdWNY?=
 =?utf-8?B?L2Zyc0V3UDZyVmZWQW1hV1o4cnFXeTNlTGU5VVNwL3IwRXZLeEhYV3VpZ3Mw?=
 =?utf-8?B?TDQxQjJsOUhaeHd4NTBjQitjeG1jK1pzVGJ1cWR6L0w4bDBCTjk2WFRyUmEz?=
 =?utf-8?B?U002SC9BM1JOVXE1NFZjZUVxZ0dROGZTL3VtMFNpblJzd1c3R0hMUVVTdkQx?=
 =?utf-8?B?L1ZYdFZkSG85eTNtVDgrMDZReU9Ldk5Zay93SzV0Q3lDS0hFNnJ6SXAzMFpl?=
 =?utf-8?B?RERwd3FMUzZJQ1RSaC9lTjlQc2tWcGw0d2w1NUN2Z1ZJazJCZWpwWGtzYkRB?=
 =?utf-8?B?Sk1zYmp2bklxaDlIUkMwMGZxdmRtUzZQRzhvNlVFNEY2NHhOdzAxUTlyemFp?=
 =?utf-8?B?TVE0VGxRamErY0gxMWllS0VqOTRQZUxnOWRsaEpsN25Oa2VZUW9QNFdKUWVQ?=
 =?utf-8?B?M0g4c251ZEYxeGNsdUd4VXJ4bW9nakFHdTdkVEdCYUQycSt2QTBTdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84067594-0d6d-4efa-9fc7-08da3d40bf66
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 04:49:12.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAI7uZHc1HmMsI/QV/RS/A5l6kGGbdRFWfOaGxDZOy4MMazH9kkbN+bFbhDOx63kngF6SZ8OHqxx/PmqC8ydeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8505
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 05:27:12PM -0700, Yonghong Song wrote:
> 
> 
> On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
> > It may not be immediately clear why that ld_imm64 test cases are
> > rejected, especially for test1 and test2 where JMP to the 2nd
> > instruction of BPF_LD_IMM64 is performed.
> > 
> > Add brief explaination of why each test case in verifier/ld_imm64.c
> > should be rejected.
> > 
> > Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > ---
> >   .../testing/selftests/bpf/verifier/ld_imm64.c | 20 ++++++++++---------
> >   1 file changed, 11 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > index f9297900cea6..021312641aaf 100644
> > --- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > +++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > @@ -1,5 +1,6 @@
> > +/* Note: BPF_LD_IMM64 is composed of two instructions of class BPF_LD */
> 
> > [...]LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
> > @@ -42,7 +43,7 @@
> >   	.result = REJECT,
> >   },
> >   {
> > -	"test4 ld_imm64",
> > +	"test4 ld_imm64: reject incomplete BPF_LD_IMM64 instruction",
> >   	.insns = {
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
> >   	BPF_EXIT_INSN(),
> > @@ -70,7 +71,7 @@
> >   	.retval = 1,
> >   },
> >   {
> > -	"test8 ld_imm64",
> > +	"test8 ld_imm64: reject 1st off!=0",
> 
> Let add some space like 'off != 0'. The same for
> some of later test names.

Okay, will do that in the next version. Thanks!

> >   	.insns = {
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 1, 1),
> >   	BPF_RAW_INSN(0, 0, 0, 0, 1),
> > @@ -80,7 +81,7 @@
> >   	.result = REJECT,
> >   },
> >   {
> > -	"test9 ld_imm64",
> > +	"test9 ld_imm64: reject 2nd off!=0",
> >   	.insns = {
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
> >   	BPF_RAW_INSN(0, 0, 0, 1, 1),
> > @@ -90,7 +91,7 @@
> >   	.result = REJECT,
> >   },
> >   {
> > -	"test10 ld_imm64",
> > +	"test10 ld_imm64: reject 2nd dst_reg!=0",
> >   	.insns = {
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
> >   	BPF_RAW_INSN(0, BPF_REG_1, 0, 0, 1),
> > @@ -100,7 +101,7 @@
> >   	.result = REJECT,
> >   },
> >   {
> > -	"test11 ld_imm64",
> > +	"test11 ld_imm64: reject 2nd src_reg!=0",
> >   	.insns = {
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
> >   	BPF_RAW_INSN(0, 0, BPF_REG_1, 0, 1),
> > @@ -113,6 +114,7 @@
> >   	"test12 ld_imm64",
> >   	.insns = {
> >   	BPF_MOV64_IMM(BPF_REG_1, 0),
> > +	/* BPF_REG_1 is interpreted as BPF_PSEUDO_MAP_FD */
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
> >   	BPF_RAW_INSN(0, 0, 0, 0, 0),
> >   	BPF_EXIT_INSN(),
> > @@ -121,7 +123,7 @@
> >   	.result = REJECT,
> >   },
> >   {
> > -	"test13 ld_imm64",
> > +	"test13 ld_imm64: 2nd src_reg!=0",
> >   	.insns = {
> >   	BPF_MOV64_IMM(BPF_REG_1, 0),
> >   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
> 

