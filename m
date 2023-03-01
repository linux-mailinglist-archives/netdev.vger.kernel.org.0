Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3F16A6F40
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCAPWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCAPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:22:24 -0500
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587163BD86;
        Wed,  1 Mar 2023 07:22:23 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 099472B066AA;
        Wed,  1 Mar 2023 10:22:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 01 Mar 2023 10:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1677684137; x=1677691337; bh=35LAosmMrb
        aNq+dBMEtgsW+bTUi65LRc+RMuP/OivHw=; b=v6r/OuO3xTuBebiQ3is1k1uNgb
        eM4IUhoL0733u7q8ZxOv+4pNODCjZNmgkW5FkSbf1dfx2ls1Grm82aBNmFR2gFrs
        dWX9+ARcHLoHxL+XxbneOWoAuBwBjlxAS/Q0hS79co2p2P9SFRngRFWGkCjxRwZ7
        Qnufn/9aymmKdtS/2wjJfZo2edzzXJs45FJ4QFgghjCmmxBTSGXd64W2hh1QXphn
        m+wr0iqJOzNUNi107dvmfiwTOBf1EDQc88lb+GScuQyOjSYrBsAPW3CdB3Jx6c0x
        YJlD8qnJQ9mrIpO+9NND2RnTYicZbugt/jOx3cQddzoXzMzNJ4ssioIf409Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677684137; x=1677691337; bh=35LAosmMrbaNq+dBMEtgsW+bTUi6
        5LRc+RMuP/OivHw=; b=YrVxsGT+aC71h7mj7ao4Py9kyXShoFsqsb1Jm7RP3Yvn
        nH396vS0z9pOdgqXIlrjeB5zMrADq/bz9OBNNCQodaKeoox6wJbBuD3fF2L6owc0
        Oys7MTC3BaainmlNiVRB2qFyl2NN72FnyYt1Snjl5crZu7cXm1ndKy1b/AQh6PU5
        c6EbQSgUrX3PvX7uxQTly6uYsmhoo6qznkYoigFUY5wpZN3mDmifm6cO6bkZnZ3j
        AIrC5geq/79NwjlPbn5tN54PGPWDGW0uv9td8JZc+dezONesHHOwBsWkBDbIOZeu
        yOq+cG0Be+WXYkxhDm2MINGW6BxUTDjs7ECghJ8oag==
X-ME-Sender: <xms:qG3_Y_Kilw9lw0q5o3bSwHvknKDCu4_e7WZcEZzDys9reEQKmI9lKg>
    <xme:qG3_YzLpAztfri--XN0PrwqaBwZ97beLj854f7wKxVez4mCJv8zyiPqecPFo1u1cT
    zEUqZxIzbpueA>
X-ME-Received: <xmr:qG3_Y3uOpfGZWp1umNrtSno_6JY3Age98d14zFunKDbNGsY2CdpzI1ADTZCu5QFCH0RWINqVKbXK-4sOW155FXf9d9AP5hczQyeT6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelhedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:qG3_Y4aYx-nGh-WQ5O-qp59RhWhZAArJsvnpvZ7035GsO-DQyNEOGQ>
    <xmx:qG3_Y2YZ0Oico0Uc56N52DZXE74FFpquCHM2bqfm8QCg6EkTjw8T1w>
    <xmx:qG3_Y8AQW3a0YXNVbUYj51d-M6NdZdl5gJVp9giFRW4VtatA6ygdqw>
    <xmx:qW3_Y5ntk_-AFmrGeaMNB4HBhvUULCS4CnWyZAb0V0HC0MfY7yTBSqYKyZE>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Mar 2023 10:22:15 -0500 (EST)
Date:   Wed, 1 Mar 2023 16:22:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     stable@vger.kernel.org,
        "linux-wireless@vger.kernel.org Neo Jou" <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v2 0/3] wifi: rtw88: USB fixes
Message-ID: <Y/9toUMQlZ4fLbe0@kroah.com>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
 <20230301071141.GN23347@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301071141.GN23347@pengutronix.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 08:11:41AM +0100, Sascha Hauer wrote:
> On Fri, Feb 10, 2023 at 12:16:29PM +0100, Sascha Hauer wrote:
> > This series addresses issues for the recently added RTW88 USB support
> > reported by Andreas Henriksson and also our customer.
> > 
> > The hardware can't handle urbs that have a size of multiple of the
> > bulkout_size (usually 512 bytes). The symptom is that the hardware
> > stalls completely. The issue can be reproduced by sending a suitably
> > sized ping packet from the device:
> > 
> > ping -s 394 <somehost>
> > 
> > (It's 394 bytes here on a RTL8822CU and RTL8821CU, the actual size may
> > differ on other chips, it was 402 bytes on a RTL8723DU)
> > 
> > Other than that qsel was not set correctly. The sympton here is that
> > only one of multiple bulk endpoints was used to send data.
> > 
> > Changes since v1:
> > - Use URB_ZERO_PACKET to let the USB host controller handle it automatically
> >   rather than working around the issue.
> > 
> > Sascha Hauer (3):
> >   wifi: rtw88: usb: Set qsel correctly
> >   wifi: rtw88: usb: send Zero length packets if necessary
> >   wifi: rtw88: usb: drop now unnecessary URB size check
> 
> These patches went in upstream as:
> 
> 7869b834fb07c wifi: rtw88: usb: Set qsel correctly
> 07ce9fa6ab0e5 wifi: rtw88: usb: send Zero length packets if necessary
> 462c8db6a0116 wifi: rtw88: usb: drop now unnecessary URB size check
> 
> These patches make the RTW88 USB support much more reliable. Can they be
> picked for the current 6.2 stable series please?

All now queued up, thanks.

greg k-h
