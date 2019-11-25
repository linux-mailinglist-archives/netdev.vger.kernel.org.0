Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18DF108A32
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 09:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKYImc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 03:42:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51922 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725828AbfKYImb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 03:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574671341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVgrQYRTBv9ZTCftQOJPStGlsB1DnRyZ72azZTkSH04=;
        b=Mck8Fm4zxuWLixidLrEeBds0BRHKpXGqUz6I/K1JL7K0oppR2dojztma2LWOiCqlXLdOSL
        8fwCVFQACQnBbQnH2oxhH2Xt0/wwFaFUJRdxp8e3+L6qNVY2bRk0Bgr7pwJkxDLx46ZXmI
        t881ULc+74WmQeVOg82tfjBdGe0e/VM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-8vENm7yzNz2UgydRwxmy2A-1; Mon, 25 Nov 2019 03:42:20 -0500
Received: by mail-qv1-f69.google.com with SMTP id b6so9839524qvo.4
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 00:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XteXgZeasHzj8o9rBJ5B+3iZnYek+RastSBag7cjNjo=;
        b=E1FmlJlYAWUSZi3wOa3GvPSMV+llDPv6SrBRUYfVTCiwuoA2vc0TjWWeqiIcIq938d
         Qo4HWh3JW2M2HKk52uiGrGXt8fy4vpsZRHtXJ4g5Kb4rb6ObbEvwT9Njptgz3X5udUAn
         E09dSjtQ+Kg7rs/LU8f4oHvpCGFoBEUYQGByXa75MBDFhFbE673c+HYFJlQy+/HJDZHl
         ZWm4kQmikhltvY3Sy2mCSddydC2S8eUxA89Uu4Mor6IM4sFFooY1HLKRF8BFlY1grHzk
         hTbtRn8ecAgKwjtJLUKL7Rhz+yvUbBDx3caPrsrsjCsUwBKm7u2pMWV9URt+0jLoFVlA
         tiXg==
X-Gm-Message-State: APjAAAXsxlQvnQZ/waoZOkadr/yzS7B4WARtgjwL8oPdnclLRU/QVRG0
        5jbr/VBOEfZxfTetIxeLAHfbdPugychajjKELMiKCgC6OSpl5SOUopl3eFCGuo1I/FOATay6+P7
        1zJlDlY6cIWeLC0LD
X-Received: by 2002:a05:620a:485:: with SMTP id 5mr24620519qkr.134.1574671337677;
        Mon, 25 Nov 2019 00:42:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvOUeNAMReeMlUtE8xMt6TpQzkFKiazCg+QHi+1JOt1kqsEz1+ZABxlmMLG/rhu06WNEzz9g==
X-Received: by 2002:a05:620a:485:: with SMTP id 5mr24620416qkr.134.1574671335439;
        Mon, 25 Nov 2019 00:42:15 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id g11sm2986512qkm.82.2019.11.25.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 00:42:14 -0800 (PST)
Date:   Mon, 25 Nov 2019 03:42:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191125033959-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
 <20191122052506-mutt-send-email-mst@kernel.org>
 <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
 <20191124100157-mutt-send-email-mst@kernel.org>
 <20191124164411-mutt-send-email-mst@kernel.org>
 <20191124150352.5cab3209@cakuba.netronome.com>
 <20191124182426-mutt-send-email-mst@kernel.org>
 <20191124153717.6edefa85@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191124153717.6edefa85@cakuba.netronome.com>
X-MC-Unique: 8vENm7yzNz2UgydRwxmy2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 03:37:17PM -0800, Jakub Kicinski wrote:
> On Sun, 24 Nov 2019 18:29:49 -0500, Michael S. Tsirkin wrote:
> > netdev: pass the stuck queue to the timeout handler
> >=20
> > This allows incrementing the correct timeout statistic without any mess=
.
> > Down the road, devices can learn to reset just the specific queue.
>=20
> FWIW
>=20
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

OK but I think you need to include this with your patch
that actually uses the infrastructure.

Meanwhile here's v5, fixing an error reported by kbuild:

--->
netdev: pass the stuck queue to the timeout handler

This allows incrementing the correct timeout statistic without any mess.
Down the road, devices can learn to reset just the specific queue.

The patch was generated with the following script:

use strict;
use warnings;

our $^I =3D '.bak';

my @work =3D (
["arch/m68k/emu/nfeth.c", "nfeth_tx_timeout"],
["arch/um/drivers/net_kern.c", "uml_net_tx_timeout"],
["arch/um/drivers/vector_kern.c", "vector_net_tx_timeout"],
["arch/xtensa/platforms/iss/network.c", "iss_net_tx_timeout"],
["drivers/char/pcmcia/synclink_cs.c", "hdlcdev_tx_timeout"],
["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
["drivers/infiniband/ulp/ipoib/ipoib_main.c", "ipoib_timeout"],
["drivers/message/fusion/mptlan.c", "mpt_lan_tx_timeout"],
["drivers/misc/sgi-xp/xpnet.c", "xpnet_dev_tx_timeout"],
["drivers/net/appletalk/cops.c", "cops_timeout"],
["drivers/net/arcnet/arcdevice.h", "arcnet_timeout"],
["drivers/net/arcnet/arcnet.c", "arcnet_timeout"],
["drivers/net/arcnet/com20020.c", "arcnet_timeout"],
["drivers/net/ethernet/3com/3c509.c", "el3_tx_timeout"],
["drivers/net/ethernet/3com/3c515.c", "corkscrew_timeout"],
["drivers/net/ethernet/3com/3c574_cs.c", "el3_tx_timeout"],
["drivers/net/ethernet/3com/3c589_cs.c", "el3_tx_timeout"],
["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
["drivers/net/ethernet/3com/3c59x.c", "vortex_tx_timeout"],
["drivers/net/ethernet/3com/typhoon.c", "typhoon_tx_timeout"],
["drivers/net/ethernet/8390/8390.h", "ei_tx_timeout"],
["drivers/net/ethernet/8390/8390.c", "ei_tx_timeout"],
["drivers/net/ethernet/8390/8390p.c", "eip_tx_timeout"],
["drivers/net/ethernet/8390/ax88796.c", "ax_ei_tx_timeout"],
["drivers/net/ethernet/8390/axnet_cs.c", "axnet_tx_timeout"],
["drivers/net/ethernet/8390/etherh.c", "__ei_tx_timeout"],
["drivers/net/ethernet/8390/hydra.c", "__ei_tx_timeout"],
["drivers/net/ethernet/8390/mac8390.c", "__ei_tx_timeout"],
["drivers/net/ethernet/8390/mcf8390.c", "__ei_tx_timeout"],
["drivers/net/ethernet/8390/lib8390.c", "__ei_tx_timeout"],
["drivers/net/ethernet/8390/ne2k-pci.c", "ei_tx_timeout"],
["drivers/net/ethernet/8390/pcnet_cs.c", "ei_tx_timeout"],
["drivers/net/ethernet/8390/smc-ultra.c", "ei_tx_timeout"],
["drivers/net/ethernet/8390/wd.c", "ei_tx_timeout"],
["drivers/net/ethernet/8390/zorro8390.c", "__ei_tx_timeout"],
["drivers/net/ethernet/adaptec/starfire.c", "tx_timeout"],
["drivers/net/ethernet/agere/et131x.c", "et131x_tx_timeout"],
["drivers/net/ethernet/allwinner/sun4i-emac.c", "emac_timeout"],
["drivers/net/ethernet/alteon/acenic.c", "ace_watchdog"],
["drivers/net/ethernet/amazon/ena/ena_netdev.c", "ena_tx_timeout"],
["drivers/net/ethernet/amd/7990.h", "lance_tx_timeout"],
["drivers/net/ethernet/amd/7990.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/a2065.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/am79c961a.c", "am79c961_timeout"],
["drivers/net/ethernet/amd/amd8111e.c", "amd8111e_tx_timeout"],
["drivers/net/ethernet/amd/ariadne.c", "ariadne_tx_timeout"],
["drivers/net/ethernet/amd/atarilance.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/au1000_eth.c", "au1000_tx_timeout"],
["drivers/net/ethernet/amd/declance.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/lance.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/mvme147.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/ni65.c", "ni65_timeout"],
["drivers/net/ethernet/amd/nmclan_cs.c", "mace_tx_timeout"],
["drivers/net/ethernet/amd/pcnet32.c", "pcnet32_tx_timeout"],
["drivers/net/ethernet/amd/sunlance.c", "lance_tx_timeout"],
["drivers/net/ethernet/amd/xgbe/xgbe-drv.c", "xgbe_tx_timeout"],
["drivers/net/ethernet/apm/xgene-v2/main.c", "xge_timeout"],
["drivers/net/ethernet/apm/xgene/xgene_enet_main.c", "xgene_enet_timeout"],
["drivers/net/ethernet/apple/macmace.c", "mace_tx_timeout"],
["drivers/net/ethernet/atheros/ag71xx.c", "ag71xx_tx_timeout"],
["drivers/net/ethernet/atheros/alx/main.c", "alx_tx_timeout"],
["drivers/net/ethernet/atheros/atl1c/atl1c_main.c", "atl1c_tx_timeout"],
["drivers/net/ethernet/atheros/atl1e/atl1e_main.c", "atl1e_tx_timeout"],
["drivers/net/ethernet/atheros/atlx/atl1.c", "atlx_tx_timeout"],
["drivers/net/ethernet/atheros/atlx/atl2.c", "atl2_tx_timeout"],
["drivers/net/ethernet/broadcom/b44.c", "b44_tx_timeout"],
["drivers/net/ethernet/broadcom/bcmsysport.c", "bcm_sysport_tx_timeout"],
["drivers/net/ethernet/broadcom/bnx2.c", "bnx2_tx_timeout"],
["drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h", "bnx2x_tx_timeout"],
["drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c", "bnx2x_tx_timeout"],
["drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c", "bnx2x_tx_timeout"],
["drivers/net/ethernet/broadcom/bnxt/bnxt.c", "bnxt_tx_timeout"],
["drivers/net/ethernet/broadcom/genet/bcmgenet.c", "bcmgenet_timeout"],
["drivers/net/ethernet/broadcom/sb1250-mac.c", "sbmac_tx_timeout"],
["drivers/net/ethernet/broadcom/tg3.c", "tg3_tx_timeout"],
["drivers/net/ethernet/calxeda/xgmac.c", "xgmac_tx_timeout"],
["drivers/net/ethernet/cavium/liquidio/lio_main.c", "liquidio_tx_timeout"],
["drivers/net/ethernet/cavium/liquidio/lio_vf_main.c", "liquidio_tx_timeout=
"],
["drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c", "lio_vf_rep_tx_timeou=
t"],
["drivers/net/ethernet/cavium/thunder/nicvf_main.c", "nicvf_tx_timeout"],
["drivers/net/ethernet/cirrus/cs89x0.c", "net_timeout"],
["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
["drivers/net/ethernet/cisco/enic/enic_main.c", "enic_tx_timeout"],
["drivers/net/ethernet/cortina/gemini.c", "gmac_tx_timeout"],
["drivers/net/ethernet/davicom/dm9000.c", "dm9000_timeout"],
["drivers/net/ethernet/dec/tulip/de2104x.c", "de_tx_timeout"],
["drivers/net/ethernet/dec/tulip/tulip_core.c", "tulip_tx_timeout"],
["drivers/net/ethernet/dec/tulip/winbond-840.c", "tx_timeout"],
["drivers/net/ethernet/dlink/dl2k.c", "rio_tx_timeout"],
["drivers/net/ethernet/dlink/sundance.c", "tx_timeout"],
["drivers/net/ethernet/emulex/benet/be_main.c", "be_tx_timeout"],
["drivers/net/ethernet/ethoc.c", "ethoc_tx_timeout"],
["drivers/net/ethernet/faraday/ftgmac100.c", "ftgmac100_tx_timeout"],
["drivers/net/ethernet/fealnx.c", "fealnx_tx_timeout"],
["drivers/net/ethernet/freescale/dpaa/dpaa_eth.c", "dpaa_tx_timeout"],
["drivers/net/ethernet/freescale/fec_main.c", "fec_timeout"],
["drivers/net/ethernet/freescale/fec_mpc52xx.c", "mpc52xx_fec_tx_timeout"],
["drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c", "fs_timeout"],
["drivers/net/ethernet/freescale/gianfar.c", "gfar_timeout"],
["drivers/net/ethernet/freescale/ucc_geth.c", "ucc_geth_timeout"],
["drivers/net/ethernet/fujitsu/fmvj18x_cs.c", "fjn_tx_timeout"],
["drivers/net/ethernet/google/gve/gve_main.c", "gve_tx_timeout"],
["drivers/net/ethernet/hisilicon/hip04_eth.c", "hip04_timeout"],
["drivers/net/ethernet/hisilicon/hix5hd2_gmac.c", "hix5hd2_net_timeout"],
["drivers/net/ethernet/hisilicon/hns/hns_enet.c", "hns_nic_net_timeout"],
["drivers/net/ethernet/hisilicon/hns3/hns3_enet.c", "hns3_nic_net_timeout"]=
,
["drivers/net/ethernet/huawei/hinic/hinic_main.c", "hinic_tx_timeout"],
["drivers/net/ethernet/i825xx/82596.c", "i596_tx_timeout"],
["drivers/net/ethernet/i825xx/ether1.c", "ether1_timeout"],
["drivers/net/ethernet/i825xx/lib82596.c", "i596_tx_timeout"],
["drivers/net/ethernet/i825xx/sun3_82586.c", "sun3_82586_timeout"],
["drivers/net/ethernet/ibm/ehea/ehea_main.c", "ehea_tx_watchdog"],
["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
["drivers/net/ethernet/ibm/emac/core.c", "emac_tx_timeout"],
["drivers/net/ethernet/ibm/ibmvnic.c", "ibmvnic_tx_timeout"],
["drivers/net/ethernet/intel/e100.c", "e100_tx_timeout"],
["drivers/net/ethernet/intel/e1000/e1000_main.c", "e1000_tx_timeout"],
["drivers/net/ethernet/intel/e1000e/netdev.c", "e1000_tx_timeout"],
["drivers/net/ethernet/intel/fm10k/fm10k_netdev.c", "fm10k_tx_timeout"],
["drivers/net/ethernet/intel/i40e/i40e_main.c", "i40e_tx_timeout"],
["drivers/net/ethernet/intel/iavf/iavf_main.c", "iavf_tx_timeout"],
["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
["drivers/net/ethernet/intel/ice/ice_main.c", "ice_tx_timeout"],
["drivers/net/ethernet/intel/igb/igb_main.c", "igb_tx_timeout"],
["drivers/net/ethernet/intel/igbvf/netdev.c", "igbvf_tx_timeout"],
["drivers/net/ethernet/intel/ixgb/ixgb_main.c", "ixgb_tx_timeout"],
["drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c", "adapter->netdev->netd=
ev_ops->ndo_tx_timeout(adapter->netdev);"],
["drivers/net/ethernet/intel/ixgbe/ixgbe_main.c", "ixgbe_tx_timeout"],
["drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c", "ixgbevf_tx_timeout"]=
,
["drivers/net/ethernet/jme.c", "jme_tx_timeout"],
["drivers/net/ethernet/korina.c", "korina_tx_timeout"],
["drivers/net/ethernet/lantiq_etop.c", "ltq_etop_tx_timeout"],
["drivers/net/ethernet/marvell/mv643xx_eth.c", "mv643xx_eth_tx_timeout"],
["drivers/net/ethernet/marvell/pxa168_eth.c", "pxa168_eth_tx_timeout"],
["drivers/net/ethernet/marvell/skge.c", "skge_tx_timeout"],
["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
["drivers/net/ethernet/marvell/sky2.c", "sky2_tx_timeout"],
["drivers/net/ethernet/mediatek/mtk_eth_soc.c", "mtk_tx_timeout"],
["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
["drivers/net/ethernet/mellanox/mlx4/en_netdev.c", "mlx4_en_tx_timeout"],
["drivers/net/ethernet/mellanox/mlx5/core/en_main.c", "mlx5e_tx_timeout"],
["drivers/net/ethernet/micrel/ks8842.c", "ks8842_tx_timeout"],
["drivers/net/ethernet/micrel/ksz884x.c", "netdev_tx_timeout"],
["drivers/net/ethernet/microchip/enc28j60.c", "enc28j60_tx_timeout"],
["drivers/net/ethernet/microchip/encx24j600.c", "encx24j600_tx_timeout"],
["drivers/net/ethernet/natsemi/sonic.h", "sonic_tx_timeout"],
["drivers/net/ethernet/natsemi/sonic.c", "sonic_tx_timeout"],
["drivers/net/ethernet/natsemi/jazzsonic.c", "sonic_tx_timeout"],
["drivers/net/ethernet/natsemi/macsonic.c", "sonic_tx_timeout"],
["drivers/net/ethernet/natsemi/natsemi.c", "ns_tx_timeout"],
["drivers/net/ethernet/natsemi/ns83820.c", "ns83820_tx_timeout"],
["drivers/net/ethernet/natsemi/xtsonic.c", "sonic_tx_timeout"],
["drivers/net/ethernet/neterion/s2io.h", "s2io_tx_watchdog"],
["drivers/net/ethernet/neterion/s2io.c", "s2io_tx_watchdog"],
["drivers/net/ethernet/neterion/vxge/vxge-main.c", "vxge_tx_watchdog"],
["drivers/net/ethernet/netronome/nfp/nfp_net_common.c", "nfp_net_tx_timeout=
"],
["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
["drivers/net/ethernet/nvidia/forcedeth.c", "nv_tx_timeout"],
["drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c", "pch_gbe_tx_timeou=
t"],
["drivers/net/ethernet/packetengines/hamachi.c", "hamachi_tx_timeout"],
["drivers/net/ethernet/packetengines/yellowfin.c", "yellowfin_tx_timeout"],
["drivers/net/ethernet/pensando/ionic/ionic_lif.c", "ionic_tx_timeout"],
["drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c", "netxen_tx_timeout=
"],
["drivers/net/ethernet/qlogic/qla3xxx.c", "ql3xxx_tx_timeout"],
["drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c", "qlcnic_tx_timeout"],
["drivers/net/ethernet/qualcomm/emac/emac.c", "emac_tx_timeout"],
["drivers/net/ethernet/qualcomm/qca_spi.c", "qcaspi_netdev_tx_timeout"],
["drivers/net/ethernet/qualcomm/qca_uart.c", "qcauart_netdev_tx_timeout"],
["drivers/net/ethernet/rdc/r6040.c", "r6040_tx_timeout"],
["drivers/net/ethernet/realtek/8139cp.c", "cp_tx_timeout"],
["drivers/net/ethernet/realtek/8139too.c", "rtl8139_tx_timeout"],
["drivers/net/ethernet/realtek/atp.c", "tx_timeout"],
["drivers/net/ethernet/realtek/r8169_main.c", "rtl8169_tx_timeout"],
["drivers/net/ethernet/renesas/ravb_main.c", "ravb_tx_timeout"],
["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
["drivers/net/ethernet/renesas/sh_eth.c", "sh_eth_tx_timeout"],
["drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c", "sxgbe_tx_timeout"],
["drivers/net/ethernet/seeq/ether3.c", "ether3_timeout"],
["drivers/net/ethernet/seeq/sgiseeq.c", "timeout"],
["drivers/net/ethernet/sfc/efx.c", "efx_watchdog"],
["drivers/net/ethernet/sfc/falcon/efx.c", "ef4_watchdog"],
["drivers/net/ethernet/sgi/ioc3-eth.c", "ioc3_timeout"],
["drivers/net/ethernet/sgi/meth.c", "meth_tx_timeout"],
["drivers/net/ethernet/silan/sc92031.c", "sc92031_tx_timeout"],
["drivers/net/ethernet/sis/sis190.c", "sis190_tx_timeout"],
["drivers/net/ethernet/sis/sis900.c", "sis900_tx_timeout"],
["drivers/net/ethernet/smsc/epic100.c", "epic_tx_timeout"],
["drivers/net/ethernet/smsc/smc911x.c", "smc911x_timeout"],
["drivers/net/ethernet/smsc/smc9194.c", "smc_timeout"],
["drivers/net/ethernet/smsc/smc91c92_cs.c", "smc_tx_timeout"],
["drivers/net/ethernet/smsc/smc91x.c", "smc_timeout"],
["drivers/net/ethernet/stmicro/stmmac/stmmac_main.c", "stmmac_tx_timeout"],
["drivers/net/ethernet/sun/cassini.c", "cas_tx_timeout"],
["drivers/net/ethernet/sun/ldmvsw.c", "sunvnet_tx_timeout_common"],
["drivers/net/ethernet/sun/niu.c", "niu_tx_timeout"],
["drivers/net/ethernet/sun/sunbmac.c", "bigmac_tx_timeout"],
["drivers/net/ethernet/sun/sungem.c", "gem_tx_timeout"],
["drivers/net/ethernet/sun/sunhme.c", "happy_meal_tx_timeout"],
["drivers/net/ethernet/sun/sunqe.c", "qe_tx_timeout"],
["drivers/net/ethernet/sun/sunvnet.c", "sunvnet_tx_timeout_common"],
["drivers/net/ethernet/sun/sunvnet_common.c", "sunvnet_tx_timeout_common"],
["drivers/net/ethernet/sun/sunvnet_common.h", "sunvnet_tx_timeout_common"],
["drivers/net/ethernet/synopsys/dwc-xlgmac-net.c", "xlgmac_tx_timeout"],
["drivers/net/ethernet/ti/cpmac.c", "cpmac_tx_timeout"],
["drivers/net/ethernet/ti/cpsw.c", "cpsw_ndo_tx_timeout"],
["drivers/net/ethernet/ti/davinci_emac.c", "emac_dev_tx_timeout"],
["drivers/net/ethernet/ti/netcp_core.c", "netcp_ndo_tx_timeout"],
["drivers/net/ethernet/ti/tlan.c", "tlan_tx_timeout"],
["drivers/net/ethernet/toshiba/ps3_gelic_net.h", "gelic_net_tx_timeout"],
["drivers/net/ethernet/toshiba/ps3_gelic_net.c", "gelic_net_tx_timeout"],
["drivers/net/ethernet/toshiba/ps3_gelic_wireless.c", "gelic_net_tx_timeout=
"],
["drivers/net/ethernet/toshiba/spider_net.c", "spider_net_tx_timeout"],
["drivers/net/ethernet/toshiba/tc35815.c", "tc35815_tx_timeout"],
["drivers/net/ethernet/via/via-rhine.c", "rhine_tx_timeout"],
["drivers/net/ethernet/wiznet/w5100.c", "w5100_tx_timeout"],
["drivers/net/ethernet/wiznet/w5300.c", "w5300_tx_timeout"],
["drivers/net/ethernet/xilinx/xilinx_emaclite.c", "xemaclite_tx_timeout"],
["drivers/net/ethernet/xircom/xirc2ps_cs.c", "xirc_tx_timeout"],
["drivers/net/fjes/fjes_main.c", "fjes_tx_retry"],
["drivers/net/slip/slip.c", "sl_tx_timeout"],
["include/linux/usb/usbnet.h", "usbnet_tx_timeout"],
["drivers/net/usb/aqc111.c", "usbnet_tx_timeout"],
["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
["drivers/net/usb/asix_devices.c", "usbnet_tx_timeout"],
["drivers/net/usb/ax88172a.c", "usbnet_tx_timeout"],
["drivers/net/usb/ax88179_178a.c", "usbnet_tx_timeout"],
["drivers/net/usb/catc.c", "catc_tx_timeout"],
["drivers/net/usb/cdc_mbim.c", "usbnet_tx_timeout"],
["drivers/net/usb/cdc_ncm.c", "usbnet_tx_timeout"],
["drivers/net/usb/dm9601.c", "usbnet_tx_timeout"],
["drivers/net/usb/hso.c", "hso_net_tx_timeout"],
["drivers/net/usb/int51x1.c", "usbnet_tx_timeout"],
["drivers/net/usb/ipheth.c", "ipheth_tx_timeout"],
["drivers/net/usb/kaweth.c", "kaweth_tx_timeout"],
["drivers/net/usb/lan78xx.c", "lan78xx_tx_timeout"],
["drivers/net/usb/mcs7830.c", "usbnet_tx_timeout"],
["drivers/net/usb/pegasus.c", "pegasus_tx_timeout"],
["drivers/net/usb/qmi_wwan.c", "usbnet_tx_timeout"],
["drivers/net/usb/r8152.c", "rtl8152_tx_timeout"],
["drivers/net/usb/rndis_host.c", "usbnet_tx_timeout"],
["drivers/net/usb/rtl8150.c", "rtl8150_tx_timeout"],
["drivers/net/usb/sierra_net.c", "usbnet_tx_timeout"],
["drivers/net/usb/smsc75xx.c", "usbnet_tx_timeout"],
["drivers/net/usb/smsc95xx.c", "usbnet_tx_timeout"],
["drivers/net/usb/sr9700.c", "usbnet_tx_timeout"],
["drivers/net/usb/sr9800.c", "usbnet_tx_timeout"],
["drivers/net/usb/usbnet.c", "usbnet_tx_timeout"],
["drivers/net/vmxnet3/vmxnet3_drv.c", "vmxnet3_tx_timeout"],
["drivers/net/wan/cosa.c", "cosa_net_timeout"],
["drivers/net/wan/farsync.c", "fst_tx_timeout"],
["drivers/net/wan/fsl_ucc_hdlc.c", "uhdlc_tx_timeout"],
["drivers/net/wan/lmc/lmc_main.c", "lmc_driver_timeout"],
["drivers/net/wan/x25_asy.c", "x25_asy_timeout"],
["drivers/net/wimax/i2400m/netdev.c", "i2400m_tx_timeout"],
["drivers/net/wireless/intel/ipw2x00/ipw2100.c", "ipw2100_tx_timeout"],
["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"]=
,
["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"]=
,
["drivers/net/wireless/intersil/hostap/hostap_main.c", "prism2_tx_timeout"]=
,
["drivers/net/wireless/intersil/orinoco/main.c", "orinoco_tx_timeout"],
["drivers/net/wireless/intersil/orinoco/orinoco_usb.c", "orinoco_tx_timeout=
"],
["drivers/net/wireless/intersil/orinoco/orinoco.h", "orinoco_tx_timeout"],
["drivers/net/wireless/intersil/prism54/islpci_dev.c", "islpci_eth_tx_timeo=
ut"],
["drivers/net/wireless/intersil/prism54/islpci_eth.c", "islpci_eth_tx_timeo=
ut"],
["drivers/net/wireless/intersil/prism54/islpci_eth.h", "islpci_eth_tx_timeo=
ut"],
["drivers/net/wireless/marvell/mwifiex/main.c", "mwifiex_tx_timeout"],
["drivers/net/wireless/quantenna/qtnfmac/core.c", "qtnf_netdev_tx_timeout"]=
,
["drivers/net/wireless/quantenna/qtnfmac/core.h", "qtnf_netdev_tx_timeout"]=
,
["drivers/net/wireless/rndis_wlan.c", "usbnet_tx_timeout"],
["drivers/net/wireless/wl3501_cs.c", "wl3501_tx_timeout"],
["drivers/net/wireless/zydas/zd1201.c", "zd1201_tx_timeout"],
["drivers/s390/net/qeth_core.h", "qeth_tx_timeout"],
["drivers/s390/net/qeth_core_main.c", "qeth_tx_timeout"],
["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
["drivers/s390/net/qeth_l2_main.c", "qeth_tx_timeout"],
["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
["drivers/s390/net/qeth_l3_main.c", "qeth_tx_timeout"],
["drivers/staging/ks7010/ks_wlan_net.c", "ks_wlan_tx_timeout"],
["drivers/staging/qlge/qlge_main.c", "qlge_tx_timeout"],
["drivers/staging/rtl8192e/rtl8192e/rtl_core.c", "_rtl92e_tx_timeout"],
["drivers/staging/rtl8192u/r8192U_core.c", "tx_timeout"],
["drivers/staging/unisys/visornic/visornic_main.c", "visornic_xmit_timeout"=
],
["drivers/staging/wlan-ng/p80211netdev.c", "p80211knetdev_tx_timeout"],
["drivers/tty/n_gsm.c", "gsm_mux_net_tx_timeout"],
["drivers/tty/synclink.c", "hdlcdev_tx_timeout"],
["drivers/tty/synclink_gt.c", "hdlcdev_tx_timeout"],
["drivers/tty/synclinkmp.c", "hdlcdev_tx_timeout"],
["net/atm/lec.c", "lec_tx_timeout"],
["net/bluetooth/bnep/netdev.c", "bnep_net_timeout"]
);

for my $p (@work) {
        my @pair =3D @$p;
        my $file =3D $pair[0];
        my $func =3D $pair[1];
        print STDERR $file , ": ", $func,"\n";
        our @ARGV =3D ($file);
        while (<ARGV>) {
                if (m/($func\s*\(struct\s+net_device\s+\*[A-Za-z_]?[A-Za-z-=
0-9]*)(\))/) {
                        print STDERR "found $1+$2 in $file\n";
                }
                if (s/($func\s*\(struct\s+net_device\s+\*[A-Za-z_]?[A-Za-z-=
0-9]*)(\))/$1, int txqueue$2/) {
                        print STDERR "$func found in $file\n";
                }
                print;
        }
}

where the list of files and functions is simply from:

git grep ndo_tx_timeout, with manual addition of headers
in the rare cases where the function is from a header.

I then manually changed the few places which actually
call ndo_tx_timeout.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

changes from v4:
        add a missing driver header
changes from v3:
        change queue # to unsigned
Changes from v2:
        added headers
Changes from v1:
        Fix errors found by kbuild:
        generalize the pattern a bit, to pick up
        a couple of instances missed by the previous
        version.

diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index a4ebd2445eda..d2875e32abfc 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -167,7 +167,7 @@ static int nfeth_xmit(struct sk_buff *skb, struct net_d=
evice *dev)
 =09return 0;
 }
=20
-static void nfeth_tx_timeout(struct net_device *dev)
+static void nfeth_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09dev->stats.tx_errors++;
 =09netif_wake_queue(dev);
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 327b728f7244..35ebeebfc1a8 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -247,7 +247,7 @@ static void uml_net_set_multicast_list(struct net_devic=
e *dev)
 =09return;
 }
=20
-static void uml_net_tx_timeout(struct net_device *dev)
+static void uml_net_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09netif_trans_update(dev);
 =09netif_wake_queue(dev);
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 769ffbd9e9a6..ae930f0bfd51 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1298,7 +1298,7 @@ static void vector_net_set_multicast_list(struct net_=
device *dev)
 =09return;
 }
=20
-static void vector_net_tx_timeout(struct net_device *dev)
+static void vector_net_tx_timeout(struct net_device *dev, unsigned int txq=
ueue)
 {
 =09struct vector_private *vp =3D netdev_priv(dev);
=20
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/is=
s/network.c
index fa9f3893b002..4986226a5ab2 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -455,7 +455,7 @@ static void iss_net_set_multicast_list(struct net_devic=
e *dev)
 {
 }
=20
-static void iss_net_tx_timeout(struct net_device *dev)
+static void iss_net_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 }
=20
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/syncli=
nk_cs.c
index 82f9a6a814ae..e342daa73d1b 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -4169,7 +4169,7 @@ static int hdlcdev_ioctl(struct net_device *dev, stru=
ct ifreq *ifr, int cmd)
  *
  * dev  pointer to network device structure
  */
-static void hdlcdev_tx_timeout(struct net_device *dev)
+static void hdlcdev_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09MGSLPC_INFO *info =3D dev_to_port(dev);
 =09unsigned long flags;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband=
/ulp/ipoib/ipoib_main.c
index ac0583ff280d..b86dbdc37b83 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1182,7 +1182,7 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *s=
kb, struct net_device *dev)
 =09return NETDEV_TX_OK;
 }
=20
-static void ipoib_timeout(struct net_device *dev)
+static void ipoib_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ipoib_dev_priv *priv =3D ipoib_priv(dev);
=20
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptla=
n.c
index ebc00d47abf5..7d3784aa20e5 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -552,7 +552,7 @@ mpt_lan_close(struct net_device *dev)
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/
 /* Tx timeout handler. */
 static void
-mpt_lan_tx_timeout(struct net_device *dev)
+mpt_lan_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct mpt_lan_priv *priv =3D netdev_priv(dev);
 =09MPT_ADAPTER *mpt_dev =3D priv->mpt_dev;
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index f7d610a22347..ada94e6a3c91 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -496,7 +496,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct n=
et_device *dev)
  * Deal with transmit timeouts coming from the network layer.
  */
 static void
-xpnet_dev_tx_timeout(struct net_device *dev)
+xpnet_dev_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09dev->stats.tx_errors++;
 }
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index b3c63d2f16aa..18428e104445 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -189,7 +189,7 @@ static int  cops_nodeid (struct net_device *dev, int no=
deid);
=20
 static irqreturn_t cops_interrupt (int irq, void *dev_id);
 static void cops_poll(struct timer_list *t);
-static void cops_timeout(struct net_device *dev);
+static void cops_timeout(struct net_device *dev, unsigned int txqueue);
 static void cops_rx (struct net_device *dev);
 static netdev_tx_t  cops_send_packet (struct sk_buff *skb,
 =09=09=09=09=09    struct net_device *dev);
@@ -844,7 +844,7 @@ static void cops_rx(struct net_device *dev)
         netif_rx(skb);
 }
=20
-static void cops_timeout(struct net_device *dev)
+static void cops_timeout(struct net_device *dev, unsigned int txqueue)
 {
         struct cops_local *lp =3D netdev_priv(dev);
         int ioaddr =3D dev->base_addr;
diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.=
h
index b0f5bc07aef5..22a49c6d7ae6 100644
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -356,7 +356,7 @@ int arcnet_open(struct net_device *dev);
 int arcnet_close(struct net_device *dev);
 netdev_tx_t arcnet_send_packet(struct sk_buff *skb,
 =09=09=09       struct net_device *dev);
-void arcnet_timeout(struct net_device *dev);
+void arcnet_timeout(struct net_device *dev, unsigned int txqueue);
=20
 /* I/O equivalents */
=20
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 553776cc1d29..e04efc0a5c97 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -763,7 +763,7 @@ static int go_tx(struct net_device *dev)
 }
=20
 /* Called by the kernel when transmit times out */
-void arcnet_timeout(struct net_device *dev)
+void arcnet_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09unsigned long flags;
 =09struct arcnet_local *lp =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/=
3c509.c
index 3da97996bdf3..8cafd06ff0c4 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -196,7 +196,7 @@ static struct net_device_stats *el3_get_stats(struct ne=
t_device *dev);
 static int el3_rx(struct net_device *dev);
 static int el3_close(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
-static void el3_tx_timeout (struct net_device *dev);
+static void el3_tx_timeout (struct net_device *dev, unsigned int txqueue);
 static void el3_down(struct net_device *dev);
 static void el3_up(struct net_device *dev);
 static const struct ethtool_ops ethtool_ops;
@@ -689,7 +689,7 @@ el3_open(struct net_device *dev)
 }
=20
 static void
-el3_tx_timeout (struct net_device *dev)
+el3_tx_timeout (struct net_device *dev, unsigned int txqueue)
 {
 =09int ioaddr =3D dev->base_addr;
=20
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/=
3c515.c
index b15752267c8d..1e233e2f0a5a 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -371,7 +371,7 @@ static void corkscrew_timer(struct timer_list *t);
 static netdev_tx_t corkscrew_start_xmit(struct sk_buff *skb,
 =09=09=09=09=09struct net_device *dev);
 static int corkscrew_rx(struct net_device *dev);
-static void corkscrew_timeout(struct net_device *dev);
+static void corkscrew_timeout(struct net_device *dev, unsigned int txqueue=
);
 static int boomerang_rx(struct net_device *dev);
 static irqreturn_t corkscrew_interrupt(int irq, void *dev_id);
 static int corkscrew_close(struct net_device *dev);
@@ -961,7 +961,7 @@ static void corkscrew_timer(struct timer_list *t)
 #endif=09=09=09=09/* AUTOMEDIA */
 }
=20
-static void corkscrew_timeout(struct net_device *dev)
+static void corkscrew_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09int i;
 =09struct corkscrew_private *vp =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3c=
om/3c574_cs.c
index 3044a6f35f04..ef1c3151fbb2 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -234,7 +234,7 @@ static void update_stats(struct net_device *dev);
 static struct net_device_stats *el3_get_stats(struct net_device *dev);
 static int el3_rx(struct net_device *dev, int worklimit);
 static int el3_close(struct net_device *dev);
-static void el3_tx_timeout(struct net_device *dev);
+static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static int el3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void set_rx_mode(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
@@ -690,7 +690,7 @@ static int el3_open(struct net_device *dev)
 =09return 0;
 }
=20
-static void el3_tx_timeout(struct net_device *dev)
+static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09unsigned int ioaddr =3D dev->base_addr;
 =09
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3c=
om/3c589_cs.c
index 2b2695311bda..d47cde6c5f08 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -173,7 +173,7 @@ static void update_stats(struct net_device *dev);
 static struct net_device_stats *el3_get_stats(struct net_device *dev);
 static int el3_rx(struct net_device *dev);
 static int el3_close(struct net_device *dev);
-static void el3_tx_timeout(struct net_device *dev);
+static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void set_rx_mode(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
 static const struct ethtool_ops netdev_ethtool_ops;
@@ -526,7 +526,7 @@ static int el3_open(struct net_device *dev)
 =09return 0;
 }
=20
-static void el3_tx_timeout(struct net_device *dev)
+static void el3_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09unsigned int ioaddr =3D dev->base_addr;
=20
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/=
3c59x.c
index 8785c2ff3825..fc046797c0ea 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -776,7 +776,7 @@ static void set_rx_mode(struct net_device *dev);
 #ifdef CONFIG_PCI
 static int vortex_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)=
;
 #endif
-static void vortex_tx_timeout(struct net_device *dev);
+static void vortex_tx_timeout(struct net_device *dev, unsigned int txqueue=
);
 static void acpi_set_WOL(struct net_device *dev);
 static const struct ethtool_ops vortex_ethtool_ops;
 static void set_8021q_mode(struct net_device *dev, int enable);
@@ -1877,7 +1877,7 @@ vortex_timer(struct timer_list *t)
 =09=09iowrite16(FakeIntr, ioaddr + EL3_CMD);
 }
=20
-static void vortex_tx_timeout(struct net_device *dev)
+static void vortex_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct vortex_private *vp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D vp->ioaddr;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3co=
m/typhoon.c
index be823c186517..14fce6658106 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2013,7 +2013,7 @@ typhoon_stop_runtime(struct typhoon *tp, int wait_typ=
e)
 }
=20
 static void
-typhoon_tx_timeout(struct net_device *dev)
+typhoon_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct typhoon *tp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/8=
390.c
index 78f3e532c600..0e0aa4016858 100644
--- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -36,9 +36,9 @@ void ei_set_multicast_list(struct net_device *dev)
 }
 EXPORT_SYMBOL(ei_set_multicast_list);
=20
-void ei_tx_timeout(struct net_device *dev)
+void ei_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
-=09__ei_tx_timeout(dev);
+=09__ei_tx_timeout(dev, txqueue);
 }
 EXPORT_SYMBOL(ei_tx_timeout);
=20
diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8=
390.h
index 3e2f2c2e7b58..6d55015fa361 100644
--- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -32,7 +32,7 @@ void NS8390_init(struct net_device *dev, int startp);
 int ei_open(struct net_device *dev);
 int ei_close(struct net_device *dev);
 irqreturn_t ei_interrupt(int irq, void *dev_id);
-void ei_tx_timeout(struct net_device *dev);
+void ei_tx_timeout(struct net_device *dev, unsigned int txqueue);
 netdev_tx_t ei_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void ei_set_multicast_list(struct net_device *dev);
 struct net_device_stats *ei_get_stats(struct net_device *dev);
diff --git a/drivers/net/ethernet/8390/8390p.c b/drivers/net/ethernet/8390/=
8390p.c
index 6cf36992a2c6..6834742057b3 100644
--- a/drivers/net/ethernet/8390/8390p.c
+++ b/drivers/net/ethernet/8390/8390p.c
@@ -41,9 +41,9 @@ void eip_set_multicast_list(struct net_device *dev)
 }
 EXPORT_SYMBOL(eip_set_multicast_list);
=20
-void eip_tx_timeout(struct net_device *dev)
+void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
-=09__ei_tx_timeout(dev);
+=09__ei_tx_timeout(dev, txqueue);
 }
 EXPORT_SYMBOL(eip_tx_timeout);
=20
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/83=
90/axnet_cs.c
index 0b6bbf63f7ca..aeae7966a082 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -83,7 +83,7 @@ static netdev_tx_t axnet_start_xmit(struct sk_buff *skb,
 =09=09=09=09=09  struct net_device *dev);
 static struct net_device_stats *get_stats(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
-static void axnet_tx_timeout(struct net_device *dev);
+static void axnet_tx_timeout(struct net_device *dev, unsigned int txqueue)=
;
 static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
 static void ei_watchdog(struct timer_list *t);
 static void axnet_reset_8390(struct net_device *dev);
@@ -903,7 +903,7 @@ static int ax_close(struct net_device *dev)
  * completed (or failed) - i.e. never posted a Tx related interrupt.
  */
=20
-static void axnet_tx_timeout(struct net_device *dev)
+static void axnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09long e8390_base =3D dev->base_addr;
 =09struct ei_device *ei_local =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/839=
0/lib8390.c
index c9c55c9eab9f..babc92e2692e 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -251,7 +251,7 @@ static int __ei_close(struct net_device *dev)
  * completed (or failed) - i.e. never posted a Tx related interrupt.
  */
=20
-static void __ei_tx_timeout(struct net_device *dev)
+static void __ei_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09unsigned long e8390_base =3D dev->base_addr;
 =09struct ei_device *ei_local =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet=
/adaptec/starfire.c
index 816540e6beac..165d18405b0c 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -576,7 +576,7 @@ static int=09mdio_read(struct net_device *dev, int phy_=
id, int location);
 static void=09mdio_write(struct net_device *dev, int phy_id, int location,=
 int value);
 static int=09netdev_open(struct net_device *dev);
 static void=09check_duplex(struct net_device *dev);
-static void=09tx_timeout(struct net_device *dev);
+static void=09tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void=09init_ring(struct net_device *dev);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
 static irqreturn_t intr_handler(int irq, void *dev_instance);
@@ -1105,7 +1105,7 @@ static void check_duplex(struct net_device *dev)
 }
=20
=20
-static void tx_timeout(struct net_device *dev)
+static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D np->base;
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/age=
re/et131x.c
index 174344c450af..3c51d8c502ed 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3811,7 +3811,7 @@ static netdev_tx_t et131x_tx(struct sk_buff *skb, str=
uct net_device *netdev)
  * specified by the 'tx_timeo" element in the net_device structure (see
  * et131x_alloc_device() to see how this value is set).
  */
-static void et131x_tx_timeout(struct net_device *netdev)
+static void et131x_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue)
 {
 =09struct et131x_adapter *adapter =3D netdev_priv(netdev);
 =09struct tx_ring *tx_ring =3D &adapter->tx_ring;
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethe=
rnet/allwinner/sun4i-emac.c
index 0537df06a9b5..5ea806423e4c 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -407,7 +407,7 @@ static void emac_init_device(struct net_device *dev)
 }
=20
 /* Our watchdog timed out. Called by the networking layer */
-static void emac_timeout(struct net_device *dev)
+static void emac_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct emac_board_info *db =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/al=
teon/acenic.c
index 46b4207d3266..f366faf88eee 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -437,7 +437,7 @@ static const struct ethtool_ops ace_ethtool_ops =3D {
 =09.set_link_ksettings =3D ace_set_link_ksettings,
 };
=20
-static void ace_watchdog(struct net_device *dev);
+static void ace_watchdog(struct net_device *dev, unsigned int txqueue);
=20
 static const struct net_device_ops ace_netdev_ops =3D {
 =09.ndo_open=09=09=3D ace_open,
@@ -1542,7 +1542,7 @@ static void ace_set_rxtx_parms(struct net_device *dev=
, int jumbo)
 }
=20
=20
-static void ace_watchdog(struct net_device *data)
+static void ace_watchdog(struct net_device *data, unsigned int txqueue)
 {
 =09struct net_device *dev =3D data;
 =09struct ace_private *ap =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/eth=
ernet/amazon/ena/ena_netdev.c
index c487d2a7d6dd..61a6543f962a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -78,7 +78,7 @@ static void check_for_admin_com_state(struct ena_adapter =
*adapter);
 static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)=
;
 static int ena_restore_device(struct ena_adapter *adapter);
=20
-static void ena_tx_timeout(struct net_device *dev)
+static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ena_adapter *adapter =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/amd/7990.c b/drivers/net/ethernet/amd/799=
0.c
index ab30761003da..cf3562e82ca9 100644
--- a/drivers/net/ethernet/amd/7990.c
+++ b/drivers/net/ethernet/amd/7990.c
@@ -527,7 +527,7 @@ int lance_close(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(lance_close);
=20
-void lance_tx_timeout(struct net_device *dev)
+void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09printk("lance_tx_timeout\n");
 =09lance_reset(dev);
diff --git a/drivers/net/ethernet/amd/7990.h b/drivers/net/ethernet/amd/799=
0.h
index 741cdc392c6b..8266b3c1fefc 100644
--- a/drivers/net/ethernet/amd/7990.h
+++ b/drivers/net/ethernet/amd/7990.h
@@ -243,7 +243,7 @@ int lance_open(struct net_device *dev);
 int lance_close(struct net_device *dev);
 int lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void lance_set_multicast(struct net_device *dev);
-void lance_tx_timeout(struct net_device *dev);
+void lance_tx_timeout(struct net_device *dev, unsigned int txqueue);
 #ifdef CONFIG_NET_POLL_CONTROLLER
 void lance_poll(struct net_device *dev);
 #endif
diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2=
065.c
index 212fe72a190b..a3faf4feb204 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -522,7 +522,7 @@ static inline int lance_reset(struct net_device *dev)
 =09return status;
 }
=20
-static void lance_tx_timeout(struct net_device *dev)
+static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct lance_private *lp =3D netdev_priv(dev);
 =09volatile struct lance_regs *ll =3D lp->ll;
diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/am=
d/am79c961a.c
index 0842da492a64..1c53408f5d47 100644
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ b/drivers/net/ethernet/amd/am79c961a.c
@@ -422,7 +422,7 @@ static void am79c961_setmulticastlist (struct net_devic=
e *dev)
 =09spin_unlock_irqrestore(&priv->chip_lock, flags);
 }
=20
-static void am79c961_timeout(struct net_device *dev)
+static void am79c961_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09printk(KERN_WARNING "%s: transmit timed out, network cable problem?\n",
 =09=09dev->name);
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd=
/amd8111e.c
index 573e88fc8ede..0f3b743425e8 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1569,7 +1569,7 @@ static int amd8111e_enable_link_change(struct amd8111=
e_priv *lp)
  * failed or the interface is locked up. This function will reinitialize
  * the hardware.
  */
-static void amd8111e_tx_timeout(struct net_device *dev)
+static void amd8111e_tx_timeout(struct net_device *dev, unsigned int txque=
ue)
 {
 =09struct amd8111e_priv *lp =3D netdev_priv(dev);
 =09int err;
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/=
ariadne.c
index 4b6a5cb85dd2..5e0f645f5bde 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -530,7 +530,7 @@ static inline void ariadne_reset(struct net_device *dev=
)
 =09netif_start_queue(dev);
 }
=20
-static void ariadne_tx_timeout(struct net_device *dev)
+static void ariadne_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09volatile struct Am79C960 *lance =3D (struct Am79C960 *)dev->base_addr;
=20
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/a=
md/atarilance.c
index d3d44e07afbc..4e36122609a3 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -346,7 +346,7 @@ static int lance_rx( struct net_device *dev );
 static int lance_close( struct net_device *dev );
 static void set_multicast_list( struct net_device *dev );
 static int lance_set_mac_address( struct net_device *dev, void *addr );
-static void lance_tx_timeout (struct net_device *dev);
+static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue=
);
=20
 /************************* End of Prototypes **************************/
=20
@@ -727,7 +727,7 @@ static void lance_init_ring( struct net_device *dev )
 /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
=20
=20
-static void lance_tx_timeout (struct net_device *dev)
+static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct lance_private *lp =3D netdev_priv(dev);
 =09struct lance_ioreg=09 *IO =3D lp->iobase;
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/a=
md/au1000_eth.c
index 1793950f0582..d832c9f4d306 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1014,7 +1014,7 @@ static netdev_tx_t au1000_tx(struct sk_buff *skb, str=
uct net_device *dev)
  * The Tx ring has been full longer than the watchdog timeout
  * value. The transmitter must be hung?
  */
-static void au1000_tx_timeout(struct net_device *dev)
+static void au1000_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09netdev_err(dev, "au1000_tx_timeout: dev=3D%p\n", dev);
 =09au1000_reset_mac(dev);
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd=
/declance.c
index dac4a2fcad6a..6592a2db9efb 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -884,7 +884,7 @@ static inline int lance_reset(struct net_device *dev)
 =09return status;
 }
=20
-static void lance_tx_timeout(struct net_device *dev)
+static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct lance_private *lp =3D netdev_priv(dev);
 =09volatile struct lance_regs *ll =3D lp->ll;
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/la=
nce.c
index f90b454b1642..aff44241988c 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -306,7 +306,7 @@ static irqreturn_t lance_interrupt(int irq, void *dev_i=
d);
 static int lance_close(struct net_device *dev);
 static struct net_device_stats *lance_get_stats(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
-static void lance_tx_timeout (struct net_device *dev);
+static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue=
);
=20
=20
=20
@@ -913,7 +913,7 @@ lance_restart(struct net_device *dev, unsigned int csr0=
_bits, int must_reinit)
 }
=20
=20
-static void lance_tx_timeout (struct net_device *dev)
+static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct lance_private *lp =3D (struct lance_private *) dev->ml_priv;
 =09int ioaddr =3D dev->base_addr;
diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni6=
5.c
index c6c2a54c1121..c38edf6f03a3 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -254,7 +254,7 @@ static int  ni65_lance_reinit(struct net_device *dev);
 static void ni65_init_lance(struct priv *p,unsigned char*,int,int);
 static netdev_tx_t ni65_send_packet(struct sk_buff *skb,
 =09=09=09=09    struct net_device *dev);
-static void  ni65_timeout(struct net_device *dev);
+static void  ni65_timeout(struct net_device *dev, unsigned int txqueue);
 static int  ni65_close(struct net_device *dev);
 static int  ni65_alloc_buffer(struct net_device *dev);
 static void ni65_free_buffer(struct priv *p);
@@ -1133,7 +1133,7 @@ static void ni65_recv_intr(struct net_device *dev,int=
 csr0)
  * kick xmitter ..
  */
=20
-static void ni65_timeout(struct net_device *dev)
+static void ni65_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09int i;
 =09struct priv *p =3D dev->ml_priv;
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/am=
d/nmclan_cs.c
index 9c152d85840d..023aecf6ab30 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -407,7 +407,7 @@ static int mace_open(struct net_device *dev);
 static int mace_close(struct net_device *dev);
 static netdev_tx_t mace_start_xmit(struct sk_buff *skb,
 =09=09=09=09=09 struct net_device *dev);
-static void mace_tx_timeout(struct net_device *dev);
+static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static irqreturn_t mace_interrupt(int irq, void *dev_id);
 static struct net_device_stats *mace_get_stats(struct net_device *dev);
 static int mace_rx(struct net_device *dev, unsigned char RxCnt);
@@ -837,7 +837,7 @@ mace_start_xmit
 =09failed, put skb back into a list."
 --------------------------------------------------------------------------=
-- */
=20
-static void mace_tx_timeout(struct net_device *dev)
+static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
   mace_private *lp =3D netdev_priv(dev);
   struct pcmcia_device *link =3D lp->p_dev;
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/=
pcnet32.c
index f5ad12c10934..dc7d88227e76 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -314,7 +314,7 @@ static int pcnet32_open(struct net_device *);
 static int pcnet32_init_ring(struct net_device *);
 static netdev_tx_t pcnet32_start_xmit(struct sk_buff *,
 =09=09=09=09      struct net_device *);
-static void pcnet32_tx_timeout(struct net_device *dev);
+static void pcnet32_tx_timeout(struct net_device *dev, unsigned int txqueu=
e);
 static irqreturn_t pcnet32_interrupt(int, void *);
 static int pcnet32_close(struct net_device *);
 static struct net_device_stats *pcnet32_get_stats(struct net_device *);
@@ -2455,7 +2455,7 @@ static void pcnet32_restart(struct net_device *dev, u=
nsigned int csr0_bits)
 =09lp->a->write_csr(ioaddr, CSR0, csr0_bits);
 }
=20
-static void pcnet32_tx_timeout(struct net_device *dev)
+static void pcnet32_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct pcnet32_private *lp =3D netdev_priv(dev);
 =09unsigned long ioaddr =3D dev->base_addr, flags;
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd=
/sunlance.c
index ebcbf8ca4829..b00e00881253 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1097,7 +1097,7 @@ static void lance_piozero(void __iomem *dest, int len=
)
 =09=09sbus_writeb(0, piobuf);
 }
=20
-static void lance_tx_timeout(struct net_device *dev)
+static void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct lance_private *lp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/etherne=
t/amd/xgbe/xgbe-drv.c
index 98f8f2033154..b71f9b04a51e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2152,7 +2152,7 @@ static int xgbe_change_mtu(struct net_device *netdev,=
 int mtu)
 =09return 0;
 }
=20
-static void xgbe_tx_timeout(struct net_device *netdev)
+static void xgbe_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct xgbe_prv_data *pdata =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/etherne=
t/apm/xgene-v2/main.c
index 02b4f3af02b5..c48f60996761 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -575,7 +575,7 @@ static void xge_free_pending_skb(struct net_device *nde=
v)
 =09}
 }
=20
-static void xge_timeout(struct net_device *ndev)
+static void xge_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct xge_pdata *pdata =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net=
/ethernet/apm/xgene/xgene_enet_main.c
index d8612131c55e..e284b6753725 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -859,7 +859,7 @@ static int xgene_enet_napi(struct napi_struct *napi, co=
nst int budget)
 =09return processed;
 }
=20
-static void xgene_enet_timeout(struct net_device *ndev)
+static void xgene_enet_timeout(struct net_device *ndev, unsigned int txque=
ue)
 {
 =09struct xgene_enet_pdata *pdata =3D netdev_priv(ndev);
 =09struct netdev_queue *txq;
diff --git a/drivers/net/ethernet/apple/macmace.c b/drivers/net/ethernet/ap=
ple/macmace.c
index 8d03578d5e8c..95d3061c61be 100644
--- a/drivers/net/ethernet/apple/macmace.c
+++ b/drivers/net/ethernet/apple/macmace.c
@@ -91,7 +91,7 @@ static int mace_set_address(struct net_device *dev, void =
*addr);
 static void mace_reset(struct net_device *dev);
 static irqreturn_t mace_interrupt(int irq, void *dev_id);
 static irqreturn_t mace_dma_intr(int irq, void *dev_id);
-static void mace_tx_timeout(struct net_device *dev);
+static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void __mace_set_address(struct net_device *dev, void *addr);
=20
 /*
@@ -600,7 +600,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id=
)
 =09return IRQ_HANDLED;
 }
=20
-static void mace_tx_timeout(struct net_device *dev)
+static void mace_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct mace_data *mp =3D netdev_priv(dev);
 =09volatile struct mace *mb =3D mp->mace;
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/a=
theros/ag71xx.c
index 1b1a09095c0d..061dc1fec69c 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1409,7 +1409,7 @@ static void ag71xx_oom_timer_handler(struct timer_lis=
t *t)
 =09napi_schedule(&ag->napi);
 }
=20
-static void ag71xx_tx_timeout(struct net_device *ndev)
+static void ag71xx_tx_timeout(struct net_device *ndev, unsigned int txqueu=
e)
 {
 =09struct ag71xx *ag =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet=
/atheros/alx/main.c
index d4bbcdfd691a..1dcbc486eca9 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1553,7 +1553,7 @@ static netdev_tx_t alx_start_xmit(struct sk_buff *skb=
,
 =09return alx_start_xmit_ring(skb, alx_tx_queue_mapping(alx, skb));
 }
=20
-static void alx_tx_timeout(struct net_device *dev)
+static void alx_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct alx_priv *alx =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/=
ethernet/atheros/atl1c/atl1c_main.c
index 2b239ecea05f..4c0b1f8551dd 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -350,7 +350,7 @@ static void atl1c_del_timer(struct atl1c_adapter *adapt=
er)
  * atl1c_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  */
-static void atl1c_tx_timeout(struct net_device *netdev)
+static void atl1c_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct atl1c_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/=
ethernet/atheros/atl1e/atl1e_main.c
index 4f7b65825c15..e0d89942d537 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -251,7 +251,7 @@ static void atl1e_cancel_work(struct atl1e_adapter *ada=
pter)
  * atl1e_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  */
-static void atl1e_tx_timeout(struct net_device *netdev)
+static void atl1e_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct atl1e_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/etherne=
t/atheros/atlx/atl2.c
index 3aba38322717..b81a4e0c5b57 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1001,7 +1001,7 @@ static int atl2_ioctl(struct net_device *netdev, stru=
ct ifreq *ifr, int cmd)
  * atl2_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  */
-static void atl2_tx_timeout(struct net_device *netdev)
+static void atl2_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct atl2_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/bro=
adcom/b44.c
index 97ab0dd25552..f5a13627bb24 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -951,7 +951,7 @@ static irqreturn_t b44_interrupt(int irq, void *dev_id)
 =09return IRQ_RETVAL(handled);
 }
=20
-static void b44_tx_timeout(struct net_device *dev)
+static void b44_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct b44 *bp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ether=
net/broadcom/bcmsysport.c
index a977a459bd20..4f3c5bf42e08 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1354,7 +1354,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *s=
kb,
 =09return ret;
 }
=20
-static void bcm_sysport_tx_timeout(struct net_device *dev)
+static void bcm_sysport_tx_timeout(struct net_device *dev, unsigned int tx=
queue)
 {
 =09netdev_warn(dev, "transmit timeout!\n");
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/br=
oadcom/bnx2.c
index fbc196b480b6..dbb7874607ca 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -6575,7 +6575,7 @@ bnx2_dump_state(struct bnx2 *bp)
 }
=20
 static void
-bnx2_tx_timeout(struct net_device *dev)
+bnx2_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct bnx2 *bp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.c
index d10b421ed1f1..d687b9e98341 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4969,7 +4969,7 @@ int bnx2x_set_features(struct net_device *dev, netdev=
_features_t features)
 =09return 0;
 }
=20
-void bnx2x_tx_timeout(struct net_device *dev)
+void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct bnx2x *bp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 8b08cb18e363..e35f48bfdc85 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -617,7 +617,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_f=
eatures_t features);
  *
  * @dev:=09net device
  */
-void bnx2x_tx_timeout(struct net_device *dev);
+void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue);
=20
 /** bnx2x_get_c2s_mapping - read inner-to-outer vlan configuration
  * c2s_map should have BNX2X_MAX_PRIORITY entries.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethern=
et/broadcom/bnxt/bnxt.c
index 04ec909e06df..df808394c4cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9936,7 +9936,7 @@ static void bnxt_reset_task(struct bnxt *bp, bool sil=
ent)
 =09}
 }
=20
-static void bnxt_tx_timeout(struct net_device *dev)
+static void bnxt_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct bnxt *bp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/e=
thernet/broadcom/genet/bcmgenet.c
index 1de51811fcb4..841147891c53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3053,7 +3053,7 @@ static void bcmgenet_dump_tx_queue(struct bcmgenet_tx=
_ring *ring)
 =09=09  ring->cb_ptr, ring->end_ptr);
 }
=20
-static void bcmgenet_timeout(struct net_device *dev)
+static void bcmgenet_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct bcmgenet_priv *priv =3D netdev_priv(dev);
 =09u32 int0_enable =3D 0;
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ether=
net/broadcom/sb1250-mac.c
index 1604ad32e920..80ff52527233 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -294,7 +294,7 @@ static int sbmac_set_duplex(struct sbmac_softc *s, enum=
 sbmac_duplex duplex,
 =09=09=09    enum sbmac_fc fc);
=20
 static int sbmac_open(struct net_device *dev);
-static void sbmac_tx_timeout (struct net_device *dev);
+static void sbmac_tx_timeout (struct net_device *dev, unsigned int txqueue=
);
 static void sbmac_set_rx_mode(struct net_device *dev);
 static int sbmac_mii_ioctl(struct net_device *dev, struct ifreq *rq, int c=
md);
 static int sbmac_close(struct net_device *dev);
@@ -2419,7 +2419,7 @@ static void sbmac_mii_poll(struct net_device *dev)
 }
=20
=20
-static void sbmac_tx_timeout (struct net_device *dev)
+static void sbmac_tx_timeout (struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct sbmac_softc *sc =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/bro=
adcom/tg3.c
index ca3aa1250dd1..460b4992914a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7645,7 +7645,7 @@ static void tg3_poll_controller(struct net_device *de=
v)
 }
 #endif
=20
-static void tg3_tx_timeout(struct net_device *dev)
+static void tg3_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct tg3 *tp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/ca=
lxeda/xgmac.c
index f96a42af1014..d1db87634b8f 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1251,7 +1251,7 @@ static int xgmac_poll(struct napi_struct *napi, int b=
udget)
  *   netdev structure and arrange for the device to be reset to a sane sta=
te
  *   in order to transmit a new packet.
  */
-static void xgmac_tx_timeout(struct net_device *dev)
+static void xgmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct xgmac_priv *priv =3D netdev_priv(dev);
 =09schedule_work(&priv->tx_timeout_work);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/=
ethernet/cavium/liquidio/lio_main.c
index 7f3b2e3b0868..eab05b5534ea 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2562,7 +2562,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb,=
 struct net_device *netdev)
 /** \brief Network device Tx timeout
  * @param netdev    pointer to network device
  */
-static void liquidio_tx_timeout(struct net_device *netdev)
+static void liquidio_tx_timeout(struct net_device *netdev, unsigned int tx=
queue)
 {
 =09struct lio *lio;
=20
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/n=
et/ethernet/cavium/liquidio/lio_vf_main.c
index 370d76822ee0..7a77544a54f5 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1628,7 +1628,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb,=
 struct net_device *netdev)
 /** \brief Network device Tx timeout
  * @param netdev    pointer to network device
  */
-static void liquidio_tx_timeout(struct net_device *netdev)
+static void liquidio_tx_timeout(struct net_device *netdev, unsigned int tx=
queue)
 {
 =09struct lio *lio;
=20
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/ne=
t/ethernet/cavium/liquidio/lio_vf_rep.c
index f3f2e71431ac..600de587d7a9 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -31,7 +31,7 @@ static int lio_vf_rep_open(struct net_device *ndev);
 static int lio_vf_rep_stop(struct net_device *ndev);
 static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
 =09=09=09=09       struct net_device *ndev);
-static void lio_vf_rep_tx_timeout(struct net_device *netdev);
+static void lio_vf_rep_tx_timeout(struct net_device *netdev, unsigned int =
txqueue);
 static int lio_vf_rep_phys_port_name(struct net_device *dev,
 =09=09=09=09     char *buf, size_t len);
 static void lio_vf_rep_get_stats64(struct net_device *dev,
@@ -172,7 +172,7 @@ lio_vf_rep_stop(struct net_device *ndev)
 }
=20
 static void
-lio_vf_rep_tx_timeout(struct net_device *ndev)
+lio_vf_rep_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09netif_trans_update(ndev);
=20
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net=
/ethernet/cavium/thunder/nicvf_main.c
index 40a44dcb3d9b..c1a45bb24dbd 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1741,7 +1741,7 @@ static void nicvf_get_stats64(struct net_device *netd=
ev,
=20
 }
=20
-static void nicvf_tx_timeout(struct net_device *dev)
+static void nicvf_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct nicvf *nic =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/ci=
rrus/cs89x0.c
index c9aebcde403a..33ace3307059 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1128,7 +1128,7 @@ net_get_stats(struct net_device *dev)
 =09return &dev->stats;
 }
=20
-static void net_timeout(struct net_device *dev)
+static void net_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09/* If we get here, some higher level has decided we are broken.
 =09   There should really be a "kick me" function call instead. */
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethe=
rnet/cisco/enic/enic_main.c
index acb2856936d2..bbd7b3175f09 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1095,7 +1095,7 @@ static void enic_set_rx_mode(struct net_device *netde=
v)
 }
=20
 /* netif_tx_lock held, BHs disabled */
-static void enic_tx_timeout(struct net_device *netdev)
+static void enic_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct enic *enic =3D netdev_priv(netdev);
 =09schedule_work(&enic->tx_hang_reset);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/c=
ortina/gemini.c
index a8f4c69252ff..de0b6e066eef 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1296,7 +1296,7 @@ static int gmac_start_xmit(struct sk_buff *skb, struc=
t net_device *netdev)
 =09return NETDEV_TX_OK;
 }
=20
-static void gmac_tx_timeout(struct net_device *netdev)
+static void gmac_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09netdev_err(netdev, "Tx timeout\n");
 =09gmac_dump_dma_state(netdev);
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/d=
avicom/dm9000.c
index cce90b5925d9..1ea3372775e6 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -964,7 +964,7 @@ dm9000_init_dm9000(struct net_device *dev)
 }
=20
 /* Our watchdog timed out. Called by the networking layer */
-static void dm9000_timeout(struct net_device *dev)
+static void dm9000_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct board_info *db =3D netdev_priv(dev);
 =09u8 reg_save;
diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/etherne=
t/dec/tulip/de2104x.c
index f1a2da15dd0a..fd3c2abf74b5 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -1436,7 +1436,7 @@ static int de_close (struct net_device *dev)
 =09return 0;
 }
=20
-static void de_tx_timeout (struct net_device *dev)
+static void de_tx_timeout (struct net_device *dev, unsigned int txqueue)
 {
 =09struct de_private *de =3D netdev_priv(dev);
 =09const int irq =3D de->pdev->irq;
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethe=
rnet/dec/tulip/tulip_core.c
index 3e3e08698876..9e9d9eee29d9 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -255,7 +255,7 @@ MODULE_DEVICE_TABLE(pci, tulip_pci_tbl);
 const char tulip_media_cap[32] =3D
 {0,0,0,16,  3,19,16,24,  27,4,7,5, 0,20,23,20,  28,31,0,0, };
=20
-static void tulip_tx_timeout(struct net_device *dev);
+static void tulip_tx_timeout(struct net_device *dev, unsigned int txqueue)=
;
 static void tulip_init_ring(struct net_device *dev);
 static void tulip_free_ring(struct net_device *dev);
 static netdev_tx_t tulip_start_xmit(struct sk_buff *skb,
@@ -534,7 +534,7 @@ tulip_open(struct net_device *dev)
 }
=20
=20
-static void tulip_tx_timeout(struct net_device *dev)
+static void tulip_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct tulip_private *tp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D tp->base_addr;
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/eth=
ernet/dec/tulip/winbond-840.c
index 70cb2d689c2c..7f136488e67c 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -331,7 +331,7 @@ static void netdev_timer(struct timer_list *t);
 static void init_rxtx_rings(struct net_device *dev);
 static void free_rxtx_rings(struct netdev_private *np);
 static void init_registers(struct net_device *dev);
-static void tx_timeout(struct net_device *dev);
+static void tx_timeout(struct net_device *dev, unsigned int txqueue);
 static int alloc_ringdesc(struct net_device *dev);
 static void free_ringdesc(struct netdev_private *np);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
@@ -921,7 +921,7 @@ static void init_registers(struct net_device *dev)
 =09iowrite32(0, ioaddr + RxStartDemand);
 }
=20
-static void tx_timeout(struct net_device *dev)
+static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D np->base_addr;
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink=
/dl2k.c
index 55e720d2ea0c..26c5da032b1e 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -66,7 +66,7 @@ static const int multicast_filter_limit =3D 0x40;
=20
 static int rio_open (struct net_device *dev);
 static void rio_timer (struct timer_list *t);
-static void rio_tx_timeout (struct net_device *dev);
+static void rio_tx_timeout (struct net_device *dev, unsigned int txqueue);
 static netdev_tx_t start_xmit (struct sk_buff *skb, struct net_device *dev=
);
 static irqreturn_t rio_interrupt (int irq, void *dev_instance);
 static void rio_free_tx (struct net_device *dev, int irq);
@@ -696,7 +696,7 @@ rio_timer (struct timer_list *t)
 }
=20
 static void
-rio_tx_timeout (struct net_device *dev)
+rio_tx_timeout (struct net_device *dev, unsigned int txqueue)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D np->ioaddr;
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/d=
link/sundance.c
index 4a37a69764ce..b91387c456ba 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -432,7 +432,7 @@ static int  mdio_wait_link(struct net_device *dev, int =
wait);
 static int  netdev_open(struct net_device *dev);
 static void check_duplex(struct net_device *dev);
 static void netdev_timer(struct timer_list *t);
-static void tx_timeout(struct net_device *dev);
+static void tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void init_ring(struct net_device *dev);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
 static int reset_tx (struct net_device *dev);
@@ -969,7 +969,7 @@ static void netdev_timer(struct timer_list *t)
 =09add_timer(&np->timer);
 }
=20
-static void tx_timeout(struct net_device *dev)
+static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D np->base;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethe=
rnet/emulex/benet/be_main.c
index 39eb7d525043..56f59db6ebf2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1417,7 +1417,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struc=
t net_device *netdev)
 =09return NETDEV_TX_OK;
 }
=20
-static void be_tx_timeout(struct net_device *netdev)
+static void be_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct be_adapter *adapter =3D netdev_priv(netdev);
 =09struct device *dev =3D &adapter->pdev->dev;
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index ea4f17f5cce7..66406da16b60 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -869,7 +869,7 @@ static int ethoc_change_mtu(struct net_device *dev, int=
 new_mtu)
 =09return -ENOSYS;
 }
=20
-static void ethoc_tx_timeout(struct net_device *dev)
+static void ethoc_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ethoc *priv =3D netdev_priv(dev);
 =09u32 pending =3D ethoc_read(priv, INT_SOURCE);
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/etherne=
t/faraday/ftgmac100.c
index 96e9565f1e08..38c9183cb196 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1542,7 +1542,7 @@ static int ftgmac100_do_ioctl(struct net_device *netd=
ev, struct ifreq *ifr, int
 =09return phy_mii_ioctl(netdev->phydev, ifr, cmd);
 }
=20
-static void ftgmac100_tx_timeout(struct net_device *netdev)
+static void ftgmac100_tx_timeout(struct net_device *netdev, unsigned int t=
xqueue)
 {
 =09struct ftgmac100 *priv =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index c24fd56a2c71..84f10970299a 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -428,7 +428,7 @@ static void getlinktype(struct net_device *dev);
 static void getlinkstatus(struct net_device *dev);
 static void netdev_timer(struct timer_list *t);
 static void reset_timer(struct timer_list *t);
-static void fealnx_tx_timeout(struct net_device *dev);
+static void fealnx_tx_timeout(struct net_device *dev, unsigned int txqueue=
);
 static void init_ring(struct net_device *dev);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
 static irqreturn_t intr_handler(int irq, void *dev_instance);
@@ -1191,7 +1191,7 @@ static void reset_timer(struct timer_list *t)
 }
=20
=20
-static void fealnx_tx_timeout(struct net_device *dev)
+static void fealnx_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D np->mem;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index a9c386b63581..1cad343628ed 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1141,7 +1141,7 @@ fec_stop(struct net_device *ndev)
=20
=20
 static void
-fec_timeout(struct net_device *ndev)
+fec_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct fec_enet_private *fep =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/eth=
ernet/freescale/fec_mpc52xx.c
index 30cdb246d020..de5278485062 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -84,7 +84,7 @@ static int debug =3D -1;=09/* the above default */
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debugging messages level");
=20
-static void mpc52xx_fec_tx_timeout(struct net_device *dev)
+static void mpc52xx_fec_tx_timeout(struct net_device *dev, unsigned int tx=
queue)
 {
 =09struct mpc52xx_fec_priv *priv =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/driver=
s/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 3981c06f082f..80903cd58468 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -641,7 +641,7 @@ static void fs_timeout_work(struct work_struct *work)
 =09=09netif_wake_queue(dev);
 }
=20
-static void fs_timeout(struct net_device *dev)
+static void fs_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct fs_enet_private *fep =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/etherne=
t/freescale/gianfar.c
index 51ad86417cb1..ffc77e650371 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2092,7 +2092,7 @@ static void gfar_reset_task(struct work_struct *work)
 =09reset_gfar(priv->ndev);
 }
=20
-static void gfar_timeout(struct net_device *dev)
+static void gfar_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct gfar_private *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethern=
et/freescale/ucc_geth.c
index f839fa94ebdd..0d101c00286f 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3545,7 +3545,7 @@ static void ucc_geth_timeout_work(struct work_struct =
*work)
  * ucc_geth_timeout gets called when a packet has not been
  * transmitted after a set amount of time.
  */
-static void ucc_geth_timeout(struct net_device *dev)
+static void ucc_geth_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ucc_geth_private *ugeth =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethern=
et/fujitsu/fmvj18x_cs.c
index 1eca0fdb9933..a7b7a4aace79 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -93,7 +93,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id);
 static void fjn_rx(struct net_device *dev);
 static void fjn_reset(struct net_device *dev);
 static void set_rx_mode(struct net_device *dev);
-static void fjn_tx_timeout(struct net_device *dev);
+static void fjn_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static const struct ethtool_ops netdev_ethtool_ops;
=20
 /*
@@ -774,7 +774,7 @@ static irqreturn_t fjn_interrupt(int dummy, void *dev_i=
d)
=20
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
=20
-static void fjn_tx_timeout(struct net_device *dev)
+static void fjn_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
     struct local_info *lp =3D netdev_priv(dev);
     unsigned int ioaddr =3D dev->base_addr;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ether=
net/google/gve/gve_main.c
index aca95f64bde8..81c80e97c5aa 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -844,7 +844,7 @@ static void gve_turnup(struct gve_priv *priv)
 =09gve_set_napi_enabled(priv);
 }
=20
-static void gve_tx_timeout(struct net_device *dev)
+static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct gve_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ether=
net/hisilicon/hip04_eth.c
index 4606a7e4a6d1..d0c94a5373bb 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -779,7 +779,7 @@ static int hip04_mac_stop(struct net_device *ndev)
 =09return 0;
 }
=20
-static void hip04_timeout(struct net_device *ndev)
+static void hip04_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct hip04_priv *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/et=
hernet/hisilicon/hix5hd2_gmac.c
index c41b19c760f8..fbaac94cf6ce 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -893,7 +893,7 @@ static void hix5hd2_tx_timeout_task(struct work_struct =
*work)
 =09hix5hd2_net_open(priv->netdev);
 }
=20
-static void hix5hd2_net_timeout(struct net_device *dev)
+static void hix5hd2_net_timeout(struct net_device *dev, unsigned int txque=
ue)
 {
 =09struct hix5hd2_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/et=
hernet/hisilicon/hns/hns_enet.c
index 14ab20491fd0..e45553ec114a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1485,7 +1485,7 @@ static int hns_nic_net_stop(struct net_device *ndev)
=20
 static void hns_tx_timeout_reset(struct hns_nic_priv *priv);
 #define HNS_TX_TIMEO_LIMIT (40 * HZ)
-static void hns_nic_net_timeout(struct net_device *ndev)
+static void hns_nic_net_timeout(struct net_device *ndev, unsigned int txqu=
eue)
 {
 =09struct hns_nic_priv *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/=
ethernet/hisilicon/hns3/hns3_enet.c
index 616cad0faa21..bce5ed18f2ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1764,7 +1764,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_d=
evice *ndev)
 =09return true;
 }
=20
-static void hns3_nic_net_timeout(struct net_device *ndev)
+static void hns3_nic_net_timeout(struct net_device *ndev, unsigned int txq=
ueue)
 {
 =09struct hns3_nic_priv *priv =3D netdev_priv(ndev);
 =09struct hnae3_handle *h =3D priv->ae_handle;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/e=
thernet/huawei/hinic/hinic_main.c
index 2411ad270c98..02a14f5e7fe3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -766,7 +766,7 @@ static void hinic_set_rx_mode(struct net_device *netdev=
)
 =09queue_work(nic_dev->workq, &rx_mode_work->work);
 }
=20
-static void hinic_tx_timeout(struct net_device *netdev)
+static void hinic_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct hinic_dev *nic_dev =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i82=
5xx/82596.c
index 92929750f832..bef676d93339 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -363,7 +363,7 @@ static netdev_tx_t i596_start_xmit(struct sk_buff *skb,=
 struct net_device *dev);
 static irqreturn_t i596_interrupt(int irq, void *dev_id);
 static int i596_close(struct net_device *dev);
 static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
-static void i596_tx_timeout (struct net_device *dev);
+static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)=
;
 static void print_eth(unsigned char *buf, char *str);
 static void set_multicast_list(struct net_device *dev);
=20
@@ -1019,7 +1019,7 @@ static int i596_open(struct net_device *dev)
 =09return res;
 }
=20
-static void i596_tx_timeout (struct net_device *dev)
+static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)
 {
 =09struct i596_private *lp =3D dev->ml_priv;
 =09int ioaddr =3D dev->base_addr;
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i8=
25xx/ether1.c
index bb3b8adbe4f0..a0bfb509e002 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -66,7 +66,7 @@ static netdev_tx_t ether1_sendpacket(struct sk_buff *skb,
 static irqreturn_t ether1_interrupt(int irq, void *dev_id);
 static int ether1_close(struct net_device *dev);
 static void ether1_setmulticastlist(struct net_device *dev);
-static void ether1_timeout(struct net_device *dev);
+static void ether1_timeout(struct net_device *dev, unsigned int txqueue);
=20
 /* -----------------------------------------------------------------------=
-- */
=20
@@ -650,7 +650,7 @@ ether1_open (struct net_device *dev)
 }
=20
 static void
-ether1_timeout(struct net_device *dev)
+ether1_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09printk(KERN_WARNING "%s: transmit timeout, network cable problem?\n",
 =09=09dev->name);
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/=
i825xx/lib82596.c
index f9742af7f142..b03757e169e4 100644
--- a/drivers/net/ethernet/i825xx/lib82596.c
+++ b/drivers/net/ethernet/i825xx/lib82596.c
@@ -351,7 +351,7 @@ static netdev_tx_t i596_start_xmit(struct sk_buff *skb,=
 struct net_device *dev);
 static irqreturn_t i596_interrupt(int irq, void *dev_id);
 static int i596_close(struct net_device *dev);
 static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
-static void i596_tx_timeout (struct net_device *dev);
+static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)=
;
 static void print_eth(unsigned char *buf, char *str);
 static void set_multicast_list(struct net_device *dev);
 static inline void ca(struct net_device *dev);
@@ -936,7 +936,7 @@ static int i596_open(struct net_device *dev)
 =09return -EAGAIN;
 }
=20
-static void i596_tx_timeout (struct net_device *dev)
+static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)
 {
 =09struct i596_private *lp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/etherne=
t/i825xx/sun3_82586.c
index 1a86184d44c0..4564ee02c95f 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -125,7 +125,7 @@ static netdev_tx_t     sun3_82586_send_packet(struct sk=
_buff *,
 =09=09=09=09=09      struct net_device *);
 static struct  net_device_stats *sun3_82586_get_stats(struct net_device *d=
ev);
 static void    set_multicast_list(struct net_device *dev);
-static void    sun3_82586_timeout(struct net_device *dev);
+static void    sun3_82586_timeout(struct net_device *dev, unsigned int txq=
ueue);
 #if 0
 static void    sun3_82586_dump(struct net_device *,void *);
 #endif
@@ -965,7 +965,7 @@ static void startrecv586(struct net_device *dev)
 =09WAIT_4_SCB_CMD_RUC();=09/* wait for accept cmd. (no timeout!!) */
 }
=20
-static void sun3_82586_timeout(struct net_device *dev)
+static void sun3_82586_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct priv *p =3D netdev_priv(dev);
 #ifndef NO_NOPCOMMANDS
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethern=
et/ibm/ehea/ehea_main.c
index 13e30eba5349..0273fb7a9d01 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2786,7 +2786,7 @@ static void ehea_rereg_mrs(void)
 =09return;
 }
=20
-static void ehea_tx_watchdog(struct net_device *dev)
+static void ehea_tx_watchdog(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ehea_port *port =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ib=
m/emac/core.c
index 9e43c9ace9c2..1f82f6834331 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -776,7 +776,7 @@ static void emac_reset_work(struct work_struct *work)
 =09mutex_unlock(&dev->link_lock);
 }
=20
-static void emac_tx_timeout(struct net_device *ndev)
+static void emac_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct emac_instance *dev =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/=
ibmvnic.c
index f59d9a8e35e2..867525a0abaf 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2189,7 +2189,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adap=
ter,
 =09return -ret;
 }
=20
-static void ibmvnic_tx_timeout(struct net_device *dev)
+static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct ibmvnic_adapter *adapter =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel=
/e100.c
index a65d5a9ba7db..1b8d015ebfb0 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2316,7 +2316,7 @@ static void e100_down(struct nic *nic)
 =09e100_rx_clean_list(nic);
 }
=20
-static void e100_tx_timeout(struct net_device *netdev)
+static void e100_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct nic *nic =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/et=
hernet/intel/e1000/e1000_main.c
index 86493fea56e4..570133403ee2 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -134,7 +134,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, s=
truct ifreq *ifr,
 =09=09=09   int cmd);
 static void e1000_enter_82542_rst(struct e1000_adapter *adapter);
 static void e1000_leave_82542_rst(struct e1000_adapter *adapter);
-static void e1000_tx_timeout(struct net_device *dev);
+static void e1000_tx_timeout(struct net_device *dev, unsigned int txqueue)=
;
 static void e1000_reset_task(struct work_struct *work);
 static void e1000_smartspeed(struct e1000_adapter *adapter);
 static int e1000_82547_fifo_workaround(struct e1000_adapter *adapter,
@@ -3488,7 +3488,7 @@ static void e1000_dump(struct e1000_adapter *adapter)
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void e1000_tx_timeout(struct net_device *netdev)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct e1000_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ether=
net/intel/e1000e/netdev.c
index d7d56e42a6aa..d46827d4cbb7 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5926,7 +5926,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *s=
kb,
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void e1000_tx_timeout(struct net_device *netdev)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct e1000_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/=
ethernet/intel/fm10k/fm10k_netdev.c
index 09f7a246e134..2c7fcf269c3b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -697,7 +697,7 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *skb=
, struct net_device *dev)
  * fm10k_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void fm10k_tx_timeout(struct net_device *netdev)
+static void fm10k_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct fm10k_intfc *interface =3D netdev_priv(netdev);
 =09bool real_tx_hang =3D false;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_main.c
index 6031223eafab..caa86825e164 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -301,7 +301,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
  * device is munged, not just the one netdev port, so go for the full
  * reset.
  **/
-static void i40e_tx_timeout(struct net_device *netdev)
+static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct i40e_netdev_priv *np =3D netdev_priv(netdev);
 =09struct i40e_vsi *vsi =3D np->vsi;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethe=
rnet/intel/iavf/iavf_main.c
index 821987da5698..0a8824871618 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -159,7 +159,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
  * iavf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void iavf_tx_timeout(struct net_device *netdev)
+static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct iavf_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethern=
et/intel/ice/ice_main.c
index 214cd6eca405..f171f0750350 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4627,7 +4627,7 @@ ice_bridge_setlink(struct net_device *dev, struct nlm=
sghdr *nlh,
  * ice_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  */
-static void ice_tx_timeout(struct net_device *netdev)
+static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue=
)
 {
 =09struct ice_netdev_priv *np =3D netdev_priv(netdev);
 =09struct ice_ring *tx_ring =3D NULL;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index ed7e667d7eb2..4656ff17dcbe 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -146,7 +146,7 @@ static int igb_poll(struct napi_struct *, int);
 static bool igb_clean_tx_irq(struct igb_q_vector *, int);
 static int igb_clean_rx_irq(struct igb_q_vector *, int);
 static int igb_ioctl(struct net_device *, struct ifreq *, int cmd);
-static void igb_tx_timeout(struct net_device *);
+static void igb_tx_timeout(struct net_device *, unsigned int txqueue);
 static void igb_reset_task(struct work_struct *);
 static void igb_vlan_mode(struct net_device *netdev,
 =09=09=09  netdev_features_t features);
@@ -6173,7 +6173,7 @@ static netdev_tx_t igb_xmit_frame(struct sk_buff *skb=
,
  *  igb_tx_timeout - Respond to a Tx Hang
  *  @netdev: network interface device structure
  **/
-static void igb_tx_timeout(struct net_device *netdev)
+static void igb_tx_timeout(struct net_device *netdev, unsigned int txqueue=
)
 {
 =09struct igb_adapter *adapter =3D netdev_priv(netdev);
 =09struct e1000_hw *hw =3D &adapter->hw;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethern=
et/intel/igbvf/netdev.c
index 0f2b68f4bb0f..5721ddf124c4 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2375,7 +2375,7 @@ static netdev_tx_t igbvf_xmit_frame(struct sk_buff *s=
kb,
  * igbvf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void igbvf_tx_timeout(struct net_device *netdev)
+static void igbvf_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct igbvf_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethe=
rnet/intel/ixgb/ixgb_main.c
index 0940a0da16f2..e11c6ac77140 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -70,7 +70,7 @@ static int ixgb_clean(struct napi_struct *, int);
 static bool ixgb_clean_rx_irq(struct ixgb_adapter *, int *, int);
 static void ixgb_alloc_rx_buffers(struct ixgb_adapter *, int);
=20
-static void ixgb_tx_timeout(struct net_device *dev);
+static void ixgb_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void ixgb_tx_timeout_task(struct work_struct *work);
=20
 static void ixgb_vlan_strip_enable(struct ixgb_adapter *adapter);
@@ -1538,7 +1538,7 @@ ixgb_xmit_frame(struct sk_buff *skb, struct net_devic=
e *netdev)
  **/
=20
 static void
-ixgb_tx_timeout(struct net_device *netdev)
+ixgb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct ixgb_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c b/drivers/net=
/ethernet/intel/ixgbe/ixgbe_debugfs.c
index 171cdc552961..5b1cf49df3d3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
@@ -166,7 +166,9 @@ static ssize_t ixgbe_dbg_netdev_ops_write(struct file *=
filp,
 =09ixgbe_dbg_netdev_ops_buf[len] =3D '\0';
=20
 =09if (strncmp(ixgbe_dbg_netdev_ops_buf, "tx_timeout", 10) =3D=3D 0) {
-=09=09adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev);
+=09=09/* TX Queue number below is wrong, but ixgbe does not use it */
+=09=09adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev,
+=09=09=09=09=09=09=09    UINT_MAX);
 =09=09e_dev_info("tx_timeout called\n");
 =09} else {
 =09=09e_dev_info("Unknown command: %s\n", ixgbe_dbg_netdev_ops_buf);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 91b3780ddb04..dcf2f57bfc8c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6158,7 +6158,7 @@ static void ixgbe_set_eee_capable(struct ixgbe_adapte=
r *adapter)
  * ixgbe_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void ixgbe_tx_timeout(struct net_device *netdev)
+static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct ixgbe_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index 076f2da36f27..fa286694ac2c 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -250,7 +250,7 @@ static void ixgbevf_tx_timeout_reset(struct ixgbevf_ada=
pter *adapter)
  * ixgbevf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
  **/
-static void ixgbevf_tx_timeout(struct net_device *netdev)
+static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct ixgbevf_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 25aa400e2e3c..2e4975572e9f 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2337,7 +2337,7 @@ jme_change_mtu(struct net_device *netdev, int new_mtu=
)
 }
=20
 static void
-jme_tx_timeout(struct net_device *netdev)
+jme_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct jme_adapter *jme =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index ae195f8adff5..f98d9d627c71 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -917,7 +917,7 @@ static void korina_restart_task(struct work_struct *wor=
k)
 =09enable_irq(lp->rx_irq);
 }
=20
-static void korina_tx_timeout(struct net_device *dev)
+static void korina_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct korina_private *lp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lant=
iq_etop.c
index 6e73ffe6f928..028e3e6222e9 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -594,7 +594,7 @@ ltq_etop_init(struct net_device *dev)
 }
=20
 static void
-ltq_etop_tx_timeout(struct net_device *dev)
+ltq_etop_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09int err;
=20
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ether=
net/marvell/mv643xx_eth.c
index 82ea55ae5053..93360de6e98b 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2590,7 +2590,7 @@ static void tx_timeout_task(struct work_struct *ugly)
 =09}
 }
=20
-static void mv643xx_eth_tx_timeout(struct net_device *dev)
+static void mv643xx_eth_tx_timeout(struct net_device *dev, unsigned int tx=
queue)
 {
 =09struct mv643xx_eth_private *mp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethern=
et/marvell/pxa168_eth.c
index 51b77c2de400..5cd74bdfdf50 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -742,7 +742,7 @@ static int txq_reclaim(struct net_device *dev, int forc=
e)
 =09return released;
 }
=20
-static void pxa168_eth_tx_timeout(struct net_device *dev)
+static void pxa168_eth_tx_timeout(struct net_device *dev, unsigned int txq=
ueue)
 {
 =09struct pxa168_eth_private *pep =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/mar=
vell/skge.c
index 095f6c71b4fa..8ca15958e752 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -2884,7 +2884,7 @@ static void skge_tx_clean(struct net_device *dev)
 =09skge->tx_ring.to_clean =3D e;
 }
=20
-static void skge_tx_timeout(struct net_device *dev)
+static void skge_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct skge_port *skge =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 5f56ee83e3b1..acd1cba987fb 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2358,7 +2358,7 @@ static void sky2_qlink_intr(struct sky2_hw *hw)
 /* Transmit timeout is only called if we are running, carrier is up
  * and tx queue is full (stopped).
  */
-static void sky2_tx_timeout(struct net_device *dev)
+static void sky2_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct sky2_port *sky2 =3D netdev_priv(dev);
 =09struct sky2_hw *hw =3D sky2->hw;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethe=
rnet/mediatek/mtk_eth_soc.c
index 703adb96429e..1376870f78ce 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2083,7 +2083,7 @@ static void mtk_dma_free(struct mtk_eth *eth)
 =09kfree(eth->scratch_head);
 }
=20
-static void mtk_tx_timeout(struct net_device *dev)
+static void mtk_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct mtk_mac *mac =3D netdev_priv(dev);
 =09struct mtk_eth *eth =3D mac->hw;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/e=
thernet/mellanox/mlx4/en_netdev.c
index 40ec5acf79c0..d2728933d420 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1354,7 +1354,7 @@ static void mlx4_en_delete_rss_steer_rules(struct mlx=
4_en_priv *priv)
 =09}
 }
=20
-static void mlx4_en_tx_timeout(struct net_device *dev)
+static void mlx4_en_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct mlx4_en_priv *priv =3D netdev_priv(dev);
 =09struct mlx4_en_dev *mdev =3D priv->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 772bfdbdeb9c..3efee40804e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4337,7 +4337,7 @@ static void mlx5e_tx_timeout_work(struct work_struct =
*work)
 =09rtnl_unlock();
 }
=20
-static void mlx5e_tx_timeout(struct net_device *dev)
+static void mlx5e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct mlx5e_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/mi=
crel/ks8842.c
index da329ca115cc..f3f6dfe3eddc 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1103,7 +1103,7 @@ static void ks8842_tx_timeout_work(struct work_struct=
 *work)
 =09=09__ks8842_start_new_rx_dma(netdev);
 }
=20
-static void ks8842_tx_timeout(struct net_device *netdev)
+static void ks8842_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue)
 {
 =09struct ks8842_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/m=
icrel/ksz884x.c
index e102e1560ac7..d1444ba36e10 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4896,7 +4896,7 @@ static netdev_tx_t netdev_tx(struct sk_buff *skb, str=
uct net_device *dev)
  * triggered to free up resources so that the transmit routine can continu=
e
  * sending out packets.  The hardware is reset to correct the problem.
  */
-static void netdev_tx_timeout(struct net_device *dev)
+static void netdev_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09static unsigned long last_reset;
=20
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethern=
et/microchip/enc28j60.c
index 0567e4f387a5..09cdc2f2e7ff 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1325,7 +1325,7 @@ static irqreturn_t enc28j60_irq(int irq, void *dev_id=
)
 =09return IRQ_HANDLED;
 }
=20
-static void enc28j60_tx_timeout(struct net_device *ndev)
+static void enc28j60_tx_timeout(struct net_device *ndev, unsigned int txqu=
eue)
 {
 =09struct enc28j60_net *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethe=
rnet/microchip/encx24j600.c
index 52c41d11f565..39925e4bf2ec 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -892,7 +892,7 @@ static netdev_tx_t encx24j600_tx(struct sk_buff *skb, s=
truct net_device *dev)
 }
=20
 /* Deal with a transmit timeout */
-static void encx24j600_tx_timeout(struct net_device *dev)
+static void encx24j600_tx_timeout(struct net_device *dev, unsigned int txq=
ueue)
 {
 =09struct encx24j600_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/=
natsemi/natsemi.c
index 1a2634cbbb69..d21d706b83a7 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -612,7 +612,7 @@ static void undo_cable_magic(struct net_device *dev);
 static void check_link(struct net_device *dev);
 static void netdev_timer(struct timer_list *t);
 static void dump_ring(struct net_device *dev);
-static void ns_tx_timeout(struct net_device *dev);
+static void ns_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static int alloc_ring(struct net_device *dev);
 static void refill_rx(struct net_device *dev);
 static void init_ring(struct net_device *dev);
@@ -1881,7 +1881,7 @@ static void dump_ring(struct net_device *dev)
 =09}
 }
=20
-static void ns_tx_timeout(struct net_device *dev)
+static void ns_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct netdev_private *np =3D netdev_priv(dev);
 =09void __iomem * ioaddr =3D ns_ioaddr(dev);
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/=
natsemi/ns83820.c
index 6af9a7eee114..fb671a0da521 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -1549,7 +1549,7 @@ static int ns83820_stop(struct net_device *ndev)
 =09return 0;
 }
=20
-static void ns83820_tx_timeout(struct net_device *ndev)
+static void ns83820_tx_timeout(struct net_device *ndev, unsigned int txque=
ue)
 {
 =09struct ns83820 *dev =3D PRIV(ndev);
         u32 tx_done_idx;
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/na=
tsemi/sonic.c
index b339125b2f09..fdebc8598b22 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -161,7 +161,7 @@ static int sonic_close(struct net_device *dev)
 =09return 0;
 }
=20
-static void sonic_tx_timeout(struct net_device *dev)
+static void sonic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct sonic_local *lp =3D netdev_priv(dev);
 =09int i;
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/na=
tsemi/sonic.h
index 2b27f7049acb..f1544481aac1 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -336,7 +336,7 @@ static int sonic_close(struct net_device *dev);
 static struct net_device_stats *sonic_get_stats(struct net_device *dev);
 static void sonic_multicast_list(struct net_device *dev);
 static int sonic_init(struct net_device *dev);
-static void sonic_tx_timeout(struct net_device *dev);
+static void sonic_tx_timeout(struct net_device *dev, unsigned int txqueue)=
;
 static void sonic_msg_init(struct net_device *dev);
=20
 /* Internal inlines for reading/writing DMA buffers.  Note that bus
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/ne=
terion/s2io.c
index e0b2bf327905..0ec6b8e8b549 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7238,7 +7238,7 @@ static void s2io_restart_nic(struct work_struct *work=
)
  *  void
  */
=20
-static void s2io_tx_watchdog(struct net_device *dev)
+static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue)
 {
 =09struct s2io_nic *sp =3D netdev_priv(dev);
 =09struct swStat *swstats =3D &sp->mac_control.stats_info->sw_stat;
diff --git a/drivers/net/ethernet/neterion/s2io.h b/drivers/net/ethernet/ne=
terion/s2io.h
index 0a921f30f98f..6fa3159a977f 100644
--- a/drivers/net/ethernet/neterion/s2io.h
+++ b/drivers/net/ethernet/neterion/s2io.h
@@ -1065,7 +1065,7 @@ static void s2io_txpic_intr_handle(struct s2io_nic *s=
p);
 static void tx_intr_handler(struct fifo_info *fifo_data);
 static void s2io_handle_errors(void * dev_id);
=20
-static void s2io_tx_watchdog(struct net_device *dev);
+static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue)=
;
 static void s2io_set_multicast(struct net_device *dev);
 static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp=
);
 static void s2io_link(struct s2io_nic * sp, int link);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/e=
thernet/neterion/vxge/vxge-main.c
index 1d334f2e0a56..9b63574b6202 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3273,7 +3273,7 @@ static int vxge_ioctl(struct net_device *dev, struct =
ifreq *rq, int cmd)
  * This function is triggered if the Tx Queue is stopped
  * for a pre-defined amount of time when the Interface is still up.
  */
-static void vxge_tx_watchdog(struct net_device *dev)
+static void vxge_tx_watchdog(struct net_device *dev, unsigned int txqueue)
 {
 =09struct vxgedev *vdev;
=20
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index 61aabffc8888..41a808b14d76 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1320,7 +1320,7 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct n=
fp_net_tx_ring *tx_ring)
 =09netdev_tx_reset_queue(nd_q);
 }
=20
-static void nfp_net_tx_timeout(struct net_device *netdev)
+static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct nfp_net *nn =3D netdev_priv(netdev);
 =09int i;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet=
/nvidia/forcedeth.c
index 05d2b478c99b..4b963a873003 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2700,7 +2700,7 @@ static int nv_tx_done_optimized(struct net_device *de=
v, int limit)
  * nv_tx_timeout: dev->tx_timeout function
  * Called with netif_tx_lock held.
  */
-static void nv_tx_timeout(struct net_device *dev)
+static void nv_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct fe_priv *np =3D netdev_priv(dev);
 =09u8 __iomem *base =3D get_hwbase(dev);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers=
/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 18e6d87c607b..73ec195fbc30 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2271,7 +2271,7 @@ static int pch_gbe_ioctl(struct net_device *netdev, s=
truct ifreq *ifr, int cmd)
  * pch_gbe_tx_timeout - Respond to a Tx Hang
  * @netdev:   Network interface device structure
  */
-static void pch_gbe_tx_timeout(struct net_device *netdev)
+static void pch_gbe_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct pch_gbe_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/eth=
ernet/packetengines/hamachi.c
index eee883a2aa8d..70816d2e2990 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -548,7 +548,7 @@ static void mdio_write(struct net_device *dev, int phy_=
id, int location, int val
 static int hamachi_open(struct net_device *dev);
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)=
;
 static void hamachi_timer(struct timer_list *t);
-static void hamachi_tx_timeout(struct net_device *dev);
+static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueu=
e);
 static void hamachi_init_ring(struct net_device *dev);
 static netdev_tx_t hamachi_start_xmit(struct sk_buff *skb,
 =09=09=09=09      struct net_device *dev);
@@ -1042,7 +1042,7 @@ static void hamachi_timer(struct timer_list *t)
 =09add_timer(&hmp->timer);
 }
=20
-static void hamachi_tx_timeout(struct net_device *dev)
+static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09int i;
 =09struct hamachi_private *hmp =3D netdev_priv(dev);
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/e=
thernet/packetengines/yellowfin.c
index 5113ee647090..520779f05e1a 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -344,7 +344,7 @@ static void mdio_write(void __iomem *ioaddr, int phy_id=
, int location, int value
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)=
;
 static int yellowfin_open(struct net_device *dev);
 static void yellowfin_timer(struct timer_list *t);
-static void yellowfin_tx_timeout(struct net_device *dev);
+static void yellowfin_tx_timeout(struct net_device *dev, unsigned int txqu=
eue);
 static int yellowfin_init_ring(struct net_device *dev);
 static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
 =09=09=09=09=09struct net_device *dev);
@@ -677,7 +677,7 @@ static void yellowfin_timer(struct timer_list *t)
 =09add_timer(&yp->timer);
 }
=20
-static void yellowfin_tx_timeout(struct net_device *dev)
+static void yellowfin_tx_timeout(struct net_device *dev, unsigned int txqu=
eue)
 {
 =09struct yellowfin_private *yp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D yp->base;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/=
ethernet/pensando/ionic/ionic_lif.c
index 20faa8d24c9f..f7beb1b9e9d6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1268,7 +1268,7 @@ static void ionic_tx_timeout_work(struct work_struct =
*ws)
 =09rtnl_unlock();
 }
=20
-static void ionic_tx_timeout(struct net_device *netdev)
+static void ionic_tx_timeout(struct net_device *netdev, unsigned int txque=
ue)
 {
 =09struct ionic_lif *lif =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers=
/net/ethernet/qlogic/netxen/netxen_nic_main.c
index c692a41e4548..8067ea04d455 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -49,7 +49,7 @@ static int netxen_nic_open(struct net_device *netdev);
 static int netxen_nic_close(struct net_device *netdev);
 static netdev_tx_t netxen_nic_xmit_frame(struct sk_buff *,
 =09=09=09=09=09       struct net_device *);
-static void netxen_tx_timeout(struct net_device *netdev);
+static void netxen_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue);
 static void netxen_tx_timeout_task(struct work_struct *work);
 static void netxen_fw_poll_work(struct work_struct *work);
 static void netxen_schedule_work(struct netxen_adapter *adapter,
@@ -2222,7 +2222,7 @@ static void netxen_nic_handle_phy_intr(struct netxen_=
adapter *adapter)
 =09netxen_advert_link_change(adapter, linkup);
 }
=20
-static void netxen_tx_timeout(struct net_device *netdev)
+static void netxen_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue)
 {
 =09struct netxen_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/q=
logic/qla3xxx.c
index b4b8ba00ee01..bb864765c761 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3602,7 +3602,7 @@ static int ql3xxx_set_mac_address(struct net_device *=
ndev, void *p)
 =09return 0;
 }
=20
-static void ql3xxx_tx_timeout(struct net_device *ndev)
+static void ql3xxx_tx_timeout(struct net_device *ndev, unsigned int txqueu=
e)
 {
 =09struct ql3_adapter *qdev =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net=
/ethernet/qlogic/qlcnic/qlcnic_main.c
index c07438db30ba..9dd6cb36f366 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -56,7 +56,7 @@ static int qlcnic_probe(struct pci_dev *pdev, const struc=
t pci_device_id *ent);
 static void qlcnic_remove(struct pci_dev *pdev);
 static int qlcnic_open(struct net_device *netdev);
 static int qlcnic_close(struct net_device *netdev);
-static void qlcnic_tx_timeout(struct net_device *netdev);
+static void qlcnic_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue);
 static void qlcnic_attach_work(struct work_struct *work);
 static void qlcnic_fwinit_work(struct work_struct *work);
=20
@@ -3068,7 +3068,7 @@ static void qlcnic_dump_rings(struct qlcnic_adapter *=
adapter)
=20
 }
=20
-static void qlcnic_tx_timeout(struct net_device *netdev)
+static void qlcnic_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue)
 {
 =09struct qlcnic_adapter *adapter =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethern=
et/qualcomm/emac/emac.c
index c84ab052ef26..c33f491b1364 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -282,7 +282,7 @@ static int emac_close(struct net_device *netdev)
 }
=20
 /* Respond to a TX hang */
-static void emac_tx_timeout(struct net_device *netdev)
+static void emac_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct emac_adapter *adpt =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet=
/qualcomm/qca_spi.c
index 5ecf61df78bd..2b0233aa2528 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -786,7 +786,7 @@ qcaspi_netdev_xmit(struct sk_buff *skb, struct net_devi=
ce *dev)
 }
=20
 static void
-qcaspi_netdev_tx_timeout(struct net_device *dev)
+qcaspi_netdev_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct qcaspi *qca =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/etherne=
t/qualcomm/qca_uart.c
index 0981068504fa..375a844cd27c 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -248,7 +248,7 @@ qcauart_netdev_xmit(struct sk_buff *skb, struct net_dev=
ice *dev)
 =09return NETDEV_TX_OK;
 }
=20
-static void qcauart_netdev_tx_timeout(struct net_device *dev)
+static void qcauart_netdev_tx_timeout(struct net_device *dev, unsigned int=
 txqueue)
 {
 =09struct qcauart *qca =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6=
040.c
index 274e5b4bc4ac..c23cb61bbd30 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -410,7 +410,7 @@ static void r6040_init_mac_regs(struct net_device *dev)
 =09iowrite16(TM2TX, ioaddr + MTPR);
 }
=20
-static void r6040_tx_timeout(struct net_device *dev)
+static void r6040_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct r6040_private *priv =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D priv->base;
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/r=
ealtek/8139cp.c
index 4f910c4f67b0..60d342f82fb3 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1235,7 +1235,7 @@ static int cp_close (struct net_device *dev)
 =09return 0;
 }
=20
-static void cp_tx_timeout(struct net_device *dev)
+static void cp_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct cp_private *cp =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/=
realtek/8139too.c
index 55d01266e615..80e488c33c35 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -642,7 +642,7 @@ static int mdio_read (struct net_device *dev, int phy_i=
d, int location);
 static void mdio_write (struct net_device *dev, int phy_id, int location,
 =09=09=09int val);
 static void rtl8139_start_thread(struct rtl8139_private *tp);
-static void rtl8139_tx_timeout (struct net_device *dev);
+static void rtl8139_tx_timeout (struct net_device *dev, int txtqueue);
 static void rtl8139_init_ring (struct net_device *dev);
 static netdev_tx_t rtl8139_start_xmit (struct sk_buff *skb,
 =09=09=09=09       struct net_device *dev);
@@ -1700,7 +1700,7 @@ static void rtl8139_tx_timeout_task (struct work_stru=
ct *work)
 =09spin_unlock_bh(&tp->rx_lock);
 }
=20
-static void rtl8139_tx_timeout (struct net_device *dev)
+static void rtl8139_tx_timeout(struct net_device *dev, int rtl8139_tx_time=
out)
 {
 =09struct rtl8139_private *tp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/real=
tek/atp.c
index 58e0ca9093d3..9e3b35c97e63 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -204,7 +204,7 @@ static void net_rx(struct net_device *dev);
 static void read_block(long ioaddr, int length, unsigned char *buffer, int=
 data_mode);
 static int net_close(struct net_device *dev);
 static void set_rx_mode(struct net_device *dev);
-static void tx_timeout(struct net_device *dev);
+static void tx_timeout(struct net_device *dev, unsigned int txqueue);
=20
=20
 /* A list of all installed ATP devices, for removing the driver module. */
@@ -533,7 +533,7 @@ static void write_packet(long ioaddr, int length, unsig=
ned char *packet, int pad
     outb(Ctrl_HNibWrite | Ctrl_SelData | Ctrl_IRQEN, ioaddr + PAR_CONTROL)=
;
 }
=20
-static void tx_timeout(struct net_device *dev)
+static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09long ioaddr =3D dev->base_addr;
=20
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethern=
et/realtek/r8169_main.c
index c4e961ea44d5..a9f95518c627 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5662,7 +5662,7 @@ static void rtl_reset_work(struct rtl8169_private *tp=
)
 =09netif_wake_queue(dev);
 }
=20
-static void rtl8169_tx_timeout(struct net_device *dev)
+static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct rtl8169_private *tp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/etherne=
t/renesas/ravb_main.c
index 3f165c137236..763ca158cd6c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1425,7 +1425,7 @@ static int ravb_open(struct net_device *ndev)
 }
=20
 /* Timeout function for Ethernet AVB */
-static void ravb_tx_timeout(struct net_device *ndev)
+static void ravb_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct ravb_private *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/r=
enesas/sh_eth.c
index 7ba35a0bdb29..bfd6fb89740c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2478,7 +2478,7 @@ static int sh_eth_open(struct net_device *ndev)
 }
=20
 /* Timeout function */
-static void sh_eth_tx_timeout(struct net_device *ndev)
+static void sh_eth_tx_timeout(struct net_device *ndev, unsigned int txqueu=
e)
 {
 =09struct sh_eth_private *mdp =3D netdev_priv(ndev);
 =09struct sh_eth_rxdesc *rxdesc;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/=
ethernet/samsung/sxgbe/sxgbe_main.c
index c56fcbb37066..cd6e0de48248 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1572,7 +1572,7 @@ static int sxgbe_poll(struct napi_struct *napi, int b=
udget)
  *   netdev structure and arrange for the device to be reset to a sane sta=
te
  *   in order to transmit a new packet.
  */
-static void sxgbe_tx_timeout(struct net_device *dev)
+static void sxgbe_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct sxgbe_priv_data *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq=
/ether3.c
index 632a7c85964d..128ee7cda1ed 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -79,7 +79,7 @@ static netdev_tx_t=09ether3_sendpacket(struct sk_buff *sk=
b,
 static irqreturn_t ether3_interrupt (int irq, void *dev_id);
 static int=09ether3_close (struct net_device *dev);
 static void=09ether3_setmulticastlist (struct net_device *dev);
-static void=09ether3_timeout(struct net_device *dev);
+static void=09ether3_timeout(struct net_device *dev, unsigned int txqueue)=
;
=20
 #define BUS_16=09=092
 #define BUS_8=09=091
@@ -450,7 +450,7 @@ static void ether3_setmulticastlist(struct net_device *=
dev)
 =09ether3_outw(priv(dev)->regs.config1 | CFG1_LOCBUFMEM, REG_CONFIG1);
 }
=20
-static void ether3_timeout(struct net_device *dev)
+static void ether3_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09unsigned long flags;
=20
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/see=
q/sgiseeq.c
index 276c7cae7cee..8507ff242014 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -645,7 +645,7 @@ sgiseeq_start_xmit(struct sk_buff *skb, struct net_devi=
ce *dev)
 =09return NETDEV_TX_OK;
 }
=20
-static void timeout(struct net_device *dev)
+static void timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09printk(KERN_NOTICE "%s: transmit timed out, resetting\n", dev->name);
 =09sgiseeq_reset(dev);
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi=
/ioc3-eth.c
index deb636d653f3..aea5eb32d1f0 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -113,7 +113,7 @@ struct ioc3_private {
 static int ioc3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void ioc3_set_multicast_list(struct net_device *dev);
 static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device =
*dev);
-static void ioc3_timeout(struct net_device *dev);
+static void ioc3_timeout(struct net_device *dev, unsigned int txqueue);
 static inline unsigned int ioc3_hash(const unsigned char *addr);
 static void ioc3_start(struct ioc3_private *ip);
 static inline void ioc3_stop(struct ioc3_private *ip);
@@ -1493,7 +1493,7 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *sk=
b, struct net_device *dev)
 =09return NETDEV_TX_OK;
 }
=20
-static void ioc3_timeout(struct net_device *dev)
+static void ioc3_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ioc3_private *ip =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sgi/meth.c b/drivers/net/ethernet/sgi/met=
h.c
index 539bc5db989c..0c396ecd3389 100644
--- a/drivers/net/ethernet/sgi/meth.c
+++ b/drivers/net/ethernet/sgi/meth.c
@@ -90,7 +90,7 @@ struct meth_private {
 =09spinlock_t meth_lock;
 };
=20
-static void meth_tx_timeout(struct net_device *dev);
+static void meth_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static irqreturn_t meth_interrupt(int irq, void *dev_id);
=20
 /* global, initialized in ip32-setup.c */
@@ -727,7 +727,7 @@ static netdev_tx_t meth_tx(struct sk_buff *skb, struct =
net_device *dev)
 /*
  * Deal with a transmit timeout.
  */
-static void meth_tx_timeout(struct net_device *dev)
+static void meth_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct meth_private *priv =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/si=
lan/sc92031.c
index c7641a236eb8..cb043eb1bdc1 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -1078,7 +1078,7 @@ static void sc92031_set_multicast_list(struct net_dev=
ice *dev)
 =09spin_unlock_bh(&priv->lock);
 }
=20
-static void sc92031_tx_timeout(struct net_device *dev)
+static void sc92031_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct sc92031_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/s=
is190.c
index 5b351beb78cb..5a4b6e3ab38f 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1538,7 +1538,7 @@ static struct net_device *sis190_init_board(struct pc=
i_dev *pdev)
 =09goto out;
 }
=20
-static void sis190_tx_timeout(struct net_device *dev)
+static void sis190_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct sis190_private *tp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D tp->mmio_addr;
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/sms=
c/epic100.c
index be47d864f8b9..912760e8514c 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -291,7 +291,7 @@ static int mdio_read(struct net_device *dev, int phy_id=
, int location);
 static void mdio_write(struct net_device *dev, int phy_id, int loc, int va=
l);
 static void epic_restart(struct net_device *dev);
 static void epic_timer(struct timer_list *t);
-static void epic_tx_timeout(struct net_device *dev);
+static void epic_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void epic_init_ring(struct net_device *dev);
 static netdev_tx_t epic_start_xmit(struct sk_buff *skb,
 =09=09=09=09   struct net_device *dev);
@@ -861,7 +861,7 @@ static void epic_timer(struct timer_list *t)
 =09add_timer(&ep->timer);
 }
=20
-static void epic_tx_timeout(struct net_device *dev)
+static void epic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct epic_private *ep =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D ep->ioaddr;
diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/sms=
c/smc911x.c
index 8d88e4083456..4cc679376c9a 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1245,7 +1245,7 @@ static void smc911x_poll_controller(struct net_device=
 *dev)
 #endif
=20
 /* Our watchdog timed out. Called by the networking layer */
-static void smc911x_timeout(struct net_device *dev)
+static void smc911x_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct smc911x_local *lp =3D netdev_priv(dev);
 =09int status, mask;
diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/sms=
c/smc9194.c
index d3bb2ba51f40..4b2330deed47 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -216,7 +216,7 @@ static int smc_open(struct net_device *dev);
 /*
  . Our watchdog timed out. Called by the networking layer
 */
-static void smc_timeout(struct net_device *dev);
+static void smc_timeout(struct net_device *dev, unsigned int txqueue);
=20
 /*
  . This is called by the kernel in response to 'ifconfig ethX down'.  It
@@ -1094,7 +1094,7 @@ static int smc_open(struct net_device *dev)
  .--------------------------------------------------------
 */
=20
-static void smc_timeout(struct net_device *dev)
+static void smc_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09/* If we get here, some higher level has decided we are broken.
 =09   There should really be a "kick me" function call instead. */
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet=
/smsc/smc91c92_cs.c
index a55f430f6a7b..f2a50eb3c1e0 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -271,7 +271,7 @@ static void smc91c92_release(struct pcmcia_device *link=
);
 static int smc_open(struct net_device *dev);
 static int smc_close(struct net_device *dev);
 static int smc_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-static void smc_tx_timeout(struct net_device *dev);
+static void smc_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static netdev_tx_t smc_start_xmit(struct sk_buff *skb,
 =09=09=09=09=09struct net_device *dev);
 static irqreturn_t smc_interrupt(int irq, void *dev_id);
@@ -1178,7 +1178,7 @@ static void smc_hardware_send_packet(struct net_devic=
e * dev)
=20
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
=20
-static void smc_tx_timeout(struct net_device *dev)
+static void smc_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
     struct smc_private *smc =3D netdev_priv(dev);
     unsigned int ioaddr =3D dev->base_addr;
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc=
/smc91x.c
index 3a6761131f4c..90410f9d3b1a 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1321,7 +1321,7 @@ static void smc_poll_controller(struct net_device *de=
v)
 #endif
=20
 /* Our watchdog timed out. Called by the networking layer */
-static void smc_timeout(struct net_device *dev)
+static void smc_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct smc_local *lp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D lp->base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index f826365c979d..cdad40c3f104 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3712,7 +3712,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *na=
pi, int budget)
  *   netdev structure and arrange for the device to be reset to a sane sta=
te
  *   in order to transmit a new packet.
  */
-static void stmmac_tx_timeout(struct net_device *dev)
+static void stmmac_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct stmmac_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/=
cassini.c
index c91876f8c536..6ec9163e232c 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -2666,7 +2666,7 @@ static void cas_netpoll(struct net_device *dev)
 }
 #endif
=20
-static void cas_tx_timeout(struct net_device *dev)
+static void cas_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct cas *cp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.=
c
index f5fd1f3c07cc..9a5004f674c7 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -6517,7 +6517,7 @@ static void niu_reset_task(struct work_struct *work)
 =09spin_unlock_irqrestore(&np->lock, flags);
 }
=20
-static void niu_tx_timeout(struct net_device *dev)
+static void niu_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct niu *np =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/=
sunbmac.c
index e9b757b03b56..c5add0b45eed 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -941,7 +941,7 @@ static int bigmac_close(struct net_device *dev)
 =09return 0;
 }
=20
-static void bigmac_tx_timeout(struct net_device *dev)
+static void bigmac_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct bigmac *bp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/s=
ungem.c
index 3e7631160384..8358064fbd48 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -970,7 +970,7 @@ static void gem_poll_controller(struct net_device *dev)
 }
 #endif
=20
-static void gem_tx_timeout(struct net_device *dev)
+static void gem_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct gem *gp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/s=
unhme.c
index d007dfeba5c3..f0fe7bb2a750 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2246,7 +2246,7 @@ static int happy_meal_close(struct net_device *dev)
 #define SXD(x)
 #endif
=20
-static void happy_meal_tx_timeout(struct net_device *dev)
+static void happy_meal_tx_timeout(struct net_device *dev, unsigned int txq=
ueue)
 {
 =09struct happy_meal *hp =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/su=
nqe.c
index 1468fa0a54e9..2102b95ec347 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -544,7 +544,7 @@ static void qe_tx_reclaim(struct sunqe *qep)
 =09qep->tx_old =3D elem;
 }
=20
-static void qe_tx_timeout(struct net_device *dev)
+static void qe_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct sunqe *qep =3D netdev_priv(dev);
 =09int tx_full;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethern=
et/sun/sunvnet_common.c
index 8b94d9ad9e2b..a601a306f9a5 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1539,7 +1539,7 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struct=
 net_device *dev,
 }
 EXPORT_SYMBOL_GPL(sunvnet_start_xmit_common);
=20
-void sunvnet_tx_timeout_common(struct net_device *dev)
+void sunvnet_tx_timeout_common(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09/* XXX Implement me XXX */
 }
diff --git a/drivers/net/ethernet/sun/sunvnet_common.h b/drivers/net/ethern=
et/sun/sunvnet_common.h
index 2b808d2482d6..5416a3cb9e7d 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.h
+++ b/drivers/net/ethernet/sun/sunvnet_common.h
@@ -135,7 +135,7 @@ int sunvnet_open_common(struct net_device *dev);
 int sunvnet_close_common(struct net_device *dev);
 void sunvnet_set_rx_mode_common(struct net_device *dev, struct vnet *vp);
 int sunvnet_set_mac_addr_common(struct net_device *dev, void *p);
-void sunvnet_tx_timeout_common(struct net_device *dev);
+void sunvnet_tx_timeout_common(struct net_device *dev, unsigned int txqueu=
e);
 netdev_tx_t
 sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
 =09=09=09  struct vnet_port *(*vnet_tx_port)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/e=
thernet/synopsys/dwc-xlgmac-net.c
index a1f5a1e61040..07046a2370b3 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -689,7 +689,7 @@ static int xlgmac_close(struct net_device *netdev)
 =09return 0;
 }
=20
-static void xlgmac_tx_timeout(struct net_device *netdev)
+static void xlgmac_tx_timeout(struct net_device *netdev, unsigned int txqu=
eue)
 {
 =09struct xlgmac_pdata *pdata =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpma=
c.c
index 3a655a4dc10e..5e1b8292cd3f 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -797,7 +797,7 @@ static irqreturn_t cpmac_irq(int irq, void *dev_id)
 =09return IRQ_HANDLED;
 }
=20
-static void cpmac_tx_timeout(struct net_device *dev)
+static void cpmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct cpmac_priv *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.=
c
index f298d714efd6..b2e0ace6bc20 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2035,7 +2035,7 @@ static int cpsw_ndo_ioctl(struct net_device *dev, str=
uct ifreq *req, int cmd)
 =09return phy_mii_ioctl(cpsw->slaves[slave_no].phy, req, cmd);
 }
=20
-static void cpsw_ndo_tx_timeout(struct net_device *ndev)
+static void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqu=
eue)
 {
 =09struct cpsw_priv *priv =3D netdev_priv(ndev);
 =09struct cpsw_common *cpsw =3D priv->cpsw;
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/=
ti/davinci_emac.c
index ae27be85e363..75d4e16c692b 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -983,7 +983,7 @@ static int emac_dev_xmit(struct sk_buff *skb, struct ne=
t_device *ndev)
  * error and re-initialize the TX channel for hardware operation
  *
  */
-static void emac_dev_tx_timeout(struct net_device *ndev)
+static void emac_dev_tx_timeout(struct net_device *ndev, unsigned int txqu=
eue)
 {
 =09struct emac_priv *priv =3D netdev_priv(ndev);
 =09struct device *emac_dev =3D &ndev->dev;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti=
/netcp_core.c
index 1b2702f74455..432645e86495 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1811,7 +1811,7 @@ static int netcp_ndo_ioctl(struct net_device *ndev,
 =09return (ret =3D=3D 0) ? 0 : err;
 }
=20
-static void netcp_ndo_tx_timeout(struct net_device *ndev)
+static void netcp_ndo_tx_timeout(struct net_device *ndev, unsigned int txq=
ueue)
 {
 =09struct netcp_intf *netcp =3D netdev_priv(ndev);
 =09unsigned int descs =3D knav_pool_count(netcp->tx_pool);
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.=
c
index 78f0f2d59e22..115c555db91f 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -161,7 +161,7 @@ static void=09tlan_set_multicast_list(struct net_device=
 *);
 static int=09tlan_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)=
;
 static int      tlan_probe1(struct pci_dev *pdev, long ioaddr,
 =09=09=09    int irq, int rev, const struct pci_device_id *ent);
-static void=09tlan_tx_timeout(struct net_device *dev);
+static void=09tlan_tx_timeout(struct net_device *dev, unsigned int txqueue=
);
 static void=09tlan_tx_timeout_work(struct work_struct *work);
 static int=09tlan_init_one(struct pci_dev *pdev,
 =09=09=09      const struct pci_device_id *ent);
@@ -997,7 +997,7 @@ static int tlan_ioctl(struct net_device *dev, struct if=
req *rq, int cmd)
  *
  **************************************************************/
=20
-static void tlan_tx_timeout(struct net_device *dev)
+static void tlan_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
=20
 =09TLAN_DBG(TLAN_DEBUG_GNRL, "%s: Transmit timed out.\n", dev->name);
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/eth=
ernet/toshiba/ps3_gelic_net.c
index 9d9f8acb7ee3..070dd6fa9401 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1405,7 +1405,7 @@ static void gelic_net_tx_timeout_task(struct work_str=
uct *work)
  *
  * called, if tx hangs. Schedules a task that resets the interface
  */
-void gelic_net_tx_timeout(struct net_device *netdev)
+void gelic_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct gelic_card *card;
=20
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/eth=
ernet/toshiba/ps3_gelic_net.h
index 051033580f0a..805903dbddcc 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -359,7 +359,7 @@ int gelic_net_open(struct net_device *netdev);
 int gelic_net_stop(struct net_device *netdev);
 netdev_tx_t gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev)=
;
 void gelic_net_set_multi(struct net_device *netdev);
-void gelic_net_tx_timeout(struct net_device *netdev);
+void gelic_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)=
;
 int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *c=
ard);
=20
 /* shared ethtool ops */
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethern=
et/toshiba/spider_net.c
index 538e70810d3d..6576271642c1 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2180,7 +2180,7 @@ spider_net_tx_timeout_task(struct work_struct *work)
  * called, if tx hangs. Schedules a task that resets the interface
  */
 static void
-spider_net_tx_timeout(struct net_device *netdev)
+spider_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct spider_net_card *card;
=20
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/=
toshiba/tc35815.c
index 12466a72cefc..708de826200e 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -483,7 +483,7 @@ static void=09tc35815_txdone(struct net_device *dev);
 static int=09tc35815_close(struct net_device *dev);
 static struct=09net_device_stats *tc35815_get_stats(struct net_device *dev=
);
 static void=09tc35815_set_multicast_list(struct net_device *dev);
-static void=09tc35815_tx_timeout(struct net_device *dev);
+static void=09tc35815_tx_timeout(struct net_device *dev, unsigned int txqu=
eue);
 static int=09tc35815_ioctl(struct net_device *dev, struct ifreq *rq, int c=
md);
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void=09tc35815_poll_controller(struct net_device *dev);
@@ -1189,7 +1189,7 @@ static void tc35815_schedule_restart(struct net_devic=
e *dev)
 =09spin_unlock_irqrestore(&lp->lock, flags);
 }
=20
-static void tc35815_tx_timeout(struct net_device *dev)
+static void tc35815_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct tc35815_regs __iomem *tr =3D
 =09=09(struct tc35815_regs __iomem *)dev->base_addr;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/vi=
a/via-rhine.c
index ed12dbd156f0..803247d51fe9 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -506,7 +506,7 @@ static void mdio_write(struct net_device *dev, int phy_=
id, int location, int val
 static int  rhine_open(struct net_device *dev);
 static void rhine_reset_task(struct work_struct *work);
 static void rhine_slow_event_task(struct work_struct *work);
-static void rhine_tx_timeout(struct net_device *dev);
+static void rhine_tx_timeout(struct net_device *dev, unsigned int txqueue)=
;
 static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
 =09=09=09=09  struct net_device *dev);
 static irqreturn_t rhine_interrupt(int irq, void *dev_instance);
@@ -1761,7 +1761,7 @@ static void rhine_reset_task(struct work_struct *work=
)
 =09mutex_unlock(&rp->task_lock);
 }
=20
-static void rhine_tx_timeout(struct net_device *dev)
+static void rhine_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct rhine_private *rp =3D netdev_priv(dev);
 =09void __iomem *ioaddr =3D rp->base;
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiz=
net/w5100.c
index bede1ff289c5..c0d181a7f83a 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -790,7 +790,7 @@ static void w5100_restart_work(struct work_struct *work=
)
 =09w5100_restart(priv->ndev);
 }
=20
-static void w5100_tx_timeout(struct net_device *ndev)
+static void w5100_tx_timeout(struct net_device *ndev, unsigned int txqueue=
)
 {
 =09struct w5100_priv *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiz=
net/w5300.c
index 6ba2747779ce..46aae30c4636 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -341,7 +341,7 @@ static void w5300_get_regs(struct net_device *ndev,
 =09}
 }
=20
-static void w5300_tx_timeout(struct net_device *ndev)
+static void w5300_tx_timeout(struct net_device *ndev, unsigned int txqueue=
)
 {
 =09struct w5300_priv *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/et=
hernet/xilinx/xilinx_emaclite.c
index 0de52e70abcc..0c26f5bcc523 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -521,7 +521,7 @@ static int xemaclite_set_mac_address(struct net_device =
*dev, void *address)
  *
  * This function is called when Tx time out occurs for Emaclite device.
  */
-static void xemaclite_tx_timeout(struct net_device *dev)
+static void xemaclite_tx_timeout(struct net_device *dev, unsigned int txqu=
eue)
 {
 =09struct net_local *lp =3D netdev_priv(dev);
 =09unsigned long flags;
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/etherne=
t/xircom/xirc2ps_cs.c
index fd5288ff53b5..480ab7251515 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -288,7 +288,7 @@ struct local_info {
  */
 static netdev_tx_t do_start_xmit(struct sk_buff *skb,
 =09=09=09=09       struct net_device *dev);
-static void xirc_tx_timeout(struct net_device *dev);
+static void xirc_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void xirc2ps_tx_timeout_task(struct work_struct *work);
 static void set_addresses(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
@@ -1203,7 +1203,7 @@ xirc2ps_tx_timeout_task(struct work_struct *work)
 }
=20
 static void
-xirc_tx_timeout(struct net_device *dev)
+xirc_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
     struct local_info *lp =3D netdev_priv(dev);
     dev->stats.tx_errors++;
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index b517c1af9de0..309a74da2ec3 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -48,7 +48,7 @@ static void fjes_get_stats64(struct net_device *, struct =
rtnl_link_stats64 *);
 static int fjes_change_mtu(struct net_device *, int);
 static int fjes_vlan_rx_add_vid(struct net_device *, __be16 proto, u16);
 static int fjes_vlan_rx_kill_vid(struct net_device *, __be16 proto, u16);
-static void fjes_tx_retry(struct net_device *);
+static void fjes_tx_retry(struct net_device *, unsigned int txqueue);
=20
 static int fjes_acpi_add(struct acpi_device *);
 static int fjes_acpi_remove(struct acpi_device *);
@@ -792,7 +792,7 @@ fjes_xmit_frame(struct sk_buff *skb, struct net_device =
*netdev)
 =09return ret;
 }
=20
-static void fjes_tx_retry(struct net_device *netdev)
+static void fjes_tx_retry(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct netdev_queue *queue =3D netdev_get_tx_queue(netdev, 0);
=20
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 4d479e3c817d..756ccab97517 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -457,7 +457,7 @@ static void slip_write_wakeup(struct tty_struct *tty)
 =09schedule_work(&sl->tx_work);
 }
=20
-static void sl_tx_timeout(struct net_device *dev)
+static void sl_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct slip *sl =3D netdev_priv(dev);
=20
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 1e58702c737f..d387bc7ac1b6 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -447,7 +447,7 @@ static netdev_tx_t catc_start_xmit(struct sk_buff *skb,
 =09return NETDEV_TX_OK;
 }
=20
-static void catc_tx_timeout(struct net_device *netdev)
+static void catc_tx_timeout(struct net_device *netdev, unsigned int txqueu=
e)
 {
 =09struct catc *catc =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 74849da031fa..ab6754f66106 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -820,7 +820,7 @@ static const struct ethtool_ops ops =3D {
 };
=20
 /* called when a packet did not ack after watchdogtimeout */
-static void hso_net_tx_timeout(struct net_device *net)
+static void hso_net_tx_timeout(struct net_device *net, unsigned int txqueu=
e)
 {
 =09struct hso_net *odev =3D netdev_priv(net);
=20
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 8c01fbf68a89..c792d65dd7b4 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -400,7 +400,7 @@ static int ipheth_tx(struct sk_buff *skb, struct net_de=
vice *net)
 =09return NETDEV_TX_OK;
 }
=20
-static void ipheth_tx_timeout(struct net_device *net)
+static void ipheth_tx_timeout(struct net_device *net, unsigned int txqueue=
)
 {
 =09struct ipheth_device *dev =3D netdev_priv(net);
=20
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 8e210ba4a313..ed01dc964c99 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -894,7 +894,7 @@ static void kaweth_async_set_rx_mode(struct kaweth_devi=
ce *kaweth)
 /****************************************************************
  *     kaweth_tx_timeout
  ****************************************************************/
-static void kaweth_tx_timeout(struct net_device *net)
+static void kaweth_tx_timeout(struct net_device *net, unsigned int txqueue=
)
 {
 =09struct kaweth_device *kaweth =3D netdev_priv(net);
=20
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f24a1b0b801f..53cd79afcd28 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3662,7 +3662,7 @@ static void lan78xx_disconnect(struct usb_interface *=
intf)
 =09usb_put_dev(udev);
 }
=20
-static void lan78xx_tx_timeout(struct net_device *net)
+static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueu=
e)
 {
 =09struct lan78xx_net *dev =3D netdev_priv(net);
=20
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index f7d117d80cfb..8783e2ab3ec0 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -693,7 +693,7 @@ static void intr_callback(struct urb *urb)
 =09=09=09  "can't resubmit interrupt urb, %d\n", res);
 }
=20
-static void pegasus_tx_timeout(struct net_device *net)
+static void pegasus_tx_timeout(struct net_device *net, unsigned int txqueu=
e)
 {
 =09pegasus_t *pegasus =3D netdev_priv(net);
 =09netif_warn(pegasus, timer, net, "tx timeout\n");
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d4a95b50bda6..b6a132f5a1f9 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2306,7 +2306,7 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
 =09}
 }
=20
-static void rtl8152_tx_timeout(struct net_device *netdev)
+static void rtl8152_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct r8152 *tp =3D netdev_priv(netdev);
=20
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 13e51ccf0214..e7c630d37589 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -655,7 +655,7 @@ static void disable_net_traffic(rtl8150_t * dev)
 =09set_registers(dev, CR, 1, &cr);
 }
=20
-static void rtl8150_tx_timeout(struct net_device *netdev)
+static void rtl8150_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09rtl8150_t *dev =3D netdev_priv(netdev);
 =09dev_warn(&netdev->dev, "Tx timeout.\n");
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dde05e2fdc3e..481b75a4e906 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1293,7 +1293,7 @@ static void tx_complete (struct urb *urb)
=20
 /*------------------------------------------------------------------------=
-*/
=20
-void usbnet_tx_timeout (struct net_device *net)
+void usbnet_tx_timeout (struct net_device *net, unsigned int txqueue)
 {
 =09struct usbnet=09=09*dev =3D netdev_priv(net);
=20
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet=
3_drv.c
index 216acf37ca7c..18f152fa0068 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3198,7 +3198,7 @@ vmxnet3_free_intr_resources(struct vmxnet3_adapter *a=
dapter)
=20
=20
 static void
-vmxnet3_tx_timeout(struct net_device *netdev)
+vmxnet3_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 =09struct vmxnet3_adapter *adapter =3D netdev_priv(netdev);
 =09adapter->tx_timeout_count++;
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index af539151d663..5d6532ad6b78 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -268,7 +268,7 @@ static int cosa_net_attach(struct net_device *dev, unsi=
gned short encoding,
 =09=09=09   unsigned short parity);
 static int cosa_net_open(struct net_device *d);
 static int cosa_net_close(struct net_device *d);
-static void cosa_net_timeout(struct net_device *d);
+static void cosa_net_timeout(struct net_device *d, unsigned int txqueue);
 static netdev_tx_t cosa_net_tx(struct sk_buff *skb, struct net_device *d);
 static char *cosa_net_setup_rx(struct channel_data *channel, int size);
 static int cosa_net_rx_done(struct channel_data *channel);
@@ -670,7 +670,7 @@ static netdev_tx_t cosa_net_tx(struct sk_buff *skb,
 =09return NETDEV_TX_OK;
 }
=20
-static void cosa_net_timeout(struct net_device *dev)
+static void cosa_net_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct channel_data *chan =3D dev_to_chan(dev);
=20
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 1901ec7948d8..7916efce7188 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2239,7 +2239,7 @@ fst_attach(struct net_device *dev, unsigned short enc=
oding, unsigned short parit
 }
=20
 static void
-fst_tx_timeout(struct net_device *dev)
+fst_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct fst_port_info *port;
 =09struct fst_card_info *card;
diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.=
c
index ca0f3be2b6bf..308384756e6f 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1039,7 +1039,7 @@ static const struct dev_pm_ops uhdlc_pm_ops =3D {
 #define HDLC_PM_OPS NULL
=20
 #endif
-static void uhdlc_tx_timeout(struct net_device *ndev)
+static void uhdlc_tx_timeout(struct net_device *ndev, unsigned int txqueue=
)
 {
 =09netdev_err(ndev, "%s\n", __func__);
 }
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.=
c
index 0e6a51525d91..a20f467ca48a 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -99,7 +99,7 @@ static int lmc_ifdown(struct net_device * const);
 static void lmc_watchdog(struct timer_list *t);
 static void lmc_reset(lmc_softc_t * const sc);
 static void lmc_dec_reset(lmc_softc_t * const sc);
-static void lmc_driver_timeout(struct net_device *dev);
+static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueu=
e);
=20
 /*
  * linux reserves 16 device specific IOCTLs.  We call them
@@ -2044,7 +2044,7 @@ static void lmc_initcsrs(lmc_softc_t * const sc, lmc_=
csrptr_t csr_base, /*fold00
     lmc_trace(sc->lmc_device, "lmc_initcsrs out");
 }
=20
-static void lmc_driver_timeout(struct net_device *dev)
+static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
     lmc_softc_t *sc =3D dev_to_sc(dev);
     u32 csr6;
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 914be5847386..69773d228ec1 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -276,7 +276,7 @@ static void x25_asy_write_wakeup(struct tty_struct *tty=
)
 =09sl->xhead +=3D actual;
 }
=20
-static void x25_asy_timeout(struct net_device *dev)
+static void x25_asy_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct x25_asy *sl =3D netdev_priv(dev);
=20
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wir=
eless/intel/ipw2x00/ipw2100.c
index 8dfbaff2d1fe..8f85f98929f3 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5834,7 +5834,7 @@ static int ipw2100_close(struct net_device *dev)
 /*
  * TODO:  Fix this function... its just wrong
  */
-static void ipw2100_tx_timeout(struct net_device *dev)
+static void ipw2100_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct ipw2100_priv *priv =3D libipw_priv(dev);
=20
diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/n=
et/wireless/intersil/hostap/hostap_main.c
index 05466281afb6..de97b3304115 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -761,7 +761,7 @@ static void hostap_set_multicast_list(struct net_device=
 *dev)
 }
=20
=20
-static void prism2_tx_timeout(struct net_device *dev)
+static void prism2_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct hostap_interface *iface;
 =09local_info_t *local;
diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wir=
eless/intersil/orinoco/main.c
index 28dac36d7c4c..00264a14e52c 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -647,7 +647,7 @@ static void __orinoco_ev_txexc(struct net_device *dev, =
struct hermes *hw)
 =09netif_wake_queue(dev);
 }
=20
-void orinoco_tx_timeout(struct net_device *dev)
+void orinoco_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct orinoco_private *priv =3D ndev_priv(dev);
 =09struct net_device_stats *stats =3D &dev->stats;
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco.h b/drivers/net/=
wireless/intersil/orinoco/orinoco.h
index 430862a6a24b..cdd026af100b 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco.h
+++ b/drivers/net/wireless/intersil/orinoco/orinoco.h
@@ -207,7 +207,7 @@ int orinoco_open(struct net_device *dev);
 int orinoco_stop(struct net_device *dev);
 void orinoco_set_multicast_list(struct net_device *dev);
 int orinoco_change_mtu(struct net_device *dev, int new_mtu);
-void orinoco_tx_timeout(struct net_device *dev);
+void orinoco_tx_timeout(struct net_device *dev, unsigned int txqueue);
=20
 /********************************************************************/
 /* Locking and synchronization functions                            */
diff --git a/drivers/net/wireless/intersil/prism54/islpci_eth.c b/drivers/n=
et/wireless/intersil/prism54/islpci_eth.c
index 2b8fb07d07e7..8d680250a281 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_eth.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_eth.c
@@ -473,7 +473,7 @@ islpci_do_reset_and_wake(struct work_struct *work)
 }
=20
 void
-islpci_eth_tx_timeout(struct net_device *ndev)
+islpci_eth_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09islpci_private *priv =3D netdev_priv(ndev);
=20
diff --git a/drivers/net/wireless/intersil/prism54/islpci_eth.h b/drivers/n=
et/wireless/intersil/prism54/islpci_eth.h
index 61f4b43c6054..e433ccdc526b 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_eth.h
+++ b/drivers/net/wireless/intersil/prism54/islpci_eth.h
@@ -53,7 +53,7 @@ struct avs_80211_1_header {
 void islpci_eth_cleanup_transmit(islpci_private *, isl38xx_control_block *=
);
 netdev_tx_t islpci_eth_transmit(struct sk_buff *, struct net_device *);
 int islpci_eth_receive(islpci_private *);
-void islpci_eth_tx_timeout(struct net_device *);
+void islpci_eth_tx_timeout(struct net_device *, unsigned int txqueue);
 void islpci_do_reset_and_wake(struct work_struct *);
=20
 #endif=09=09=09=09/* _ISL_GEN_H */
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wire=
less/marvell/mwifiex/main.c
index a9657ae6d782..cb6d1a9d9272 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1019,7 +1019,7 @@ static void mwifiex_set_multicast_list(struct net_dev=
ice *dev)
  * CFG802.11 network device handler for transmission timeout.
  */
 static void
-mwifiex_tx_timeout(struct net_device *dev)
+mwifiex_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct mwifiex_private *priv =3D mwifiex_netdev_get_priv(dev);
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index 8d699cc03d26..96c5235dcc68 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -148,7 +148,7 @@ static void qtnf_netdev_get_stats64(struct net_device *=
ndev,
=20
 /* Netdev handler for transmission timeout.
  */
-static void qtnf_netdev_tx_timeout(struct net_device *ndev)
+static void qtnf_netdev_tx_timeout(struct net_device *ndev, unsigned int t=
xqueue)
 {
 =09struct qtnf_vif *vif =3D qtnf_netdev_get_priv(ndev);
 =09struct qtnf_wmac *mac;
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501=
_cs.c
index 007bf6803293..686161db8706 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1285,7 +1285,7 @@ static int wl3501_reset(struct net_device *dev)
 =09return rc;
 }
=20
-static void wl3501_tx_timeout(struct net_device *dev)
+static void wl3501_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct net_device_stats *stats =3D &dev->stats;
 =09int rc;
diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zyd=
as/zd1201.c
index 0db7362bedb4..41641fc2be74 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -830,7 +830,7 @@ static netdev_tx_t zd1201_hard_start_xmit(struct sk_buf=
f *skb,
 =09return NETDEV_TX_OK;
 }
=20
-static void zd1201_tx_timeout(struct net_device *dev)
+static void zd1201_tx_timeout(struct net_device *dev, unsigned int txqueue=
)
 {
 =09struct zd1201 *zd =3D netdev_priv(dev);
=20
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e4b55f9aa062..66e6db1f2c2c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1058,7 +1058,7 @@ void qeth_clear_working_pool_list(struct qeth_card *)=
;
 void qeth_drain_output_queues(struct qeth_card *card);
 void qeth_setadp_promisc_mode(struct qeth_card *card, bool enable);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
-void qeth_tx_timeout(struct net_device *);
+void qeth_tx_timeout(struct net_device *, unsigned int txqueue);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *=
iob,
 =09=09=09  u16 cmd_length);
 int qeth_query_switch_attributes(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core=
_main.c
index dda274351c21..e6272a5a86d0 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4263,7 +4263,7 @@ int qeth_set_access_ctrl_online(struct qeth_card *car=
d, int fallback)
 }
 EXPORT_SYMBOL_GPL(qeth_set_access_ctrl_online);
=20
-void qeth_tx_timeout(struct net_device *dev)
+void qeth_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct qeth_card *card;
=20
diff --git a/drivers/staging/ks7010/ks_wlan_net.c b/drivers/staging/ks7010/=
ks_wlan_net.c
index 3cffc8be6656..211dd4a11cac 100644
--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ b/drivers/staging/ks7010/ks_wlan_net.c
@@ -45,7 +45,7 @@ struct wep_key {
  *=09function prototypes
  */
 static int ks_wlan_open(struct net_device *dev);
-static void ks_wlan_tx_timeout(struct net_device *dev);
+static void ks_wlan_tx_timeout(struct net_device *dev, unsigned int txqueu=
e);
 static int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *dev)=
;
 static int ks_wlan_close(struct net_device *dev);
 static void ks_wlan_set_rx_mode(struct net_device *dev);
@@ -2498,7 +2498,7 @@ int ks_wlan_set_mac_address(struct net_device *dev, v=
oid *addr)
 }
=20
 static
-void ks_wlan_tx_timeout(struct net_device *dev)
+void ks_wlan_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct ks_wlan_private *priv =3D netdev_priv(dev);
=20
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_m=
ain.c
index 6cae33072496..b9315838f2cd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4436,7 +4436,7 @@ static int qlge_set_mac_address(struct net_device *nd=
ev, void *p)
 =09return status;
 }
=20
-static void qlge_tx_timeout(struct net_device *ndev)
+static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 =09struct ql_adapter *qdev =3D netdev_priv(ndev);
 =09ql_queue_asic_error(qdev);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging=
/rtl8192e/rtl8192e/rtl_core.c
index f932cb15e4e5..e74e337aaaa7 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -267,7 +267,7 @@ static short _rtl92e_check_nic_enough_desc(struct net_d=
evice *dev, int prio)
 =09return 0;
 }
=20
-static void _rtl92e_tx_timeout(struct net_device *dev)
+static void _rtl92e_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct r8192_priv *priv =3D rtllib_priv(dev);
=20
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl81=
92u/r8192U_core.c
index 2821411878ce..58c8ac44a192 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -654,7 +654,7 @@ short check_nic_enough_desc(struct net_device *dev, int=
 queue_index)
 =09return (used < MAX_TX_URB);
 }
=20
-static void tx_timeout(struct net_device *dev)
+static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09struct r8192_priv *priv =3D ieee80211_priv(dev);
=20
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/stag=
ing/unisys/visornic/visornic_main.c
index 1d1440d43002..0433536930a9 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -1078,7 +1078,7 @@ static void visornic_set_multi(struct net_device *net=
dev)
  * Queue the work and return. Make sure we have not already been informed =
that
  * the IO Partition is gone; if so, we will have already timed-out the xmi=
ts.
  */
-static void visornic_xmit_timeout(struct net_device *netdev)
+static void visornic_xmit_timeout(struct net_device *netdev, unsigned int =
txqueue)
 {
 =09struct visornic_devdata *devdata =3D netdev_priv(netdev);
 =09unsigned long flags;
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-=
ng/p80211netdev.c
index a70fb84f38f1..b809c0015c0c 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -101,7 +101,7 @@ static void p80211knetdev_set_multicast_list(struct net=
_device *dev);
 static int p80211knetdev_do_ioctl(struct net_device *dev, struct ifreq *if=
r,
 =09=09=09=09  int cmd);
 static int p80211knetdev_set_mac_address(struct net_device *dev, void *add=
r);
-static void p80211knetdev_tx_timeout(struct net_device *netdev);
+static void p80211knetdev_tx_timeout(struct net_device *netdev, unsigned i=
nt txqueue);
 static int p80211_rx_typedrop(struct wlandevice *wlandev, u16 fc);
=20
 int wlan_watchdog =3D 5000;
@@ -1074,7 +1074,7 @@ static int p80211_rx_typedrop(struct wlandevice *wlan=
dev, u16 fc)
 =09return drop;
 }
=20
-static void p80211knetdev_tx_timeout(struct net_device *netdev)
+static void p80211knetdev_tx_timeout(struct net_device *netdev, unsigned i=
nt txqueue)
 {
 =09struct wlandevice *wlandev =3D netdev->ml_priv;
=20
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 36a3eb4ad4c5..f1c90fa2978e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2704,7 +2704,7 @@ static netdev_tx_t gsm_mux_net_start_xmit(struct sk_b=
uff *skb,
 }
=20
 /* called when a packet did not ack after watchdogtimeout */
-static void gsm_mux_net_tx_timeout(struct net_device *net)
+static void gsm_mux_net_tx_timeout(struct net_device *net, unsigned int tx=
queue)
 {
 =09/* Tell syslog we are hosed. */
 =09dev_dbg(&net->dev, "Tx timed out.\n");
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 84f26e43b229..61dc6b4a43d0 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -7837,7 +7837,7 @@ static int hdlcdev_ioctl(struct net_device *dev, stru=
ct ifreq *ifr, int cmd)
  *
  * dev  pointer to network device structure
  */
-static void hdlcdev_tx_timeout(struct net_device *dev)
+static void hdlcdev_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct mgsl_struct *info =3D dev_to_port(dev);
 =09unsigned long flags;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index e8a9047de451..5d59e2369c8a 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1682,7 +1682,7 @@ static int hdlcdev_ioctl(struct net_device *dev, stru=
ct ifreq *ifr, int cmd)
  *
  * dev  pointer to network device structure
  */
-static void hdlcdev_tx_timeout(struct net_device *dev)
+static void hdlcdev_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09struct slgt_info *info =3D dev_to_port(dev);
 =09unsigned long flags;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index fcb91bf7a15b..33181fa6eb18 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -1807,7 +1807,7 @@ static int hdlcdev_ioctl(struct net_device *dev, stru=
ct ifreq *ifr, int cmd)
  *
  * dev  pointer to network device structure
  */
-static void hdlcdev_tx_timeout(struct net_device *dev)
+static void hdlcdev_tx_timeout(struct net_device *dev, unsigned int txqueu=
e)
 {
 =09SLMP_INFO *info =3D dev_to_port(dev);
 =09unsigned long flags;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c20f190b4c18..bae89635fee9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1004,7 +1004,7 @@ struct tlsdev_ops;
  *=09Called when a user wants to change the Maximum Transfer Unit
  *=09of a device.
  *
- * void (*ndo_tx_timeout)(struct net_device *dev);
+ * void (*ndo_tx_timeout)(struct net_device *dev, unsigned int txqueue);
  *=09Callback used when the transmitter has not made any progress
  *=09for dev->watchdog ticks.
  *
@@ -1271,7 +1271,8 @@ struct net_device_ops {
 =09=09=09=09=09=09  int new_mtu);
 =09int=09=09=09(*ndo_neigh_setup)(struct net_device *dev,
 =09=09=09=09=09=09   struct neigh_parms *);
-=09void=09=09=09(*ndo_tx_timeout) (struct net_device *dev);
+=09void=09=09=09(*ndo_tx_timeout) (struct net_device *dev,
+=09=09=09=09=09=09   unsigned int txqueue);
=20
 =09void=09=09=09(*ndo_get_stats64)(struct net_device *dev,
 =09=09=09=09=09=09   struct rtnl_link_stats64 *storage);
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index d8860f2d0976..b0bff3083278 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -253,7 +253,7 @@ extern int usbnet_open(struct net_device *net);
 extern int usbnet_stop(struct net_device *net);
 extern netdev_tx_t usbnet_start_xmit(struct sk_buff *skb,
 =09=09=09=09     struct net_device *net);
-extern void usbnet_tx_timeout(struct net_device *net);
+extern void usbnet_tx_timeout(struct net_device *net, unsigned int txqueue=
);
 extern int usbnet_change_mtu(struct net_device *net, int new_mtu);
=20
 extern int usbnet_get_endpoints(struct usbnet *, struct usb_interface *);
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 5a77c235a212..b57368e70aab 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -194,7 +194,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 =09dev->stats.tx_bytes +=3D skb->len;
 }
=20
-static void lec_tx_timeout(struct net_device *dev)
+static void lec_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09pr_info("%s\n", dev->name);
 =09netif_trans_update(dev);
diff --git a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
index 1d4d7d415730..cc1cff63194f 100644
--- a/net/bluetooth/bnep/netdev.c
+++ b/net/bluetooth/bnep/netdev.c
@@ -112,7 +112,7 @@ static int bnep_net_set_mac_addr(struct net_device *dev=
, void *arg)
 =09return 0;
 }
=20
-static void bnep_net_timeout(struct net_device *dev)
+static void bnep_net_timeout(struct net_device *dev, unsigned int txqueue)
 {
 =09BT_DBG("net_timeout");
 =09netif_wake_queue(dev);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8769b4b8807d..794b656b48c7 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -446,7 +446,7 @@ static void dev_watchdog(struct timer_list *t)
 =09=09=09=09trace_net_dev_xmit_timeout(dev, i);
 =09=09=09=09WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit que=
ue %u timed out\n",
 =09=09=09=09       dev->name, netdev_drivername(dev), i);
-=09=09=09=09dev->netdev_ops->ndo_tx_timeout(dev);
+=09=09=09=09dev->netdev_ops->ndo_tx_timeout(dev, i);
 =09=09=09}
 =09=09=09if (!mod_timer(&dev->watchdog_timer,
 =09=09=09=09       round_jiffies(jiffies +

