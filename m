Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7E48E191
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiANAa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238442AbiANAa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 19:30:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A52C06161C;
        Thu, 13 Jan 2022 16:30:56 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s1so13023266wra.6;
        Thu, 13 Jan 2022 16:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ap/kMyN68kWuR9y16gKLcanzMWx8giH2D7nuK0nuPeE=;
        b=NToC6BmfNCeA7ADQgM/xajiInDYinSQ29GhXX8sH5zvwseiOomfRkQL6pO3hlYo6Bh
         eyHHdhRh7DpoF9ycR9AedMv0lRMExHFN7zzxCq65Mb0vm5li9DDLIa7dYTjZ8ZMFJwIC
         DNI5FcsUGJvRSa4VpAwkb1eY3m++b/TNcPKxJJWvRFpRf95WxrAv3BgiJKh1n1YdvI8M
         FfcerdEBDdJf+0WptfxyF8FFmUVIJUeKXroyHTg2Htg4weyi46S0qavFv+KSD3nBcO8r
         g7ipkjV36wglDjHV9xtNfmzUlwRb3Iq3Bgb31owECX2vQRjEuY/EYcYJ8HIEsWu9+oFJ
         jdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ap/kMyN68kWuR9y16gKLcanzMWx8giH2D7nuK0nuPeE=;
        b=qJWMsmLbbZIVPFmGFLAgg/kYlrWMi5oIkaWnJJWKMAoj2MiQON606yvHx1TkmbCkmQ
         4ucylrUcy9784pOW9CxXpShuLY/zYToOZrXpYhKUNvjYkArQj5OwzrbE6AnxolHlr/lO
         DC+S4Pv0Knyy1iE6tA7kK/k+wNAM0QXxbbqgF3kd1I6x2xBW2kvYBSs60TMpqw+1yuAY
         HNiBViqruO7Kg9RLhSQl2ngs+uPnN5UE2eqybjHdpdf2TkvvMjPJcDyeIQ7gBj4ZlCrf
         H7zf2eAn+fv3rSilH1q8W+jScW9Q0lhX/Qrwl+x2S/nI4iPWNehm9otXvgEP1yLds4vr
         ofJA==
X-Gm-Message-State: AOAM531hQdgUZVoglMRRtWhbRVuLRkRKPZphnF0IFLhs1R99RyK3wUyb
        PYNoOpO/dkXKY5NDJ+xODikXgiFbT1Hu2JuA96o=
X-Google-Smtp-Source: ABdhPJzvvQbmJtO0KgwjoDpUsi2br06ux9d039EUrc4qH49bd9Z2Zd7b//Y8dcUzb9ukGmgFOMjMyWaCsQSlskqg2yI=
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr403359wrx.56.1642120255017;
 Thu, 13 Jan 2022 16:30:55 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-24-miquel.raynal@bootlin.com> <CAB_54W6bJ5oV1pTX03-xWaFohdyxrjy2WSa2kxp3rBzLqSo=UA@mail.gmail.com>
 <20220113181451.6aa5e60a@xps13>
In-Reply-To: <20220113181451.6aa5e60a@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 19:30:43 -0500
Message-ID: <CAB_54W7GzyQr05X3TUcPbAFPsvetAjX=vd3G9y9wQi+8msYGHQ@mail.gmail.com>
Subject: Re: [wpan-next v2 23/27] net: mac802154: Add support for active scans
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 13 Jan 2022 at 12:14, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 12 Jan 2022 18:16:11 -0500:
>
> > Hi,
> >
> > On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > > +static int mac802154_scan_send_beacon_req_locked(struct ieee802154_local *local)
> > > +{
> > > +       struct sk_buff *skb;
> > > +       int ret;
> > > +
> > > +       lockdep_assert_held(&local->scan_lock);
> > > +
> > > +       skb = alloc_skb(IEEE802154_BEACON_REQ_SKB_SZ, GFP_KERNEL);
> > > +       if (!skb)
> > > +               return -ENOBUFS;
> > > +
> > > +       ret = ieee802154_beacon_req_push(skb, &local->beacon_req);
> > > +       if (ret) {
> > > +               kfree_skb(skb);
> > > +               return ret;
> > > +       }
> > > +
> > > +       return drv_xmit_async(local, skb);
> >
> > I think you need to implement a sync transmit handling here.
>
> True.
>
> > And what
> > I mean is not using dryv_xmit_sync() (It is a long story and should
> > not be used, it's just that the driver is allowed to call bus api
> > functions which can sleep).
>
> Understood.
>

I think we should care about drivers which use drv_xmit_sync() or we
disable scan operations for them... so the actual transmit function
should prefer async but use sync if it's not implemented. I am not a
fan of this inside the core, if some driver really want to workaround
their bus system because it's simpler to use or whatever they should
do that inside the driver and not let the core queue it for them in
the right context. There are reasons why xmit_do is in softirq
context.

> > We don't have such a function yet (but I
> > think it can be implemented), you should wait until the transmission
> > is done. If we don't wait we fill framebuffers on the hardware while
> > the hardware is transmitting the framebuffer which is... bad.
>
> Do you already have something in mind?
>
> If I focus on the scan operation, it could be that we consider the
> queue empty, then we put this transfer, wait for completion and
> continue. But this only work for places where we know we have full
> control over what is transmitted (eg. during a scan) and not for all
> transfers. Would this fit your idea?
>
> Or do you want something more generic with some kind of an
> internal queue where we have the knowledge of what has been queued and
> a token to link with every xmit_done call that is made?
>
> I'm open to suggestions.
>

That we currently allow only one skb at one time (because ?all?
supported hardware doesn't have multiple tx framebuffers) this makes
everything for now pretty simple.

Don't let the queue run empty, the queue here is controlled by the
qdsic (I suppose and I hope we are talking about the same queue) we
already stop the queue which stops further skb to transmit to the
hardware but there can be one ongoing which we need to wait for. I
said in a previous mail a wait_for_completion()/complete() works here,
but I think now that could be problematic because scan-op ->
wait_for_completion() and complete() can run parallel in different
contexts. I think we need to do that over a waitqueue and a
wait_event(). Maybe you can track somehow with an atomic counter how
many transmissions are currently ongoing (should be never higher than
one currently). However the atomic counter will be future proofed when
we support filling up more than one framebuffer. So the condition for
wait_event() would be atomic_test(phy->ongoing_txs) - or something
like that. Increment in transmit path and decrement in xmit_done path,
if it hits zero wake_up() the queue so the condition will be checked
again.

That the queue is controlled by qdisc and we stop the queue for a long
time will somehow act the qdisc badly and dropping skb's in the
"hotpath" as I mentioned earlier it should be okay.

Be sure we don't activate the queue again in the  xmit complete
function, if we do the WARN_ON(mac...queue_stopped()) should be
triggered and this indicates we were not expecting to transmit
something over this path.

- Alex
