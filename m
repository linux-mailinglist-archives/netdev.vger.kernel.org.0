Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9860D46C252
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbhLGSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:09:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42646 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhLGSJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:09:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F51B81DDD;
        Tue,  7 Dec 2021 18:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B6DC341C1;
        Tue,  7 Dec 2021 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638900371;
        bh=j9hWvmDnSHhLayK/S4LB2G5JlhTIiHuWMU7YUw+Jl4s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qvwmJpCYS2z63ywOJoiE/LKGUBCvwi1+d60H1ZyiJ/EX2TXn8fddEdk15mWGZ8IoL
         9s0i6h+vnFXZxaxuRfodg4OECnKP+YRjeT97gSLxlHWAMi03MCv9O6OWUAmmCMuSlk
         uWRITrqocUk6CnIsxkubxOnAh5c2rLkzaYwrxoIFMDDRb92B/rHNXtc21rH2qbkwQT
         swPXvzzvOQoqt+ze0guZZbqCWtzN3uxMkgL5ZwiyrC0DpHyWHpglb39WIevVu1ajx2
         WkpNHJoBFNIT5vHUeuOX1h8gxqlu8+c0lZ3jSrvpMWXETJtAsIXaljnqCbo9e4QgiJ
         deRLDJ72/DcHg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211009221711.2315352-1-robimarko@gmail.com>
References: <20211009221711.2315352-1-robimarko@gmail.com>
To:     Robert Marko <robimarko@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163890036783.24891.8718291787865192280.kvalo@kernel.org>
Date:   Tue,  7 Dec 2021 18:06:09 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> wrote:

> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
> BDF-s to be extracted from the device storage instead of shipping packaged
> API 2 BDF-s.
> 
> This is required as MikroTik has started shipping boards that require BDF-s
> to be updated, as otherwise their WLAN performance really suffers.
> This is however impossible as the devices that require this are release
> under the same revision and its not possible to differentiate them from
> devices using the older BDF-s.
> 
> In OpenWrt we are extracting the calibration data during runtime and we are
> able to extract the BDF-s in the same manner, however we cannot package the
> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
> the fly.
> This is an issue as the ath10k driver explicitly looks only for the
> board.bin file and not for something like board-bus-device.bin like it does
> for pre-cal data.
> Due to this we have no way of providing correct BDF-s on the fly, so lets
> extend the ath10k driver to first look for BDF-s in the
> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
> If that fails, look for the default board file name as defined previously.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>

Can someone review this, please? I understand the need for this, but the board
handling is getting quite complex in ath10k so I'm hesitant.

What about QCA6390 and other devices. Will they still work?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211009221711.2315352-1-robimarko@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

