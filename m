Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01C53F105
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiFFUwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiFFUwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:52:24 -0400
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD79205E0
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:42:16 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id yJY7nohIwJXxRyJY8nmBKa; Mon, 06 Jun 2022 22:42:15 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 06 Jun 2022 22:42:15 +0200
X-ME-IP: 90.11.190.129
Message-ID: <75b293bd-ec8d-8c90-ffe5-afa49d6a218d@wanadoo.fr>
Date:   Mon, 6 Jun 2022 22:42:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] stmmac: intel: Fix an error handling path in
 intel_eth_pci_probe()
Content-Language: en-US
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
 <20220606062650.GA31937@linux.intel.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220606062650.GA31937@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/06/2022 à 08:26, Wong Vee Khee a écrit :
> On Sun, Jun 05, 2022 at 10:50:48PM +0200, Christophe JAILLET wrote:
>> When the managed API is used, there is no need to explicitly call
>> pci_free_irq_vectors().
>>
>> This looks to be a left-over from the commit in the Fixes tag. Only the
>> .remove() function had been updated.
>>
>> So remove this unused function call and update goto label accordingly.
>>
>> Fixes: 8accc467758e ("stmmac: intel: use managed PCI function on probe and resume")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
> 
> LGTM
> 
> Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> 

Hi,

I've looked at it again.

I still think that the patch is good, but pcim_release() has changed in 
5.18 since commit 3f35d2cf9fbc ("PCI/MSI: Decouple MSI[-X] disable from 
pcim_release()")

I guess that all the mechanic is in place so that everything is 
registered when needed, but I've not been able to figure it out in the 
case of dwmac-intel.c.

So, double check :).

CJ
