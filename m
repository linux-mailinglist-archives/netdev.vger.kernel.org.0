Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD0F5BB692
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 07:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiIQFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQFpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 01:45:03 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B92C125
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 22:45:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h3so19738302lja.1
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 22:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VKIbkUX8Pl/zleDxQPqco3aAHa86Nd1ZuQaZ6+BRuI4=;
        b=lTa0Tjlcv+YEGwPyzxuRbm10ncV9p9EKWn/gkwtra6K43dFsFVBgP36rKAVulZSSBB
         edpcmgoA8doU7SjFwuiJeY5PqU3g4qOwJx4NSTBZ84fY5c11+6htBLZQket9V07MIqbK
         A6narZl0yC4dyWYzlN0q1glHKWgw8CGSn+GdurSqUxmGO67JlnAzZUInCNKhW/E6r5ja
         oDXcYYX5KMQF+Hx6OWL/zK4gT3QMJMLa6END3JyvC8kt1jx8cnN0njaJixcsgast1U9O
         WCKwU4dFlXvmuCx9O1xa3od+HUDlQFa5zyPMYA3lBlvUErcg+Yv6vgM2g4t5wFy6UpRE
         jnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VKIbkUX8Pl/zleDxQPqco3aAHa86Nd1ZuQaZ6+BRuI4=;
        b=HSMmJcGqe2qZ47GCb2p5DroU2+V3PlyQerhFO+FNd7HdSOFuuLtEPRqPcMvGWMZbyD
         5mWfBLmCMIGYxPBQB6e6d1Ye42fr9hpJc1rI8whgZI4/S8ZC15L2eSdfwB4Lpw8Hl/TV
         y2As8+Hv+rcKy2eVPQoB6nAwoiKDU6gU0FlaXKWGRuGaLKzBfj5si6Q/7ByRhUA3v8GS
         TaJod3lPdyMyendlIErU56VKdbvHqNDyYjou3LCndsejtou4cT0SMC/hCyfamY2GxeNk
         ZzGp/CDavVN+g7U90WMXO5utj3mmur6wbzVizHud9W6LDoHglt2KW586fjNEmzTuw4mW
         5zVQ==
X-Gm-Message-State: ACrzQf0MzpEgcs2SekK6Bolop28/yLNIIJNm9W6jv3+af+vvW6tYTQrT
        wh4ACV6iX6oBy6iTQ6HnqrKhZNu9/6Dvfp4obk1HYw==
X-Google-Smtp-Source: AMsMyM7XyE7HsYLCHpwD/Jj+rJI0RDtN0/J4N+96fgtAzw2za/DFs5Fj9gLPzAwcKjN1i85TfmdsMgTHICkEmhXJDl8=
X-Received: by 2002:a2e:575c:0:b0:26a:9f39:b3f7 with SMTP id
 r28-20020a2e575c000000b0026a9f39b3f7mr2322630ljd.315.1663393499070; Fri, 16
 Sep 2022 22:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220824221252.4130836-1-benedictwong@google.com>
 <20220824221252.4130836-3-benedictwong@google.com> <20220830062529.GM2950045@gauss3.secunet.de>
In-Reply-To: <20220830062529.GM2950045@gauss3.secunet.de>
From:   Benedict Wong <benedictwong@google.com>
Date:   Fri, 16 Sep 2022 22:44:42 -0700
Message-ID: <CANrj0bYOU0Ekwn6nVQr+c2znbX6wHFry7TUi-Hd4BW78DEw7qA@mail.gmail.com>
Subject: Re: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP tunnels
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, nharold@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
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

Thanks for the response; apologies for taking a while to re-patch this
and verify.

I think this /almost/ does what we need to. I'm still seeing v6 ESP in v6
ESP tunnels failing; I think it's due to the fact that the IPv6 ESP
codepath does not trigger policy checks in the receive codepath until it
hits the socket, or changes namespace.

Perhaps if we verify policy unconditionally in xfrmi_rcv_cb? combined
with your change above, this should ensure IPv6 ESP also checks policies,
and inside that clear the secpath?

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5113fa0fbcee..4288d87c9249 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -236,23 +236,21 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)

        xnet = !net_eq(xi->net, dev_net(skb->dev));

-       if (xnet) {
-               inner_mode = &x->inner_mode;
-
-               if (x->sel.family == AF_UNSPEC) {
-                       inner_mode = xfrm_ip2inner_mode(x,
XFRM_MODE_SKB_CB(skb)->protocol);
-                       if (inner_mode == NULL) {
-                               XFRM_INC_STATS(dev_net(skb->dev),
-                                              LINUX_MIB_XFRMINSTATEMODEERROR);
-                               return -EINVAL;
-                       }
+       inner_mode = &x->inner_mode;
+
+       if (x->sel.family == AF_UNSPEC) {
+               inner_mode = xfrm_ip2inner_mode(x,
XFRM_MODE_SKB_CB(skb)->protocol);
+               if (inner_mode == NULL) {
+                       XFRM_INC_STATS(dev_net(skb->dev),
+                                               LINUX_MIB_XFRMINSTATEMODEERROR);
+                       return -EINVAL;
                }
-
-               if (!xfrm_policy_check(NULL, XFRM_POLICY_IN, skb,
-                                      inner_mode->family))
-                       return -EPERM;
        }

+       if (!xfrm_policy_check(NULL, XFRM_POLICY_IN, skb,
+                                       inner_mode->family))
+               return -EPERM;
+
        xfrmi_scrub_packet(skb, xnet);
        dev_sw_netstats_rx_add(dev, skb->len);

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..04f66f6d5729 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3516,7 +3516,7 @@ int __xfrm_policy_check(struct sock *sk, int
dir, struct sk_buff *skb,
        int xerr_idx = -1;
        const struct xfrm_if_cb *ifcb;
        struct sec_path *sp;
-       struct xfrm_if *xi;
+       struct xfrm_if *xi = NULL;
        u32 if_id = 0;

        rcu_read_lock();
@@ -3667,6 +3667,9 @@ int __xfrm_policy_check(struct sock *sk, int



dir, struct sk_buff *skb,

                        goto reject;
                }

+               if (xi)
+                       secpath_reset(skb);
+
                xfrm_pols_put(pols, npols);
                return 1;
        }




On Mon, Aug 29, 2022 at 11:25 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, Aug 24, 2022 at 10:12:52PM +0000, Benedict Wong wrote:
> > This change ensures that all nested XFRM packets have their policy
> > checked before decryption of the next layer, so that policies are
> > verified at each intermediate step of the decryption process.
> >
> > Notably, raw ESP/AH packets do not perform policy checks inherently,
> > whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
> > checks after calling xfrm_input handling in the respective encapsulation
> > layer.
> >
> > This is necessary especially for nested tunnels, as the IP addresses,
> > protocol and ports may all change, thus not matching the previous
> > policies. In order to ensure that packets match the relevant inbound
> > templates, the xfrm_policy_check should be done before handing off to
> > the inner XFRM protocol to decrypt and decapsulate.
> >
> > In order to prevent double-checking packets both here and in the
> > encapsulation layers, this check is currently limited to nested
> > tunnel-mode transforms and checked prior to decapsulation of inner
> > tunnel layers (prior to hitting a nested tunnel's xfrm_input, there
> > is no great way to detect a nested tunnel). This is primarily a
> > performance consideration, as a general blanket check at the end of
> > xfrm_input would suffice, but may result in multiple policy checks.
> >
> > Test: Tested against Android Kernel Unit Tests
> > Signed-off-by: Benedict Wong <benedictwong@google.com>
> > ---
> >  net/xfrm/xfrm_input.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> > index bcb9ee25474b..a3b55d109836 100644
> > --- a/net/xfrm/xfrm_input.c
> > +++ b/net/xfrm/xfrm_input.c
> > @@ -586,6 +586,20 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> >                       goto drop;
> >               }
> >
> > +             /* If nested tunnel, check outer states before context is lost.
> > +              * Only nested tunnels need to be checked, since IP addresses change
> > +              * as a result of the tunnel mode decapsulation. Similarly, this check
> > +              * is limited to nested tunnels to avoid performing another policy
> > +              * check on non-nested tunnels. On success, this check also updates the
> > +              * secpath's verified_cnt variable, skipping future verifications of
> > +              * previously-verified secpath entries.
> > +              */
> > +             if ((x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) &&
> > +                 sp->verified_cnt < sp->len &&
> > +                 !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
> > +                     goto drop;
> > +             }
>
> This is not the right place to do the policy lookup. We don't know
> if we should check XFRM_POLICY_IN or XFRM_POLICY_FWD.
>
> But it looks like we don't reset the secpath in the receive path
> like other virtual interfaces do.
>
> Would such a patch fix your issue too?
>
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index cc6ab79609e2..429de6a28f59 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3516,7 +3516,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
>         int xerr_idx = -1;
>         const struct xfrm_if_cb *ifcb;
>         struct sec_path *sp;
> -       struct xfrm_if *xi;
> +       struct xfrm_if *xi = NULL;
>         u32 if_id = 0;
>
>         rcu_read_lock();
> @@ -3668,6 +3668,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
>                         goto reject;
>                 }
>
> +               if (xi)
> +                       secpath_reset(skb);
> +
>                 xfrm_pols_put(pols, npols);
>                 return 1;
>         }
