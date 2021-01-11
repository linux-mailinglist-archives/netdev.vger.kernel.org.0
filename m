Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068B62F0CF3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 07:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbhAKGdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 01:33:11 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:41044 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727415AbhAKGdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 01:33:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610346720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QQaa3/Fg5N7DMec2oHHhPHFmfRNnauzNvoKh7jzCs2E=;
        b=O2gdItlU92qLjgHg60ela34c08jLGWSfDzzU0P05jCHnGa9MJIoW3qDoK3BJr/Xm1crtFh
        sPoxSKq8aQ9+X76EB6Ucis1FEegDoCKyjHKhgfOA+Jvdf/JaS93R/qb93TUfqFXjBebOo6
        rgy/9ugxSqnSuGlk5PdqiV1fOhcR4oM=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-1A7WUC5BNLCwGId0ksv4HA-1; Mon, 11 Jan 2021 07:22:45 +0100
X-MC-Unique: 1A7WUC5BNLCwGId0ksv4HA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yg7DBHbO+f4/gjAqWvJdr5bYqr4DD7vQRFFD4kV0pvfsCurBVuWURc6hrGBuzTKkAoFgHxgFYLZRCzCLSvReOyhDXM12M+dTmEn9NgPBXZAhe4v1NJtrYmKbplLl0mo6c4BpZmQOwn9H8d5rX7nW3AsioZKI9crpnIqUjS+C6Cz14nL4FIEvRmYqJl7PFWdRRmU3RRp5ByUccXXr5XsqZn3P8XIPNgDH9w+FH8+VFpnRiXJhNfsjkfR5/HeafR7CW/dICFPKoTQVOI0YJU70ns9BfZ3c8m7dBlVqzVTpL4QkLhm5outk8CeSwoZC9iRCRlCkCmAKmk/KOBQCu//24g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQaa3/Fg5N7DMec2oHHhPHFmfRNnauzNvoKh7jzCs2E=;
 b=ZoLtJW+BEOh14kdB36DRtlm1a9t8A7CyT13zg2aKTdri4KaHPh9xbqRID2hrP7UBc3OyXjXJItYgGUXJCFSZB5Wv3/UkgCQcsAzPzBmKLMUwnjYRZBp7HWv6wU/eCX84Pp7l4KP7PEWYD6ssvPwIbJJO4DVO/IZXn0dzrWci1vRFf1pRgKFG9CJftdgkLbwc6cgBoOKSf+dwQukNpT/wNFxsmPHDeS+mUQVD1tdaoxuUYQmpdYSpMrBTbh8sPgT1/kUnLsX0R0w+7lLNNQYlWOtYFklI08KUvZCE7ljompMDYa3IrWou1RWNfCyIa7VJ0Oe2d0FzvChx+/UxliuPUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5753.eurprd04.prod.outlook.com (2603:10a6:10:b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 06:22:44 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 06:22:44 +0000
Date:   Mon, 11 Jan 2021 14:22:34 +0800
From:   Gary Lin <glin@suse.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH RESEND v2 1/3] bpf,x64: pad NOPs to make images converge
 more easily
Message-ID: <X/vuqtDsoof9cnba@GaryWorkstation>
References: <20210107021701.1797-1-glin@suse.com>
 <20210107021701.1797-2-glin@suse.com>
 <450c7789-f9bb-113e-0a88-3ef11b453846@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <450c7789-f9bb-113e-0a88-3ef11b453846@iogearbox.net>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM9P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::29) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM9P193CA0024.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 06:22:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5fbe051-75b5-4e0d-5b4f-08d8b5f94e79
X-MS-TrafficTypeDiagnostic: DB8PR04MB5753:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB57537B5CC018AF62ABCF6C96A9AB0@DB8PR04MB5753.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1iwp5X0RnwqodpbnFR3DCJriZv7+lVqh9Om43hivLK48Zcat+cniGqwWkit3uMQmkwohe9sk4Jj0b2oDIfYZ9v/oc93+H57GRkkNBgmaMjXR5ZKZosKR0QzSIAu2iAnIICfFAvKdjZbsSrN5Myuc27gx+UskufvI1Tz5ozn+HEQRNRAtDd/Du1oOygsJF08D+qiRC1KyZF2/p4OF4jrVpgvYIAEs+Y6OlIczdpfWlVuIk+3Iw8Vphj3aG84BRcUU2I3ULwyagvkAxVsPv0HFyfdK2kEav7GZj3DPhDl/lfqoMHZ6yKQ7X2Y7IYfT83scmPZnLs7D9YWTk7sAQk2HnAvgZj5j3qKb0K/XSeMchxqU31EDPRjFJZ1VGiCd1Ex3qV8HHtUnkFYngXoNGbuKqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(376002)(396003)(956004)(16526019)(9686003)(8676002)(55016002)(26005)(55236004)(8936002)(86362001)(186003)(66946007)(316002)(2906002)(478600001)(66556008)(66476007)(83380400001)(54906003)(53546011)(4326008)(33716001)(6496006)(6916009)(107886003)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C+rU0cHSB3BPBmoIK6wRRLKL03M9ekfdyrRUliynBWPnRqqZfn6u1LC/adRz?=
 =?us-ascii?Q?/p5E7g31Ak9+t/okRH0qSmdZYttuVeJGx9G9eNy+CW+N3Z0H9FE5tfJINS0H?=
 =?us-ascii?Q?rBBNr5w9RyMx/xGVJmg3lCWmYLET24Ehv+pdVcQl0Qb83VabIAQgndgUBr2w?=
 =?us-ascii?Q?5MDVoBYteL7pQQbbx7tnFSZ2mvftXdAp9dE3UXASfb2MZJixuslrrtJM59ew?=
 =?us-ascii?Q?CX6XAknaxIdEO+qdjdTGxZQ8eXNjjmaEqpQ39J+hr70SvLmwj+0zpHNFVEvJ?=
 =?us-ascii?Q?J/cwi+y7WB+oANI31aMbZfRrvYmLbyFY/EdFfEaqArilN9stTnzIUkdlHlHX?=
 =?us-ascii?Q?baAKCn2ko0Hr3I7+CEENAIG+QoFxX7viZsgtL9I7ZHGbeTUGjVYRmdtZaZmF?=
 =?us-ascii?Q?dC9LVs8NAU1BZgHEWr8+9D1xbUNIvfHLAm4E+glGYm1hqEYVT9CSa/AYeDDf?=
 =?us-ascii?Q?HHsYGWDr8QJL37wt6ZGXf5JV6mwfRCiPMiFZ1rVOXesX+YEDrScfiwmDYoI6?=
 =?us-ascii?Q?o//iZhMjsUkfc/Xn0njpPoJSrdjEsLNgj+faqwYK+v1ifaGS+2gSnlklbwYW?=
 =?us-ascii?Q?TkHXgpJ0VFuhqyCeAlJx5uK986C49tqzvVfDHrCiyA44LjJaIcpH1zuli4HG?=
 =?us-ascii?Q?WiJNsZrEzmO2wZIPd7ZowfNlPRv1JPMQWackF4cOSLww10S8kgVGlj9WO0kO?=
 =?us-ascii?Q?hyuCtfPxgxW3r+fGIPGRTVBcYGfrHoGzMtCgZ2mBvr8Qsq3rSkeQBQ7J65+Q?=
 =?us-ascii?Q?wRdjmsvcUfwrn8vDdPuaWqjewRJChuroUo+Sd6tXdh0nRa6lMq3RZh85ZPNs?=
 =?us-ascii?Q?irdtQmildqJSBhwz9wG3aasU9rnVuFoTUGRlOB/ZM668cNYgW54K7SrTk6hi?=
 =?us-ascii?Q?njJ33n86HQS4jY1FmGWDqDY+wEJJF9lExjz57eccTobQSgIcCf5UN0vSMVGF?=
 =?us-ascii?Q?BrwAxg0CI6VDktY5A6pxzDSPiVixKKYaA8VqOmgmplTMqfrSdUm5yUVPtjTZ?=
 =?us-ascii?Q?A7T5?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 06:22:43.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fbe051-75b5-4e0d-5b4f-08d8b5f94e79
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnDG9KaryGIpdwjvHZIgi1tsKCW2Sp9Kve+OECcLMNTrbxVH3d3iTa7TUiYaBWlG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 11:21:13PM +0100, Daniel Borkmann wrote:
> On 1/7/21 3:16 AM, Gary Lin wrote:
> > The x64 bpf jit expects bpf images converge within the given passes, but
> > it could fail to do so with some corner cases. For example:
> > 
> >        l0:     ja 40
> >        l1:     ja 40
> > 
> >          [... repeated ja 40 ]
> > 
> >        l39:    ja 40
> >        l40:    ret #0
> > 
> > This bpf program contains 40 "ja 40" instructions which are effectively
> > NOPs and designed to be replaced with valid code dynamically. Ideally,
> > bpf jit should optimize those "ja 40" instructions out when translating
> > the bpf instructions into x64 machine code. However, do_jit() can only
> > remove one "ja 40" for offset==0 on each pass, so it requires at least
> > 40 runs to eliminate those JMPs and exceeds the current limit of
> > passes(20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> > is set even though it's legit as a classic socket filter.
> > 
> > To make bpf images more likely converge within 20 passes, this commit
> > pads some instructions with NOPs in the last 5 passes:
> > 
> > 1. conditional jumps
> >    A possible size variance comes from the adoption of imm8 JMP. If the
> >    offset is imm8, we calculate the size difference of this BPF instruction
> >    between the previous and the current pass and fill the gap with NOPs.
> >    To avoid the recalculation of jump offset, those NOPs are inserted before
> >    the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
> >    calculating the NOP number.
> > 
> > 2. BPF_JA
> >    There are two conditions for BPF_JA.
> >    a.) nop jumps
> >      If this instruction is not optimized out in the previous pass,
> >      instead of removing it, we insert the equivalent size of NOPs.
> >    b.) label jumps
> >      Similar to condition jumps, we prepend NOPs right before the JMP
> >      code.
> > 
> > To make the code concise, emit_nops() is modified to use the signed len and
> > return the number of inserted NOPs.
> > 
> > For bpf-to-bpf, the 'padded' flag is introduced to 'struct x64_jit_data' so
> > that bpf_int_jit_compile() could know whether the program is padded in the
> > previous run or not.
> > 
> > After applying this patch, the corner case was loaded with the following
> > jit code:
> > 
> >      flen=45 proglen=77 pass=17 image=ffffffffc03367d4 from=jump pid=10097
> >      JIT code: 00000000: 0f 1f 44 00 00 55 48 89 e5 53 41 55 31 c0 45 31
> >      JIT code: 00000010: ed 48 89 fb eb 30 eb 2e eb 2c eb 2a eb 28 eb 26
> >      JIT code: 00000020: eb 24 eb 22 eb 20 eb 1e eb 1c eb 1a eb 18 eb 16
> >      JIT code: 00000030: eb 14 eb 12 eb 10 eb 0e eb 0c eb 0a eb 08 eb 06
> >      JIT code: 00000040: eb 04 eb 02 66 90 31 c0 41 5d 5b c9 c3
> > 
> >       0: 0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
> >       5: 55                      push   rbp
> >       6: 48 89 e5                mov    rbp,rsp
> >       9: 53                      push   rbx
> >       a: 41 55                   push   r13
> >       c: 31 c0                   xor    eax,eax
> >       e: 45 31 ed                xor    r13d,r13d
> >      11: 48 89 fb                mov    rbx,rdi
> >      14: eb 30                   jmp    0x46
> >      16: eb 2e                   jmp    0x46
> >          ...
> >      3e: eb 06                   jmp    0x46
> >      40: eb 04                   jmp    0x46
> >      42: eb 02                   jmp    0x46
> >      44: 66 90                   xchg   ax,ax
> >      46: 31 c0                   xor    eax,eax
> >      48: 41 5d                   pop    r13
> >      4a: 5b                      pop    rbx
> >      4b: c9                      leave
> >      4c: c3                      ret
> > 
> > At the 16th pass, 15 jumps were already optimized out, and one jump was
> > replaced with NOPs at 44 and the image converged at the 17th pass.
> > 
> > v2:
> >    - Simplify the sample code in the description and provide the jit code
> >    - Check the expected padding bytes with WARN_ONCE
> >    - Move the 'padded' flag to 'struct x64_jit_data'
> > 
> > Signed-off-by: Gary Lin <glin@suse.com>
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 86 ++++++++++++++++++++++++++-----------
> >   1 file changed, 62 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 796506dcfc42..9ecc1fd72b67 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
> >   	}
> >   }
> > +static int emit_nops(u8 **pprog, int len)
> > +{
> > +	u8 *prog = *pprog;
> > +	int i, noplen, cnt = 0;
> > +
> > +	while (len > 0) {
> > +		noplen = len;
> > +
> > +		if (noplen > ASM_NOP_MAX)
> > +			noplen = ASM_NOP_MAX;
> > +
> > +		for (i = 0; i < noplen; i++)
> > +			EMIT1(ideal_nops[noplen][i]);
> > +		len -= noplen;
> > +	}
> > +
> > +	*pprog = prog;
> > +
> > +	return cnt;
> > +}
> > +
> > +#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
> > +
> >   static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> > -		  int oldproglen, struct jit_context *ctx)
> > +		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
> >   {
> >   	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
> >   	struct bpf_insn *insn = bpf_prog->insnsi;
> > @@ -824,6 +847,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> >   		u8 jmp_cond;
> >   		int ilen;
> >   		u8 *func;
> > +		int nops;
> >   		switch (insn->code) {
> >   			/* ALU */
> > @@ -1409,6 +1433,13 @@ xadd:			if (is_imm8(insn->off))
> >   			}
> >   			jmp_offset = addrs[i + insn->off] - addrs[i];
> >   			if (is_imm8(jmp_offset)) {
> > +				if (jmp_padding) {
> > +					nops = INSN_SZ_DIFF - 2;
> > +					WARN_ONCE((nops != 0 && nops != 4),
> > +						  "unexpected cond_jmp padding: %d bytes\n",
> > +						  nops);
> 
> Instead of all the new WARN_ONCE() occurrences, I'd rather prefer if we do a
> pr_err() and reject the JITing with an error (see also the 'jmp gen bug' one).
> 
> Some folks might panic their kernel on warning, but with an error we would
> recover just fine by simply aborting JITing process.
> 
Ok, will replace WARN_ONCE() with pr_err() and "return -EFAULT;"

> > +					cnt += emit_nops(&prog, nops);
> > +				}
> >   				EMIT2(jmp_cond, jmp_offset);
> >   			} else if (is_simm32(jmp_offset)) {
> >   				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> > @@ -1431,11 +1462,29 @@ xadd:			if (is_imm8(insn->off))
> >   			else
> >   				jmp_offset = addrs[i + insn->off] - addrs[i];
> > -			if (!jmp_offset)
> > -				/* Optimize out nop jumps */
> > +			if (!jmp_offset) {
> > +				/*
> > +				 * If jmp_padding is enabled, the extra nops will
> > +				 * be inserted. Otherwise, optimize out nop jumps.
> > +				 */
> > +				if (jmp_padding) {
> > +					nops = INSN_SZ_DIFF;
> > +					WARN_ONCE((nops != 0 && nops != 2 && nops != 5),
> > +						  "unexpected nop jump padding: %d bytes\n",
> > +						  nops);
> > +					cnt += emit_nops(&prog, nops);
> > +				}
> >   				break;
> > +			}
> >   emit_jmp:
> >   			if (is_imm8(jmp_offset)) {
> > +				if (jmp_padding) {
> > +					nops = INSN_SZ_DIFF - 2;
> > +					WARN_ONCE((nops != 0 && nops != 3),
> > +						  "unexpected jump padding: %d bytes\n",
> > +						  nops);
> > +					cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
> > +				}
> >   				EMIT2(0xEB, jmp_offset);
> >   			} else if (is_simm32(jmp_offset)) {
> >   				EMIT1_off32(0xE9, jmp_offset);
> > @@ -1578,26 +1627,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> >   	return 0;
> >   }
> > -static void emit_nops(u8 **pprog, unsigned int len)
> > -{
> > -	unsigned int i, noplen;
> > -	u8 *prog = *pprog;
> > -	int cnt = 0;
> > -
> > -	while (len > 0) {
> > -		noplen = len;
> > -
> > -		if (noplen > ASM_NOP_MAX)
> > -			noplen = ASM_NOP_MAX;
> > -
> > -		for (i = 0; i < noplen; i++)
> > -			EMIT1(ideal_nops[noplen][i]);
> > -		len -= noplen;
> > -	}
> > -
> > -	*pprog = prog;
> > -}
> > -
> >   static void emit_align(u8 **pprog, u32 align)
> >   {
> >   	u8 *target, *prog = *pprog;
> > @@ -1970,8 +1999,12 @@ struct x64_jit_data {
> >   	u8 *image;
> >   	int proglen;
> >   	struct jit_context ctx;
> > +	bool padded;
> >   };
> > +#define MAX_PASSES 20
> > +#define PADDING_PASSES (MAX_PASSES - 5)
> > +
> >   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >   {
> >   	struct bpf_binary_header *header = NULL;
> > @@ -1981,6 +2014,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >   	struct jit_context ctx = {};
> >   	bool tmp_blinded = false;
> >   	bool extra_pass = false;
> > +	bool padding = false;
> >   	u8 *image = NULL;
> >   	int *addrs;
> >   	int pass;
> > @@ -2010,6 +2044,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >   		}
> >   		prog->aux->jit_data = jit_data;
> >   	}
> > +	padding = jit_data->padded;
> >   	addrs = jit_data->addrs;
> >   	if (addrs) {
> >   		ctx = jit_data->ctx;
> > @@ -2043,7 +2078,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >   	 * pass to emit the final image.
> >   	 */
> >   	for (pass = 0; pass < 20 || image; pass++) {
> 
> Nit: s/20/MAX_PASSES/ given we have the define now.
> 
Will fix it in v3.

> > -		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> > +		if (!padding && pass >= PADDING_PASSES)
> 
> Shouldn't this rather guard on !extra_pass instead of dragging this info via jit_data->padded?
> 
> What is the rationale for the latter when JIT is called again for subprog to fill in relative
> call locations?
> 
Hmmmm, my thinking was that we only enable padding for those programs
which are already padded before. But, you're right. For the programs
converging without padding, enabling padding won't change the final
image, so it's safe to always set "padding" to true for the extra pass.

Will remove the "padded" flag in v3.

Thanks,

Gary Lin

> > +			padding = true;
> > +		proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> >   		if (proglen <= 0) {
> >   out_image:
> >   			image = NULL;
> > @@ -2097,6 +2134,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >   			jit_data->proglen = proglen;
> >   			jit_data->image = image;
> >   			jit_data->header = header;
> > +			jit_data->padded = padding;
> >   		}
> >   		prog->bpf_func = (void *)image;
> >   		prog->jited = 1;
> > 
> 

