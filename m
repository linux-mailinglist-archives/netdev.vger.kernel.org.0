Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C473FF5967
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKHVOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:14:05 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34222 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbfKHVOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:14:05 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so5503118pff.1;
        Fri, 08 Nov 2019 13:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IkOG4wMelMkdtz15a0RzG5RgUJm6TFFa3nFHB4ADVL0=;
        b=Odzw2l/KwJOgPla7N9s4JzT5cdbQRiI5jg3Urp7zeQcENpOI5zm8m/8GFDunaFSpNB
         IMeXYd87wN8V7bcAwzW4zeznp+sWaDOicCPLc2xqPKG/PHVQaoNRzjZC4uvhzqx9Sch8
         fCWPxa7XLEiN7j4WmdVNbplKk469qKKf4qRhhyFVdy3mbYnIH/qXYm/Ti6+uOIPQn0ul
         J+JhfHk3I6tM/pxeX/4Pyesi23XA8lmt4W+WEHukdmYrcTf0ZagOYqorTapRwtFVWa7C
         rQPQvplfjz6RDOHYxNIfbn+PXXZ21ttCircZPmrobaAoLTrhlv1p68IpRjPw5E5nChRe
         TzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IkOG4wMelMkdtz15a0RzG5RgUJm6TFFa3nFHB4ADVL0=;
        b=fLaItdzYiUw6RNyETuNGn/XUOfahyz2HsVJNP4mM4HC3TdQHbtv9kClAWQre44SNE5
         ptykOVqpY8kUMthSxyjFO36ekgdRDqejJNhqvBA8Qs2jq0lOnkUxh3ueVCiGp7YfM2u7
         i33SUM5fBO4FLEuu+MHbgoCgp/33mm9c+zhXN6CN7eSnIQAnfUhwdO6nGA2BilD3i8dd
         JKFHTZEx8jlRboi1Byu/cpdUv+0C8LzahFumXK3pEanje3ccWMh/hKLjVpqo8vQEBmmG
         5ShtkFA9ft9UH03j3TXHTEbo3x0BZL+SEIql9L57/4YkendumpQlCNPRUtrgdC2YKhie
         bcpQ==
X-Gm-Message-State: APjAAAV29QQGsGoPOlAMuF++OCjxpzlD11hP6sMkyLLkfcOLPhaOtGGO
        5dWDlGjuiAJJoqeJGDNXLbY=
X-Google-Smtp-Source: APXvYqxmtjzodCX277us50CIxM4qAb+YH01OR6UmaZO+JOMdAaBwQBxgf7LQwGO0tBAciLcqpOGY8A==
X-Received: by 2002:a63:1065:: with SMTP id 37mr14190425pgq.31.1573247644500;
        Fri, 08 Nov 2019 13:14:04 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:f248])
        by smtp.gmail.com with ESMTPSA id p5sm6030812pgb.14.2019.11.08.13.14.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 13:14:03 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:14:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Message-ID: <20191108211400.m6kuuyvkp2p56gmo@ast-mbp.dhcp.thefacebook.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-16-ast@kernel.org>
 <87pni2ced3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pni2ced3.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 09:17:12PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@kernel.org> writes:
> 
> > Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any type
> > including their subprograms. This feature allows snooping on input and output
> > packets in XDP, TC programs including their return values. In order to do that
> > the verifier needs to track types not only of vmlinux, but types of other BPF
> > programs as well. The verifier also needs to translate uapi/linux/bpf.h types
> > used by networking programs into kernel internal BTF types used by FENTRY/FEXIT
> > BPF programs. In some cases LLVM optimizations can remove arguments from BPF
> > subprograms without adjusting BTF info that LLVM backend knows. When BTF info
> > disagrees with actual types that the verifiers sees the BPF trampoline has to
> > fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> > program can still attach to such subprograms, but won't be able to recognize
> > pointer types like 'struct sk_buff *' into won't be able to pass them to
> > bpf_skb_output() for dumping to user space.
> >
> > The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it's set
> > to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_fd
> > points to previously loaded BPF program the attach_btf_id is BTF type id of
> > main function or one of its subprograms.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> This is cool! Certainly solves the xdpdump use case; thanks!
> 
> I do have a few questions (thinking about whether it can also be used
> for running multiple XDP programs):

excellent questions.

> - Can a FEXIT function loaded this way only *observe* the return code of
>   the BPF program it attaches to, or can it also change it?

yes. the verifier can be taught to support that for certain class of programs.
That needs careful thinking to make sure it's safe.

> - Is it possible to attach multiple FENTRY/FEXIT programs to the same
>   XDP program 

Yes. Already possible. See fexit_stress.c that attaches 40 progs to the same
kernel function. Same thing when attaching fexit BPF to any XDP program.
Since all of them are read only tracing prog all progs have access to skb on
input and ouput along with unmodified return value.

> and/or to recursively attach FENTRY/FEXIT programs to each
>   other?

Not right now to avoid complex logic of detecting cycles. See simple bit:
   if (tgt_prog->type == BPF_PROG_TYPE_TRACING) {
           /* prevent cycles */
           verbose(env, "Cannot recursively attach\n");

> - Could it be possible for an FENTRY/FEXIT program to call into another
>   XDP program (i.e., one that has the regular XDP program type)?

It's possible to teach verifier to do that, but we probably shouldn't take that
route. Instead I've started exploring the idea of dynamic linking. The
trampoline logic will be used to replace existing BPF program or subprogram
instead of attaching read-only to it. If types match the new program can
replace existing one. The concept allows to build any kind of callchain
programmatically. Pretty much what Ed proposed with static linking, but doing
it dynamically. I'll start a separate email thread explaining details.

