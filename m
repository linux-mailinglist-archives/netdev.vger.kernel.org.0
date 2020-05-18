Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D13E1D7FAA
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgERRII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:08:08 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57561 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERRII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:08:08 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Qlnx6XQKz1qrfB;
        Mon, 18 May 2020 19:08:05 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Qlnx2wY5z1qrhn;
        Mon, 18 May 2020 19:08:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 9Wg0IeFNzQWH; Mon, 18 May 2020 19:08:03 +0200 (CEST)
X-Auth-Info: +3a5yuvL2n4rztMczhByMk4qn65lq98qURAuKrTqYKM=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 18 May 2020 19:08:03 +0200 (CEST)
Subject: Re: [PATCH V6 16/20] net: ks8851: Implement register, FIFO, lock
 accessor callbacks
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200517003354.233373-1-marex@denx.de>
 <20200517003354.233373-17-marex@denx.de>
 <20200518093422.38a52ca7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <ecd84056-ef96-423e-7f14-1dc89fa378a4@denx.de>
Date:   Mon, 18 May 2020 19:06:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200518093422.38a52ca7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 6:34 PM, Jakub Kicinski wrote:
> On Sun, 17 May 2020 02:33:50 +0200 Marek Vasut wrote:
>> The register and FIFO accessors are bus specific, so is locking.
>> Implement callbacks so that each variant of the KS8851 can implement
>> matching accessors and locking, and use the rest of the common code.
>>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Petr Stetiar <ynezz@true.cz>
>> Cc: YueHaibing <yuehaibing@huawei.com>
> 
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member '____cacheline_aligned' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'tx_space' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'lock' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'unlock' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdreg16' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrreg16' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdfifo' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrfifo' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'start_xmit' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rx_skb' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'flush_tx_work' not described in 'ks8851_net'
> drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer1' not described in 'ks8851_net_spi'
> drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer2' not described in 'ks8851_net_spi'
> drivers/net/ethernet/micrel/ks8851.c:561: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb_spi'
> drivers/net/ethernet/micrel/ks8851.c:570: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb'

A lot of those were there already before this series and they are in
fact fixed by this series. The result builds clean with W=1 .
