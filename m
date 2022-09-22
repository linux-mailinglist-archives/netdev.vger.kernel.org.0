Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD05E5CCB
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIVIBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiIVIA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:00:59 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCF685AB7;
        Thu, 22 Sep 2022 01:00:58 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a67so11607638ybb.3;
        Thu, 22 Sep 2022 01:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3oP1QkyQogUqbd7txk3r32kAVm+/kI9pBniGW5zsUYs=;
        b=mzKY9rZ+m6Q5r/D86LDMWGiqX0e9nCWM0o0tycTO9slkQ5yRuMeU0j+p2OY9jE/Pl7
         1eNpt78zEVPGYaOFMwMMjcpkTN1ZkEKJF2n8hj3x3S4erU9UTwnrrWJc7JeW4m07ibWa
         1Qq3q01UGJ3iikkxgCvBM/AtejFeqBk7eA/l29YkYcitljKAIwZ8pf9CkoQTR4vyeVg6
         7BSCxBWZr/Wv3vb8ODNgpn54Wu46UhoD+Ufjht7Xg1TOo9xoFxIYZEWoHVA/yKnPHmtv
         HMvkflC8XbCP3eDkm3L6i86OrYZ3LM0iD+bPmfi0KEPZzxhH0SHAjHTQDFD8HZ1cIzIy
         D/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3oP1QkyQogUqbd7txk3r32kAVm+/kI9pBniGW5zsUYs=;
        b=jxDqlRCDnZAwFKfXAotWV6C1jge6m5OZF0546blycGR4cOr6KCr/DvUB9Dat8B5iSL
         P/1tFg40C/qL1YjvDEotZFTQeNyF9rNGt03L8cLL6lM3XUrYjgTnpbB3ersb2HJplqAc
         m125hd4WAB9sheEfrr0EelWPeyF680Jklf5NMdK/FFnoMw9wNECT//RGLMcVJLPjFnqD
         pWKUYVDpRPPT7Vov7JUUUJ/PuF50U6G2eoPOPUZILCQ0MA9zs1hip6IM1wpJIUZMDAXV
         qA1ltDdpLlSE5oQUUsUywdzSIxJ+szStmUphOTL2CzcfWv+xykSMA3uz9+g0qqjf5x02
         3mlA==
X-Gm-Message-State: ACrzQf1BdvFqZ9MqBh7+JIcdNE8hRVRuY9+zRJSW9cRBZuouQ95BkNcG
        wsic0tDTlAmbFuqWIwQJUfE5mBYIzmpPRJjemBK6/bhS
X-Google-Smtp-Source: AMsMyM5xiGeHeRSkmgFgjjAuDOrPNwavgO+if4Gw//dbT7EY5oQm8PPWL2ADWaAJNsyoRDXfNSJnL9JAbKwe8td9j9w=
X-Received: by 2002:a25:b44a:0:b0:695:bd50:9c2d with SMTP id
 c10-20020a25b44a000000b00695bd509c2dmr2324792ybg.495.1663833657534; Thu, 22
 Sep 2022 01:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663778601.git.lorenzo@kernel.org> <cdede0043c47ed7a357f0a915d16f9ce06a1d589.1663778601.git.lorenzo@kernel.org>
 <CAADnVQJY4pibr5PkoTFhpYDj8pBJ1mTPuR9VSeKQXuJqeh6d3Q@mail.gmail.com>
In-Reply-To: <CAADnVQJY4pibr5PkoTFhpYDj8pBJ1mTPuR9VSeKQXuJqeh6d3Q@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 22 Sep 2022 10:00:20 +0200
Message-ID: <CAP01T76Vsbo-8zO=K4EGNR-iJutqPSVV0trgMVYXbEtV=f_19w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: Tweak definition of KF_TRUSTED_ARGS
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sept 2022 at 04:39, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 21, 2022 at 9:49 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > +               /* These register types have special constraints wrt ref_obj_id
> > +                * and offset checks. The rest of trusted args don't.
> > +                */
> > +               obj_ptr = reg->type == PTR_TO_CTX || reg->type == PTR_TO_BTF_ID ||
> > +                         reg2btf_ids[base_type(reg->type)];
> > +
>
> ..
>
> >                 /* Check if argument must be a referenced pointer, args + i has
> >                  * been verified to be a pointer (after skipping modifiers).
> > +                * PTR_TO_CTX is ok without having non-zero ref_obj_id.
> >                  */
>
> Kumar,
>
> Looking forward to your subsequent patch to split this function.
> It's definitely getting unwieldy.
>
> The comment above is double confusing.
> 1. I think you meant to say "PTR_TO_CTX is ok with zero ref_obj_id",
> right? That double negate is not easy to parse.
>

Yes.

> 2.
> PTR_TO_CTX cannot have ref_obj_id != 0.
> At least I don't think it's possible, but the comment implies
> that such a case may exist.
>

Yes, but we are checking for that later, which is why we skip it for PTR_TO_CTX.

> I applied anyway, since big refactoring is coming shortly, right?

Yes, which is why I tacked it on like this for now. I will be
reposting later this week.

Thanks!
