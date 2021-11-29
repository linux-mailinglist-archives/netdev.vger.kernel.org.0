Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66C4616C4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbhK2Nlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbhK2Njq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:39:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030DEC08EC6B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:20:13 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 579A6B8102B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:20:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 00F9D60E94;
        Mon, 29 Nov 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188411;
        bh=0RU2qjZ8uAhAB4Na03CqEwL7KMXkBg0kg3KL0QhU1eo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gOi1A48YqeIcpeHM24kLGrEH4Di2OH9xgTj1340GEu0FrdXZS6csQrYC/2FNB7A67
         +ddmt5DAQhB0kKQ7fRjRTZDlyHeCl0Bm2b1zCmcvk0pXUXPMP6HuAT3vodQEbzm9Vr
         hAP5N9Vl5tHTnePMT2zdTQah8T1xuO3ebHyyaIdByJbEfqNPQxwBXAmyrBOCUvTVmi
         4BTYlIC03ARcq/k8FDxEeCPfnKGg4RDXLIekpvFM5rUh4YIuR/ztifqSt5nQkL5G7y
         LDXUTY1fgbnZQqh2mDXLTZ2MuoEcx8H/MoiMIbKLxUBQNW9xieKilSFPAzv2l6zcZo
         8wm8/3s5AQI7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAD4460A5A;
        Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Write lock dev_base_lock without disabling
 bottom halves.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818841095.20614.3229662488535132477.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:10 +0000
References: <20211126161529.hwqbkv6z2svox3zs@linutronix.de>
In-Reply-To: <20211126161529.hwqbkv6z2svox3zs@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, lgoncalv@redhat.com, rostedt@goodmis.org,
        nilal@redhat.com, pezhang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 17:15:29 +0100 you wrote:
> The writer acquires dev_base_lock with disabled bottom halves.
> The reader can acquire dev_base_lock without disabling bottom halves
> because there is no writer in softirq context.
> 
> On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
> as a lock to ensure that resources, that are protected by disabling
> bottom halves, remain protected.
> This leads to a circular locking dependency if the lock acquired with
> disabled bottom halves (as in write_lock_bh()) and somewhere else with
> enabled bottom halves (as by read_lock() in netstat_show()) followed by
> disabling bottom halves (cxgb_get_stats() -> t4_wr_mbox_meat_timeout()
> -> spin_lock_bh()). This is the reverse locking order.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Write lock dev_base_lock without disabling bottom halves.
    https://git.kernel.org/netdev/net-next/c/fd888e85fe6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


