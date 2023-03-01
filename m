Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B05A6A6E11
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCAONh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjCAONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:13:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B592A154;
        Wed,  1 Mar 2023 06:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11EE1B8100C;
        Wed,  1 Mar 2023 14:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3473C433EF;
        Wed,  1 Mar 2023 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677680012;
        bh=r6P//BcxLFtvB3zZTtasuqN+SEnGaEL2E66kC99aEcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDTjoO6RDjH6SIccJ2DvwEeFNf8rq0KlYr+UuZVSaIrn59Bkv3+W8F5Gb+9Q5a/db
         HLG0PSlp+KSrIUvyev/WO5xw+i/+xdRpn8auCz+Hy44FR340SHUzNutTs30OWkaw7f
         wFAX7T0jtwSGbhmVS5zZBBQ/a8C62nwK/t/UCLsib1L2zgIELnbEv3oc+WaC6OLe7r
         v+l1k/lNUHqJjBq0hzfLK9Ruz/CHpdWe4kXpg7ALhdW6sHKN3etMVILFE86Gw0qLIu
         YRwc9jmGCpiOfekrQQmrG3EanjWy/HM0keKuJjK5jGNpxELl5RGVc22LT3Szo+aUvZ
         ONOvfyp9LUR4A==
Date:   Wed, 1 Mar 2023 09:13:31 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Haley <haleyb.dev@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, corbet@lwn.net,
        den@openvz.org, razor@blackwall.org, ulf.hansson@linaro.org,
        Jason@zx2c4.com, wangyuweihx@gmail.com, daniel@iogearbox.net,
        thomas.zeitlhofer+lkml@ze-it.at, alexander@mihalicyn.com,
        ja@ssi.bg, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 31/53] neighbor: fix proxy_delay usage when
 it is zero
Message-ID: <Y/9dizGq97wpbZpn@sashalap>
References: <20230226144446.824580-1-sashal@kernel.org>
 <20230226144446.824580-31-sashal@kernel.org>
 <20230227101504.45ef890c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227101504.45ef890c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:15:04AM -0800, Jakub Kicinski wrote:
>On Sun, 26 Feb 2023 09:44:23 -0500 Sasha Levin wrote:
>> From: Brian Haley <haleyb.dev@gmail.com>
>>
>> [ Upstream commit 62e395f82d04510b0f86e5e603e29412be88596f ]
>>
>> When set to zero, the neighbor sysctl proxy_delay value
>> does not cause an immediate reply for ARP/ND requests
>> as expected, it instead causes a random delay between
>> [0, U32_MAX). Looking at this comment from
>> __get_random_u32_below() explains the reason:
>
>Potential behavior change, can we wait 4 weeks, until it's been
>in a couple of -rcs?

Ack, will revisit this later. Thanks!

-- 
Thanks,
Sasha
