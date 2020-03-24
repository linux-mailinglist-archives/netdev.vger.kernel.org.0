Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7E2190E1B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCXMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:52:08 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59832 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgCXMwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:52:07 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mrjy3VN7z1rsXY;
        Tue, 24 Mar 2020 13:52:05 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mrjw6RnZz1r0bv;
        Tue, 24 Mar 2020 13:52:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id MaPhXCu5LVWg; Tue, 24 Mar 2020 13:52:02 +0100 (CET)
X-Auth-Info: 5OuzpDb+tIijIBuY3ZjdsVcw6kObknAnZQm3z2Q6OdE=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 13:52:02 +0100 (CET)
Subject: Re: [PATCH 08/14] net: ks8851: Use 16-bit read of RXFC register
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-9-marex@denx.de>
 <20200324104102.axlr6txhbgxhhw7k@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <199d9c7a-5a71-5c2d-267f-c0dfce317f79@denx.de>
Date:   Tue, 24 Mar 2020 13:42:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324104102.axlr6txhbgxhhw7k@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 11:41 AM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:42:57AM +0100, Marek Vasut wrote:
>> The RXFC register is the only one being read using 8-bit accessors.
>> To make it easier to support the 16-bit accesses used by the parallel
>> bus variant of KS8851, use 16-bit accessor to read RXFC register as
>> well as neighboring RXFCTR register.
> 
> This means that an additional 8 bits need to be transferred over the
> SPI bus whenever a set of packets is read from the RX queue.  This
> should be avoided.  I'd suggest adding a separate hook to read RXFC
> and thus keep the 8-bit read function for the SPI variant.

See my comment about the 32bit read and regmap. It is slightly less
efficient, but it also makes the conversion much easier. Can you check
on the real hardware whether the is measurable performance impact ?
