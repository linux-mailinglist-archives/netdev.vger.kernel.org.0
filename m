Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C504DB6B3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbiCPQvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240548AbiCPQvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:51:00 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517613EF0F;
        Wed, 16 Mar 2022 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647449382;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tlwYVjAu/+eh4O7kgvKdEyQUk3/1e0fO6eNpwNQ2H+8=;
    b=n7oKwq+X668Gn4Cgy6+WzsdZD7z9bj2ATRoll40S0EpuN3Q5WqWbQOEiA9Q/icLuu0
    yp1z/NuvHBIUVAezJ6ypL9TzMwpDJosSAMx/na4XVC01CHJEa0EtGtAJwLGBwU+4Sv4R
    ihThzsSb5nfvBSoaoJiG2/sY8U4WkWxV/KXAiJ7ClBynVgG2cfrVS6NpRfaX488MN5aK
    mGCpYg3jp0yMcnvtxXz4Ois09rDRQhRZqTR+86vjpsSTnzVWogrvBRktKtusNQvJTz8Z
    y7xuCysqn0DUNNaL+vlg3izYOvUHArb4itYLMBbjTFLUT22CxWYVvhD1+wwlZpEt02Rl
    dZdg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXTKq7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::bd7]
    by smtp.strato.de (RZmta 47.41.0 AUTH)
    with ESMTPSA id a046a1y2GGng4DH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Mar 2022 17:49:42 +0100 (CET)
Message-ID: <3892b065-59e0-3490-50ba-baa56f118859@hartkopp.net>
Date:   Wed, 16 Mar 2022 17:49:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        linux-can <linux-can@vger.kernel.org>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
 <20220316074802.b3xazftb7axziue3@pengutronix.de>
 <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
 <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
 <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
In-Reply-To: <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

I sent a patch set with three patches on the CAN ML.

Maybe it is just better when you pick them up for a regular process and 
send a pull request to Jakub and Dave.

I still suggest to get these changes in via net-next and send the 
"sanitize CAN ID" backport for the 'older' kernels, when net-next hits 
Linus' tree.

Best regards,
Oliver

On 16.03.22 09:42, Oliver Hartkopp wrote:
> 
> 
> On 16.03.22 09:01, Marc Kleine-Budde wrote:
>> On 16.03.2022 08:53:54, Oliver Hartkopp wrote:
>>>> Should this go into net/master with stable on Cc or to net-next?
>>>
>>> This patch is for net-next as it won't apply to net/master nor the
>>> stable trees due to the recent changes in net-next.
>>>
>>> As it contains a Fixes: tag I would send the patch for the stable
>>> trees when the patch hits Linus' tree and likely Greg would show up
>>> asking for it.
>>>
>>> I hope that's the most elegant process here?!?
>>
>> Another option is to port the patch to net/master with the hope that
>> back porting is easier.
> 
> I have a patch here for net/master that also properly applies down to 
> linux-5.10.y
> If requested I could post it instantly.
> 
>> Then talk to Jakub and David about the merge
>> conflict when net/master is merged to net-next/master.
> 
> Yes. There will be a merge conflict. Therefore I thought bringing that 
> patch for the released 5.17 and the stable trees later would be less 
> effort for Jakub and David.
> 
> Best regards.
> Oliver
