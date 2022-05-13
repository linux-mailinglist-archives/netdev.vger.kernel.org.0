Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6202052654B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358481AbiEMO5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiEMO5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:57:03 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1757F1ADA7;
        Fri, 13 May 2022 07:56:59 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B0CC55C02A8;
        Fri, 13 May 2022 10:56:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 May 2022 10:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1652453816; x=1652540216; bh=ApxgE/i4QJ
        LCnf4e8EgH1mLEMeZ9xY6FBsGE7xPR6I4=; b=ERkyC//3dVG6pP8hMXQKfMpWMf
        vqPtGBU6sgkMzpSSahRJTY4yDctCdgO0CXkETjQ0JLoYQCP5bbwNHeCLD0Qf6Zhk
        Ex4Xpcuk81swvDe0PwAZuBOB5xLXO3TLocDiBmWMXjSct4Q8ZVR1eUhzn8xdh7ud
        RmciT48yk/ELtyHCHLiO/cqXPyz1O3ZFm2bTR1+x8RHswtGH3y+bsaYrw2lY3s/r
        gelw/laQfG83uQLmtAIPgRIS+5bs4825TwpvCR4UMw6qbrnVQVmvtpr/1CXfJ98/
        aLl7lDIffxf9Wsg3Hd3knkEJ0KCfh7U7Z80dngKOoAO8sIBef5qXZV3eRPBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652453816; x=
        1652540216; bh=ApxgE/i4QJLCnf4e8EgH1mLEMeZ9xY6FBsGE7xPR6I4=; b=V
        YBBoPd7P86Px4FQtXiQ+9C8H7Xyi5XrTMWl1HTUxDwnKEUSLzVxtq6CdhKs37zZ3
        GwxD3c6N7XGaeJywrJ1k+ODalKtl+noN+AlYwcWC1GnNIUIwJeQn26Oa6XZPkWzf
        PRWV9ocSbTeml/7ZcVg8TcMAWmXESbqkD7q4LdwACDLHNpacCB2hzXQ8svqN/0Q5
        esPxh4+xYDr3eMBcIzqmlTqDne/dSn/u8FVokzrZ75SewVGOPt06d1Rx3j76VpWS
        PGxRMyvei0ripbz+Jw3gXpAd0spCkclFJ525e895EXQrcLDDj+PEYIw8NnVInjGd
        EHHeWE1N26emng/L0Q+Xw==
X-ME-Sender: <xms:uHF-Ykae1U-MGO0u7f9vUReHLny7RNVqMS11BJV3xAX83DBx2qPBeg>
    <xme:uHF-YvZjpc7uM8pUSkV81lYW8wocRXk8_66xaksCLcPKnNFlvefjwupvGsZM2coR5
    1R32n8e2nPzhvibvg8>
X-ME-Received: <xmr:uHF-Yu_rYgYnAFY48uRIIATZ7v6VHDXumydEWDCXLYNBS_9yjC7GDxJcAsv91g6Ji8zts0UqphezFPsDUGOwHg1d9FeNnSgH8PhTGMc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeelgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepteefffefgfektdefgfeludfgtdejfeejvddttdekteeiffejvdfgheehfffh
    vedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:uHF-YuqaTp8b7OiDx148axScPvyAlk22TovPGHRK9tUJ1pQsY0Ci7g>
    <xmx:uHF-Yvr1oWtZRalWuDhuVg0IwZOlbCddIZ7G2HPFPbmg4rJ_wtiFww>
    <xmx:uHF-YsTzUmZejFFoiFJUNbzp3Z9ETTle6Wi1sg3j7br4pS9Ahhdlzw>
    <xmx:uHF-YgnI61QQTC-qUqJbjG9J1tjZc7qlmh3WTE8pe2cmoXQj4bEJPA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 May 2022 10:56:56 -0400 (EDT)
Date:   Fri, 13 May 2022 16:56:53 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20220513145653.rb7tah6dbjxc2fab@houat>
References: <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pndtf2rjhjgtbxdj"
Content-Disposition: inline
In-Reply-To: <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pndtf2rjhjgtbxdj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Sorry for reviving this old thread...

On Thu, Jun 10, 2021 at 02:33:17PM -0700, Florian Fainelli wrote:
> On 6/2/2021 6:28 AM, Maxime Ripard wrote:
> > On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wrote:
> >> On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
> >>>> That is also how I boot my Pi4 at home, and I suspect you are right,=
 if
> >>>> the VPU does not shut down GENET's DMA, and leaves buffer addresses =
in
> >>>> the on-chip descriptors that point to an address space that is manag=
ed
> >>>> totally differently by Linux, then we can have a serious problem and
> >>>> create some memory corruption when the ring is being reclaimed. I wi=
ll
> >>>> run a few experiments to test that theory and there may be a solution
> >>>> using the SW_INIT reset controller to have a big reset of the contro=
ller
> >>>> before handing it over to the Linux driver.
> >>>
> >>> Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
> >>> that the TX or RX DMA have been left running during the hand over from
> >>> the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to redu=
ce
> >>> as much as possible the differences between your set-up and my set-up
> >>> but so far have not been able to reproduce the crash in booting from =
NFS
> >>> repeatedly, I will try again.
> >>
> >> FWIW I can reproduce the error too. That said it's rather hard to repr=
oduce,
> >> something in the order of 1 failure every 20 tries.
> >=20
> > Yeah, it looks like it's only from a cold boot and comes in "bursts",
> > where you would get like 5 in a row and be done with it for a while.
>=20
> Here are two patches that you could try exclusive from one another
>=20
> 1) Limit GENET to a single queue
>=20
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index fcca023f22e5..e400c12e6868 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3652,6 +3652,12 @@ static int bcmgenet_change_carrier(struct
> net_device *dev, bool new_carrier)
>         return 0;
>  }
>=20
> +static u16 bcmgenet_select_queue(struct net_device *dev, struct sk_buff
> *skb,
> +                                struct net_device *sb_dev)
> +{
> +       return 0;
> +}
> +
>  static const struct net_device_ops bcmgenet_netdev_ops =3D {
>         .ndo_open               =3D bcmgenet_open,
>         .ndo_stop               =3D bcmgenet_close,
> @@ -3666,6 +3672,7 @@ static const struct net_device_ops
> bcmgenet_netdev_ops =3D {
>  #endif
>         .ndo_get_stats          =3D bcmgenet_get_stats,
>         .ndo_change_carrier     =3D bcmgenet_change_carrier,
> +       .ndo_select_queue       =3D bcmgenet_select_queue,
>  };
>=20
>  /* Array of GENET hardware parameters/characteristics */
>=20
> 2) Ensure that all TX/RX queues are disabled upon DMA initialization
>=20
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index fcca023f22e5..7f8a5996fbbb 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3237,15 +3237,21 @@ static void bcmgenet_get_hw_addr(struct
> bcmgenet_priv *priv,
>  /* Returns a reusable dma control register value */
>  static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
>  {
> +       unsigned int i;
>         u32 reg;
>         u32 dma_ctrl;
>=20
>         /* disable DMA */
>         dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
> +       for (i =3D 0; i < priv->hw_params->tx_queues; i++)
> +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
>         reg =3D bcmgenet_tdma_readl(priv, DMA_CTRL);
>         reg &=3D ~dma_ctrl;
>         bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
>=20
> +       dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
> +       for (i =3D 0; i < priv->hw_params->rx_queues; i++)
> +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
>         reg =3D bcmgenet_rdma_readl(priv, DMA_CTRL);
>         reg &=3D ~dma_ctrl;
>         bcmgenet_rdma_writel(priv, reg, DMA_CTRL);

It looks like current upstream still has this issue, which also upsets KASA=
N:

[   16.798433] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   16.809347] BUG: KASAN: wild-memory-access in skb_release_data+0x124/0x2=
70
[   16.816379] Read of size 8 at addr 80800000807f2e0c by task swapper/0/0
[   16.823122]
[   16.824655] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.0-rc5-v8+ #210
[   16.831581] Hardware name: Raspberry Pi 4 Model B Rev 1.1 (DT)
[   16.837525] Call trace:
[   16.840025]  dump_backtrace.part.0+0x1dc/0x1f0
[   16.844576]  show_stack+0x24/0x80
[   16.847974]  dump_stack_lvl+0x8c/0xb8
[   16.851735]  print_report+0x1cc/0x240
[   16.855494]  kasan_report+0xb4/0x120
[   16.859161]  __asan_load8+0xa0/0xc4
[   16.862743]  skb_release_data+0x124/0x270
[   16.866849]  consume_skb+0x74/0xe0
[   16.870337]  __dev_kfree_skb_any+0x74/0x90
[   16.874538]  bcmgenet_desc_rx+0x4b4/0x620
[   16.878642]  bcmgenet_rx_poll+0x78/0x150
[   16.882657]  __napi_poll.constprop.0+0x64/0x240
[   16.887290]  net_rx_action+0x4d4/0x590
[   16.891127]  __do_softirq+0x228/0x4d8
[   16.894875]  __irq_exit_rcu+0x1e4/0x24c
[   16.898806]  irq_exit_rcu+0x20/0x54
[   16.902382]  el1_interrupt+0x38/0x50
[   16.906051]  el1h_64_irq_handler+0x18/0x2c
[   16.910250]  el1h_64_irq+0x64/0x68
[   16.913733]  arch_local_irq_enable+0xc/0x20
[   16.918010]  default_idle_call+0x80/0x114
[   16.922118]  cpuidle_idle_call+0x1e0/0x224
[   16.926310]  do_idle+0x104/0x14c
[   16.929616]  cpu_startup_entry+0x34/0x3c
[   16.933630]  rest_init+0x180/0x200
[   16.937113]  arch_post_acpi_subsys_init+0x0/0x30
[   16.941840]  start_kernel+0x3c8/0x400
[   16.945592]  __primary_switched+0xa8/0xb0
[   16.949699] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   16.957052] Disabling lock debugging due to kernel taint
[   16.962507] Unable to handle kernel paging request at virtual address 80=
800000807f2e0c
[   16.970590] Mem abort info:
[   16.973461]   ESR =3D 0x96000004
[   16.976602]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   16.982038]   SET =3D 0, FnV =3D 0
[   16.985176]   EA =3D 0, S1PTW =3D 0
[   16.988403]   FSC =3D 0x04: level 0 translation fault
[   16.993440] Data abort info:
[   16.996401]   ISV =3D 0, ISS =3D 0x00000004
[   17.000333]   CM =3D 0, WnR =3D 0
[   17.003384] [80800000807f2e0c] address between user and kernel address r=
anges
[   17.010674] Internal error: Oops: 96000004 [#1] SMP
[   17.015651] Modules linked in:
[   17.018784] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B             5.=
18.0-rc5-v8+ #210
[   17.027115] Hardware name: Raspberry Pi 4 Model B Rev 1.1 (DT)
[   17.033052] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   17.040148] pc : skb_release_data+0x124/0x270
[   17.044603] lr : skb_release_data+0x124/0x270
[   17.049055] sp : ffffffc00a477690
[   17.052434] x29: ffffffc00a477690 x28: 0000000000000000 x27: ffffff8043c=
feb42
[   17.059744] x26: 0000000000000001 x25: ffffff8040a5d5be x24: 00000000fff=
fffff
[   17.067049] x23: ffffff8043cfeb40 x22: 0000000000000000 x21: ffffff8040a=
5d540
[   17.074355] x20: ffffff8043cfeb70 x19: 80800000807f2e04 x18: 00000000ee6=
397dc
[   17.081661] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
[   17.088961] x14: 0000000000000000 x13: 746e696174206c65 x12: ffffffb8015=
67cf9
[   17.096265] x11: 1ffffff801567cf8 x10: ffffffb801567cf8 x9 : dfffffc0000=
00000
[   17.103572] x8 : ffffffc00ab3e7c7 x7 : 0000000000000001 x6 : ffffffb8015=
67cf8
[   17.110875] x5 : ffffffc00ab3e7c0 x4 : ffffffb801567cf9 x3 : 00000000000=
00000
[   17.118178] x2 : 0000000000000020 x1 : ffffffc00a48e7c0 x0 : 00000000000=
00001
[   17.125481] Call trace:
[   17.127978]  skb_release_data+0x124/0x270
[   17.132083]  consume_skb+0x74/0xe0
[   17.135567]  __dev_kfree_skb_any+0x74/0x90
[   17.139764]  bcmgenet_desc_rx+0x4b4/0x620
[   17.143863]  bcmgenet_rx_poll+0x78/0x150
[   17.147873]  __napi_poll.constprop.0+0x64/0x240
[   17.152503]  net_rx_action+0x4d4/0x590
[   17.156338]  __do_softirq+0x228/0x4d8
[   17.160083]  __irq_exit_rcu+0x1e4/0x24c
[   17.164008]  irq_exit_rcu+0x20/0x54
[   17.167580]  el1_interrupt+0x38/0x50
[   17.171247]  el1h_64_irq_handler+0x18/0x2c
[   17.175444]  el1h_64_irq+0x64/0x68
[   17.178923]  arch_local_irq_enable+0xc/0x20
[   17.183197]  default_idle_call+0x80/0x114
[   17.187301]  cpuidle_idle_call+0x1e0/0x224
[   17.191490]  do_idle+0x104/0x14c
[   17.194793]  cpu_startup_entry+0x34/0x3c
[   17.198803]  rest_init+0x180/0x200
[   17.202283]  arch_post_acpi_subsys_init+0x0/0x30
[   17.207006]  start_kernel+0x3c8/0x400
[   17.210755]  __primary_switched+0xa8/0xb0
[   17.214872] Code: 72001c1f 540001e1 91002260 97d3086f (f9400660)
[   17.221083] ---[ end trace 0000000000000000 ]---
[   17.225791] Kernel panic - not syncing: Oops: Fatal exception in interru=
pt
[   17.232785] SMP: stopping secondary CPUs
[   17.236795] Kernel Offset: disabled
[   17.240348] CPU features: 0x100,00000d08,00001086
[   17.245143] Memory Limit: none
[   17.248273] ---[ end Kernel panic - not syncing: Oops: Fatal exception i=
n interrupt ]---

This is at boot, over TFTP and NFS on a RaspberryPi4

Maxime

--pndtf2rjhjgtbxdj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYn5xtQAKCRDj7w1vZxhR
xfaKAP0Tz3mBxiu68M4h2HWacy+X5pVo59TLW3wVNsrEx+Js9wEAuQBetftXhC0W
COz93bcJGfe+Wi4ICbh5V+aU2yTqUgQ=
=mMDo
-----END PGP SIGNATURE-----

--pndtf2rjhjgtbxdj--
