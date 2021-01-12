Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A022F3FF1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437778AbhALXGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbhALXGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625E123123;
        Tue, 12 Jan 2021 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610492731;
        bh=wdx4ZAeAUfZ7dxLkRbVJc8qEvwFdJs9X9noG0UXtTgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LgUVgbi4ZJyPk/xbvcmDfrIGbP332TNz/FEt+ntZDLF2+DJBRHvuVpm2nO4/yxyWO
         tFjPnS+u+VD7mYMBC6uKtUcsLxvmbnQJa+dY3CWQ1a9Sdx5ixu3HVG4Iw0nOdD+Hza
         Pcvm55Ne166QF4TO1zSs2j87GBxstN03FXyArjPgLadTyPDKU4laTv4AkiKZz9Um2y
         skA8dTmot3+ty8rD4GfSU2h/5QfuQb2q96507ZY6SejpMhK1A5n2CTwcRhLTZ/HAuQ
         a6NPYHFs42s8JhUbmE3bVafbzPGvnD8Tn7ANZ3RuClAuMHEw4vVem3Eof1bnynMeTw
         OJdpWhkBhYnUA==
Date:   Tue, 12 Jan 2021 15:05:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        ast@kernel.org, bjorn.topel@intel.com, daniel@iogearbox.net,
        andriin@fb.com, tariqt@nvidia.com, edumazet@google.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, jiri@mellanox.com,
        borisp@nvidia.com
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
Message-ID: <20210112150530.0598a518@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
References: <20210106175327.5606-1-rohitm@chelsio.com>
        <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 02:47:51 +0530 rohit maheshwari wrote:
> On 07/01/21 12:47 AM, Jakub Kicinski wrote:
> > On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:  
> >> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
> >> And it broke tls offload feature for the drivers, which are still
> >> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
> >> NETIF_F_CSUM_MASK instead.
> >>
> >> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
> >> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>  
> > Please use Tariq's suggestion.  
> HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
> support only IPv4 checksum offload, TLS offload should be allowed for
> that too. So I think putting a check of CSUM_MASK is enough.

If Tariq does not disagree please repost.
