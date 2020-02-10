Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E21583ED
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgBJTtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:49:50 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:33975 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJTtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 14:49:50 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48Gc1n0QH4z1rbLm;
        Mon, 10 Feb 2020 20:49:49 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48Gc1n0D31z1qxyv;
        Mon, 10 Feb 2020 20:49:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 9hn6alCWVSlq; Mon, 10 Feb 2020 20:49:46 +0100 (CET)
X-Auth-Info: AMpyj9Ch/f06jn/zBlOb59cqee/ujpurslXarhR1gvY=
Received: from [127.0.0.1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 10 Feb 2020 20:49:46 +0100 (CET)
Subject: Re: [PATCH 1/3] net: ks8851-ml: Remove 8-bit bus accessors
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200210184139.342716-1-marex@denx.de>
 <20200210193102.q7qikf4czfzuqlox@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <14404123-c05c-f29c-6b5c-6d6ef8ef2191@denx.de>
Date:   Mon, 10 Feb 2020 20:44:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200210193102.q7qikf4czfzuqlox@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 8:31 PM, Lukas Wunner wrote:
> On Mon, Feb 10, 2020 at 07:41:37PM +0100, Marek Vasut wrote:
>> This driver is mixing 8-bit and 16-bit bus accessors for reasons unknown,
>> however the speculation is that this was some sort of attempt to support
>> the 8-bit bus mode.
> 
> ks8851.c was introduced in July 2009 with commit 3ba81f3ece3c.
> ks8851_mll.c was introduced two months later with a55c0a0ed415.
> 
> Perhaps the 8-bit accesses are remnants of the SPI-version ks8851.c?
> 
> Both chips are very similar.  Unfortunately ks8851_mll.c duplicated
> much of ks8851.c, instead of separating it into a common portion and
> an SPI-specific portion.  I've deduplicated at least the register
> macros with commit aae079aa76d0.  It would be great if you could
> continue this effort and increase the amount of shared code between
> the two drivers.  Right now ks8851_mll.c supports features that
> ks8851.c does not, e.g. multicast filtering.  On the other hand
> I've fixed bugs in ks8851.c which I believe still exist in ks8851_mll.c,
> see 536d3680fd2d for an example.  I didn't apply the fixes to
> ks8851_mll.c simply because I don't have hardware with that chip.
> I do have access to hardware using ks8851.c.

Right now I cannot promise that I'll be able to work on this driver
beyond these basic fixes. I'll see what I can do.
