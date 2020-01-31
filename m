Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA714E9C8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgAaIsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:48:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36927 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgAaIsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 03:48:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so2458915plz.4;
        Fri, 31 Jan 2020 00:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5ycccSqPafUQDUtArWJENgWEJXME9xnY8wDyWmiLVw=;
        b=CtCjGMxHlPa4uMBe55NlXbqQ2Ri9C6ybpjqfv3+Q45xOWA+0PRrI+HH7abYlewqIMe
         JElfCO3sLos1TxRjfZ+bArgAjmSLiCPYWIufxyd42VnqnBTaUCUP3f36GmdeEpc0LQ8l
         5lQEZNT53I9+hpinOzEh7SB9irGLI90zc7Ph5xdp0eDFdktqKzCKbxKt6kFS9sWr0DDA
         jFOkroK/s3JcQzwjPyZc22e/lAhqN0mLPFUTwPGn5w4z5ahN2JEkION/DaKhvcHOjp+t
         7dF8dHtRRg8bFr4rrXWE4bHbVaAOW1rxA9X+wpv3zllUE66krzpaAf6zzZc7e5FvtV6l
         cafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5ycccSqPafUQDUtArWJENgWEJXME9xnY8wDyWmiLVw=;
        b=nf6T8kJl1rNu4tNfk+nuo9+5njKCOto1/N6YWJrqdquKQqDgy1CyLC9zE/6ryypEy9
         0G2dSqvCIOSjuLcnvca9BebX0+IyIfy9+/soUSShop+v68jZ012cEufGplh2zUvy1lCV
         ItjxPfGNvbwdrGkz29w94nsqyS2nJzIsOvTnat/Zed7v+zvNSlTVvuqNRfazYfC/7O9F
         LjuxhW+4sVTJPPFS6pOGoC73I54pr7NJzuNJMoo9Zn0w3yS5Ck1CnVqq0XdbjqwhYz0m
         gn4RGUqwHqZ0vKigMCq+NDY1Er9SQgX0rKhie1OaurNg3l2JtM2TtlgSutsVoqivqGPP
         bmuQ==
X-Gm-Message-State: APjAAAX1nNKmamD2MTA/rPA5LvGnDj7t3UJhq8e8cBBTpvTDn6dbG7IF
        qdzGfkhQdDaiWby3c3R8nwzYH3AC5ACVVLFaatFWQHfLqqY=
X-Google-Smtp-Source: APXvYqyiNY4uwfOnlxbSqgONwjK+nUKqWtW8I5m0IqBAngruxNfTIHVXqcPwf70qsozwC/k9s9tg0VayqPXTxiO6peM=
X-Received: by 2002:a17:90a:b10b:: with SMTP id z11mr11383068pjq.132.1580460511210;
 Fri, 31 Jan 2020 00:48:31 -0800 (PST)
MIME-Version: 1.0
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain> <CAHp75Vd_CNFx8xT9yO9LA=jKjT_xnc3XotUJx4jNFKaq0bpHsg@mail.gmail.com>
In-Reply-To: <CAHp75Vd_CNFx8xT9yO9LA=jKjT_xnc3XotUJx4jNFKaq0bpHsg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jan 2020 10:48:22 +0200
Message-ID: <CAHp75VcxgoMstVHEUyUT9nwYKGgLER7_jXjtp+zFWfJQ1k=ykA@mail.gmail.com>
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 10:12 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Jan 31, 2020 at 7:03 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > The device_get_phy_mode() was returning negative error codes on
> > failure and positive phy_interface_t values on success.  The problem is
> > that the phy_interface_t type is an enum which GCC treats as unsigned.
> > This lead to recurring signedness bugs where we check "if (phy_mode < 0)"
> > and "phy_mode" is unsigned.
> >
> > In the commit 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve
> > int/unit warnings") we updated of_get_phy_mode() take a pointer to
> > phy_mode and only return zero on success and negatives on failure.  This
> > patch does the same thing for device_get_phy_mode().  Plus it's just
> > nice for the API to be the same in both places.
> >
>
> For device property API changes
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Sorry, have to withdraw my tag. See below.

> > Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This is a change to drivers/base/ but all the users are ethernet drivers
> > so probably it makes sense for Dave to take this?
> >
> > Also this fixes a bug in stmmac.  If you wanted I could make a one
> > liner fix for that and then write this change on top of that.  The bug
> > is only in v5.6 so it doesn't affect old kernels.
> >
> >  drivers/base/property.c                               | 13 +++++++++++--
> >  drivers/net/ethernet/apm/xgene-v2/main.c              |  9 ++++-----
> >  drivers/net/ethernet/apm/xgene-v2/main.h              |  2 +-
> >  drivers/net/ethernet/apm/xgene/xgene_enet_main.c      |  6 +++---
> >  drivers/net/ethernet/apm/xgene/xgene_enet_main.h      |  2 +-
> >  drivers/net/ethernet/smsc/smsc911x.c                  |  8 +++-----
> >  drivers/net/ethernet/socionext/netsec.c               |  5 ++---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |  6 +++---
> >  include/linux/property.h                              |  3 ++-
> >  9 files changed, 30 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 511f6d7acdfe..8854cfbd213b 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -863,9 +863,18 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
> >   * 'phy-connection-type', and return its index in phy_modes table, or errno in
> >   * error case.
> >   */

You forgot to update documentation part.
After addressing you may put my tag back.

> > -int device_get_phy_mode(struct device *dev)
> > +int device_get_phy_mode(struct device *dev, phy_interface_t *interface)
> >  {
> > -       return fwnode_get_phy_mode(dev_fwnode(dev));
> > +       int mode;
> > +
> > +       *interface = PHY_INTERFACE_MODE_NA;
> > +
> > +       mode = fwnode_get_phy_mode(dev_fwnode(dev));
> > +       if (mode < 0)
> > +               return mode;
> > +
> > +       *interface = mode;
> > +       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(device_get_phy_mode);
> >
> > diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
> > index c48f60996761..706602918dd1 100644
> > --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> > +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> > @@ -15,7 +15,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
> >  {
> >         struct platform_device *pdev;
> >         struct net_device *ndev;
> > -       int phy_mode, ret = 0;
> > +       int ret = 0;
> >         struct resource *res;
> >         struct device *dev;
> >
> > @@ -41,12 +41,11 @@ static int xge_get_resources(struct xge_pdata *pdata)
> >
> >         memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
> >
> > -       phy_mode = device_get_phy_mode(dev);
> > -       if (phy_mode < 0) {
> > +       ret = device_get_phy_mode(dev, &pdata->resources.phy_mode);
> > +       if (ret) {
> >                 dev_err(dev, "Unable to get phy-connection-type\n");
> > -               return phy_mode;
> > +               return ret;
> >         }
> > -       pdata->resources.phy_mode = phy_mode;
> >
> >         if (pdata->resources.phy_mode != PHY_INTERFACE_MODE_RGMII) {
> >                 dev_err(dev, "Incorrect phy-connection-type specified\n");
> > diff --git a/drivers/net/ethernet/apm/xgene-v2/main.h b/drivers/net/ethernet/apm/xgene-v2/main.h
> > index d41439d2709d..d687f0185908 100644
> > --- a/drivers/net/ethernet/apm/xgene-v2/main.h
> > +++ b/drivers/net/ethernet/apm/xgene-v2/main.h
> > @@ -35,7 +35,7 @@
> >
> >  struct xge_resource {
> >         void __iomem *base_addr;
> > -       int phy_mode;
> > +       phy_interface_t phy_mode;
> >         u32 irq;
> >  };
> >
> > diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> > index 6aee2f0fc0db..da35e70ccceb 100644
> > --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> > +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> > @@ -1736,10 +1736,10 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
> >
> >         memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
> >
> > -       pdata->phy_mode = device_get_phy_mode(dev);
> > -       if (pdata->phy_mode < 0) {
> > +       ret = device_get_phy_mode(dev, &pdata->phy_mode);
> > +       if (ret) {
> >                 dev_err(dev, "Unable to get phy-connection-type\n");
> > -               return pdata->phy_mode;
> > +               return ret;
> >         }
> >         if (!phy_interface_mode_is_rgmii(pdata->phy_mode) &&
> >             pdata->phy_mode != PHY_INTERFACE_MODE_SGMII &&
> > diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
> > index 18f4923b1723..600cddf1942d 100644
> > --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
> > +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
> > @@ -209,7 +209,7 @@ struct xgene_enet_pdata {
> >         void __iomem *pcs_addr;
> >         void __iomem *ring_csr_addr;
> >         void __iomem *ring_cmd_addr;
> > -       int phy_mode;
> > +       phy_interface_t phy_mode;
> >         enum xgene_enet_rm rm;
> >         struct xgene_enet_cle cle;
> >         u64 *extd_stats;
> > diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
> > index 49a6a9167af4..2d773e5e67f8 100644
> > --- a/drivers/net/ethernet/smsc/smsc911x.c
> > +++ b/drivers/net/ethernet/smsc/smsc911x.c
> > @@ -2361,14 +2361,12 @@ static const struct smsc911x_ops shifted_smsc911x_ops = {
> >  static int smsc911x_probe_config(struct smsc911x_platform_config *config,
> >                                  struct device *dev)
> >  {
> > -       int phy_interface;
> >         u32 width = 0;
> >         int err;
> >
> > -       phy_interface = device_get_phy_mode(dev);
> > -       if (phy_interface < 0)
> > -               phy_interface = PHY_INTERFACE_MODE_NA;
> > -       config->phy_interface = phy_interface;
> > +       err = device_get_phy_mode(dev, &config->phy_interface);
> > +       if (err)
> > +               config->phy_interface = PHY_INTERFACE_MODE_NA;
> >
> >         device_get_mac_address(dev, config->mac, ETH_ALEN);
> >
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index e8224b543dfc..95ff91230523 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -1994,10 +1994,9 @@ static int netsec_probe(struct platform_device *pdev)
> >         priv->msg_enable = NETIF_MSG_TX_ERR | NETIF_MSG_HW | NETIF_MSG_DRV |
> >                            NETIF_MSG_LINK | NETIF_MSG_PROBE;
> >
> > -       priv->phy_interface = device_get_phy_mode(&pdev->dev);
> > -       if ((int)priv->phy_interface < 0) {
> > +       ret = device_get_phy_mode(&pdev->dev, &priv->phy_interface);
> > +       if (ret) {
> >                 dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
> > -               ret = -ENODEV;
> >                 goto free_ndev;
> >         }
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > index d10ac54bf385..aa77c332ea1d 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > @@ -412,9 +412,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
> >                 *mac = NULL;
> >         }
> >
> > -       plat->phy_interface = device_get_phy_mode(&pdev->dev);
> > -       if (plat->phy_interface < 0)
> > -               return ERR_PTR(plat->phy_interface);
> > +       rc = device_get_phy_mode(&pdev->dev, &plat->phy_interface);
> > +       if (rc)
> > +               return ERR_PTR(rc);
> >
> >         plat->interface = stmmac_of_get_mac_mode(np);
> >         if (plat->interface < 0)
> > diff --git a/include/linux/property.h b/include/linux/property.h
> > index d86de017c689..2ffe9842c997 100644
> > --- a/include/linux/property.h
> > +++ b/include/linux/property.h
> > @@ -12,6 +12,7 @@
> >
> >  #include <linux/bits.h>
> >  #include <linux/fwnode.h>
> > +#include <linux/phy.h>
> >  #include <linux/types.h>
> >
> >  struct device;
> > @@ -368,7 +369,7 @@ enum dev_dma_attr device_get_dma_attr(struct device *dev);
> >
> >  const void *device_get_match_data(struct device *dev);
> >
> > -int device_get_phy_mode(struct device *dev);
> > +int device_get_phy_mode(struct device *dev, phy_interface_t *interface);
> >
> >  void *device_get_mac_address(struct device *dev, char *addr, int alen);
> >
> > --
> > 2.11.0
> >
>
>
> --
> With Best Regards,
> Andy Shevchenko



-- 
With Best Regards,
Andy Shevchenko
