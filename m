Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A563A3E544E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhHJHcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhHJHcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:32:47 -0400
X-Greylist: delayed 2079 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Aug 2021 00:32:25 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81285C0613D3;
        Tue, 10 Aug 2021 00:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bQDTGF3K6TXEhbkJJjazYgzwaqYxaaB91UFy2IRZsr4=; b=i9896ows6SedjR7ZHZkEMrgC8i
        FzqPZ+gVZekBw6qB4aLCJRWzD0vjGoyILemjPHkcoDOhVG36u4rxfr/SzEAwq78AeJQ7MYfQ4qi9D
        lH3yC3FU0xPfnZycXTkWN/KGPa8QSlR55p3ptvFxgmGHy0d0+jtuIbeDSAibs12IAz/AjsTCOLm2L
        8XQHn4XzkaykoSdcIDV409234VaL8NaryIFeTKxMBkNxyCwV0qs66AElL+037WZU+8pEYo/79sCTG
        /hJ4CHyIb29+JDg60qlMsmZRS+ostGF2kVcp/7DLPhxJaK2By3px0eck55/yw9asvChZf9s2jux+v
        9pfRlnaA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1mDLhT-0007eg-A2; Tue, 10 Aug 2021 07:57:23 +0100
Date:   Tue, 10 Aug 2021 07:57:23 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?iso-8859-1?Q?Andr=E9?= Valentin <avalentin@vmh.kalnet.hooya.de>
Subject: Re: [RFC net-next 0/3] qca8k bridge flags offload
Message-ID: <20210810065723.GI2705@earth.li>
References: <20210807120726.1063225-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807120726.1063225-1-dqfext@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 08:07:23PM +0800, DENG Qingfang wrote:
> Add bridge flags support for qca8k.
> 
> RFC: This is only compile-tested. Anyone who has the hardware, please
> test this and provide Tested-by tags. Thanks.

I will try to find time to build + test these on my RB3011 this weekend.
Anything in particular I should look out for, or just that normal
operation is unaffected?

> DENG Qingfang (3):
>   net: dsa: qca8k: offload bridge flags
>   net: dsa: qca8k: enable assisted learning on CPU port
>   net: dsa: tag_qca: set offload_fwd_mark
> 
>  drivers/net/dsa/qca8k.c | 62 +++++++++++++++++++++++++++++++++++------
>  net/dsa/tag_qca.c       | 11 +++++++-
>  2 files changed, 64 insertions(+), 9 deletions(-)

J.

-- 
Are you happy with your wash?
