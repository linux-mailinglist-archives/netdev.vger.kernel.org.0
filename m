Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7BA2BBC4A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKUCkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgKUCkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 21:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605926405;
        bh=Ss4ZDZyCK+cFtb/BCNoiQdG30RSycV9WivXFwQcfOyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bjHp2DYWIf/vWXM10has2XA3cCRXd3dDz/iCxawznRkIenRRTKHXorYug/AV+x+9A
         mLf8afc/dfkao+VnEIyXxMZl780xwYpQXko8wfODWsq+rK053nvtSEOjaidNYTpYot
         M1pwr2gbIgiiql+uX7Z8bpnyH3bx4PCkxsPyER0w=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: reduce number of workaround doorbell rings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160592640524.13180.7708519953108227572.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Nov 2020 02:40:05 +0000
References: <0a15a83c-aecf-ab51-8071-b29d9dcd529a@gmail.com>
In-Reply-To: <0a15a83c-aecf-ab51-8071-b29d9dcd529a@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Nov 2020 21:57:27 +0100 you wrote:
> Some chip versions have a hw bug resulting in lost door bell rings.
> To work around this the doorbell is also rung whenever we still have
> tx descriptors in flight after having cleaned up tx descriptors.
> These PCI(e) writes come at a cost, therefore let's reduce the number
> of extra doorbell rings.
> If skb is NULL then this means:
> - last cleaned-up descriptor belongs to a skb with at least one fragment
>   and last fragment isn't marked as sent yet
> - hw is in progress sending the skb, therefore no extra doorbell ring
>   is needed for this skb
> - once last fragment is marked as transmitted hw will trigger
>   a tx done interrupt and we come here again (with skb != NULL)
>   and ring the doorbell if needed
> Therefore skip the workaround doorbell ring if skb is NULL.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: reduce number of workaround doorbell rings
    https://git.kernel.org/netdev/net-next/c/94d8a98e6235

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


