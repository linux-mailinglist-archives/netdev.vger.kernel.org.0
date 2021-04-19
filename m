Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D430364CEF
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhDSVQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhDSVQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60E2261003;
        Mon, 19 Apr 2021 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618866962;
        bh=gipsoq8wJorpv0DxjT0nd3/XxZuHkLBVg4vEzgXH9xI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBo3/wFjll1ggZ59fpw1fBR3ZuG+A4ZQJcGd6dTOPJpcBei7CyZUv+CWUIbnGDFYs
         p61MREoity08kdUvope9YU2vTRamSSiOI+ABnbyi16nqzOvHtxl0gsvRB3MOAgKOD/
         eSuhoTM8SBDTy+IpYyx1CbpnP28h9zAopKA6OZ4ShyvX3IZTdklvrA9UpSfGt3kom3
         LCR1NZQ+XN1kIFrpx9tp6Z1dpKDswWOCTY8ke64OZtebd7vxM/n4PWTFvP/am4j470
         9/DTtDmwq4nXQLrH7Nq8ULuuHNbicVKhBtkyyF7iS+k1oAXLQFFRI1igfouf4h+ZXM
         jBXFOZLD6FXww==
Date:   Mon, 19 Apr 2021 14:16:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Message-ID: <20210419141601.531b2efd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210418211145.21914-3-pablo@netfilter.org>
References: <20210418211145.21914-1-pablo@netfilter.org>
        <20210418211145.21914-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Apr 2021 23:11:44 +0200 Pablo Neira Ayuso wrote:
> Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy and
> stats to different workqueues") splits the workqueue per event type. Add
> a mutex to serialize updates.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This driver doesn't set unlocked_driver_cb, why is it expected to take
any locks? I thought the contract is that caller should hold rtnl.

