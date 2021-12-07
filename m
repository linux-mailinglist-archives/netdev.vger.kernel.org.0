Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4313A46C266
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhLGSNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhLGSNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E184C061574;
        Tue,  7 Dec 2021 10:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0434DB81DEF;
        Tue,  7 Dec 2021 18:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F4DC341C7;
        Tue,  7 Dec 2021 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638900577;
        bh=FvI1SkWzzRNUldZETJA2GVPaosCZVieX9Ur7HudZtH4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qMtJMF2nB2ucgJnFXCOq6g32pHQWR3v2RIMTZg/bzFuw0FrFcArgX/c1GeGrIOmZA
         eMS/MgoYR5N7C+qAsViQRpAtu2AY9YgexyTIQBHxKJYVGCmNMTOvVDZvQGO50z3esy
         66NvCsrx3//z2U4BGGeuZvGRdfikk1AYqZN/gZGycYIgDhwxqf+Q78kYZPbsagxjzx
         gLuEfZOCKT1eRA9pDdJWu10avbjmqn47jHu1oKbkbdNGnpnm6CXh7F0R2IxpveLEW5
         Ck2RjENJRHViz+ygQNHfI6vwEgb5AI3TEFALUY+sDtZnmqILeLqqOlp52YVklRbJkX
         gh+GDZZu4P27A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
References: <20211009221711.2315352-1-robimarko@gmail.com>
        <163890036783.24891.8718291787865192280.kvalo@kernel.org>
Date:   Tue, 07 Dec 2021 20:09:32 +0200
In-Reply-To: <163890036783.24891.8718291787865192280.kvalo@kernel.org> (Kalle
        Valo's message of "Tue, 7 Dec 2021 18:06:09 +0000 (UTC)")
Message-ID: <87lf0wjnhf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Robert Marko <robimarko@gmail.com> wrote:
>
>> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
>> BDF-s to be extracted from the device storage instead of shipping packaged
>> API 2 BDF-s.
>> 
>> This is required as MikroTik has started shipping boards that require BDF-s
>> to be updated, as otherwise their WLAN performance really suffers.
>> This is however impossible as the devices that require this are release
>> under the same revision and its not possible to differentiate them from
>> devices using the older BDF-s.
>> 
>> In OpenWrt we are extracting the calibration data during runtime and we are
>> able to extract the BDF-s in the same manner, however we cannot package the
>> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
>> the fly.
>> This is an issue as the ath10k driver explicitly looks only for the
>> board.bin file and not for something like board-bus-device.bin like it does
>> for pre-cal data.
>> Due to this we have no way of providing correct BDF-s on the fly, so lets
>> extend the ath10k driver to first look for BDF-s in the
>> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
>> If that fails, look for the default board file name as defined previously.
>> 
>> Signed-off-by: Robert Marko <robimarko@gmail.com>
>
> Can someone review this, please? I understand the need for this, but the board
> handling is getting quite complex in ath10k so I'm hesitant.
>
> What about QCA6390 and other devices. Will they still work?

I meant QCA6174, of course. I have been working too much on ath11k.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
