Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E1937970C
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhEJScb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231538AbhEJSca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 14:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8C761483;
        Mon, 10 May 2021 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620671485;
        bh=WRBJKugEKWUFjf8QXVv5Zrcvh68D/uXiVWMZHgtTK+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sXRPaHBFGsd9eaakCymd2IiZEj5GwlcOPqFbdLD/7xIMBZIazAqBbd72MeZcoiNcO
         vfNTPF0CU9XLRG0uvTd0RFk3bMHap/23pLd+oqVKOcI1t5FTT37k99z+bEgkCj4eUS
         Pg57803QIKboZlQJsWaxG40UndC4+vZhsBqzhrkd5rS7sRf7jEF35OpWYFp1z7BfHV
         8ea7yZYd/Jb3HEwCN7zwEPgLow1bBmeYR0m8Be4m6WhmUwkdiuKtm9u5BtjYt1HVpD
         YwtIcCVx7/BVhysIkGRsx4fjJb19JPzgvVdWDQv81dZOX/AB9ItagC+IxaG8hkW4Ho
         K0C4v6uEfk4vw==
Date:   Mon, 10 May 2021 11:31:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <20210510113124.414f3924@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
        <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 22:19:34 +0800 Zhu Yanjun wrote:
> On Mon, May 10, 2021 at 9:57 PM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> >
> > The statement of the last "if (adv_lpa & LPA_10HALF)" branch is the same
> > as the "else" branch. Delete it to simplify code.
> >
> > No functional change.  
> 
> Thanks.
> Missing Fixes?

Fixes tag is supposed to be used for functional fixes.

This patch (and the stmmac one) removes a branch based on the fact that
it's the same as the default / catch all case. It's has a net negative
effect on the reability of the code since now not all cases are
explicitly enumerated. But it's at least the 3rd time we got that
stmmac patch so perhaps not worth fighting the bots...
