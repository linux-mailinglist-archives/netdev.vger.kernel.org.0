Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB46D0496
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjC3MW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjC3MWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:22:49 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56429AF15
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0YYDqH0woYMkFKs80FN8nbJZVrZF8L2WGvk2YNmmjZc=; b=pNXzuZ8VL+siiEpVKyVawPGSFs
        3euU177OPVaPItoQuIjwCn6jnGasaFi7mP1UdTMx6Gzd8A/DfKnDuhH7ByyjBEhoFjsH0x2e09Pfc
        9JOV7Xtgm+AuNnnT3KUBFJwsgfYbhNDfY79guRqhsBra4P/RmkBbFGYI/nfExIkPNHyM=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phrIj-008WYp-Az; Thu, 30 Mar 2023 14:22:45 +0200
Message-ID: <f4fd578f-f9fb-6df7-2927-c652789ec236@nbd.name>
Date:   Thu, 30 Mar 2023 14:22:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20230330120840.52079-1-nbd@nbd.name>
 <20230330121349.GV831478@unreal>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230330121349.GV831478@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.23 14:13, Leon Romanovsky wrote:
> On Thu, Mar 30, 2023 at 02:08:38PM +0200, Felix Fietkau wrote:
>> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
>> call flow_block_cb_incref for a newly allocated cb.
>> Also fix the accidentally inverted refcount check on unbind.
>> 
>> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> So what was changed between version 1 and 2?
> It is expected to send cover letter too for series with more than 2 patches.
I had already sent v2 without the net prefix, this was just a resend 
without any further code changes.
Unfortunately I forgot to copy the changelog as well. Here it is:
   v2: fix description, simplify refcounting change

Sorry about that.

- Felix
