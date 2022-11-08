Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD8621E32
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 22:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKHVER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 16:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKHVEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 16:04:16 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52320BD8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 13:04:14 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2A8L3aB3680699;
        Tue, 8 Nov 2022 22:03:36 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2A8L3aB3680699
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1667941417;
        bh=UHITPECF7qMl8PYIdIJWCD7l8l/q2a5WJN+lwJTtqDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bXC7v8aa+T0zAVkVYSlU0z5Z8eWo8UFKlLm2k1DzoQHX6ZvJte/AXW5h0myU/VjAQ
         971UN1HSgCRad8hE5eMjqRP/jiaVgEKUzHQgbK3XZW7bfwfEkYKx7zBN4QCUIx6Djd
         2CmQgeX8svtFg6ku78vxs4BTP6mWjP8El51Y03Z4=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2A8L3apU680698;
        Tue, 8 Nov 2022 22:03:36 +0100
Date:   Tue, 8 Nov 2022 22:03:36 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Message-ID: <Y2rEKOXDqLvL++hR@electric-eye.fr.zoreil.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Albert Zhou <albert.zhou.50@gmail.com> :
> This patch integrates the version-two r8152 drivers from Realtek into
> the kernel. I am new to kernel development, so apologies if I make
> newbie mistakes.

While it makes sense to minimize differences betwenn Realtek's in-house
driver and kernel r8152 driver, it does not mean that the out-of-tree
driver is suitable for a straight kernel inclusion.

If you want things to move forward in a not too painful way, you should
split the more than 650 ko patch into smaller, more focused patches
(huge patches also makes bisection mildly effective btw).

In its current form, the submission is imho a bit abrasive to review.

[...]
> Albert Zhou (5):
>   net: move back netif_set_gso_max helpers
>   r8152: update to version two

This code misuses mutex in {read, write}_mii_word.

It includes code and data that should be moved to firmware files.

>   r8152: remove backwards compatibility

Backwards compatibility code should had been avoided in the first
place.

[...]
>   r8152: remove redundant code

Same thing.

-- 
Ueimor
