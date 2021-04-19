Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6654D364D60
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhDSV5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhDSV51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9110660E0C;
        Mon, 19 Apr 2021 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618869416;
        bh=rj5Mtd1vnrSJBL9IS6i/OsOQUpG2569ZseMj1wzuvts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MiwM6vV+1Xp7ni9Azz7iaV5ZroBBYDpgHrtw+k/vTPxsHKfWVBQQJ3Z7KSt/MtPoa
         YpJWJBQ9c7RoLD9Fd+MvPAFfOzJu3zkSVUh5uzWtyF+9HnoGTrVwuGySyxr2oGyUZ6
         CkSvfpytTXTk9ZnLtpk4b/2kE+GPwRkZDM6Eb7+M8k/mkGaOgIbYlUlIInbNKV0HP+
         /PewbySG0h6GSTkhp0GZO/Wx/bJquZLPCRNqNQanQF9b8Gu4GNYXvy2vGDqld4E1/g
         MnHNjc8vAAYrLGOt7bQFYbcHC0CE9+luyOsRHfUOWp9pYzmrpF8n3qpkZk7XD14VJi
         FYdco2Q0OjzKg==
Date:   Mon, 19 Apr 2021 14:56:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Message-ID: <20210419145655.098899c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210419215432.GA8783@salvia>
References: <20210418211145.21914-1-pablo@netfilter.org>
        <20210418211145.21914-3-pablo@netfilter.org>
        <20210419141601.531b2efd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210419214019.GA8535@salvia>
        <20210419144341.159bde8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210419215432.GA8783@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Apr 2021 23:54:32 +0200 Pablo Neira Ayuso wrote:
> On Mon, Apr 19, 2021 at 02:43:41PM -0700, Jakub Kicinski wrote:
> > On Mon, 19 Apr 2021 23:40:19 +0200 Pablo Neira Ayuso wrote:  
> > > No rtnl lock is held from the netfilter side, see:
> > > 
> > > 42f1c2712090 ("netfilter: nftables: comment indirect serialization of
> > > commit_mutex with rtnl_mutex")  
> > 
> > All the tc-centric drivers but mlx5 depend on rtnl_lock, is there
> > something preventing them from binding to netfilter blocks?  
> 
> Only mlx5 and this driver support for TC_SETUP_FT.
> 
> This fix is targetting at the TC_SETUP_FT flow block type.

Ah, there is a separate block type. Thanks.
