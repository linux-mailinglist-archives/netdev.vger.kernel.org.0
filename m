Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1670653B56E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 10:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFBIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 04:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiFBIwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 04:52:13 -0400
X-Greylist: delayed 468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 01:52:08 PDT
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [IPv6:2001:1600:4:17::190e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D1A9D4C5
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 01:52:08 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LDKLl046yzMprjq;
        Thu,  2 Jun 2022 10:44:15 +0200 (CEST)
Received: from [10.0.0.141] (unknown [31.10.206.125])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4LDKLk1DMszlk1FD;
        Thu,  2 Jun 2022 10:44:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pschenker.ch;
        s=20220412; t=1654159454;
        bh=mV7mkCUjOl6hMSevGR59+xlFQCqBQ4WwdymyF0opzUY=;
        h=Subject:From:Reply-To:To:Cc:Date:In-Reply-To:References:From;
        b=TVJFhJK9EsLdiqX+KhfpvkfTgssVCX73VGWmPkbBNWLdNRINdU7AzH0KLslewDaPE
         0/OcSegpEggQ+NuLItKAQexi9dmhEjTtYaqWsf2yWmCCCWHigsxq3jh0KmXREU+xJC
         BCkuo08R2hje4EXErOkpDVna9rJTAIVc9SsHLJrw=
Message-ID: <2c5a6bb34c67c9c15c393346e89bdb14ae6f3c44.camel@pschenker.ch>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Philippe Schenker <dev@pschenker.ch>
Reply-To: dev@pschenker.ch
To:     sean.wang@mediatek.com
Cc:     deren.wu@mediatek.com, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, nbd@nbd.name, linux@leemhuis.info,
        davem@davemloft.net, kuba@kernel.org, lorenzo.bianconi83@gmail.com,
        matthias.bgg@gmail.com, pabeni@redhat.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, yn.chen@mediatek.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Date:   Thu, 02 Jun 2022 10:44:13 +0200
In-Reply-To: <1654122203-26090-1-git-send-email-sean.wang@mediatek.com>
References: <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch--annotate>
         <1654122203-26090-1-git-send-email-sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-02 at 06:23 +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
>=20
> > On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
> > > On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> > > > Philippe Schenker <dev@pschenker.ch> writes:
> > > >=20
> > > > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > > > >=20
> > > > > This commit introduces a regression on some systems where the
> > > > > kernel is crashing in different locations after a reboot was
> > > > > issued.
> > > > >=20
> > > > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with
> > > > > latest
> > > > > firmware.
> > > > >=20
> > > > > Link:
> > > > > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireles=
s
> > > > > /5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/_
> > > > > _;!!
> > > > > CTRNKA9wMg0ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B9
> > > > > 9Q14
> > > > > J4iDycWA9cq36Y$
> > > > >=20
> > > > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> > > >=20
> > > > Can I take this to wireless tree? Felix, ack?
> > > >=20
> > > > I'll also add:
> > > >=20
> > > > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> > > >=20
> > >=20
> > > Hi Kalle,
> > >=20
> > > We have a patch for a similar problem. Can you wait for the
> > > verification by Philippe?
> > > Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
> > > after
> > > reboot")
> > > Link:
> > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kern=
e
> > > l/git/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76
> > > ?id=3D
> > > 602cc0c9618a819ab00ea3c9400742a0ca318380__;!!CTRNKA9wMg0ARbw!3N9I3
> > > iKwS
> > > 3XCNAb4LuhbFqt_el1yiOaJzSdUjaJsTaxRCHiWhXnEgbk3bOqYTy6T$
> > >=20
> > > I can reproduce the problem in my v5.16-rc5 desktop. And the issue
> > > can
> > > be fixed when the patch applied.
> > >=20
> > >=20
> > > Hi Philippe,
> > >=20
> > > Can you please help to check the patch in your platform?
> >=20
> > Hi Kalle and Deren,
> >=20
> > I just noticed on my system and mainline v5.18 reboots do now work
> > however Bluetooth is no longer accessible after a reboot.
> >=20
> > Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top of
> > v5.18 solves this problem for me.
> >=20
> > @Deren are you aware of this bug?
> > @Kalle Is there a bugtracker somewhere I can submit this?
>=20
> Hi Philippe,
>=20
> Could you try the latest firmware to see if it can help with the issue
> you reported here ?
>=20
> Please check out
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.g=
it/tree/mediatek
> and replace the following three files in /lib/firmware/mediatek on
> your target and reboot
> 1) BT_RAM_CODE_MT7961_1_2_hdr.bin
> 2) WIFI_MT7961_patch_mcu_1_2_hdr.bin
> 3) WIFI_RAM_CODE_MT7961_1.bin
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Sean

Hi Sean,

Thanks for your suggestion. I downloaded the firmwares from the link you
indicated and downloaded the three firmwares from main branch. I checked
and the sha256sums of the most recent firmwares match with the one
installed by my distribution. So I already had latest versions on my
tests.

Philippe

>=20
> >=20
> > Thanks,
> > Philippe
> >=20
> > >=20
> > >=20
> > > Regards,
> > > Deren
> > >=20
> >=20
> >=20
> >=20

