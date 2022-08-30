Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45A5A6E44
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiH3UQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiH3UQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:16:26 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE8066117
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 13:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-type:content-transfer-encoding; s=k1; bh=Z
        /990+DQA2pI+mpyRTqfrQr3tz4rAI6oR5vEZawmfSU=; b=GrlXlZW7j4gubkE8c
        h0ls1CpJj+3wOdE2XQ53jHFLPVgA+wmDcTgfYXe3fuDuktaUbwCny7vR4ZR2d9zN
        ghrBP2s7Z4IP9eDyyP6SRsMuga2Pt31AUiRFv3B1IUyB63/gfeq7davfhNCt4OkI
        GKWV91euzAr4wnZkBf+LsuAlFA=
Received: (qmail 423081 invoked from network); 30 Aug 2022 22:15:15 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 30 Aug 2022 22:15:15 +0200
X-UD-Smtp-Session: l3s3148p1@fSXQCXvnkqcgAwDtxxrgAFH1RcxMblwv
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-kernel@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Petr Machata <petrm@nvidia.com>,
        Geoff Levand <geoff@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shay Agroskin <shayagr@amazon.com>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <klassert@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Russell King <linux@armlinux.org.uk>,
        Ion Badulescu <ionut@badula.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Don Fry <pcnet32@frontier.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Chris Snook <chris.snook@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Doug Berger <opendmb@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Li Yang <leoyang.li@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nick Child <nnac123@linux.ibm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Chris Lee <christopher.lee@cspi.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Rahul Verma <rahulv@marvell.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        Jiri Pirko <jiri@resnulli.us>,
        Byungho An <bh74.an@samsung.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Daniele Venzano <venza@brownhat.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Chessman <chessman@tux.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Kevin Brace <kevinbrace@bracecomputerlab.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-acenic@sunsite.dk, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-wired-lan@lists.osuosl.org,
        linux-mediatek@lists.infradead.org, linux-rdma@vger.kernel.org,
        oss-drivers@corigine.com, linux-mips@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 3/3] net: ethernet: move from strlcpy with unused retval to strscpy
Date:   Tue, 30 Aug 2022 22:14:54 +0200
Message-Id: <20220830201457.7984-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830201457.7984-1-wsa+renesas@sang-engineering.com>
References: <20220830201457.7984-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the below link and prefer 'strscpy' in this
subsystem. Conversion is 1:1 because the return value is not used.
Generated by a coccinelle script.

Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Petr Machata <petrm@nvidia.com> # For drivers/net/ethernet/mellanox/mlxsw
Acked-by: Geoff Levand <geoff@infradead.org> # For ps3_gelic_net and spider_net_ethtool
Acked-by: Tom Lendacky <thomas.lendacky@amd.com> # For drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
Acked-by: Marcin Wojtas <mw@semihalf.com> # For drivers/net/ethernet/marvell/mvpp2
Reviewed-by: Leon Romanovsky <leonro@nvidia.com> # For drivers/net/ethernet/mellanox/mlx{4|5}
Reviewed-by: Shay Agroskin <shayagr@amazon.com> # For drivers/net/ethernet/amazon/ena
Acked-by: Krzysztof Hałasa <khalasa@piap.pl> # For IXP4xx Ethernet
---

Changes since v1:
* split into smaller patches
* added given tags

 drivers/net/ethernet/3com/3c509.c                |  2 +-
 drivers/net/ethernet/3com/3c515.c                |  2 +-
 drivers/net/ethernet/3com/3c589_cs.c             |  2 +-
 drivers/net/ethernet/3com/3c59x.c                |  6 +++---
 drivers/net/ethernet/3com/typhoon.c              |  8 ++++----
 drivers/net/ethernet/8390/ax88796.c              |  6 +++---
 drivers/net/ethernet/8390/etherh.c               |  6 +++---
 drivers/net/ethernet/adaptec/starfire.c          |  4 ++--
 drivers/net/ethernet/aeroflex/greth.c            |  4 ++--
 drivers/net/ethernet/agere/et131x.c              |  4 ++--
 drivers/net/ethernet/alacritech/slicoss.c        |  4 ++--
 drivers/net/ethernet/allwinner/sun4i-emac.c      |  4 ++--
 drivers/net/ethernet/alteon/acenic.c             |  4 ++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    |  4 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  2 +-
 drivers/net/ethernet/amd/amd8111e.c              |  4 ++--
 drivers/net/ethernet/amd/au1000_eth.c            |  2 +-
 drivers/net/ethernet/amd/nmclan_cs.c             |  2 +-
 drivers/net/ethernet/amd/pcnet32.c               |  4 ++--
 drivers/net/ethernet/amd/sunlance.c              |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c     |  4 ++--
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c  |  2 +-
 drivers/net/ethernet/arc/emac_main.c             |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c            |  4 ++--
 .../net/ethernet/atheros/atl1c/atl1c_ethtool.c   |  4 ++--
 .../net/ethernet/atheros/atl1e/atl1e_ethtool.c   |  6 +++---
 drivers/net/ethernet/atheros/atlx/atl1.c         |  4 ++--
 drivers/net/ethernet/atheros/atlx/atl2.c         |  6 +++---
 drivers/net/ethernet/broadcom/b44.c              |  6 +++---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c     |  4 ++--
 drivers/net/ethernet/broadcom/bcmsysport.c       |  4 ++--
 drivers/net/ethernet/broadcom/bgmac.c            |  6 +++---
 drivers/net/ethernet/broadcom/bnx2.c             |  6 +++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c  |  6 +++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.h    |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c    |  8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c    |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   |  2 +-
 drivers/net/ethernet/broadcom/tg3.c              |  6 +++---
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c  |  6 +++---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |  2 +-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c  |  4 ++--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c        |  4 ++--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c  |  4 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c   |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c  |  4 ++--
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c  |  4 ++--
 .../chelsio/inline_crypto/chtls/chtls_main.c     |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c         |  2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c   |  6 +++---
 drivers/net/ethernet/davicom/dm9000.c            |  4 ++--
 drivers/net/ethernet/dec/tulip/de2104x.c         |  4 ++--
 drivers/net/ethernet/dec/tulip/dmfe.c            |  4 ++--
 drivers/net/ethernet/dec/tulip/tulip_core.c      |  4 ++--
 drivers/net/ethernet/dec/tulip/uli526x.c         |  4 ++--
 drivers/net/ethernet/dec/tulip/winbond-840.c     |  4 ++--
 drivers/net/ethernet/dlink/dl2k.c                |  4 ++--
 drivers/net/ethernet/dlink/sundance.c            |  4 ++--
 drivers/net/ethernet/dnet.c                      |  4 ++--
 drivers/net/ethernet/emulex/benet/be_cmds.c      | 12 ++++++------
 drivers/net/ethernet/emulex/benet/be_ethtool.c   |  6 +++---
 drivers/net/ethernet/faraday/ftgmac100.c         |  4 ++--
 drivers/net/ethernet/faraday/ftmac100.c          |  4 ++--
 drivers/net/ethernet/fealnx.c                    |  4 ++--
 .../net/ethernet/freescale/dpaa/dpaa_ethtool.c   |  4 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  2 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c |  4 ++--
 drivers/net/ethernet/freescale/fec_main.c        |  8 ++++----
 drivers/net/ethernet/freescale/fec_ptp.c         |  2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  2 +-
 .../net/ethernet/freescale/ucc_geth_ethtool.c    |  4 ++--
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c        |  4 ++--
 drivers/net/ethernet/hisilicon/hip04_eth.c       |  4 ++--
 drivers/net/ethernet/ibm/ehea/ehea_ethtool.c     |  4 ++--
 drivers/net/ethernet/ibm/emac/core.c             |  4 ++--
 drivers/net/ethernet/ibm/ibmveth.c               |  4 ++--
 drivers/net/ethernet/intel/e100.c                |  4 ++--
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |  4 ++--
 drivers/net/ethernet/intel/e1000e/ethtool.c      |  4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c       |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_main.c      | 16 ++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_ptp.c       |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c   |  6 +++---
 drivers/net/ethernet/intel/igb/igb_ethtool.c     |  6 +++---
 drivers/net/ethernet/intel/igb/igb_main.c        |  2 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c       |  4 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c   |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |  6 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  4 ++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c     |  4 ++--
 drivers/net/ethernet/jme.c                       |  6 +++---
 drivers/net/ethernet/korina.c                    |  6 +++---
 drivers/net/ethernet/marvell/mv643xx_eth.c       |  8 ++++----
 drivers/net/ethernet/marvell/mvneta.c            |  6 +++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  6 +++---
 .../marvell/octeontx2/nic/otx2_ethtool.c         |  8 ++++----
 .../ethernet/marvell/prestera/prestera_ethtool.c |  4 ++--
 drivers/net/ethernet/marvell/pxa168_eth.c        |  8 ++++----
 drivers/net/ethernet/marvell/skge.c              |  6 +++---
 drivers/net/ethernet/marvell/sky2.c              |  6 +++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c      |  4 ++--
 drivers/net/ethernet/mediatek/mtk_star_emac.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c  |  6 +++---
 drivers/net/ethernet/mellanox/mlx4/fw.c          |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c       |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c    |  4 ++--
 .../ethernet/mellanox/mlxsw/spectrum_ethtool.c   |  6 +++---
 drivers/net/ethernet/micrel/ks8851_common.c      |  6 +++---
 drivers/net/ethernet/micrel/ksz884x.c            |  6 +++---
 drivers/net/ethernet/microchip/enc28j60.c        |  6 +++---
 drivers/net/ethernet/microchip/encx24j600.c      |  6 +++---
 drivers/net/ethernet/microchip/lan743x_ethtool.c |  4 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |  8 ++++----
 drivers/net/ethernet/natsemi/natsemi.c           |  6 +++---
 drivers/net/ethernet/natsemi/ns83820.c           |  6 +++---
 drivers/net/ethernet/neterion/s2io.c             |  6 +++---
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c |  6 +++---
 drivers/net/ethernet/ni/nixge.c                  |  4 ++--
 drivers/net/ethernet/nvidia/forcedeth.c          |  6 +++---
 drivers/net/ethernet/nxp/lpc_eth.c               |  6 +++---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c  |  6 +++---
 drivers/net/ethernet/packetengines/hamachi.c     |  6 +++---
 drivers/net/ethernet/packetengines/yellowfin.c   |  6 +++---
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c  |  6 +++---
 drivers/net/ethernet/qlogic/qed/qed_int.c        |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c  |  4 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c     |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c            |  6 +++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c  |  6 +++---
 drivers/net/ethernet/qualcomm/qca_debug.c        |  8 ++++----
 drivers/net/ethernet/rdc/r6040.c                 |  6 +++---
 drivers/net/ethernet/realtek/8139cp.c            |  6 +++---
 drivers/net/ethernet/realtek/8139too.c           |  6 +++---
 drivers/net/ethernet/realtek/r8169_main.c        |  6 +++---
 drivers/net/ethernet/rocker/rocker_main.c        |  4 ++--
 .../net/ethernet/samsung/sxgbe/sxgbe_ethtool.c   |  4 ++--
 drivers/net/ethernet/sfc/efx.c                   |  2 +-
 drivers/net/ethernet/sfc/efx_common.c            |  2 +-
 drivers/net/ethernet/sfc/ethtool_common.c        |  6 +++---
 drivers/net/ethernet/sfc/falcon/efx.c            |  4 ++--
 drivers/net/ethernet/sfc/falcon/ethtool.c        |  8 ++++----
 drivers/net/ethernet/sfc/falcon/falcon.c         |  2 +-
 drivers/net/ethernet/sfc/falcon/nic.c            |  2 +-
 drivers/net/ethernet/sfc/mcdi_mon.c              |  2 +-
 drivers/net/ethernet/sfc/nic.c                   |  2 +-
 drivers/net/ethernet/sfc/siena/efx.c             |  2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c      |  2 +-
 drivers/net/ethernet/sfc/siena/ethtool_common.c  |  6 +++---
 drivers/net/ethernet/sfc/siena/mcdi_mon.c        |  2 +-
 drivers/net/ethernet/sfc/siena/nic.c             |  2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c              |  6 +++---
 drivers/net/ethernet/sis/sis190.c                |  6 +++---
 drivers/net/ethernet/sis/sis900.c                |  6 +++---
 drivers/net/ethernet/smsc/epic100.c              |  6 +++---
 drivers/net/ethernet/smsc/smc911x.c              |  6 +++---
 drivers/net/ethernet/smsc/smc91c92_cs.c          |  4 ++--
 drivers/net/ethernet/smsc/smc91x.c               |  6 +++---
 drivers/net/ethernet/smsc/smsc911x.c             |  6 +++---
 drivers/net/ethernet/smsc/smsc9420.c             |  6 +++---
 drivers/net/ethernet/socionext/netsec.c          |  4 ++--
 drivers/net/ethernet/socionext/sni_ave.c         |  4 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  8 ++++----
 drivers/net/ethernet/sun/cassini.c               |  6 +++---
 drivers/net/ethernet/sun/ldmvsw.c                |  4 ++--
 drivers/net/ethernet/sun/niu.c                   |  6 +++---
 drivers/net/ethernet/sun/sunbmac.c               |  4 ++--
 drivers/net/ethernet/sun/sungem.c                |  6 +++---
 drivers/net/ethernet/sun/sunhme.c                |  6 +++---
 drivers/net/ethernet/sun/sunqe.c                 |  4 ++--
 drivers/net/ethernet/sun/sunvnet.c               |  4 ++--
 .../net/ethernet/synopsys/dwc-xlgmac-common.c    |  4 ++--
 .../net/ethernet/synopsys/dwc-xlgmac-ethtool.c   |  6 +++---
 drivers/net/ethernet/tehuti/tehuti.c             |  8 ++++----
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c      |  4 ++--
 drivers/net/ethernet/ti/cpmac.c                  |  4 ++--
 drivers/net/ethernet/ti/cpsw.c                   |  6 +++---
 drivers/net/ethernet/ti/cpsw_new.c               |  6 +++---
 drivers/net/ethernet/ti/davinci_emac.c           |  4 ++--
 drivers/net/ethernet/ti/tlan.c                   |  6 +++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c     |  4 ++--
 .../net/ethernet/toshiba/spider_net_ethtool.c    |  8 ++++----
 drivers/net/ethernet/toshiba/tc35815.c           |  6 +++---
 drivers/net/ethernet/via/via-rhine.c             |  4 ++--
 drivers/net/ethernet/via/via-velocity.c          |  8 ++++----
 drivers/net/ethernet/wiznet/w5100.c              |  6 +++---
 drivers/net/ethernet/wiznet/w5300.c              |  6 +++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c    |  4 ++--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c    |  2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c         |  2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c         |  4 ++--
 199 files changed, 457 insertions(+), 457 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 846fa3af4504..fb68339e1511 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -1135,7 +1135,7 @@ el3_netdev_set_ecmd(struct net_device *dev,
 
 static void el3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 }
 
 static int el3_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 1d124b0f65e7..d2f4358cc550 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -1527,7 +1527,7 @@ static void set_rx_mode(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "ISA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index 4673bc1604e7..82f94b1635bf 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -480,7 +480,7 @@ static void tc589_reset(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index ccf07667aa5e..082388bb6169 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2959,13 +2959,13 @@ static void vortex_get_drvinfo(struct net_device *dev,
 {
 	struct vortex_private *vp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	if (VORTEX_PCI(vp)) {
-		strlcpy(info->bus_info, pci_name(VORTEX_PCI(vp)),
+		strscpy(info->bus_info, pci_name(VORTEX_PCI(vp)),
 			sizeof(info->bus_info));
 	} else {
 		if (VORTEX_EISA(vp))
-			strlcpy(info->bus_info, dev_name(vp->gendev),
+			strscpy(info->bus_info, dev_name(vp->gendev),
 				sizeof(info->bus_info));
 		else
 			snprintf(info->bus_info, sizeof(info->bus_info),
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index cad4f354cc76..aaaff3ba43ef 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -969,12 +969,12 @@ typhoon_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 
 	smp_rmb();
 	if (tp->card_state == Sleeping) {
-		strlcpy(info->fw_version, "Sleep image",
+		strscpy(info->fw_version, "Sleep image",
 			sizeof(info->fw_version));
 	} else {
 		INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_READ_VERSIONS);
 		if (typhoon_issue_command(tp, 1, &xp_cmd, 3, xp_resp) < 0) {
-			strlcpy(info->fw_version, "Unknown runtime",
+			strscpy(info->fw_version, "Unknown runtime",
 				sizeof(info->fw_version));
 		} else {
 			u32 sleep_ver = le32_to_cpu(xp_resp[0].parm2);
@@ -984,8 +984,8 @@ typhoon_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 		}
 	}
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 1f8acbba5b6b..af603256b724 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -579,9 +579,9 @@ static void ax_get_drvinfo(struct net_device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev->dev.parent);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static u32 ax_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index e7b879123bb1..05d39ecb97ff 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -555,9 +555,9 @@ static int __init etherm_addr(char *addr)
 
 static void etherh_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 8f0a6b9c518e..857361c74f5d 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1844,8 +1844,8 @@ static int check_if_running(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 447dc64a17e5..9c4fe25aca6c 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1112,9 +1112,9 @@ static void greth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *in
 {
 	struct greth_private *greth = netdev_priv(dev);
 
-	strlcpy(info->driver, dev_driver_string(greth->dev),
+	strscpy(info->driver, dev_driver_string(greth->dev),
 		sizeof(info->driver));
-	strlcpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
 }
 
 static void greth_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index d19d1579c415..28334b1e3d6b 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2952,8 +2952,8 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index ce353b0c02a3..4cea61f16be3 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1531,8 +1531,8 @@ static void slic_get_drvinfo(struct net_device *dev,
 {
 	struct slic_device *sdev = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(sdev->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(sdev->pdev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops slic_ethtool_ops = {
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 621ce742ad21..a94c62956eed 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -331,8 +331,8 @@ static int emac_dma_inblk_32bit(struct emac_board_info *db,
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
 }
 
 static u32 emac_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 22fe98555b24..d7762da8b2c0 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2691,12 +2691,12 @@ static void ace_get_drvinfo(struct net_device *dev,
 {
 	struct ace_private *ap = netdev_priv(dev);
 
-	strlcpy(info->driver, "acenic", sizeof(info->driver));
+	strscpy(info->driver, "acenic", sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->version), "%i.%i.%i",
 		 ap->firmware_major, ap->firmware_minor, ap->firmware_fix);
 
 	if (ap->pdev)
-		strlcpy(info->bus_info, pci_name(ap->pdev),
+		strscpy(info->bus_info, pci_name(ap->pdev),
 			sizeof(info->bus_info));
 
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 39242c5a1729..98d6386b7f39 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -462,8 +462,8 @@ static void ena_get_drvinfo(struct net_device *dev,
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..371269e0b2b9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3166,7 +3166,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pd
 	host_info->bdf = (pdev->bus->number << 8) | pdev->devfn;
 	host_info->os_type = ENA_ADMIN_OS_LINUX;
 	host_info->kernel_ver = LINUX_VERSION_CODE;
-	strlcpy(host_info->kernel_ver_str, utsname()->version,
+	strscpy(host_info->kernel_ver_str, utsname()->version,
 		sizeof(host_info->kernel_ver_str) - 1);
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 5d1baa01360f..fb6a5f64d221 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1364,10 +1364,10 @@ static void amd8111e_get_drvinfo(struct net_device *dev,
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	struct pci_dev *pci_dev = lp->pci_dev;
-	strlcpy(info->driver, MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, MODULE_NAME, sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version),
 		"%u", chip_version);
-	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
 }
 
 static int amd8111e_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index d5f2c6989221..81d5af00d30d 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -650,7 +650,7 @@ au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct au1000_private *aup = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s %d", DRV_NAME,
 		 aup->mac_id);
 }
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 30ee5329bd7c..df8874bd619a 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -815,7 +815,7 @@ static int mace_close(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index b5ff47283cfe..c9138175ec07 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -797,9 +797,9 @@ static void pcnet32_get_drvinfo(struct net_device *dev,
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	if (lp->pci_dev)
-		strlcpy(info->bus_info, pci_name(lp->pci_dev),
+		strscpy(info->bus_info, pci_name(lp->pci_dev),
 			sizeof(info->bus_info));
 	else
 		snprintf(info->bus_info, sizeof(info->bus_info),
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 22d609563af8..4ed2ebbf9ff7 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1276,7 +1276,7 @@ static void lance_free_hwresources(struct lance_private *lp)
 /* Ethtool support... */
 static void sparc_lance_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "sunlance", sizeof(info->driver));
+	strscpy(info->driver, "sunlance", sizeof(info->driver));
 }
 
 static const struct ethtool_ops sparc_lance_ethtool_ops = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 6ceb1cdf6eba..6e83ff59172a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -402,8 +402,8 @@ static void xgbe_get_drvinfo(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_features *hw_feat = &pdata->hw_feat;
 
-	strlcpy(drvinfo->driver, XGBE_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(pdata->dev),
+	strscpy(drvinfo->driver, XGBE_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(pdata->dev),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "%d.%d.%d",
 		 XGMAC_GET_BITS(hw_feat->version, MAC_VR, USERVER),
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 1daecd483b8d..a08f221e30d4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -238,7 +238,7 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 		 "%u.%u.%u", firmware_version >> 24,
 		 (firmware_version >> 16) & 0xFFU, firmware_version & 0xFFFFU);
 
-	strlcpy(drvinfo->bus_info, pdev ? pci_name(pdev) : "",
+	strscpy(drvinfo->bus_info, pdev ? pci_name(pdev) : "",
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_stats = aq_ethtool_n_stats(ndev);
 	drvinfo->testinfo_len = 0;
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 288e2961823e..ba0646b3b122 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -91,7 +91,7 @@ static void arc_emac_get_drvinfo(struct net_device *ndev,
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 
-	strlcpy(info->driver, priv->drv_name, sizeof(info->driver));
+	strscpy(info->driver, priv->drv_name, sizeof(info->driver));
 }
 
 static const struct ethtool_ops arc_emac_ethtool_ops = {
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index e461f4764066..cc932b3cf873 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -451,8 +451,8 @@ static void ag71xx_get_drvinfo(struct net_device *ndev,
 {
 	struct ag71xx *ag = netdev_priv(ndev);
 
-	strlcpy(info->driver, "ag71xx", sizeof(info->driver));
-	strlcpy(info->bus_info, of_node_full_name(ag->pdev->dev.of_node),
+	strscpy(info->driver, "ag71xx", sizeof(info->driver));
+	strscpy(info->bus_info, of_node_full_name(ag->pdev->dev.of_node),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
index e2eb7b8c63a0..0bce122c68f1 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
@@ -220,8 +220,8 @@ static void atl1c_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
index 0cbde352d1ba..68f1832a198d 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
@@ -306,9 +306,9 @@ static void atl1e_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl1e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "L1e", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver,  atl1e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, "L1e", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index ff1fe09abf9f..7fcfba370fc3 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3340,8 +3340,8 @@ static void atl1_get_drvinfo(struct net_device *netdev,
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index bbc4d7b08a49..1b487c071cb6 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1980,9 +1980,9 @@ static void atl2_get_drvinfo(struct net_device *netdev,
 {
 	struct atl2_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  atl2_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "L2", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver,  atl2_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, "L2", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index e5857e88c207..7821084c8fbe 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1790,13 +1790,13 @@ static void b44_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *inf
 	struct b44 *bp = netdev_priv(dev);
 	struct ssb_bus *bus = bp->sdev->bus;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 	switch (bus->bustype) {
 	case SSB_BUSTYPE_PCI:
-		strlcpy(info->bus_info, pci_name(bus->host_pci), sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(bus->host_pci), sizeof(info->bus_info));
 		break;
 	case SSB_BUSTYPE_SSB:
-		strlcpy(info->bus_info, "SSB", sizeof(info->bus_info));
+		strscpy(info->bus_info, "SSB", sizeof(info->bus_info));
 		break;
 	case SSB_BUSTYPE_PCMCIA:
 	case SSB_BUSTYPE_SDIO:
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 1c6aea12db72..d91fdb0c2649 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1321,8 +1321,8 @@ static const u32 unused_mib_regs[] = {
 static void bcm_enet_get_drvinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, bcm_enet_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, "bcm63xx", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->driver, bcm_enet_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, "bcm63xx", sizeof(drvinfo->bus_info));
 }
 
 static int bcm_enet_get_sset_count(struct net_device *netdev,
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 47fc8e6963d5..52144ea2bbf3 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -308,8 +308,8 @@ static const struct bcm_sysport_stats bcm_sysport_gstrings_stats[] = {
 static void bcm_sysport_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "platform", sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, "platform", sizeof(info->bus_info));
 }
 
 static u32 bcm_sysport_get_msglvl(struct net_device *dev)
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 93580484a3f4..29a9ab20ff98 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1367,7 +1367,7 @@ static void bgmac_get_strings(struct net_device *dev, u32 stringset,
 		return;
 
 	for (i = 0; i < BGMAC_STATS_LEN; i++)
-		strlcpy(data + i * ETH_GSTRING_LEN,
+		strscpy(data + i * ETH_GSTRING_LEN,
 			bgmac_get_strings_stats[i].name, ETH_GSTRING_LEN);
 }
 
@@ -1395,8 +1395,8 @@ static void bgmac_get_ethtool_stats(struct net_device *dev,
 static void bgmac_get_drvinfo(struct net_device *net_dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "AXI", sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, "AXI", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops bgmac_ethtool_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b97ed9b5f685..b612781be893 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7042,9 +7042,9 @@ bnx2_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
-	strlcpy(info->fw_version, bp->fw_version, sizeof(info->fw_version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->fw_version, bp->fw_version, sizeof(info->fw_version));
 }
 
 #define BNX2_REGDUMP_LEN		(32 * 1024)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..e704e42446aa 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -150,7 +150,7 @@ void bnx2x_fill_fw_str(struct bnx2x *bp, char *buf, size_t buf_len)
 		phy_fw_ver[0] = '\0';
 		bnx2x_get_ext_phy_fw_version(&bp->link_params,
 					     phy_fw_ver, PHY_FW_VER_LEN);
-		strlcpy(buf, bp->fw_ver, buf_len);
+		strscpy(buf, bp->fw_ver, buf_len);
 		snprintf(buf + strlen(bp->fw_ver), 32 - strlen(bp->fw_ver),
 			 "bc %d.%d.%d%s%s",
 			 (bp->common.bc_ver & 0xff0000) >> 16,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 0e319ac7799f..bda3ccc28eca 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1112,7 +1112,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 	int ext_dev_info_offset;
 	u32 mbi;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 
 	if (SHMEM2_HAS(bp, extended_dev_info_shared_addr)) {
 		ext_dev_info_offset = SHMEM2_RD(bp,
@@ -1126,7 +1126,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 				 (mbi & 0xff000000) >> 24,
 				 (mbi & 0x00ff0000) >> 16,
 				 (mbi & 0x0000ff00) >> 8);
-			strlcpy(info->fw_version, version,
+			strscpy(info->fw_version, version,
 				sizeof(info->fw_version));
 		}
 	}
@@ -1135,7 +1135,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 	bnx2x_fill_fw_str(bp, version, ETHTOOL_FWVERS_LEN);
 	strlcat(info->fw_version, version, sizeof(info->fw_version));
 
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
 }
 
 static void bnx2x_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 962253db25b8..51b1690fd045 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3385,7 +3385,7 @@ static void bnx2x_drv_info_ether_stat(struct bnx2x *bp)
 		&bp->sp_objs->mac_obj;
 	int i;
 
-	strlcpy(ether_stat->version, DRV_MODULE_VERSION,
+	strscpy(ether_stat->version, DRV_MODULE_VERSION,
 		ETH_STAT_INFO_VERSION_LEN);
 
 	/* get DRV_INFO_ETH_STAT_NUM_MACS_REQUIRED macs, placing them in the
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index 2dac704dc346..02a4e557e176 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -518,7 +518,7 @@ int bnx2x_vfpf_storm_rx_mode(struct bnx2x *bp);
 static inline void bnx2x_vf_fill_fw_str(struct bnx2x *bp, char *buf,
 					size_t buf_len)
 {
-	strlcpy(buf, bp->acquire_resp.pfdev_info.fw_ver, buf_len);
+	strscpy(buf, bp->acquire_resp.pfdev_info.fw_ver, buf_len);
 }
 
 static inline int bnx2x_vf_ustorm_prods_offset(struct bnx2x *bp,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index c9129b9ba446..0657a0f5170f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -380,7 +380,7 @@ int bnx2x_vfpf_acquire(struct bnx2x *bp, u8 tx_count, u8 rx_count)
 	bp->igu_base_sb = bp->acquire_resp.resc.hw_sbs[0].hw_sb_id;
 	bp->vlan_credit = bp->acquire_resp.resc.num_vlan_filters;
 
-	strlcpy(bp->fw_ver, bp->acquire_resp.pfdev_info.fw_ver,
+	strscpy(bp->fw_ver, bp->acquire_resp.pfdev_info.fw_ver,
 		sizeof(bp->fw_ver));
 
 	if (is_valid_ether_addr(bp->acquire_resp.resc.current_mac_addr))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 87eb5362ad70..f57e524c7e30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1371,9 +1371,9 @@ static void bnxt_get_drvinfo(struct net_device *dev,
 {
 	struct bnxt *bp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->fw_version, bp->fw_ver_str, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->fw_version, bp->fw_ver_str, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
 	info->n_stats = bnxt_get_num_stats(bp);
 	info->testinfo_len = bp->num_tests;
 	/* TODO CHIMP_FW: eeprom dump details */
@@ -3876,7 +3876,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		} else if (i == BNXT_IRQ_TEST_IDX) {
 			strcpy(str, "Interrupt_test (offline)");
 		} else {
-			strlcpy(str, fw_str, ETH_GSTRING_LEN);
+			strscpy(str, fw_str, ETH_GSTRING_LEN);
 			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
 			if (test_info->offline_mask & (1 << i))
 				strncat(str, " (offline)",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index eb4803b11c0e..fcc65890820a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -222,7 +222,7 @@ static int bnxt_vf_rep_get_phys_port_name(struct net_device *dev, char *buf,
 static void bnxt_vf_rep_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int bnxt_vf_rep_get_port_parent_id(struct net_device *dev,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 8309fb993cdb..667e66079c73 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1146,7 +1146,7 @@ static const struct bcmgenet_stats bcmgenet_gstrings_stats[] = {
 static void bcmgenet_get_drvinfo(struct net_device *dev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "bcmgenet", sizeof(info->driver));
+	strscpy(info->driver, "bcmgenet", sizeof(info->driver));
 }
 
 static int bcmgenet_get_sset_count(struct net_device *dev, int string_set)
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index db1e9d810b41..1ff27c548e7a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12302,9 +12302,9 @@ static void tg3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->fw_version, tp->fw_ver, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(tp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->fw_version, tp->fw_ver, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(tp->pdev), sizeof(info->bus_info));
 }
 
 static void tg3_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 8aca768571b2..5d2c68ee1ea9 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -283,7 +283,7 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	struct bfa_ioc_attr *ioc_attr;
 	unsigned long flags;
 
-	strlcpy(drvinfo->driver, BNAD_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, BNAD_NAME, sizeof(drvinfo->driver));
 
 	ioc_attr = kzalloc(sizeof(*ioc_attr), GFP_KERNEL);
 	if (ioc_attr) {
@@ -291,12 +291,12 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 		bfa_nw_ioc_get_attr(&bnad->bna.ioceth.ioc, ioc_attr);
 		spin_unlock_irqrestore(&bnad->bna_lock, flags);
 
-		strlcpy(drvinfo->fw_version, ioc_attr->adapter_attr.fw_ver,
+		strscpy(drvinfo->fw_version, ioc_attr->adapter_attr.fw_ver,
 			sizeof(drvinfo->fw_version));
 		kfree(ioc_attr);
 	}
 
-	strlcpy(drvinfo->bus_info, pci_name(bnad->pcidev),
+	strscpy(drvinfo->bus_info, pci_name(bnad->pcidev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 103591dcea1c..369bfd376d6f 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1342,7 +1342,7 @@ static void octeon_mgmt_poll_controller(struct net_device *netdev)
 static void octeon_mgmt_get_drvinfo(struct net_device *netdev,
 				    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 }
 
 static int octeon_mgmt_nway_reset(struct net_device *dev)
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 5a9fad61e9ea..e5c71f907852 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -191,8 +191,8 @@ static void nicvf_get_drvinfo(struct net_device *netdev,
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(nic->pdev), sizeof(info->bus_info));
 }
 
 static u32 nicvf_get_msglevel(struct net_device *netdev)
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index f4054d2553ea..17043c4fce52 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -429,8 +429,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct adapter *adapter = dev->ml_priv;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 174b1e156669..a46afc0bf5cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1627,8 +1627,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	t3_get_tp_version(adapter, &tp_vers);
 	spin_unlock(&adapter->stats_lock);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	if (fw_vers)
 		snprintf(info->fw_version, sizeof(info->fw_version),
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 77897edd2bc0..8477a93cee6b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -199,8 +199,8 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct adapter *adapter = netdev2adap(dev);
 	u32 exprom_vers;
 
-	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	info->regdump_len = get_regs_len(dev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index d0061921529f..9cbce1faab26 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3903,8 +3903,8 @@ static void cxgb4_mgmt_get_drvinfo(struct net_device *dev,
 {
 	struct adapter *adapter = netdev2adap(dev);
 
-	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(adapter->pdev),
+	strscpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index c2822e635f89..54db79f4dcfe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1553,8 +1553,8 @@ static void cxgb4vf_get_drvinfo(struct net_device *dev,
 {
 	struct adapter *adapter = netdev2adap(dev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u.%u.%u, TP %u.%u.%u.%u",
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 9098b3eed4da..1e55b12fee51 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -193,7 +193,7 @@ static void chtls_register_dev(struct chtls_dev *cdev)
 {
 	struct tls_toe_device *tlsdev = &cdev->tlsdev;
 
-	strlcpy(tlsdev->name, "chtls", TLS_TOE_DEVICE_NAME_MAX);
+	strscpy(tlsdev->name, "chtls", TLS_TOE_DEVICE_NAME_MAX);
 	strlcat(tlsdev->name, cdev->lldi->ports[0]->name,
 		TLS_TOE_DEVICE_NAME_MAX);
 	tlsdev->feature = chtls_inline_feature;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 21ba6e893072..888506185326 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -689,7 +689,7 @@ static int ep93xx_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static void ep93xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int ep93xx_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 60d8c0fbc037..08b7cc0a1809 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -131,10 +131,10 @@ static void enic_get_drvinfo(struct net_device *netdev,
 	if (err == -ENOMEM)
 		return;
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, fw_info->fw_version,
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, fw_info->fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(enic->pdev),
+	strscpy(drvinfo->bus_info, pci_name(enic->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 0985ab216566..77229e53b04e 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -540,8 +540,8 @@ static void dm9000_get_drvinfo(struct net_device *dev,
 {
 	struct board_info *dm = to_dm9000_board(dev);
 
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, to_platform_device(dm->dev)->name,
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->bus_info, to_platform_device(dm->dev)->name,
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index d51b3d24a0c8..cd3dc4b89518 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -1606,8 +1606,8 @@ static void de_get_drvinfo (struct net_device *dev,struct ethtool_drvinfo *info)
 {
 	struct de_private *de = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(de->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(de->pdev), sizeof(info->bus_info));
 }
 
 static int de_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 83f1727d1423..3188ba7b450f 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -1074,8 +1074,8 @@ static void dmfe_ethtool_get_drvinfo(struct net_device *dev,
 {
 	struct dmfe_board_info *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int dmfe_ethtool_set_wol(struct net_device *dev,
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index b8e46c4849ef..ecfad43df45a 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -858,8 +858,8 @@ static struct net_device_stats *tulip_get_stats(struct net_device *dev)
 static void tulip_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct tulip_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 77d9058431e3..ff080ab0f116 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -971,8 +971,8 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct uli526x_board_info *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 1db19463fd46..37fba39c0056 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -1374,8 +1374,8 @@ static void netdev_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index a301f7e6a440..2c67a857a42f 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1235,8 +1235,8 @@ static void rio_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, "dl2k", sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "dl2k", sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int rio_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index 8dd7bf9014ec..43def191f26f 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1644,8 +1644,8 @@ static int check_if_running(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 92462ed87bc4..99e6f76f6cc0 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -725,8 +725,8 @@ static struct net_device_stats *dnet_get_stats(struct net_device *dev)
 static void dnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, "0", sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, "0", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops dnet_ethtool_ops = {
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index b4f5e57d0285..08ec84cd21c0 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1878,9 +1878,9 @@ int be_cmd_get_fw_ver(struct be_adapter *adapter)
 	if (!status) {
 		struct be_cmd_resp_get_fw_version *resp = embedded_payload(wrb);
 
-		strlcpy(adapter->fw_ver, resp->firmware_version_string,
+		strscpy(adapter->fw_ver, resp->firmware_version_string,
 			sizeof(adapter->fw_ver));
-		strlcpy(adapter->fw_on_flash, resp->fw_on_flash_version_string,
+		strscpy(adapter->fw_on_flash, resp->fw_on_flash_version_string,
 			sizeof(adapter->fw_on_flash));
 	}
 err:
@@ -2373,7 +2373,7 @@ static int lancer_cmd_write_object(struct be_adapter *adapter,
 
 	be_dws_cpu_to_le(ctxt, sizeof(req->context));
 	req->write_offset = cpu_to_le32(data_offset);
-	strlcpy(req->object_name, obj_name, sizeof(req->object_name));
+	strscpy(req->object_name, obj_name, sizeof(req->object_name));
 	req->descriptor_count = cpu_to_le32(1);
 	req->buf_len = cpu_to_le32(data_size);
 	req->addr_low = cpu_to_le32((cmd->dma +
@@ -2442,9 +2442,9 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
 						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
-		strlcpy(adapter->phy.vendor_name, page_data +
+		strscpy(adapter->phy.vendor_name, page_data +
 			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
-		strlcpy(adapter->phy.vendor_pn,
+		strscpy(adapter->phy.vendor_pn,
 			page_data + SFP_VENDOR_PN_OFFSET,
 			SFP_VENDOR_NAME_LEN - 1);
 	}
@@ -2473,7 +2473,7 @@ static int lancer_cmd_delete_object(struct be_adapter *adapter,
 			       OPCODE_COMMON_DELETE_OBJECT,
 			       sizeof(*req), wrb, NULL);
 
-	strlcpy(req->object_name, obj_name, sizeof(req->object_name));
+	strscpy(req->object_name, obj_name, sizeof(req->object_name));
 
 	status = be_mcc_notify_wait(adapter);
 err:
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index bd0df189d871..77edc3d9b505 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -220,15 +220,15 @@ static void be_get_drvinfo(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
 	if (!memcmp(adapter->fw_ver, adapter->fw_on_flash, FW_VER_LEN))
-		strlcpy(drvinfo->fw_version, adapter->fw_ver,
+		strscpy(drvinfo->fw_version, adapter->fw_ver,
 			sizeof(drvinfo->fw_version));
 	else
 		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 			 "%s [%s]", adapter->fw_ver, adapter->fw_on_flash);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index c03663785a8d..9277d5fb5052 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1063,8 +1063,8 @@ static int ftgmac100_mdiobus_write(struct mii_bus *bus, int phy_addr,
 static void ftgmac100_get_drvinfo(struct net_device *netdev,
 				  struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
 }
 
 static void
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 8a341e2d5833..598cdbb280de 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -807,8 +807,8 @@ static void ftmac100_mdio_write(struct net_device *netdev, int phy_id, int reg,
 static void ftmac100_get_drvinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
 }
 
 static int ftmac100_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index b3939a5f7b03..ed18450fd2cc 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -1809,8 +1809,8 @@ static void netdev_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 73f07881ce2d..769e936a263c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -80,9 +80,9 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
 static void dpaa_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, KBUILD_MODNAME,
+	strscpy(drvinfo->driver, KBUILD_MODNAME,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
+	strscpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c9bee9a0c9b2..49ff85633783 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -549,7 +549,7 @@ void dpaa2_mac_get_strings(u8 *data)
 	int i;
 
 	for (i = 0; i < DPAA2_MAC_NUM_STATS; i++) {
-		strlcpy(p, dpaa2_mac_ethtool_stats[i], ETH_GSTRING_LEN);
+		strscpy(p, dpaa2_mac_ethtool_stats[i], ETH_GSTRING_LEN);
 		p += ETH_GSTRING_LEN;
 	}
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ff872e40ce85..dec721e82938 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -236,7 +236,7 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(enetc_si_counters); i++) {
-			strlcpy(p, enetc_si_counters[i].name, ETH_GSTRING_LEN);
+			strscpy(p, enetc_si_counters[i].name, ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -258,7 +258,7 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 			break;
 
 		for (i = 0; i < ARRAY_SIZE(enetc_port_counters); i++) {
-			strlcpy(p, enetc_port_counters[i].name,
+			strscpy(p, enetc_port_counters[i].name,
 				ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index b0d60f898249..7211597d323d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2138,13 +2138,13 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 				continue;
 			if (dev_id--)
 				continue;
-			strlcpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
+			strscpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
 			break;
 		}
 
 		if (phy_id >= PHY_MAX_ADDR) {
 			netdev_info(ndev, "no PHY, assuming direct connection to switch\n");
-			strlcpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
+			strscpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
 			phy_id = 0;
 		}
 
@@ -2328,9 +2328,9 @@ static void fec_enet_get_drvinfo(struct net_device *ndev,
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
-	strlcpy(info->driver, fep->pdev->dev.driver->name,
+	strscpy(info->driver, fep->pdev->dev.driver->name,
 		sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
 }
 
 static int fec_enet_get_regs_len(struct net_device *ndev)
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index c74d04f4b2fd..dc856eb1ce60 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -578,7 +578,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	int ret;
 
 	fep->ptp_caps.owner = THIS_MODULE;
-	strlcpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
+	strscpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
 
 	fep->ptp_caps.max_adj = 250000000;
 	fep->ptp_caps.n_alarm = 0;
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index b3dae17e067e..5b760436bb01 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -791,7 +791,7 @@ static int fs_enet_close(struct net_device *dev)
 static void fs_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 }
 
 static int fs_get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 81fb68730138..b2b0d3c26fcc 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -163,7 +163,7 @@ static int gfar_sset_count(struct net_device *dev, int sset)
 static void gfar_gdrvinfo(struct net_device *dev,
 			  struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
 }
 
 /* Return the length of the register structure */
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index 69b2b98b1525..601beb93d3b3 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -337,8 +337,8 @@ static void
 uec_get_drvinfo(struct net_device *netdev,
                        struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index b0d733e9a7c6..4859493471db 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -1046,8 +1046,8 @@ static void fjn_rx(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index c84ef494bd60..ddeceb26fb79 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -830,8 +830,8 @@ static int hip04_set_coalesce(struct net_device *netdev,
 static void hip04_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 }
 
 static const struct ethtool_ops hip04_ethtool_ops = {
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c b/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
index 6cb86032ce46..1db5b6790a41 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_ethtool.c
@@ -159,8 +159,8 @@ static int ehea_nway_reset(struct net_device *dev)
 static void ehea_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 ehea_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index fbea9f7efe8c..0a4d04a8825d 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2284,8 +2284,8 @@ static void emac_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct emac_instance *dev = netdev_priv(ndev);
 
-	strlcpy(info->driver, "ibm_emac", sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, "ibm_emac", sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "PPC 4xx EMAC-%d %pOF",
 		 dev->cell_index, dev->ofdev->dev.of_node);
 }
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 5c6a04d29f5b..ee4548e08446 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -727,8 +727,8 @@ static void ibmveth_init_link_settings(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
-	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
+	strscpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
+	strscpy(info->version, ibmveth_driver_version, sizeof(info->version));
 }
 
 static netdev_features_t ibmveth_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 11a884aa5082..560d1d442232 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2431,8 +2431,8 @@ static void e100_get_drvinfo(struct net_device *netdev,
 	struct ethtool_drvinfo *info)
 {
 	struct nic *nic = netdev_priv(netdev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(nic->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(nic->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 32803b0cf1e8..d06d29c6c037 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -531,10 +531,10 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  e1000_driver_name,
+	strscpy(drvinfo->driver,  e1000_driver_name,
 		sizeof(drvinfo->driver));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index b80ae9a82224..51a5afe9df2f 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -639,7 +639,7 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, e1000e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, e1000e_driver_name, sizeof(drvinfo->driver));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * PCI-E controllers
@@ -650,7 +650,7 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 		 (adapter->eeprom_vers & 0x0FF0) >> 4,
 		 (adapter->eeprom_vers & 0x000F));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 321f2a95ae3a..56984803c957 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7267,7 +7267,7 @@ static void e1000_print_device_info(struct e1000_adapter *adapter)
 	ret_val = e1000_read_pba_string_generic(hw, pba_str,
 						E1000_PBANUM_LENGTH);
 	if (ret_val)
-		strlcpy((char *)pba_str, "Unknown", sizeof(pba_str));
+		strscpy((char *)pba_str, "Unknown", sizeof(pba_str));
 	e_info("MAC: %d, PHY: %d, PBA No: %s\n",
 	       hw->mac.type, hw->phy.type, pba_str);
 }
@@ -7480,7 +7480,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	e1000e_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 	netif_napi_add(netdev, &adapter->napi, e1000e_poll, 64);
-	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
+	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	netdev->mem_start = mmio_start;
 	netdev->mem_end = mmio_start + mmio_len;
@@ -7676,7 +7676,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->mac.type >= e1000_pch_cnp)
 		adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
 
-	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
+	strscpy(netdev->name, "eth%d", sizeof(netdev->name));
 	err = register_netdev(netdev);
 	if (err)
 		goto err_register;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index e9cd0fa6a0d2..7e75706f76db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2001,10 +2001,10 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 
-	strlcpy(drvinfo->driver, i40e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, i40e_nvm_version_str(&pf->hw),
+	strscpy(drvinfo->driver, i40e_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, i40e_nvm_version_str(&pf->hw),
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(pf->pdev),
+	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_priv_flags = I40E_PRIV_FLAGS_STR_LEN;
 	if (pf->hw.pf_id == 0)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9f1d5de7bf16..5e5290099b76 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10701,7 +10701,7 @@ static void i40e_send_version(struct i40e_pf *pf)
 	dv.minor_version = 0xff;
 	dv.build_version = 0xff;
 	dv.subbuild_version = 0;
-	strlcpy(dv.driver_string, UTS_RELEASE, sizeof(dv.driver_string));
+	strscpy(dv.driver_string, UTS_RELEASE, sizeof(dv.driver_string));
 	i40e_aq_send_driver_version(&pf->hw, &dv, NULL);
 }
 
@@ -16049,23 +16049,23 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		switch (hw->bus.speed) {
 		case i40e_bus_speed_8000:
-			strlcpy(speed, "8.0", PCI_SPEED_SIZE); break;
+			strscpy(speed, "8.0", PCI_SPEED_SIZE); break;
 		case i40e_bus_speed_5000:
-			strlcpy(speed, "5.0", PCI_SPEED_SIZE); break;
+			strscpy(speed, "5.0", PCI_SPEED_SIZE); break;
 		case i40e_bus_speed_2500:
-			strlcpy(speed, "2.5", PCI_SPEED_SIZE); break;
+			strscpy(speed, "2.5", PCI_SPEED_SIZE); break;
 		default:
 			break;
 		}
 		switch (hw->bus.width) {
 		case i40e_bus_width_pcie_x8:
-			strlcpy(width, "8", PCI_WIDTH_SIZE); break;
+			strscpy(width, "8", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x4:
-			strlcpy(width, "4", PCI_WIDTH_SIZE); break;
+			strscpy(width, "4", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x2:
-			strlcpy(width, "2", PCI_WIDTH_SIZE); break;
+			strscpy(width, "2", PCI_WIDTH_SIZE); break;
 		case i40e_bus_width_pcie_x1:
-			strlcpy(width, "1", PCI_WIDTH_SIZE); break;
+			strscpy(width, "1", PCI_WIDTH_SIZE); break;
 		default:
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 2d3533f38d7b..ffea0c9c82f1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -1390,7 +1390,7 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
 	if (!IS_ERR_OR_NULL(pf->ptp_clock))
 		return 0;
 
-	strlcpy(pf->ptp_caps.name, i40e_driver_name,
+	strscpy(pf->ptp_caps.name, i40e_driver_name,
 		sizeof(pf->ptp_caps.name) - 1);
 	pf->ptp_caps.owner = THIS_MODULE;
 	pf->ptp_caps.max_adj = 999999999;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index e535d4c3da49..a056e1545615 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -581,9 +581,9 @@ static void iavf_get_drvinfo(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, iavf_driver_name, 32);
-	strlcpy(drvinfo->fw_version, "N/A", 4);
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
+	strscpy(drvinfo->driver, iavf_driver_name, 32);
+	strscpy(drvinfo->fw_version, "N/A", 4);
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
 	drvinfo->n_priv_flags = IAVF_PRIV_FLAGS_STR_LEN;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index c14fc871dd41..e5f3e7680dc6 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -850,14 +850,14 @@ static void igb_get_drvinfo(struct net_device *netdev,
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  igb_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver,  igb_driver_name, sizeof(drvinfo->driver));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * 82575 controllers
 	 */
-	strlcpy(drvinfo->fw_version, adapter->fw_version,
+	strscpy(drvinfo->fw_version, adapter->fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IGB_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2796e81d2726..ff0c7f0bf07a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3138,7 +3138,7 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
 	adapter->i2c_algo.data = adapter;
 	adapter->i2c_adap.algo_data = &adapter->i2c_algo;
 	adapter->i2c_adap.dev.parent = &adapter->pdev->dev;
-	strlcpy(adapter->i2c_adap.name, "igb BB",
+	strscpy(adapter->i2c_adap.name, "igb BB",
 		sizeof(adapter->i2c_adap.name));
 	status = i2c_bit_add_bus(&adapter->i2c_adap);
 	return status;
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index 9d4322b74163..83b97989a6bd 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -169,8 +169,8 @@ static void igbvf_get_drvinfo(struct net_device *netdev,
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  igbvf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver,  igbvf_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index 46efcfab7234..efa980514944 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -456,9 +456,9 @@ ixgb_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver,  ixgb_driver_name,
+	strscpy(drvinfo->driver,  ixgb_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 04f453eabef6..daa70149ac77 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1106,12 +1106,12 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
 
-	strlcpy(drvinfo->fw_version, adapter->eeprom_id,
+	strscpy(drvinfo->fw_version, adapter->eeprom_id,
 		sizeof(drvinfo->fw_version));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IXGBE_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 0fcd82036d4e..7311bd545acf 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -1004,7 +1004,7 @@ int ixgbe_fcoe_get_hbainfo(struct net_device *netdev,
 		 ixgbe_driver_name,
 		 UTS_RELEASE);
 	/* Firmware Version */
-	strlcpy(info->firmware_version, adapter->eeprom_id,
+	strscpy(info->firmware_version, adapter->eeprom_id,
 		sizeof(info->firmware_version));
 
 	/* Model */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index d1e430b8c8aa..298cfbfcb7b6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10849,7 +10849,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &ixgbe_netdev_ops;
 	ixgbe_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
+	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	/* Setup hw api */
 	hw->mac.ops   = *ii->mac_ops;
@@ -11140,7 +11140,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ixgbe_read_pba_string_generic(hw, part_str, sizeof(part_str));
 	if (err)
-		strlcpy(part_str, "Unknown", sizeof(part_str));
+		strscpy(part_str, "Unknown", sizeof(part_str));
 	if (ixgbe_is_sfp(hw) && hw->phy.sfp_type != ixgbe_sfp_type_not_present)
 		e_dev_info("MAC: %d, PHY: %d, SFP+: %d, PBA No: %s\n",
 			   hw->mac.type, hw->phy.type, hw->phy.sfp_type,
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index fed46872af2b..ccfa6b91aac6 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -213,8 +213,8 @@ static void ixgbevf_get_drvinfo(struct net_device *netdev,
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, ixgbevf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, ixgbevf_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IXGBEVF_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index f43d6616bc0d..b56594407965 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2332,9 +2332,9 @@ jme_get_drvinfo(struct net_device *netdev,
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(jme->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(jme->pdev), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index df9a8eefa007..90e458de9aa2 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -938,9 +938,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct korina_private *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, lp->dev->name, sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, lp->dev->name, sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a6c1..8b9abe622489 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1603,12 +1603,12 @@ mv643xx_eth_set_link_ksettings(struct net_device *dev,
 static void mv643xx_eth_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, mv643xx_eth_driver_name,
+	strscpy(drvinfo->driver, mv643xx_eth_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mv643xx_eth_driver_version,
+	strscpy(drvinfo->version, mv643xx_eth_driver_version,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
 static int mv643xx_eth_get_coalesce(struct net_device *dev,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..b500fe1dfa81 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4656,11 +4656,11 @@ mvneta_ethtool_get_coalesce(struct net_device *dev,
 static void mvneta_ethtool_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, MVNETA_DRIVER_NAME,
+	strscpy(drvinfo->driver, MVNETA_DRIVER_NAME,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, MVNETA_DRIVER_VERSION,
+	strscpy(drvinfo->version, MVNETA_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(&dev->dev),
+	strscpy(drvinfo->bus_info, dev_name(&dev->dev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..38e5b4be6a4d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5425,11 +5425,11 @@ mvpp2_ethtool_get_coalesce(struct net_device *dev,
 static void mvpp2_ethtool_get_drvinfo(struct net_device *dev,
 				      struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, MVPP2_DRIVER_NAME,
+	strscpy(drvinfo->driver, MVPP2_DRIVER_NAME,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, MVPP2_DRIVER_VERSION,
+	strscpy(drvinfo->version, MVPP2_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(&dev->dev),
+	strscpy(drvinfo->bus_info, dev_name(&dev->dev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 3f60a80e34c8..5bd16e95370b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -76,8 +76,8 @@ static void otx2_get_drvinfo(struct net_device *netdev,
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
 }
 
 static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
@@ -1313,8 +1313,8 @@ static void otx2vf_get_drvinfo(struct net_device *netdev,
 {
 	struct otx2_nic *vf = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
 }
 
 static void otx2vf_get_strings(struct net_device *netdev, u32 sset, u8 *data)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 1da7ff889417..2f52daba58e6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -300,8 +300,8 @@ static void prestera_ethtool_get_drvinfo(struct net_device *dev,
 	struct prestera_port *port = netdev_priv(dev);
 	struct prestera_switch *sw = port->sw;
 
-	strlcpy(drvinfo->driver, driver_kind, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, dev_name(prestera_dev(sw)),
+	strscpy(drvinfo->driver, driver_kind, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(prestera_dev(sw)),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 349b8a94e939..cf456d62677f 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1354,10 +1354,10 @@ static void pxa168_eth_netpoll(struct net_device *dev)
 static void pxa168_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
-	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->bus_info, "N/A", sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops pxa168_ethtool_ops = {
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index c1e985416c0e..bcc4aa59d10a 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -394,9 +394,9 @@ static void skge_get_drvinfo(struct net_device *dev,
 {
 	struct skge_port *skge = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(skge->hw->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(skge->hw->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index bbea5458000b..e19acfcd84d4 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3687,9 +3687,9 @@ static void sky2_get_drvinfo(struct net_device *dev,
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sky2->hw->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sky2->hw->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5ace4609de47..60236b49164c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3556,8 +3556,8 @@ static void mtk_get_drvinfo(struct net_device *dev,
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 
-	strlcpy(info->driver, mac->hw->dev->driver->name, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(mac->hw->dev), sizeof(info->bus_info));
+	strscpy(info->driver, mac->hw->dev->driver->name, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(mac->hw->dev), sizeof(info->bus_info));
 	info->n_stats = ARRAY_SIZE(mtk_ethtool_stats);
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 3f0e5e64de50..f8db176c71ae 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1255,7 +1255,7 @@ static const struct net_device_ops mtk_star_netdev_ops = {
 static void mtk_star_get_drvinfo(struct net_device *dev,
 				 struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, MTK_STAR_DRVNAME, sizeof(info->driver));
+	strscpy(info->driver, MTK_STAR_DRVNAME, sizeof(info->driver));
 }
 
 /* TODO Add ethtool stats. */
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 6400a827173c..7d45f1d55f79 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -89,15 +89,15 @@ mlx4_en_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION,
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, DRV_VERSION,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d",
 		(u16) (mdev->dev->caps.fw_ver >> 32),
 		(u16) ((mdev->dev->caps.fw_ver >> 16) & 0xffff),
 		(u16) (mdev->dev->caps.fw_ver & 0xffff));
-	strlcpy(drvinfo->bus_info, pci_name(mdev->dev->persist->pdev),
+	strscpy(drvinfo->bus_info, pci_name(mdev->dev->persist->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index dcb9eb1899ce..fe48d20d6118 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1779,7 +1779,7 @@ static void get_board_id(void *vsd, char *board_id)
 
 	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
 	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
-		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MLX4_BOARD_ID_LEN);
+		strscpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MLX4_BOARD_ID_LEN);
 	} else {
 		/*
 		 * The board ID is a string but the firmware byte
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index b811207fe5ed..b6d038f8d65e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -44,12 +44,12 @@ void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
 		 fw_rev_maj(mdev), fw_rev_min(mdev), fw_rev_sub(mdev),
 		 mdev->board_id);
-	strlcpy(drvinfo->bus_info, dev_name(mdev->device),
+	strscpy(drvinfo->bus_info, dev_name(mdev->device),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 759f7d3c2cfd..c4f0d772d959 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -69,7 +69,7 @@ static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, mlx5e_rep_driver_name,
+	strscpy(drvinfo->driver, mlx5e_rep_driver_name,
 		sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index ac3757beaea2..1cae066bddf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -39,7 +39,7 @@ static void mlx5i_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
 	mlx5e_ethtool_get_drvinfo(priv, drvinfo);
-	strlcpy(drvinfo->driver, KBUILD_MODNAME "[ib_ipoib]",
+	strscpy(drvinfo->driver, KBUILD_MODNAME "[ib_ipoib]",
 		sizeof(drvinfo->driver));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 75553eb2c7f2..7331635607f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -633,7 +633,7 @@ static void mlxsw_emad_process_string_tlv(const struct sk_buff *skb,
 		return;
 
 	string = mlxsw_emad_string_tlv_string_data(string_tlv);
-	strlcpy(trans->emad_err_string, string,
+	strscpy(trans->emad_err_string, string,
 		MLXSW_EMAD_STRING_TLV_STRING_LEN);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index bb1cd4bae82e..e3c045a82ae2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -94,14 +94,14 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	strlcpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
+	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
 		sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
 		 mlxsw_m->bus_info->fw_rev.major,
 		 mlxsw_m->bus_info->fw_rev.minor,
 		 mlxsw_m->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
+	strscpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 915dffb85a1c..dcd79d7e2af4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -14,16 +14,16 @@ static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	strlcpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
+	strscpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mlxsw_sp_driver_version,
+	strscpy(drvinfo->version, mlxsw_sp_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
 		 mlxsw_sp->bus_info->fw_rev.major,
 		 mlxsw_sp->bus_info->fw_rev.minor,
 		 mlxsw_sp->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
+	strscpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 691206f19ea7..ec8457e61b45 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -703,9 +703,9 @@ static const struct net_device_ops ks8851_netdev_ops = {
 static void ks8851_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *di)
 {
-	strlcpy(di->driver, "KS8851", sizeof(di->driver));
-	strlcpy(di->version, "1.00", sizeof(di->version));
-	strlcpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
+	strscpy(di->driver, "KS8851", sizeof(di->driver));
+	strscpy(di->version, "1.00", sizeof(di->version));
+	strscpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di->bus_info));
 }
 
 static u32 ks8851_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 2b3eb5ed8233..468520079c65 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5998,9 +5998,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 	struct dev_priv *priv = netdev_priv(dev);
 	struct dev_info *hw_priv = priv->adapter;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(hw_priv->pdev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(hw_priv->pdev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 559ad94a44d0..176efbeae127 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1467,9 +1467,9 @@ static void enc28j60_restart_work_handler(struct work_struct *work)
 static void
 enc28j60_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info,
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info,
 		dev_name(dev->dev.parent), sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index dc1840cb5b10..d7c8aa77ec75 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -925,9 +925,9 @@ static void encx24j600_get_regs(struct net_device *dev,
 static void encx24j600_get_drvinfo(struct net_device *dev,
 				   struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index b1c74e6cb012..c739d60ee17d 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -579,8 +579,8 @@ static void lan743x_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info,
+	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
+	strscpy(info->bus_info,
 		pci_name(adapter->pdev), sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 971dde8c3286..9063e2e22cd5 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1647,10 +1647,10 @@ myri10ge_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
-	strlcpy(info->driver, "myri10ge", sizeof(info->driver));
-	strlcpy(info->version, MYRI10GE_VERSION_STR, sizeof(info->version));
-	strlcpy(info->fw_version, mgp->fw_version, sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "myri10ge", sizeof(info->driver));
+	strscpy(info->version, MYRI10GE_VERSION_STR, sizeof(info->version));
+	strscpy(info->fw_version, mgp->fw_version, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
 }
 
 static int myri10ge_get_coalesce(struct net_device *netdev,
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 9aae7f1eb5d2..518b664a6908 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -2564,9 +2564,9 @@ static void set_rx_mode(struct net_device *dev)
 static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int get_regs_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 49ea130c9067..998586872599 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -1351,9 +1351,9 @@ static int ns83820_set_link_ksettings(struct net_device *ndev,
 static void ns83820_get_drvinfo(struct net_device *ndev, struct ethtool_drvinfo *info)
 {
 	struct ns83820 *dev = PRIV(ndev);
-	strlcpy(info->driver, "ns83820", sizeof(info->driver));
-	strlcpy(info->version, VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(dev->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, "ns83820", sizeof(info->driver));
+	strscpy(info->version, VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(dev->pci_dev), sizeof(info->bus_info));
 }
 
 static u32 ns83820_get_link(struct net_device *ndev)
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 30f955efa830..d8a77b0db50d 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5348,9 +5348,9 @@ static void s2io_ethtool_gdrvinfo(struct net_device *dev,
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 
-	strlcpy(info->driver, s2io_driver_name, sizeof(info->driver));
-	strlcpy(info->version, s2io_driver_version, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, s2io_driver_name, sizeof(info->driver));
+	strscpy(info->version, s2io_driver_version, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sp->pdev), sizeof(info->bus_info));
 }
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index eeb1455a4e5d..cfae6a30bada 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -205,7 +205,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
 {
 	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
 
-	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev),
+	strscpy(drvinfo->driver, dev_driver_string(&pdev->dev),
 		sizeof(drvinfo->driver));
 	nfp_net_get_nspinfo(app, nsp_version);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
@@ -222,7 +222,7 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	snprintf(vnic_version, sizeof(vnic_version), "%d.%d.%d.%d",
 		 nn->fw_ver.extend, nn->fw_ver.class,
 		 nn->fw_ver.major, nn->fw_ver.minor);
-	strlcpy(drvinfo->bus_info, pci_name(nn->pdev),
+	strscpy(drvinfo->bus_info, pci_name(nn->pdev),
 		sizeof(drvinfo->bus_info));
 
 	nfp_get_drvinfo(nn->app, nn->pdev, vnic_version, drvinfo);
@@ -233,7 +233,7 @@ nfp_app_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 
-	strlcpy(drvinfo->bus_info, pci_name(app->pdev),
+	strscpy(drvinfo->bus_info, pci_name(app->pdev),
 		sizeof(drvinfo->bus_info));
 	nfp_get_drvinfo(app, app->pdev, "*", drvinfo);
 }
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 4b3482ce90a1..cf2929fa525e 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -990,8 +990,8 @@ static const struct net_device_ops nixge_netdev_ops = {
 static void nixge_ethtools_get_drvinfo(struct net_device *ndev,
 				       struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, "nixge", sizeof(ed->driver));
-	strlcpy(ed->bus_info, "platform", sizeof(ed->bus_info));
+	strscpy(ed->driver, "nixge", sizeof(ed->driver));
+	strscpy(ed->bus_info, "platform", sizeof(ed->bus_info));
 }
 
 static int
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 5116badaf091..7c0675ca337b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4291,9 +4291,9 @@ static void nv_do_stats_poll(struct timer_list *t)
 static void nv_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct fe_priv *np = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, FORCEDETH_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, FORCEDETH_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static void nv_get_wol(struct net_device *dev, struct ethtool_wolinfo *wolinfo)
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index f606d75b33b4..1a4a272f4c5c 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1184,9 +1184,9 @@ static int lpc_eth_open(struct net_device *ndev)
 static void lpc_eth_ethtool_getdrvinfo(struct net_device *ndev,
 	struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 84cc79e928c8..541b8bcd3223 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -169,9 +169,9 @@ static void pch_gbe_get_drvinfo(struct net_device *netdev,
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, pch_driver_version, sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, pch_driver_version, sizeof(drvinfo->version));
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index 9c408328be0d..1cc001087193 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -1819,9 +1819,9 @@ static void hamachi_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct hamachi_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int hamachi_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index 03650022d444..640ac01689fb 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -1340,9 +1340,9 @@ static void yellowfin_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
 {
 	struct yellowfin_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops ethtool_ops = {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index 3c4a84ea6321..8c4cb910e09b 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -65,9 +65,9 @@ netxen_nic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	u32 fw_minor = 0;
 	u32 fw_build = 0;
 
-	strlcpy(drvinfo->driver, netxen_nic_driver_name,
+	strscpy(drvinfo->driver, netxen_nic_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, NETXEN_NIC_LINUX_VERSIONID,
+	strscpy(drvinfo->version, NETXEN_NIC_LINUX_VERSIONID,
 		sizeof(drvinfo->version));
 	fw_major = NXRD32(adapter, NETXEN_FW_VERSION_MAJOR);
 	fw_minor = NXRD32(adapter, NETXEN_FW_VERSION_MINOR);
@@ -75,7 +75,7 @@ netxen_nic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d", fw_major, fw_minor, fw_build);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index d701ecd3ba00..2661c483c67e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1119,7 +1119,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 						snprintf(bit_name, 30,
 							 p_aeu->bit_name, num);
 					else
-						strlcpy(bit_name,
+						strscpy(bit_name,
 							p_aeu->bit_name, 30);
 
 					/* We now need to pass bitmask in its
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 97a7ab0826ed..8034d812d5a0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -624,7 +624,7 @@ static void qede_get_drvinfo(struct net_device *ndev,
 	struct qede_dev *edev = netdev_priv(ndev);
 	char mbi[ETHTOOL_FWVERS_LEN];
 
-	strlcpy(info->driver, "qede", sizeof(info->driver));
+	strscpy(info->driver, "qede", sizeof(info->driver));
 
 	snprintf(storm, ETHTOOL_FWVERS_LEN, "%d.%d.%d.%d",
 		 edev->dev_info.common.fw_major,
@@ -661,7 +661,7 @@ static void qede_get_drvinfo(struct net_device *ndev,
 			 "mfw %s", mfw);
 	}
 
-	strlcpy(info->bus_info, pci_name(edev->pdev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(edev->pdev), sizeof(info->bus_info));
 }
 
 static void qede_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index f56b679adb4b..3c1bfff29157 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1214,7 +1214,7 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	/* Start the Slowpath-process */
 	memset(&sp_params, 0, sizeof(sp_params));
 	sp_params.int_mode = QED_INT_MODE_MSIX;
-	strlcpy(sp_params.name, "qede LAN", QED_DRV_VER_STR_SIZE);
+	strscpy(sp_params.name, "qede LAN", QED_DRV_VER_STR_SIZE);
 	rc = qed_ops->common->slowpath_start(cdev, &sp_params);
 	if (rc) {
 		pr_notice("Cannot start slowpath\n");
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 06f4d9a9e938..31e3ab149727 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -1736,10 +1736,10 @@ static void ql_get_drvinfo(struct net_device *ndev,
 			   struct ethtool_drvinfo *drvinfo)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
-	strlcpy(drvinfo->driver, ql3xxx_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, ql3xxx_driver_version,
+	strscpy(drvinfo->driver, ql3xxx_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, ql3xxx_driver_version,
 		sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, pci_name(qdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(qdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index 54a2d653be63..1ee491f78c6b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -277,10 +277,10 @@ qlcnic_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *drvinfo)
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		"%d.%d.%d", fw_major, fw_minor, fw_build);
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
-	strlcpy(drvinfo->driver, qlcnic_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, QLCNIC_LINUX_VERSIONID,
+	strscpy(drvinfo->driver, qlcnic_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, QLCNIC_LINUX_VERSIONID,
 		sizeof(drvinfo->version));
 }
 
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 792ce9a323cd..f62c39544e08 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -164,10 +164,10 @@ qcaspi_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *p)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
-	strlcpy(p->driver, QCASPI_DRV_NAME, sizeof(p->driver));
-	strlcpy(p->version, QCASPI_DRV_VERSION, sizeof(p->version));
-	strlcpy(p->fw_version, "QCA7000", sizeof(p->fw_version));
-	strlcpy(p->bus_info, dev_name(&qca->spi_dev->dev),
+	strscpy(p->driver, QCASPI_DRV_NAME, sizeof(p->driver));
+	strscpy(p->version, QCASPI_DRV_VERSION, sizeof(p->version));
+	strscpy(p->fw_version, "QCA7000", sizeof(p->fw_version));
+	strscpy(p->bus_info, dev_name(&qca->spi_dev->dev),
 		sizeof(p->bus_info));
 }
 
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index a6bf7d505178..1aac2c3e5e0d 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -939,9 +939,9 @@ static void netdev_get_drvinfo(struct net_device *dev,
 {
 	struct r6040_private *rp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(rp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(rp->pdev), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops netdev_ethtool_ops = {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index e0feeec13da6..f5786d78ed23 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1382,9 +1382,9 @@ static void cp_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct cp_private *cp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
 }
 
 static void cp_get_ringparam(struct net_device *dev,
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 15b40fd93cd2..ab424b5b4920 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2380,9 +2380,9 @@ static int rtl8139_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 static void rtl8139_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 }
 
 static int rtl8139_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b7fdb4f056b..3845f9ae0fa5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1423,11 +1423,11 @@ static void rtl8169_get_drvinfo(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct rtl_fw *rtl_fw = tp->rtl_fw;
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 	BUILD_BUG_ON(sizeof(info->fw_version) < sizeof(rtl_fw->version));
 	if (rtl_fw)
-		strlcpy(info->fw_version, rtl_fw->version,
+		strscpy(info->fw_version, rtl_fw->version,
 			sizeof(info->fw_version));
 }
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index fc83ec23bd1d..9e7b62750bb0 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2226,8 +2226,8 @@ rocker_port_set_link_ksettings(struct net_device *dev,
 static void rocker_port_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *drvinfo)
 {
-	strlcpy(drvinfo->driver, rocker_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
+	strscpy(drvinfo->driver, rocker_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 }
 
 static struct rocker_port_stats {
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 98edb01024f0..8ba017ec9849 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -175,8 +175,8 @@ static int sxgbe_set_eee(struct net_device *dev,
 static void sxgbe_getdrvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 sxgbe_getmsglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 153d68e29b8b..abed6188a8e6 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -778,7 +778,7 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 		return;
 
 	if (efx_dev_registered(efx)) {
-		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
+		strscpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
 		efx_fini_mcdi_logging(efx);
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index a929a1aaba92..c2224e41a694 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -996,7 +996,7 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev)
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+	strscpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
 	efx->rx_ip_align =
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bc840ede3053..a8cbceeb301b 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -106,10 +106,10 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
 }
 
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev)
@@ -468,7 +468,7 @@ void efx_ethtool_get_strings(struct net_device *net_dev,
 		strings += (efx->type->describe_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
 		for (i = 0; i < EFX_ETHTOOL_SW_STAT_COUNT; i++)
-			strlcpy(strings + i * ETH_GSTRING_LEN,
+			strscpy(strings + i * ETH_GSTRING_LEN,
 				efx_sw_stat_desc[i].name, ETH_GSTRING_LEN);
 		strings += EFX_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (efx_describe_per_queue_stats(efx, strings) *
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index a63f40b09856..f18418e07eb8 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2329,7 +2329,7 @@ static void ef4_unregister_netdev(struct ef4_nic *efx)
 	BUG_ON(netdev_priv(efx->net_dev) != efx);
 
 	if (ef4_dev_registered(efx)) {
-		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
+		strscpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
 	}
@@ -2640,7 +2640,7 @@ static int ef4_init_struct(struct ef4_nic *efx,
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+	strscpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
 	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index 907254b36663..3976a333f7e3 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -162,9 +162,9 @@ static void ef4_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, EF4_DRIVER_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->version, EF4_DRIVER_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
 }
 
 static int ef4_ethtool_get_regs_len(struct net_device *net_dev)
@@ -412,7 +412,7 @@ static void ef4_ethtool_get_strings(struct net_device *net_dev,
 		strings += (efx->type->describe_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
 		for (i = 0; i < EF4_ETHTOOL_SW_STAT_COUNT; i++)
-			strlcpy(strings + i * ETH_GSTRING_LEN,
+			strscpy(strings + i * ETH_GSTRING_LEN,
 				ef4_sw_stat_desc[i].name, ETH_GSTRING_LEN);
 		strings += EF4_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (ef4_describe_per_queue_stats(efx, strings) *
diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
index 3324a6219a09..7a1c9337081b 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon.c
@@ -2387,7 +2387,7 @@ static int falcon_probe_nic(struct ef4_nic *efx)
 	board->i2c_data.data = efx;
 	board->i2c_adap.algo_data = &board->i2c_data;
 	board->i2c_adap.dev.parent = &efx->pci_dev->dev;
-	strlcpy(board->i2c_adap.name, "SFC4000 GPIO",
+	strscpy(board->i2c_adap.name, "SFC4000 GPIO",
 		sizeof(board->i2c_adap.name));
 	rc = i2c_bit_add_bus(&board->i2c_adap);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/nic.c b/drivers/net/ethernet/sfc/falcon/nic.c
index 156da315ec89..78c851b5a56f 100644
--- a/drivers/net/ethernet/sfc/falcon/nic.c
+++ b/drivers/net/ethernet/sfc/falcon/nic.c
@@ -452,7 +452,7 @@ size_t ef4_nic_describe_stats(const struct ef4_hw_stat_desc *desc, size_t count,
 	for_each_set_bit(index, mask, count) {
 		if (desc[index].name) {
 			if (names) {
-				strlcpy(names, desc[index].name,
+				strscpy(names, desc[index].name,
 					ETH_GSTRING_LEN);
 				names += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sfc/mcdi_mon.c b/drivers/net/ethernet/sfc/mcdi_mon.c
index 5954fcfee2b1..f5128db7c7e7 100644
--- a/drivers/net/ethernet/sfc/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/mcdi_mon.c
@@ -285,7 +285,7 @@ efx_mcdi_mon_add_attr(struct efx_nic *efx, const char *name,
 	struct efx_mcdi_mon *hwmon = efx_mcdi_mon(efx);
 	struct efx_mcdi_mon_attribute *attr = &hwmon->attrs[hwmon->n_attrs];
 
-	strlcpy(attr->name, name, sizeof(attr->name));
+	strscpy(attr->name, name, sizeof(attr->name));
 	attr->index = index;
 	attr->type = type;
 	if (type < ARRAY_SIZE(efx_mcdi_sensor_type))
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 22fbb0ae77fb..63e2394382bb 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -465,7 +465,7 @@ size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 	for_each_set_bit(index, mask, count) {
 		if (desc[index].name) {
 			if (names) {
-				strlcpy(names, desc[index].name,
+				strscpy(names, desc[index].name,
 					ETH_GSTRING_LEN);
 				names += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 63d999e63960..10734e828e51 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -775,7 +775,7 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 	BUG_ON(netdev_priv(efx->net_dev) != efx);
 
 	if (efx_dev_registered(efx)) {
-		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
+		strscpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
 		efx_siena_fini_mcdi_logging(efx);
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 954daf464abb..1fd396b00bfb 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1006,7 +1006,7 @@ int efx_siena_init_struct(struct efx_nic *efx,
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+	strscpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
 	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index 0207d07f54e3..f590e87e5a23 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -105,10 +105,10 @@ void efx_siena_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	efx_siena_mcdi_print_fwver(efx, info->fw_version,
 				   sizeof(info->fw_version));
-	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
 }
 
 u32 efx_siena_ethtool_get_msglevel(struct net_device *net_dev)
@@ -467,7 +467,7 @@ void efx_siena_ethtool_get_strings(struct net_device *net_dev,
 		strings += (efx->type->describe_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
 		for (i = 0; i < EFX_ETHTOOL_SW_STAT_COUNT; i++)
-			strlcpy(strings + i * ETH_GSTRING_LEN,
+			strscpy(strings + i * ETH_GSTRING_LEN,
 				efx_sw_stat_desc[i].name, ETH_GSTRING_LEN);
 		strings += EFX_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (efx_describe_per_queue_stats(efx, strings) *
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_mon.c b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
index c7ea703c5d7a..56a9c56ed9e3 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
@@ -285,7 +285,7 @@ efx_mcdi_mon_add_attr(struct efx_nic *efx, const char *name,
 	struct efx_mcdi_mon *hwmon = efx_mcdi_mon(efx);
 	struct efx_mcdi_mon_attribute *attr = &hwmon->attrs[hwmon->n_attrs];
 
-	strlcpy(attr->name, name, sizeof(attr->name));
+	strscpy(attr->name, name, sizeof(attr->name));
 	attr->index = index;
 	attr->type = type;
 	if (type < ARRAY_SIZE(efx_mcdi_sensor_type))
diff --git a/drivers/net/ethernet/sfc/siena/nic.c b/drivers/net/ethernet/sfc/siena/nic.c
index abf9a4adf139..0ea0433a6230 100644
--- a/drivers/net/ethernet/sfc/siena/nic.c
+++ b/drivers/net/ethernet/sfc/siena/nic.c
@@ -458,7 +458,7 @@ size_t efx_siena_describe_stats(const struct efx_hw_stat_desc *desc, size_t coun
 	for_each_set_bit(index, mask, count) {
 		if (desc[index].name) {
 			if (names) {
-				strlcpy(names, desc[index].name,
+				strscpy(names, desc[index].name,
 					ETH_GSTRING_LEN);
 				names += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index e2d009866a7b..8fc3f5272fa7 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1158,9 +1158,9 @@ static inline unsigned int ioc3_hash(const unsigned char *addr)
 static void ioc3_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, IOC3_NAME, sizeof(info->driver));
-	strlcpy(info->version, IOC3_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
+	strscpy(info->driver, IOC3_NAME, sizeof(info->driver));
+	strscpy(info->version, IOC3_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 216bb2d34d7c..dda4e488c77a 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1769,9 +1769,9 @@ static void sis190_get_drvinfo(struct net_device *dev,
 {
 	struct sis190_private *tp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(tp->pci_dev),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(tp->pci_dev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 23a336c5096e..cb7fec226cab 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -2027,9 +2027,9 @@ static void sis900_get_drvinfo(struct net_device *net_dev,
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 
-	strlcpy(info->driver, SIS900_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, SIS900_DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(sis_priv->pci_dev),
+	strscpy(info->driver, SIS900_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, SIS900_DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(sis_priv->pci_dev),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 0329caf63279..83fe53401453 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1392,9 +1392,9 @@ static void netdev_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct epic_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 24d66af797d4..52ecfb461c41 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1509,9 +1509,9 @@ smc911x_ethtool_set_link_ksettings(struct net_device *dev,
 static void
 smc911x_ethtool_getdrvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->version, version, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->version, version, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index 37c822e27207..29bb19f42de9 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -1909,8 +1909,8 @@ static int check_if_running(struct net_device *dev)
 
 static void smc_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static int smc_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index a31c159e96ea..35e99bf0c401 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1588,9 +1588,9 @@ smc_ethtool_set_link_ksettings(struct net_device *dev,
 static void
 smc_ethtool_getdrvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->version, version, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, CARDNAME, sizeof(info->driver));
+	strscpy(info->version, version, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 3bf20211cceb..953489548b8d 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1953,9 +1953,9 @@ static int smsc911x_set_mac_address(struct net_device *dev, void *p)
 static void smsc911x_ethtool_getdrvinfo(struct net_device *dev,
 					struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, SMSC_CHIPNAME, sizeof(info->driver));
-	strlcpy(info->version, SMSC_DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+	strscpy(info->driver, SMSC_CHIPNAME, sizeof(info->driver));
+	strscpy(info->version, SMSC_DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 0c68c7f8056d..229180aa86de 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -215,10 +215,10 @@ static void smsc9420_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct smsc9420_pdata *pd = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->bus_info, pci_name(pd->pdev),
+	strscpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(pd->pdev),
 		sizeof(drvinfo->bus_info));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 }
 
 static u32 smsc9420_ethtool_get_msglevel(struct net_device *netdev)
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index b0c5a44785fa..85e62f5489b6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -526,8 +526,8 @@ static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr)
 static void netsec_et_get_drvinfo(struct net_device *net_device,
 				  struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "netsec", sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(net_device->dev.parent),
+	strscpy(info->driver, "netsec", sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(net_device->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index f0c8de2c6075..ee341a383e69 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -395,8 +395,8 @@ static void ave_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct device *dev = ndev->dev.parent;
 
-	strlcpy(info->driver, dev->driver->name, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(dev), sizeof(info->bus_info));
+	strscpy(info->driver, dev->driver->name, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(dev), sizeof(info->bus_info));
 	ave_hw_read_version(ndev, info->fw_version, sizeof(info->fw_version));
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d6a44d53fe08..f453b0d09366 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -287,15 +287,15 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->has_gmac || priv->plat->has_gmac4)
-		strlcpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
+		strscpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
 	else if (priv->plat->has_xgmac)
-		strlcpy(info->driver, XGMAC_ETHTOOL_NAME, sizeof(info->driver));
+		strscpy(info->driver, XGMAC_ETHTOOL_NAME, sizeof(info->driver));
 	else
-		strlcpy(info->driver, MAC100_ETHTOOL_NAME,
+		strscpy(info->driver, MAC100_ETHTOOL_NAME,
 			sizeof(info->driver));
 
 	if (priv->plat->pdev) {
-		strlcpy(info->bus_info, pci_name(priv->plat->pdev),
+		strscpy(info->bus_info, pci_name(priv->plat->pdev),
 			sizeof(info->bus_info));
 	}
 }
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 0b08b0e085e8..19a3eb6efc3a 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4484,9 +4484,9 @@ static void cas_set_multicast(struct net_device *dev)
 static void cas_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct cas *cp = netdev_priv(dev);
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(cp->pdev), sizeof(info->bus_info));
 }
 
 static int cas_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 0cd8493b810f..bc51a75a0e19 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -63,8 +63,8 @@ static struct vio_version vsw_versions[] = {
 static void vsw_get_drvinfo(struct net_device *dev,
 			    struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static u32 vsw_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index df70df29deea..204a29e72292 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -6798,12 +6798,12 @@ static void niu_get_drvinfo(struct net_device *dev,
 	struct niu *np = netdev_priv(dev);
 	struct niu_vpd *vpd = &np->vpd;
 
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	snprintf(info->fw_version, sizeof(info->fw_version), "%d.%d",
 		vpd->fcode_major, vpd->fcode_minor);
 	if (np->parent->plat_type != PLAT_TYPE_NIU)
-		strlcpy(info->bus_info, pci_name(np->pdev),
+		strscpy(info->bus_info, pci_name(np->pdev),
 			sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 531a6f449afa..34b94153bf0c 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -1038,8 +1038,8 @@ static void bigmac_set_multicast(struct net_device *dev)
 /* Ethtool support... */
 static void bigmac_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "sunbmac", sizeof(info->driver));
-	strlcpy(info->version, "2.0", sizeof(info->version));
+	strscpy(info->driver, "sunbmac", sizeof(info->driver));
+	strscpy(info->version, "2.0", sizeof(info->version));
 }
 
 static u32 bigmac_get_link(struct net_device *dev)
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index a14591b41acb..6fb89c55f957 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2521,9 +2521,9 @@ static void gem_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct gem *gp = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(gp->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(gp->pdev), sizeof(info->bus_info));
 }
 
 static int gem_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 8594ee839628..1921054b7f7d 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2467,11 +2467,11 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	strlcpy(info->driver, "sunhme", sizeof(info->driver));
-	strlcpy(info->version, "2.02", sizeof(info->version));
+	strscpy(info->driver, "sunhme", sizeof(info->driver));
+	strscpy(info->version, "2.02", sizeof(info->version));
 	if (hp->happy_flags & HFLAG_PCI) {
 		struct pci_dev *pdev = hp->happy_dev;
-		strlcpy(info->bus_info, pci_name(pdev), sizeof(info->bus_info));
+		strscpy(info->bus_info, pci_name(pdev), sizeof(info->bus_info));
 	}
 #ifdef CONFIG_SBUS
 	else {
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index efe0d33f6024..6418fcc3139f 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -684,8 +684,8 @@ static void qe_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct sunqe *qep = netdev_priv(dev);
 	struct platform_device *op;
 
-	strlcpy(info->driver, "sunqe", sizeof(info->driver));
-	strlcpy(info->version, "3.0", sizeof(info->version));
+	strscpy(info->driver, "sunqe", sizeof(info->driver));
+	strscpy(info->version, "3.0", sizeof(info->version));
 
 	op = qep->op;
 	regs = of_get_property(op->dev.of_node, "reg", NULL);
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index da8119625cf3..042b50227850 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -60,8 +60,8 @@ static struct vio_version vnet_versions[] = {
 static void vnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static u32 vnet_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index 5c9b6c90942b..f8e133604146 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -54,8 +54,8 @@ static void xlgmac_default_config(struct xlgmac_pdata *pdata)
 	pdata->phy_speed = SPEED_25000;
 	pdata->sysclk_rate = XLGMAC_SYSCLOCK;
 
-	strlcpy(pdata->drv_name, XLGMAC_DRV_NAME, sizeof(pdata->drv_name));
-	strlcpy(pdata->drv_ver, XLGMAC_DRV_VERSION, sizeof(pdata->drv_ver));
+	strscpy(pdata->drv_name, XLGMAC_DRV_NAME, sizeof(pdata->drv_name));
+	strscpy(pdata->drv_ver, XLGMAC_DRV_VERSION, sizeof(pdata->drv_ver));
 }
 
 static void xlgmac_init_all_ops(struct xlgmac_pdata *pdata)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
index 49f8c6be9459..e794da727fe0 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
@@ -102,9 +102,9 @@ static void xlgmac_ethtool_get_drvinfo(struct net_device *netdev,
 	u32 ver = pdata->hw_feat.version;
 	u32 snpsver, devid, userver;
 
-	strlcpy(drvinfo->driver, pdata->drv_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, pdata->drv_ver, sizeof(drvinfo->version));
-	strlcpy(drvinfo->bus_info, dev_name(pdata->dev),
+	strscpy(drvinfo->driver, pdata->drv_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, pdata->drv_ver, sizeof(drvinfo->version));
+	strscpy(drvinfo->bus_info, dev_name(pdata->dev),
 		sizeof(drvinfo->bus_info));
 	/* S|SNPSVER: Synopsys-defined Version
 	 * D|DEVID: Indicates the Device family
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 985073eba3bd..08ba658db987 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2133,10 +2133,10 @@ bdx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 
-	strlcpy(drvinfo->driver, BDX_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, BDX_DRV_VERSION, sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(priv->pdev),
+	strscpy(drvinfo->driver, BDX_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, BDX_DRV_VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(priv->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index abc1e4276cf0..c51e2af91f69 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -402,9 +402,9 @@ static void am65_cpsw_get_drvinfo(struct net_device *ndev,
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 
-	strlcpy(info->driver, dev_driver_string(common->dev),
+	strscpy(info->driver, dev_driver_string(common->dev),
 		sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
 }
 
 static u32 am65_cpsw_get_msglevel(struct net_device *ndev)
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index bef5e68dac31..ce92d335927e 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -851,8 +851,8 @@ static int cpmac_set_ringparam(struct net_device *dev,
 static void cpmac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "cpmac", sizeof(info->driver));
-	strlcpy(info->version, CPMAC_VERSION, sizeof(info->version));
+	strscpy(info->driver, "cpmac", sizeof(info->driver));
+	strscpy(info->version, CPMAC_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s", "cpmac");
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index ed66c4d4d830..312250c642bb 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1172,9 +1172,9 @@ static void cpsw_get_drvinfo(struct net_device *ndev,
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	struct platform_device	*pdev = to_platform_device(cpsw->dev);
 
-	strlcpy(info->driver, "cpsw", sizeof(info->driver));
-	strlcpy(info->version, "1.0", sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, "cpsw", sizeof(info->driver));
+	strscpy(info->version, "1.0", sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static int cpsw_set_pauseparam(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 353e58b22c51..007de15179f0 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1146,9 +1146,9 @@ static void cpsw_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev;
 
 	pdev = to_platform_device(cpsw->dev);
-	strlcpy(info->driver, "cpsw-switch", sizeof(info->driver));
-	strlcpy(info->version, "2.0", sizeof(info->version));
-	strlcpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->driver, "cpsw-switch", sizeof(info->driver));
+	strscpy(info->version, "2.0", sizeof(info->version));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
 }
 
 static int cpsw_set_pauseparam(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 2a3e4e842fa5..0d6a099d6b68 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -374,8 +374,8 @@ static char *emac_rxhost_errcodes[16] = {
 static void emac_get_drvinfo(struct net_device *ndev,
 			     struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, emac_version_string, sizeof(info->driver));
-	strlcpy(info->version, EMAC_MODULE_VERSION, sizeof(info->version));
+	strscpy(info->driver, emac_version_string, sizeof(info->driver));
+	strscpy(info->version, EMAC_MODULE_VERSION, sizeof(info->version));
 }
 
 /**
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 741c42c6a417..b3da76efa8f5 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -762,12 +762,12 @@ static void tlan_get_drvinfo(struct net_device *dev,
 {
 	struct tlan_priv *priv = netdev_priv(dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	if (priv->pci_dev)
-		strlcpy(info->bus_info, pci_name(priv->pci_dev),
+		strscpy(info->bus_info, pci_name(priv->pci_dev),
 			sizeof(info->bus_info));
 	else
-		strlcpy(info->bus_info, "EISA",	sizeof(info->bus_info));
+		strscpy(info->bus_info, "EISA",	sizeof(info->bus_info));
 }
 
 static int tlan_get_eeprom_len(struct net_device *dev)
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 3dbfb1b20649..6e838e8f79d0 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1187,8 +1187,8 @@ int gelic_net_open(struct net_device *netdev)
 void gelic_net_get_drvinfo(struct net_device *netdev,
 			   struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static int gelic_ether_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
index 93110dba0bfa..fef9fd127b5e 100644
--- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
+++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
@@ -63,12 +63,12 @@ spider_net_ethtool_get_drvinfo(struct net_device *netdev,
 	card = netdev_priv(netdev);
 
 	/* clear and fill out info */
-	strlcpy(drvinfo->driver, spider_net_driver_name,
+	strscpy(drvinfo->driver, spider_net_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, VERSION, sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, "no information",
+	strscpy(drvinfo->version, VERSION, sizeof(drvinfo->version));
+	strscpy(drvinfo->fw_version, "no information",
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, pci_name(card->pdev),
+	strscpy(drvinfo->bus_info, pci_name(card->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 47aab9c132c8..b50be67b398b 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1956,9 +1956,9 @@ static void tc35815_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 {
 	struct tc35815_local *lp = netdev_priv(dev);
 
-	strlcpy(info->driver, MODNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(lp->pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, MODNAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(lp->pci_dev), sizeof(info->bus_info));
 }
 
 static u32 tc35815_get_msglevel(struct net_device *dev)
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 509c5e9b29df..29cde0bec4b1 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2281,8 +2281,8 @@ static void netdev_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 {
 	struct device *hwdev = dev->dev.parent;
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, dev_name(hwdev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(hwdev), sizeof(info->bus_info));
 }
 
 static int netdev_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index ff0c102cb578..5d710ebb9680 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3419,13 +3419,13 @@ static void velocity_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
 {
 	struct velocity_info *vptr = netdev_priv(dev);
 
-	strlcpy(info->driver, VELOCITY_NAME, sizeof(info->driver));
-	strlcpy(info->version, VELOCITY_VERSION, sizeof(info->version));
+	strscpy(info->driver, VELOCITY_NAME, sizeof(info->driver));
+	strscpy(info->version, VELOCITY_VERSION, sizeof(info->version));
 	if (vptr->pdev)
-		strlcpy(info->bus_info, pci_name(vptr->pdev),
+		strscpy(info->bus_info, pci_name(vptr->pdev),
 						sizeof(info->bus_info));
 	else
-		strlcpy(info->bus_info, "platform", sizeof(info->bus_info));
+		strscpy(info->bus_info, "platform", sizeof(info->bus_info));
 }
 
 static void velocity_ethtool_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index acd78120e53c..634946e87e5f 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -719,9 +719,9 @@ static void w5100_hw_close(struct w5100_priv *priv)
 static void w5100_get_drvinfo(struct net_device *ndev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 773f8c77909a..b0958fe8111e 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -282,9 +282,9 @@ static void w5300_hw_close(struct w5300_priv *priv)
 static void w5300_get_drvinfo(struct net_device *ndev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev_name(ndev->dev.parent),
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(ndev->dev.parent),
 		sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1760930ec0c4..52e05895823e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1317,8 +1317,8 @@ static const struct net_device_ops axienet_netdev_ops = {
 static void axienet_ethtools_get_drvinfo(struct net_device *ndev,
 					 struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
-	strlcpy(ed->version, DRIVER_VERSION, sizeof(ed->version));
+	strscpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
+	strscpy(ed->version, DRIVER_VERSION, sizeof(ed->version));
 }
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 016a9c4f2c6c..05848ff15fb5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1060,7 +1060,7 @@ static bool get_bool(struct platform_device *ofdev, const char *s)
 static void xemaclite_ethtools_get_drvinfo(struct net_device *ndev,
 					   struct ethtool_drvinfo *ed)
 {
-	strlcpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
+	strscpy(ed->driver, DRIVER_NAME, sizeof(ed->driver));
 }
 
 static const struct ethtool_ops xemaclite_ethtool_ops = {
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index f9587e55b842..894e92ef415b 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1402,7 +1402,7 @@ do_open(struct net_device *dev)
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "xirc2ps_cs", sizeof(info->driver));
+	strscpy(info->driver, "xirc2ps_cs", sizeof(info->driver));
 	snprintf(info->bus_info, sizeof(info->bus_info), "PCMCIA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 3591b9edc9a1..dc81674f5d38 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -999,11 +999,11 @@ static void ixp4xx_get_drvinfo(struct net_device *dev,
 {
 	struct port *port = netdev_priv(dev);
 
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	snprintf(info->fw_version, sizeof(info->fw_version), "%u:%u:%u:%u",
 		 port->firmware[0], port->firmware[1],
 		 port->firmware[2], port->firmware[3]);
-	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
+	strscpy(info->bus_info, "internal", sizeof(info->bus_info));
 }
 
 static int ixp4xx_get_ts_info(struct net_device *dev,
-- 
2.35.1

