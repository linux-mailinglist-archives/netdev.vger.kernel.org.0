Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1742435B2
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHMIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 04:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHMIDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 04:03:31 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F04BC061757;
        Thu, 13 Aug 2020 01:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xOO6MeTEA8MRtWkU2Z+NzWhEwftxTFMRNfGpcioRO4U=; b=ir15jMqI2TJ0H4SsnZEaUzcoNK
        nNHh7eotC4pq6h36/qGt6qP7hzdsVSf7jTrvkN//0zSmxnZqzqbOw7mJvhcHWZXPzUXgpDXp3M0BL
        LZPBOLehRUzKThdYYz+/e3WUMdzKfhQSXuvjhBujhVXm8IloqgiNZWGMrVbQfcLr6D5DF4CH0dvIR
        LkpFjpxMxXXt1qcu46CJyKfvOiFWwMsU3cVC2GqEp4+I8nFUr8EKintbtMK6zPAmYzlwkL1RdQiQa
        nYaiJQGXWJ6NgGcEdgoNUTYLA9VesawXx+R/XHS7UrsqSskNyO37Kh9VqRlvBtGRNbOFLFylsFgwP
        zhjBEfBQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k68Co-0002GT-At; Thu, 13 Aug 2020 09:03:22 +0100
Date:   Thu, 13 Aug 2020 09:03:22 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200813080322.GH21409@earth.li>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727122242.32337-2-vadym.kochan@plvision.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:22:37PM +0300, Vadym Kochan wrote:
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
> 
> The current implementation supports only boards designed for the Marvell
> Switchdev solution and requires special firmware.
> 
> The core Prestera switching logic is implemented in prestera_main.c,
> there is an intermediate hw layer between core logic and firmware. It is
> implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> related logic, in future there is a plan to support more devices with
> different HW related configurations.

The Prestera range covers a lot of different silicon. 98DX326x appears
to be AlleyCat3; does this driver definitely support all previous
revisions too? I've started looking at some 98DX4122 (BobCat+) hardware
and while some of the register mappings seem to match up it looks like
the DSA tagging has some extra information at least.

Worth making it clear exactly what this driver is expected to support,
and possibly fix up the naming/device tree compatibles as a result.

J.

-- 
... Nice world. Let's make it weirder.
