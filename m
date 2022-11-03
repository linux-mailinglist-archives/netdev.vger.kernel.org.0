Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17BE6173BF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 02:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKCB2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 21:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKCB2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 21:28:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DD112D08;
        Wed,  2 Nov 2022 18:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E812161AA9;
        Thu,  3 Nov 2022 01:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B47C433D6;
        Thu,  3 Nov 2022 01:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667438925;
        bh=lX+ST3dTXyEaKiiwRst2GT7kC0z5eaEAXLnWNMvTMnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XQbE9zfOjEEB4WZYgh7PjxGs+7Y2tRdTwpjhUbQpzU3ARuGu4N8xZ/OWorrbABlOV
         6CZHfyUEwEPAufZg+kpNGDLCFxPF8+xzhPtn7DW6fxeaosNJl9NERVkcig7nRnxSii
         QnSEULhwrBjo8tQrrAI4FJfc2+Le4kc2Dd5Mi1lV5D5Byisi8qK+FByVRU3U99hdGf
         ZgbVLFZrR/48mGbFQmvIhvxO89081GAZNOE/bXoiLObNJ6Y+oatQKIFlS2U35560Io
         ZlRT1bBY0VpzDIGM1esPVjqEAMN7q6CD/eftxYzVohVXu5h1kWg92ljt1P1u2SHKMp
         Bu/bZOPLrAobA==
Date:   Wed, 2 Nov 2022 18:28:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
Message-ID: <20221102182843.6d14c7ed@kernel.org>
In-Reply-To: <e9d662682b00a976ad1dedf361a18b5f28aac8fb.camel@microchip.com>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
        <20221028144540.3344995-3-steen.hegelund@microchip.com>
        <20221031103747.uk76tudphqdo6uto@wse-c0155>
        <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
        <20221031184128.1143d51e@kernel.org>
        <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
        <20221101084925.7d8b7641@kernel.org>
        <e9d662682b00a976ad1dedf361a18b5f28aac8fb.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 14:11:37 +0100 Steen Hegelund wrote:
> I have sent a version 4 of the series, but I realized after sending it, that I
> was probably not understanding the implications of what you were saying
> entirely.
> 
> As far as I understand it now, I need to have a matchall rule that does a goto
> from chain 0 (as this is where all traffic processing starts) to my first IS2
> VCAP chain and this rule activates the IS2 VCAP lookup.
> 
> Each of the rules in this VCAP chain need to point to the next chain etc.
> 
> If the matchall rule is deleted the IS2 VCAP lookups should be disabled as there
> is no longer any way to reach the VCAP chains.
> 
> Does that sound OK?

It does as far as I understand.

I haven't grasped what the purpose of using multiple chains is in 
case of your design. IIRC correctly other drivers use it for instance
to partition TCAMs with each chain having a different set of fields it
can match on. But I don't see templates used in sparx5.

In general in TC offloads you can reject any configuration you can't
(or choose not to) support, and make up your own constraints (e.g. only
specific priority or chain values are supported).

But for a "target" ruleset, i.e. ruleset comprised fully of rules you
do offload - the behavior of executing that ruleset in software and in
the device must be the same.

Dunno if that helps :)
