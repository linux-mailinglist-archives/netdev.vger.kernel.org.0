Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93A84111B8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbhITJNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236795AbhITJLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53D31610A3;
        Mon, 20 Sep 2021 09:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632129007;
        bh=n3gK4PXJzv5qshjhhOwuA5JycgoExSXFHzw8XPtI/oM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mXCFbLD5ctS5ikXD8o4S4pt94qVql8pl9CMbYTEV8GC9zswy7y5CL+TEPNnKs1wqt
         pYl8AcI1h55EJOcJPH1SnaO9PSBGXFSyv/t/FVrzbJ9ht4u2rrY3A4pu3l0Mg3MzRq
         Z7ZysgLCNywjQAvJx92zxugKQdgjfABWJlbY63ZjJK9tjG54V3ZQAnJSSBmcK3D82p
         JNPa34iykayPiwfzP8Uju92K+HKZS0XU4uAnMTsTK2ToMRZVsmCUdInt/goLTq1Fix
         2TEAaqYI9FlxlwBgNVG8BJV3V/ievGLrYJJTjc8r1qbOvEP84c4B+dtv4yDBGTpPs5
         EV1axw2MH3hYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48F0D60A53;
        Mon, 20 Sep 2021 09:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Fix TX timeout when TX ring size is set to the
 smallest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163212900729.27858.970634646008254924.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 09:10:07 +0000
References: <1632120712-17410-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1632120712-17410-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 20 Sep 2021 02:51:52 -0400 you wrote:
> The smallest TX ring size we support must fit a TX SKB with MAX_SKB_FRAGS
> + 1.  Because the first TX BD for a packet is always a long TX BD, we
> need an extra TX BD to fit this packet.  Define BNXT_MIN_TX_DESC_CNT with
> this value to make this more clear.  The current code uses a minimum
> that is off by 1.  Fix it using this constant.
> 
> The tx_wake_thresh to determine when to wake up the TX queue is half the
> ring size but we must have at least BNXT_MIN_TX_DESC_CNT for the next
> packet which may have maximum fragments.  So the comparison of the
> available TX BDs with tx_wake_thresh should be >= instead of > in the
> current code.  Otherwise, at the smallest ring size, we will never wake
> up the TX queue and will cause TX timeout.
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Fix TX timeout when TX ring size is set to the smallest
    https://git.kernel.org/netdev/net/c/5bed8b0704c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


