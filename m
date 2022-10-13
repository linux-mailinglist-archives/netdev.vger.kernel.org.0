Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6FE5FE0A2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJMSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiJMSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD1025CB;
        Thu, 13 Oct 2022 11:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA403B820BE;
        Thu, 13 Oct 2022 18:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63224C43146;
        Thu, 13 Oct 2022 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684107;
        bh=Ha2dHhEvUe6b//Bh1NvZ9uTu3Vp2Wt+ccJEaoiKWGbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRzAPRHWyDgUKJUgvoAkBalBvhwST1Jdm1sLxiGFPnIB3m9j8Jak+9sUWOcZIpxf7
         wHwvl469C5roDl9h14UjXL8IhKDQhzI414+eSfk3Mmof/s9WjbOLV6DYvkh2U8PVC3
         iQT5xdvodKwgCa6pmFNR0Il1TxjXMCcg9TdTsF19XweIzqI9iNmJMQqDParLq6bEdF
         5g8lIziOo6j8sntGkB4WaDcn8InnRLjKFyXvjJ8XGcKhlJM5cVDDQ7INN/AzZesQvG
         2e3lM1O+SSXXOC5Ld+fc8KCYWNtWWuEejST0Uyb1ABqSp6ocqTTMU1hMKHQf2m0dv+
         dfqDyDMf6qTVw==
Date:   Thu, 13 Oct 2022 14:01:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 52/77] net: sfp: re-implement soft state
 polling setup
Message-ID: <Y0hSivQqzGb3hAl3@sashalap>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-52-sashal@kernel.org>
 <Y0PH5fFyViE2qrrG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0PH5fFyViE2qrrG@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:21:09AM +0100, Russell King (Oracle) wrote:
>On Sun, Oct 09, 2022 at 06:07:29PM -0400, Sasha Levin wrote:
>> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
>>
>> [ Upstream commit 8475c4b70b040f9d8cbc308100f2c4d865f810b3 ]
>>
>> Re-implement the decision making for soft state polling. Instead of
>> generating the soft state mask in sfp_soft_start_poll() by looking at
>> which GPIOs are available, record their availability in
>> sfp_sm_mod_probe() in sfp->state_hw_mask.
>>
>> This will then allow us to clear bits in sfp->state_hw_mask in module
>> specific quirks when the hardware signals should not be used, thereby
>> allowing us to switch to using the software state polling.
>
>NAK.
>
>There is absolutely no point in stable picking up this commit. On its
>own, it doesn't do anything beneficial. It isn't a fix for anything.
>It isn't stable material.
>
>If you picked up the next two patches in the series, there would be a
>point to it - introducing support for the HALNy GPON SFP module, but
>as you didn't these three patches on their own are entirely pointless.

So why not tag those patches for stable to make it explicit?

-- 
Thanks,
Sasha
