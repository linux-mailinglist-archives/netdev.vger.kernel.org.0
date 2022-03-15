Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA74D92BF
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 03:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbiCOC6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 22:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbiCOC6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 22:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDA423BC1;
        Mon, 14 Mar 2022 19:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FA5561032;
        Tue, 15 Mar 2022 02:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304EC340E9;
        Tue, 15 Mar 2022 02:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647313057;
        bh=vbVGF4busbB1SfADP/S6ab+VlgQgMMbCFKeAOde9lxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ibGF1JNpawiYXF+YouYnMoja2x/89B7ZomKzO1ypHHAIJvEWfos4ZgfAjwvrdK1bW
         bb8IjVBpGr/vcvo4HTeoKFWd6ixhROA0EYpMfsOpSu1NdFS2Pm2lc5A8o3bad5+GuW
         zthRHNz/tE5pDqfV4Raqpa+UHFCJuZvX4/EYx+TqNMyC0D9SpHNqDv2+sqxgwf9Zex
         A/JX11fTy7IqH9zdY/Plc7bvH4n7yN1wLL2t46Npej3Sw1bD72GngxRPWZDmQHRBfu
         LvLd2FhZQV6ab/v/oiw9jqQbhxRtupjrvRJ5gszcgaqYTtayg9SUFHPprha/48rdMX
         3fxQij6Qdq1Eg==
Date:   Mon, 14 Mar 2022 19:57:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Manish Chopra <manishc@marvell.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        it+netdev@molgen.mpg.de, regressions@lists.linux.dev
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Message-ID: <20220314195735.6ada196d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9513e74e-c682-d891-a5de-c9a82c5cf9d3@molgen.mpg.de>
References: <20211217165552.746-1-manishc@marvell.com>
        <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
        <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
        <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
        <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
        <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <0dafa9d7-9c79-f367-a343-8ad38f7bde07@molgen.mpg.de>
        <9513e74e-c682-d891-a5de-c9a82c5cf9d3@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 16:07:08 +0100 Paul Menzel wrote:
> > There might be something more wrong with the patch in the subject: The=
=20
> > usability of the ports from a single card (with older firmware?) now=20
> > depends on the order the ports are enabled (first port enabled is=20
> > working, second port enabled is not working, driver complaining about a=
=20
> > firmware mismatch).
> >=20
> > In the following examples, the driver was not built-in to the kernel bu=
t=20
> > loaded from the root filesystem instead, so there is no initramfs=20
> > related problem here.
> >=20
> > For the records:
> >=20
> > root@ira:~# dmesg|grep bnx2x
> > [=C2=A0=C2=A0 18.749871] bnx2x 0000:45:00.0: msix capability found
> > [=C2=A0=C2=A0 18.766534] bnx2x 0000:45:00.0: part number 394D4342-31373=
735-31314131-473331
> > [=C2=A0=C2=A0 18.799198] bnx2x 0000:45:00.0: 32.000 Gb/s available PCIe=
 bandwidth (5.0 GT/s PCIe x8 link)
> > [=C2=A0=C2=A0 18.807638] bnx2x 0000:45:00.1: msix capability found
> > [=C2=A0=C2=A0 18.824509] bnx2x 0000:45:00.1: part number 394D4342-31373=
735-31314131-473331
> > [=C2=A0=C2=A0 18.857171] bnx2x 0000:45:00.1: 32.000 Gb/s available PCIe=
 bandwidth (5.0 GT/s PCIe x8 link)
> > [=C2=A0=C2=A0 18.865619] bnx2x 0000:46:00.0: msix capability found
> > [=C2=A0=C2=A0 18.882636] bnx2x 0000:46:00.0: part number 394D4342-31373=
735-31314131-473331
> > [=C2=A0=C2=A0 18.915196] bnx2x 0000:46:00.0: 32.000 Gb/s available PCIe=
 bandwidth (5.0 GT/s PCIe x8 link)
> > [=C2=A0=C2=A0 18.923636] bnx2x 0000:46:00.1: msix capability found
> > [=C2=A0=C2=A0 18.940505] bnx2x 0000:46:00.1: part number 394D4342-31373=
735-31314131-473331
> > [=C2=A0=C2=A0 18.973167] bnx2x 0000:46:00.1: 32.000 Gb/s available PCIe=
 bandwidth (5.0 GT/s PCIe x8 link)
> > [=C2=A0=C2=A0 46.480660] bnx2x 0000:45:00.0 net04: renamed from eth4
> > [=C2=A0=C2=A0 46.494677] bnx2x 0000:45:00.1 net05: renamed from eth5
> > [=C2=A0=C2=A0 46.508544] bnx2x 0000:46:00.0 net06: renamed from eth6
> > [=C2=A0=C2=A0 46.524641] bnx2x 0000:46:00.1 net07: renamed from eth7
> > root@ira:~# ls /lib/firmware/bnx2x/
> > bnx2x-e1-6.0.34.0.fw=C2=A0=C2=A0 bnx2x-e1-7.13.1.0.fw=C2=A0=C2=A0 bnx2x=
-e1-7.8.2.0.fw    =20
> > bnx2x-e1h-7.12.30.0.fw=C2=A0 bnx2x-e1h-7.8.19.0.fw=C2=A0 bnx2x-e2-7.10.=
51.0.fw=C2=A0 bnx2x-e2-7.8.17.0.fw
> > bnx2x-e1-6.2.5.0.fw=C2=A0=C2=A0=C2=A0 bnx2x-e1-7.13.11.0.fw=C2=A0 bnx2x=
-e1h-6.0.34.0.fw  =20
> > bnx2x-e1h-7.13.1.0.fw=C2=A0=C2=A0 bnx2x-e1h-7.8.2.0.fw=C2=A0=C2=A0 bnx2=
x-e2-7.12.30.0.fw=C2=A0 bnx2x-e2-7.8.19.0.fw
> > bnx2x-e1-6.2.9.0.fw=C2=A0=C2=A0=C2=A0 bnx2x-e1-7.13.15.0.fw=C2=A0 bnx2x=
-e1h-6.2.5.0.fw   =20
> > bnx2x-e1h-7.13.11.0.fw=C2=A0 bnx2x-e2-6.0.34.0.fw=C2=A0=C2=A0 bnx2x-e2-=
7.13.1.0.fw=C2=A0=C2=A0 bnx2x-e2-7.8.2.0.fw
> > bnx2x-e1-7.0.20.0.fw=C2=A0=C2=A0 bnx2x-e1-7.13.21.0.fw=C2=A0 bnx2x-e1h-=
6.2.9.0.fw   =20
> > bnx2x-e1h-7.13.15.0.fw=C2=A0 bnx2x-e2-6.2.5.0.fw=C2=A0=C2=A0=C2=A0 bnx2=
x-e2-7.13.11.0.fw
> > bnx2x-e1-7.0.23.0.fw=C2=A0=C2=A0 bnx2x-e1-7.2.16.0.fw=C2=A0=C2=A0 bnx2x=
-e1h-7.0.20.0.fw  =20
> > bnx2x-e1h-7.13.21.0.fw=C2=A0 bnx2x-e2-6.2.9.0.fw=C2=A0=C2=A0=C2=A0 bnx2=
x-e2-7.13.15.0.fw
> > bnx2x-e1-7.0.29.0.fw=C2=A0=C2=A0 bnx2x-e1-7.2.51.0.fw=C2=A0=C2=A0 bnx2x=
-e1h-7.0.23.0.fw  =20
> > bnx2x-e1h-7.2.16.0.fw=C2=A0=C2=A0 bnx2x-e2-7.0.20.0.fw=C2=A0=C2=A0 bnx2=
x-e2-7.13.21.0.fw
> > bnx2x-e1-7.10.51.0.fw=C2=A0 bnx2x-e1-7.8.17.0.fw=C2=A0=C2=A0 bnx2x-e1h-=
7.0.29.0.fw  =20
> > bnx2x-e1h-7.2.51.0.fw=C2=A0=C2=A0 bnx2x-e2-7.0.23.0.fw=C2=A0=C2=A0 bnx2=
x-e2-7.2.16.0.fw
> > bnx2x-e1-7.12.30.0.fw=C2=A0 bnx2x-e1-7.8.19.0.fw=C2=A0=C2=A0 bnx2x-e1h-=
7.10.51.0.fw =20
> > bnx2x-e1h-7.8.17.0.fw=C2=A0=C2=A0 bnx2x-e2-7.0.29.0.fw=C2=A0=C2=A0 bnx2=
x-e2-7.2.51.0.fw
> >=20
> > Now with v5.10.95, the first kernel of the series which includes=20
> > fdcfabd0952d ("bnx2x: Utilize firmware 7.13.21.0") and later:
> >=20
> > root@ira:~# dmesg -w &
> > [...]
> > root@ira:~# ip link set net04 up
> > [=C2=A0=C2=A0 88.504536] bnx2x 0000:45:00.0 net04: using MSI-X=C2=A0 IR=
Qs: sp 47=C2=A0 fp[0] 49 ... fp[7] 56
> > root@ira:~# ip link set net05 up
> > [=C2=A0=C2=A0 90.825820] bnx2x: [bnx2x_compare_fw_ver:2380(net05)]bnx2x=
 with FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
> > RTNETLINK answers: Device or resource busy
> > root@ira:~# ip link set net04 down
> > root@ira:~# ip link set net05 down
> > root@ira:~# ip link set net05 up
> > [=C2=A0 114.462448] bnx2x 0000:45:00.1 net05: using MSI-X=C2=A0 IRQs: s=
p 58=C2=A0 fp[0] 60 ... fp[7] 67
> > root@ira:~# ip link set net04 up
> > [=C2=A0 117.247763] bnx2x: [bnx2x_compare_fw_ver:2380(net04)]bnx2x with=
 FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
> > RTNETLINK answers: Device or resource busy
> >=20
> > With v5.10.94, both ports work fine:
> >=20
> > root@ira:~# dmesg -w &
> > [...]
> > root@ira:~# ip link set net04 up
> > [=C2=A0 133.126647] bnx2x 0000:45:00.0 net04: using MSI-X=C2=A0 IRQs: s=
p 47=C2=A0 fp[0] 49 ... fp[7] 56
> > root@ira:~# ip link set net05 up
> > [=C2=A0 136.215169] bnx2x 0000:45:00.1 net05: using MSI-X=C2=A0 IRQs: s=
p 58=C2=A0 fp[0] 60 ... fp[7] 67 =20
>=20
> One additional note, that it=E2=80=99s totally unclear to us, where FW ve=
rsion=20
> 120d07 in the error message comes from. It maps to 7.13.18.0, which is=20
> nowhere to be found and too new to be on the cards EEPROM, which should=20
> be from 2013 or so.

Hrm, any chance an out-of-tree driver or another OS loaded it?
Does the dmesg indicate that the host loaded the FW at all?
Looks like upstream went from .15 to .21, .18 was never in the picture.

Also, will the revert work for you?
