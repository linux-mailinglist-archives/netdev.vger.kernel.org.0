Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24A7641410
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 04:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiLCDz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 22:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiLCDzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 22:55:55 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B306EBF923;
        Fri,  2 Dec 2022 19:55:54 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id c140so8236281ybf.11;
        Fri, 02 Dec 2022 19:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kHS6CLXWQpHB/BJrAaxuJc2OY8x0uiv3R6/NvgJ6/hA=;
        b=gPXmkV5OmTUmcB0Uyl80A0/dVUXa2NLAhnXApMvHwKMh9Kmnog48hjw7Db1oe13aXH
         FXI8/ZlVaZPQnALjZryRuuOpBfJgkcfPHNVBIQi41h7oAasx5NaGamlfCjTd9JCh9ut7
         Bcdx4i74ezZmE2B3qnsytKk7i1a3sJRf89sjrQ9E7wn7VF7GkmpHBjQmFDcHxSMjcAoa
         UDettIVR8P6HBr2Jt1hhdOmgzDw4lswZKk2pDkdLLK6FezI2lBBN6ymUqqUMgHjSJmWl
         d1yrD28PDFKaxnHt5qoqvfeWm7Me2EC3ebQ9oJ9+ZgfBBtOcepyuWiDVsVcWAIsTXne0
         VW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kHS6CLXWQpHB/BJrAaxuJc2OY8x0uiv3R6/NvgJ6/hA=;
        b=2gQLhlfmJ9VBzqmi1xW8vAfbhaLzd1mVQVhXzkUyWINd3s0cj3AbwnZQmjNGbJ5h7p
         rnsMJAvhLhX+p717gaEtMk0S4aWkf6KS/WWiJB9pqlJTuO1+lJbUwuEkTaLSVH7DMlG3
         jYyLy7/gIpyu0KsOmn6oJxB81aV4YbySfgVdgwZPszdTwonvY7tX4mg0gkC+pbdbOn7P
         7l/rGw5ubeO4qfku0dzrooQhNj0sdjIxGUKjSnGcUiGs2FDf9Kic1IJskVcLtalppeoC
         j0u+JpwommEqgP0jnZcxKFI4zM4G6IzfXfh1KbolStt1DxOVwPM8xmwC6KvfgV/aBD/+
         AVpQ==
X-Gm-Message-State: ANoB5pmBWwo+XokHvrEsHJayS8IfZ/8nRDeJB3yDY6ZYaXx7L9CRR/9I
        ln0gBji4m+BFIpBmy5vOGYFwkOYUO18ox0rUAco=
X-Google-Smtp-Source: AA0mqf77CwzLriATDu/S5/3TAJXdCBpTETjQlqAi3OyLTGJP5TAUUxTFVcGXMNbJWz8CvvXaLsIE8J4FWf8B2hEQRtU=
X-Received: by 2002:a25:9e0b:0:b0:6e8:1d39:f445 with SMTP id
 m11-20020a259e0b000000b006e81d39f445mr68025282ybq.7.1670039753610; Fri, 02
 Dec 2022 19:55:53 -0800 (PST)
MIME-Version: 1.0
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com> <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
 <CAHsH6Gtt4vihaZ5kCFsjT8x1SmuiUkijnVxgAA9bMp4NOgPeAw@mail.gmail.com>
 <4cf2ecd4-2f21-848a-00df-4e4fd86667eb@linux.dev> <CAHsH6Gt=WQhcqTsrDRhVyOSMwc4be5JaY9LpkbtFunvNZx3_Cg@mail.gmail.com>
 <b35e5328-c57f-a5f7-d9cb-eaee1a73991a@linux.dev>
In-Reply-To: <b35e5328-c57f-a5f7-d9cb-eaee1a73991a@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sat, 3 Dec 2022 05:55:42 +0200
Message-ID: <CAHsH6GuRTV1fqPWaeKsqyPgceQAgGiJ39HZ7CiDK1YdmnOU2Tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next,v4 2/4] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
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

Hi Martin,

On Fri, Dec 2, 2022 at 11:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/2/22 12:49 PM, Eyal Birger wrote:
> > On Fri, Dec 2, 2022 at 10:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>
> >> On 12/2/22 11:42 AM, Eyal Birger wrote:
> >>> Hi Martin,
> >>>
> >>> On Fri, Dec 2, 2022 at 9:08 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>>>
> >>>> On 12/2/22 1:59 AM, Eyal Birger wrote:
> >>>>> +__used noinline
> >>>>> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> >>>>> +                       const struct bpf_xfrm_info *from)
> >>>>> +{
> >>>>> +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> >>>>> +     struct metadata_dst *md_dst;
> >>>>> +     struct xfrm_md_info *info;
> >>>>> +
> >>>>> +     if (unlikely(skb_metadata_dst(skb)))
> >>>>> +             return -EINVAL;
> >>>>> +
> >>>>> +     md_dst = this_cpu_ptr(xfrm_md_dst);
> >>>>> +
> >>>>> +     info = &md_dst->u.xfrm_info;
> >>>>> +
> >>>>> +     info->if_id = from->if_id;
> >>>>> +     info->link = from->link;
> >>>>> +     skb_dst_force(skb);
> >>>>> +     info->dst_orig = skb_dst(skb);
> >>>>> +
> >>>>> +     dst_hold((struct dst_entry *)md_dst);
> >>>>> +     skb_dst_set(skb, (struct dst_entry *)md_dst);
> >>>>
> >>>>
> >>>> I may be missed something obvious and this just came to my mind,
> >>>>
> >>>> What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the
> >>>> md_dst?
> >>>>
> >>> Oh I think you're right. I missed this.
> >>>
> >>> In order to keep this implementation I suppose it means that the module would
> >>> not be allowed to be removed upon use of this kfunc. but this could be seen as
> >>> annoying from the configuration user experience.
> >>>
> >>> Alternatively the metadata dsts can be separately allocated from the kfunc,
> >>> which is probably the simplest approach to maintain, so I'll work on that
> >>> approach.
> >>
> >> If it means dst_alloc on every skb, it will not be cheap.
> >>
> >> Another option is to metadata_dst_alloc_percpu() once during the very first
> >> bpf_skb_set_xfrm_info() call and the xfrm_md_dst memory will never be freed.  It
> >> is a tradeoff but likely the correct one.  You can take a look at
> >> bpf_get_skb_set_tunnel_proto().
> >>
> >
> > Yes, I originally wrote this as a helper similar to the tunnel key
> > helper which uses bpf_get_skb_set_tunnel_proto(), and when converting
> > to kfuncs I kept the
> > percpu implementation.
> >
> > However, the set tunnel key code is never unloaded. Whereas taking this
> > approach here would mean that this memory would leak on each module reload
> > iiuc.
>
> 'struct metadata_dst __percpu *xfrm_md_dst' cannot be in the xfrm module.
> filter.c could be an option.

Looking at it some more, won't the module reference taken by the kfunc btf
guarantee that the module can't be unloaded while the kfunc is used by a
loaded program?

I tried this using a synthetic test attaching the program to a dummy interface
and the module couldn't be unloaded while the program was loaded.

In such case, is it possible for the memory to be freed while there are in-use
percpu metadata dsts?

Eyal.
