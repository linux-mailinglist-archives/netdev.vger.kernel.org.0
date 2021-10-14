Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B242D49B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJNIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:16:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60431 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhJNIQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634199284; x=1665735284;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2Q6yaUU9qlb3WZoZtGPuaVZXBC1cFKtpGHsUGf9FZr8=;
  b=A9fHbjpUvn1Qs03mLRO5MinIqvWFHXoMx9m4X5VxA2MrwlrSwJZ3A7oa
   lvHINFRp+bEU9TxeGHi6rdiDj2aecRHMKbwyK8BRH+/sidr/W271ppSA2
   3rBYMHeRQj7EqBqNALJdXFQMgLatLzDD0QgVEvyyENJbzX90ZIG4jbsJ/
   dIu44nWQhj9BJg60n2oexHxOJ4zYu/ZlgNRwq4luCXUiZZhw1GLwolyYq
   4XubzTPYFmNtZ/AimfPE2mvGKLfk5/WdaW2rHg9t4mzDS2a5M/in55xLM
   NMUBVd8vlccvtpoJyxV7B6NaoSJ83voOE38dZLogZJIQbNP9CzXAyotuC
   Q==;
IronPort-SDR: Xu1iAr4SBtsG5mthR3lwDh4e0vRa4rcH7tbNgf8PI3EYuWhiiXtuIKn2apCnCxo33CSyg8x6kK
 hJ14QGc5w1TvfGuywE321RsUYJBVwqWJgiXFEcFwXN7mvpucd7ZwPd/QMQ2iErvyRFtz3DcDdB
 QG5XqhnswomVeZsr7yuPr+QErYYi58cNxjdkge9RW5lLzRuDTn+0+a3NxfiUEQNY1+ULoebaBf
 rww9ptBLAZ+Ebgk8iS/QYyEuVQslO4QVL2qcgfPcynOpmRVAaOioy6rqzXiWQqA3EOU8aeZVeo
 11omhRztmRK9TCcB4Ytc9Wos
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="140256199"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2021 01:14:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Oct 2021 01:14:44 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 14 Oct 2021 01:14:42 -0700
Subject: Re: [PATCH net-next 4/7] ethernet: manually convert
 memcpy(dev_addr,..., sizeof(addr))
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <claudiu.beznea@microchip.com>,
        <f.fainelli@gmail.com>, <petkan@nucleusys.com>,
        <christophe.jaillet@wanadoo.fr>, <zhangchangzhong@huawei.com>,
        <linux-usb@vger.kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
 <20211013204435.322561-5-kuba@kernel.org>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <669ce977-1181-9522-2503-746a0499d383@microchip.com>
Date:   Thu, 14 Oct 2021 10:14:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211013204435.322561-5-kuba@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2021 at 22:44, Jakub Kicinski wrote:
> A handful of drivers use sizeof(addr) for the size of
> the address, after manually confirming the size is
> indeed 6 convert them to eth_hw_addr_set().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: nicolas.ferre@microchip.com

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> CC: claudiu.beznea@microchip.com
> CC: f.fainelli@gmail.com
> CC: petkan@nucleusys.com
> CC: christophe.jaillet@wanadoo.fr
> CC: zhangchangzhong@huawei.com
> CC: linux-usb@vger.kernel.org
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>   drivers/net/ethernet/dnet.c              | 2 +-
>   drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
>   drivers/net/ethernet/ti/cpmac.c          | 2 +-
>   drivers/net/usb/pegasus.c                | 2 +-
>   5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 683f14665c2c..029dea2873e3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -313,7 +313,7 @@ static void macb_get_hwaddr(struct macb *bp)
>                  addr[5] = (top >> 8) & 0xff;
> 
>                  if (is_valid_ether_addr(addr)) {
> -                       memcpy(bp->dev->dev_addr, addr, sizeof(addr));
> +                       eth_hw_addr_set(bp->dev, addr);
>                          return;
>                  }
>          }
> diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
> index 3ed21ba4eb99..92462ed87bc4 100644
> --- a/drivers/net/ethernet/dnet.c
> +++ b/drivers/net/ethernet/dnet.c
> @@ -93,7 +93,7 @@ static void dnet_get_hwaddr(struct dnet *bp)
>          *((__be16 *)(addr + 4)) = cpu_to_be16(tmp);
> 
>          if (is_valid_ether_addr(addr))
> -               memcpy(bp->dev->dev_addr, addr, sizeof(addr));
> +               eth_hw_addr_set(bp->dev, addr);
>   }
> 
>   static int dnet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
> index 5512e43bafc1..f0ace3a0e85c 100644
> --- a/drivers/net/ethernet/pasemi/pasemi_mac.c
> +++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
> @@ -1722,7 +1722,7 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                  err = -ENODEV;
>                  goto out;
>          }
> -       memcpy(dev->dev_addr, mac->mac_addr, sizeof(mac->mac_addr));
> +       eth_hw_addr_set(dev, mac->mac_addr);
> 
>          ret = mac_to_intf(mac);
>          if (ret < 0) {
> diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
> index 02d4e51f7306..7449436fc87c 100644
> --- a/drivers/net/ethernet/ti/cpmac.c
> +++ b/drivers/net/ethernet/ti/cpmac.c
> @@ -1112,7 +1112,7 @@ static int cpmac_probe(struct platform_device *pdev)
>          priv->dev = dev;
>          priv->ring_size = 64;
>          priv->msg_enable = netif_msg_init(debug_level, 0xff);
> -       memcpy(dev->dev_addr, pdata->dev_addr, sizeof(pdata->dev_addr));
> +       eth_hw_addr_set(dev, pdata->dev_addr);
> 
>          snprintf(priv->phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT,
>                                                  mdio_bus_id, phy_id);
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 6a92a3fef75e..c4cd40b090fd 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -357,7 +357,7 @@ static void set_ethernet_addr(pegasus_t *pegasus)
>                          goto err;
>          }
> 
> -       memcpy(pegasus->net->dev_addr, node_id, sizeof(node_id));
> +       eth_hw_addr_set(pegasus->net, node_id);
> 
>          return;
>   err:
> --
> 2.31.1
> 


-- 
Nicolas Ferre
