Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DED562641B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiKKWCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiKKWBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:01:42 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BCA88810
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:00:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id k2so15566391ejr.2
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oDdz52zwXrcYtJDXpplbHh2OtQmjSyE9maGn+8iROwk=;
        b=FwmO5xUuanLATlWYlG6/ywshnKZsubiqedyFDprF0DFbkJZMoT1KO0vUrE4HooaW+p
         NMBD9K9ulIYjfa8N++2H+ZeYnIhdwxMxUkibhOfyIiCe6SrjQSNmhuD0CrJnJwokN9yQ
         smW1Z8M4lgftt5iFI6adsViXl6E45ZKAUsFPcaGFIk6JiaIQ02XIKuiQ7tXMnNeSktni
         Ctc5xCHJqSM+MBTBpQCrmOYCM/F6+pVSiYi63Wv/fIahxSaCr6p0jmhCh2w0movjdHqr
         TG7U1ipaPFno4HaPSawJxobIi7KJ1dXGF+LMdkFJkb5Pd5EON3WXzu4wPpfen0qvddAd
         VmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oDdz52zwXrcYtJDXpplbHh2OtQmjSyE9maGn+8iROwk=;
        b=qjZO9S8WreYcDDOlCZdB5v0AesW9gxPIMxrEV6TI+cQVB7UZotv3j3iOKoSvyCaFPC
         y/b1Psp5nyZWeuN7xLT0K2PDLn6DScRyYv0bnS800BEFX+Mt+fbfvwC7n500vpg/9cRu
         MZmf7c2vAJ8pMjULMULvIXwIS+bcE2c+sEdxtCno3AkjpaYkczHsYQt0MBz37G8vs0ot
         a/UFuElIMbmvu6664U+czQtqi07w5gpWD3xtWCdgpm7I4u7KO+O801kMpmgSKmQ5uxgE
         mPorS+OcJ5DxclaD2BfF9FtPVz5LpjP0MEm7lzupGTrmxFFclPAgeFh1JaIPeZgRsZRs
         3b2w==
X-Gm-Message-State: ANoB5pn48o7mjZ96Tvmwc55tmcLbgDpCzdTtarXGxzYmO68XffP1++93
        JPCcnkr5fslCetR8ZGa6Ggzb4PKWdNnvZt/Lg+pS2HJPmYRGFg==
X-Google-Smtp-Source: AA0mqf7lcU84c/IYPwUqgozrh0JeuyNiTuYYIDtyrHL5LdZySpJ+/nGxx2Ji/lLRXQFqSRDYBzjbMFb0TxgoYcOhkn8=
X-Received: by 2002:a17:907:1749:b0:78d:4f05:6ba7 with SMTP id
 lf9-20020a170907174900b0078d4f056ba7mr3443247ejc.590.1668204043923; Fri, 11
 Nov 2022 14:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com> <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
In-Reply-To: <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 11 Nov 2022 23:00:32 +0100
Message-ID: <CAGRyCJHEwqg8f-pGuCuboo-mE6gFaViX3e4v26LGCGuWjgAyWA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Subash,

Il giorno ven 11 nov 2022 alle ore 02:17 Subash Abhinov
Kasiviswanathan (KS) <quic_subashab@quicinc.com> ha scritto:
>
> On 11/10/2022 10:32 AM, Alexander Lobakin wrote:
> > From: Daniele Palmas <dnlplm@gmail.com>
> > Date: Wed,  9 Nov 2022 19:02:48 +0100
> >
> >> Bidirectional TCP throughput tests through iperf with low-cat
> >> Thread-x based modems showed performance issues both in tx
> >> and rx.
> >>
> >> The Windows driver does not show this issue: inspecting USB
> >> packets revealed that the only notable change is the driver
> >> enabling tx packets aggregation.
> >>
> >> Tx packets aggregation, by default disabled, requires flag
> >> RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).
> >>
> >> The maximum number of aggregated packets and the maximum aggregated
> >> size are by default set to reasonably low values in order to support
> >> the majority of modems.
> >>
> >> This implementation is based on patches available in Code Aurora
> >> repositories (msm kernel) whose main authors are
> >>
> >> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> >> Sean Tranchetti <stranche@codeaurora.org>
> >>
> >> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> >> ---
> >>
> >> +struct rmnet_egress_agg_params {
> >> +    u16 agg_size;
> >
> > skbs can now be way longer than 64 Kb.
> >
>
> rmnet devices generally use a standard MTU (around 1500) size.
> Would it still be possible for >64kb to be generated as no relevant
> hw_features is set for large transmit offloads.
> Alternatively, are you referring to injection of packets explicitly, say
> via packet sockets.
>
> >> +    u16 agg_count;
> >> +    u64 agg_time_nsec;
> >> +};
> >> +
> > Do I get the whole logics correctly, you allocate a new big skb and
> > just copy several frames into it, then send as one chunk once its
> > size reaches the threshold? Plus linearize every skb to be able to
> > do that... That's too much of overhead I'd say, just handle S/G and
> > fraglists and make long trains of frags from them without copying
> > anything? Also BQL/DQL already does some sort of aggregation via
> > ::xmit_more, doesn't it? Do you have any performance numbers?
>
> The difference here is that hardware would use a single descriptor for
> aggregation vs multiple descriptors for scatter gather.
>
> I wonder if this issue is related to pacing though.
> Daniele, perhaps you can try this hack without enabling EGRESS
> AGGREGATION and check if you are able to reach the same level of
> performance for your scenario.
>
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -236,7 +236,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
>          struct rmnet_priv *priv;
>          u8 mux_id;
>
> -       sk_pacing_shift_update(skb->sk, 8);
> +       skb_orphan(skb);
>
>          orig_dev = skb->dev;
>          priv = netdev_priv(orig_dev);
>

Sure, I'll test that on Monday.

> >
> >> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> >> index 5e7a1041df3a..09a30e2b29b1 100644
> >> --- a/include/uapi/linux/if_link.h
> >> +++ b/include/uapi/linux/if_link.h
> >> @@ -1351,6 +1351,7 @@ enum {
> >>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> >>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
> >>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
> >> +#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)
> >
> > But you could rely on the aggregation parameters passed via Ethtool
> > to decide whether to enable aggregation or not. If any of them is 0,
> > it means the aggregation needs to be disabled.
> > Otherwise, to enable it you need to use 2 utilities: the one that
> > creates RMNet devices at first and Ethtool after, isn't it too
> > complicated for no reason?
>
> Yes, the EGRESS AGGREGATION parameters can be added as part of the rmnet
> netlink policies.
>

Ack.

Thanks,
Daniele

> >
> >>
> >>   enum {
> >>      IFLA_RMNET_UNSPEC,
> >> --
> >> 2.37.1
> >
> > Thanks,
> > Olek
