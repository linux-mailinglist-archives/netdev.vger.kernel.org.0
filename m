Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C743EA434
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhHLMAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 08:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhHLMAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 08:00:40 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E9BC061765
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 05:00:15 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id o123so839234qkf.12
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NU4IkNZ7PV/S2J7ELPwk+eWhVSihC9ZvvxT+TkohS3o=;
        b=aNw8dRU1jaGQvjFx90S/AwSa/Fra96qs3x0+IU+vSuWGDIetbNqQ46nBYx/SEgq8o3
         QN8IugflO/PH/6D3l84GqmaAZtNH60nt08rOCVIHebxOH+Ubp4owSMni+vRyIbS+pMFn
         aJN5HFug00nFdU12DNoHCXd2ewZ7vXKbhjKOO1edCdPnt2Cds9HmbUXEoLE8W8lkWzP5
         AIBMfTMs0rihgq82oAF8UMDqMYw0c4qrFIGXUHj/MhSlvZptlnPS0YlUGoZKKXDz2ltM
         PJTue9R2aOPZTitbzsANiu+RF2aIwRZ0JhiJVjn00pBq/MDO8a8k9HG1xahEDSmGWP+H
         EwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NU4IkNZ7PV/S2J7ELPwk+eWhVSihC9ZvvxT+TkohS3o=;
        b=rnHvatCcofIXSJi+TLFrub7DDpO19JC4GP6yIXR5ml7rJS9/eqYMl6b7pEzjObymE7
         KQJjGnenZYPbrIskA6fvNFBCrXnXCBOtIqeG+VAV2oiwv95ZV57apbr3vxizzL6mBGlK
         ULaHND+uaRh0OdEdHN9TFYoaKa2p0uk4aiPtJSmsAJFaw8gObYtti1N2szpLJ3p/3/ge
         bKwuiDrSMzlVuIuLudIvlLTiNNQsldvtt5AVYVkvbgBqb4JtaxVrZ9FfdBEBnk78DEWW
         La96Gn/YvYZkW79feRBmPt2Rd3xSyVDU3oikn5qpR3eSCjG35tG+aVWm5u83T0bppSZ2
         d/Hw==
X-Gm-Message-State: AOAM531qVx5sX0FKPG3YccxEUgBET8cjY+25SRIzlQ5zkcv/ZBgLaHxL
        PjDlvisCaXqBSJl1NYn8MRyidfNP6X/bOpKMRfM=
X-Google-Smtp-Source: ABdhPJyABXlCbj0EQuqVIqfuNsiOxxIz0LCSEoHiPUm7cMxM8wgdRfB3JPAvZS5cRbvRfFfZ+jzFvm1jWcYM0840J68=
X-Received: by 2002:a05:620a:2451:: with SMTP id h17mr4063649qkn.377.1628769614548;
 Thu, 12 Aug 2021 05:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org> <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org> <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
 <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org> <87sfzlplr2.fsf@miraculix.mork.no>
 <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
In-Reply-To: <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Thu, 12 Aug 2021 14:02:27 +0200
Message-ID: <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Subash,

Il giorno lun 9 ago 2021 alle ore 23:40 <subashab@codeaurora.org> ha scritto:
>
> > No need for () around a constant, is there?
> >
> > Either I'm blind, or you don't actuelly change the rx_urb_size for the
> > mux and pass through modes?
> >
>
> I seem to have missed this and the other stuff you have pointed out.
> Can you please review this update-
>
> >
> > I'd also prefer this to reset back to syncing with hard_mtu if/when
> > muxing or passthrough is disabled.  Calling usbnet_change_mtu() won't
> > do
> > that. It doesn't touch rx_urb_size if it is different from hard_mtu.
> >
> > I also think that it might be useful to keep the mtu/hard_mtu control,
> > wouldn't it?
> >
> >
> > Something like
> >
> >    old_rx_urb_size = dev->rx_urb_size;
> >    if (mux|passthrough)
> >        dev->rx_urb_size = MAP_DL_URB_SIZE;
> >    else
> >        dev->rx_urb_size = dev->hard_mtu;
> >    if (dev->rx_urb_size > old_rx_urb_size)
> >        unlink_urbs etc;
> >    return usbnet_change_mtu(net, new_mtu);
> >
> > should do that, I think.  Completely untested....
> >
> > And add it to the (!qmimux_has_slaves(dev)) cas in del_mux_store() too.
> >
>
> Assuming this patch doesn't have too many other issues, can I request
> Aleksander / Daniele to try this out.
>

I'm currently in vacation for a few weeks, so I can't test the change
at the moment, will try to do when I come back.

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 6a2e4f8..4676544 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -75,6 +75,8 @@ struct qmimux_priv {
>          u8 mux_id;
>   };
>
> +#define MAP_DL_URB_SIZE 32768

Just an heads-up that when I proposed that urb size there were doubts
about the value (see
https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/#2523774
and https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/#2523958):
it is true that this time you are setting the size just when qmap is
enabled, but I think that Carl's comment about low-cat chipsets could
still apply.

Thanks,
Daniele

> +
>   static int qmimux_open(struct net_device *dev)
>   {
>          struct qmimux_priv *priv = netdev_priv(dev);
> @@ -303,6 +305,39 @@ static void qmimux_unregister_device(struct
> net_device *dev,
>          dev_put(real_dev);
>   }
>
> +static int qmi_wwan_change_mtu(struct net_device *net, int new_mtu)
> +{
> +       struct usbnet *dev = netdev_priv(net);
> +       struct qmi_wwan_state *info = (void *)&dev->data;
> +       int old_rx_urb_size = dev->rx_urb_size;
> +
> +       /* mux and pass through modes use a fixed rx_urb_size and the
> value
> +        * is independent of mtu
> +        */
> +       if (info->flags & (QMI_WWAN_FLAG_MUX |
> QMI_WWAN_FLAG_PASS_THROUGH)) {
> +               if (old_rx_urb_size == MAP_DL_URB_SIZE)
> +                       return 0;
> +
> +               if (old_rx_urb_size < MAP_DL_URB_SIZE) {
> +                       dev->rx_urb_size = MAP_DL_URB_SIZE;
> +
> +                       usbnet_pause_rx(dev);
> +                       usbnet_unlink_rx_urbs(dev);
> +                       usbnet_resume_rx(dev);
> +                       usbnet_update_max_qlen(dev);
> +               }
> +
> +               return 0;
> +       }
> +
> +       /* rawip mode uses existing logic of setting rx_urb_size based
> on mtu.
> +        * rx_urb_size will be updated within usbnet_change_mtu only if
> it is
> +        * equal to existing hard_mtu
> +        */
> +       dev->rx_urb_size = dev->hard_mtu;
> +       return usbnet_change_mtu(net, new_mtu);
> +}
> +
>   static void qmi_wwan_netdev_setup(struct net_device *net)
>   {
>          struct usbnet *dev = netdev_priv(net);
> @@ -326,7 +361,7 @@ static void qmi_wwan_netdev_setup(struct net_device
> *net)
>          }
>
>          /* recalculate buffers after changing hard_header_len */
> -       usbnet_change_mtu(net, net->mtu);
> +       qmi_wwan_change_mtu(net, net->mtu);
>   }
>
>   static ssize_t raw_ip_show(struct device *d, struct device_attribute
> *attr, char *buf)
> @@ -433,6 +468,7 @@ static ssize_t add_mux_store(struct device *d,
> struct device_attribute *attr, c
>          if (!ret) {
>                  info->flags |= QMI_WWAN_FLAG_MUX;
>                  ret = len;
> +               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
>          }
>   err:
>          rtnl_unlock();
> @@ -466,8 +502,11 @@ static ssize_t del_mux_store(struct device *d,
> struct device_attribute *attr, c
>          }
>          qmimux_unregister_device(del_dev, NULL);
>
> -       if (!qmimux_has_slaves(dev))
> +       if (!qmimux_has_slaves(dev)) {
>                  info->flags &= ~QMI_WWAN_FLAG_MUX;
> +               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
> +       }
> +
>          ret = len;
>   err:
>          rtnl_unlock();
> @@ -514,6 +553,8 @@ static ssize_t pass_through_store(struct device *d,
>          else
>                  info->flags &= ~QMI_WWAN_FLAG_PASS_THROUGH;
>
> +       qmi_wwan_change_mtu(dev->net, dev->net->mtu);
> +
>          return len;
>   }
>
> @@ -643,7 +684,7 @@ static const struct net_device_ops
> qmi_wwan_netdev_ops = {
>          .ndo_stop               = usbnet_stop,
>          .ndo_start_xmit         = usbnet_start_xmit,
>          .ndo_tx_timeout         = usbnet_tx_timeout,
> -       .ndo_change_mtu         = usbnet_change_mtu,
> +       .ndo_change_mtu         = qmi_wwan_change_mtu,
>          .ndo_get_stats64        = dev_get_tstats64,
>          .ndo_set_mac_address    = qmi_wwan_mac_addr,
>          .ndo_validate_addr      = eth_validate_addr,
