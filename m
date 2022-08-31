Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFD5A87F2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiHaVNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiHaVNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:13:41 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EABDEA44;
        Wed, 31 Aug 2022 14:13:38 -0700 (PDT)
Received: from [IPV6:2003:e9:d720:85aa:808b:c60d:ed1c:7084] (p200300e9d72085aa808bc60ded1c7084.dip0.t-ipconnect.de [IPv6:2003:e9:d720:85aa:808b:c60d:ed1c:7084])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9B993C0253;
        Wed, 31 Aug 2022 23:13:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661980416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWMWIKD9VTkKr1KmGH2YBdLsA0ETWQ5s/8ePpQZheys=;
        b=g+4G3ht7oXITMo+acGAFsVMDt/H5RW3eriAbEFnCuSMQh2kK3kfM/QVZ2jK3cnkM8N6cQc
        O1l5mCPzlw7n1SYgYM2DuShTriapHtpbQzd1wSLRtLGwfttMa9wrL1e9mGc3+1XGnjrmiw
        UHAjugfnig1QFS5wzg6obBdPP5ZryFIUzOOM/KrdFZ50BIyrgKfhQIvf97VOOIAy2EPSOh
        CG/iGYA3G7PsRhRI2S7uqQ668uH0Y8QFesamkaFQxhQWCYOB8le6VkghEQ6H6pil0y//Ep
        Ajf90q740WllYYkKgkEoVLU7a7RdhsUEu/8sSswzMNaso4wePzKZnsPFOrHZhA==
Message-ID: <2b604558-ff97-78be-6534-09e20bebd0d1@datenfreihafen.org>
Date:   Wed, 31 Aug 2022 23:13:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, linux-wpan@vger.kernel.org
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
 <20220830233124.2770ffc2@kernel.org> <20220831112150.36e503bd@kernel.org>
 <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
 <20220831140947.7e8d06ee@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220831140947.7e8d06ee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Jakub.

On 31.08.22 23:09, Jakub Kicinski wrote:
> On Wed, 31 Aug 2022 22:59:14 +0200 Stefan Schmidt wrote:
>> I was swamped today and I am only now finding time to go through mail.
>>
>> Given the problem these ifdef are raising I am ok with having these
>> commands exposed without them.
>>
>> Our main reason for having this feature marked as experimental is that
>> it does not have much exposure and we fear that some of it needs rewrites.
>>
>> If that really is going to happen we will simply treat the current
>> commands as reserved/burned and come up with other ones if needed. While
>> I hope this will not be needed it is a fair plan for mitigating this.
> 
> Thanks for the replies. I keep going back and forth in my head on
> what's better - un-hiding or just using NL802154_CMD_SET_WPAN_PHY_NETNS + 1
> as the start of validation, since it's okay to break experimental commands.
> 
> Any preference?

We saw other problems with these being behind ifdefs from build and 
fuzzing bots. I say its time we un-hide and deal with them being 
formerly deprecated and replaced by something else if it really comes to 
changes for them (which we are not sure of)

regards
Stefan Schmidt
