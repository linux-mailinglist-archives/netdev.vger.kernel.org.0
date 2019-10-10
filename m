Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77148D1FBE
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfJJEmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:42:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43323 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:42:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so3048797pfo.10;
        Wed, 09 Oct 2019 21:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ul6B5sTr9KQC1ANUb+xAoNDJu9lKzfbcshAB5jlCr1k=;
        b=fux9292pnE9lQyfdrhgQn83sAoxZaqhZDojnHT4bBZDxRIwfzoLFBv714cBUO3gP01
         TVRsQQpYG/X7ZgiyDI1iU/rECEiPQw7up+5/7eA3NsypHbQjt2HPRZArWsQ47f9QgMAN
         KJmVrI6CGjJriEVAo+3KNXtCZvmPKaQ5LPT52EAujUDEM4L357mtQm2BS33y0RFWAAEh
         EJqnVW4fBr6dffw5YbfvzRjECXYPRvYYO3s92mOjn1wkbNAjMg9FGCB7DyLfnmXk4UNc
         1AdOlwhxWzeSr7kBLMp0cVbZeFvIkrhQGWD+LBmTHTPL3UVWCXyxREIW5M7QMS91vD/Q
         GU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ul6B5sTr9KQC1ANUb+xAoNDJu9lKzfbcshAB5jlCr1k=;
        b=MULzrUrXLqXk6uhRAiQjR4SBUjvZfenJbG9sCItjTFuOjYVdI4mQSUuvRnBfMxiaPk
         pDdGsKK5/rgQsE+3mc/aUyJLr6l5sePbvCBfzvsTKUjLpc2Mma6JQFBrKjvsUEhN2VL6
         If0pvmomzUGq+pmspApwxVTG59SkmbZeK5RPOk4+n3TPmdM92u7A0N96se+7cHfmx+ux
         chsTBW6LnR0mhxB1HLIrUj5dsjUX9lBadJsbW+t7SHmeEG7kauph/Ikn7zrdu5gZHNmm
         P54PZ6+n/j8Ny1pJXpEaKysh1V3WUVrUHoZ6YXnGsGCNcE2t5/y2fvL6eFnVb+w4Vz0C
         IfaQ==
X-Gm-Message-State: APjAAAWrwjb0PMzse87pf262osvZXkKSdyFlykYUJF8WYfusBx6md4bR
        DXUmnjqbsxVehI25mOW1cil9FjG9
X-Google-Smtp-Source: APXvYqyDqIVTZ2PBykOpjwTgErPEEj8r7vjfaGyIZMRLmqdSeL7Xvu1Pd22rAv7RH+0c/GMMS/yEhg==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr8838120pgm.421.1570682521719;
        Wed, 09 Oct 2019 21:42:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::7c62])
        by smtp.gmail.com with ESMTPSA id 184sm3621350pgf.33.2019.10.09.21.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 21:42:00 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:41:58 -0700
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
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8yqjqg0.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > Please implement proper indirect calls and jumps.
> 
> I am still not convinced this will actually solve our problem; but OK, I
> can give it a shot.

If you're not convinced let's talk about it first.

Indirect calls is a building block for debugpoints.
Let's not call them tracepoints, because Linus banned any discusion
that includes that name.
The debugpoints is a way for BPF program to insert points in its
code to let external facility to do tracing and debugging.

void (*debugpoint1)(struct xdp_buff *, int code);
void (*debugpoint2)(struct xdp_buff *);
void (*debugpoint3)(int len);

int bpf_prog(struct xdp_buff *ctx)
{
    // let's parse the packet
    if (debugpoint3)
        debugpoint3(ctx->data_end - ctx->data);

    if (condition) {
        // deciding to drop this packet
        if (debugpoint1)
            debugpoint1(ctx, XDP_DROP);
        return XDP_DROP;
    }
    if (some other condition) {
        // lets pass it to the stack
        if (debugpoint2)
            debugpoint2(ctx);
        return XDP_PASS;
    }
}

In normal operation nothing is being called.
The execution cost to the program is load plus branch.
But since program is annotated with BTF the external tool,
like bpftool, can load another program and populate
debugpointN pointer in the original program to trace its
execution.
Essentially it's live debugging (tracing) of cooperative
bpf programs that added debugpoints to their code.

Obviously indirect calls can be used for a ton of other things
including proper chaing of progs, but I'm convinced that
you don't need chaining to solve your problem.
You need debugging.
If you disagree please explain _your_ problem again.
Saying that fb katran is a use case for chaining is, hrm, not correct.

