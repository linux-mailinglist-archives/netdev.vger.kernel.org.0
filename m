Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E84B7787
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiBOQpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:45:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbiBOQpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:45:18 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868671019EF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 08:45:07 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id j15so15121710lfe.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 08:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4reGk+E2DQBcoIJcAVd0N9JCDFB30OHH1yKp7piXzTY=;
        b=YcEfyIKEivRBnLwbo3YrAW9cTeW7ijaOtyPN8i6BjDXMvKggDqaKLA37c4tbuptYdf
         jZXHEyccJI8+4HSkhMizKfr+Fw4K0n7bRkqO9skUVeWFbYW6YEzLdvE/JzqIR8ndG8bn
         /Fgmean/WtywBt9pycit0qED0rspILZzXTzFiiH9+aPXuR1nvdgL1kY4Wf6kVDi4z+GY
         YlM0Vy3hfHSg5KNtzfaww5tTuSNxNZPR2K7niOuK22Gat9TQwCJuf3siuWidvKM+gseR
         HpFugKBhaJV6pDRFKegFHA79+fSgq6+u74gCir9dcUzmZLj1w9ymwWb5LOJ7Ypgzrd/b
         GOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4reGk+E2DQBcoIJcAVd0N9JCDFB30OHH1yKp7piXzTY=;
        b=7AWaoiBairi2NmkREBaNG39OrHd61kDiWwi1s7eSk3YHgIUpH0SV9/Q++ZDfhtn9Zr
         trFlQ6+C9fIxIi6pxva+ItHiMrKBLOsC2IOJo/kcf6NeGjhARvmGqrftXT3Z2gYIZsnh
         RCn4cROCp9kBgS4GVO8tebu2w975cAB+hwfkPlZqAaNstX43Wth5Al5yZy0YhRkKuzoV
         nSkIyydIGuEr9IOqR4a3AC0vRvLwKTiDJWwxaHCBdIhWqXgnz/hBF+dzc7Hvygs3DIEu
         1SFSrljim8EumgKGIoUa+AECEh+4pJU4lcCcqaj/5aSlG/2RJ86RS0YmCdcnErzlvXvg
         /vbQ==
X-Gm-Message-State: AOAM530Dqpbio45NYiIdOsFGWORG0m6OZsXg8HkVWzwe9QEbcuNCRX3K
        gsg8mJn5dcFPgdhaH0YhTI1hSaR4GlwrWP/HIUWUAw==
X-Google-Smtp-Source: ABdhPJxzYZsL0qxq//O7Dcs8406Ccopyz/H0z2PceH5VWjjBo+QppXvSefU/F2M2Hv6YFjEfneizaH5OJj/pTR3hvk8=
X-Received: by 2002:a05:6512:acb:: with SMTP id n11mr666261lfu.428.1644943505712;
 Tue, 15 Feb 2022 08:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20220214231852.3331430-1-jeremy.linton@arm.com>
 <CAPv3WKczaLS8zKwTyEXTCD=YEVF5KcDGTr0uqM-7=MKahMQJYA@mail.gmail.com> <33a8e31c-c271-2e3a-36cf-caea5a7527dc@arm.com>
In-Reply-To: <33a8e31c-c271-2e3a-36cf-caea5a7527dc@arm.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 15 Feb 2022 17:44:53 +0100
Message-ID: <CAPv3WKftMRJ0KRXu5+t_Y8MYDd4u0C74QZfsjUjwo7bvonN89w@mail.gmail.com>
Subject: Re: [BUG/PATCH v3] net: mvpp2: always set port pcs ops
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

wt., 15 lut 2022 o 15:37 Jeremy Linton <jeremy.linton@arm.com> napisa=C5=82=
(a):
>
> Hi,
>
> On 2/15/22 02:38, Marcin Wojtas wrote:
> > Hi Jeremy,
> >
> >
> > wt., 15 lut 2022 o 00:18 Jeremy Linton <jeremy.linton@arm.com> napisa=
=C5=82(a):
> >>
> >> Booting a MACCHIATObin with 5.17, the system OOPs with
> >> a null pointer deref when the network is started. This
> >> is caused by the pcs->ops structure being null in
> >> mcpp2_acpi_start() when it tries to call pcs_config().
> >>
> >> Hoisting the code which sets pcs_gmac.ops and pcs_xlg.ops,
> >> assuring they are always set, fixes the problem.
> >>
> >> The OOPs looks like:
> >> [   18.687760] Unable to handle kernel access to user memory outside u=
access routines at virtual address 0000000000000010
> >> [   18.698561] Mem abort info:
> >> [   18.698564]   ESR =3D 0x96000004
> >> [   18.698567]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> >> [   18.709821]   SET =3D 0, FnV =3D 0
> >> [   18.714292]   EA =3D 0, S1PTW =3D 0
> >> [   18.718833]   FSC =3D 0x04: level 0 translation fault
> >> [   18.725126] Data abort info:
> >> [   18.729408]   ISV =3D 0, ISS =3D 0x00000004
> >> [   18.734655]   CM =3D 0, WnR =3D 0
> >> [   18.738933] user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000111bb=
f000
> >> [   18.745409] [0000000000000010] pgd=3D0000000000000000, p4d=3D000000=
0000000000
> >> [   18.752235] Internal error: Oops: 96000004 [#1] SMP
> >> [   18.757134] Modules linked in: rfkill ip_set nf_tables nfnetlink qr=
tr sunrpc vfat fat omap_rng fuse zram xfs crct10dif_ce mvpp2 ghash_ce sbsa_=
gwdt phylink xhci_plat_hcd ahci_plam
> >> [   18.773481] CPU: 0 PID: 681 Comm: NetworkManager Not tainted 5.17.0=
-0.rc3.89.fc36.aarch64 #1
> >> [   18.781954] Hardware name: Marvell                         Armada 7=
k/8k Family Board      /Armada 7k/8k Family Board      , BIOS EDK II Jun  4=
 2019
> >> [   18.795222] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS B=
TYPE=3D--)
> >> [   18.802213] pc : mvpp2_start_dev+0x2b0/0x300 [mvpp2]
> >> [   18.807208] lr : mvpp2_start_dev+0x298/0x300 [mvpp2]
> >> [   18.812197] sp : ffff80000b4732c0
> >> [   18.815522] x29: ffff80000b4732c0 x28: 0000000000000000 x27: ffffcc=
ab38ae57f8
> >> [   18.822689] x26: ffff6eeb03065a10 x25: ffff80000b473a30 x24: ffff80=
000b4735b8
> >> [   18.829855] x23: 0000000000000000 x22: 00000000000001e0 x21: ffff6e=
eb07b6ab68
> >> [   18.837021] x20: ffff6eeb07b6ab30 x19: ffff6eeb07b6a9c0 x18: 000000=
0000000014
> >> [   18.844187] x17: 00000000f6232bfe x16: ffffccab899b1dc0 x15: 000000=
006a30f9fa
> >> [   18.851353] x14: 000000003b77bd50 x13: 000006dc896f0e8e x12: 001bbb=
fccfd0d3a2
> >> [   18.858519] x11: 0000000000001528 x10: 0000000000001548 x9 : ffffcc=
ab38ad0fb0
> >> [   18.865685] x8 : ffff80000b473330 x7 : 0000000000000000 x6 : 000000=
0000000000
> >> [   18.872851] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff80=
000b4732f8
> >> [   18.880017] x2 : 000000000000001a x1 : 0000000000000002 x0 : ffff6e=
eb07b6ab68
> >> [   18.887183] Call trace:
> >> [   18.889637]  mvpp2_start_dev+0x2b0/0x300 [mvpp2]
> >> [   18.894279]  mvpp2_open+0x134/0x2b4 [mvpp2]
> >> [   18.898483]  __dev_open+0x128/0x1e4
> >> [   18.901988]  __dev_change_flags+0x17c/0x1d0
> >> [   18.906187]  dev_change_flags+0x30/0x70
> >> [   18.910038]  do_setlink+0x278/0xa7c
> >> [   18.913540]  __rtnl_newlink+0x44c/0x7d0
> >> [   18.917391]  rtnl_newlink+0x5c/0x8c
> >> [   18.920892]  rtnetlink_rcv_msg+0x254/0x314
> >> [   18.925006]  netlink_rcv_skb+0x48/0x10c
> >> [   18.928858]  rtnetlink_rcv+0x24/0x30
> >> [   18.932449]  netlink_unicast+0x290/0x2f4
> >> [   18.936386]  netlink_sendmsg+0x1d0/0x41c
> >> [   18.940323]  sock_sendmsg+0x60/0x70
> >> [   18.943825]  ____sys_sendmsg+0x248/0x260
> >> [   18.947762]  ___sys_sendmsg+0x74/0xa0
> >> [   18.951438]  __sys_sendmsg+0x64/0xcc
> >> [   18.955027]  __arm64_sys_sendmsg+0x30/0x40
> >> [   18.959140]  invoke_syscall+0x50/0x120
> >> [   18.962906]  el0_svc_common.constprop.0+0x4c/0xf4
> >> [   18.967629]  do_el0_svc+0x30/0x9c
> >> [   18.970958]  el0_svc+0x28/0xb0
> >> [   18.974025]  el0t_64_sync_handler+0x10c/0x140
> >> [   18.978400]  el0t_64_sync+0x1a4/0x1a8
> >> [   18.982078] Code: 52800004 b9416262 aa1503e0 52800041 (f94008a5)
> >> [   18.988196] ---[ end trace 0000000000000000 ]---
> >>
> >> Fixes: cff056322372 ("net: mvpp2: use .mac_select_pcs() interface")
> >> Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> >> ---
> >> v1->v2: Apply Russell's fix
> >> v2->v3: Fix Russell's name
> >>
> >>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers=
/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> index 7cdbf8b8bbf6..1a835b48791b 100644
> >> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> @@ -6870,6 +6870,9 @@ static int mvpp2_port_probe(struct platform_devi=
ce *pdev,
> >>          dev->max_mtu =3D MVPP2_BM_JUMBO_PKT_SIZE;
> >>          dev->dev.of_node =3D port_node;
> >>
> >> +       port->pcs_gmac.ops =3D &mvpp2_phylink_gmac_pcs_ops;
> >> +       port->pcs_xlg.ops =3D &mvpp2_phylink_xlg_pcs_ops;
> >> +
> >>          if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
> >>                  port->phylink_config.dev =3D &dev->dev;
> >>                  port->phylink_config.type =3D PHYLINK_NETDEV;
> >> @@ -6940,9 +6943,6 @@ static int mvpp2_port_probe(struct platform_devi=
ce *pdev,
> >>                                    port->phylink_config.supported_inte=
rfaces);
> >>                  }
> >>
> >> -               port->pcs_gmac.ops =3D &mvpp2_phylink_gmac_pcs_ops;
> >> -               port->pcs_xlg.ops =3D &mvpp2_phylink_xlg_pcs_ops;
> >> -
> >>                  phylink =3D phylink_create(&port->phylink_config, por=
t_fwnode,
> >>                                           phy_mode, &mvpp2_phylink_ops=
);
> >>                  if (IS_ERR(phylink)) {
> >> --
> >> 2.34.1
> >>
> >
> > I'd like to test the patch - what EDK2 version are you using?
>
> I don't have access to the machine at the moment (maybe in a couple days
> again) but it was running a build from late 2019 IIRC. So, definitely
> not a bleeding edge version for sure.
>

2019 is enough indicator that most likely there is no MDIO description
in ACPI. Let me test the patch, thanks.

Best regards,
Marcin
