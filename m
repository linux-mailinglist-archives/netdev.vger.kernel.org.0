Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC47539F9B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiFAIhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245286AbiFAIhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:37:11 -0400
X-Greylist: delayed 513 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jun 2022 01:37:07 PDT
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [83.166.143.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B6F1EC70
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 01:37:06 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LCj3106knzMprL9;
        Wed,  1 Jun 2022 10:28:29 +0200 (CEST)
Received: from [10.0.0.141] (unknown [31.10.206.125])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LCj300xmMzlhs7p;
        Wed,  1 Jun 2022 10:28:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pschenker.ch;
        s=20220412; t=1654072108;
        bh=Mxe97A1GNK58/rOoNSBOXmeHmHULjXJ31P/mKWrLzv4=;
        h=Subject:From:Reply-To:To:Cc:Date:In-Reply-To:References:From;
        b=I+VDQNdDVJO53tsfUev2HYDDi2xbfy+3H92LPzqKmqJBf57b1oH/UVgYjGKgs4Pdb
         wU0PTT2ybRQi5XSUqyvtb5AsTfFbuzSk7vdgjuDSSpSB2YqoIfjAWzqEYcQ/xBhJEP
         ChW2tB1NS/RJdQL+nA3t7oXYxTR0ukB7FXRaO9c8=
Message-ID: <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Philippe Schenker <dev@pschenker.ch>
Reply-To: dev@pschenker.ch
To:     Deren Wu <deren.wu@mediatek.com>, Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux@leemhuis.info, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Date:   Wed, 01 Jun 2022 10:28:27 +0200
In-Reply-To: <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
References: <20220412090415.17541-1-dev@pschenker.ch>
         <87y20aod5d.fsf@kernel.org>
         <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
> On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> > Philippe Schenker <dev@pschenker.ch> writes:
> >=20
> > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > >=20
> > > This commit introduces a regression on some systems where the
> > > kernel is
> > > crashing in different locations after a reboot was issued.
> > >=20
> > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest
> > > firmware.
> > >=20
> > > Link:=20
> > > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/50=
77a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0A=
Rbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
> > > =C2=A0
> > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> >=20
> > Can I take this to wireless tree? Felix, ack?
> >=20
> > I'll also add:
> >=20
> > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> >=20
>=20
> Hi Kalle,
>=20
> We have a patch for a similar problem. Can you wait for the
> verification by Philippe?
> Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
> after
> reboot")
> Link:=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/drivers/net/wireless/mediatek/mt76?id=3D602cc0c9618a819ab00ea3c9400742a0ca=
318380
>=20
> I can reproduce the problem in my v5.16-rc5 desktop. And the issue can
> be fixed when the patch applied.
>=20
>=20
> Hi Philippe,
>=20
> Can you please help to check the patch in your platform?

Hi Kalle and Deren,

I just noticed on my system and mainline v5.18 reboots do now work
however Bluetooth is no longer accessible after a reboot.

Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top of
v5.18 solves this problem for me.

@Deren are you aware of this bug?
@Kalle Is there a bugtracker somewhere I can submit this?

Thanks,
Philippe

>=20
>=20
> Regards,
> Deren
>=20

