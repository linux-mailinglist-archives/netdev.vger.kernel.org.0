Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2062C4D4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiKPQjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiKPQj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:39:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3665258BE1;
        Wed, 16 Nov 2022 08:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2B46B81DEC;
        Wed, 16 Nov 2022 16:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3042EC433C1;
        Wed, 16 Nov 2022 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668616483;
        bh=mb0N2PYWnG5pZzOXKSEaoIb46jvuhMqXT8TcX/a0cvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y0A/7jDGDRMCG4ixeDym+iOq73iCA0DjWAqcMr6zsdi1X6YDdeOPcj3q5zy+qoa6v
         tGteOJH2HgfF/U4GPFjWALYzZm56GF2Zqr+GNlnkkV2gRHU0lrOWBdFr+KtDc77JOF
         nAX0Q1PmiQyh7zQBW6UbdfjxkpyvPWyaXX2oeF/yYyGr525+Ckp2qf1bXfW1i+WVlr
         3KjfJBrRpl51E2XOwdtCJY3w/P9xOYV70EisgrGtfC9vhjYpvIi/EI1jXcTQOEFgNl
         UjFpJ4b2qXsZewsHBuXcGXjP+d6phZ9OUIXGdwooOLx8DtBvXQujwsDVc0iGtU4YJU
         jaAeb/il4DvBQ==
Date:   Wed, 16 Nov 2022 08:34:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Message-ID: <20221116083442.71d9b32b@kernel.org>
In-Reply-To: <d43ad04e-8c24-d17c-ef09-984924ad1c4c@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
        <20221108125028.35a765be@kernel.org>
        <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
        <20221109104050.49dc17c8@kernel.org>
        <d43ad04e-8c24-d17c-ef09-984924ad1c4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 02:13:49 +1100 Albert Zhou wrote:
> After a lot of testing, I have come to the conclusion that the reason
> for the speed difference between the v1 and v2 driver is actually the
> firmware.
> 
> The v2 driver doesn't even #include <linux/firmware.h>; so it doesn't
> load the standard firmware in /lib/firmware/rtl_nic. It seems the
> firmware is actually written in the source and loaded directly.
> 
> Since firmware is not even part of the kernel, it's probably
> inappropriate to submit a patch that modifies the firmware of a device,
> would that be correct?
> 
> If that's the case, it's probably best if Realtek can update the
> firmware on the linux firmware git.
> 
> Not sure otherwise how to proceed. Any suggestions?

Getting Realtek to update the FW would definitely be the best avenue.

If that fails you can try to update it yourself, but it's always a bit
tricky because of licensing. You may need to invent your own file
format :S
