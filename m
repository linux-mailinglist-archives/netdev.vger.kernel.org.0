Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB04B1568
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiBJSjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:39:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiBJSjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:39:31 -0500
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37407101E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:39:32 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id IELpnOosqeKJJIELqn3GA8; Thu, 10 Feb 2022 19:39:30 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 10 Feb 2022 19:39:30 +0100
X-ME-IP: 90.126.236.122
Message-ID: <80a6083b-97ac-e24d-7791-1b5bdb318da5@wanadoo.fr>
Date:   Thu, 10 Feb 2022 19:39:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] nfp: flower: Fix a potential theorical leak in
 nfp_tunnel_add_shared_mac()
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
References: <49e30a009f6fc56cfb76eb2c922740ac64c7767d.1644433109.git.christophe.jaillet@wanadoo.fr>
 <YgUNdJgC9dNJN82P@corigine.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YgUNdJgC9dNJN82P@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/02/2022 à 14:04, Simon Horman a écrit :
> Hi Christophe,
> 
> On Wed, Feb 09, 2022 at 07:58:47PM +0100, Christophe JAILLET wrote:
>> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
>> inclusive.
>> So NFP_MAX_MAC_INDEX (0xff) is a valid id
>>
>> In order for the error handling path to work correctly, the 'invalid'
>> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
>> inclusive.
>>
>> So set it to -1.
>>
>> While at it, use ida_alloc_xxx()/ida_free() instead to
>> ida_simple_get()/ida_simple_remove().
>> The latter is deprecated and more verbose.
>>
>> Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Thanks for your patch.
> 
> I agree that it is indeed a problem and your fix looks good.
> I would, however, prefer if the patch was split into two:
> 
> 1. Bug fix
> 2. ida_alloc_xxx()/ida_free() cleanup

I'll send a v2.

I added it because some other maintainers have asked for it in other 
similar patches. Everyone's taste is different :).

CJ



> 
> Thanks again,
> Simon
> 
> ...
> 

