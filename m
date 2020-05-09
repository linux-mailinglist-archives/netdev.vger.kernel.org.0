Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229E01CC2DB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEIQrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:47:18 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:43590 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgEIQrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 12:47:17 -0400
Received: from [192.168.42.210] ([93.22.151.218])
        by mwinf5d41 with ME
        id cgn9220054iyQ5p03gn9Tp; Sat, 09 May 2020 18:47:16 +0200
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 09 May 2020 18:47:16 +0200
X-ME-IP: 93.22.151.218
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, fthain@telegraphics.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
 <20200508185402.41d9d068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <50ef36cd-d095-9abe-26ea-d363d11ce521@wanadoo.fr>
Date:   Sat, 9 May 2020 18:47:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508185402.41d9d068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/05/2020 à 03:54, Jakub Kicinski a écrit :
> On Fri,  8 May 2020 19:25:57 +0200 Christophe JAILLET wrote:
>> @@ -527,8 +531,9 @@ static int mac_sonic_platform_remove(struct platform_device *pdev)
>>   	struct sonic_local* lp = netdev_priv(dev);
>>   
>>   	unregister_netdev(dev);
>> -	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
>> -	                  lp->descriptors, lp->descriptors_laddr);
>> +	dma_free_coherent(lp->device,
>> +			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
>> +			  lp->descriptors, lp->descriptors_laddr);
>>   	free_netdev(dev);
>>   
>>   	return 0;
> This is a white-space only change, right? Since this is a fix we should
> avoid making cleanups which are not strictly necessary.
>
Right.

The reason of this clean-up is that I wanted to avoid a checkpatch 
warning with the proposed patch and I felt that having the same layout 
in the error handling path of the probe function and in the remove 
function was clearer.
So I updated also the remove function.

Fell free to ignore this hunk if not desired. I will not sent a V2 only 
for that.

CJ

