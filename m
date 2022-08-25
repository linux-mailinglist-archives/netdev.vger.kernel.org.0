Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A3E5A1560
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbiHYPPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiHYPPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:15:05 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C5E4A138;
        Thu, 25 Aug 2022 08:15:03 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id s1so1193341qvn.11;
        Thu, 25 Aug 2022 08:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KftygciUxD9ZLXS1NK53lQjwSu/9WEebAQPIgHLiUng=;
        b=B3/dZxMqUeTwiC9cfUhY0y1hQo+FSAwfRGlRRYsrTlE0FPpp+9NlU+AZSzk1EPW5VC
         c+2WxLWlAMCeIgJoOk04iKx6Vy/tesMi38+dQhJZeAwdHG12gRh5kgNVc3CJTcLSVEuX
         U1oI6/0xwbBTSxaycigIsZ2ek8CYwx6NCgq7HWnm8xCyUDchd28ePWRtFim4M4ctS7ZA
         a5CjbEaYluhoL5XgmIj7pprKPX2IJnv8DqtoyngWtRAO0T6P0sBUe7YNT/rs6DAckYAg
         f6kg0HggJg6tVb4Qa/CpAHKKkaGEXCqkganEJInjIl8MOnajJFefRU9thQzrCp4parKP
         Bw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KftygciUxD9ZLXS1NK53lQjwSu/9WEebAQPIgHLiUng=;
        b=UHCakrwJY8F6eSt3wbLBR1CK1l97N4/BjTCAcX2UenPH4SMt47q/gDne6hVk89osoh
         a6EdCB3vJqmv59LqvW6SM5R88yhLelZWVfq60Ech82y55gkhZ71R99cteOFtDkFuAMqF
         6Z3G/cZRbGo5fFUs7/V8C1tqUQLPF4XfmwZnuY2n+sy08/NMfhzFMcoqkoQGRiAzdgdN
         zNvuLB1mcjOQpfTvjHv366+oPS+vN6tGHEVK3YJOln4f3zNwx1igmVOJZkkCUMA2e1+T
         c8TPjZ7KqrAgtlUSADnE6yF+sem3pRl6gWMem+28pjpSuOeqCOsz4jZpe0q0lH5R6m/W
         kvzw==
X-Gm-Message-State: ACgBeo2zquS3/m6Ij30bF5eOepCQEOw8OsYnT+R/yG4GQhQs1IH1OGIg
        l7Yt2BpbPjH9k6xMQ+cBU4J1gFgLUQmPGPhdE+eOMNQpRSDmBg==
X-Google-Smtp-Source: AA6agR5AydfvmV2hOoIZ2sOvD+tDxri7SZnqNHiuDvG3WEZ/1NmrZwUdt523Su9dZ5gE+l2bmuV821iGHJ6Hpz/zrgE=
X-Received: by 2002:a0c:90a2:0:b0:47b:6b36:f94a with SMTP id
 p31-20020a0c90a2000000b0047b6b36f94amr4046759qvp.26.1661440502240; Thu, 25
 Aug 2022 08:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
 <20220825134636.2101222-3-eyal.birger@gmail.com> <a825aa13-6f82-e6c1-3c5c-7974b14f881e@blackwall.org>
In-Reply-To: <a825aa13-6f82-e6c1-3c5c-7974b14f881e@blackwall.org>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 25 Aug 2022 18:14:51 +0300
Message-ID: <CAHsH6Gv8Zv722pjtKrWDiSHYKvV0FUxUSnHf_8B+gJnAVYiziQ@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: support collect
 metadata mode
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:24 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 25/08/2022 16:46, Eyal Birger wrote:
> > This commit adds support for 'collect_md' mode on xfrm interfaces.
> >
> > Each net can have one collect_md device, created by providing the
> > IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> > altered and has no if_id or link device attributes.
> >
> > On transmit to this device, the if_id is fetched from the attached dst
> > metadata on the skb. If exists, the link property is also fetched from
> > the metadata. The dst metadata type used is METADATA_XFRM which holds
> > these properties.
> >
> > On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> > packet received and attaches it to the skb. The if_id used in this case is
> > fetched from the xfrm state, and the link is fetched from the incoming
> > device. This information can later be used by upper layers such as tc,
> > ebpf, and ip rules.
> >
> > Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> > metadata is postponed until after scrubing. Similarly, xfrm_input() is
> > adapted to avoid dropping metadata dsts by only dropping 'valid'
> > (skb_valid_dst(skb) == true) dsts.
> >
> > Policy matching on packets arriving from collect_md xfrmi devices is
> > done by using the xfrm state existing in the skb's sec_path.
> > The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> > is changed to keep the details of the if_id extraction tucked away
> > in xfrm_interface.c.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
> > ----
> >
> > v2:
> >   - add "link" property as suggested by Nicolas Dichtel
> >   - rename xfrm_if_decode_session_params to xfrm_if_decode_session_result
> > ---
>
> (+CC Daniel)
>
> Hi,
> Generally I really like the idea, but I missed to comment the first round. :)
> A few comments below..
>

Thanks for the review!

> >  include/net/xfrm.h           |  11 +++-
<...snip...>
> >
> >  static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
> > -     [IFLA_XFRM_LINK]        = { .type = NLA_U32 },
> > -     [IFLA_XFRM_IF_ID]       = { .type = NLA_U32 },
> > +     [IFLA_XFRM_UNSPEC]              = { .strict_start_type = IFLA_XFRM_COLLECT_METADATA },
> > +     [IFLA_XFRM_LINK]                = { .type = NLA_U32 },
>
> link is signed, so s32

Ack on all comments except this one - I'm a little hesitant to change
this one as the change would be unrelated to this series.

Thanks!
Eyal.
