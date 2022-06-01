Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67830539FF2
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350986AbiFAI6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345836AbiFAI6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:58:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE18350044;
        Wed,  1 Jun 2022 01:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40A07CE19D9;
        Wed,  1 Jun 2022 08:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A34C385B8;
        Wed,  1 Jun 2022 08:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654073912;
        bh=fycRZup+rRlDibIJXv+b3HmaX/NftZkSg+gXy5Njcqo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=laVepRzYyH9QSsliuI01fpIxdBnoq4GRTpBkDWb+GHnPG0tBOjLV9AyqB9D+h4yV4
         TPIkLvVZe4EBIdgshCqz0iqc/jH4PNKYahyQeUX5d+qxiRx0+CI25HWutXwoNNE8c3
         NjEGpTyEuMRAFGNQ2O/YkVc1LSOlqeqNb2ZKnOAduLGWHMk4y8pLRefiCwj6K2i+NW
         4Rnq6FdMXVyFiu0o3fN+a8kD6QBxODs4ggsFv6qyyr5LJhSzbKFP0aXJQwRc04HYHJ
         SYdBYRQVehNUABAvGHAEjwPlogc7hDLkElYPaKRBTeHVzOZicj61LT1hyAS2B3sgBE
         2PgUzp8xU9JAQ==
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
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
References: <20220412090415.17541-1-dev@pschenker.ch>
        <87y20aod5d.fsf@kernel.org>
        <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
        <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch>
Date:   Wed, 01 Jun 2022 11:58:25 +0300
In-Reply-To: <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch>
        (Philippe Schenker's message of "Wed, 01 Jun 2022 10:28:27 +0200")
Message-ID: <87mtewoj4e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Hi Kalle and Deren,
>
> I just noticed on my system and mainline v5.18 reboots do now work
> however Bluetooth is no longer accessible after a reboot.
>
> Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top of
> v5.18 solves this problem for me.
>
> @Deren are you aware of this bug?
> @Kalle Is there a bugtracker somewhere I can submit this?

For regressions the best is to submit it to the regressions list, CCed
it now.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
