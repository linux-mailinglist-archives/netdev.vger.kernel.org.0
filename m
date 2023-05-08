Return-Path: <netdev+bounces-867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E2A6FB0ED
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F227D280F20
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208A51362;
	Mon,  8 May 2023 13:11:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7411361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:11:25 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E34B86BF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:11:23 -0700 (PDT)
Received: from maia.denx.de (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: hws@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id C85618472A;
	Mon,  8 May 2023 15:11:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1683551480;
	bh=kFTy1HFxA6TjrrG30+5je60VEzCjRcWjuezuFo+5A5s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=e5vOC4j+GlxV5JeeJGK2oR3mNh7znDB7g0DERNgKsRAscoYHGJWbq7YT1tnPyPURM
	 565oxwm9q/sCXf0XH66XBR12gPPkPH1B1emaNAIqUR3BDxS1K+J01MChAp3t9VmOaz
	 wszmgBLu9R5LLooaBM9KJ7VHhtMCXvZKxNsaVAdzgcHoJkiAq1Oz22y9gkRx36CMgX
	 q9WIX8u3JueQRYZTi/efXbnulFfJ/PBe/OJe3HCEzQbJMjX+1/iugPwmPpjMJKd1SB
	 Pzfdzv/ur90r4CIl2R9YwkHEHBmYcJFkz5DToHoiXmctjlmFtum79sIOR5e3vlZ56S
	 2TDIlHWJfctcA==
Message-ID: <fb5174e6b774e4ccda1fe274f01601661201e324.camel@denx.de>
Subject: Re: [PATCH] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
From: Harald Seiler <hws@denx.de>
To: Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Eric Dumazet <edumazet@google.com>, 
 Francesco Dolcini <francesco.dolcini@toradex.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Jakub Kicinski <kuba@kernel.org>, Jose Abreu
 <joabreu@synopsys.com>, Marcel Ziswiler <marcel.ziswiler@toradex.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,  Paolo Abeni
 <pabeni@redhat.com>, linux-arm-kernel@lists.infradead.org, 
 linux-stm32@st-md-mailman.stormreply.com
Date: Mon, 08 May 2023 15:11:19 +0200
In-Reply-To: <20230506235845.246105-1-marex@denx.de>
References: <20230506235845.246105-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Marek,

On Sun, 2023-05-07 at 01:58 +0200, Marek Vasut wrote:
> Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
> from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
> and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
> be sent out.
>=20
> i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
> 11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
> defines this register as:
> "
> This register controls the generation of the Reference time (1 microsecon=
d
> tic) for all the LPI timers. This timer has to be programmed by the softw=
are
> initially.
> ...
> The application must program this counter so that the number of clock cyc=
les
> of CSR clock is 1us. (Subtract 1 from the value before programming).
> For example if the CSR clock is 100MHz then this field needs to be progra=
mmed
> to value 100 - 1 =3D 99 (which is 0x63).
> This is required to generate the 1US events that are used to update some =
of
> the EEE related counters.
> "
>=20
> The reset value is 0x63 on i.MX8M Plus, which means expected CSR clock ar=
e
> 100 MHz. However, the i.MX8M Plus "enet_qos_root_clk" are 266 MHz instead=
,
> which means the LPI timers reach their count much sooner on this platform=
.
>=20
> This is visible using a scope by monitoring e.g. exit from LPI mode on TX=
_CTL
> line from MAC to PHY. This should take 30us per STMMAC_DEFAULT_TWT_LS set=
ting,
> during which the TX_CTL line transitions from tristate to low, and 30 us =
later
> from low to high. On i.MX8M Plus, this transition takes 11 us, which matc=
hes
> the 30us * 100/266 formula for misconfigured MAC_ONEUS_TIC_COUNTER regist=
er.
>=20
> Configure MAC_ONEUS_TIC_COUNTER based on CSR clock, so that the LPI timer=
s
> have correct 1us reference. This then fixes EEE on i.MX8M Plus with Micre=
l
> KSZ9131RNX PHY.
>=20
> Signed-off-by: Marek Vasut <marex@denx.de>

Tested on STM32MP157 with KSZ9131RNX at 1000Mb/s.  This patch makes the
network as reliable with EEE active as it is with EEE disabled.  So

Tested-by: Harald Seiler <hws@denx.de>

> ---
> NOTE: The hint that this might be related to LPI timer misconfiguration
>       came from sending large fragmented ICMP request, i.e.
>       ping -4 -c 1 -s 4096 -I eth1 192.168.1.1
>       The received packets consistently missed the 1st fragment, because
>       the LPI exit time was too short and the first packet was likely
>       pushed out of the MAC while the PHY was still not ready for it.
> NOTE: I suspect this can help with Toradex ELB-3757, Marcel, can you plea=
se
>       test this patch on i.MX8M Plus Verdin ?
>       https://developer-archives.toradex.com/software/linux/release-detai=
ls?module=3DVerdin+iMX8M+Plus&key=3DELB-3757
> NOTE: STM32MP15xx sets 'ethmac' clock to 266.5 MHz, so this patch likely
>       helps there as well. The default value of MAC_ONEUS_TIC_COUNTER on
>       this platform is also 0x63, i.e. expected 100 MHz CSR clock. I can
>       not test this with KSZ9131RNX as I do not have any STM32MP15xx
>       board with this PHY. Harald, can you please test ?
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Francesco Dolcini <francesco.dolcini@toradex.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Harald Seiler <hws@denx.de>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 5 +++++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/e=
thernet/stmicro/stmmac/dwmac4.h
> index 4538f334df576..d3c5306f1c41f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> @@ -181,6 +181,7 @@ enum power_event {
>  #define GMAC4_LPI_CTRL_STATUS	0xd0
>  #define GMAC4_LPI_TIMER_CTRL	0xd4
>  #define GMAC4_LPI_ENTRY_TIMER	0xd8
> +#define GMAC4_MAC_ONEUS_TIC_COUNTER	0xdc
> =20
>  /* LPI control and status defines */
>  #define GMAC4_LPI_CTRL_STATUS_LPITCSE	BIT(21)	/* LPI Tx Clock Stop Enabl=
e */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/=
net/ethernet/stmicro/stmmac/dwmac4_core.c
> index afaec3fb9ab66..03b1c5a97826e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -25,6 +25,7 @@ static void dwmac4_core_init(struct mac_device_info *hw=
,
>  	struct stmmac_priv *priv =3D netdev_priv(dev);
>  	void __iomem *ioaddr =3D hw->pcsr;
>  	u32 value =3D readl(ioaddr + GMAC_CONFIG);
> +	u32 clk_rate;
> =20
>  	value |=3D GMAC_CORE_INIT;
> =20
> @@ -47,6 +48,10 @@ static void dwmac4_core_init(struct mac_device_info *h=
w,
> =20
>  	writel(value, ioaddr + GMAC_CONFIG);
> =20
> +	/* Configure LPI 1us counter to number of CSR clock ticks in 1us - 1 */
> +	clk_rate =3D clk_get_rate(priv->plat->stmmac_clk);
> +	writel((clk_rate / 1000000) - 1, ioaddr + GMAC4_MAC_ONEUS_TIC_COUNTER);
> +
>  	/* Enable GMAC interrupts */
>  	value =3D GMAC_INT_DEFAULT_ENABLE;
> =20

