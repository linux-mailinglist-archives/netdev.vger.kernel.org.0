Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8D1D6CC0
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEQUKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:10:02 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59301 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQUKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 16:10:01 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49QCtG6FBdz1rsXp;
        Sun, 17 May 2020 22:09:58 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49QCtG5kvmz1qr4w;
        Sun, 17 May 2020 22:09:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id fLNZ_7V1w_hR; Sun, 17 May 2020 22:09:57 +0200 (CEST)
X-Auth-Info: NPZL7HQJCvfEj5zCuq8uudk0kgiEU71ulzxePicC8MU=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 22:09:57 +0200 (CEST)
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        lukas@wunner.de, ynezz@true.cz, yuehaibing@huawei.com
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
 <a68af5dd-d12c-f645-f89f-3967cc64e8df@denx.de>
 <20200517192628.GF606317@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <fb452fc7-b3df-f11a-0122-f9315bd38269@denx.de>
Date:   Sun, 17 May 2020 22:08:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200517192628.GF606317@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 9:26 PM, Andrew Lunn wrote:
>> So I was already led into reworking the entire series to do this
>> inlining once, after V1. It then turned out it's a horrible mess to get
>> everything to compile as modules and built-in and then also only the
>> parallel/SPI as a module and then the other way around.
> 
> Maybe consider some trade offs. Have both sets of accessors in the
> core, and then thin wrappers around it to probe on each bus type. You
> bloat the core, but avoid the indirection. You can also have the core
> as a standalone module, which exports symbols for the wrappers to
> use. It does take some Kconfig work to get built in vs modules
> correct, but there are people who can help. It is also not considered
> a regression if you reduce the options in terms of module vs built in.

I think this is what we attempted with V1/V2/V3 already, except back
then it was to improve performance, which turned out to be a no-issue,
as the performance is the same with or without the indirect accessors
(of course it is, the interface is so slow the indirect accessors make
no difference, plus add into it that it's communicating with the NIC
through SPI core and SPI drivers, which are full of this indirection
already).

Or do I misunderstand something?
