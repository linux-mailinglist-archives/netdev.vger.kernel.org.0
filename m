Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25396B2861
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjCIPH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbjCIPHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:07:37 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76AF5D16
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:05:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id h14so2195741wru.4
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 07:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678374325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fprW8tKIJpNzkLRvXOdERhC1G75znrKGsVPaP20fW+w=;
        b=J47UBp+wxM1KsM1vSCnlEL6q+hv+bNiGs/S9ezNZ3FczAvPEOX6REYsGl9e8y7Kbgi
         t5yvgu0EEzLYK5ax9pbvEWlXWeG4xwvYLD+iRkI4eeYAVBiwRZdxoC4hcxTKEvoxB77D
         /XoNjLGzs1QwWmkc18cq/P6rMHkbWHCrsA+Zcvkz2HIQ1ixuuESeBlZu2fCp1dyb7itC
         Mb/hVCNN/MEhXlOv8lfZELVazX9djURCqc4gk/Wb73mm1vW7fXkRrrjWchmb6dhl7Qr5
         zRC+MMJLXrHpC6tLqV6PDj7t0x12U/LrM5GCNrjJ/S1qA4PeqlvyH7/0PFuXxnLyxLHx
         VLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678374325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fprW8tKIJpNzkLRvXOdERhC1G75znrKGsVPaP20fW+w=;
        b=j2Py7OlE0M/2bj0gP8jjU6O9y0AHYsKsPqS4da+25IEjK8zDWXGdX7iaed9e6ThsiM
         ZlHep2aa2R6sXiUTfudRFNuly6366CU4oivV+E6KbN+UWW2Uui1bERsbbDgxxmKRWRyy
         LfDqfFsQ0CeQm5AsuwfiS7isp61jmAoirW2EQNHc1w5cDEJbGSFhrCJpOMRC5r/sBz6o
         92TQxfMl4WDafJh2BZRyhMqhUIqDvz8tpmqzWPmbJnqQoLPzMbhkaAqnOEvQn/rav7qk
         kZbj1ofFM0IzBt/j6rwp3qJU0LWMKKofOytAHp0bLiHa4EjhgGmQ1O/JhyQRgZniKRXX
         1kvA==
X-Gm-Message-State: AO0yUKVP4NcUKZ4afEXS3ZLfgoSfObvxY9LUHX1UZOUorlcqpMnYvQAg
        XFEroAmzz8HZrx1HYd8LG/Su0YAFlzMu2rTi1WBARQ==
X-Google-Smtp-Source: AK7set887nr6XBTqOK05PdAz44JZdvwltzyYf1Oyh2sWKb7bxgmtbjPGrGWiHv4JHYEf8xQDCPIO/0u/eeRBu46mEwA=
X-Received: by 2002:adf:f38d:0:b0:2cb:3b68:3a88 with SMTP id
 m13-20020adff38d000000b002cb3b683a88mr4826450wro.7.1678374325103; Thu, 09 Mar
 2023 07:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20230309134718.306570-1-gavinl@nvidia.com> <20230309134718.306570-5-gavinl@nvidia.com>
 <CANn89i+k3fcSw58owpr70eM_uSM5QUqEb_4y5wpXOKEz30+vvg@mail.gmail.com>
In-Reply-To: <CANn89i+k3fcSw58owpr70eM_uSM5QUqEb_4y5wpXOKEz30+vvg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Mar 2023 16:05:13 +0100
Message-ID: <CANn89iKcDNZBerR_2nEp_ryM3BVXuvr64s6tnAvizCwr=SuACg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gavi@nvidia.com, roid@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 3:59=E2=80=AFPM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Thu, Mar 9, 2023 at 2:48=E2=80=AFPM Gavin Li <gavinl@nvidia.com> wrote=
:
> >
> > Change ip_tunnel_info_opts( ) from static function to macro to cast ret=
urn
> > value and preserve the const-ness of the pointer.
> >
> > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > ---
> >  include/net/ip_tunnels.h | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> > index fca357679816..3e5c102b841f 100644
> > --- a/include/net/ip_tunnels.h
> > +++ b/include/net/ip_tunnels.h
> > @@ -67,6 +67,12 @@ struct ip_tunnel_key {
> >         GENMASK((sizeof_field(struct ip_tunnel_info,            \
> >                               options_len) * BITS_PER_BYTE) - 1, 0)
> >
> > +#define ip_tunnel_info_opts(info)                              \
> > +       _Generic(info,                                          \
> > +               const typeof(*(info)) * : ((const void *)((info) + 1)),=
\
> > +               default : ((void *)((info) + 1))                \
> > +       )
> > +
>
> Hmm...
>
> This looks quite dangerous, we lost type safety with the 'default'
> case, with all these casts.
>
> What about using something cleaner instead ?
>
> (Not sure why we do not have an available generic helper for this kind
> of repetitive things)
>

Or more exactly :

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca3576798166416982ee6a9100b003810c49830..17fc6c8f7e0b9e5303c1fb9e5da=
d77c5310e01a9
100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -485,10 +485,11 @@ static inline void iptunnel_xmit_stats(struct
net_device *dev, int pkt_len)
        }
 }

-static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
-{
-       return info + 1;
-}
+#define ip_tunnel_info_opts(info)                                      \
+       (_Generic(info,                                                 \
+                const struct ip_tunnel_info * : (const void *)((info)
+ 1),    \
+                struct ip_tunnel_info * : (void *)((info) + 1))        \
+       )

 static inline void ip_tunnel_info_opts_get(void *to,
                                           const struct ip_tunnel_info *inf=
o)
