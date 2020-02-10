Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8139D1583EC
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBJTtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:49:47 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:36830 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJTtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 14:49:47 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48Gc1j5MBDz1rbLw;
        Mon, 10 Feb 2020 20:49:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48Gc1j4mFdz1qxyv;
        Mon, 10 Feb 2020 20:49:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 39PmCrnwvYP2; Mon, 10 Feb 2020 20:49:44 +0100 (CET)
X-Auth-Info: 376gqZgdP6KQskjfy0HZH5257hYEAnypTReDDRCP38U=
Received: from [127.0.0.1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 10 Feb 2020 20:49:44 +0100 (CET)
Subject: Re: [PATCH 2/3] net: ks8851-ml: Fix 16-bit data access
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200210184139.342716-1-marex@denx.de>
 <20200210184139.342716-2-marex@denx.de>
 <20200210193540.2nfui5gbistqszcm@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <b107da56-27c9-f7b0-8458-4ca5cefbfe93@denx.de>
Date:   Mon, 10 Feb 2020 20:40:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200210193540.2nfui5gbistqszcm@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 8:35 PM, Lukas Wunner wrote:
> On Mon, Feb 10, 2020 at 07:41:38PM +0100, Marek Vasut wrote:
>> The packet data written to and read from Micrel KSZ8851-16MLLI must be
>> byte-swapped in 16-bit mode, add this byte-swapping.
> [...]
>> -		*wptr++ = (u16)ioread16(ks->hw_addr);
>> +		*wptr++ = swab16(ioread16(ks->hw_addr));
> 
> Um, doesn't this depend on the endianness of the CPU architecture?
> I'd expect be16_to_cpu() or le16_to_cpu() here instead of swab16().

I don't really know in this case, this is a bus IO accessor, so I would
expect the answer is no. But I can only test this on ARMv7a.
