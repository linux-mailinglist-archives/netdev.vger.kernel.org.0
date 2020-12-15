Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0540E2DB398
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgLOSUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:20:54 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:54095 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgLOSUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 13:20:44 -0500
Received: from [192.168.42.210] ([93.22.37.143])
        by mwinf5d64 with ME
        id 4iJo2400435JPTR03iJo1g; Tue, 15 Dec 2020 19:18:56 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 15 Dec 2020 19:18:56 +0100
X-ME-IP: 93.22.37.143
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
To:     Maxime Ripard <maxime@cerno.tech>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour> <20201215091153.GH2809@kadam>
 <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
Date:   Tue, 15 Dec 2020 19:18:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/12/2020 à 12:37, Maxime Ripard a écrit :
> On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
>> On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
>>> Hi,
>>>
>>> On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
>>>> 'irq_of_parse_and_map()' should be balanced by a corresponding
>>>> 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.
>>>
>>> Do you have a source to back that? It's not clear at all from the
>>> documentation for those functions, and couldn't find any user calling it
>>> from the ten-or-so random picks I took.
>>
>> It looks like irq_create_of_mapping() needs to be freed with
>> irq_dispose_mapping() so this is correct.
> 
> The doc should be updated first to make that clear then, otherwise we're
> going to fix one user while multiples will have poped up
> 
> Maxime
> 

Hi,

as Dan explained, I think that 'irq_dispose_mapping()' is needed because 
of the 'irq_create_of_mapping()" within 'irq_of_parse_and_map()'.

As you suggest, I'll propose a doc update to make it clear and more 
future proof.

CJ
