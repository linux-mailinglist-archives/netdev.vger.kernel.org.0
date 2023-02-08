Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7B68FB19
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBHXXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBHXXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:23:05 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2616F12F10;
        Wed,  8 Feb 2023 15:23:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id lu11so1542109ejb.3;
        Wed, 08 Feb 2023 15:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X1n7NNor3zS2ODqtpCXJROvyu+9CFBDKnMybRjAFIPg=;
        b=FGM/knYfNDUAtPxi75lCFS1RDqLvwiPJdQ6FfERl5ejRKDNPfUjQE1paZSk2hcW3Vx
         fRS72h16BJeOhF//JWZuBZdc2B5Or0MWicILrVLTRNgv/aO2LkmOkuTwtgXEib4HMvBI
         fv58QP2MNDva5X1+aF+hiB4NDwasNNcyLkshtiUMxfoMEvtcH/3qCHCZDTogzfMJvwC5
         P1ktibclIBsVxYQR3hj+ebukJanrsCzGTjugeUmc5clKhJ7EudUs5Mns8B7+gbO5Z4DP
         Jw+5k5/ajUeWCawpmlS3hsyOwHRKmdV3Nb/F727M3V4NLsrXTymM5NNVQZfgU9QZ7aYU
         lykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X1n7NNor3zS2ODqtpCXJROvyu+9CFBDKnMybRjAFIPg=;
        b=A8H3T7hfc7pVrkeBBL54l9OU678HMGx8CFyXRFrWFqOrkAQsqhun0v8OnGKEbGekp4
         5O8J+450BUbj/BPUe5sU6AduXGNfINTq9cmEIas0QFxcSdHva58Kzmlugn6WRusss8SG
         1D+y1ESzRlE7KN8VodxwsiV6qLpHsphYLD2FBBbbKBj45ZPU41CCjV2+AcT6VVbB/vY3
         BHAJy+zWV6Cl7ZAUhB/L8ZiUZk/2OJj2lPEInOgxdMvDDGbKpdaOBEo6zVahcGXeqZi2
         FbDGVvQWDKkp7rNVxSJEdVwruCiT48H+pyRYrS4f/zovamthkm3o0ulWRKLwBUT960ec
         jTcw==
X-Gm-Message-State: AO0yUKV4BmmJgpWPCP/DFUk3F7IDbgZEwhHi4zkaKgMd3oZAVyxueHKU
        tJxLGbFICvVjdVbg0ROIhyJDovXsuw7oXuJWO+QEU4WJcqU=
X-Google-Smtp-Source: AK7set9GEmhdEFXZqKETwRPf2Gm9FPpSetM+Kv1huiP5DmCeyDVvfYwL6WiLlzdfzTJizx4pyEbHTbmCqza2aSFhFos=
X-Received: by 2002:a17:906:eb8f:b0:878:786e:8c39 with SMTP id
 mh15-20020a170906eb8f00b00878786e8c39mr2226891ejb.105.1675898582447; Wed, 08
 Feb 2023 15:23:02 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
 <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com>
 <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com> <CAJnrk1bxm3_QQFK_aqiApiu5vYC+z++jRj9HF2jO6a+WWkswpQ@mail.gmail.com>
In-Reply-To: <CAJnrk1bxm3_QQFK_aqiApiu5vYC+z++jRj9HF2jO6a+WWkswpQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 8 Feb 2023 15:22:50 -0800
Message-ID: <CAADnVQJYOR7YMEFV7c1e4p8hvrEmoa3VA2wp0oJSgmuAjSF+EA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>
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

On Wed, Feb 8, 2023 at 1:47 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 9:54 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 9:36 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> > > > On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> [...]
> > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > index 6da78b3d381e..ddb47126071a 100644
> > > > > > --- a/net/core/filter.c
> > > > > > +++ b/net/core/filter.c
> > > > > > @@ -1684,8 +1684,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
> > > > > >               skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
> > > > > >  }
> > > > > >
> > > > > > -BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> > > > > > -        const void *, from, u32, len, u64, flags)
> > > > > > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > > > > > +                       u32 len, u64 flags)
> > > > >
> > > > > This change is just to be able to call __bpf_skb_store_bytes() ?
> > > > > If so, it's unnecessary.
> > > > > See:
> > > > > BPF_CALL_4(sk_reuseport_load_bytes,
> > > > >            const struct sk_reuseport_kern *, reuse_kern, u32, offset,
> > > > >            void *, to, u32, len)
> > > > > {
> > > > >         return ____bpf_skb_load_bytes(reuse_kern->skb, offset, to, len);
> > > > > }
> > > > >
> > > >
> > > > There was prior feedback [0] that using four underscores to call a
> > > > helper function is confusing and makes it ungreppable
> > >
> > > There are plenty of ungreppable funcs in the kernel.
> > > Try finding where folio_test_dirty() is defined.
> > > mm subsystem is full of such 'features'.
> > > Not friendly for casual kernel code reader, but useful.
> > >
> > > Since quadruple underscore is already used in the code base
> > > I see no reason to sacrifice bpf_skb_load_bytes performance with extra call.
> >
> > I don't have a preference either way, I'll change it to use the
> > quadruple underscore in the next version
>
> I think we still need these extra __bpf_skb_store/load_bytes()
> functions, because BPF_CALL_x static inlines the
> bpf_skb_store/load_bytes helpers in net/core/filter.c, and we need to
> call these bpf_skb_store/load_bytes helpers from another file
> (kernel/bpf/helpers.c). I think the only other alternative is moving
> the BPF_CALL_x declaration of bpf_skb_store/load bytes to
> include/linux/filter.h, but I think having the extra
> __bpf_skb_store/load_bytes() is cleaner.

bpf_skb_load_bytes() is a performance critical function.
I'm worried about the cost of the extra call.
Will compiler be smart enough to inline __bpf_skb_load_bytes()
in both cases? Probably not if they're in different .c files.
Not sure how to solve it. Make it a static inline in skbuff.h ?
