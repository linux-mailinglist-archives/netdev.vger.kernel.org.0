Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2796E67D675
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjAZUcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjAZUct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:32:49 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3737ABD;
        Thu, 26 Jan 2023 12:32:47 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 000F332003CE;
        Thu, 26 Jan 2023 15:32:42 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 15:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674765162; x=1674851562; bh=tYzr0DaVNR
        V8HZ6FDJMSiSXhopDpAcTggMPsjwMzShA=; b=md3YN8wU017LIoep1j3PjkZMua
        k8z4tjYO9KltPBC9q/K2UHLoySjvOrRaF/9I0G3fmt+rOyUMpz19jC2OtI8r8W0/
        YZtf8iKJ8lxErb06iJqeAJz9MV7EQldRT65AtRESsxLyNEuX4GzP0SRfeqjk0A3s
        Vku/US6uBQCzxaXGmPzxdFs1Gh82NQ7yFP6XpsacxLQp4+M/0oVTD5vb+uXygR4N
        A0+BaZBtbdtGqYl3KUbXvymUeCc80qDVDhuUjhRSdSqscEwPTE6UljRD7aaoFkvA
        H0Zgnu20NeoI6t9Y+WkUu5F2rc65TaTnFygJYUHxuuMVHFxdqo39swySyttQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674765162; x=1674851562; bh=tYzr0DaVNRV8HZ6FDJMSiSXhopDp
        AcTggMPsjwMzShA=; b=eahcr3+d7ZWhy6X5QvZ/Jn7nZ0ZPLWSUqXLjP3U2BytO
        7MKMtjjDoEfbEO+E6R6nUVXooNrYoVC3NqRiVdLhp8tVQD31wuTqoUVFCD4AOf6Y
        USOetT5+gO4x9qxlUWnxB7I6sebzutecpy5dL4KVNs1iWaX0iAR+ZsOUVhFVWeOU
        GP+3nG3vawhNqRN4lrkOM0+8GRcJ4SJFb1kwD/i26Oytba1IIC4jHT1pxyDt0rRV
        SmNRoka8R+KgaPU6nOQYxqr0c6zOksOwL5CtqwHBF+gD5fwV5r+LMGOz1qy8hMFk
        bULu49yX5g+aIi0gj49dKBFw3SxcE1/7D3UQjLmUfw==
X-ME-Sender: <xms:auPSY5BepBvwxwBuLJtIzViTSqQlW7gjcUkU49JXIBLLHpBN0hdrxg>
    <xme:auPSY3i_p8bWwEinXrL1DApl0vRkGhIuFhSWaJQgKoF353dB_Jqq4VSDQVZFRc-Ey
    AmcPzZFCkJBi2x05Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:auPSY0muctUVkvGkyQTg99nmD7G0pb3Gee8A9De7Iqw0-lEAVsrjjA>
    <xmx:auPSYzw3mSgOiVB9LD1Z4dJCEDS55I6a_gJS_Et2tvSyacpL9vFCDw>
    <xmx:auPSY-QwcCC4g-n-vIa9n6euQ2k82ayBMgUCWqbSw4vtLSP7gd2ZOQ>
    <xmx:auPSYzLElFRGY4g-mYp4UFZTziCqtTBKD8JKdFUlHEoCaEtDKlbI6Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0429FB60086; Thu, 26 Jan 2023 15:32:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <b694c12a-e0f7-47af-85c3-eb527963a7aa@app.fastmail.com>
In-Reply-To: <Y9LAQRjb6h+ynXBZ@lunn.ch>
References: <20230126135339.3488682-1-arnd@kernel.org>
 <Y9LAQRjb6h+ynXBZ@lunn.ch>
Date:   Thu, 26 Jan 2023 21:32:21 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Andrew Lunn" <andrew@lunn.ch>, "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Wei Fang" <wei.fang@nxp.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "Shenwei Wang" <shenwei.wang@nxp.com>,
        "Clark Wang" <xiaoning.wang@nxp.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fec: convert to gpio descriptor
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 19:02, Andrew Lunn wrote:
> On Thu, Jan 26, 2023 at 02:52:58PM +0100, Arnd Bergmann wrote:
>>  static int fec_reset_phy(struct platform_device *pdev)
>>  {
>> -	int err, phy_reset;
>> +	int err;
>> +	struct gpio_desc *phy_reset;
>>  	bool active_high = false;
>>  	int msec = 1, phy_post_delay = 0;
>>  	struct device_node *np = pdev->dev.of_node;
>
> Hi Arnd
>
> netdev drivers are supposed to use 'reverse Christmas tree'. It looks
> like this function is actually using 'Christmas tree' :-) Please could
> you keep with the current coding style.

My feeling is that the style in this file is just random,
but having 'err' as the last one fits with the usual style
and with what some of the other functions do, so I'll do that.

>> +			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
>> +	if (IS_ERR(phy_reset)) {
>> +		err = PTR_ERR(phy_reset);
>> +		if (err != -EPROBE_DEFER)
>> +			dev_err(&pdev->dev,
>> +				"failed to get phy-reset-gpios: %d\n", err);
>
> dev_err_probe() looks usable here.

Ah nice, I've never been able to use that one so far.

Will send a v2 with both suggestions.

    ARnd
