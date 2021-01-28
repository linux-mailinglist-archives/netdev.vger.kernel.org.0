Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7DA3081BC
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 00:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhA1XP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 18:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhA1XP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 18:15:27 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D65C061573;
        Thu, 28 Jan 2021 15:14:44 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id q5so6891645ilc.10;
        Thu, 28 Jan 2021 15:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tUOoiixOlHERyRclinULi6EGJX0DLXiHdqYf6TmzoPQ=;
        b=Fm2YGUDHFksDPi+zCTrDoTv/AwkUmucbRonRbQXwTYHnp9Zyh4WPrKwhL0XcbXsMXF
         RBwUNNkd/fmEciPrFCnTOo6bEbsAQriCI4JN3tlwZWb2NUlFsJQAwpprEbcYHbUrY/fh
         DCwk2Z/Zgq9icKxvU4wNajkW/9QCRzqN9LWIqmo8LXOK4sAWaCj6DCm9iidiiWr41VT5
         3XR9AtKVepR6hEk0e/PfbRy9XOex7jsAKuPOG0It0XwioxqsAQ3U7Z63iohIWq0K1stl
         vRzw67E+uA0EA5XePlpOO3sxgBaGjlh1F/QelFYDBPBPwhUEyCcG0OMfQ5CwxXABUNCM
         ffRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tUOoiixOlHERyRclinULi6EGJX0DLXiHdqYf6TmzoPQ=;
        b=ZUNqqHGogSnSx+h3/EBn0QDPAJAFbpBMQV7sAWUlKGiUddtbsdhavp2RrPk6WcAxQo
         D+Pn28m8i7u8sVGlOZMVzb/kzhRPbu6wc6rGacGNpgBToy/AbAvE2mkwU2pE7wXNzfBi
         aV8vfsIjWP3L8g1nWo25nEvhjiDoJaq+LFsN0wYcDPv7tNHt6h7Ue2QBaPVdgQvJ4bTt
         J7VP1yIyTGh51dxjMq8pdqbzp7gQvIbDtXH4TH13qLJY+uQ1ijoXYVKrmf6YKKtgSQDa
         fgUdJIt+2HsYRwjGmN9tw0L7rEhKBvwwW4vQWCijUlyINcAc1gmznTycksvlEFJmm0MN
         gUSw==
X-Gm-Message-State: AOAM531byHe3ilDwElIlslxSsWQzQxdT2oaAQSNl09H2meXTNODxGhuX
        VrdWpr4cdCEGT8Sxtdm12Js=
X-Google-Smtp-Source: ABdhPJzFXsjEolV4b7EPgRrMdbj/cdHkAXQcxOHKNhkq36+IQ2BOvwrqNuNVAls2LoXRx4HRfH+grw==
X-Received: by 2002:a05:6e02:1608:: with SMTP id t8mr1077080ilu.79.1611875684261;
        Thu, 28 Jan 2021 15:14:44 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id f6sm3067549iov.45.2021.01.28.15.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:14:43 -0800 (PST)
Date:   Thu, 28 Jan 2021 15:14:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <6013455cc1e36_f9c12083b@john-XPS-13-9370.notmuch>
In-Reply-To: <20210128035300.GQ1421720@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-6-liuhangbin@gmail.com>
 <6011e82feb2_a0fd920881@john-XPS-13-9370.notmuch>
 <20210128035300.GQ1421720@Leo-laptop-t470s>
Subject: Re: [PATCHv17 bpf-next 5/6] selftests/bpf: Add verifier tests for bpf
 arg ARG_CONST_MAP_PTR_OR_NULL
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> On Wed, Jan 27, 2021 at 02:24:47PM -0800, John Fastabend wrote:
> > [...]
> > 
> > > +{
> > > +	"ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map",
> > > +	.insns = {
> > > +		BPF_MOV64_IMM(BPF_REG_1, 0),
> > > +		/* bpf_redirect_map_multi arg1 (in_map) */
> > > +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> > > +		/* bpf_redirect_map_multi arg2 (ex_map) */
> > > +		BPF_MOV64_IMM(BPF_REG_2, 0),
> > > +		/* bpf_redirect_map_multi arg3 (flags) */
> > > +		BPF_MOV64_IMM(BPF_REG_3, 0),
> > > +		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
> > > +		BPF_EXIT_INSN(),
> > > +	},
> > > +	.fixup_map_devmap = { 1 },
> > > +	.result = ACCEPT,
> > > +	.prog_type = BPF_PROG_TYPE_XDP,
> > > +	.retval = 4,
> > 
> > Do we need one more case where this is map_or_null? In above
> > ex_map will be scalar tnum_const=0 and be exactly a null. This
> > will push verifier here,
> > 
> >   meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;
> > 
> > In the below case it is known to be not null.
> > 
> > Is it also interesting to have a case where register_is_null(reg)
> > check fails and reg->map_ptr is set, but may be null.
> 
> Hi John,
> 
> I'm not familiar with the test_verifier syntax. Doesn't
> BPF_LD_MAP_FD(BPF_REG_1, 0) just assign the register with map NULL?

On second thought because we are only running the verifier here and
not actually calling the helper I guess both paths are in fact
covered here.

Acked-by: John Fastabend <john.fastabend@gmail.com>
