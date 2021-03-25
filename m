Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C68349513
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCYPNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:13:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46454 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCYPNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:13:34 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210325151330euoutp014a5afecb5961a4908bb9c80c2978b125~vnqI3pB0G0975709757euoutp01v
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 15:13:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210325151330euoutp014a5afecb5961a4908bb9c80c2978b125~vnqI3pB0G0975709757euoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616685210;
        bh=ZGPa5fVfRSfinWPEDgHLOSPhuIAIXOEQc5LsF6R8+T0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=KczXuYOyelZZbiTscoyDcgtv5FDN3T1IFToWikhcaYMzNWvN5SB/9lOBUdCTxV4cd
         W9tb8ZfKa1q0pqs/CLYwVLrSowSbcViPLnhY9aXJvOJZLGk8Z2nyvG+KG3JTqc3Hbi
         HMxaygmNRShexfjw5+kEnG+o6SmOl+irpHGGBm9A=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210325151330eucas1p2b44a1cd5a985f1446aee9d07573fb5d6~vnqINy9rZ2540425404eucas1p2B;
        Thu, 25 Mar 2021 15:13:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CA.9B.09444.998AC506; Thu, 25
        Mar 2021 15:13:29 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2~vnqHjIUeL0274602746eucas1p1H;
        Thu, 25 Mar 2021 15:13:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210325151329eusmtrp13566a4fb7964bf6cfd7aa2d4dad12e54~vnqHh826z0469304693eusmtrp1m;
        Thu, 25 Mar 2021 15:13:29 +0000 (GMT)
X-AuditID: cbfec7f4-dd5ff700000024e4-70-605ca8991f98
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A3.13.08705.998AC506; Thu, 25
        Mar 2021 15:13:29 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210325151328eusmtip121817def291fafd9bbb1528249748d7b~vnqGaAwUk0952909529eusmtip1B;
        Thu, 25 Mar 2021 15:13:28 +0000 (GMT)
Subject: Re: [PATCH net-next] net: stmmac: support FPE link partner
 hand-shaking procedure
To:     mohammad.athari.ismail@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, Chuah@vger.kernel.org,
        Kim Tatt <kim.tatt.chuah@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Neil Armstrong <narmstrong@baylibre.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <ccd0e43b-b4f4-8074-83dc-eb59c5ddb969@samsung.com>
Date:   Thu, 25 Mar 2021 16:13:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324090742.3413-1-mohammad.athari.ismail@intel.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZduznOd2ZK2ISDHYds7bY+OQ0o8WT9YvY
        LC6v2MdiMed8C4vFyud32S3uLXrHarFv7RtWiwvb+lgtFszmttj0+BqrxeVdc9gsuq49YbU4
        NHUvo8W8v2uBrEPvmSwO9UVbHFsgZvH/9VZGixXPutgtZj/Yy2ax9MgMdgdRj8vXLjJ7vL/R
        yu6xZeVNJo+ds+6yeyze85LJY9OqTjaPzUvqPTa+28HkcXCfocfTH3uZPbbs/8zo8XmTXABP
        FJdNSmpOZllqkb5dAlfGisdTWApe7Ges2P24namB8fcsxi5GTg4JAROJSasWsYLYQgIrGCWm
        n6iCsL8wSnR+yexi5AKyPzNK7H55gh2mYeXygywQieWMEv8OzmaHcD4ySky8PxFsrLBAjMTu
        k11sIAkRgUvMEtdO/gFrYRY4wSSxa/0WJpAqNgFDia63IFWcHLwCdhJ/t/WB2SwCqhLft/cD
        NXBwiAokSWw4FAtRIihxcuYTFhCbU8BV4kv/SjCbWUBeonnrbGYIW1zi1pP5TBCnfuKUmHY2
        GsJ2kTj7eCfUC8ISr45vgbJlJE5P7gG7TUKgmVHi4bm17BBOD6PE5aYZ0FCylrhz7hcbyEHM
        ApoS63fpQ4QdJfY8+MQEEpYQ4JO48VYQ4gY+iUnbpjNDhHklOtqEIKrVJGYdXwe39uCFS8wT
        GJVmIflsFpJvZiH5ZhbC3gWMLKsYxVNLi3PTU4uN8lLL9YoTc4tL89L1kvNzNzEC0+npf8e/
        7GBc/uqj3iFGJg7GQ4wSHMxKIrxJvjEJQrwpiZVVqUX58UWlOanFhxilOViUxHmTtqyJFxJI
        TyxJzU5NLUgtgskycXBKNTD5KNZMMAnmvMQy5xyH12qWnOVmPtNqNFfOM5/3e9fRFcsfbWx4
        EB62qG9uY26P08ROqfRJkquO+UXKnypk9l5wL4775b+w0OWvbyg7z7Y1W/t7foJQ/9K8ZxZp
        cUJXRfbkvDU2fHHwwc3fRnvEn22XKEqd2jtB6Rafx+Inr/qT3fZ93mP7ZPOpK147zy79l3rB
        x2T/x6MRV478YORQ45bsMdTr3pa06Us7z9pk+Rd3viy+/fzCoyt8Bq4Jr0/8XNy/UJsz+Trf
        61bj3fr2nDyZnZ935ryU7J36ckr/epmuIuNjSh+3MkjP9XV2drA9cJaNcSVXZvzShDQeV8sM
        zR++PR0qvBxHss2M3Fi1r9cpsRRnJBpqMRcVJwIAEqIG6hYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t/xu7ozV8QkGMx4yWex8clpRosn6xex
        WVxesY/FYs75FhaLlc/vslvcW/SO1WLf2jesFhe29bFaLJjNbbHp8TVWi8u75rBZdF17wmpx
        aOpeRot5f9cCWYfeM1kc6ou2OLZAzOL/662MFiuedbFbzH6wl81i6ZEZ7A6iHpevXWT2eH+j
        ld1jy8qbTB47Z91l91i85yWTx6ZVnWwem5fUe2x8t4PJ4+A+Q4+nP/Yye2zZ/5nR4/MmuQCe
        KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2MFY+n
        sBS82M9YsftxO1MD4+9ZjF2MnBwSAiYSK5cfZOli5OIQEljKKHHnXQ8LREJG4uS0BlYIW1ji
        z7UuNoii94wSzU/+ghUJC8RI7D4JkuDkEBG4wiwx6ZgsSBGzwAkmiev3roJ1Cwm4SDTf72EH
        sdkEDCW63kI08ArYSfzd1gdmswioSnzf3g82VFQgSeLykomsEDWCEidnPgGLcwq4SnzpXwlm
        MwuYSczb/JAZwpaXaN46G8oWl7j1ZD7TBEahWUjaZyFpmYWkZRaSlgWMLKsYRVJLi3PTc4sN
        9YoTc4tL89L1kvNzNzECU8i2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrxJvjEJQrwpiZVVqUX5
        8UWlOanFhxhNgf6ZyCwlmpwPTGJ5JfGGZgamhiZmlgamlmbGSuK8W+euiRcSSE8sSc1OTS1I
        LYLpY+LglGpgatZesWm65tWQW6lbLh1iWanUV75z8o0Hldd9HnFF1C64mJLzddL2gs+3a/Qk
        NG7PvbDktI+UBWOW7oI7O/JkL7/f/LFQdcaa3wr/DvVZx7bYfPfwX5wXdEXrV7v8JDXLhk1N
        Hh7q4TPOrTpyvUzGd+WUj+yRh4N2PXqm0X1hysqlz+4ee3rgj9D8WSoLb8+V60mPz5zZYZUi
        ovg4S/yT+af3//eG7V6SEhtxoft0mWOJ45GzmxdYS6/dVHD2857oZznM2q1W2xWa3q9s4juf
        8n3F1o/BdT+/bWd0Fox4LV6ybsOhXx+/LY50F0p0kn18/rvzIYXVyS+WNf56vIvlwT3zikbh
        zr6PbWzn/Lo41+krsRRnJBpqMRcVJwIAXlYkeaoDAAA=
X-CMS-MailID: 20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2
References: <20210324090742.3413-1-mohammad.athari.ismail@intel.com>
        <CGME20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24.03.2021 10:07, mohammad.athari.ismail@intel.com wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
>
> In order to discover whether remote station supports frame preemption,
> local station sends verify mPacket and expects response mPacket in
> return from the remote station.
>
> So, we add the functions to send and handle event when verify mPacket
> and response mPacket are exchanged between the networked stations.
>
> The mechanism to handle different FPE states between local and remote
> station (link partner) is implemented using workqueue which starts a
> task each time there is some sign of verify & response mPacket exchange
> as check in FPE IRQ event. The task retries couple of times to try to
> spot the states that both stations are ready to enter FPE ON. This allows
> different end points to enable FPE at different time and verify-response
> mPacket can happen asynchronously. Ultimately, the task will only turn
> FPE ON when local station have both exchange response in both directions.
>
> Thanks to Voon Weifeng for implementing the core functions for detecting
> FPE events and send mPacket and phylink related change.
>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Co-developed-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Co-developed-by: Tan Tee Min <tee.min.tan@intel.com>
> Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
> Co-developed-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

This patch landed in today's linux-next as commit 5a5586112b92 ("net: 
stmmac: support FPE link partner hand-shaking procedure"). It causes the 
following NULL pointer dereference issue on various Amlogic SoC based 
boards:

  meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.0:00] driver [RTL8211F 
Gigabit Ethernet] (irq=35)
  meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
  meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
  meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rgmii link mode
  Unable to handle kernel NULL pointer dereference at virtual address 
0000000000000001
  Mem abort info:
...
  user pgtable: 4k pages, 48-bit VAs, pgdp=00000000044eb000
  [0000000000000001] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 96000004 [#1] PREEMPT SMP
  Modules linked in: dw_hdmi_i2s_audio dw_hdmi_cec meson_gxl realtek 
meson_gxbb_wdt snd_soc_meson_axg_sound_card dwmac_generic axg_audio 
meson_dw_hdmi crct10dif_ce snd_soc_meson_card_utils 
snd_soc_meson_axg_tdmout panfrost rc_odroid gpu_sched 
reset_meson_audio_arb meson_ir snd_soc_meson_g12a_tohdmitx 
snd_soc_meson_axg_frddr sclk_div clk_phase snd_soc_meson_codec_glue 
dwmac_meson8b snd_soc_meson_axg_fifo stmmac_platform meson_rng meson_drm 
stmmac rtc_meson_vrtc rng_core meson_canvas pwm_meson dw_hdmi 
mdio_mux_meson_g12a pcs_xpcs snd_soc_meson_axg_tdm_interface 
snd_soc_meson_axg_tdm_formatter nvmem_meson_efuse display_connector
  CPU: 1 PID: 7 Comm: kworker/u8:0 Not tainted 5.12.0-rc4-next-20210325+ 
#2747
  Hardware name: Hardkernel ODROID-C4 (DT)
  Workqueue: events_power_efficient phylink_resolve
  pstate: 20400009 (nzCv daif +PAN -UAO -TCO BTYPE=--)
  pc : stmmac_mac_link_up+0x14c/0x348 [stmmac]
  lr : stmmac_mac_link_up+0x284/0x348 [stmmac]
...
  Call trace:
   stmmac_mac_link_up+0x14c/0x348 [stmmac]
   phylink_resolve+0x104/0x420
   process_one_work+0x2a8/0x718
   worker_thread+0x48/0x460
   kthread+0x134/0x160
   ret_from_fork+0x10/0x18
  Code: b971ba60 350007c0 f958c260 f9402000 (39400401)
  ---[ end trace 0c9deb6c510228aa ]---

> ---
>   drivers/net/ethernet/stmicro/stmmac/common.h  |   7 +
>   .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   8 +
>   drivers/net/ethernet/stmicro/stmmac/dwmac5.c  |  49 +++++
>   drivers/net/ethernet/stmicro/stmmac/dwmac5.h  |  11 ++
>   drivers/net/ethernet/stmicro/stmmac/hwif.h    |   7 +
>   drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 183 ++++++++++++++++++
>   .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  39 +++-
>   include/linux/stmmac.h                        |  27 +++
>   9 files changed, 331 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
> index 1c0c60bdf854..4511945df802 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
> @@ -315,6 +315,13 @@ enum dma_irq_status {
>   #define	CORE_IRQ_RX_PATH_IN_LPI_MODE	(1 << 2)
>   #define	CORE_IRQ_RX_PATH_EXIT_LPI_MODE	(1 << 3)
>   
> +/* FPE defines */
> +#define FPE_EVENT_UNKNOWN		0
> +#define FPE_EVENT_TRSP			BIT(0)
> +#define FPE_EVENT_TVER			BIT(1)
> +#define FPE_EVENT_RRSP			BIT(2)
> +#define FPE_EVENT_RVER			BIT(3)
> +
>   #define CORE_IRQ_MTL_RX_OVERFLOW	BIT(8)
>   
>   /* Physical Coding Sublayer */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> index 29f765a246a0..95864f014ffa 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -53,6 +53,10 @@ static void dwmac4_core_init(struct mac_device_info *hw,
>   	if (hw->pcs)
>   		value |= GMAC_PCS_IRQ_DEFAULT;
>   
> +	/* Enable FPE interrupt */
> +	if ((GMAC_HW_FEAT_FPESEL & readl(ioaddr + GMAC_HW_FEATURE3)) >> 26)
> +		value |= GMAC_INT_FPE_EN;
> +
>   	writel(value, ioaddr + GMAC_INT_EN);
>   }
>   
> @@ -1245,6 +1249,8 @@ const struct stmmac_ops dwmac410_ops = {
>   	.config_l4_filter = dwmac4_config_l4_filter,
>   	.est_configure = dwmac5_est_configure,
>   	.fpe_configure = dwmac5_fpe_configure,
> +	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
> +	.fpe_irq_status = dwmac5_fpe_irq_status,
>   	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
>   	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
>   	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
> @@ -1294,6 +1300,8 @@ const struct stmmac_ops dwmac510_ops = {
>   	.config_l4_filter = dwmac4_config_l4_filter,
>   	.est_configure = dwmac5_est_configure,
>   	.fpe_configure = dwmac5_fpe_configure,
> +	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
> +	.fpe_irq_status = dwmac5_fpe_irq_status,
>   	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
>   	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
>   	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
> index 0ae85f8adf67..5b010ebfede9 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
> @@ -707,3 +707,52 @@ void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
>   	value |= EFPE;
>   	writel(value, ioaddr + MAC_FPE_CTRL_STS);
>   }
> +
> +int dwmac5_fpe_irq_status(void __iomem *ioaddr, struct net_device *dev)
> +{
> +	u32 value;
> +	int status;
> +
> +	status = FPE_EVENT_UNKNOWN;
> +
> +	value = readl(ioaddr + MAC_FPE_CTRL_STS);
> +
> +	if (value & TRSP) {
> +		status |= FPE_EVENT_TRSP;
> +		netdev_info(dev, "FPE: Respond mPacket is transmitted\n");
> +	}
> +
> +	if (value & TVER) {
> +		status |= FPE_EVENT_TVER;
> +		netdev_info(dev, "FPE: Verify mPacket is transmitted\n");
> +	}
> +
> +	if (value & RRSP) {
> +		status |= FPE_EVENT_RRSP;
> +		netdev_info(dev, "FPE: Respond mPacket is received\n");
> +	}
> +
> +	if (value & RVER) {
> +		status |= FPE_EVENT_RVER;
> +		netdev_info(dev, "FPE: Verify mPacket is received\n");
> +	}
> +
> +	return status;
> +}
> +
> +void dwmac5_fpe_send_mpacket(void __iomem *ioaddr, enum stmmac_mpacket_type type)
> +{
> +	u32 value;
> +
> +	value = readl(ioaddr + MAC_FPE_CTRL_STS);
> +
> +	if (type == MPACKET_VERIFY) {
> +		value &= ~SRSP;
> +		value |= SVER;
> +	} else {
> +		value &= ~SVER;
> +		value |= SRSP;
> +	}
> +
> +	writel(value, ioaddr + MAC_FPE_CTRL_STS);
> +}
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
> index 709bbfc9ae61..ff555d8b0cdf 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
> @@ -12,6 +12,12 @@
>   #define TMOUTEN				BIT(0)
>   
>   #define MAC_FPE_CTRL_STS		0x00000234
> +#define TRSP				BIT(19)
> +#define TVER				BIT(18)
> +#define RRSP				BIT(17)
> +#define RVER				BIT(16)
> +#define SRSP				BIT(2)
> +#define SVER				BIT(1)
>   #define EFPE				BIT(0)
>   
>   #define MAC_PPS_CONTROL			0x00000b70
> @@ -128,6 +134,8 @@
>   #define GMAC_RXQCTRL_VFFQ_SHIFT		17
>   #define GMAC_RXQCTRL_VFFQE		BIT(16)
>   
> +#define GMAC_INT_FPE_EN			BIT(17)
> +
>   int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
>   int dwmac5_safety_feat_irq_status(struct net_device *ndev,
>   		void __iomem *ioaddr, unsigned int asp,
> @@ -145,5 +153,8 @@ void dwmac5_est_irq_status(void __iomem *ioaddr, struct net_device *dev,
>   			   struct stmmac_extra_stats *x, u32 txqcnt);
>   void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
>   			  bool enable);
> +void dwmac5_fpe_send_mpacket(void __iomem *ioaddr,
> +			     enum stmmac_mpacket_type type);
> +int dwmac5_fpe_irq_status(void __iomem *ioaddr, struct net_device *dev);
>   
>   #endif /* __DWMAC5_H__ */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> index 692541c7b419..38cfc2cae129 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> @@ -397,6 +397,9 @@ struct stmmac_ops {
>   			       struct stmmac_extra_stats *x, u32 txqcnt);
>   	void (*fpe_configure)(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
>   			      bool enable);
> +	void (*fpe_send_mpacket)(void __iomem *ioaddr,
> +				 enum stmmac_mpacket_type type);
> +	int (*fpe_irq_status)(void __iomem *ioaddr, struct net_device *dev);
>   };
>   
>   #define stmmac_core_init(__priv, __args...) \
> @@ -497,6 +500,10 @@ struct stmmac_ops {
>   	stmmac_do_void_callback(__priv, mac, est_irq_status, __args)
>   #define stmmac_fpe_configure(__priv, __args...) \
>   	stmmac_do_void_callback(__priv, mac, fpe_configure, __args)
> +#define stmmac_fpe_send_mpacket(__priv, __args...) \
> +	stmmac_do_void_callback(__priv, mac, fpe_send_mpacket, __args)
> +#define stmmac_fpe_irq_status(__priv, __args...) \
> +	stmmac_do_callback(__priv, mac, fpe_irq_status, __args)
>   
>   /* PTP and HW Timer helpers */
>   struct stmmac_hwtimestamp {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index 375c503d2df8..4faad331a4ca 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -234,6 +234,12 @@ struct stmmac_priv {
>   	struct workqueue_struct *wq;
>   	struct work_struct service_task;
>   
> +	/* Workqueue for handling FPE hand-shaking */
> +	unsigned long fpe_task_state;
> +	struct workqueue_struct *fpe_wq;
> +	struct work_struct fpe_task;
> +	char wq_name[IFNAMSIZ + 4];
> +
>   	/* TC Handling */
>   	unsigned int tc_entries_max;
>   	unsigned int tc_off_max;
> @@ -273,6 +279,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv);
>   int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
>   int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
>   int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
> +void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable);
>   
>   #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
>   void stmmac_selftest_run(struct net_device *dev,
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8d7015d3a537..170296820af0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -971,6 +971,21 @@ static void stmmac_mac_an_restart(struct phylink_config *config)
>   	/* Not Supported */
>   }
>   
> +static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
> +{
> +	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
> +	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
> +	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
> +	bool *hs_enable = &fpe_cfg->hs_enable;
> +
> +	if (is_up && *hs_enable) {
> +		stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
> +	} else {
> +		*lo_state = FPE_EVENT_UNKNOWN;
> +		*lp_state = FPE_EVENT_UNKNOWN;
> +	}
> +}
> +
>   static void stmmac_mac_link_down(struct phylink_config *config,
>   				 unsigned int mode, phy_interface_t interface)
>   {
> @@ -981,6 +996,8 @@ static void stmmac_mac_link_down(struct phylink_config *config,
>   	priv->tx_lpi_enabled = false;
>   	stmmac_eee_init(priv);
>   	stmmac_set_eee_pls(priv, priv->hw, false);
> +
> +	stmmac_fpe_link_state_handle(priv, false);
>   }
>   
>   static void stmmac_mac_link_up(struct phylink_config *config,
> @@ -1079,6 +1096,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>   		priv->tx_lpi_enabled = priv->eee_enabled;
>   		stmmac_set_eee_pls(priv, priv->hw, true);
>   	}
> +
> +	stmmac_fpe_link_state_handle(priv, true);
>   }
>   
>   static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> @@ -2793,6 +2812,26 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
>   	}
>   }
>   
> +static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
> +{
> +	char *name;
> +
> +	clear_bit(__FPE_TASK_SCHED, &priv->fpe_task_state);
> +
> +	name = priv->wq_name;
> +	sprintf(name, "%s-fpe", priv->dev->name);
> +
> +	priv->fpe_wq = create_singlethread_workqueue(name);
> +	if (!priv->fpe_wq) {
> +		netdev_err(priv->dev, "%s: Failed to create workqueue\n", name);
> +
> +		return -ENOMEM;
> +	}
> +	netdev_info(priv->dev, "FPE workqueue start");
> +
> +	return 0;
> +}
> +
>   /**
>    * stmmac_hw_setup - setup mac in a usable state.
>    *  @dev : pointer to the device structure.
> @@ -2929,6 +2968,13 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
>   	/* Start the ball rolling... */
>   	stmmac_start_all_dma(priv);
>   
> +	if (priv->dma_cap.fpesel) {
> +		stmmac_fpe_start_wq(priv);
> +
> +		if (priv->plat->fpe_cfg->enable)
> +			stmmac_fpe_handshake(priv, true);
> +	}
> +
>   	return 0;
>   }
>   
> @@ -3090,6 +3136,16 @@ static int stmmac_open(struct net_device *dev)
>   	return ret;
>   }
>   
> +static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
> +{
> +	set_bit(__FPE_REMOVING, &priv->fpe_task_state);
> +
> +	if (priv->fpe_wq)
> +		destroy_workqueue(priv->fpe_wq);
> +
> +	netdev_info(priv->dev, "FPE workqueue stop");
> +}
> +
>   /**
>    *  stmmac_release - close entry point of the driver
>    *  @dev : device pointer.
> @@ -3139,6 +3195,9 @@ static int stmmac_release(struct net_device *dev)
>   
>   	pm_runtime_put(priv->device);
>   
> +	if (priv->dma_cap.fpesel)
> +		stmmac_fpe_stop_wq(priv);
> +
>   	return 0;
>   }
>   
> @@ -4280,6 +4339,48 @@ static int stmmac_set_features(struct net_device *netdev,
>   	return 0;
>   }
>   
> +static void stmmac_fpe_event_status(struct stmmac_priv *priv, int status)
> +{
> +	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
> +	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
> +	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
> +	bool *hs_enable = &fpe_cfg->hs_enable;
> +
> +	if (status == FPE_EVENT_UNKNOWN || !*hs_enable)
> +		return;
> +
> +	/* If LP has sent verify mPacket, LP is FPE capable */
> +	if ((status & FPE_EVENT_RVER) == FPE_EVENT_RVER) {
> +		if (*lp_state < FPE_STATE_CAPABLE)
> +			*lp_state = FPE_STATE_CAPABLE;
> +
> +		/* If user has requested FPE enable, quickly response */
> +		if (*hs_enable)
> +			stmmac_fpe_send_mpacket(priv, priv->ioaddr,
> +						MPACKET_RESPONSE);
> +	}
> +
> +	/* If Local has sent verify mPacket, Local is FPE capable */
> +	if ((status & FPE_EVENT_TVER) == FPE_EVENT_TVER) {
> +		if (*lo_state < FPE_STATE_CAPABLE)
> +			*lo_state = FPE_STATE_CAPABLE;
> +	}
> +
> +	/* If LP has sent response mPacket, LP is entering FPE ON */
> +	if ((status & FPE_EVENT_RRSP) == FPE_EVENT_RRSP)
> +		*lp_state = FPE_STATE_ENTERING_ON;
> +
> +	/* If Local has sent response mPacket, Local is entering FPE ON */
> +	if ((status & FPE_EVENT_TRSP) == FPE_EVENT_TRSP)
> +		*lo_state = FPE_STATE_ENTERING_ON;
> +
> +	if (!test_bit(__FPE_REMOVING, &priv->fpe_task_state) &&
> +	    !test_and_set_bit(__FPE_TASK_SCHED, &priv->fpe_task_state) &&
> +	    priv->fpe_wq) {
> +		queue_work(priv->fpe_wq, &priv->fpe_task);
> +	}
> +}
> +
>   /**
>    *  stmmac_interrupt - main ISR
>    *  @irq: interrupt number.
> @@ -4318,6 +4419,13 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
>   		stmmac_est_irq_status(priv, priv->ioaddr, priv->dev,
>   				      &priv->xstats, tx_cnt);
>   
> +	if (priv->dma_cap.fpesel) {
> +		int status = stmmac_fpe_irq_status(priv, priv->ioaddr,
> +						   priv->dev);
> +
> +		stmmac_fpe_event_status(priv, status);
> +	}
> +
>   	/* To handle GMAC own interrupts */
>   	if ((priv->plat->has_gmac) || xmac) {
>   		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
> @@ -5065,6 +5173,68 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
>   	return ret;
>   }
>   
> +#define SEND_VERIFY_MPAKCET_FMT "Send Verify mPacket lo_state=%d lp_state=%d\n"
> +static void stmmac_fpe_lp_task(struct work_struct *work)
> +{
> +	struct stmmac_priv *priv = container_of(work, struct stmmac_priv,
> +						fpe_task);
> +	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
> +	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
> +	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
> +	bool *hs_enable = &fpe_cfg->hs_enable;
> +	bool *enable = &fpe_cfg->enable;
> +	int retries = 20;
> +
> +	while (retries-- > 0) {
> +		/* Bail out immediately if FPE handshake is OFF */
> +		if (*lo_state == FPE_STATE_OFF || !*hs_enable)
> +			break;
> +
> +		if (*lo_state == FPE_STATE_ENTERING_ON &&
> +		    *lp_state == FPE_STATE_ENTERING_ON) {
> +			stmmac_fpe_configure(priv, priv->ioaddr,
> +					     priv->plat->tx_queues_to_use,
> +					     priv->plat->rx_queues_to_use,
> +					     *enable);
> +
> +			netdev_info(priv->dev, "configured FPE\n");
> +
> +			*lo_state = FPE_STATE_ON;
> +			*lp_state = FPE_STATE_ON;
> +			netdev_info(priv->dev, "!!! BOTH FPE stations ON\n");
> +			break;
> +		}
> +
> +		if ((*lo_state == FPE_STATE_CAPABLE ||
> +		     *lo_state == FPE_STATE_ENTERING_ON) &&
> +		     *lp_state != FPE_STATE_ON) {
> +			netdev_info(priv->dev, SEND_VERIFY_MPAKCET_FMT,
> +				    *lo_state, *lp_state);
> +			stmmac_fpe_send_mpacket(priv, priv->ioaddr,
> +						MPACKET_VERIFY);
> +		}
> +		/* Sleep then retry */
> +		msleep(500);
> +	}
> +
> +	clear_bit(__FPE_TASK_SCHED, &priv->fpe_task_state);
> +}
> +
> +void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
> +{
> +	if (priv->plat->fpe_cfg->hs_enable != enable) {
> +		if (enable) {
> +			stmmac_fpe_send_mpacket(priv, priv->ioaddr,
> +						MPACKET_VERIFY);
> +		} else {
> +			priv->plat->fpe_cfg->lo_fpe_state = FPE_STATE_OFF;
> +			priv->plat->fpe_cfg->lp_fpe_state = FPE_STATE_OFF;
> +		}
> +
> +		priv->plat->fpe_cfg->hs_enable = enable;
> +	}
> +}
> +
>   /**
>    * stmmac_dvr_probe
>    * @device: device pointer
> @@ -5122,6 +5292,9 @@ int stmmac_dvr_probe(struct device *device,
>   
>   	INIT_WORK(&priv->service_task, stmmac_service_task);
>   
> +	/* Initialize Link Partner FPE workqueue */
> +	INIT_WORK(&priv->fpe_task, stmmac_fpe_lp_task);
> +
>   	/* Override with kernel parameters if supplied XXX CRS XXX
>   	 * this needs to have multiple instances
>   	 */
> @@ -5435,8 +5608,18 @@ int stmmac_suspend(struct device *dev)
>   		if (ret)
>   			return ret;
>   	}
> +
>   	mutex_unlock(&priv->lock);
>   
> +	if (priv->dma_cap.fpesel) {
> +		/* Disable FPE */
> +		stmmac_fpe_configure(priv, priv->ioaddr,
> +				     priv->plat->tx_queues_to_use,
> +				     priv->plat->rx_queues_to_use, false);
> +
> +		stmmac_fpe_handshake(priv, false);
> +	}
> +
>   	priv->speed = SPEED_UNKNOWN;
>   	return 0;
>   }
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> index b80cb2985b39..1d84ee359808 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> @@ -297,6 +297,17 @@ static int tc_init(struct stmmac_priv *priv)
>   
>   	dev_info(priv->device, "Enabling HW TC (entries=%d, max_off=%d)\n",
>   			priv->tc_entries_max, priv->tc_off_max);
> +
> +	if (!priv->plat->fpe_cfg) {
> +		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
> +						   sizeof(*priv->plat->fpe_cfg),
> +						   GFP_KERNEL);
> +		if (!priv->plat->fpe_cfg)
> +			return -ENOMEM;
> +	} else {
> +		memset(priv->plat->fpe_cfg, 0, sizeof(*priv->plat->fpe_cfg));
> +	}
> +
>   	return 0;
>   }
>   
> @@ -829,13 +840,10 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
>   	if (fpe && !priv->dma_cap.fpesel)
>   		return -EOPNOTSUPP;
>   
> -	ret = stmmac_fpe_configure(priv, priv->ioaddr,
> -				   priv->plat->tx_queues_to_use,
> -				   priv->plat->rx_queues_to_use, fpe);
> -	if (ret && fpe) {
> -		netdev_err(priv->dev, "failed to enable Frame Preemption\n");
> -		return ret;
> -	}
> +	/* Actual FPE register configuration will be done after FPE handshake
> +	 * is success.
> +	 */
> +	priv->plat->fpe_cfg->enable = fpe;
>   
>   	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
>   				   priv->plat->clk_ptp_rate);
> @@ -845,12 +853,29 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
>   	}
>   
>   	netdev_info(priv->dev, "configured EST\n");
> +
> +	if (fpe) {
> +		stmmac_fpe_handshake(priv, true);
> +		netdev_info(priv->dev, "start FPE handshake\n");
> +	}
> +
>   	return 0;
>   
>   disable:
>   	priv->plat->est->enable = false;
>   	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
>   			     priv->plat->clk_ptp_rate);
> +
> +	priv->plat->fpe_cfg->enable = false;
> +	stmmac_fpe_configure(priv, priv->ioaddr,
> +			     priv->plat->tx_queues_to_use,
> +			     priv->plat->rx_queues_to_use,
> +			     false);
> +	netdev_info(priv->dev, "disabled FPE\n");
> +
> +	stmmac_fpe_handshake(priv, false);
> +	netdev_info(priv->dev, "stop FPE handshake\n");
> +
>   	return ret;
>   }
>   
> diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
> index 10abc80b601e..072f269b1618 100644
> --- a/include/linux/stmmac.h
> +++ b/include/linux/stmmac.h
> @@ -144,6 +144,32 @@ struct stmmac_txq_cfg {
>   	int tbs_en;
>   };
>   
> +/* FPE link state */
> +enum stmmac_fpe_state {
> +	FPE_STATE_OFF = 0,
> +	FPE_STATE_CAPABLE = 1,
> +	FPE_STATE_ENTERING_ON = 2,
> +	FPE_STATE_ON = 3,
> +};
> +
> +/* FPE link-partner hand-shaking mPacket type */
> +enum stmmac_mpacket_type {
> +	MPACKET_VERIFY = 0,
> +	MPACKET_RESPONSE = 1,
> +};
> +
> +enum stmmac_fpe_task_state_t {
> +	__FPE_REMOVING,
> +	__FPE_TASK_SCHED,
> +};
> +
> +struct stmmac_fpe_cfg {
> +	bool enable;				/* FPE enable */
> +	bool hs_enable;				/* FPE handshake enable */
> +	enum stmmac_fpe_state lp_fpe_state;	/* Link Partner FPE state */
> +	enum stmmac_fpe_state lo_fpe_state;	/* Local station FPE state */
> +};
> +
>   struct plat_stmmacenet_data {
>   	int bus_id;
>   	int phy_addr;
> @@ -155,6 +181,7 @@ struct plat_stmmacenet_data {
>   	struct device_node *mdio_node;
>   	struct stmmac_dma_cfg *dma_cfg;
>   	struct stmmac_est *est;
> +	struct stmmac_fpe_cfg *fpe_cfg;
>   	int clk_csr;
>   	int has_gmac;
>   	int enh_desc;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

