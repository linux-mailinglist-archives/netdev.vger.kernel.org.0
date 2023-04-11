Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A366DE109
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDKQfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDKQfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:35:18 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F62319B1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:35:17 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id x30so4182789uaf.7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681230916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3nAsyKS2LrWI4VBGxDvu++QDQA0NDa31AoKsUdJz5E=;
        b=hl6kzhOphqtVjy3DRepL/tLVQQ1NQXKCc3beOV2W97/u8zuR4X4rvE6uqy6b3Ah6zj
         74SBUpzlU5uXCWJM5ZAXY6iOOrPaTOrKvRJijKOlyNbl699Dqj/N7C7dV+h8dbnfZw4X
         zxEeosOnsGjSrxKrgaKs6Rx9xoZMDK7OVs6vGzxV4scQSXSBQqzRus+8ePXwb+lvDnAi
         AgN/m9SF0PyYY0YElwnVOMFoiNxqg9iKavZx0vXyFudzacQPBdQ2Q9HzTzbappicp5N2
         NRGKtQI4dfGsvGi9BX9/ZIRCqSm001vpNLOPkh3SUoic+fJpVDH9TlOafFO2xvx0rDnl
         jhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681230916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3nAsyKS2LrWI4VBGxDvu++QDQA0NDa31AoKsUdJz5E=;
        b=tMw5PrfS2xHjJ34Fm4dTP9sLnDyWXnxp1oiLFjiZk+2p/NrsDHjTV89PPVUWgDVM3q
         YKzkBRuVN26VR3ETYurnDLXHb67jR38nTcxHpxMU9mlr9Nk8Emd/aMmmCgfhy5RK9dst
         cVtwjCAgbk+BdtzvbxU+Fvc6f7aIr6lXdC/3a53itFFsFPF6krd28qpROYsfrenyBkyf
         74piP4gOVjaH+ZEX1gpnYrT9IrYlfWocSjsI2rf62z/YQSiXCLBiYZ63vLlWYF5YZH45
         Mh/SeGnmZJIYSuFpLo1DTYf+E0uEXQHzIgRxKYOOTq3qXDJF2WRW0n7d9Fas6Ka0+xC9
         Cbkg==
X-Gm-Message-State: AAQBX9cEvNK0Nb3jGVEGMekC9H3+D3IGMqXQWUpFkJ+kyypvWRkXAu+9
        gOLFUhkKtqEbdzhwKgpsAvf9dpX8Or5AJYGRdaA=
X-Google-Smtp-Source: AKy350bWQQnCduG9kvcNEej1xQUKjEngSS3UcPoc1kR8X0i6dMEDhlIfICsWfJYKTfotU41ebSksbmQzRRlgO+TvqjM=
X-Received: by 2002:a1f:9813:0:b0:43f:c93f:4eb8 with SMTP id
 a19-20020a1f9813000000b0043fc93f4eb8mr5238668vke.3.1681230916036; Tue, 11 Apr
 2023 09:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230411072502.21315-1-martin@strongswan.org>
In-Reply-To: <20230411072502.21315-1-martin@strongswan.org>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 11 Apr 2023 19:35:04 +0300
Message-ID: <CAHsH6GtyE8HE2TnU_QUVg2s+Dass0GtGsaWKqo-g+1aUprmSxw@mail.gmail.com>
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

On Tue, Apr 11, 2023 at 10:54=E2=80=AFAM Martin Willi <martin@strongswan.or=
g> wrote:
>
> The commit referenced below clears the secpath on packets received via
> xfrm interfaces to support nested IPsec tunnels. This breaks Netfilter
> policy matching using xt_policy in the FORWARD chain, as the secpath
> is missing during forwarding. INPUT matching is not affected, as it is
> done before secpath reset.
>
> A work-around could use XFRM input interface matching for such rules,
> but this does not work if the XFRM interface is part of a VRF; the
> Netfilter input interface is replaced by the VRF interface, making a
> sufficient match for IPsec-protected packets difficult.
>
> So instead, limit the secpath reset to packets that are targeting the
> local host, in the default or a specific VRF. This should allow nested
> tunnels, but keeps the secpath intact on packets that are passed to
> Netfilter chains with potential IPsec policy matches.
>
> Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  include/net/xfrm.h     | 10 ++++++++++
>  net/xfrm/xfrm_policy.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 3e1f70e8e424..f16df2f07a83 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1349,6 +1349,16 @@ void xfrm_flowi_addr_get(const struct flowi *fl,
>         }
>  }
>
> +static inline bool xfrm_flowi_is_forwarding(struct net *net,
> +                                           const struct flowi *fl)
> +{
> +       if (fl->flowi_oif =3D=3D LOOPBACK_IFINDEX)
> +               return false;
> +       if (netif_index_is_l3_master(net, fl->flowi_oif))
> +               return false;
> +       return true;
> +}
> +
>  static __inline__ int
>  __xfrm4_state_addr_check(const struct xfrm_state *x,
>                          const xfrm_address_t *daddr, const xfrm_address_=
t *saddr)
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 5c61ec04b839..4f49698eb29f 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, s=
truct sk_buff *skb,
>                         goto reject;
>                 }
>
> -               if (if_id)
> +               if (if_id && !xfrm_flowi_is_forwarding(net, &fl))

At first I thought that "dir" would just be "XFRM_POLICY_FWD" from the
forwarding path, so you could just do:

if (if_id && dir !=3D XFRM_POLICY_FWD)
secpath_reset(skb);

But I think the problem with this would be when the xfrmi is moved to a
different NS in which case the policy check is done using XFRM_POLICY_IN
right? if so maybe this can be passed somehow, maybe using a bit in the "di=
r"
outside of XFRM_POLICY_MASK?

something like:

no_reset_sp =3D dir & XFRM_POLICY_NO_RESET_SP || dir =3D=3D XFRM_POLICY_FWD=
;
dir &=3D XFRM_POLICY_MASK;

...
if (if_id && !no_reset_sp)
secpath_reset(skb);

The benefit I think is in not deducing whether we are in forwarding.

Maybe there's some other logic that I'm missing?

Eyal.
