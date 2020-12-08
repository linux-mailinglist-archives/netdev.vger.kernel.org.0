Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945082D3200
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgLHSUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbgLHSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 13:20:09 -0500
Date:   Tue, 8 Dec 2020 10:19:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607451568;
        bh=6Jp6oXBUUDlrEYX+S6xFA5brUPF0AmbTD8gjVZy/wXY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NwpAC8SVNyFKPaG+1UDfY1mLmIcZ2Jiwd7wP0IMYcee7vOqixFAHB2PWhQ9vPOT1Q
         Z0Ezv5uUEQQO9a9QnRONhjrRLSaRLtSJVF9O1kjN16Y2mTypZaDlLiFfguezcoUz/D
         ryUwEBelhTDYh0vJF1PTK7hlZAvXlZ0n6Hn8yTmDOCU8/l9Zzgvjx2mNgsG6r01bkH
         XIwrtO96g+h+aoHb01QsLHXk7dgiZIccX6HQ19ewpiXNQ1X7al7TdtPXtH/nGiW/GK
         WXeAo4erjzfNpEV5IfvsfRwKzY3bYLysM3IwP5n4WcDLuD6wHx5LoaHXMvDruVobmm
         LZ9JMoU3dDmWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net v2] net/tls: Fix kernel panic when socket is in tls
 toe mode
Message-ID: <20201208101927.39dddc85@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205113529.14574-1-vinay.yadav@chelsio.com>
References: <20201205113529.14574-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 17:05:30 +0530 Vinay Kumar Yadav wrote:
> When socket is in tls-toe (TLS_HW_RECORD) and connections
> are established in kernel stack, on every connection close
> it clears tls context which is created once on socket creation,
> causing kernel panic. fix it by not initializing listen in
> kernel stack incase of tls-toe, allow listen in only adapter.

IOW the socket will no longer be present in kernel's hash tables?
