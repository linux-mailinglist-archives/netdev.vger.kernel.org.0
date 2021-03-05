Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C632F524
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCEVKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3313E650A5;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=/pJj/nB535Qu0F9dhwEEv/JkP20imH0yiCmcAAmvo6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eau6n5wEUdwCMIXk0EhStLu5mRpuvWpK/+v+u0MsnXxlQJLa7Vs72MgGSAeXQ8tKF
         u7Ztto4jyaVhAjip3mMdYAOX58snN1Qy57i5/wMA4frtMI7KmWdXv6poH+7M7EjK38
         vdBvcMkq0+rTkLTP7qnf+ir5e7VL0EqQbJ60BZVjD8tM4MYJQKG8JGWyNG3q/m5q7b
         gD89BYah1EQGyrGdax6MPZIGoODbEy7fIV3Aiagn/3hmO7OHoBMjQzva9TO1HgCATI
         bMSNqaADqjKpB9wafIaF0JTAqgjtDAMo8peSbrrJa/R3E3qnjafbKcONA3yRRu7lq5
         cw6S/xOHs8y0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25C3160A22;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] ibmvnic: remove excessive irqsave
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860915.24588.2102886207868627115.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305084839.2405-1-angkery@163.com>
In-Reply-To: <20210305084839.2405-1-angkery@163.com>
To:     angkery <angkery@163.com>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        drt@linux.ibm.com, ljp@linux.ibm.com, sukadev@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangjunlin@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 16:48:39 +0800 you wrote:
> From: Junlin Yang <yangjunlin@yulong.com>
> 
> ibmvnic_remove locks multiple spinlocks while disabling interrupts:
> spin_lock_irqsave(&adapter->state_lock, flags);
> spin_lock_irqsave(&adapter->rwi_lock, flags);
> 
> As reported by coccinelle, the second _irqsave() overwrites the value
> saved in 'flags' by the first _irqsave(),   therefore when the second
> _irqrestore() comes,the value in 'flags' is not valid,the value saved
> by the first _irqsave() has been lost.
> This likely leads to IRQs remaining disabled. So remove the second
> _irqsave():
> spin_lock_irqsave(&adapter->state_lock, flags);
> spin_lock(&adapter->rwi_lock);
> 
> [...]

Here is the summary with links:
  - [v1] ibmvnic: remove excessive irqsave
    https://git.kernel.org/netdev/net/c/69cdb7947adb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


