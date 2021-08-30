Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206E03FB2B1
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhH3IvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234695AbhH3IvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 04:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D3BC16101C;
        Mon, 30 Aug 2021 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630313408;
        bh=Dj8fzU9bUJILQeHbNP9RnqhG/dHyDaJ7x6g0YHrOORQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AJeFI4JCvf2Ilh/McLlRM2a9zM78aY/XDvlElLh5C3JJgrmT6WXsLTBcb7O80GqX5
         26azkWWX2lrAsoDrbRRnh/6uCGNCkXTA/4pWJjnpksYBbRInvrebDjfz9ozkztxPAR
         Ncb+R/PAOP0EItmeqvJAG0Snvv9ESuk1ySl23ALQJON+hhEiUOaI6RS7m1aXzDVv6S
         RaBsAAm6OWj1Ll4ZDaO4eeeacIvA0XYfmqIbeW7x4mOFps0WMPFT4B8UKklR/39tq9
         qxeGiNKSrc6lXJfHXGiQoTKkFLmrMWd/q3JX1gxba8v3cJehQ2Qu2bLb4f/4nABdn8
         kl9KqLB+C7PNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C77BE60A3C;
        Mon, 30 Aug 2021 08:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11] bnxt_en: Implement new driver APIs to send
 FW messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163031340881.11172.13384242552118412129.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 08:50:08 +0000
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 29 Aug 2021 03:34:55 -0400 you wrote:
> The current driver APIs to send messages to the firmware allow only one
> outstanding message in flight.  There is only one buffer for the firmware
> response for each firmware channel.  To send a firmware message, all
> callers must take a mutex and it is released after the firmware response
> has been read.  This scheme does not allow multiple firmware messages
> in flight.  Firmware may take a long time to respond to some messages
> (e.g. NVRAM related ones) and this causes the mutex to be held for
> a long time, blocking other callers.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] bnxt_en: remove DMA mapping for KONG response
    https://git.kernel.org/netdev/net-next/c/6c172d59ad79
  - [net-next,v2,02/11] bnxt_en: Refactor the HWRM_VER_GET firmware calls
    https://git.kernel.org/netdev/net-next/c/7b370ad77392
  - [net-next,v2,03/11] bnxt_en: move HWRM API implementation into separate file
    https://git.kernel.org/netdev/net-next/c/3c8c20db769c
  - [net-next,v2,04/11] bnxt_en: introduce new firmware message API based on DMA pools
    https://git.kernel.org/netdev/net-next/c/f9ff578251dc
  - [net-next,v2,05/11] bnxt_en: discard out of sequence HWRM responses
    https://git.kernel.org/netdev/net-next/c/02b9aa106868
  - [net-next,v2,06/11] bnxt_en: add HWRM request assignment API
    https://git.kernel.org/netdev/net-next/c/ecddc29d928d
  - [net-next,v2,07/11] bnxt_en: add support for HWRM request slices
    https://git.kernel.org/netdev/net-next/c/213808170840
  - [net-next,v2,08/11] bnxt_en: use link_lock instead of hwrm_cmd_lock to protect link_info
    https://git.kernel.org/netdev/net-next/c/3c10ed497fa8
  - [net-next,v2,09/11] bnxt_en: update all firmware calls to use the new APIs
    https://git.kernel.org/netdev/net-next/c/bbf33d1d9805
  - [net-next,v2,10/11] bnxt_en: remove legacy HWRM interface
    https://git.kernel.org/netdev/net-next/c/b34695a894b8
  - [net-next,v2,11/11] bnxt_en: support multiple HWRM commands in flight
    https://git.kernel.org/netdev/net-next/c/68f684e257d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


