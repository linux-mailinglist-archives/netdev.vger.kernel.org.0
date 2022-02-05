Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931174AA670
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379313AbiBEE1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEE1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:27:11 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D958C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:27:10 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v190so8213722ybv.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WLfaAGR75iPakgaqasliEOKsrerkySqPkGNwQ7llQrA=;
        b=tPs8M9lh7Jtct/ySzw3Z+NsLMgpME8W0IMqzX6BsW35iAGHAekocRu/Su0MZmsP0Pc
         zFU4AmVgMz+GBY4I/+vDx2VdaGW4mrxjraBQH6UVx1j1GtZkqPVoasYcu4eLW7/DlYEC
         L5FzHh4WwerrXHVv0vVFLzttjhzOBuUfN0YZ4lVQ9pOJnbNZcXJywv/mLwMofvpikeF1
         qbzMOsdDcpHcuH4a/QCXbPh1hLDYeSf5UqBaYeXoz5T5pJlw0wAQo3pSXiMGPhObwrev
         2E1iJocATCw7pDWCQ22TwIq9M1ofJ6XCKDZBaQ5k86rE2WxSoDkpBvv3o+PM5LIVbm1v
         CS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLfaAGR75iPakgaqasliEOKsrerkySqPkGNwQ7llQrA=;
        b=lBB5WGA0AmgDd0VPAENyBxmfOs/lPWi8eXM+F8b7FKLOJBGjGDrJaUGY+gp3KfruIp
         KDy6ghPL1uGPkVQGvEiVQgnPVel7sDrNZIe2RFyHFsPmzd2nsHQ66e/JGF9VIk/kNWxg
         qgsxv1pIh7GsiHvvSpYG488fhDB3+qnxPE7eArfCmtjLAVbHgFzoUjgGch0nkrC9fTv5
         UzMFPwOv41QxV2tN/7BiZTfJbxUP341aTrLRVGe2K/ozTx4b5C8SrvHdxnS3tS6xF9+J
         TUAzvM+1XrDoTNHcOVX8Crytu8CTSyDcwBGwrucjibKNlLPkoHjLpOZuzediraPDlXUC
         Q5oQ==
X-Gm-Message-State: AOAM531rr8sdTZKgKORXW+GH3GZate3Wjso5QGjGmL5zXsZLJnWtBomc
        +/5iQeqMtV+XTpsBzn2U1aQvDKkEZ4TjWHKWNwjgAg==
X-Google-Smtp-Source: ABdhPJwSkomFtawCPSNxPU56WHi3MBHQBpiYGAV10FsEW6iFM83I8uDjg0AWsuqg7viyULK3ldVXZ8fvcHTQzWpveec=
X-Received: by 2002:a0d:cc46:: with SMTP id o67mr2076869ywd.463.1644035229019;
 Fri, 04 Feb 2022 20:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
 <20220203180227.3751784-2-eric.dumazet@gmail.com> <20220204195229.2e210fde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204195229.2e210fde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 20:26:58 -0800
Message-ID: <CANn89iKF0sf1APAaVKHdWRZEVZ5X1LoBRGHBgS4TfucD=SsOJw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: typhoon: implement ndo_features_check method
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Feb 4, 2022 at 7:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  3 Feb 2022 10:02:26 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Instead of disabling TSO if MAX_SKB_FRAGS > 32, implement
> > ndo_features_check() method for this driver.
> >
> > If skb has more than 32 frags, use the following heuristic:
> >
> > 1) force GSO for gso packets.
> > 2) Otherwise force linearization.
> >
> > Most locally generated packets will use a small number
> > of fragments anyway.
> >
> > For forwarding workloads, we can limit gro_max_size at ingress,
> > we might also implement gro_max_segs if needed.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  drivers/net/ethernet/3com/typhoon.c | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
> > index 8aec5d9fbfef2803c181387537300502a937caf0..67b1a1f439d841ed0ed0f620e9477607ac6e2fae 100644
> > --- a/drivers/net/ethernet/3com/typhoon.c
> > +++ b/drivers/net/ethernet/3com/typhoon.c
> > @@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or PIO(0) to access the NIC. "
> >  module_param(rx_copybreak, int, 0);
> >  module_param(use_mmio, int, 0);
> >
> > -#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
> > -#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
> > -#undef NETIF_F_TSO
> > -#endif
> > -
> >  #if TXLO_ENTRIES <= (2 * MAX_SKB_FRAGS)
> >  #error TX ring too small!
> >  #endif
> > @@ -2261,9 +2256,27 @@ typhoon_test_mmio(struct pci_dev *pdev)
> >       return mode;
> >  }
> >
> > +#if MAX_SKB_FRAGS > 32
> > +static netdev_features_t typhoon_features_check(struct sk_buff *skb,
> > +                                             struct net_device *dev,
> > +                                             netdev_features_t features)
> > +{
> > +     if (skb_shinfo(skb)->nr_frags > 32) {
> > +             if (skb_is_gso(skb))
> > +                     features &= ~NETIF_F_GSO_MASK;
> > +             else
> > +                     features &= ~NETIF_F_SG;
>
> Should we always clear SG? If we want to make the assumption that
> non-gso skbs are never this long (like the driver did before) then
> we should never clear SG. If we do we risk one of the gso-generated
> segs will also be longer than 32 frags.

If I read the comment (deleted in this patch), it seems the 32 limits
is about TSO only ?

#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO

This is why I chose this implementation.

>
> Thought I should ask.
>
> > +     }
> > +     return features;
>
> return vlan_features_check(skb, features) ?

Hmm... not sure why we duplicate vlan_features_check() &
vxlan_features_check() in all ndo_features_check() handlers :/

>
> > +}
> > +#endif
> > +
> >  static const struct net_device_ops typhoon_netdev_ops = {
> >       .ndo_open               = typhoon_open,
> >       .ndo_stop               = typhoon_close,
> > +#if MAX_SKB_FRAGS > 32
> > +     .ndo_features_check     = typhoon_features_check,
> > +#endif
> >       .ndo_start_xmit         = typhoon_start_tx,
> >       .ndo_set_rx_mode        = typhoon_set_rx_mode,
> >       .ndo_tx_timeout         = typhoon_tx_timeout,
>
