Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A961C60FF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEETZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgEETZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:25:41 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF17C061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:25:40 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id o7so3045330oif.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKLj+Bvazx+0GBaDeiW8XR54CzGKY4AHaP4cILqovw8=;
        b=SJdtgGTW5rf7rigkvrS0mGJrpwJvn5sAzRAkkSYrU2yWA/lI6TmCZF0sq1SvNFwlg1
         kREVUdbiAPDNjSfxcJ7oIXu434wnGVlmGdtL6WbnnD9hbqTKUgJpUSsrG2XH0oFtkDpS
         blRYXGrjL79B5wOO2fnZ53Ph/JTysPZXNngkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RKLj+Bvazx+0GBaDeiW8XR54CzGKY4AHaP4cILqovw8=;
        b=CxXirK9Am/VVulxeFDeOGLvysfOQKpfahXGh1Wt1fbUNXPB9sZNjfKKALq/HP4ENCJ
         WWWqTo4qA0Z7lR/MdamYSFFPrMRFG6bISnK70WtKCpmqhuk9OvyZCuhfX8kAwZw4mTcD
         +C1HNriU45hhpDlviK71StT0A0ZMV3ZlLKv1K4kqCYtR5jsOGCl5P+RXyQBaODVmubn8
         ZdH2BKypeBG1esCEpBEipEQBK9Lw4Tf41r6DKS6EQjjnH6ZDFQv7ArrGE4boO4RMQpeD
         MnpUpHW5dwvXJ+VgIeWKUqiFsmQSdp3VLJr26J/LboXKGREHBs5//UCXL0Qt+X/eX7k8
         iz7Q==
X-Gm-Message-State: AGi0PubgLd/1SUh4mbFCbvVdHHecouH640dRUSW2ueMduqoW2iVcDbTA
        ZO7uDRWn/DeuXgQC6/XfzX0yHYIC6VAwbSmfaJQDdA==
X-Google-Smtp-Source: APiQypJj1DkGUZt7VIZXosUiRMoBR0Hk5xmD/ibsZ1474R2bICyoP6W/sR5eJX+NBmdVffk3jmYWOAdQstorpI7Bi6g=
X-Received: by 2002:aca:403:: with SMTP id 3mr227565oie.166.1588706739870;
 Tue, 05 May 2020 12:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-6-brgl@bgdev.pl>
In-Reply-To: <20200505140231.16600-6-brgl@bgdev.pl>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 5 May 2020 12:25:03 -0700
Message-ID: <CAKOOJTzcNr7mc9xusQm3nCzkq5P=ha-si3fizeEL2_KJUOC3-Q@mail.gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 7:05 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Provide devm_register_netdev() - a device resource managed variant
> of register_netdev(). This new helper will only work for net_device
> structs that have a parent device assigned and are devres managed too.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  include/linux/netdevice.h |  4 ++++
>  net/core/dev.c            | 48 +++++++++++++++++++++++++++++++++++++++
>  net/ethernet/eth.c        |  1 +
>  3 files changed, 53 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 130a668049ab..433bd5ca2efc 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1515,6 +1515,8 @@ struct net_device_ops {
>   * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
>   * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
>   * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
> + * @IFF_IS_DEVRES: this structure was allocated dynamically and is managed by
> + *     devres
>   */
>  enum netdev_priv_flags {
>         IFF_802_1Q_VLAN                 = 1<<0,
> @@ -1548,6 +1550,7 @@ enum netdev_priv_flags {
>         IFF_FAILOVER_SLAVE              = 1<<28,
>         IFF_L3MDEV_RX_HANDLER           = 1<<29,
>         IFF_LIVE_RENAME_OK              = 1<<30,
> +       IFF_IS_DEVRES                   = 1<<31,
>  };
>
>  #define IFF_802_1Q_VLAN                        IFF_802_1Q_VLAN
> @@ -4206,6 +4209,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>                          count)
>
>  int register_netdev(struct net_device *dev);
> +int devm_register_netdev(struct net_device *ndev);
>  void unregister_netdev(struct net_device *dev);
>
>  /* General hardware address lists handling functions */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 522288177bbd..99db537c9468 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(register_netdev);
>
> +struct netdevice_devres {
> +       struct net_device *ndev;
> +};
> +
> +static void devm_netdev_release(struct device *dev, void *this)
> +{
> +       struct netdevice_devres *res = this;
> +
> +       unregister_netdev(res->ndev);
> +}
> +
> +/**
> + *     devm_register_netdev - resource managed variant of register_netdev()
> + *     @ndev: device to register
> + *
> + *     This is a devres variant of register_netdev() for which the unregister
> + *     function will be call automatically when the parent device of ndev
> + *     is detached.
> + */
> +int devm_register_netdev(struct net_device *ndev)
> +{
> +       struct netdevice_devres *dr;
> +       int ret;
> +
> +       /* struct net_device itself must be devres managed. */
> +       BUG_ON(!(ndev->priv_flags & IFF_IS_DEVRES));
> +       /* struct net_device must have a parent device - it will be the device
> +        * managing this resource.
> +        */

Catching static programming errors seems like an expensive use of the
last runtime flag in the enum. It would be weird to devres manage the
unregister and not also choose to manage the underlying memory in the
same fashion, so it wouldn't be an obvious mistake to make. If it must
be enforced, one could also iterate over the registered release
functions and check for the presence of devm_free_netdev without
burning the flag.

> +       BUG_ON(!ndev->dev.parent);
> +
> +       dr = devres_alloc(devm_netdev_release, sizeof(*dr), GFP_KERNEL);
> +       if (!dr)
> +               return -ENOMEM;
> +
> +       ret = register_netdev(ndev);
> +       if (ret) {
> +               devres_free(dr);
> +               return ret;
> +       }
> +
> +       dr->ndev = ndev;
> +       devres_add(ndev->dev.parent, dr);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(devm_register_netdev);
> +
>  int netdev_refcnt_read(const struct net_device *dev)
>  {
>         int i, refcnt = 0;
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index c8b903302ff2..ce9b5e576f20 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -423,6 +423,7 @@ struct net_device *devm_alloc_etherdev_mqs(struct device *dev, int sizeof_priv,
>
>         *dr = netdev;
>         devres_add(dev, dr);
> +       netdev->priv_flags |= IFF_IS_DEVRES;
>
>         return netdev;
>  }
> --
> 2.25.0
>

Regards,
Edwin Peer
