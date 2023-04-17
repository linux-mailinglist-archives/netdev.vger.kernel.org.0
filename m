Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9BE6E5481
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 00:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjDQWBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 18:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjDQWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 18:01:53 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A577FE7B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:01:43 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id o2so18065813uao.11
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681768902; x=1684360902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBE1FZt6/Qawl9WD+ocJw6fdkv4BXFqUUjRQ+Erbeu4=;
        b=G/JhzekGG2ROD8CP6Ta4+K4G8ue1I73WtaBkD01SUZRp06HwUSHbvDZFIkKJQlSqeG
         LzI6AEiGfDV9HqNiHr43+YMb4xHa5/AQw5vyw5JDE5XbGiQPogvb5+flofVcVJlr6BVX
         cYK2rVcGE+ZFbZVAY2rpk3kxAuddL6Obm19HtAKFL1BFGrU/hZzCP6Hj623DzQu7/af6
         /u5kK1THT293QI0Lopn9XNbtE9skefLQVXLQ+37iPdW/z6GTQtIdwM6Wg/yJegKeUTp0
         U8vK5TLZPInnVAhy/hyhOXK2xYOdR/krr8PqPxE0RqjMPje9ViImSexIbKw6/Ayt0fnp
         p5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681768902; x=1684360902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBE1FZt6/Qawl9WD+ocJw6fdkv4BXFqUUjRQ+Erbeu4=;
        b=FJBI6sTNaJEpDEb/B9ZIQywtZaAk+XM1yDzNq9pU1cGl2pCoQVTFU248TO9LPGOaXu
         e4K7WZ78UJiLSO2d7ZXaFqTbPgtCSQFN+Ghi13RXgysnAaliHS8eV+V1+mlvIQjwoj3u
         lmWtpOSRLIIQ9KaqBG+I2FVsiakzqZgj5PBXJ2PRKMxwDPdQauNGwFcf8HElX9BoS6M8
         2Hgd7XDn4r7TS2Q8nry50kifnHNZkHJupfs91RjcXelRg2IpG6YomtAP9p6UrByhqJ5E
         aiZwMsw567VmD34L0YIr6dr2LsSJf/K3hMRmU4gJ3Uq4I1Ijew82x21MW5CRDMifCXY0
         N8Jg==
X-Gm-Message-State: AAQBX9egAU9wB+E1+uJL19xbaUuW+jn+w8qCxymcBVaYID5ZGNapMvz1
        xqC6NI+uYBHGOPpWSECzwULO8iJSFRTvu/HwOc6pgg==
X-Google-Smtp-Source: AKy350bk2Yxg+G3bxpCbobnNEti9PTUpnhBkrfCNey5clhRAbebwSJ/OYX0y1YYUB3Op2HKTeji4yWer2AUSam1fJBA=
X-Received: by 2002:a9f:3143:0:b0:68b:9eed:1c7c with SMTP id
 n3-20020a9f3143000000b0068b9eed1c7cmr9552792uab.0.1681768902530; Mon, 17 Apr
 2023 15:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230412085615.124791-1-martin@strongswan.org> <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
In-Reply-To: <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
From:   Benedict Wong <benedictwong@google.com>
Date:   Mon, 17 Apr 2023 15:01:26 -0700
Message-ID: <CANrj0bYFzrLsVx=VPY1FR8VpmQ7CYeJWDKv6iE3fPxBFh26qVQ@mail.gmail.com>
Subject: Re: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for
 packets forwarded
To:     Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe I have a potential solution that caches the policy matches,
rather than clearing the secpath, which should allow for repeated
matches against a secpath entry, while allowing other already-matched
secpath entries to not need to match nested policies. That should
solve for the general case where the secpath gets checked against
policies multiple times (both in the forwarding case, as well as in
the nested transport mode in tunnel mode case.

Forgive my not knowing of convention; should I send that as a separate
patch, or append it as a reply to this thread?


On Thu, Apr 13, 2023 at 11:04=E2=80=AFAM Benedict Wong <benedictwong@google=
.com> wrote:
>
> Not directly related to this change, but in testing these on a broader
> swath of Android tests, we've found that my original change also
> happens to break Transport-in-Tunnel mode (which attempts to match the
> outer tunnel mode policy twice.). I wonder if it's worth just
> reverting first, and going back to a previous iteration of the nested
> policy checks that allows multiple lookups of the same
> template/secpath pair.
>
>
> On Wed, Apr 12, 2023 at 1:56=E2=80=AFAM Martin Willi <martin@strongswan.o=
rg> wrote:
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
> > So instead, limit the secpath reset to packets that are not using a
> > XFRM forward policy. This should allow nested tunnels, but keeps the
> > secpath intact on packets that are passed to Netfilter chains with
> > potential IPsec policy matches.
> >
> > Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
> > Suggested-by: Eyal Birger <eyal.birger@gmail.com>
> > Signed-off-by: Martin Willi <martin@strongswan.org>
> > ---
> > v1 -> v2: Use policy dir instead of flowi outif to check for forwarding
> >
> >  net/xfrm/xfrm_policy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > index 5c61ec04b839..669c3c0880a6 100644
> > --- a/net/xfrm/xfrm_policy.c
> > +++ b/net/xfrm/xfrm_policy.c
> > @@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir,=
 struct sk_buff *skb,
> >                         goto reject;
> >                 }
> >
> > -               if (if_id)
> > +               if (if_id && dir !=3D XFRM_POLICY_FWD)
> >                         secpath_reset(skb);
> >
> >                 xfrm_pols_put(pols, npols);
> > --
> > 2.34.1
> >
