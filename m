Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A42CDEE2
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfJGKLg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Oct 2019 06:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbfJGKLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:11:35 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1CAFC057F2C
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 10:11:34 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id l13so3313254lji.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 03:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xFJfvxGSxXmlG8uRezCO6P2oPcGamXrw9xhVuelSmow=;
        b=Oac5V7LbyDNMRi/fo5oc+WdxRNPDwsEGElHoDsgzP84YD7v4vrmHWMRZe99M6p7UOC
         YczNemUPiN7gs5jKOpT53NLRmVrIxKJ5dMhcMfW+PP6tWQOQTHeGoS5jPLQsrL9quD7O
         Ump+aHSh4kIdZ5MXYHJwFZGENCMuM9SL/OOlKX0pSeb+TH2KOEjmwQgsN6slhXXSjHAS
         FTRcT+8jmfTkn7LpcDEFR2rZIGvo+rvdCQpqbGPvP2r8AvIhZohX7pl787O8xLVF1gEM
         I2muG+L8oZV7P302O/snJZWphkc8ENSzxB66mQtr2DtyERDFnd6V/v5UR43gDDSs0cx2
         t6NQ==
X-Gm-Message-State: APjAAAX48GHALIKBCYgAFW43CHLRiTdObJEgyoOW4crP6yY31uwy9xXg
        4HBy6UdIYoPCAehFym4UTn/eXpPWdSmSTB0qDAxqgaVIDqmVrAXQRrT/4d7BxXx0u8sKhj7nA81
        a8nkYHtM0+8Ttm6DL
X-Received: by 2002:ac2:5dd0:: with SMTP id x16mr16758748lfq.38.1570443093368;
        Mon, 07 Oct 2019 03:11:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx2gFbEXRiqKPPXrCBizFB8ImxCZF7nNRmfGN7yLgLUqd2Ermfi23xtdcLo32ef7jpQ9FBUOw==
X-Received: by 2002:ac2:5dd0:: with SMTP id x16mr16758719lfq.38.1570443093110;
        Mon, 07 Oct 2019 03:11:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 6sm2650023lfa.24.2019.10.07.03.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 03:11:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 52EA518063D; Mon,  7 Oct 2019 12:11:31 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into BPF programs on load
In-Reply-To: <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1> <157020976144.1824887.10249946730258092768.stgit@alrua-x1> <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Oct 2019 12:11:31 +0200
Message-ID: <87h84kn9v0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Oct 04, 2019 at 07:22:41PM +0200, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> This adds support for injecting chain call logic into eBPF programs before
>> they return. The code injection is controlled by a flag at program load
>> time; if the flag is set, the verifier will add code to every BPF_EXIT
>> instruction that first does a lookup into a chain call structure to see if
>> it should call into another program before returning. The actual calls
>> reuse the tail call infrastructure.
>> 
>> Ideally, it shouldn't be necessary to set the flag on program load time,
>> but rather inject the calls when a chain call program is first loaded.
>> However, rewriting the program reallocates the bpf_prog struct, which is
>> obviously not possible after the program has been attached to something.
>> 
>> One way around this could be a sysctl to force the flag one (for enforcing
>> system-wide support). Another could be to have the chain call support
>> itself built into the interpreter and JIT, which could conceivably be
>> re-run each time we attach a new chain call program. This would also allow
>> the JIT to inject direct calls to the next program instead of using the
>> tail call infrastructure, which presumably would be a performance win. The
>> drawback is, of course, that it would require modifying all the JITs.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ...
>>  
>> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
>> +{
>> +	struct bpf_prog *prog = env->prog;
>> +	struct bpf_insn *insn = prog->insnsi;
>> +	int i, cnt, delta = 0, ret = -ENOMEM;
>> +	const int insn_cnt = prog->len;
>> +	struct bpf_array *prog_array;
>> +	struct bpf_prog *new_prog;
>> +	size_t array_size;
>> +
>> +	struct bpf_insn call_next[] = {
>> +		BPF_LD_IMM64(BPF_REG_2, 0),
>> +		/* Save real return value for later */
>> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
>> +		/* First try tail call with index ret+1 */
>> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
>> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
>> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> +		/* If that doesn't work, try with index 0 (wildcard) */
>> +		BPF_MOV64_IMM(BPF_REG_3, 0),
>> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> +		/* Restore saved return value and exit */
>> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
>> +		BPF_EXIT_INSN()
>> +	};
>
> How did you test it?
> With the only test from patch 5?
> +int xdp_drop_prog(struct xdp_md *ctx)
> +{
> +       return XDP_DROP;
> +}
>
> Please try different program with more than one instruction.
> And then look at above asm and think how it can be changed to
> get valid R1 all the way to each bpf_exit insn.
> Do you see amount of headaches this approach has?

Ah yes, that's a good point. It seems that I totally overlooked that
issue, somehow...

> The way you explained the use case of XDP-based firewall plus XDP-based
> IPS/IDS it's about "knows nothing" admin that has to deal with more than
> one XDP application on an unfamiliar server.
> This is the case of debugging.

This is not about debugging. The primary use case is about deploying
multiple, independently developed, XDP-enabled applications on the same
server.

Basically, we want the admin to be able to do:

# yum install MyIDS
# yum install MyXDPFirewall

and then have both of those *just work* in XDP mode, on the same
interface.

I originally started solving this in an XDP-specific way (v1 of this
patch set), but the reactions to that was pretty unanimous that this
could be useful as a general eBPF feature. Do you agree with this?

-Toke
