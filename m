Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C934FE1A4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355117AbiDLNFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356401AbiDLND2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:03:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A21DF42;
        Tue, 12 Apr 2022 05:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30C09B81CCD;
        Tue, 12 Apr 2022 12:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DDFC385A1;
        Tue, 12 Apr 2022 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649767530;
        bh=XYiwRfijmpElQc3kiUm2Ka2BQBWKE6kkKwKlog3l6Fw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ol2DO33P1N8tMqZh4X8Yj4ItBwtVOONDeChhJGN4LnJD4gIccJc4cv84waAZ2jGoM
         u6PVkiJfdOP8A29p1K4eO5dnEbiTo3ayyk7R8ZLGnd/AqtAIAF1Sbcq/6xSxvk5pAf
         kJB/cusL+nAw+O1lZlrgiLCGTv9McBJLaHRngWBLcxmmLHlkWrsrRk4MU6hNSP5mx6
         jSRGFxOOq7UyP6wOu5/ejhr9Wi3/eT7CQbXrW+WC0jLziii0gyvfK0Es9EzmILy668
         6Z2L9z55ae0y1Ehkud7V63F/q9HEylhRu9trydlYgCL1Lx1jPvghLiyk3pYojFAxm2
         Txq7fsNfrZrEQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Philippe Schenker <dev@pschenker.ch>
Cc:     Deren Wu <deren.wu@mediatek.com>, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, linux@leemhuis.info,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
References: <20220412090415.17541-1-dev@pschenker.ch>
        <87y20aod5d.fsf@kernel.org>
        <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
        <420241bdd4fdbd1379f59e38571ec04c580eba41.camel@pschenker.ch>
Date:   Tue, 12 Apr 2022 15:45:24 +0300
In-Reply-To: <420241bdd4fdbd1379f59e38571ec04c580eba41.camel@pschenker.ch>
        (Philippe Schenker's message of "Tue, 12 Apr 2022 14:30:34 +0200")
Message-ID: <87bkx6o4gr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Philippe Schenker <dev@pschenker.ch> writes:

> On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
>> On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
>> > Philippe Schenker <dev@pschenker.ch> writes:
>> >=20
>> > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
>> > >=20
>> > > This commit introduces a regression on some systems where the
>> > > kernel is
>> > > crashing in different locations after a reboot was issued.
>> > >=20
>> > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest
>> > > firmware.
>> > >=20
>> > > Link:=20
>> > > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/5=
077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0=
ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
>> > > =C2=A0
>> > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
>> >=20
>> > Can I take this to wireless tree? Felix, ack?
>> >=20
>> > I'll also add:
>> >=20
>> > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
>> >=20
>>=20
>> Hi Kalle,
>>=20
>> We have a patch for a similar problem. Can you wait for the
>> verification by Philippe?
>> Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
>> after
>> reboot")
>> Link:=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/drivers/net/wireless/mediatek/mt76?id=3D602cc0c9618a819ab00ea3c9400742a0c=
a318380
>>=20
>> I can reproduce the problem in my v5.16-rc5 desktop. And the issue can
>> be fixed when the patch applied.
>>=20
>>=20
>> Hi Philippe,
>>=20
>> Can you please help to check the patch in your platform?
>
> Aah, so I have been a bit late with my painful bisecting. Should have
> checked -next before...=20

Actually commit 602cc0c9618a is already in Linus' tree and it was
included in v5.18-rc1 release.

> Whatever, your patch works just fine. I cherry picked your patch on
> top mainline v5.17 and it works just fine with that one.
>
> Thank you very much Deren!

And thank you Philippe for quickly testing this!

> Sorry Kalle for the overlapping revert, please do not apply it.

Ok, I'll drop your revert.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
