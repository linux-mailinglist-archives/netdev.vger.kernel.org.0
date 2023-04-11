Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADD56DE121
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDKQlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDKQlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:41:08 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2501510E9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:41:07 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id x11so4863660vsq.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681231266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3X48ar0qFZm2GWEUPYGGy0mBW0lVj7DLN8iUD9bW15Q=;
        b=ivABfikQNYrTK3IN3U7P0Y70iOEON5Xm/hUfLwl87VTs2dZsr43JgibvXdeOKxc6tN
         5Rhjs962rwWa/PhAxvFXT9s3grhoDMpvnJFSovwHXZRKyESvc/cX/jtE6yCAwJDF6OKr
         6AzIFFPAOg1NhCRtyzi99McUMXjWXHZ9OBMpCPhfLaSfnYVhU62fKW/ijBT12E1w18za
         Ds/5rYxzgZesdrzrkRrURCd5jze+4X7Y0NYdSlNXtxFEs+N9B85aCSm1AjSGpKDw/G8V
         x9NpXiRV+MAxMsUNwFLC8R9RVeH9YtdoLqR8YEso/5O2eZnGUVStB/Wo5TAK0JG3afwI
         3KVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681231266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3X48ar0qFZm2GWEUPYGGy0mBW0lVj7DLN8iUD9bW15Q=;
        b=G1OerS4FsIOCBfT1rzQ6PatNIR22aov4MFZ9KcheFops31F4slF8wsxO3ru8DyQr8g
         5E9ebgMF5KL7Ei8+hxsihWvK2XuQVQSW3mC+uxerzFqcFmpmiR5tizaFZ+76owzavbeu
         ze9eIkdVAjWO6+woZHGwYYVsnhlnMClT1eHbkM/bQJ0c15ar0OsRJQwEOkNcJwikOPST
         TQXFIbUutWCBYaSlZPQxFuU6MEBLctqyfYnbOrV6mY6j8GHc9GXi48AXFzvOPI4iETEk
         V/F2g26JvMcjX/SOOg8hm85psVQRW01OMsiLmpwhkTBTeDcqj0Z1Ji3iEMiFfQ8PIrYU
         YhZw==
X-Gm-Message-State: AAQBX9eUXpEeCeFU2nywdu17HGjBzb9lETFJxTv+hJmlBFoV9jDfrlFo
        4MW2QnRwFaIpaDQWsqEWIjf3C8eiIvZTVxoJhQA=
X-Google-Smtp-Source: AKy350aPk+Pc9pbq15+uHNJs4Lbl42FERiI5UfTnwE3pJ6Rs8BW4DX5guA8Gm7QSJcxBKP1qJmVtCubmc3MVzTiWCq0=
X-Received: by 2002:a67:d58c:0:b0:423:e1fd:c6e2 with SMTP id
 m12-20020a67d58c000000b00423e1fdc6e2mr7649123vsj.2.1681231266126; Tue, 11 Apr
 2023 09:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230411072502.21315-1-martin@strongswan.org> <CAHsH6GtyE8HE2TnU_QUVg2s+Dass0GtGsaWKqo-g+1aUprmSxw@mail.gmail.com>
In-Reply-To: <CAHsH6GtyE8HE2TnU_QUVg2s+Dass0GtGsaWKqo-g+1aUprmSxw@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 11 Apr 2023 19:40:55 +0300
Message-ID: <CAHsH6Gv1Vhr3unAsG-0WiJf5CD85NyrgDitLmMtxdphD4__aSA@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: Preserve xfrm interface secpath for packets forwarded
To:     Martin Willi <martin@strongswan.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 11, 2023 at 7:35=E2=80=AFPM Eyal Birger <eyal.birger@gmail.com>=
 wrote:
>
> Hi,
>
> On Tue, Apr 11, 2023 at 10:54=E2=80=AFAM Martin Willi <martin@strongswan.=
org> wrote:
> >
> > The commit referenced below clears the secpath on packets received via
> > xfrm interfaces to support nested IPsec tunnels. This breaks Netfilter
> > policy matching using xt_policy in the FORWARD chain, as the secpath
> > is missing during forwarding. INPUT matching is not affected, as it is
> > done before secpath reset.
> >
> > A work-around could use XFRM input interface matching for such rules,
> > but this does not work if the XFRM interface is part of a VRF; the
> > Netfilter input interface is replaced by the VRF interface, making a
> > sufficient match for IPsec-protected packets difficult.
> >
> > So instead, limit the secpath reset to packets that are targeting the
> > local host, in the default or a specific VRF. This should allow nested
> > tunnels, but keeps the secpath intact on packets that are passed to
> > Netfilter chains with potential IPsec policy matches.
> >
> > Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
> > Signed-off-by: Martin Willi <martin@strongswan.org>
> > ---
> >  include/net/xfrm.h     | 10 ++++++++++
> >  net/xfrm/xfrm_policy.c |  2 +-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> > index 3e1f70e8e424..f16df2f07a83 100644
> > --- a/include/net/xfrm.h
> > +++ b/include/net/xfrm.h
> > @@ -1349,6 +1349,16 @@ void xfrm_flowi_addr_get(const struct flowi *fl,
> >         }
> >  }
> >
> > +static inline bool xfrm_flowi_is_forwarding(struct net *net,
> > +                                           const struct flowi *fl)
> > +{
> > +       if (fl->flowi_oif =3D=3D LOOPBACK_IFINDEX)
> > +               return false;
> > +       if (netif_index_is_l3_master(net, fl->flowi_oif))
> > +               return false;
> > +       return true;
> > +}
> > +
> >  static __inline__ int
> >  __xfrm4_state_addr_check(const struct xfrm_state *x,
> >                          const xfrm_address_t *daddr, const xfrm_addres=
s_t *saddr)
> > diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > index 5c61ec04b839..4f49698eb29f 100644
> > --- a/net/xfrm/xfrm_policy.c
> > +++ b/net/xfrm/xfrm_policy.c
> > @@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir,=
 struct sk_buff *skb,
> >                         goto reject;
> >                 }
> >
> > -               if (if_id)
> > +               if (if_id && !xfrm_flowi_is_forwarding(net, &fl))
>
> At first I thought that "dir" would just be "XFRM_POLICY_FWD" from the
> forwarding path, so you could just do:
>
> if (if_id && dir !=3D XFRM_POLICY_FWD)
> secpath_reset(skb);
>
> But I think the problem with this would be when the xfrmi is moved to a
> different NS in which case the policy check is done using XFRM_POLICY_IN
> right? if so maybe this can be passed somehow, maybe using a bit in the "=
dir"
> outside of XFRM_POLICY_MASK?
>
> something like:
>
> no_reset_sp =3D dir & XFRM_POLICY_NO_RESET_SP || dir =3D=3D XFRM_POLICY_F=
WD;
> dir &=3D XFRM_POLICY_MASK;
>
> ...
> if (if_id && !no_reset_sp)
> secpath_reset(skb);
>
> The benefit I think is in not deducing whether we are in forwarding.
>
> Maybe there's some other logic that I'm missing?

After another look the secpath is reset in that case anyway.
So in that case, which flow is missing when just using:

if (if_id && dir !=3D XFRM_POLICY_FWD)
    secpath_reset(skb);

Eyal.
