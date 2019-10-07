Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973B7CD9E7
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 02:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfJGA1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 20:27:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44659 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfJGA1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 20:27:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id i14so7095051pgt.11;
        Sun, 06 Oct 2019 17:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=czcZT6dxXZ+Vqa23wzs7oImXUOO2ucfIZtL/GfvRzmg=;
        b=p5f568iBYcCFDGPwPpDnCzDViJVIRjCe513AzpBQDHvJPEf1lsefSn3RPbz72Tpxxl
         3Jw1Ilbh+qE/3S1Y8WBtLqvNPThD0ljlzBkpIkBiYeDQ4YHz/TMXbKhEJ33kuZEWjZHR
         M4v5LXC7TwBvlSfSS3RbtUeSkK1za0huPepzRtGvf4wpOdZ9UU7NZ2uk8D2pUf/GBaDM
         YT4fOq8ReU3WC5XZ+tiUexsxnagE6z/drNcUbLln6gnykPfiGi/jhNAkovy9pjEFIoGr
         CBD2RLk/roc1g/PTURDAK+P3MuB7FLoS2rB1x0vpsR6Dmr3mwPiqzmzRJ32hu5lGkKB3
         3otw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=czcZT6dxXZ+Vqa23wzs7oImXUOO2ucfIZtL/GfvRzmg=;
        b=UEfwxBJJ+0zTfLIIOeKvX9Rb3uQkkhZbUjnxpfCiGv2uG9JaAv1uh0beF+/b0GX94T
         Aan5oKjm1TowRC4db8zHdOsG/Bb7NyyFZiSuoPnww+BTd5bRWU9jwf4y84Mk+qlY8IxE
         ZaB9nhyTAUPCsYjyF1AEjXQo3zEaDBGCbJeYD42CoWloubOFBKDMBfjTqmJ8sSg/xcU8
         1kdKnRIZy45Zo9iYU7D6kim+0bNFoEGbC/5+YD4DgwCQJJhdDHTgAch046x5kjspCBbr
         FlCsTaYDApkK6PN9NxJnTQnwTePBU4rHjOhnq8CC6KLe6d1EWdd+4WctRPHZJONFaXr0
         dvDA==
X-Gm-Message-State: APjAAAWEyEh+duitHa7YjnxvP7yRsddTFH3ESiVJweHxbfcw6bZ8jKtw
        xoDwSf7Z/WdyQm2vZArqCbY=
X-Google-Smtp-Source: APXvYqzdCT1pvaPTDyhCZqdNnbBCeJKapH5CuslGPsQxNU47XFOZX4LXfKGZyexwFlYZmAyJIAEcrA==
X-Received: by 2002:a63:214e:: with SMTP id s14mr26898145pgm.205.1570408063611;
        Sun, 06 Oct 2019 17:27:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f2c6])
        by smtp.gmail.com with ESMTPSA id q76sm22390168pfc.86.2019.10.06.17.27.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 17:27:42 -0700 (PDT)
Date:   Sun, 6 Oct 2019 17:27:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
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
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into
 BPF programs on load
Message-ID: <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
 <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 07:22:41PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This adds support for injecting chain call logic into eBPF programs before
> they return. The code injection is controlled by a flag at program load
> time; if the flag is set, the verifier will add code to every BPF_EXIT
> instruction that first does a lookup into a chain call structure to see if
> it should call into another program before returning. The actual calls
> reuse the tail call infrastructure.
> 
> Ideally, it shouldn't be necessary to set the flag on program load time,
> but rather inject the calls when a chain call program is first loaded.
> However, rewriting the program reallocates the bpf_prog struct, which is
> obviously not possible after the program has been attached to something.
> 
> One way around this could be a sysctl to force the flag one (for enforcing
> system-wide support). Another could be to have the chain call support
> itself built into the interpreter and JIT, which could conceivably be
> re-run each time we attach a new chain call program. This would also allow
> the JIT to inject direct calls to the next program instead of using the
> tail call infrastructure, which presumably would be a performance win. The
> drawback is, of course, that it would require modifying all the JITs.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
...
>  
> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
> +{
> +	struct bpf_prog *prog = env->prog;
> +	struct bpf_insn *insn = prog->insnsi;
> +	int i, cnt, delta = 0, ret = -ENOMEM;
> +	const int insn_cnt = prog->len;
> +	struct bpf_array *prog_array;
> +	struct bpf_prog *new_prog;
> +	size_t array_size;
> +
> +	struct bpf_insn call_next[] = {
> +		BPF_LD_IMM64(BPF_REG_2, 0),
> +		/* Save real return value for later */
> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +		/* First try tail call with index ret+1 */
> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> +		/* If that doesn't work, try with index 0 (wildcard) */
> +		BPF_MOV64_IMM(BPF_REG_3, 0),
> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> +		/* Restore saved return value and exit */
> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
> +		BPF_EXIT_INSN()
> +	};

How did you test it?
With the only test from patch 5?
+int xdp_drop_prog(struct xdp_md *ctx)
+{
+       return XDP_DROP;
+}

Please try different program with more than one instruction.
And then look at above asm and think how it can be changed to
get valid R1 all the way to each bpf_exit insn.
Do you see amount of headaches this approach has?

The way you explained the use case of XDP-based firewall plus XDP-based
IPS/IDS it's about "knows nothing" admin that has to deal with more than
one XDP application on an unfamiliar server.
This is the case of debugging.
The admin would probably want to see all values xdp prog returns, right?
The possible answer is to add a tracepoint to bpf_prog_run_xdp().
Most drivers have XDP_DROP stats. So some visibility into drops
is already available.
Dumping all packets that xdp prog is dropping into user space via another
xdp application is imo pointless. User space won't be able to process
this rate of packets. Human admin won't be able to "grep" through millions
of packets either.
xdp-firewall prog is dropping the packets for some reason.
That reason is what admin is looking for!
The admin wants to see inside the program.
The actual content of the packet is like bread crumbs.
The authors of xdp firewall can find packet dumps useful,
but poor admin who was tasked to debug unknown xdp application will
not find anything useful in those packets.
I think what you're advocating for is better xdp debugging.
Let's work on that. Let's focus on designing good debugging facility.
This chaining feature isn't necessary for that and looks unlikely to converge.

