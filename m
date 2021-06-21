Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB03AE35E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFUGqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhFUGqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:46:43 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB21DC061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 23:44:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y13so1874312plc.8
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 23:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHd2vjQRaZdxs1CT99P/k6JhVKuhqPBmSb4egzu1WEo=;
        b=a0TM5N41PpGi7CotuUZ1ZXg0iZO6cHph9RufpjoZtj97UfJ7VJ1s5b8aLm90/Ql/6K
         jOamyGVLfVK6JBnAYIanko1tu3zUf3dp/MCI8+ZFO28atG//vbhT2M1xgKmX4c6QqgdY
         o8xU2Dgd1MIEL7f8QHx3YYwhmPtBk58//Q9aiDn12rJyZTdHaTDvIuX0xAs4H0TtbKDR
         5Q6YBEpcTwHAPPvEnULedVXHjIvMNv48jMlWy/9eXhuwuoujOwmq56/Xv6Fj22ojxAEw
         bQe+rojIAZ0yOfLn8AOPny1GU1UpAMbeiuokSsjiNyJgXqaDnQeZCVCqWsR8c+8Y301F
         Gf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHd2vjQRaZdxs1CT99P/k6JhVKuhqPBmSb4egzu1WEo=;
        b=fsxS9piw5tva6DPl+m15S6zjsz3EhajNKQev2x9igEFgNJValCVV7vdSWy1ASTkfnU
         RfUo9eAsbosDRoMjnSXT4B2cSiySZp3GqXYvusns1nQl6s9rPiKZzbS7vD8a3hqQJv+d
         PuemZdK6yBinGvHddiEVIKLV+KoqLDQW/Rkthr/5L3GjOxvZAZGQ5itYkQA89ATB9KJv
         QnaUXUc9xAWrnmLXgR3+ZBja5lIHcKcR0EK5qZSVGI4U04NscOUfuVXROOsyOY9udVXn
         IhxrjZCPlUckCFdo19S5ADOclLc/RGXcYQFY8h2Xn6OyhE5cwP1k4etm+mhY8LNQh7f1
         YhCQ==
X-Gm-Message-State: AOAM5305jIqNAluLiSlVXuYKJFh0VdQQIH3Lfb29NAG7ITwsToOAwkcS
        UFt364lN98JkEUQLJlSUkb/BM761Jn/k2aWTB1q50w==
X-Google-Smtp-Source: ABdhPJx402BtfA+pdqUmEga/aRdrINZHUWyaYG4CjJyyu1T09IZ9b0s4JH1wnQrlqJGnlzSiy+j97ON8HLs/VnRQ0Rw=
X-Received: by 2002:a17:90a:5106:: with SMTP id t6mr28366378pjh.231.1624257869115;
 Sun, 20 Jun 2021 23:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-10-ryazanov.s.a@gmail.com>
 <CAMZdPi-C+Yhf27+-7Ct-1pkp0htrr6Qbt=Om2KQk+5aVVFPRMQ@mail.gmail.com> <CAHNKnsRDuf=zuqeAMJgZ5kW6Kd1GsOd6-v5AX4ScCt7_muJp6g@mail.gmail.com>
In-Reply-To: <CAHNKnsRDuf=zuqeAMJgZ5kW6Kd1GsOd6-v5AX4ScCt7_muJp6g@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 21 Jun 2021 08:53:23 +0200
Message-ID: <CAMZdPi_-4tWfo-adLPJvbR5deAD1HsO6XYKSpdHOSs9t-6X1CQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] net: mhi_net: create default link via WWAN core
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Sun, 20 Jun 2021 at 15:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hi Loic,
>
> CC Aleksander, as the talk drifts towards ModemManager.
>
> On Tue, Jun 15, 2021 at 10:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >> Utilize the just introduced WWAN core feature to create a default netdev
> >> for the default data channel. Since the netdev is now created via the
> >> WWAN core, rely on it ability to destroy all child netdevs on ops
> >> unregistering.
> >>
> >> While at it, remove the RTNL lock acquiring hacks that were earlier used
> >> to call addlink/dellink without holding the RTNL lock. Also make the
> >> WWAN netdev ops structure static to make sparse happy.
> >>
> >> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> >> ---
> >>  drivers/net/mhi/net.c | 54 +++++--------------------------------------
> >>  1 file changed, 6 insertions(+), 48 deletions(-)
> >>
> >> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> >> index b003003cbd42..06253acecaa2 100644
> >> --- a/drivers/net/mhi/net.c
> >> +++ b/drivers/net/mhi/net.c
> >> @@ -342,10 +342,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
> >>         /* Number of transfer descriptors determines size of the queue */
> >>         mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> >>
> >> -       if (extack)
> >> -               err = register_netdevice(ndev);
> >> -       else
> >> -               err = register_netdev(ndev);
> >> +       err = register_netdevice(ndev);
> >>         if (err)
> >>                 goto out_err;
> >>
> >> @@ -370,10 +367,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
> >>         struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> >>         struct mhi_device *mhi_dev = ctxt;
> >>
> >> -       if (head)
> >> -               unregister_netdevice_queue(ndev, head);
> >> -       else
> >> -               unregister_netdev(ndev);
> >> +       unregister_netdevice_queue(ndev, head);
> >>
> >>         mhi_unprepare_from_transfer(mhi_dev);
> >>
> >> @@ -382,7 +376,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
> >>         dev_set_drvdata(&mhi_dev->dev, NULL);
> >>  }
> >>
> >> -const struct wwan_ops mhi_wwan_ops = {
> >> +static const struct wwan_ops mhi_wwan_ops = {
> >>         .priv_size = sizeof(struct mhi_net_dev),
> >>         .setup = mhi_net_setup,
> >>         .newlink = mhi_net_newlink,
> >> @@ -392,55 +386,19 @@ const struct wwan_ops mhi_wwan_ops = {
> >>  static int mhi_net_probe(struct mhi_device *mhi_dev,
> >>                          const struct mhi_device_id *id)
> >>  {
> >> -       const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
> >>         struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
> >> -       struct net_device *ndev;
> >> -       int err;
> >> -
> >> -       err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
> >> -                               WWAN_NO_DEFAULT_LINK);
> >> -       if (err)
> >> -               return err;
> >> -
> >> -       if (!create_default_iface)
> >> -               return 0;
> >> -
> >> -       /* Create a default interface which is used as either RMNET real-dev,
> >> -        * MBIM link 0 or ip link 0)
> >> -        */
> >> -       ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
> >> -                           NET_NAME_PREDICTABLE, mhi_net_setup);
> >
> > I like the idea of the default link, but here we need to create the
> > netdev manually for several reasons:
> > - In case of QMAP/rmnet, this link is the lower netdev (transport
> > layer) and is not associated with any link id.
> > - In case of MBIM, it changes the netdev parent device from the MHI
> > dev to the WWAN dev, which (currently) breaks how ModemManager groups
> > ports/netdevs (based on bus).
> >
> > For the last one, I don't think device hierarchy is considered as
> > UAPI, so we probably just need to add this new wwan link support to
> > user tools like MM. For the first one, I plan to split the mhi_net
> > driver into two different ones (mhi_net_qmap, mhi_net_mbim), and in
> > the case of qmap(rmnet) forward newlink/dellink call to rmnet
> > rtnetlink ops.
>
> Looks like I missed the complexity of WWAN devices handling. Thank you
> for pointing that out. Now I will drop this patch from the series.
>
> Just curious, am I right to say that any network interface created
> with wwan-core is not usable with ModemManager at the moment? AFAIU,
> ModemManager is unable to bundle a control port and a netdev into a
> common "modem" object, even if they both have the same parent Linux
> device, just because that device is not a physical USB device.

Right, there is an ongoing discussion about supporting iosm:
https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/issues/385#note_958408

So once we have it working for iosm, it should work for any WWAN
device using WWAN framework.

Regards,
Loic
