Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62830304A0A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbhAZFSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbhAYPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:36:07 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74D8C061786;
        Mon, 25 Jan 2021 07:04:03 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DPTlp38fgz1s8P3;
        Mon, 25 Jan 2021 13:32:38 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DPTlp29gnz1rfK8;
        Mon, 25 Jan 2021 13:32:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id SjUqCsmRVQvc; Mon, 25 Jan 2021 13:32:35 +0100 (CET)
X-Auth-Info: pQzdjtka2BKwz0OQu6FP+DYh5itMUuZK8lIFjS5qH9s=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 25 Jan 2021 13:32:35 +0100 (CET)
Subject: Re: [PATCH] [5.8 regression] net: ks8851: fix link error
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210125121937.3900988-1-arnd@kernel.org>
From:   Marek Vasut <marex@denx.de>
Message-ID: <d412433b-032a-9ed9-81aa-fe3f7c6d50d5@denx.de>
Date:   Mon, 25 Jan 2021 13:32:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125121937.3900988-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 1:19 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> An object file cannot be built for both loadable module and built-in
> use at the same time:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> ks8851_common.c:(.text+0xf80): undefined reference to `__this_module'
> 
> Change the ks8851_common code to be a standalone module instead,
> and use Makefile logic to ensure this is built-in if at least one
> of its two users is.
> 
> Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Marek sent two other patches to address the problem:
> https://lore.kernel.org/netdev/20210116164828.40545-1-marex@denx.de/
> https://lore.kernel.org/netdev/20210115134239.126152-1-marex@denx.de/
> 
> My version is what I applied locally to my randconfig tree, and
> I think this is the cleanest solution.

If this version works for all the configuration combinations, then 
that's perfect, thanks.
