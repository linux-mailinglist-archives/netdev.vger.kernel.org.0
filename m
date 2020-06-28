Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58520C985
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgF1SYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 14:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1SYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 14:24:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA20C03E979;
        Sun, 28 Jun 2020 11:24:30 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so7251100pge.12;
        Sun, 28 Jun 2020 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CDyu5XxyUZj+ZAwyaUkvNAVQsuKCLx90g4IgowK3j8I=;
        b=l+uo/daZ87u8J02fhuKrKZ8vlZFo/Wbtdw+K+PcSpeOm6FqHH5j9T2OMnFHpJ81hdI
         +HoR5VKjKg7xpFs+sH2qUId3aI1Nlp4QzNMELcUyYsSOOfoBTtPsZ2D+Cikf3DFZXoKN
         VwyKEB224j9nnmQdgTcKNkF8ByrNj9TkJ4hlY+VMotyUBzwLEoUlutinMiyx+FWBNZ3w
         Ishh1oANf+7PrukmhO1AAF2eCoOdnj3fg3ntCTUmLnxg/ODAGPcfjuiKmxIfBAg04oBE
         QDqSGyN4YG/8GeNCv7DHZHV5zx777wd2YWmfpHqGXhwKr9ar+ZBwj03kZhQElxX/jYgc
         c7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CDyu5XxyUZj+ZAwyaUkvNAVQsuKCLx90g4IgowK3j8I=;
        b=tjokY503g00YNGbmfzBsZ+FmXvmE90wDmZBNUv0hiYw6C8/NQSI3WJk42S0rNBCAdO
         eCwP3cwOqIVL1BInHd6Lvmf0s5Uk5HEnJLQK5RGlSdO1ou6K0bQM0bM238d63Ycs2qw/
         PHZnljG7qFR13dcq8444TTfEJ2YybgxMrNzWvI8SltCGJRZSMqFpZvzaMMJIWaHmvvGp
         7afoeT9OjW3oAsa2szcHeFFmOQAizmAbdZwoIC22aGenBFRNPYrvB0GuwfOJ2uy+qXp4
         Z6I+DXoNzF7WSqA7YOJpLVRWglCx92sy3KT0XGO7JwkgQBrPrfrEbCu2INXAdpkGiYXq
         itww==
X-Gm-Message-State: AOAM5300lGP6MaaAxWs5gTpa8wKeMrS59qgz1gavwffS4s02OvSszxf5
        8iaY16swxa3H0K9t6ZClGgp1le4F
X-Google-Smtp-Source: ABdhPJwSNzlWjP1DUsgRh+08q+7nveKR42Nx/Wo/4AqB1IvjmJkx1UOu1LFvTIDKHXtoHfKECvtchg==
X-Received: by 2002:aa7:9630:: with SMTP id r16mr5808749pfg.144.1593368670425;
        Sun, 28 Jun 2020 11:24:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:616])
        by smtp.gmail.com with ESMTPSA id y69sm32663688pfg.207.2020.06.28.11.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 11:24:29 -0700 (PDT)
Date:   Sun, 28 Jun 2020 11:24:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 04/10] bpf: tcp: Allow bpf prog to write and
 parse BPF TCP header option
Message-ID: <20200628182427.qt7vpjohwkxvixfi@ast-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175526.1461133-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200626175526.1461133-1-kafai@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:55:26AM -0700, Martin KaFai Lau wrote:
> 
> Parsing BPF Header Option
> ─────────────────────────
> 
> As mentioned earlier, the received SYN/SYNACK/ACK during the 3WHS
> will be available to some specific CB (e.g. the *_ESTABLISHED_CB)
> 
> For established connection, if the kernel finds a bpf header
> option (i.e. option with kind:254 and magic:0xeB9F) and the
> the "PARSE_HDR_OPT_CB_FLAG" flag is set,  the
> bpf prog will be called in the "BPF_SOCK_OPS_PARSE_HDR_OPT_CB" op.
> The received skb will be available through sock_ops->skb_data
> and the bpf header option offset will also be specified
> in sock_ops->skb_bpf_hdr_opt_off.

TCP noob question:
- can tcp header have two or more options with the same kind and magic?
I scanned draft-ietf-tcpm-experimental-options-00.txt and it seems
it's not prohibiting collisions.
So should be ok?
Why I'm asking... I think existing bpf_sock_ops style of running
multiple bpf progs is gonna be awkward to use.
Picking the max of bpf_reserve_hdr_opt() from many calls and let
parent bpf progs override children written headers feels a bit hackish.
I feel the users will thank us if we design the progs to be more
isolated and independent somehow.
I was thinking may be each bpf prog will bpf_reserve_hdr_opt()
and bpf_store_hdr_opt() into their own option?
Then during option writing side the tcp header will have two or more
options with the same kind and magic.
Obviously it creates a headache during parsing. Which bpf prog
should be called for each option?

I suspect tcp draft actually prefers all options to have unique kind+magic.
Can we add an attribute to prog load time that will request particular magic ?
Then only that _one_ program will be called for the given kind+magic.
We can still have multiple progs attached to a cgroup (likely root cgroup)
and different progs will take care of parsing and writing their own option.
cgroup attaching side can make sure that multi progs have different magics.

Saving multiple bpf_hdr_opt_off in patch 2 for different magics becomes
problematic. So clearly the implementation complexity shots through the roof
with above proposal, but it feels more flexible and more user friendly?
Not a strong opinion. The feature is great as-is.
