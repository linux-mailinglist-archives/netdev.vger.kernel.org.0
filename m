Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2210B470314
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242340AbhLJOt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:49:29 -0500
Received: from ciao.gmane.io ([116.202.254.214]:57628 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242318AbhLJOt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 09:49:27 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1mvh9i-0004K3-BB
        for netdev@vger.kernel.org; Fri, 10 Dec 2021 15:45:50 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: MT7621 ethernet does not get probed on net-next branch after 5.15 merge
Date:   Fri, 10 Dec 2021 17:35:12 +0300
Message-ID: <u55c8i-v7i.ln1@banana.localnet>
References: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com> <CAMhs-H9ve2VtLm8x__DEb0_CpoYsqix1HwLDcZ8_ZeEK9vdfQg@mail.gmail.com>
User-Agent: tin/2.4.6-20210226 ("Glen Albyn") (Linux/5.14.0-0.bpo.2-armmp-lpae (armv7l))
Cc:     linux-mediatek@lists.infradead.org, openwrt-devel@lists.openwrt.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gmane.comp.embedded.openwrt.devel Sergio Paracuellos <sergio.paracuellos@gmail.com> wrote:
> Hi Qingfang,

> On Fri, Oct 15, 2021 at 4:23 PM DENG Qingfang <dqfext@gmail.com> wrote:
> >
> > Hi,
> >
> > After the merge of 5.15.y into net-next, MT7621 ethernet
> > (mtk_eth_soc.c) does not get probed at all.
> >
> > Kernel log before 5.15 merge:
> > ...
> > libphy: Fixed MDIO Bus: probed
> > libphy: mdio: probed
> > mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> > mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 20
> > mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> > ...
> >
> > Kernel log after 5.15 merge:
> > ...
> > libphy: Fixed MDIO Bus: probed
> > mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> > ...
> >
> >
> > I tried adding debug prints into the .mtk_probe function, but it did
> > not execute.
> > There are no dts changes for MT7621 between 5.14 and 5.15, so I
> > believe it should be something else.
> >
> > Any ideas?

> I had time to create a new image for my gnubee board using kernel 5.15
> and this problem does not exist on my side. Since no more mails have
> come for a while I guess this was a problem from your configuration,
> but just in case I preferred to answer to let you know. I am currently
> using v5.15.7 from linux-stable with some other patches that will be
> for 5.16. Just in case, you can check the kernel tree [0] I am
> currently using.

There is problem with reset controller and devlink commutication. reset
controller is abent in mainline, devlink defer all drivers which use reset
lines until reset-controller become available - so no drivers probed.
I'm create for myself this patch:
https://drive.google.com/file/d/1AiKlfvIgtrBsxtI-2XFBvaxGoE0S-s9d/view?usp=sharing

