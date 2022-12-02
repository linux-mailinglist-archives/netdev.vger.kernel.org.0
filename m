Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8E06406E9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiLBMgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiLBMgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:36:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E44A519C;
        Fri,  2 Dec 2022 04:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFE8D622A8;
        Fri,  2 Dec 2022 12:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A557C433C1;
        Fri,  2 Dec 2022 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669984610;
        bh=JrVlUhmbfEf3yx1LFj69LbM293k8DEwjw6TruUjw5Dc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Npr23a1vBexZkiiLKy3Pnz3Iv7m20sJySy1/QsAPyn4jy1rtCIBih+QtA4/i/Siqi
         EsmR4Q5KzFygb4fiirPAavuVoN/7n9P2jJucnF4TQeJae8V9diRcZEdGelA8LV+n40
         jWoXOF15N3xo3S3zSiA8m4aldXk6wcbJQZyisL3JAGqDTD/2RgYfOCaoOxLJ6HfSS3
         4f2aWS7tp4sK+Tp+MSO3GJys4fHRh/DAnb7w1xPfjbNSTGqVh6E+3zeueJpTreyetK
         pNkwvLJyYM9vB3bmWfrLmICwMVuuDx3H07qZpaBbQPvypokaJyfSyzuZ3/W8eDNoEZ
         DymCxv0z3rMbA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
        <20221129100754.2753237-9-s.hauer@pengutronix.de>
        <20221129081753.087b7a35@kernel.org>
        <20221202080952.GG9130@pengutronix.de>
Date:   Fri, 02 Dec 2022 14:36:41 +0200
In-Reply-To: <20221202080952.GG9130@pengutronix.de> (Sascha Hauer's message of
        "Fri, 2 Dec 2022 09:09:52 +0100")
Message-ID: <87359y3rty.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

> On Tue, Nov 29, 2022 at 08:17:53AM -0800, Jakub Kicinski wrote:
>> On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
>> > +config RTW88_8821CU
>> > +	tristate "Realtek 8821CU USB wireless network adapter"
>> > +	depends on USB
>> > +	select RTW88_CORE
>> > +	select RTW88_USB
>> > +	select RTW88_8821C
>> > +	help
>> > +	  Select this option will enable support for 8821CU chipset
>> > +
>> > +	  802.11ac USB wireless network adapter
>> 
>> Those kconfig knobs add so little code, why not combine them all into
>> one? No point bothering the user with 4 different questions with amount
>> to almost nothing.
>
> I tend to agree here. I followed the pattern used with PCI support here,
> but I also think that we don't need to be able to select all chips
> individually. The following should be enough:
>
> config RTW88_PCI
> 	tristate
> 	depends on PCI
> 	default y
>
> config RTW88_USB
> 	tristate
> 	depends on USB
> 	default y
>
> Still I'd like to continue with the current pattern to not block merging
> of the USB support with this topic.
>
> I could create a follow up patch though if that's desired.

Yeah, a follow up patch is a good idea. Best to get USB support commited
first, after that we can discuss improvements.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
