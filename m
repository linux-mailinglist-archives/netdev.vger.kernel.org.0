Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9226414C2
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiLCHfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLCHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:35:36 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B7F8B391;
        Fri,  2 Dec 2022 23:35:34 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3b56782b3f6so69792257b3.13;
        Fri, 02 Dec 2022 23:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RW69/Eb1RsEco8j6fiv/NDxQrnk9LFpX2RWbPfe3wDg=;
        b=Z2PV1GiJ19FWojkxS4HryS0+uS4a9Xk0C0t8NY1/qUa7+XtxlTWVj4arys6pfnMe6U
         hcbxIUk4KCF/HuAiWxyCsNOcteLTfsD/aP3scXIqQo4/Y+JsLFzgrtOBiCnuQXbRmhga
         1iXOcUFrDcdmUhmiRewDT8xrvC6MF8hXnK3RdZN6Ccg96ZXGLbRYNXR5pxoEojoIhAMV
         VxE4VJhyAdegAw/sWhH0JKubFTKxAwZlBW+VzfzOx6PDkvAJzSB/Y30B1xzOWo+C15Yu
         dsbVQihqh657C/1NUcSZdCTGZiUxcS+BsFoJCvFSDqHE81+3yAdkQ5rhJnm5GTUFnJui
         rz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RW69/Eb1RsEco8j6fiv/NDxQrnk9LFpX2RWbPfe3wDg=;
        b=nfyNeoSnQXX0lR8mKfEQE0nSBWxoONhByxka4Uk9krJv7c7WCxGN7wYgnvng7EhhQg
         CUlweUbW7tGTO0VJ+q07FxrkEctU4WLNMhPZFFfN0cnqvwp5sq9jAiTQw5GEjdO25jO3
         WSAKLbH+tX3Tl7lUpuwUh1+52h4/EqTdM5skgZ/mRUAWgGMyjMF3uFKL12D00sQb8M/o
         s2wjrdHEYZ4TNzD2PFNABF3T4L3pa89EULMXADGuK8PVkebblFeduKwspvPB3XS23VPS
         vKrLuUBLcePip70InXIvHfAQ/xrXF7EkqUfnFqOmzPAwJiZqP1yhGhyZCX+7K4zOvuqf
         wG1Q==
X-Gm-Message-State: ANoB5pkhjDZkOivztZ9zJ2mXadQCy2DwDHFIH0RQiPe5iNop0Ejb+vPJ
        xncvkevjIgEhiIIIykOCekZdJbQFvs7X2Oq4+zw=
X-Google-Smtp-Source: AA0mqf7CllcAfLzLp5Ysp8C/fcrodaN5tbw3loIeP4tD23Je7Jok8qKjZ3ZnMXCnc12PBEAzeUw84H02L1DqtiZGCT4=
X-Received: by 2002:a05:690c:312:b0:377:54e8:337d with SMTP id
 bg18-20020a05690c031200b0037754e8337dmr52532405ywb.117.1670052933510; Fri, 02
 Dec 2022 23:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com> <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
 <CAHsH6Gtt4vihaZ5kCFsjT8x1SmuiUkijnVxgAA9bMp4NOgPeAw@mail.gmail.com>
 <4cf2ecd4-2f21-848a-00df-4e4fd86667eb@linux.dev> <CAHsH6Gt=WQhcqTsrDRhVyOSMwc4be5JaY9LpkbtFunvNZx3_Cg@mail.gmail.com>
 <b35e5328-c57f-a5f7-d9cb-eaee1a73991a@linux.dev> <CAHsH6GuRTV1fqPWaeKsqyPgceQAgGiJ39HZ7CiDK1YdmnOU2Tg@mail.gmail.com>
In-Reply-To: <CAHsH6GuRTV1fqPWaeKsqyPgceQAgGiJ39HZ7CiDK1YdmnOU2Tg@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sat, 3 Dec 2022 09:35:22 +0200
Message-ID: <CAHsH6Gu2VgREhgiFwvT8OokuJEt7kxh7ifUnFqPMnwiKOeu4aw@mail.gmail.com>
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

On Sat, Dec 3, 2022 at 5:55 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> Hi Martin,
>
> On Fri, Dec 2, 2022 at 11:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >
> > On 12/2/22 12:49 PM, Eyal Birger wrote:
> > > On Fri, Dec 2, 2022 at 10:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> > >>
> > >> On 12/2/22 11:42 AM, Eyal Birger wrote:
> > >>> Hi Martin,
> > >>>
> > >>> On Fri, Dec 2, 2022 at 9:08 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> > >>>>
> > >>>> On 12/2/22 1:59 AM, Eyal Birger wrote:
> > >>>>> +__used noinline
> > >>>>> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> > >>>>> +                       const struct bpf_xfrm_info *from)
> > >>>>> +{
> > >>>>> +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > >>>>> +     struct metadata_dst *md_dst;
> > >>>>> +     struct xfrm_md_info *info;
> > >>>>> +
> > >>>>> +     if (unlikely(skb_metadata_dst(skb)))
> > >>>>> +             return -EINVAL;
> > >>>>> +
> > >>>>> +     md_dst = this_cpu_ptr(xfrm_md_dst);
> > >>>>> +
> > >>>>> +     info = &md_dst->u.xfrm_info;
> > >>>>> +
> > >>>>> +     info->if_id = from->if_id;
> > >>>>> +     info->link = from->link;
> > >>>>> +     skb_dst_force(skb);
> > >>>>> +     info->dst_orig = skb_dst(skb);
> > >>>>> +
> > >>>>> +     dst_hold((struct dst_entry *)md_dst);
> > >>>>> +     skb_dst_set(skb, (struct dst_entry *)md_dst);
> > >>>>
> > >>>>
> > >>>> I may be missed something obvious and this just came to my mind,
> > >>>>
> > >>>> What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the
> > >>>> md_dst?
> > >>>>
> > >>> Oh I think you're right. I missed this.
> > >>>
> > >>> In order to keep this implementation I suppose it means that the module would
> > >>> not be allowed to be removed upon use of this kfunc. but this could be seen as
> > >>> annoying from the configuration user experience.
> > >>>
> > >>> Alternatively the metadata dsts can be separately allocated from the kfunc,
> > >>> which is probably the simplest approach to maintain, so I'll work on that
> > >>> approach.
> > >>
> > >> If it means dst_alloc on every skb, it will not be cheap.
> > >>
> > >> Another option is to metadata_dst_alloc_percpu() once during the very first
> > >> bpf_skb_set_xfrm_info() call and the xfrm_md_dst memory will never be freed.  It
> > >> is a tradeoff but likely the correct one.  You can take a look at
> > >> bpf_get_skb_set_tunnel_proto().
> > >>
> > >
> > > Yes, I originally wrote this as a helper similar to the tunnel key
> > > helper which uses bpf_get_skb_set_tunnel_proto(), and when converting
> > > to kfuncs I kept the
> > > percpu implementation.
> > >
> > > However, the set tunnel key code is never unloaded. Whereas taking this
> > > approach here would mean that this memory would leak on each module reload
> > > iiuc.
> >
> > 'struct metadata_dst __percpu *xfrm_md_dst' cannot be in the xfrm module.
> > filter.c could be an option.
>
> Looking at it some more, won't the module reference taken by the kfunc btf
> guarantee that the module can't be unloaded while the kfunc is used by a
> loaded program?
>
> I tried this using a synthetic test attaching the program to a dummy interface
> and the module couldn't be unloaded while the program was loaded.
>
> In such case, is it possible for the memory to be freed while there are in-use
> percpu metadata dsts?

Decided to err on the side of caution and avoid the release of the percpu
dsts. It seems unlikely that the module could be unloaded while there are
in flight skbs pointing to the percpu memory, but it's safer not to rely on
this, and the cost is rather minimal, so I agree this is the correct tradeoff.

Eyal.
