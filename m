Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C50365E59F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 07:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjAEG1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 01:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjAEG1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 01:27:05 -0500
Received: from smtp.smtpout.orange.fr (smtp-12.smtpout.orange.fr [80.12.242.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3650F5B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 22:27:03 -0800 (PST)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id DJiOpLFMWoBUEDJiOpC7y5; Thu, 05 Jan 2023 07:27:02 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 05 Jan 2023 07:27:02 +0100
X-ME-IP: 86.243.100.34
Message-ID: <94876618-bc7c-dd42-6d41-eda80deb6f1d@wanadoo.fr>
Date:   Thu, 5 Jan 2023 07:27:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 2/3] ezchip: Switch to some devm_ function to
 simplify code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
 <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
 <20230104205438.61a7dc20@kernel.org>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230104205438.61a7dc20@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/01/2023 à 05:54, Jakub Kicinski a écrit :
> On Wed,  4 Jan 2023 22:05:33 +0100 Christophe JAILLET wrote:
>> devm_alloc_etherdev() and devm_register_netdev() can be used to simplify
>> code.
>>
>> Now the error handling path of the probe and the remove function are
>> useless and can be removed completely.
> 
> Right, but this is very likely a dead driver. Why invest in refactoring?
> 

Hi Jakub,

this driver was just randomly picked as an example.

My main point is in the cover letter. I look for feed-back to know if 
patches like that are welcomed. Only the first, Only the second, Both or 
None.


I put it here, slightly rephrased:


These patches (at least 1 and 2) can be seen as an RFC for net 
MAINTAINERS, to see if there is any interest in:
   - axing useless netif_napi_del() calls, when free_netdev() is called 
just after. (patch 1)
   - simplifying code with axing the error handling path of the probe 
and the remove function in favor of using devm_ functions (patch 2)

   or

if it doesn't worth it and would only waste MAINTAINERS' time to review 
what is in fact only code clean-ups.


The rational for patch 1 is based on Jakub's comment [1].
free_netdev() already cleans up NAPIs (see [2]).

CJ

[1]: https://lore.kernel.org/all/20221221174043.1191996a@kernel.org/
[2]: https://elixir.bootlin.com/linux/v6.2-rc1/source/net/core/dev.c#L10710
