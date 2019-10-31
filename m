Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9108EBA7C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJaXgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:36:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42158 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfJaXgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:36:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id s23so1792489pgo.9;
        Thu, 31 Oct 2019 16:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SRicC8gxgrcvSoQaQnNKgH+PvAGWxmFOUhP7quZB9vI=;
        b=u+kyQ+m9kn5x0y3w/gFzJDJ1rKevPqs/uCbnDzktpBTIwTtcDbnMdB9hLgWvmufi8/
         VDGnrrcc+ZDQNqqV5REuWArZf1E+aKed9I1ZIBSVyLBsi6D2vDSQhXlTwYGItQ8L+pxP
         ThBO/HE8GFVJWHV9pPG2eJe0g0m0PXBkyNX83EpV9UGfxDyihO0n9y6vFVTLhwwUHwvt
         JcRBRp697XbCQeWT9QjFPv5duiLR/O6/3mF/miZaSouuiOyhXJHmjJJDO6LXnNZs5QtN
         VMK9aCQeBAGnAZ4gqKSeEg8Q3KeN7lDLMBLTI4IpCnYK7Je6c6nsl7HJqaalpS9HBN3N
         ApzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SRicC8gxgrcvSoQaQnNKgH+PvAGWxmFOUhP7quZB9vI=;
        b=mWMdcoNM7Mhjq0V6Q4NX6tcsfHdj8z+PsyjHPrkE6N6gm1gJt9mfiRY6uvWU6b0zhl
         Xa/jf9NPy2Yr5lAomlMkuBu+XSUSNXt0CESoC4kY32kFT+Yca3KIUVZ5ycGreCdCVf7L
         mN5t74++lueN4UBsVAAaSU5BylDAEabik7VJ4iyC9IbJvp078Wc5a3xKDSZB3WddPCM9
         ysEv837Vlf5eGlVYUNgSwqT2wyZub8qTjxk6KvZSNWdnOsYKQoEPNPlrZTkzCnTre4xq
         2PadXL/1WMd076Se7W1v+zK6+PYkEhUi89lHTbotHoPtwfNtNT3ArJ+ESwqvj7iyXJ9e
         QBxA==
X-Gm-Message-State: APjAAAUeEhL03qug9Hux1eBSGzNLnJxy9Ksa3/4s7+PUdY/lduCmhQ4Q
        VHvZjcaU9Nl4OBnqkFxe7nnuzVnW
X-Google-Smtp-Source: APXvYqwv+SB6WLM7NrKomLDadIKTtk+zGR56wywNTIBvjwd94WByjhoXFz+biEc+QiUEB2+1Qsh33w==
X-Received: by 2002:a63:6d8b:: with SMTP id i133mr9564632pgc.241.1572565005715;
        Thu, 31 Oct 2019 16:36:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:3c2d])
        by smtp.gmail.com with ESMTPSA id t12sm4267007pgv.45.2019.10.31.16.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 16:36:44 -0700 (PDT)
Date:   Thu, 31 Oct 2019 16:36:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with
 prog_tracing
Message-ID: <20191031233642.xnqlz6qjfwzlmilt@ast-mbp.dhcp.thefacebook.com>
References: <20191030223212.953010-1-ast@kernel.org>
 <20191030223212.953010-2-ast@kernel.org>
 <5ef95166-dace-28be-8274-a9343900025e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ef95166-dace-28be-8274-a9343900025e@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 12:20:13AM +0100, Daniel Borkmann wrote:
> On 10/30/19 11:32 PM, Alexei Starovoitov wrote:
> > The bpf program type raw_tp together with 'expected_attach_type'
> > was the most appropriate api to indicate BTF-enabled raw_tp programs.
> > But during development it became apparent that 'expected_attach_type'
> > cannot be used and new 'attach_btf_id' field had to be introduced.
> > Which means that the information is duplicated in two fields where
> > one of them is ignored.
> > Clean it up by introducing new program type where both
> > 'expected_attach_type' and 'attach_btf_id' fields have
> > specific meaning.
> 
> Hm, just for my understanding, the expected_attach_type is unused for
> tracing so far. Are you aware of anyone (bcc / bpftrace / etc) leaving
> uninitialized garbage in there? 

I'm not aware, but the risk is there. Better safe than sorry.
If we need to revert in the future that would be massive.
I'm already worried about new CHECK_ATTR check in raw_tp_open.
Equally unlikely user space breakage, but that one is easy to revert
whereas what you're proposing would mean revert everything.

> Just seems confusing that we have all
> the different tracing prog types and now adding yet another one as
> BPF_RPOG_TYPE_TRACING which will act as umbrella one and again have
> different attach types some of which probably resemble existing tracing
> prog types again (kprobes / kretprobes for example). Sounds like this
> new type would implicitly deprecate all the existing types (sort of as
> we're replacing them with new sub-types)?

All existing once are still supported and may grow its own helpers and what not.
Having new prog type makes things grow independently much easier.
I was thinking to call it BPF_PROG_TYPE_BTF_ENABLED or BPF_PROG_TYPE_GENERIC,
since I suspect upcoming lsm and others will fit right in,
but I think it's cleaner to define categories of bpf programs now
instead of specific purpose types like we had in the past before BTF.

> True that k[ret]probe expects pt_regs whereas BTF enabled program context
> will be the same as raw_tp as well, but couldn't this logic be hidden in
> the kernel e.g. via attach_btf_id as well since this is an opt-in? Could
> the fentry/fexit be described through attach_btf_id as well?

That's what I tried first, but the code grows too ugly.
Also for attaching fentry/fexit I'm adding new bpf_trace_open command
similar to bpf_raw_tp_open, since existing kprobe attach style doesn't
work at all. imo the code is much cleaner now.
I guess it's hard to judge, since you haven't seen my first version
hacking into existing types that I quickly discarded due to messy and
hard to read code logic.

