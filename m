Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA9110501
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfLCTYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:24:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40778 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfLCTYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:24:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so5179699wrn.7;
        Tue, 03 Dec 2019 11:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yhEyWleD6cfCzF9R+V5coo0Qv0HIrgGbATOdkoDJ9ao=;
        b=iw2OF0l8Yx20xPuT06SZ3yBdDfqIuxk8vIB7h4lOlrL2hUNWGsT8540mL0BaGR97YS
         64WvqyKWZPqukDR+T14StGm1a0/0czxVUAtGIpYcycx3LtNffhhns0ZlTPc83Gjn/ptF
         GThFVXKNmXYwvbmpqV1XviDfPCxVzeaip4znHcldqGvlk2mofwZ+2fjlNf4Oc3Dz75IS
         jxJ7Nk9t6oIfnh2uBrPtSOktlSJfxvfU+5TK7BpD4s9gU+FSJR3eDwKS7WHz2H1N8Tj3
         Io7KMbFzYS5JEJyp9yD3f2Ez3HA+RX+ZCbz9mijMnMTHZzwC/t2u5+4BusgitglvoSK/
         nBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yhEyWleD6cfCzF9R+V5coo0Qv0HIrgGbATOdkoDJ9ao=;
        b=H8qfjD+3iyGJGJlw/eiNICD7QR8HhnotsP7093wJjd/37IckjHvOmoKLmf/pV1lukH
         QpSxIjvSxvcZMNZjphqH3uLCc2Kjg9QFPQnEhN9/p3JIflGb58+O/GBC8fZt94IJnL3/
         Kv/RXttyRetkkgZZcpv1mCEa6qZ64M2iqSGSqicVQwnCvsUIX3B+I3fNj9i/pO5U4dkp
         ZA1pk+ODQrpZ7KcPvi/sot/35dma4TjFCzl0bmPtb+YYQ37pYwOZgFb36NgeDdY8d5OY
         C9P7wGP8Zzo4Wb/ldVcVvhSmHA8uQfLjUpPRb0dUma517Rs8n8djRtomsgFI8HPxcrni
         olxg==
X-Gm-Message-State: APjAAAUbmDk3kT/h2GgxauKq6rap4e3xR3QofCdPh3x0dHPUmeRIYw+x
        3v1bCgW+IfCE3nGh4bAZD9M=
X-Google-Smtp-Source: APXvYqy0vw4DvH3GBCs08RxmWbNJ4wrunb93VV5910xNrWUGeV+ll3BNL64bxqLxyGO7NhbIfPeg9A==
X-Received: by 2002:adf:df90:: with SMTP id z16mr7377009wrl.273.1575401064188;
        Tue, 03 Dec 2019 11:24:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:c5aa:b1f:2ae:5783? (p200300EA8F4A6300C5AA0B1F02AE5783.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:c5aa:b1f:2ae:5783])
        by smtp.googlemail.com with ESMTPSA id k16sm5279842wru.0.2019.12.03.11.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 11:24:23 -0800 (PST)
Subject: Re: [PATCH RFC v7 net-next] netdev: pass the stuck queue to the
 timeout handler
To:     "Michael S. Tsirkin" <mst@redhat.com>, jcfaracco@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
References: <20191203071101.427592-1-mst@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <715bde42-6ded-5868-f049-a39fb0c90ace@gmail.com>
Date:   Tue, 3 Dec 2019 20:24:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191203071101.427592-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2019 08:12, Michael S. Tsirkin wrote:
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
> 
> The patch was generated with the following script:
> 
> use strict;
> use warnings;
> 
> our $^I = '.bak';
> 
> my @work = (
> ["arch/m68k/emu/nfeth.c", "nfeth_tx_timeout"],
> ["arch/um/drivers/net_kern.c", "uml_net_tx_timeout"],
> ["arch/um/drivers/vector_kern.c", "vector_net_tx_timeout"],
> ["arch/xtensa/platforms/iss/network.c", "iss_net_tx_timeout"],
> ["drivers/char/pcmcia/synclink_cs.c", "hdlcdev_tx_timeout"],
> ["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
> ["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
> ["drivers/message/fusion/mptlan.c", "mpt_lan_tx_timeout"],
> ["drivers/misc/sgi-xp/xpnet.c", "xpnet_dev_tx_timeout"],
> ["drivers/net/appletalk/cops.c", "cops_timeout"],
> ["drivers/net/arcnet/arcdevice.h", "arcnet_timeout"],
> ["drivers/net/arcnet/arcnet.c", "arcnet_timeout"],
> ["drivers/net/arcnet/com20020.c", "arcnet_timeout"],
> ["drivers/net/ethernet/3com/3c509.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c515.c", "corkscrew_timeout"],
> ["drivers/net/ethernet/3com/3c574_cs.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c589_cs.c", "el3_tx_timeout"],
> ["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
> ["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
> ["drivers/net/ethernet/3com/typhoon.c", "typhoon_tx_timeout"],
> ["drivers/net/ethernet/8390/8390.h", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/8390.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/8390p.c", "eip_tx_timeout"],
> ["drivers/net/ethernet/8390/ax88796.c", "ax_ei_tx_timeout"],
> ["drivers/net/ethernet/8390/axnet_cs.c", "axnet_tx_timeout"],
> ["drivers/net/ethernet/8390/etherh.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/hydra.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/mac8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/mcf8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/lib8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/8390/ne2k-pci.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/pcnet_cs.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/smc-ultra.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/wd.c", "ei_tx_timeout"],
> ["drivers/net/ethernet/8390/zorro8390.c", "__ei_tx_timeout"],
> ["drivers/net/ethernet/adaptec/starfire.c", "tx_timeout"],
> ["drivers/net/ethernet/agere/et131x.c", "et131x_tx_timeout"],
> ["drivers/net/ethernet/allwinner/sun4i-emac.c", "emac_timeout"],
> ["drivers/net/ethernet/alteon/acenic.c", "ace_watchdog"],
> ["drivers/net/ethernet/amazon/ena/ena_netdev.c", "ena_tx_timeout"],
> ["drivers/net/ethernet/amd/7990.h", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/7990.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/a2065.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/am79c961a.c", "am79c961_timeout"],
> ["drivers/net/ethernet/amd/amd8111e.c", "amd8111e_tx_timeout"],
> ["drivers/net/ethernet/amd/ariadne.c", "ariadne_tx_timeout"],
> ["drivers/net/ethernet/amd/atarilance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/au1000_eth.c", "au1000_tx_timeout"],
> ["drivers/net/ethernet/amd/declance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/lance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/mvme147.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/ni65.c", "ni65_timeout"],
> ["drivers/net/ethernet/amd/nmclan_cs.c", "mace_tx_timeout"],
> ["drivers/net/ethernet/amd/pcnet32.c", "pcnet32_tx_timeout"],
> ["drivers/net/ethernet/amd/sunlance.c", "lance_tx_timeout"],
> ["drivers/net/ethernet/amd/xgbe/xgbe-drv.c", "xgbe_tx_timeout"],
> ["drivers/net/ethernet/apm/xgene-v2/main.c", "xge_timeout"],
> ["drivers/net/ethernet/apm/xgene/xgene_enet_main.c", "xgene_enet_timeout"],
> ["drivers/net/ethernet/apple/macmace.c", "mace_tx_timeout"],
> ["drivers/net/ethernet/atheros/ag71xx.c", "ag71xx_tx_timeout"],
> ["drivers/net/ethernet/atheros/alx/main.c", "alx_tx_timeout"],
> ["drivers/net/ethernet/atheros/atl1c/atl1c_main.c", "atl1c_tx_timeout"],
> ["drivers/net/ethernet/atheros/atl1e/atl1e_main.c", "atl1e_tx_timeout"],
> ["drivers/net/ethernet/atheros/atlx/atl1.c", "atlx_tx_timeout"],
> ["drivers/net/ethernet/atheros/atlx/atl2.c", "atl2_tx_timeout"],
> ["drivers/net/ethernet/broadcom/b44.c", "b44_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bcmsysport.c", "bcm_sysport_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2.c", "bnx2_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h", "bnx2x_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c", "bnx2x_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c", "bnx2x_tx_timeout"],
> ["drivers/net/ethernet/broadcom/bnxt/bnxt.c", "bnxt_tx_timeout"],
> ["drivers/net/ethernet/broadcom/genet/bcmgenet.c", "bcmgenet_timeout"],
> ["drivers/net/ethernet/broadcom/sb1250-mac.c", "sbmac_tx_timeout"],
> ["drivers/net/ethernet/broadcom/tg3.c", "tg3_tx_timeout"],
> ["drivers/net/ethernet/calxeda/xgmac.c", "xgmac_tx_timeout"],
> ["drivers/net/ethernet/cavium/liquidio/lio_main.c", "liquidio_tx_timeout"],
> ["drivers/net/ethernet/cavium/liquidio/lio_vf_main.c", "liquidio_tx_timeout"],
> ["drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c", "lio_vf_rep_tx_timeout"],
> ["drivers/net/ethernet/cavium/thunder/nicvf_main.c", "nicvf_tx_timeout"],
> ["drivers/net/ethernet/cirrus/cs89x0.c", "net_timeout"],
> ["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
> ["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
> ["drivers/net/ethernet/cortina/gemini.c", "gmac_tx_timeout"],
> ["drivers/net/ethernet/davicom/dm9000.c", "dm9000_timeout"],
> ["drivers/net/ethernet/dec/tulip/de2104x.c", "de_tx_timeout"],
> ["drivers/net/ethernet/dec/tulip/tulip_core.c", "tulip_tx_timeout"],
> ["drivers/net/ethernet/dec/tulip/winbond-840.c", "tx_timeout"],
> ["drivers/net/ethernet/dlink/dl2k.c", "rio_tx_timeout"],
> ["drivers/net/ethernet/dlink/sundance.c", "tx_timeout"],
> ["drivers/net/ethernet/emulex/benet/be_main.c", "be_tx_timeout"],
> ["drivers/net/ethernet/ethoc.c", "ethoc_tx_timeout"],
> ["drivers/net/ethernet/faraday/ftgmac100.c", "ftgmac100_tx_timeout"],
> ["drivers/net/ethernet/fealnx.c", "fealnx_tx_timeout"],
> ["drivers/net/ethernet/freescale/dpaa/dpaa_eth.c", "dpaa_tx_timeout"],
> ["drivers/net/ethernet/freescale/fec_main.c", "fec_timeout"],
> ["drivers/net/ethernet/freescale/fec_mpc52xx.c", "mpc52xx_fec_tx_timeout"],
> ["drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c", "fs_timeout"],
> ["drivers/net/ethernet/freescale/gianfar.c", "gfar_timeout"],
> ["drivers/net/ethernet/freescale/ucc_geth.c", "ucc_geth_timeout"],
> ["drivers/net/ethernet/fujitsu/fmvj18x_cs.c", "fjn_tx_timeout"],
> ["drivers/net/ethernet/google/gve/gve_main.c", "gve_tx_timeout"],
> ["drivers/net/ethernet/hisilicon/hip04_eth.c", "hip04_timeout"],
> ["drivers/net/ethernet/hisilicon/hix5hd2_gmac.c", "hix5hd2_net_timeout"],
> ["drivers/net/ethernet/hisilicon/hns/hns_enet.c", "hns_nic_net_timeout"],
> ["drivers/net/ethernet/hisilicon/hns3/hns3_enet.c", "hns3_nic_net_timeout"],
> ["drivers/net/ethernet/huawei/hinic/hinic_main.c", "hinic_tx_timeout"],
> ["drivers/net/ethernet/i825xx/82596.c", "i596_tx_timeout"],
> ["drivers/net/ethernet/i825xx/ether1.c", "ether1_timeout"],
> ["drivers/net/ethernet/i825xx/lib82596.c", "i596_tx_timeout"],
> ["drivers/net/ethernet/i825xx/sun3_82586.c", "sun3_82586_timeout"],
> ["drivers/net/ethernet/ibm/ehea/ehea_main.c", "ehea_tx_watchdog"],
> ["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/ibm/ibmvnic.c", "ibmvnic_tx_timeout"],
> ["drivers/net/ethernet/intel/e100.c", "e100_tx_timeout"],
> ["drivers/net/ethernet/intel/e1000/e1000_main.c", "e1000_tx_timeout"],
> ["drivers/net/ethernet/intel/e1000e/netdev.c", "e1000_tx_timeout"],
> ["drivers/net/ethernet/intel/fm10k/fm10k_netdev.c", "fm10k_tx_timeout"],
> ["drivers/net/ethernet/intel/i40e/i40e_main.c", "i40e_tx_timeout"],
> ["drivers/net/ethernet/intel/iavf/iavf_main.c", "iavf_tx_timeout"],
> ["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
> ["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
> ["drivers/net/ethernet/intel/igb/igb_main.c", "igb_tx_timeout"],
> ["drivers/net/ethernet/intel/igbvf/netdev.c", "igbvf_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgb/ixgb_main.c", "ixgb_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c", "adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev);"],
> ["drivers/net/ethernet/intel/ixgbe/ixgbe_main.c", "ixgbe_tx_timeout"],
> ["drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c", "ixgbevf_tx_timeout"],
> ["drivers/net/ethernet/jme.c", "jme_tx_timeout"],
> ["drivers/net/ethernet/korina.c", "korina_tx_timeout"],
> ["drivers/net/ethernet/lantiq_etop.c", "ltq_etop_tx_timeout"],
> ["drivers/net/ethernet/marvell/mv643xx_eth.c", "mv643xx_eth_tx_timeout"],
> ["drivers/net/ethernet/marvell/pxa168_eth.c", "pxa168_eth_tx_timeout"],
> ["drivers/net/ethernet/marvell/skge.c", "skge_tx_timeout"],
> ["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
> ["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
> ["drivers/net/ethernet/mediatek/mtk_eth_soc.c", "mtk_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
> ["drivers/net/ethernet/mellanox/mlx5/core/en_main.c", "mlx5e_tx_timeout"],
> ["drivers/net/ethernet/micrel/ks8842.c", "ks8842_tx_timeout"],
> ["drivers/net/ethernet/micrel/ksz884x.c", "netdev_tx_timeout"],
> ["drivers/net/ethernet/microchip/enc28j60.c", "enc28j60_tx_timeout"],
> ["drivers/net/ethernet/microchip/encx24j600.c", "encx24j600_tx_timeout"],
> ["drivers/net/ethernet/natsemi/sonic.h", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/sonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/jazzsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/macsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/natsemi/natsemi.c", "ns_tx_timeout"],
> ["drivers/net/ethernet/natsemi/ns83820.c", "ns83820_tx_timeout"],
> ["drivers/net/ethernet/natsemi/xtsonic.c", "sonic_tx_timeout"],
> ["drivers/net/ethernet/neterion/s2io.h", "s2io_tx_watchdog"],
> ["drivers/net/ethernet/neterion/s2io.c", "s2io_tx_watchdog"],
> ["drivers/net/ethernet/neterion/vxge/vxge-main.c", "vxge_tx_watchdog"],
> ["drivers/net/ethernet/netronome/nfp/nfp_net_common.c", "nfp_net_tx_timeout"],
> ["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
> ["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
> ["drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c", "pch_gbe_tx_timeout"],
> ["drivers/net/ethernet/packetengines/hamachi.c", "hamachi_tx_timeout"],
> ["drivers/net/ethernet/packetengines/yellowfin.c", "yellowfin_tx_timeout"],
> ["drivers/net/ethernet/pensando/ionic/ionic_lif.c", "ionic_tx_timeout"],
> ["drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c", "netxen_tx_timeout"],
> ["drivers/net/ethernet/qlogic/qla3xxx.c", "ql3xxx_tx_timeout"],
> ["drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c", "qlcnic_tx_timeout"],
> ["drivers/net/ethernet/qualcomm/emac/emac.c", "emac_tx_timeout"],
> ["drivers/net/ethernet/qualcomm/qca_spi.c", "qcaspi_netdev_tx_timeout"],
> ["drivers/net/ethernet/qualcomm/qca_uart.c", "qcauart_netdev_tx_timeout"],
> ["drivers/net/ethernet/rdc/r6040.c", "r6040_tx_timeout"],
> ["drivers/net/ethernet/realtek/8139cp.c", "cp_tx_timeout"],
> ["drivers/net/ethernet/realtek/8139too.c", "rtl8139_tx_timeout"],
> ["drivers/net/ethernet/realtek/atp.c", "tx_timeout"],
> ["drivers/net/ethernet/realtek/r8169_main.c", "rtl8169_tx_timeout"],
> ["drivers/net/ethernet/renesas/ravb_main.c", "ravb_tx_timeout"],
> ["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
> ["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
> ["drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c", "sxgbe_tx_timeout"],
> ["drivers/net/ethernet/seeq/ether3.c", "ether3_timeout"],
> ["drivers/net/ethernet/seeq/sgiseeq.c", "timeout"],
> ["drivers/net/ethernet/sfc/efx.c", "efx_watchdog"],
> ["drivers/net/ethernet/sfc/falcon/efx.c", "ef4_watchdog"],
> ["drivers/net/ethernet/sgi/ioc3-eth.c", "ioc3_timeout"],
> ["drivers/net/ethernet/sgi/meth.c", "meth_tx_timeout"],
> ["drivers/net/ethernet/silan/sc92031.c", "sc92031_tx_timeout"],
> ["drivers/net/ethernet/sis/sis190.c", "sis190_tx_timeout"],
> ["drivers/net/ethernet/sis/sis900.c", "sis900_tx_timeout"],
> ["drivers/net/ethernet/smsc/epic100.c", "epic_tx_timeout"],
> ["drivers/net/ethernet/smsc/smc911x.c", "smc911x_timeout"],
> ["drivers/net/ethernet/smsc/smc9194.c", "smc_timeout"],
> ["drivers/net/ethernet/smsc/smc91c92_cs.c", "smc_tx_timeout"],
> ["drivers/net/ethernet/smsc/smc91x.c", "smc_timeout"],
> ["drivers/net/ethernet/stmicro/stmmac/stmmac_main.c", "stmmac_tx_timeout"],
> ["drivers/net/ethernet/sun/cassini.c", "cas_tx_timeout"],
> ["drivers/net/ethernet/sun/ldmvsw.c", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/sun/niu.c", "niu_tx_timeout"],
> ["drivers/net/ethernet/sun/sunbmac.c", "bigmac_tx_timeout"],
> ["drivers/net/ethernet/sun/sungem.c", "gem_tx_timeout"],
> ["drivers/net/ethernet/sun/sunhme.c", "happy_meal_tx_timeout"],
> ["drivers/net/ethernet/sun/sunqe.c", "qe_tx_timeout"],
> ["drivers/net/ethernet/sun/sunvnet.c", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/sun/sunvnet_common.c", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/sun/sunvnet_common.h", "sunvnet_tx_timeout_common"],
> ["drivers/net/ethernet/synopsys/dwc-xlgmac-net.c", "xlgmac_tx_timeout"],
> ["drivers/net/ethernet/ti/cpmac.c", "cpmac_tx_timeout"],
> ["drivers/net/ethernet/ti/cpsw.c", "cpsw_ndo_tx_timeout"],
> ["drivers/net/ethernet/ti/davinci_emac.c", "emac_dev_tx_timeout"],
> ["drivers/net/ethernet/ti/netcp_core.c", "netcp_ndo_tx_timeout"],
> ["drivers/net/ethernet/ti/tlan.c", "tlan_tx_timeout"],
> ["drivers/net/ethernet/toshiba/ps3_gelic_net.h", "gelic_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/ps3_gelic_net.c", "gelic_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/ps3_gelic_wireless.c", "gelic_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/spider_net.c", "spider_net_tx_timeout"],
> ["drivers/net/ethernet/toshiba/tc35815.c", "tc35815_tx_timeout"],
> ["drivers/net/ethernet/via/via-rhine.c", "rhine_tx_timeout"],
> ["drivers/net/ethernet/wiznet/w5100.c", "w5100_tx_timeout"],
> ["drivers/net/ethernet/wiznet/w5300.c", "w5300_tx_timeout"],
> ["drivers/net/ethernet/xilinx/xilinx_emaclite.c", "xemaclite_tx_timeout"],
> ["drivers/net/ethernet/xircom/xirc2ps_cs.c", "xirc_tx_timeout"],
> ["drivers/net/fjes/fjes_main.c", "fjes_tx_retry"],
> ["drivers/net/slip/slip.c", "sl_tx_timeout"],
> ["include/linux/usb/usbnet.h", "usbnet_tx_timeout"],
> ["drivers/net/usb/aqc111.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ax88172a.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ax88179_178a.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/catc.c", "catc_tx_timeout"],
> ["drivers/net/usb/cdc_mbim.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/cdc_ncm.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/dm9601.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/hso.c", "hso_net_tx_timeout"],
> ["drivers/net/usb/int51x1.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/ipheth.c", "ipheth_tx_timeout"],
> ["drivers/net/usb/kaweth.c", "kaweth_tx_timeout"],
> ["drivers/net/usb/lan78xx.c", "lan78xx_tx_timeout"],
> ["drivers/net/usb/mcs7830.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/pegasus.c", "pegasus_tx_timeout"],
> ["drivers/net/usb/qmi_wwan.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/r8152.c", "rtl8152_tx_timeout"],
> ["drivers/net/usb/rndis_host.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/rtl8150.c", "rtl8150_tx_timeout"],
> ["drivers/net/usb/sierra_net.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/smsc75xx.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/smsc95xx.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/sr9700.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/sr9800.c", "usbnet_tx_timeout"],
> ["drivers/net/usb/usbnet.c", "usbnet_tx_timeout"],
> ["drivers/net/vmxnet3/vmxnet3_drv.c", "vmxnet3_tx_timeout"],
> ["drivers/net/wan/cosa.c", "cosa_net_timeout"],
> ["drivers/net/wan/farsync.c", "fst_tx_timeout"],
> ["drivers/net/wan/fsl_ucc_hdlc.c", "uhdlc_tx_timeout"],
> ["drivers/net/wan/lmc/lmc_main.c", "lmc_driver_timeout"],
> ["drivers/net/wan/x25_asy.c", "x25_asy_timeout"],
> ["drivers/net/wimax/i2400m/netdev.c", "i2400m_tx_timeout"],
> ["drivers/net/wireless/intel/ipw2x00/ipw2100.c", "ipw2100_tx_timeout"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"],
> ["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"],
> ["drivers/net/wireless/intersil/orinoco/main.c", "orinoco_tx_timeout"],
> ["drivers/net/wireless/intersil/orinoco/orinoco_usb.c", "orinoco_tx_timeout"],
> ["drivers/net/wireless/intersil/orinoco/orinoco.h", "orinoco_tx_timeout"],
> ["drivers/net/wireless/intersil/prism54/islpci_dev.c", "islpci_eth_tx_timeout"],
> ["drivers/net/wireless/intersil/prism54/islpci_eth.c", "islpci_eth_tx_timeout"],
> ["drivers/net/wireless/intersil/prism54/islpci_eth.h", "islpci_eth_tx_timeout"],
> ["drivers/net/wireless/marvell/mwifiex/main.c", "mwifiex_tx_timeout"],
> ["drivers/net/wireless/quantenna/qtnfmac/core.c", "qtnf_netdev_tx_timeout"],
> ["drivers/net/wireless/quantenna/qtnfmac/core.h", "qtnf_netdev_tx_timeout"],
> ["drivers/net/wireless/rndis_wlan.c", "usbnet_tx_timeout"],
> ["drivers/net/wireless/wl3501_cs.c", "wl3501_tx_timeout"],
> ["drivers/net/wireless/zydas/zd1201.c", "zd1201_tx_timeout"],
> ["drivers/s390/net/qeth_core.h", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_core_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
> ["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
> ["drivers/staging/ks7010/ks_wlan_net.c", "ks_wlan_tx_timeout"],
> ["drivers/staging/qlge/qlge_main.c", "qlge_tx_timeout"],
> ["drivers/staging/rtl8192e/rtl8192e/rtl_core.c", "_rtl92e_tx_timeout"],
> ["drivers/staging/rtl8192u/r8192U_core.c", "tx_timeout"],
> ["drivers/staging/unisys/visornic/visornic_main.c", "visornic_xmit_timeout"],
> ["drivers/staging/wlan-ng/p80211netdev.c", "p80211knetdev_tx_timeout"],
> ["drivers/tty/n_gsm.c", "gsm_mux_net_tx_timeout"],
> ["drivers/tty/synclink.c", "hdlcdev_tx_timeout"],
> ["drivers/tty/synclink_gt.c", "hdlcdev_tx_timeout"],
> ["drivers/tty/synclinkmp.c", "hdlcdev_tx_timeout"],
> ["net/atm/lec.c", "lec_tx_timeout"],
> ["net/bluetooth/bnep/netdev.c", "bnep_net_timeout"]
> );
> 
> for my $p (@work) {
> 	my @pair = @$p;
> 	my $file = $pair[0];
> 	my $func = $pair[1];
> 	print STDERR $file , ": ", $func,"\n";
> 	our @ARGV = ($file);
> 	while (<ARGV>) {
> 		if (m/($func\s*\(struct\s+net_device\s+\*[A-Za-z_]?[A-Za-z-0-9_]*)(\))/) {
> 			print STDERR "found $1+$2 in $file\n";
> 		}
> 		if (s/($func\s*\(struct\s+net_device\s+\*[A-Za-z_]?[A-Za-z-0-9_]*)(\))/$1, int txqueue$2/) {
> 			print STDERR "$func found in $file\n";
> 		}
> 		print;
> 	}
> }
> 
> where the list of files and functions is simply from:
> 
> git grep ndo_tx_timeout, with manual addition of headers
> in the rare cases where the function is from a header,
> then manually changing the few places which actually
> call ndo_tx_timeout.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> changes from v6:
> 	fix typo in rtl driver
> changes from v5:
> 	add missing files (allow any net device argument name)
> changes from v4:
> 	add a missing driver header
> changes from v3:
>         change queue # to unsigned
> Changes from v2:
>         added headers
> Changes from v1:
>         Fix errors found by kbuild:
>         generalize the pattern a bit, to pick up
>         a couple of instances missed by the previous
>         version.
> ---
>  arch/m68k/emu/nfeth.c                                 | 2 +-
>  arch/um/drivers/net_kern.c                            | 2 +-
>  arch/um/drivers/vector_kern.c                         | 2 +-
>  arch/xtensa/platforms/iss/network.c                   | 2 +-
>  drivers/char/pcmcia/synclink_cs.c                     | 2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c             | 2 +-
>  drivers/message/fusion/mptlan.c                       | 2 +-
>  drivers/misc/sgi-xp/xpnet.c                           | 2 +-
>  drivers/net/appletalk/cops.c                          | 4 ++--
>  drivers/net/arcnet/arcdevice.h                        | 2 +-
>  drivers/net/arcnet/arcnet.c                           | 2 +-
>  drivers/net/ethernet/3com/3c509.c                     | 4 ++--
>  drivers/net/ethernet/3com/3c515.c                     | 4 ++--
>  drivers/net/ethernet/3com/3c574_cs.c                  | 4 ++--
>  drivers/net/ethernet/3com/3c589_cs.c                  | 4 ++--
>  drivers/net/ethernet/3com/3c59x.c                     | 4 ++--
>  drivers/net/ethernet/3com/typhoon.c                   | 2 +-
>  drivers/net/ethernet/8390/8390.c                      | 4 ++--
>  drivers/net/ethernet/8390/8390.h                      | 2 +-
>  drivers/net/ethernet/8390/8390p.c                     | 4 ++--
>  drivers/net/ethernet/8390/axnet_cs.c                  | 4 ++--
>  drivers/net/ethernet/8390/lib8390.c                   | 2 +-
>  drivers/net/ethernet/adaptec/starfire.c               | 4 ++--
>  drivers/net/ethernet/agere/et131x.c                   | 2 +-
>  drivers/net/ethernet/allwinner/sun4i-emac.c           | 2 +-
>  drivers/net/ethernet/alteon/acenic.c                  | 4 ++--
>  drivers/net/ethernet/amazon/ena/ena_netdev.c          | 2 +-
>  drivers/net/ethernet/amd/7990.c                       | 2 +-
>  drivers/net/ethernet/amd/7990.h                       | 2 +-
>  drivers/net/ethernet/amd/a2065.c                      | 2 +-
>  drivers/net/ethernet/amd/am79c961a.c                  | 2 +-
>  drivers/net/ethernet/amd/amd8111e.c                   | 2 +-
>  drivers/net/ethernet/amd/ariadne.c                    | 2 +-
>  drivers/net/ethernet/amd/atarilance.c                 | 4 ++--
>  drivers/net/ethernet/amd/au1000_eth.c                 | 2 +-
>  drivers/net/ethernet/amd/declance.c                   | 2 +-
>  drivers/net/ethernet/amd/lance.c                      | 4 ++--
>  drivers/net/ethernet/amd/ni65.c                       | 4 ++--
>  drivers/net/ethernet/amd/nmclan_cs.c                  | 4 ++--
>  drivers/net/ethernet/amd/pcnet32.c                    | 4 ++--
>  drivers/net/ethernet/amd/sunlance.c                   | 2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c              | 2 +-
>  drivers/net/ethernet/apm/xgene-v2/main.c              | 2 +-
>  drivers/net/ethernet/apm/xgene/xgene_enet_main.c      | 2 +-
>  drivers/net/ethernet/apple/macmace.c                  | 4 ++--
>  drivers/net/ethernet/atheros/ag71xx.c                 | 2 +-
>  drivers/net/ethernet/atheros/alx/main.c               | 2 +-
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c       | 2 +-
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c       | 2 +-
>  drivers/net/ethernet/atheros/atlx/atl2.c              | 2 +-
>  drivers/net/ethernet/broadcom/b44.c                   | 2 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c            | 2 +-
>  drivers/net/ethernet/broadcom/bnx2.c                  | 2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c       | 2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h       | 2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c             | 2 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c        | 2 +-
>  drivers/net/ethernet/broadcom/sb1250-mac.c            | 4 ++--
>  drivers/net/ethernet/broadcom/tg3.c                   | 2 +-
>  drivers/net/ethernet/calxeda/xgmac.c                  | 2 +-
>  drivers/net/ethernet/cavium/liquidio/lio_main.c       | 2 +-
>  drivers/net/ethernet/cavium/liquidio/lio_vf_main.c    | 2 +-
>  drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c     | 4 ++--
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c      | 2 +-
>  drivers/net/ethernet/cirrus/cs89x0.c                  | 2 +-
>  drivers/net/ethernet/cisco/enic/enic_main.c           | 2 +-
>  drivers/net/ethernet/cortina/gemini.c                 | 2 +-
>  drivers/net/ethernet/davicom/dm9000.c                 | 2 +-
>  drivers/net/ethernet/dec/tulip/de2104x.c              | 2 +-
>  drivers/net/ethernet/dec/tulip/tulip_core.c           | 4 ++--
>  drivers/net/ethernet/dec/tulip/winbond-840.c          | 4 ++--
>  drivers/net/ethernet/dlink/dl2k.c                     | 4 ++--
>  drivers/net/ethernet/dlink/sundance.c                 | 4 ++--
>  drivers/net/ethernet/emulex/benet/be_main.c           | 2 +-
>  drivers/net/ethernet/ethoc.c                          | 2 +-
>  drivers/net/ethernet/faraday/ftgmac100.c              | 2 +-
>  drivers/net/ethernet/fealnx.c                         | 4 ++--
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 2 +-
>  drivers/net/ethernet/freescale/fec_main.c             | 2 +-
>  drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 +-
>  drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 2 +-
>  drivers/net/ethernet/freescale/gianfar.c              | 2 +-
>  drivers/net/ethernet/freescale/ucc_geth.c             | 2 +-
>  drivers/net/ethernet/fujitsu/fmvj18x_cs.c             | 4 ++--
>  drivers/net/ethernet/google/gve/gve_main.c            | 2 +-
>  drivers/net/ethernet/hisilicon/hip04_eth.c            | 2 +-
>  drivers/net/ethernet/hisilicon/hix5hd2_gmac.c         | 2 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c         | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 2 +-
>  drivers/net/ethernet/huawei/hinic/hinic_main.c        | 2 +-
>  drivers/net/ethernet/i825xx/82596.c                   | 4 ++--
>  drivers/net/ethernet/i825xx/ether1.c                  | 4 ++--
>  drivers/net/ethernet/i825xx/lib82596.c                | 4 ++--
>  drivers/net/ethernet/i825xx/sun3_82586.c              | 4 ++--
>  drivers/net/ethernet/ibm/ehea/ehea_main.c             | 2 +-
>  drivers/net/ethernet/ibm/emac/core.c                  | 2 +-
>  drivers/net/ethernet/ibm/ibmvnic.c                    | 2 +-
>  drivers/net/ethernet/intel/e100.c                     | 2 +-
>  drivers/net/ethernet/intel/e1000/e1000_main.c         | 4 ++--
>  drivers/net/ethernet/intel/e1000e/netdev.c            | 2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c       | 2 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c           | 2 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c           | 2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c             | 2 +-
>  drivers/net/ethernet/intel/igb/igb_main.c             | 4 ++--
>  drivers/net/ethernet/intel/igbvf/netdev.c             | 2 +-
>  drivers/net/ethernet/intel/ixgb/ixgb_main.c           | 4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c      | 4 +++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         | 2 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c     | 2 +-
>  drivers/net/ethernet/jme.c                            | 2 +-
>  drivers/net/ethernet/korina.c                         | 2 +-
>  drivers/net/ethernet/lantiq_etop.c                    | 2 +-
>  drivers/net/ethernet/marvell/mv643xx_eth.c            | 2 +-
>  drivers/net/ethernet/marvell/pxa168_eth.c             | 2 +-
>  drivers/net/ethernet/marvell/skge.c                   | 2 +-
>  drivers/net/ethernet/marvell/sky2.c                   | 2 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c           | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c        | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 2 +-
>  drivers/net/ethernet/micrel/ks8842.c                  | 2 +-
>  drivers/net/ethernet/micrel/ksz884x.c                 | 2 +-
>  drivers/net/ethernet/microchip/enc28j60.c             | 2 +-
>  drivers/net/ethernet/microchip/encx24j600.c           | 2 +-
>  drivers/net/ethernet/natsemi/natsemi.c                | 4 ++--
>  drivers/net/ethernet/natsemi/ns83820.c                | 2 +-
>  drivers/net/ethernet/natsemi/sonic.c                  | 2 +-
>  drivers/net/ethernet/natsemi/sonic.h                  | 2 +-
>  drivers/net/ethernet/neterion/s2io.c                  | 2 +-
>  drivers/net/ethernet/neterion/s2io.h                  | 2 +-
>  drivers/net/ethernet/neterion/vxge/vxge-main.c        | 2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c   | 2 +-
>  drivers/net/ethernet/nvidia/forcedeth.c               | 2 +-
>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 2 +-
>  drivers/net/ethernet/packetengines/hamachi.c          | 4 ++--
>  drivers/net/ethernet/packetengines/yellowfin.c        | 4 ++--
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c       | 2 +-
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c  | 4 ++--
>  drivers/net/ethernet/qlogic/qla3xxx.c                 | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      | 4 ++--
>  drivers/net/ethernet/qualcomm/emac/emac.c             | 2 +-
>  drivers/net/ethernet/qualcomm/qca_spi.c               | 2 +-
>  drivers/net/ethernet/qualcomm/qca_uart.c              | 2 +-
>  drivers/net/ethernet/rdc/r6040.c                      | 2 +-
>  drivers/net/ethernet/realtek/8139cp.c                 | 2 +-
>  drivers/net/ethernet/realtek/8139too.c                | 4 ++--
>  drivers/net/ethernet/realtek/atp.c                    | 4 ++--
>  drivers/net/ethernet/realtek/r8169_main.c             | 2 +-
>  drivers/net/ethernet/renesas/ravb_main.c              | 2 +-
>  drivers/net/ethernet/renesas/sh_eth.c                 | 2 +-
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c       | 2 +-
>  drivers/net/ethernet/seeq/ether3.c                    | 4 ++--
>  drivers/net/ethernet/seeq/sgiseeq.c                   | 2 +-
>  drivers/net/ethernet/sfc/efx.c                        | 2 +-
>  drivers/net/ethernet/sfc/falcon/efx.c                 | 2 +-
>  drivers/net/ethernet/sgi/ioc3-eth.c                   | 4 ++--
>  drivers/net/ethernet/sgi/meth.c                       | 4 ++--
>  drivers/net/ethernet/silan/sc92031.c                  | 2 +-
>  drivers/net/ethernet/sis/sis190.c                     | 2 +-
>  drivers/net/ethernet/sis/sis900.c                     | 4 ++--
>  drivers/net/ethernet/smsc/epic100.c                   | 4 ++--
>  drivers/net/ethernet/smsc/smc911x.c                   | 2 +-
>  drivers/net/ethernet/smsc/smc9194.c                   | 4 ++--
>  drivers/net/ethernet/smsc/smc91c92_cs.c               | 4 ++--
>  drivers/net/ethernet/smsc/smc91x.c                    | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 2 +-
>  drivers/net/ethernet/sun/cassini.c                    | 2 +-
>  drivers/net/ethernet/sun/niu.c                        | 2 +-
>  drivers/net/ethernet/sun/sunbmac.c                    | 2 +-
>  drivers/net/ethernet/sun/sungem.c                     | 2 +-
>  drivers/net/ethernet/sun/sunhme.c                     | 2 +-
>  drivers/net/ethernet/sun/sunqe.c                      | 2 +-
>  drivers/net/ethernet/sun/sunvnet_common.c             | 2 +-
>  drivers/net/ethernet/sun/sunvnet_common.h             | 2 +-
>  drivers/net/ethernet/synopsys/dwc-xlgmac-net.c        | 2 +-
>  drivers/net/ethernet/ti/cpmac.c                       | 2 +-
>  drivers/net/ethernet/ti/cpsw.c                        | 2 +-
>  drivers/net/ethernet/ti/davinci_emac.c                | 2 +-
>  drivers/net/ethernet/ti/netcp_core.c                  | 2 +-
>  drivers/net/ethernet/ti/tlan.c                        | 4 ++--
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c          | 2 +-
>  drivers/net/ethernet/toshiba/ps3_gelic_net.h          | 2 +-
>  drivers/net/ethernet/toshiba/spider_net.c             | 2 +-
>  drivers/net/ethernet/toshiba/tc35815.c                | 4 ++--
>  drivers/net/ethernet/via/via-rhine.c                  | 4 ++--
>  drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
>  drivers/net/ethernet/wiznet/w5300.c                   | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 +-
>  drivers/net/ethernet/xircom/xirc2ps_cs.c              | 4 ++--
>  drivers/net/fjes/fjes_main.c                          | 4 ++--
>  drivers/net/slip/slip.c                               | 2 +-
>  drivers/net/usb/catc.c                                | 2 +-
>  drivers/net/usb/hso.c                                 | 2 +-
>  drivers/net/usb/ipheth.c                              | 2 +-
>  drivers/net/usb/kaweth.c                              | 2 +-
>  drivers/net/usb/lan78xx.c                             | 2 +-
>  drivers/net/usb/pegasus.c                             | 2 +-
>  drivers/net/usb/r8152.c                               | 2 +-
>  drivers/net/usb/rtl8150.c                             | 2 +-
>  drivers/net/usb/usbnet.c                              | 2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c                     | 2 +-
>  drivers/net/wan/cosa.c                                | 4 ++--
>  drivers/net/wan/farsync.c                             | 2 +-
>  drivers/net/wan/fsl_ucc_hdlc.c                        | 2 +-
>  drivers/net/wan/lmc/lmc_main.c                        | 4 ++--
>  drivers/net/wan/x25_asy.c                             | 2 +-
>  drivers/net/wimax/i2400m/netdev.c                     | 2 +-
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c          | 2 +-
>  drivers/net/wireless/intersil/hostap/hostap_main.c    | 2 +-
>  drivers/net/wireless/intersil/orinoco/main.c          | 2 +-
>  drivers/net/wireless/intersil/orinoco/orinoco.h       | 2 +-
>  drivers/net/wireless/intersil/prism54/islpci_eth.c    | 2 +-
>  drivers/net/wireless/intersil/prism54/islpci_eth.h    | 2 +-
>  drivers/net/wireless/marvell/mwifiex/main.c           | 2 +-
>  drivers/net/wireless/quantenna/qtnfmac/core.c         | 2 +-
>  drivers/net/wireless/wl3501_cs.c                      | 2 +-
>  drivers/net/wireless/zydas/zd1201.c                   | 2 +-
>  drivers/s390/net/qeth_core.h                          | 2 +-
>  drivers/s390/net/qeth_core_main.c                     | 2 +-
>  drivers/staging/ks7010/ks_wlan_net.c                  | 4 ++--
>  drivers/staging/qlge/qlge_main.c                      | 2 +-
>  drivers/staging/rtl8192e/rtl8192e/rtl_core.c          | 2 +-
>  drivers/staging/rtl8192u/r8192U_core.c                | 2 +-
>  drivers/staging/unisys/visornic/visornic_main.c       | 2 +-
>  drivers/staging/wlan-ng/p80211netdev.c                | 4 ++--
>  drivers/tty/n_gsm.c                                   | 2 +-
>  drivers/tty/synclink.c                                | 2 +-
>  drivers/tty/synclink_gt.c                             | 2 +-
>  drivers/tty/synclinkmp.c                              | 2 +-
>  include/linux/netdevice.h                             | 5 +++--
>  include/linux/usb/usbnet.h                            | 2 +-
>  net/atm/lec.c                                         | 2 +-
>  net/bluetooth/bnep/netdev.c                           | 2 +-
>  net/sched/sch_generic.c                               | 2 +-
>  234 files changed, 293 insertions(+), 290 deletions(-)
> 
> diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
> index a4ebd2445eda..d2875e32abfc 100644
> --- a/arch/m68k/emu/nfeth.c
> +++ b/arch/m68k/emu/nfeth.c
> @@ -167,7 +167,7 @@ static int nfeth_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return 0;
>  }
>  
> -static void nfeth_tx_timeout(struct net_device *dev)
> +static void nfeth_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	dev->stats.tx_errors++;
>  	netif_wake_queue(dev);
> diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> index 327b728f7244..35ebeebfc1a8 100644
> --- a/arch/um/drivers/net_kern.c
> +++ b/arch/um/drivers/net_kern.c
> @@ -247,7 +247,7 @@ static void uml_net_set_multicast_list(struct net_device *dev)
>  	return;
>  }
>  
> -static void uml_net_tx_timeout(struct net_device *dev)
> +static void uml_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	netif_trans_update(dev);
>  	netif_wake_queue(dev);
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
> index 769ffbd9e9a6..ae930f0bfd51 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1298,7 +1298,7 @@ static void vector_net_set_multicast_list(struct net_device *dev)
>  	return;
>  }
>  
> -static void vector_net_tx_timeout(struct net_device *dev)
> +static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct vector_private *vp = netdev_priv(dev);
>  
> diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
> index fa9f3893b002..4986226a5ab2 100644
> --- a/arch/xtensa/platforms/iss/network.c
> +++ b/arch/xtensa/platforms/iss/network.c
> @@ -455,7 +455,7 @@ static void iss_net_set_multicast_list(struct net_device *dev)
>  {
>  }
>  
> -static void iss_net_tx_timeout(struct net_device *dev)
> +static void iss_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  }
>  
> diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
> index 82f9a6a814ae..e342daa73d1b 100644
> --- a/drivers/char/pcmcia/synclink_cs.c
> +++ b/drivers/char/pcmcia/synclink_cs.c
> @@ -4169,7 +4169,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>   *
>   * dev  pointer to network device structure
>   */
> -static void hdlcdev_tx_timeout(struct net_device *dev)
> +static void hdlcdev_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	MGSLPC_INFO *info = dev_to_port(dev);
>  	unsigned long flags;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index ac0583ff280d..b86dbdc37b83 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1182,7 +1182,7 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return NETDEV_TX_OK;
>  }
>  
> -static void ipoib_timeout(struct net_device *dev)
> +static void ipoib_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ipoib_dev_priv *priv = ipoib_priv(dev);
>  
> diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
> index ebc00d47abf5..7d3784aa20e5 100644
> --- a/drivers/message/fusion/mptlan.c
> +++ b/drivers/message/fusion/mptlan.c
> @@ -552,7 +552,7 @@ mpt_lan_close(struct net_device *dev)
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /* Tx timeout handler. */
>  static void
> -mpt_lan_tx_timeout(struct net_device *dev)
> +mpt_lan_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mpt_lan_priv *priv = netdev_priv(dev);
>  	MPT_ADAPTER *mpt_dev = priv->mpt_dev;
> diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
> index f7d610a22347..ada94e6a3c91 100644
> --- a/drivers/misc/sgi-xp/xpnet.c
> +++ b/drivers/misc/sgi-xp/xpnet.c
> @@ -496,7 +496,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
>   * Deal with transmit timeouts coming from the network layer.
>   */
>  static void
> -xpnet_dev_tx_timeout(struct net_device *dev)
> +xpnet_dev_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	dev->stats.tx_errors++;
>  }
> diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
> index b3c63d2f16aa..18428e104445 100644
> --- a/drivers/net/appletalk/cops.c
> +++ b/drivers/net/appletalk/cops.c
> @@ -189,7 +189,7 @@ static int  cops_nodeid (struct net_device *dev, int nodeid);
>  
>  static irqreturn_t cops_interrupt (int irq, void *dev_id);
>  static void cops_poll(struct timer_list *t);
> -static void cops_timeout(struct net_device *dev);
> +static void cops_timeout(struct net_device *dev, unsigned int txqueue);
>  static void cops_rx (struct net_device *dev);
>  static netdev_tx_t  cops_send_packet (struct sk_buff *skb,
>  					    struct net_device *dev);
> @@ -844,7 +844,7 @@ static void cops_rx(struct net_device *dev)
>          netif_rx(skb);
>  }
>  
> -static void cops_timeout(struct net_device *dev)
> +static void cops_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>          struct cops_local *lp = netdev_priv(dev);
>          int ioaddr = dev->base_addr;
> diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.h
> index b0f5bc07aef5..22a49c6d7ae6 100644
> --- a/drivers/net/arcnet/arcdevice.h
> +++ b/drivers/net/arcnet/arcdevice.h
> @@ -356,7 +356,7 @@ int arcnet_open(struct net_device *dev);
>  int arcnet_close(struct net_device *dev);
>  netdev_tx_t arcnet_send_packet(struct sk_buff *skb,
>  			       struct net_device *dev);
> -void arcnet_timeout(struct net_device *dev);
> +void arcnet_timeout(struct net_device *dev, unsigned int txqueue);
>  
>  /* I/O equivalents */
>  
> diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
> index 553776cc1d29..e04efc0a5c97 100644
> --- a/drivers/net/arcnet/arcnet.c
> +++ b/drivers/net/arcnet/arcnet.c
> @@ -763,7 +763,7 @@ static int go_tx(struct net_device *dev)
>  }
>  
>  /* Called by the kernel when transmit times out */
> -void arcnet_timeout(struct net_device *dev)
> +void arcnet_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	unsigned long flags;
>  	struct arcnet_local *lp = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
> index 3da97996bdf3..8cafd06ff0c4 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -196,7 +196,7 @@ static struct net_device_stats *el3_get_stats(struct net_device *dev);
>  static int el3_rx(struct net_device *dev);
>  static int el3_close(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> -static void el3_tx_timeout (struct net_device *dev);
> +static void el3_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static void el3_down(struct net_device *dev);
>  static void el3_up(struct net_device *dev);
>  static const struct ethtool_ops ethtool_ops;
> @@ -689,7 +689,7 @@ el3_open(struct net_device *dev)
>  }
>  
>  static void
> -el3_tx_timeout (struct net_device *dev)
> +el3_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	int ioaddr = dev->base_addr;
>  
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
> index b15752267c8d..1e233e2f0a5a 100644
> --- a/drivers/net/ethernet/3com/3c515.c
> +++ b/drivers/net/ethernet/3com/3c515.c
> @@ -371,7 +371,7 @@ static void corkscrew_timer(struct timer_list *t);
>  static netdev_tx_t corkscrew_start_xmit(struct sk_buff *skb,
>  					struct net_device *dev);
>  static int corkscrew_rx(struct net_device *dev);
> -static void corkscrew_timeout(struct net_device *dev);
> +static void corkscrew_timeout(struct net_device *dev, unsigned int txqueue);
>  static int boomerang_rx(struct net_device *dev);
>  static irqreturn_t corkscrew_interrupt(int irq, void *dev_id);
>  static int corkscrew_close(struct net_device *dev);
> @@ -961,7 +961,7 @@ static void corkscrew_timer(struct timer_list *t)
>  #endif				/* AUTOMEDIA */
>  }
>  
> -static void corkscrew_timeout(struct net_device *dev)
> +static void corkscrew_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	int i;
>  	struct corkscrew_private *vp = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
> index 3044a6f35f04..ef1c3151fbb2 100644
> --- a/drivers/net/ethernet/3com/3c574_cs.c
> +++ b/drivers/net/ethernet/3com/3c574_cs.c
> @@ -234,7 +234,7 @@ static void update_stats(struct net_device *dev);
>  static struct net_device_stats *el3_get_stats(struct net_device *dev);
>  static int el3_rx(struct net_device *dev, int worklimit);
>  static int el3_close(struct net_device *dev);
> -static void el3_tx_timeout(struct net_device *dev);
> +static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static int el3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  static void set_rx_mode(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> @@ -690,7 +690,7 @@ static int el3_open(struct net_device *dev)
>  	return 0;
>  }
>  
> -static void el3_tx_timeout(struct net_device *dev)
> +static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	unsigned int ioaddr = dev->base_addr;
>  	
> diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
> index 2b2695311bda..d47cde6c5f08 100644
> --- a/drivers/net/ethernet/3com/3c589_cs.c
> +++ b/drivers/net/ethernet/3com/3c589_cs.c
> @@ -173,7 +173,7 @@ static void update_stats(struct net_device *dev);
>  static struct net_device_stats *el3_get_stats(struct net_device *dev);
>  static int el3_rx(struct net_device *dev);
>  static int el3_close(struct net_device *dev);
> -static void el3_tx_timeout(struct net_device *dev);
> +static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void set_rx_mode(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
>  static const struct ethtool_ops netdev_ethtool_ops;
> @@ -526,7 +526,7 @@ static int el3_open(struct net_device *dev)
>  	return 0;
>  }
>  
> -static void el3_tx_timeout(struct net_device *dev)
> +static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	unsigned int ioaddr = dev->base_addr;
>  
> diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> index 8785c2ff3825..fc046797c0ea 100644
> --- a/drivers/net/ethernet/3com/3c59x.c
> +++ b/drivers/net/ethernet/3com/3c59x.c
> @@ -776,7 +776,7 @@ static void set_rx_mode(struct net_device *dev);
>  #ifdef CONFIG_PCI
>  static int vortex_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  #endif
> -static void vortex_tx_timeout(struct net_device *dev);
> +static void vortex_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void acpi_set_WOL(struct net_device *dev);
>  static const struct ethtool_ops vortex_ethtool_ops;
>  static void set_8021q_mode(struct net_device *dev, int enable);
> @@ -1877,7 +1877,7 @@ vortex_timer(struct timer_list *t)
>  		iowrite16(FakeIntr, ioaddr + EL3_CMD);
>  }
>  
> -static void vortex_tx_timeout(struct net_device *dev)
> +static void vortex_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct vortex_private *vp = netdev_priv(dev);
>  	void __iomem *ioaddr = vp->ioaddr;
> diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
> index be823c186517..14fce6658106 100644
> --- a/drivers/net/ethernet/3com/typhoon.c
> +++ b/drivers/net/ethernet/3com/typhoon.c
> @@ -2013,7 +2013,7 @@ typhoon_stop_runtime(struct typhoon *tp, int wait_type)
>  }
>  
>  static void
> -typhoon_tx_timeout(struct net_device *dev)
> +typhoon_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct typhoon *tp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/8390.c
> index 78f3e532c600..0e0aa4016858 100644
> --- a/drivers/net/ethernet/8390/8390.c
> +++ b/drivers/net/ethernet/8390/8390.c
> @@ -36,9 +36,9 @@ void ei_set_multicast_list(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(ei_set_multicast_list);
>  
> -void ei_tx_timeout(struct net_device *dev)
> +void ei_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
> -	__ei_tx_timeout(dev);
> +	__ei_tx_timeout(dev, txqueue);
>  }
>  EXPORT_SYMBOL(ei_tx_timeout);
>  
> diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8390.h
> index 3e2f2c2e7b58..6d55015fa361 100644
> --- a/drivers/net/ethernet/8390/8390.h
> +++ b/drivers/net/ethernet/8390/8390.h
> @@ -32,7 +32,7 @@ void NS8390_init(struct net_device *dev, int startp);
>  int ei_open(struct net_device *dev);
>  int ei_close(struct net_device *dev);
>  irqreturn_t ei_interrupt(int irq, void *dev_id);
> -void ei_tx_timeout(struct net_device *dev);
> +void ei_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  netdev_tx_t ei_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  void ei_set_multicast_list(struct net_device *dev);
>  struct net_device_stats *ei_get_stats(struct net_device *dev);
> diff --git a/drivers/net/ethernet/8390/8390p.c b/drivers/net/ethernet/8390/8390p.c
> index 6cf36992a2c6..6834742057b3 100644
> --- a/drivers/net/ethernet/8390/8390p.c
> +++ b/drivers/net/ethernet/8390/8390p.c
> @@ -41,9 +41,9 @@ void eip_set_multicast_list(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(eip_set_multicast_list);
>  
> -void eip_tx_timeout(struct net_device *dev)
> +void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
> -	__ei_tx_timeout(dev);
> +	__ei_tx_timeout(dev, txqueue);
>  }
>  EXPORT_SYMBOL(eip_tx_timeout);
>  
> diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
> index 0b6bbf63f7ca..aeae7966a082 100644
> --- a/drivers/net/ethernet/8390/axnet_cs.c
> +++ b/drivers/net/ethernet/8390/axnet_cs.c
> @@ -83,7 +83,7 @@ static netdev_tx_t axnet_start_xmit(struct sk_buff *skb,
>  					  struct net_device *dev);
>  static struct net_device_stats *get_stats(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> -static void axnet_tx_timeout(struct net_device *dev);
> +static void axnet_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
>  static void ei_watchdog(struct timer_list *t);
>  static void axnet_reset_8390(struct net_device *dev);
> @@ -903,7 +903,7 @@ static int ax_close(struct net_device *dev)
>   * completed (or failed) - i.e. never posted a Tx related interrupt.
>   */
>  
> -static void axnet_tx_timeout(struct net_device *dev)
> +static void axnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	long e8390_base = dev->base_addr;
>  	struct ei_device *ei_local = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
> index c9c55c9eab9f..babc92e2692e 100644
> --- a/drivers/net/ethernet/8390/lib8390.c
> +++ b/drivers/net/ethernet/8390/lib8390.c
> @@ -251,7 +251,7 @@ static int __ei_close(struct net_device *dev)
>   * completed (or failed) - i.e. never posted a Tx related interrupt.
>   */
>  
> -static void __ei_tx_timeout(struct net_device *dev)
> +static void __ei_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	unsigned long e8390_base = dev->base_addr;
>  	struct ei_device *ei_local = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
> index 816540e6beac..165d18405b0c 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -576,7 +576,7 @@ static int	mdio_read(struct net_device *dev, int phy_id, int location);
>  static void	mdio_write(struct net_device *dev, int phy_id, int location, int value);
>  static int	netdev_open(struct net_device *dev);
>  static void	check_duplex(struct net_device *dev);
> -static void	tx_timeout(struct net_device *dev);
> +static void	tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void	init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
>  static irqreturn_t intr_handler(int irq, void *dev_instance);
> @@ -1105,7 +1105,7 @@ static void check_duplex(struct net_device *dev)
>  }
>  
>  
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem *ioaddr = np->base;
> diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
> index 174344c450af..3c51d8c502ed 100644
> --- a/drivers/net/ethernet/agere/et131x.c
> +++ b/drivers/net/ethernet/agere/et131x.c
> @@ -3811,7 +3811,7 @@ static netdev_tx_t et131x_tx(struct sk_buff *skb, struct net_device *netdev)
>   * specified by the 'tx_timeo" element in the net_device structure (see
>   * et131x_alloc_device() to see how this value is set).
>   */
> -static void et131x_tx_timeout(struct net_device *netdev)
> +static void et131x_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct et131x_adapter *adapter = netdev_priv(netdev);
>  	struct tx_ring *tx_ring = &adapter->tx_ring;
> diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
> index 0537df06a9b5..5ea806423e4c 100644
> --- a/drivers/net/ethernet/allwinner/sun4i-emac.c
> +++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
> @@ -407,7 +407,7 @@ static void emac_init_device(struct net_device *dev)
>  }
>  
>  /* Our watchdog timed out. Called by the networking layer */
> -static void emac_timeout(struct net_device *dev)
> +static void emac_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct emac_board_info *db = netdev_priv(dev);
>  	unsigned long flags;
> diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
> index 46b4207d3266..f366faf88eee 100644
> --- a/drivers/net/ethernet/alteon/acenic.c
> +++ b/drivers/net/ethernet/alteon/acenic.c
> @@ -437,7 +437,7 @@ static const struct ethtool_ops ace_ethtool_ops = {
>  	.set_link_ksettings = ace_set_link_ksettings,
>  };
>  
> -static void ace_watchdog(struct net_device *dev);
> +static void ace_watchdog(struct net_device *dev, unsigned int txqueue);
>  
>  static const struct net_device_ops ace_netdev_ops = {
>  	.ndo_open		= ace_open,
> @@ -1542,7 +1542,7 @@ static void ace_set_rxtx_parms(struct net_device *dev, int jumbo)
>  }
>  
>  
> -static void ace_watchdog(struct net_device *data)
> +static void ace_watchdog(struct net_device *data, unsigned int txqueue)
>  {
>  	struct net_device *dev = data;
>  	struct ace_private *ap = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index c487d2a7d6dd..61a6543f962a 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -78,7 +78,7 @@ static void check_for_admin_com_state(struct ena_adapter *adapter);
>  static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
>  static int ena_restore_device(struct ena_adapter *adapter);
>  
> -static void ena_tx_timeout(struct net_device *dev)
> +static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/amd/7990.c b/drivers/net/ethernet/amd/7990.c
> index ab30761003da..cf3562e82ca9 100644
> --- a/drivers/net/ethernet/amd/7990.c
> +++ b/drivers/net/ethernet/amd/7990.c
> @@ -527,7 +527,7 @@ int lance_close(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(lance_close);
>  
> -void lance_tx_timeout(struct net_device *dev)
> +void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	printk("lance_tx_timeout\n");
>  	lance_reset(dev);
> diff --git a/drivers/net/ethernet/amd/7990.h b/drivers/net/ethernet/amd/7990.h
> index 741cdc392c6b..8266b3c1fefc 100644
> --- a/drivers/net/ethernet/amd/7990.h
> +++ b/drivers/net/ethernet/amd/7990.h
> @@ -243,7 +243,7 @@ int lance_open(struct net_device *dev);
>  int lance_close(struct net_device *dev);
>  int lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  void lance_set_multicast(struct net_device *dev);
> -void lance_tx_timeout(struct net_device *dev);
> +void lance_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  void lance_poll(struct net_device *dev);
>  #endif
> diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
> index 212fe72a190b..a3faf4feb204 100644
> --- a/drivers/net/ethernet/amd/a2065.c
> +++ b/drivers/net/ethernet/amd/a2065.c
> @@ -522,7 +522,7 @@ static inline int lance_reset(struct net_device *dev)
>  	return status;
>  }
>  
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct lance_private *lp = netdev_priv(dev);
>  	volatile struct lance_regs *ll = lp->ll;
> diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
> index 0842da492a64..1c53408f5d47 100644
> --- a/drivers/net/ethernet/amd/am79c961a.c
> +++ b/drivers/net/ethernet/amd/am79c961a.c
> @@ -422,7 +422,7 @@ static void am79c961_setmulticastlist (struct net_device *dev)
>  	spin_unlock_irqrestore(&priv->chip_lock, flags);
>  }
>  
> -static void am79c961_timeout(struct net_device *dev)
> +static void am79c961_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	printk(KERN_WARNING "%s: transmit timed out, network cable problem?\n",
>  		dev->name);
> diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
> index 573e88fc8ede..0f3b743425e8 100644
> --- a/drivers/net/ethernet/amd/amd8111e.c
> +++ b/drivers/net/ethernet/amd/amd8111e.c
> @@ -1569,7 +1569,7 @@ static int amd8111e_enable_link_change(struct amd8111e_priv *lp)
>   * failed or the interface is locked up. This function will reinitialize
>   * the hardware.
>   */
> -static void amd8111e_tx_timeout(struct net_device *dev)
> +static void amd8111e_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct amd8111e_priv *lp = netdev_priv(dev);
>  	int err;
> diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
> index 4b6a5cb85dd2..5e0f645f5bde 100644
> --- a/drivers/net/ethernet/amd/ariadne.c
> +++ b/drivers/net/ethernet/amd/ariadne.c
> @@ -530,7 +530,7 @@ static inline void ariadne_reset(struct net_device *dev)
>  	netif_start_queue(dev);
>  }
>  
> -static void ariadne_tx_timeout(struct net_device *dev)
> +static void ariadne_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	volatile struct Am79C960 *lance = (struct Am79C960 *)dev->base_addr;
>  
> diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
> index d3d44e07afbc..4e36122609a3 100644
> --- a/drivers/net/ethernet/amd/atarilance.c
> +++ b/drivers/net/ethernet/amd/atarilance.c
> @@ -346,7 +346,7 @@ static int lance_rx( struct net_device *dev );
>  static int lance_close( struct net_device *dev );
>  static void set_multicast_list( struct net_device *dev );
>  static int lance_set_mac_address( struct net_device *dev, void *addr );
> -static void lance_tx_timeout (struct net_device *dev);
> +static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  
>  /************************* End of Prototypes **************************/
>  
> @@ -727,7 +727,7 @@ static void lance_init_ring( struct net_device *dev )
>  /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
>  
>  
> -static void lance_tx_timeout (struct net_device *dev)
> +static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct lance_private *lp = netdev_priv(dev);
>  	struct lance_ioreg	 *IO = lp->iobase;
> diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
> index 1793950f0582..d832c9f4d306 100644
> --- a/drivers/net/ethernet/amd/au1000_eth.c
> +++ b/drivers/net/ethernet/amd/au1000_eth.c
> @@ -1014,7 +1014,7 @@ static netdev_tx_t au1000_tx(struct sk_buff *skb, struct net_device *dev)
>   * The Tx ring has been full longer than the watchdog timeout
>   * value. The transmitter must be hung?
>   */
> -static void au1000_tx_timeout(struct net_device *dev)
> +static void au1000_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	netdev_err(dev, "au1000_tx_timeout: dev=%p\n", dev);
>  	au1000_reset_mac(dev);
> diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
> index dac4a2fcad6a..6592a2db9efb 100644
> --- a/drivers/net/ethernet/amd/declance.c
> +++ b/drivers/net/ethernet/amd/declance.c
> @@ -884,7 +884,7 @@ static inline int lance_reset(struct net_device *dev)
>  	return status;
>  }
>  
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct lance_private *lp = netdev_priv(dev);
>  	volatile struct lance_regs *ll = lp->ll;
> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
> index f90b454b1642..aff44241988c 100644
> --- a/drivers/net/ethernet/amd/lance.c
> +++ b/drivers/net/ethernet/amd/lance.c
> @@ -306,7 +306,7 @@ static irqreturn_t lance_interrupt(int irq, void *dev_id);
>  static int lance_close(struct net_device *dev);
>  static struct net_device_stats *lance_get_stats(struct net_device *dev);
>  static void set_multicast_list(struct net_device *dev);
> -static void lance_tx_timeout (struct net_device *dev);
> +static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  
>  
>  
> @@ -913,7 +913,7 @@ lance_restart(struct net_device *dev, unsigned int csr0_bits, int must_reinit)
>  }
>  
>  
> -static void lance_tx_timeout (struct net_device *dev)
> +static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct lance_private *lp = (struct lance_private *) dev->ml_priv;
>  	int ioaddr = dev->base_addr;
> diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
> index c6c2a54c1121..c38edf6f03a3 100644
> --- a/drivers/net/ethernet/amd/ni65.c
> +++ b/drivers/net/ethernet/amd/ni65.c
> @@ -254,7 +254,7 @@ static int  ni65_lance_reinit(struct net_device *dev);
>  static void ni65_init_lance(struct priv *p,unsigned char*,int,int);
>  static netdev_tx_t ni65_send_packet(struct sk_buff *skb,
>  				    struct net_device *dev);
> -static void  ni65_timeout(struct net_device *dev);
> +static void  ni65_timeout(struct net_device *dev, unsigned int txqueue);
>  static int  ni65_close(struct net_device *dev);
>  static int  ni65_alloc_buffer(struct net_device *dev);
>  static void ni65_free_buffer(struct priv *p);
> @@ -1133,7 +1133,7 @@ static void ni65_recv_intr(struct net_device *dev,int csr0)
>   * kick xmitter ..
>   */
>  
> -static void ni65_timeout(struct net_device *dev)
> +static void ni65_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	int i;
>  	struct priv *p = dev->ml_priv;
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
> index 9c152d85840d..023aecf6ab30 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -407,7 +407,7 @@ static int mace_open(struct net_device *dev);
>  static int mace_close(struct net_device *dev);
>  static netdev_tx_t mace_start_xmit(struct sk_buff *skb,
>  					 struct net_device *dev);
> -static void mace_tx_timeout(struct net_device *dev);
> +static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static irqreturn_t mace_interrupt(int irq, void *dev_id);
>  static struct net_device_stats *mace_get_stats(struct net_device *dev);
>  static int mace_rx(struct net_device *dev, unsigned char RxCnt);
> @@ -837,7 +837,7 @@ mace_start_xmit
>  	failed, put skb back into a list."
>  ---------------------------------------------------------------------------- */
>  
> -static void mace_tx_timeout(struct net_device *dev)
> +static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>    mace_private *lp = netdev_priv(dev);
>    struct pcmcia_device *link = lp->p_dev;
> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
> index f5ad12c10934..dc7d88227e76 100644
> --- a/drivers/net/ethernet/amd/pcnet32.c
> +++ b/drivers/net/ethernet/amd/pcnet32.c
> @@ -314,7 +314,7 @@ static int pcnet32_open(struct net_device *);
>  static int pcnet32_init_ring(struct net_device *);
>  static netdev_tx_t pcnet32_start_xmit(struct sk_buff *,
>  				      struct net_device *);
> -static void pcnet32_tx_timeout(struct net_device *dev);
> +static void pcnet32_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static irqreturn_t pcnet32_interrupt(int, void *);
>  static int pcnet32_close(struct net_device *);
>  static struct net_device_stats *pcnet32_get_stats(struct net_device *);
> @@ -2455,7 +2455,7 @@ static void pcnet32_restart(struct net_device *dev, unsigned int csr0_bits)
>  	lp->a->write_csr(ioaddr, CSR0, csr0_bits);
>  }
>  
> -static void pcnet32_tx_timeout(struct net_device *dev)
> +static void pcnet32_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct pcnet32_private *lp = netdev_priv(dev);
>  	unsigned long ioaddr = dev->base_addr, flags;
> diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
> index ebcbf8ca4829..b00e00881253 100644
> --- a/drivers/net/ethernet/amd/sunlance.c
> +++ b/drivers/net/ethernet/amd/sunlance.c
> @@ -1097,7 +1097,7 @@ static void lance_piozero(void __iomem *dest, int len)
>  		sbus_writeb(0, piobuf);
>  }
>  
> -static void lance_tx_timeout(struct net_device *dev)
> +static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct lance_private *lp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 98f8f2033154..b71f9b04a51e 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -2152,7 +2152,7 @@ static int xgbe_change_mtu(struct net_device *netdev, int mtu)
>  	return 0;
>  }
>  
> -static void xgbe_tx_timeout(struct net_device *netdev)
> +static void xgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct xgbe_prv_data *pdata = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
> index 02b4f3af02b5..c48f60996761 100644
> --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> @@ -575,7 +575,7 @@ static void xge_free_pending_skb(struct net_device *ndev)
>  	}
>  }
>  
> -static void xge_timeout(struct net_device *ndev)
> +static void xge_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct xge_pdata *pdata = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> index d8612131c55e..e284b6753725 100644
> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> @@ -859,7 +859,7 @@ static int xgene_enet_napi(struct napi_struct *napi, const int budget)
>  	return processed;
>  }
>  
> -static void xgene_enet_timeout(struct net_device *ndev)
> +static void xgene_enet_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct xgene_enet_pdata *pdata = netdev_priv(ndev);
>  	struct netdev_queue *txq;
> diff --git a/drivers/net/ethernet/apple/macmace.c b/drivers/net/ethernet/apple/macmace.c
> index 8d03578d5e8c..95d3061c61be 100644
> --- a/drivers/net/ethernet/apple/macmace.c
> +++ b/drivers/net/ethernet/apple/macmace.c
> @@ -91,7 +91,7 @@ static int mace_set_address(struct net_device *dev, void *addr);
>  static void mace_reset(struct net_device *dev);
>  static irqreturn_t mace_interrupt(int irq, void *dev_id);
>  static irqreturn_t mace_dma_intr(int irq, void *dev_id);
> -static void mace_tx_timeout(struct net_device *dev);
> +static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void __mace_set_address(struct net_device *dev, void *addr);
>  
>  /*
> @@ -600,7 +600,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static void mace_tx_timeout(struct net_device *dev)
> +static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mace_data *mp = netdev_priv(dev);
>  	volatile struct mace *mb = mp->mace;
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 1b1a09095c0d..061dc1fec69c 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1409,7 +1409,7 @@ static void ag71xx_oom_timer_handler(struct timer_list *t)
>  	napi_schedule(&ag->napi);
>  }
>  
> -static void ag71xx_tx_timeout(struct net_device *ndev)
> +static void ag71xx_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct ag71xx *ag = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index d4bbcdfd691a..1dcbc486eca9 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1553,7 +1553,7 @@ static netdev_tx_t alx_start_xmit(struct sk_buff *skb,
>  	return alx_start_xmit_ring(skb, alx_tx_queue_mapping(alx, skb));
>  }
>  
> -static void alx_tx_timeout(struct net_device *dev)
> +static void alx_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct alx_priv *alx = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 2b239ecea05f..4c0b1f8551dd 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -350,7 +350,7 @@ static void atl1c_del_timer(struct atl1c_adapter *adapter)
>   * atl1c_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl1c_tx_timeout(struct net_device *netdev)
> +static void atl1c_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct atl1c_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> index 4f7b65825c15..e0d89942d537 100644
> --- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> @@ -251,7 +251,7 @@ static void atl1e_cancel_work(struct atl1e_adapter *adapter)
>   * atl1e_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl1e_tx_timeout(struct net_device *netdev)
> +static void atl1e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct atl1e_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
> index 3aba38322717..b81a4e0c5b57 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl2.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
> @@ -1001,7 +1001,7 @@ static int atl2_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
>   * atl2_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void atl2_tx_timeout(struct net_device *netdev)
> +static void atl2_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct atl2_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> index 97ab0dd25552..f5a13627bb24 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -951,7 +951,7 @@ static irqreturn_t b44_interrupt(int irq, void *dev_id)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -static void b44_tx_timeout(struct net_device *dev)
> +static void b44_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct b44 *bp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> index a977a459bd20..4f3c5bf42e08 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -1354,7 +1354,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
>  	return ret;
>  }
>  
> -static void bcm_sysport_tx_timeout(struct net_device *dev)
> +static void bcm_sysport_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	netdev_warn(dev, "transmit timeout!\n");
>  
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index fbc196b480b6..dbb7874607ca 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -6575,7 +6575,7 @@ bnx2_dump_state(struct bnx2 *bp)
>  }
>  
>  static void
> -bnx2_tx_timeout(struct net_device *dev)
> +bnx2_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct bnx2 *bp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index d10b421ed1f1..d687b9e98341 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -4969,7 +4969,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
>  	return 0;
>  }
>  
> -void bnx2x_tx_timeout(struct net_device *dev)
> +void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct bnx2x *bp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> index 8b08cb18e363..e35f48bfdc85 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> @@ -617,7 +617,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features);
>   *
>   * @dev:	net device
>   */
> -void bnx2x_tx_timeout(struct net_device *dev);
> +void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  
>  /** bnx2x_get_c2s_mapping - read inner-to-outer vlan configuration
>   * c2s_map should have BNX2X_MAX_PRIORITY entries.
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 04ec909e06df..df808394c4cb 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -9936,7 +9936,7 @@ static void bnxt_reset_task(struct bnxt *bp, bool silent)
>  	}
>  }
>  
> -static void bnxt_tx_timeout(struct net_device *dev)
> +static void bnxt_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 1de51811fcb4..841147891c53 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3053,7 +3053,7 @@ static void bcmgenet_dump_tx_queue(struct bcmgenet_tx_ring *ring)
>  		  ring->cb_ptr, ring->end_ptr);
>  }
>  
> -static void bcmgenet_timeout(struct net_device *dev)
> +static void bcmgenet_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct bcmgenet_priv *priv = netdev_priv(dev);
>  	u32 int0_enable = 0;
> diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
> index 1604ad32e920..80ff52527233 100644
> --- a/drivers/net/ethernet/broadcom/sb1250-mac.c
> +++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
> @@ -294,7 +294,7 @@ static int sbmac_set_duplex(struct sbmac_softc *s, enum sbmac_duplex duplex,
>  			    enum sbmac_fc fc);
>  
>  static int sbmac_open(struct net_device *dev);
> -static void sbmac_tx_timeout (struct net_device *dev);
> +static void sbmac_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static void sbmac_set_rx_mode(struct net_device *dev);
>  static int sbmac_mii_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  static int sbmac_close(struct net_device *dev);
> @@ -2419,7 +2419,7 @@ static void sbmac_mii_poll(struct net_device *dev)
>  }
>  
>  
> -static void sbmac_tx_timeout (struct net_device *dev)
> +static void sbmac_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct sbmac_softc *sc = netdev_priv(dev);
>  	unsigned long flags;
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index ca3aa1250dd1..460b4992914a 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -7645,7 +7645,7 @@ static void tg3_poll_controller(struct net_device *dev)
>  }
>  #endif
>  
> -static void tg3_tx_timeout(struct net_device *dev)
> +static void tg3_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct tg3 *tp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
> index f96a42af1014..d1db87634b8f 100644
> --- a/drivers/net/ethernet/calxeda/xgmac.c
> +++ b/drivers/net/ethernet/calxeda/xgmac.c
> @@ -1251,7 +1251,7 @@ static int xgmac_poll(struct napi_struct *napi, int budget)
>   *   netdev structure and arrange for the device to be reset to a sane state
>   *   in order to transmit a new packet.
>   */
> -static void xgmac_tx_timeout(struct net_device *dev)
> +static void xgmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct xgmac_priv *priv = netdev_priv(dev);
>  	schedule_work(&priv->tx_timeout_work);
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index 7f3b2e3b0868..eab05b5534ea 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -2562,7 +2562,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
>  /** \brief Network device Tx timeout
>   * @param netdev    pointer to network device
>   */
> -static void liquidio_tx_timeout(struct net_device *netdev)
> +static void liquidio_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct lio *lio;
>  
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
> index 370d76822ee0..7a77544a54f5 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
> @@ -1628,7 +1628,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
>  /** \brief Network device Tx timeout
>   * @param netdev    pointer to network device
>   */
> -static void liquidio_tx_timeout(struct net_device *netdev)
> +static void liquidio_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct lio *lio;
>  
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> index f3f2e71431ac..600de587d7a9 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> @@ -31,7 +31,7 @@ static int lio_vf_rep_open(struct net_device *ndev);
>  static int lio_vf_rep_stop(struct net_device *ndev);
>  static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
>  				       struct net_device *ndev);
> -static void lio_vf_rep_tx_timeout(struct net_device *netdev);
> +static void lio_vf_rep_tx_timeout(struct net_device *netdev, unsigned int txqueue);
>  static int lio_vf_rep_phys_port_name(struct net_device *dev,
>  				     char *buf, size_t len);
>  static void lio_vf_rep_get_stats64(struct net_device *dev,
> @@ -172,7 +172,7 @@ lio_vf_rep_stop(struct net_device *ndev)
>  }
>  
>  static void
> -lio_vf_rep_tx_timeout(struct net_device *ndev)
> +lio_vf_rep_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	netif_trans_update(ndev);
>  
> diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> index 40a44dcb3d9b..c1a45bb24dbd 100644
> --- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> +++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> @@ -1741,7 +1741,7 @@ static void nicvf_get_stats64(struct net_device *netdev,
>  
>  }
>  
> -static void nicvf_tx_timeout(struct net_device *dev)
> +static void nicvf_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct nicvf *nic = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
> index c9aebcde403a..33ace3307059 100644
> --- a/drivers/net/ethernet/cirrus/cs89x0.c
> +++ b/drivers/net/ethernet/cirrus/cs89x0.c
> @@ -1128,7 +1128,7 @@ net_get_stats(struct net_device *dev)
>  	return &dev->stats;
>  }
>  
> -static void net_timeout(struct net_device *dev)
> +static void net_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	/* If we get here, some higher level has decided we are broken.
>  	   There should really be a "kick me" function call instead. */
> diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
> index acb2856936d2..bbd7b3175f09 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_main.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_main.c
> @@ -1095,7 +1095,7 @@ static void enic_set_rx_mode(struct net_device *netdev)
>  }
>  
>  /* netif_tx_lock held, BHs disabled */
> -static void enic_tx_timeout(struct net_device *netdev)
> +static void enic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct enic *enic = netdev_priv(netdev);
>  	schedule_work(&enic->tx_hang_reset);
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> index a8f4c69252ff..de0b6e066eef 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -1296,7 +1296,7 @@ static int gmac_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>  	return NETDEV_TX_OK;
>  }
>  
> -static void gmac_tx_timeout(struct net_device *netdev)
> +static void gmac_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	netdev_err(netdev, "Tx timeout\n");
>  	gmac_dump_dma_state(netdev);
> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
> index cce90b5925d9..1ea3372775e6 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -964,7 +964,7 @@ dm9000_init_dm9000(struct net_device *dev)
>  }
>  
>  /* Our watchdog timed out. Called by the networking layer */
> -static void dm9000_timeout(struct net_device *dev)
> +static void dm9000_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct board_info *db = netdev_priv(dev);
>  	u8 reg_save;
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index f1a2da15dd0a..fd3c2abf74b5 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -1436,7 +1436,7 @@ static int de_close (struct net_device *dev)
>  	return 0;
>  }
>  
> -static void de_tx_timeout (struct net_device *dev)
> +static void de_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct de_private *de = netdev_priv(dev);
>  	const int irq = de->pdev->irq;
> diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
> index 3e3e08698876..9e9d9eee29d9 100644
> --- a/drivers/net/ethernet/dec/tulip/tulip_core.c
> +++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
> @@ -255,7 +255,7 @@ MODULE_DEVICE_TABLE(pci, tulip_pci_tbl);
>  const char tulip_media_cap[32] =
>  {0,0,0,16,  3,19,16,24,  27,4,7,5, 0,20,23,20,  28,31,0,0, };
>  
> -static void tulip_tx_timeout(struct net_device *dev);
> +static void tulip_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void tulip_init_ring(struct net_device *dev);
>  static void tulip_free_ring(struct net_device *dev);
>  static netdev_tx_t tulip_start_xmit(struct sk_buff *skb,
> @@ -534,7 +534,7 @@ tulip_open(struct net_device *dev)
>  }
>  
>  
> -static void tulip_tx_timeout(struct net_device *dev)
> +static void tulip_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct tulip_private *tp = netdev_priv(dev);
>  	void __iomem *ioaddr = tp->base_addr;
> diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
> index 70cb2d689c2c..7f136488e67c 100644
> --- a/drivers/net/ethernet/dec/tulip/winbond-840.c
> +++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
> @@ -331,7 +331,7 @@ static void netdev_timer(struct timer_list *t);
>  static void init_rxtx_rings(struct net_device *dev);
>  static void free_rxtx_rings(struct netdev_private *np);
>  static void init_registers(struct net_device *dev);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static int alloc_ringdesc(struct net_device *dev);
>  static void free_ringdesc(struct netdev_private *np);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
> @@ -921,7 +921,7 @@ static void init_registers(struct net_device *dev)
>  	iowrite32(0, ioaddr + RxStartDemand);
>  }
>  
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem *ioaddr = np->base_addr;
> diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
> index 55e720d2ea0c..26c5da032b1e 100644
> --- a/drivers/net/ethernet/dlink/dl2k.c
> +++ b/drivers/net/ethernet/dlink/dl2k.c
> @@ -66,7 +66,7 @@ static const int multicast_filter_limit = 0x40;
>  
>  static int rio_open (struct net_device *dev);
>  static void rio_timer (struct timer_list *t);
> -static void rio_tx_timeout (struct net_device *dev);
> +static void rio_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static netdev_tx_t start_xmit (struct sk_buff *skb, struct net_device *dev);
>  static irqreturn_t rio_interrupt (int irq, void *dev_instance);
>  static void rio_free_tx (struct net_device *dev, int irq);
> @@ -696,7 +696,7 @@ rio_timer (struct timer_list *t)
>  }
>  
>  static void
> -rio_tx_timeout (struct net_device *dev)
> +rio_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem *ioaddr = np->ioaddr;
> diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
> index 4a37a69764ce..b91387c456ba 100644
> --- a/drivers/net/ethernet/dlink/sundance.c
> +++ b/drivers/net/ethernet/dlink/sundance.c
> @@ -432,7 +432,7 @@ static int  mdio_wait_link(struct net_device *dev, int wait);
>  static int  netdev_open(struct net_device *dev);
>  static void check_duplex(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
>  static int reset_tx (struct net_device *dev);
> @@ -969,7 +969,7 @@ static void netdev_timer(struct timer_list *t)
>  	add_timer(&np->timer);
>  }
>  
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem *ioaddr = np->base;
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
> index 39eb7d525043..56f59db6ebf2 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -1417,7 +1417,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
>  	return NETDEV_TX_OK;
>  }
>  
> -static void be_tx_timeout(struct net_device *netdev)
> +static void be_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct be_adapter *adapter = netdev_priv(netdev);
>  	struct device *dev = &adapter->pdev->dev;
> diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
> index ea4f17f5cce7..66406da16b60 100644
> --- a/drivers/net/ethernet/ethoc.c
> +++ b/drivers/net/ethernet/ethoc.c
> @@ -869,7 +869,7 @@ static int ethoc_change_mtu(struct net_device *dev, int new_mtu)
>  	return -ENOSYS;
>  }
>  
> -static void ethoc_tx_timeout(struct net_device *dev)
> +static void ethoc_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ethoc *priv = netdev_priv(dev);
>  	u32 pending = ethoc_read(priv, INT_SOURCE);
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 96e9565f1e08..38c9183cb196 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1542,7 +1542,7 @@ static int ftgmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int
>  	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
>  }
>  
> -static void ftgmac100_tx_timeout(struct net_device *netdev)
> +static void ftgmac100_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ftgmac100 *priv = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
> index c24fd56a2c71..84f10970299a 100644
> --- a/drivers/net/ethernet/fealnx.c
> +++ b/drivers/net/ethernet/fealnx.c
> @@ -428,7 +428,7 @@ static void getlinktype(struct net_device *dev);
>  static void getlinkstatus(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
>  static void reset_timer(struct timer_list *t);
> -static void fealnx_tx_timeout(struct net_device *dev);
> +static void fealnx_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void init_ring(struct net_device *dev);
>  static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
>  static irqreturn_t intr_handler(int irq, void *dev_instance);
> @@ -1191,7 +1191,7 @@ static void reset_timer(struct timer_list *t)
>  }
>  
>  
> -static void fealnx_tx_timeout(struct net_device *dev)
> +static void fealnx_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem *ioaddr = np->mem;
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index b4b82b9c5cd6..5339aa50d70d 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -308,7 +308,7 @@ static int dpaa_stop(struct net_device *net_dev)
>  	return err;
>  }
>  
> -static void dpaa_tx_timeout(struct net_device *net_dev)
> +static void dpaa_tx_timeout(struct net_device *net_dev, int txqueue)
>  {
>  	struct dpaa_percpu_priv *percpu_priv;
>  	const struct dpaa_priv	*priv;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index a9c386b63581..1cad343628ed 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1141,7 +1141,7 @@ fec_stop(struct net_device *ndev)
>  
>  
>  static void
> -fec_timeout(struct net_device *ndev)
> +fec_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
> index 30cdb246d020..de5278485062 100644
> --- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
> +++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
> @@ -84,7 +84,7 @@ static int debug = -1;	/* the above default */
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "debugging messages level");
>  
> -static void mpc52xx_fec_tx_timeout(struct net_device *dev)
> +static void mpc52xx_fec_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mpc52xx_fec_priv *priv = netdev_priv(dev);
>  	unsigned long flags;
> diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> index 3981c06f082f..80903cd58468 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> @@ -641,7 +641,7 @@ static void fs_timeout_work(struct work_struct *work)
>  		netif_wake_queue(dev);
>  }
>  
> -static void fs_timeout(struct net_device *dev)
> +static void fs_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct fs_enet_private *fep = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 51ad86417cb1..ffc77e650371 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -2092,7 +2092,7 @@ static void gfar_reset_task(struct work_struct *work)
>  	reset_gfar(priv->ndev);
>  }
>  
> -static void gfar_timeout(struct net_device *dev)
> +static void gfar_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct gfar_private *priv = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index f839fa94ebdd..0d101c00286f 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -3545,7 +3545,7 @@ static void ucc_geth_timeout_work(struct work_struct *work)
>   * ucc_geth_timeout gets called when a packet has not been
>   * transmitted after a set amount of time.
>   */
> -static void ucc_geth_timeout(struct net_device *dev)
> +static void ucc_geth_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ucc_geth_private *ugeth = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
> index 1eca0fdb9933..a7b7a4aace79 100644
> --- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
> +++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
> @@ -93,7 +93,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id);
>  static void fjn_rx(struct net_device *dev);
>  static void fjn_reset(struct net_device *dev);
>  static void set_rx_mode(struct net_device *dev);
> -static void fjn_tx_timeout(struct net_device *dev);
> +static void fjn_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static const struct ethtool_ops netdev_ethtool_ops;
>  
>  /*
> @@ -774,7 +774,7 @@ static irqreturn_t fjn_interrupt(int dummy, void *dev_id)
>  
>  /*====================================================================*/
>  
> -static void fjn_tx_timeout(struct net_device *dev)
> +static void fjn_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>      struct local_info *lp = netdev_priv(dev);
>      unsigned int ioaddr = dev->base_addr;
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index aca95f64bde8..81c80e97c5aa 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -844,7 +844,7 @@ static void gve_turnup(struct gve_priv *priv)
>  	gve_set_napi_enabled(priv);
>  }
>  
> -static void gve_tx_timeout(struct net_device *dev)
> +static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct gve_priv *priv = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
> index 4606a7e4a6d1..d0c94a5373bb 100644
> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
> @@ -779,7 +779,7 @@ static int hip04_mac_stop(struct net_device *ndev)
>  	return 0;
>  }
>  
> -static void hip04_timeout(struct net_device *ndev)
> +static void hip04_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct hip04_priv *priv = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
> index c41b19c760f8..fbaac94cf6ce 100644
> --- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
> +++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
> @@ -893,7 +893,7 @@ static void hix5hd2_tx_timeout_task(struct work_struct *work)
>  	hix5hd2_net_open(priv->netdev);
>  }
>  
> -static void hix5hd2_net_timeout(struct net_device *dev)
> +static void hix5hd2_net_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct hix5hd2_priv *priv = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> index 14ab20491fd0..e45553ec114a 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> @@ -1485,7 +1485,7 @@ static int hns_nic_net_stop(struct net_device *ndev)
>  
>  static void hns_tx_timeout_reset(struct hns_nic_priv *priv);
>  #define HNS_TX_TIMEO_LIMIT (40 * HZ)
> -static void hns_nic_net_timeout(struct net_device *ndev)
> +static void hns_nic_net_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct hns_nic_priv *priv = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 616cad0faa21..bce5ed18f2ca 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -1764,7 +1764,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
>  	return true;
>  }
>  
> -static void hns3_nic_net_timeout(struct net_device *ndev)
> +static void hns3_nic_net_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct hns3_nic_priv *priv = netdev_priv(ndev);
>  	struct hnae3_handle *h = priv->ae_handle;
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index 2411ad270c98..02a14f5e7fe3 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -766,7 +766,7 @@ static void hinic_set_rx_mode(struct net_device *netdev)
>  	queue_work(nic_dev->workq, &rx_mode_work->work);
>  }
>  
> -static void hinic_tx_timeout(struct net_device *netdev)
> +static void hinic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct hinic_dev *nic_dev = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
> index 92929750f832..bef676d93339 100644
> --- a/drivers/net/ethernet/i825xx/82596.c
> +++ b/drivers/net/ethernet/i825xx/82596.c
> @@ -363,7 +363,7 @@ static netdev_tx_t i596_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  static irqreturn_t i596_interrupt(int irq, void *dev_id);
>  static int i596_close(struct net_device *dev);
>  static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
> -static void i596_tx_timeout (struct net_device *dev);
> +static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static void print_eth(unsigned char *buf, char *str);
>  static void set_multicast_list(struct net_device *dev);
>  
> @@ -1019,7 +1019,7 @@ static int i596_open(struct net_device *dev)
>  	return res;
>  }
>  
> -static void i596_tx_timeout (struct net_device *dev)
> +static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct i596_private *lp = dev->ml_priv;
>  	int ioaddr = dev->base_addr;
> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
> index bb3b8adbe4f0..a0bfb509e002 100644
> --- a/drivers/net/ethernet/i825xx/ether1.c
> +++ b/drivers/net/ethernet/i825xx/ether1.c
> @@ -66,7 +66,7 @@ static netdev_tx_t ether1_sendpacket(struct sk_buff *skb,
>  static irqreturn_t ether1_interrupt(int irq, void *dev_id);
>  static int ether1_close(struct net_device *dev);
>  static void ether1_setmulticastlist(struct net_device *dev);
> -static void ether1_timeout(struct net_device *dev);
> +static void ether1_timeout(struct net_device *dev, unsigned int txqueue);
>  
>  /* ------------------------------------------------------------------------- */
>  
> @@ -650,7 +650,7 @@ ether1_open (struct net_device *dev)
>  }
>  
>  static void
> -ether1_timeout(struct net_device *dev)
> +ether1_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	printk(KERN_WARNING "%s: transmit timeout, network cable problem?\n",
>  		dev->name);
> diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
> index f9742af7f142..b03757e169e4 100644
> --- a/drivers/net/ethernet/i825xx/lib82596.c
> +++ b/drivers/net/ethernet/i825xx/lib82596.c
> @@ -351,7 +351,7 @@ static netdev_tx_t i596_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  static irqreturn_t i596_interrupt(int irq, void *dev_id);
>  static int i596_close(struct net_device *dev);
>  static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
> -static void i596_tx_timeout (struct net_device *dev);
> +static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static void print_eth(unsigned char *buf, char *str);
>  static void set_multicast_list(struct net_device *dev);
>  static inline void ca(struct net_device *dev);
> @@ -936,7 +936,7 @@ static int i596_open(struct net_device *dev)
>  	return -EAGAIN;
>  }
>  
> -static void i596_tx_timeout (struct net_device *dev)
> +static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)
>  {
>  	struct i596_private *lp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
> index 1a86184d44c0..4564ee02c95f 100644
> --- a/drivers/net/ethernet/i825xx/sun3_82586.c
> +++ b/drivers/net/ethernet/i825xx/sun3_82586.c
> @@ -125,7 +125,7 @@ static netdev_tx_t     sun3_82586_send_packet(struct sk_buff *,
>  					      struct net_device *);
>  static struct  net_device_stats *sun3_82586_get_stats(struct net_device *dev);
>  static void    set_multicast_list(struct net_device *dev);
> -static void    sun3_82586_timeout(struct net_device *dev);
> +static void    sun3_82586_timeout(struct net_device *dev, unsigned int txqueue);
>  #if 0
>  static void    sun3_82586_dump(struct net_device *,void *);
>  #endif
> @@ -965,7 +965,7 @@ static void startrecv586(struct net_device *dev)
>  	WAIT_4_SCB_CMD_RUC();	/* wait for accept cmd. (no timeout!!) */
>  }
>  
> -static void sun3_82586_timeout(struct net_device *dev)
> +static void sun3_82586_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct priv *p = netdev_priv(dev);
>  #ifndef NO_NOPCOMMANDS
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> index 13e30eba5349..0273fb7a9d01 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -2786,7 +2786,7 @@ static void ehea_rereg_mrs(void)
>  	return;
>  }
>  
> -static void ehea_tx_watchdog(struct net_device *dev)
> +static void ehea_tx_watchdog(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ehea_port *port = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
> index 9e43c9ace9c2..1f82f6834331 100644
> --- a/drivers/net/ethernet/ibm/emac/core.c
> +++ b/drivers/net/ethernet/ibm/emac/core.c
> @@ -776,7 +776,7 @@ static void emac_reset_work(struct work_struct *work)
>  	mutex_unlock(&dev->link_lock);
>  }
>  
> -static void emac_tx_timeout(struct net_device *ndev)
> +static void emac_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct emac_instance *dev = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index f59d9a8e35e2..867525a0abaf 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2189,7 +2189,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
>  	return -ret;
>  }
>  
> -static void ibmvnic_tx_timeout(struct net_device *dev)
> +static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
> index a65d5a9ba7db..1b8d015ebfb0 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -2316,7 +2316,7 @@ static void e100_down(struct nic *nic)
>  	e100_rx_clean_list(nic);
>  }
>  
> -static void e100_tx_timeout(struct net_device *netdev)
> +static void e100_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct nic *nic = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
> index 86493fea56e4..570133403ee2 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -134,7 +134,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
>  			   int cmd);
>  static void e1000_enter_82542_rst(struct e1000_adapter *adapter);
>  static void e1000_leave_82542_rst(struct e1000_adapter *adapter);
> -static void e1000_tx_timeout(struct net_device *dev);
> +static void e1000_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void e1000_reset_task(struct work_struct *work);
>  static void e1000_smartspeed(struct e1000_adapter *adapter);
>  static int e1000_82547_fifo_workaround(struct e1000_adapter *adapter,
> @@ -3488,7 +3488,7 @@ static void e1000_dump(struct e1000_adapter *adapter)
>   * e1000_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void e1000_tx_timeout(struct net_device *netdev)
> +static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e42a6aa..d46827d4cbb7 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5926,7 +5926,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
>   * e1000_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void e1000_tx_timeout(struct net_device *netdev)
> +static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> index 09f7a246e134..2c7fcf269c3b 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> @@ -697,7 +697,7 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *skb, struct net_device *dev)
>   * fm10k_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void fm10k_tx_timeout(struct net_device *netdev)
> +static void fm10k_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct fm10k_intfc *interface = netdev_priv(netdev);
>  	bool real_tx_hang = false;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 6031223eafab..caa86825e164 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -301,7 +301,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
>   * device is munged, not just the one netdev port, so go for the full
>   * reset.
>   **/
> -static void i40e_tx_timeout(struct net_device *netdev)
> +static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct i40e_netdev_priv *np = netdev_priv(netdev);
>  	struct i40e_vsi *vsi = np->vsi;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 821987da5698..0a8824871618 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -159,7 +159,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
>   * iavf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void iavf_tx_timeout(struct net_device *netdev)
> +static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct iavf_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 214cd6eca405..f171f0750350 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -4627,7 +4627,7 @@ ice_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
>   * ice_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   */
> -static void ice_tx_timeout(struct net_device *netdev)
> +static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ice_netdev_priv *np = netdev_priv(netdev);
>  	struct ice_ring *tx_ring = NULL;
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index ed7e667d7eb2..4656ff17dcbe 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -146,7 +146,7 @@ static int igb_poll(struct napi_struct *, int);
>  static bool igb_clean_tx_irq(struct igb_q_vector *, int);
>  static int igb_clean_rx_irq(struct igb_q_vector *, int);
>  static int igb_ioctl(struct net_device *, struct ifreq *, int cmd);
> -static void igb_tx_timeout(struct net_device *);
> +static void igb_tx_timeout(struct net_device *, unsigned int txqueue);
>  static void igb_reset_task(struct work_struct *);
>  static void igb_vlan_mode(struct net_device *netdev,
>  			  netdev_features_t features);
> @@ -6173,7 +6173,7 @@ static netdev_tx_t igb_xmit_frame(struct sk_buff *skb,
>   *  igb_tx_timeout - Respond to a Tx Hang
>   *  @netdev: network interface device structure
>   **/
> -static void igb_tx_timeout(struct net_device *netdev)
> +static void igb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct igb_adapter *adapter = netdev_priv(netdev);
>  	struct e1000_hw *hw = &adapter->hw;
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
> index 0f2b68f4bb0f..5721ddf124c4 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -2375,7 +2375,7 @@ static netdev_tx_t igbvf_xmit_frame(struct sk_buff *skb,
>   * igbvf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void igbvf_tx_timeout(struct net_device *netdev)
> +static void igbvf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct igbvf_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
> index 0940a0da16f2..e11c6ac77140 100644
> --- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
> +++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
> @@ -70,7 +70,7 @@ static int ixgb_clean(struct napi_struct *, int);
>  static bool ixgb_clean_rx_irq(struct ixgb_adapter *, int *, int);
>  static void ixgb_alloc_rx_buffers(struct ixgb_adapter *, int);
>  
> -static void ixgb_tx_timeout(struct net_device *dev);
> +static void ixgb_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void ixgb_tx_timeout_task(struct work_struct *work);
>  
>  static void ixgb_vlan_strip_enable(struct ixgb_adapter *adapter);
> @@ -1538,7 +1538,7 @@ ixgb_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>   **/
>  
>  static void
> -ixgb_tx_timeout(struct net_device *netdev)
> +ixgb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ixgb_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
> index 171cdc552961..5b1cf49df3d3 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
> @@ -166,7 +166,9 @@ static ssize_t ixgbe_dbg_netdev_ops_write(struct file *filp,
>  	ixgbe_dbg_netdev_ops_buf[len] = '\0';
>  
>  	if (strncmp(ixgbe_dbg_netdev_ops_buf, "tx_timeout", 10) == 0) {
> -		adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev);
> +		/* TX Queue number below is wrong, but ixgbe does not use it */
> +		adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev,
> +							    UINT_MAX);
>  		e_dev_info("tx_timeout called\n");
>  	} else {
>  		e_dev_info("Unknown command: %s\n", ixgbe_dbg_netdev_ops_buf);
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 91b3780ddb04..dcf2f57bfc8c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6158,7 +6158,7 @@ static void ixgbe_set_eee_capable(struct ixgbe_adapter *adapter)
>   * ixgbe_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void ixgbe_tx_timeout(struct net_device *netdev)
> +static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ixgbe_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 076f2da36f27..fa286694ac2c 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -250,7 +250,7 @@ static void ixgbevf_tx_timeout_reset(struct ixgbevf_adapter *adapter)
>   * ixgbevf_tx_timeout - Respond to a Tx Hang
>   * @netdev: network interface device structure
>   **/
> -static void ixgbevf_tx_timeout(struct net_device *netdev)
> +static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
> index 25aa400e2e3c..2e4975572e9f 100644
> --- a/drivers/net/ethernet/jme.c
> +++ b/drivers/net/ethernet/jme.c
> @@ -2337,7 +2337,7 @@ jme_change_mtu(struct net_device *netdev, int new_mtu)
>  }
>  
>  static void
> -jme_tx_timeout(struct net_device *netdev)
> +jme_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct jme_adapter *jme = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index ae195f8adff5..f98d9d627c71 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -917,7 +917,7 @@ static void korina_restart_task(struct work_struct *work)
>  	enable_irq(lp->rx_irq);
>  }
>  
> -static void korina_tx_timeout(struct net_device *dev)
> +static void korina_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct korina_private *lp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> index 6e73ffe6f928..028e3e6222e9 100644
> --- a/drivers/net/ethernet/lantiq_etop.c
> +++ b/drivers/net/ethernet/lantiq_etop.c
> @@ -594,7 +594,7 @@ ltq_etop_init(struct net_device *dev)
>  }
>  
>  static void
> -ltq_etop_tx_timeout(struct net_device *dev)
> +ltq_etop_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	int err;
>  
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 82ea55ae5053..93360de6e98b 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -2590,7 +2590,7 @@ static void tx_timeout_task(struct work_struct *ugly)
>  	}
>  }
>  
> -static void mv643xx_eth_tx_timeout(struct net_device *dev)
> +static void mv643xx_eth_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mv643xx_eth_private *mp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
> index 51b77c2de400..5cd74bdfdf50 100644
> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> @@ -742,7 +742,7 @@ static int txq_reclaim(struct net_device *dev, int force)
>  	return released;
>  }
>  
> -static void pxa168_eth_tx_timeout(struct net_device *dev)
> +static void pxa168_eth_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct pxa168_eth_private *pep = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
> index 095f6c71b4fa..8ca15958e752 100644
> --- a/drivers/net/ethernet/marvell/skge.c
> +++ b/drivers/net/ethernet/marvell/skge.c
> @@ -2884,7 +2884,7 @@ static void skge_tx_clean(struct net_device *dev)
>  	skge->tx_ring.to_clean = e;
>  }
>  
> -static void skge_tx_timeout(struct net_device *dev)
> +static void skge_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct skge_port *skge = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index 5f56ee83e3b1..acd1cba987fb 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -2358,7 +2358,7 @@ static void sky2_qlink_intr(struct sky2_hw *hw)
>  /* Transmit timeout is only called if we are running, carrier is up
>   * and tx queue is full (stopped).
>   */
> -static void sky2_tx_timeout(struct net_device *dev)
> +static void sky2_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct sky2_port *sky2 = netdev_priv(dev);
>  	struct sky2_hw *hw = sky2->hw;
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 703adb96429e..1376870f78ce 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2083,7 +2083,7 @@ static void mtk_dma_free(struct mtk_eth *eth)
>  	kfree(eth->scratch_head);
>  }
>  
> -static void mtk_tx_timeout(struct net_device *dev)
> +static void mtk_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mtk_mac *mac = netdev_priv(dev);
>  	struct mtk_eth *eth = mac->hw;
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index 40ec5acf79c0..d2728933d420 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -1354,7 +1354,7 @@ static void mlx4_en_delete_rss_steer_rules(struct mlx4_en_priv *priv)
>  	}
>  }
>  
> -static void mlx4_en_tx_timeout(struct net_device *dev)
> +static void mlx4_en_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mlx4_en_priv *priv = netdev_priv(dev);
>  	struct mlx4_en_dev *mdev = priv->mdev;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 772bfdbdeb9c..3efee40804e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4337,7 +4337,7 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
>  	rtnl_unlock();
>  }
>  
> -static void mlx5e_tx_timeout(struct net_device *dev)
> +static void mlx5e_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct mlx5e_priv *priv = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
> index da329ca115cc..f3f6dfe3eddc 100644
> --- a/drivers/net/ethernet/micrel/ks8842.c
> +++ b/drivers/net/ethernet/micrel/ks8842.c
> @@ -1103,7 +1103,7 @@ static void ks8842_tx_timeout_work(struct work_struct *work)
>  		__ks8842_start_new_rx_dma(netdev);
>  }
>  
> -static void ks8842_tx_timeout(struct net_device *netdev)
> +static void ks8842_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ks8842_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index e102e1560ac7..d1444ba36e10 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -4896,7 +4896,7 @@ static netdev_tx_t netdev_tx(struct sk_buff *skb, struct net_device *dev)
>   * triggered to free up resources so that the transmit routine can continue
>   * sending out packets.  The hardware is reset to correct the problem.
>   */
> -static void netdev_tx_timeout(struct net_device *dev)
> +static void netdev_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	static unsigned long last_reset;
>  
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
> index 0567e4f387a5..09cdc2f2e7ff 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -1325,7 +1325,7 @@ static irqreturn_t enc28j60_irq(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static void enc28j60_tx_timeout(struct net_device *ndev)
> +static void enc28j60_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct enc28j60_net *priv = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
> index 52c41d11f565..39925e4bf2ec 100644
> --- a/drivers/net/ethernet/microchip/encx24j600.c
> +++ b/drivers/net/ethernet/microchip/encx24j600.c
> @@ -892,7 +892,7 @@ static netdev_tx_t encx24j600_tx(struct sk_buff *skb, struct net_device *dev)
>  }
>  
>  /* Deal with a transmit timeout */
> -static void encx24j600_tx_timeout(struct net_device *dev)
> +static void encx24j600_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct encx24j600_priv *priv = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
> index 1a2634cbbb69..d21d706b83a7 100644
> --- a/drivers/net/ethernet/natsemi/natsemi.c
> +++ b/drivers/net/ethernet/natsemi/natsemi.c
> @@ -612,7 +612,7 @@ static void undo_cable_magic(struct net_device *dev);
>  static void check_link(struct net_device *dev);
>  static void netdev_timer(struct timer_list *t);
>  static void dump_ring(struct net_device *dev);
> -static void ns_tx_timeout(struct net_device *dev);
> +static void ns_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static int alloc_ring(struct net_device *dev);
>  static void refill_rx(struct net_device *dev);
>  static void init_ring(struct net_device *dev);
> @@ -1881,7 +1881,7 @@ static void dump_ring(struct net_device *dev)
>  	}
>  }
>  
> -static void ns_tx_timeout(struct net_device *dev)
> +static void ns_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct netdev_private *np = netdev_priv(dev);
>  	void __iomem * ioaddr = ns_ioaddr(dev);
> diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
> index 6af9a7eee114..fb671a0da521 100644
> --- a/drivers/net/ethernet/natsemi/ns83820.c
> +++ b/drivers/net/ethernet/natsemi/ns83820.c
> @@ -1549,7 +1549,7 @@ static int ns83820_stop(struct net_device *ndev)
>  	return 0;
>  }
>  
> -static void ns83820_tx_timeout(struct net_device *ndev)
> +static void ns83820_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct ns83820 *dev = PRIV(ndev);
>          u32 tx_done_idx;
> diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
> index b339125b2f09..fdebc8598b22 100644
> --- a/drivers/net/ethernet/natsemi/sonic.c
> +++ b/drivers/net/ethernet/natsemi/sonic.c
> @@ -161,7 +161,7 @@ static int sonic_close(struct net_device *dev)
>  	return 0;
>  }
>  
> -static void sonic_tx_timeout(struct net_device *dev)
> +static void sonic_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct sonic_local *lp = netdev_priv(dev);
>  	int i;
> diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
> index 2b27f7049acb..f1544481aac1 100644
> --- a/drivers/net/ethernet/natsemi/sonic.h
> +++ b/drivers/net/ethernet/natsemi/sonic.h
> @@ -336,7 +336,7 @@ static int sonic_close(struct net_device *dev);
>  static struct net_device_stats *sonic_get_stats(struct net_device *dev);
>  static void sonic_multicast_list(struct net_device *dev);
>  static int sonic_init(struct net_device *dev);
> -static void sonic_tx_timeout(struct net_device *dev);
> +static void sonic_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void sonic_msg_init(struct net_device *dev);
>  
>  /* Internal inlines for reading/writing DMA buffers.  Note that bus
> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
> index e0b2bf327905..0ec6b8e8b549 100644
> --- a/drivers/net/ethernet/neterion/s2io.c
> +++ b/drivers/net/ethernet/neterion/s2io.c
> @@ -7238,7 +7238,7 @@ static void s2io_restart_nic(struct work_struct *work)
>   *  void
>   */
>  
> -static void s2io_tx_watchdog(struct net_device *dev)
> +static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct s2io_nic *sp = netdev_priv(dev);
>  	struct swStat *swstats = &sp->mac_control.stats_info->sw_stat;
> diff --git a/drivers/net/ethernet/neterion/s2io.h b/drivers/net/ethernet/neterion/s2io.h
> index 0a921f30f98f..6fa3159a977f 100644
> --- a/drivers/net/ethernet/neterion/s2io.h
> +++ b/drivers/net/ethernet/neterion/s2io.h
> @@ -1065,7 +1065,7 @@ static void s2io_txpic_intr_handle(struct s2io_nic *sp);
>  static void tx_intr_handler(struct fifo_info *fifo_data);
>  static void s2io_handle_errors(void * dev_id);
>  
> -static void s2io_tx_watchdog(struct net_device *dev);
> +static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue);
>  static void s2io_set_multicast(struct net_device *dev);
>  static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp);
>  static void s2io_link(struct s2io_nic * sp, int link);
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> index 1d334f2e0a56..9b63574b6202 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> @@ -3273,7 +3273,7 @@ static int vxge_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>   * This function is triggered if the Tx Queue is stopped
>   * for a pre-defined amount of time when the Interface is still up.
>   */
> -static void vxge_tx_watchdog(struct net_device *dev)
> +static void vxge_tx_watchdog(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct vxgedev *vdev;
>  
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 61aabffc8888..41a808b14d76 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -1320,7 +1320,7 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
>  	netdev_tx_reset_queue(nd_q);
>  }
>  
> -static void nfp_net_tx_timeout(struct net_device *netdev)
> +static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct nfp_net *nn = netdev_priv(netdev);
>  	int i;
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 05d2b478c99b..4b963a873003 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -2700,7 +2700,7 @@ static int nv_tx_done_optimized(struct net_device *dev, int limit)
>   * nv_tx_timeout: dev->tx_timeout function
>   * Called with netif_tx_lock held.
>   */
> -static void nv_tx_timeout(struct net_device *dev)
> +static void nv_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct fe_priv *np = netdev_priv(dev);
>  	u8 __iomem *base = get_hwbase(dev);
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> index 18e6d87c607b..73ec195fbc30 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> @@ -2271,7 +2271,7 @@ static int pch_gbe_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
>   * pch_gbe_tx_timeout - Respond to a Tx Hang
>   * @netdev:   Network interface device structure
>   */
> -static void pch_gbe_tx_timeout(struct net_device *netdev)
> +static void pch_gbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
> index eee883a2aa8d..70816d2e2990 100644
> --- a/drivers/net/ethernet/packetengines/hamachi.c
> +++ b/drivers/net/ethernet/packetengines/hamachi.c
> @@ -548,7 +548,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int location, int val
>  static int hamachi_open(struct net_device *dev);
>  static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  static void hamachi_timer(struct timer_list *t);
> -static void hamachi_tx_timeout(struct net_device *dev);
> +static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static void hamachi_init_ring(struct net_device *dev);
>  static netdev_tx_t hamachi_start_xmit(struct sk_buff *skb,
>  				      struct net_device *dev);
> @@ -1042,7 +1042,7 @@ static void hamachi_timer(struct timer_list *t)
>  	add_timer(&hmp->timer);
>  }
>  
> -static void hamachi_tx_timeout(struct net_device *dev)
> +static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	int i;
>  	struct hamachi_private *hmp = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
> index 5113ee647090..520779f05e1a 100644
> --- a/drivers/net/ethernet/packetengines/yellowfin.c
> +++ b/drivers/net/ethernet/packetengines/yellowfin.c
> @@ -344,7 +344,7 @@ static void mdio_write(void __iomem *ioaddr, int phy_id, int location, int value
>  static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
>  static int yellowfin_open(struct net_device *dev);
>  static void yellowfin_timer(struct timer_list *t);
> -static void yellowfin_tx_timeout(struct net_device *dev);
> +static void yellowfin_tx_timeout(struct net_device *dev, unsigned int txqueue);
>  static int yellowfin_init_ring(struct net_device *dev);
>  static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
>  					struct net_device *dev);
> @@ -677,7 +677,7 @@ static void yellowfin_timer(struct timer_list *t)
>  	add_timer(&yp->timer);
>  }
>  
> -static void yellowfin_tx_timeout(struct net_device *dev)
> +static void yellowfin_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct yellowfin_private *yp = netdev_priv(dev);
>  	void __iomem *ioaddr = yp->base;
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 20faa8d24c9f..f7beb1b9e9d6 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1268,7 +1268,7 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
>  	rtnl_unlock();
>  }
>  
> -static void ionic_tx_timeout(struct net_device *netdev)
> +static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct ionic_lif *lif = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> index c692a41e4548..8067ea04d455 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> @@ -49,7 +49,7 @@ static int netxen_nic_open(struct net_device *netdev);
>  static int netxen_nic_close(struct net_device *netdev);
>  static netdev_tx_t netxen_nic_xmit_frame(struct sk_buff *,
>  					       struct net_device *);
> -static void netxen_tx_timeout(struct net_device *netdev);
> +static void netxen_tx_timeout(struct net_device *netdev, unsigned int txqueue);
>  static void netxen_tx_timeout_task(struct work_struct *work);
>  static void netxen_fw_poll_work(struct work_struct *work);
>  static void netxen_schedule_work(struct netxen_adapter *adapter,
> @@ -2222,7 +2222,7 @@ static void netxen_nic_handle_phy_intr(struct netxen_adapter *adapter)
>  	netxen_advert_link_change(adapter, linkup);
>  }
>  
> -static void netxen_tx_timeout(struct net_device *netdev)
> +static void netxen_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct netxen_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> index b4b8ba00ee01..bb864765c761 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -3602,7 +3602,7 @@ static int ql3xxx_set_mac_address(struct net_device *ndev, void *p)
>  	return 0;
>  }
>  
> -static void ql3xxx_tx_timeout(struct net_device *ndev)
> +static void ql3xxx_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct ql3_adapter *qdev = netdev_priv(ndev);
>  
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index c07438db30ba..9dd6cb36f366 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -56,7 +56,7 @@ static int qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
>  static void qlcnic_remove(struct pci_dev *pdev);
>  static int qlcnic_open(struct net_device *netdev);
>  static int qlcnic_close(struct net_device *netdev);
> -static void qlcnic_tx_timeout(struct net_device *netdev);
> +static void qlcnic_tx_timeout(struct net_device *netdev, unsigned int txqueue);
>  static void qlcnic_attach_work(struct work_struct *work);
>  static void qlcnic_fwinit_work(struct work_struct *work);
>  
> @@ -3068,7 +3068,7 @@ static void qlcnic_dump_rings(struct qlcnic_adapter *adapter)
>  
>  }
>  
> -static void qlcnic_tx_timeout(struct net_device *netdev)
> +static void qlcnic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct qlcnic_adapter *adapter = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
> index c84ab052ef26..c33f491b1364 100644
> --- a/drivers/net/ethernet/qualcomm/emac/emac.c
> +++ b/drivers/net/ethernet/qualcomm/emac/emac.c
> @@ -282,7 +282,7 @@ static int emac_close(struct net_device *netdev)
>  }
>  
>  /* Respond to a TX hang */
> -static void emac_tx_timeout(struct net_device *netdev)
> +static void emac_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  {
>  	struct emac_adapter *adpt = netdev_priv(netdev);
>  
> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
> index 5ecf61df78bd..2b0233aa2528 100644
> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> @@ -786,7 +786,7 @@ qcaspi_netdev_xmit(struct sk_buff *skb, struct net_device *dev)
>  }
>  
>  static void
> -qcaspi_netdev_tx_timeout(struct net_device *dev)
> +qcaspi_netdev_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct qcaspi *qca = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
> index 0981068504fa..375a844cd27c 100644
> --- a/drivers/net/ethernet/qualcomm/qca_uart.c
> +++ b/drivers/net/ethernet/qualcomm/qca_uart.c
> @@ -248,7 +248,7 @@ qcauart_netdev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return NETDEV_TX_OK;
>  }
>  
> -static void qcauart_netdev_tx_timeout(struct net_device *dev)
> +static void qcauart_netdev_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct qcauart *qca = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
> index 274e5b4bc4ac..c23cb61bbd30 100644
> --- a/drivers/net/ethernet/rdc/r6040.c
> +++ b/drivers/net/ethernet/rdc/r6040.c
> @@ -410,7 +410,7 @@ static void r6040_init_mac_regs(struct net_device *dev)
>  	iowrite16(TM2TX, ioaddr + MTPR);
>  }
>  
> -static void r6040_tx_timeout(struct net_device *dev)
> +static void r6040_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct r6040_private *priv = netdev_priv(dev);
>  	void __iomem *ioaddr = priv->base;
> diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
> index 4f910c4f67b0..60d342f82fb3 100644
> --- a/drivers/net/ethernet/realtek/8139cp.c
> +++ b/drivers/net/ethernet/realtek/8139cp.c
> @@ -1235,7 +1235,7 @@ static int cp_close (struct net_device *dev)
>  	return 0;
>  }
>  
> -static void cp_tx_timeout(struct net_device *dev)
> +static void cp_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct cp_private *cp = netdev_priv(dev);
>  	unsigned long flags;
> diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
> index 55d01266e615..5caeb8368eab 100644
> --- a/drivers/net/ethernet/realtek/8139too.c
> +++ b/drivers/net/ethernet/realtek/8139too.c
> @@ -642,7 +642,7 @@ static int mdio_read (struct net_device *dev, int phy_id, int location);
>  static void mdio_write (struct net_device *dev, int phy_id, int location,
>  			int val);
>  static void rtl8139_start_thread(struct rtl8139_private *tp);
> -static void rtl8139_tx_timeout (struct net_device *dev);
> +static void rtl8139_tx_timeout (struct net_device *dev, unsigned int txqueue);
>  static void rtl8139_init_ring (struct net_device *dev);
>  static netdev_tx_t rtl8139_start_xmit (struct sk_buff *skb,
>  				       struct net_device *dev);
> @@ -1700,7 +1700,7 @@ static void rtl8139_tx_timeout_task (struct work_struct *work)
>  	spin_unlock_bh(&tp->rx_lock);
>  }
>  
> -static void rtl8139_tx_timeout (struct net_device *dev)
> +static void rtl8139_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct rtl8139_private *tp = netdev_priv(dev);
>  
> diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
> index 58e0ca9093d3..9e3b35c97e63 100644
> --- a/drivers/net/ethernet/realtek/atp.c
> +++ b/drivers/net/ethernet/realtek/atp.c
> @@ -204,7 +204,7 @@ static void net_rx(struct net_device *dev);
>  static void read_block(long ioaddr, int length, unsigned char *buffer, int data_mode);
>  static int net_close(struct net_device *dev);
>  static void set_rx_mode(struct net_device *dev);
> -static void tx_timeout(struct net_device *dev);
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue);
>  
>  
>  /* A list of all installed ATP devices, for removing the driver module. */
> @@ -533,7 +533,7 @@ static void write_packet(long ioaddr, int length, unsigned char *packet, int pad
>      outb(Ctrl_HNibWrite | Ctrl_SelData | Ctrl_IRQEN, ioaddr + PAR_CONTROL);
>  }
>  
> -static void tx_timeout(struct net_device *dev)
> +static void tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	long ioaddr = dev->base_addr;
>  
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index c4e961ea44d5..a9f95518c627 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5662,7 +5662,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
>  	netif_wake_queue(dev);
>  }
>  
> -static void rtl8169_tx_timeout(struct net_device *dev)
> +static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  

For r8169:
Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
