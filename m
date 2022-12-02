Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE0640EA1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbiLBTmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiLBTmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:42:23 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA5E8E09;
        Fri,  2 Dec 2022 11:42:22 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3691e040abaso58892387b3.9;
        Fri, 02 Dec 2022 11:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nwslupv40/QslSuQOvoaHr7g0djmRhPH/x5tIV1JjRQ=;
        b=lloZWMXgZH/wsPqIA2THx1gZqqhEiDALXJnH7i/rWcmUc9KqU9s6pwMgoafasSINpR
         FNbP18Wc6E1VpYX9DqEmVt656mzGrZAvIaAA9IUb03/ueG5Feb0DClqLLnUq0PdE3vT+
         fkVMSqtVhjmg1rbHqN6PCnVZmTPItDCn4oMBGdd8GS/Dy1/Ys+huZ+yj3cpJHTnJEcRA
         xr7rcdUZ8Lb6A0htEpulBq3glzvwRMDmpVa1s0/ek05/4Sn8sGN4xc0Tk24n5iqibWoW
         SNj+TJvGSv3908gja90BuOOcShYrVeJ2LMnHEBlNwUY1zx+u3FgPlK0PV2cR+QOi2qs2
         zM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nwslupv40/QslSuQOvoaHr7g0djmRhPH/x5tIV1JjRQ=;
        b=nRxNpkkd2QkXywfRAUc1fHIYojO5GJfaZQJHsq4F6V5z0xxqPE4NMkWMXhdTLUcvuh
         yw3415NKBPciQf4KgwFogoxFU6mq2PoRMlGVevg7i64WXTL4RXTk+rSsAPGhKp4KLgAl
         YvDApzRM4EkG21dbLeRCNJKrc/jjzJi9PzlFehIdnYRq1LXHRpSP1F1PiQouAnsGtwIL
         +ajn0MJHR9yoNOQL7onOnSgAg+LNUukiFlZO/tJCxZt5HqC+J9lrgve/IXUlYBymjL7G
         Jxd2Ha+ywlhyDUmT8sK9jwffN2/MR7MlE1+NseKEt2Y8ga6at7p3fg4t80DufiqHm58V
         aLcg==
X-Gm-Message-State: ANoB5pkfYDLjljPxmihfBVcA5uSMq692mL51yP8uuefW2job92hGRuwc
        o3qDXYKbJMOIo72mEs6XWwVjIqh5cX9/KtLbWK4=
X-Google-Smtp-Source: AA0mqf51NzgiF1kUqyUWX67d1QzhgNNzAlipiSJVZeHKmlVs9nfCrwhGxSdWwML483/LCF/zrDc95zzIeuZoMeAU+M0=
X-Received: by 2002:a81:850:0:b0:373:45d9:2263 with SMTP id
 77-20020a810850000000b0037345d92263mr3145487ywi.507.1670010141605; Fri, 02
 Dec 2022 11:42:21 -0800 (PST)
MIME-Version: 1.0
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com> <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
In-Reply-To: <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 2 Dec 2022 21:42:10 +0200
Message-ID: <CAHsH6Gtt4vihaZ5kCFsjT8x1SmuiUkijnVxgAA9bMp4NOgPeAw@mail.gmail.com>
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

On Fri, Dec 2, 2022 at 9:08 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/2/22 1:59 AM, Eyal Birger wrote:
> > +__used noinline
> > +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> > +                       const struct bpf_xfrm_info *from)
> > +{
> > +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > +     struct metadata_dst *md_dst;
> > +     struct xfrm_md_info *info;
> > +
> > +     if (unlikely(skb_metadata_dst(skb)))
> > +             return -EINVAL;
> > +
> > +     md_dst = this_cpu_ptr(xfrm_md_dst);
> > +
> > +     info = &md_dst->u.xfrm_info;
> > +
> > +     info->if_id = from->if_id;
> > +     info->link = from->link;
> > +     skb_dst_force(skb);
> > +     info->dst_orig = skb_dst(skb);
> > +
> > +     dst_hold((struct dst_entry *)md_dst);
> > +     skb_dst_set(skb, (struct dst_entry *)md_dst);
>
>
> I may be missed something obvious and this just came to my mind,
>
> What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the
> md_dst?
>
Oh I think you're right. I missed this.

In order to keep this implementation I suppose it means that the module would
not be allowed to be removed upon use of this kfunc. but this could be seen as
annoying from the configuration user experience.

Alternatively the metadata dsts can be separately allocated from the kfunc,
which is probably the simplest approach to maintain, so I'll work on that
approach.

Thanks for noticing this!
Eyal.
