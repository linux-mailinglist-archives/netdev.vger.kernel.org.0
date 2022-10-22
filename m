Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FEF60850E
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 08:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJVGZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 02:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJVGZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 02:25:38 -0400
Received: from mxout1.routing.net (mxout1.routing.net [IPv6:2a03:2900:1:a::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4E11905FC;
        Fri, 21 Oct 2022 23:25:34 -0700 (PDT)
Received: from mxbox1.masterlogin.de (unknown [192.168.10.88])
        by mxout1.routing.net (Postfix) with ESMTP id 013F441A2A;
        Sat, 22 Oct 2022 06:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1666419932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZMqoiUKL2i4Kmd4ZRsFKh8NDUy/+nQ+GenjiN4Z6LvA=;
        b=PlUurBxGweiNyiYCpxqgtFWbQiYIbqmCRWfy09ocSy5GC/sUpxXW2TMQP8umz1xjm5rCzh
        VrP8WPiway3wqKDwpITQFytHbY+AYUNBSrgzk0ga8Crg9Fq76HN5cmJWXUduVEiPG2zz/4
        YSkvqZk0NmTn7e2tUgOdoGtI8uiVHq0=
Received: from [127.0.0.1] (fttx-pool-80.245.73.148.bambit.de [80.245.73.148])
        by mxbox1.masterlogin.de (Postfix) with ESMTPSA id E27054030E;
        Sat, 22 Oct 2022 06:25:30 +0000 (UTC)
Date:   Sat, 22 Oct 2022 08:25:26 +0200
From:   Frank Wunderlich <linux@fw-web.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>
CC:     linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
User-Agent: K-9 Mail for Android
In-Reply-To: <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de> <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk> <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de> <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk> <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55> <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk> <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55> <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
Message-ID: <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mail-ID: 57565e2b-1798-4544-8b83-796b855bbc18
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21=2E Oktober 2022 23:28:09 MESZ schrieb "Russell King (Oracle)" <linux@=
armlinux=2Eorg=2Euk>:
>On Fri, Oct 21, 2022 at 09:52:36PM +0200, Frank Wunderlich wrote:
>> > Gesendet: Freitag, 21=2E Oktober 2022 um 20:31 Uhr
>> > Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
>>=20
>> > On Fri, Oct 21, 2022 at 07:47:47PM +0200, Frank Wunderlich wrote:
>> > > > Gesendet: Freitag, 21=2E Oktober 2022 um 11:06 Uhr
>> > > > Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
>>=20
>> > > > Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BM=
CR in
>> > > > the low 16 bits, and BMSR in the upper 16 bits, so:
>> > > >
>> > > > At address 4, I'd expect the PHYSID=2E
>> > > > At address 8, I'd expect the advertisement register in the low 16=
 bits
>> > > > and the link partner advertisement in the upper 16 bits=2E
>> > > >
>> > > > Can you try an experiment, and in mtk_sgmii_init() try accessing =
the
>> > > > regmap at address 0, 4, and 8 and print their contents please?
>> > >
>> > > is this what you want to see?
>>=20
>> > > [    1=2E083359] dev: 0 offset:0 0x840140
>> > > [    1=2E083376] dev: 0 offset:4 0x4d544950
>> > > [    1=2E086955] dev: 0 offset:8 0x1
>> > > [    1=2E090697] dev: 1 offset:0 0x81140
>> > > [    1=2E093866] dev: 1 offset:4 0x4d544950
>> > > [    1=2E097342] dev: 1 offset:8 0x1
>> >
>> > Thanks=2E Decoding these=2E=2E=2E
>> >
>> > dev 0:
>> >  BMCR: fixed, full duplex, 1000Mbps, !autoneg
>> >  BMSR: link up
>> >  Phy ID: 0x4d54 0x4950
>> >  Advertise: 0x0001 (which would correspond with the MAC side of SGMII=
)
>> >  Link partner: 0x0000 (no advertisement received, but we're not using
>> >     negotiation=2E)
>> >
>> > dev 1:
>> >  BMCR: autoneg (full duplex, 1000Mbps - both would be ignored)
>> >  BMSR: able to do autoneg, no link
>> >  Phy ID: 0x4d54 0x4950
>> >  Advertise: 0x0001 (same as above)
>> >  Link partner: 0x0000 (no advertisement received due to no link)
>> >
>> > Okay, what would now be interesting is to see how dev 1 behaves when
>> > it has link with a 1000base-X link partner that is advertising
>> > properly=2E If this changes to 0x01e0 or similar (in the high 16-bits
>> > of offset 8) then we definitely know that this is an IEEE PHY registe=
r
>> > set laid out in memory, and we can program the advertisement and read
>> > the link partner's abilities=2E
>>=20
>> added register-read on the the new get_state function too
>>=20
>> on bootup it is now a bit different
>>=20
>> [    1=2E086283] dev: 0 offset:0 0x40140 #was previously 0x840140
>> [    1=2E086301] dev: 0 offset:4 0x4d544950
>> [    1=2E089795] dev: 0 offset:8 0x1
>> [    1=2E093584] dev: 1 offset:0 0x81140
>> [    1=2E096716] dev: 1 offset:4 0x4d544950
>> [    1=2E100191] dev: 1 offset:8 0x1
>>=20
>> root@bpi-r3:~# ip link set eth1 up
>> [  172=2E037519] mtk_soc_eth 15100000=2Eethernet eth1: configuring for =
inband/1000base-x link mode
>> root@bpi-r3:~#
>> [  172=2E102949] offset:0 0x40140 #still same value
>
>If this is "dev: 1" the value has changed - the ANENABLE bit has been
>turned off, which means it's not going to bother receiving or sending
>the 16-bit control word=2E Bit 12 needs to stay set for it to perform
>the exchange=2E

Your right,was confused that dev 0 (fixed link to switch chip) had differe=
nt value=2E

offset:0 0x81140 =3D> 0x40140

So i should change offset 8 (currently 0x1) to at least 0x1 | BIT(12)? I c=
an try to set this in the get_state callback,but i'm unsure i can read out =
it on my switch (basic mode changes yes,but not the value directly)=2E=2E=
=2Eif mode is not autoneg i will see no change there=2E

regards Frank
