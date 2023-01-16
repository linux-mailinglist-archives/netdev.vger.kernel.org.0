Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071D766C516
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjAPQBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjAPQBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024241E2AF;
        Mon, 16 Jan 2023 08:01:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5458961044;
        Mon, 16 Jan 2023 16:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F5C433F0;
        Mon, 16 Jan 2023 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673884872;
        bh=lcl2R3pBBULheZnPnqkp9w7w3lh8SVthhQOMeD8+CMY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qnXAgwjBaQY/MqV5GwGJQGJOulcc60Mn5DuSzpZZ4/RHlB9wJf8CI8ZP6lkz5UVyj
         3NYPiG03hagIIOXfGwVBbS0lCt15SnEe2mJyxkV7JXEYjmwWfoYj9sCcym5UUF2AD0
         RxDHhrke2L3PCikrENmXTrhN6BDIJOnq43K+Bhu5bF0cEJvAGZz64rIIKdei5LZZH7
         A4/LPEDCk8HmwsWr1Uaz3i1LDjtOnYedeSaK9r1pKSaKV4TjuZx3DpnCCq5Lmbsfla
         T8SxT4BtPlSUTDTDh/N3Lua9Exa95zHJ0+YdY7p4pco5OCquRc7jr4Lf/MOXRaNVY8
         cxtdB3xiIuT2A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 00/19] rtw88: Add SDIO support
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
Date:   Mon, 16 Jan 2023 18:01:05 +0200
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
        (Martin Blumenstingl's message of "Wed, 28 Dec 2022 00:30:01 +0100")
Message-ID: <87y1q28o5a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Jakub, a question for you below)

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Recently the rtw88 driver has gained locking support for the "slow" bus
> types (USB, SDIO) as part of USB support. Thanks to everyone who helped
> make this happen!
>
> Based on the USB work (especially the locking part and various
> bugfixes) this series adds support for SDIO based cards. It's the
> result of a collaboration between Jernej and myself. Neither of us has
> access to the rtw88 datasheets. All of our work is based on studying
> the RTL8822BS and RTL8822CS vendor drivers and trial and error.
>
> Jernej and myself have tested this with RTL8822BS and RTL8822CS cards.
> Other users have confirmed that RTL8821CS support is working as well.
> RTL8723DS may also work (we tried our best to handle rtw_chip_wcpu_11n
> where needed) but has not been tested at this point.

Very nice, good work.

Our recommendation is to have maximum of 10-12 patches per patchset to
make it easier for us maintainers, any chance to split the patchset into
two? For example, get the easy preparation patches into wireless-next
first and later submit the actual SDIO support.

[...]

> Why is this an RFC?

[...]

> - My understanding is that there's a discussion about the rtw88 Kconfig
>   symbols. We're adding four new ones within this series. It's not
>   clear to me what the conclusion is on this topic though.

Yeah, there were no conclusions about that. Jakub, do you have any
opinions? For example, do we keep per device Kconfig options (eg.
CONFIG_RTW88_8822BS, RTW88_8822CS and so on) or should we have only one
more bus level option (eg. CONFIG_RTW88_SDIO)? rtw88 now uses the former
and IIRC so does mt76. ath10k/ath11k/ath12k again use the latter :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
