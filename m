Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BADF67D198
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjAZQ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjAZQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:27:29 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79047375F;
        Thu, 26 Jan 2023 08:26:34 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 876E73200A2D;
        Thu, 26 Jan 2023 11:25:48 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 11:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674750348; x=1674836748; bh=NaFVoqTHQH
        cJ9HsTieBYpGZYHbu5p65aAcMF7VEyI5Y=; b=Gt3QmEPraM1rPycnoOri4/0nGN
        7mUdA2sAei0oxfsCFgnhOnm1qSIIUDGBcVeLUgKPtgTIuvFozT5ZaBd9df5Jv2zz
        azFQ0VYqFiA8kqr+uzh+W+psPianbxAPaquRbwKg3SVMFZZAlzsvMoinbqKC/Qyl
        Pse/y5/pWbrKWvwIFvS5o0DWtjeITeeMy0K7qCVRar6BKI34gJFLZntz4Qi9nLay
        IBk3D3qVtccFCajKELtxStv0Q0OsSBvTy5IZQj1ZA2jAKhGXBDcWw4cGjn6QDSKr
        NZ2YHc/o3CU4SvxOVn7RFKJi2JyZcmQ8BaQ15z5NyHCKzY9P/Irbvz0SteYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674750348; x=1674836748; bh=NaFVoqTHQHcJ9HsTieBYpGZYHbu5
        p65aAcMF7VEyI5Y=; b=C5WHYpbhjgF/YWASYwjPKeeBI2bGnI6sqQGX8GZyAgMo
        gwcVJQqX28VGbHYU7fI/wT50bCNs9FqiyD+w4CMQAL0tiasOgbrx9MemErPqX8ZD
        JmL0kmEiwNuY5GJy1hGh5bwDxobxFtNGWCQ9YwnJonCfYaI7c8voxrrFn4gSNn8m
        Mz4PD1eYR8hjQHFLLG8r1rOs+/ciSFdU5z+5nxAzjY7OHla3FGxVd/M9r4fmd7Aw
        l3bp/8UDx395g+RSYiQTh9khlV1sXdEmrLJyh3hQ2k3iwtIjA+ug2xAKEOzClG1U
        zCvQHAYhzgdzY4DLBm0kHiF2dDXQYxbrPIUC3sZcbg==
X-ME-Sender: <xms:i6nSY7UiCSclozXycVbFBgBP1UA8KqcX5NTOeEFR7yN6a2-h90e12w>
    <xme:i6nSYzmB5BB8r6I_kqnEmrxVpzLxmZ5Xkze7-AAB_UdbqGRq7DR4CgMhFF0NG5TrM
    WsFHUw6vOq0_uQTpKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:i6nSY3aTUANaj2paDIXomCPxZNWrEG4B1kjqr1HE3ah8z3AVy1NiNw>
    <xmx:i6nSY2U5dleINlyZmm24tEMr_GM0fru-Ukl6pN44kZf1qFUdaH18lA>
    <xmx:i6nSY1nyRjBJJfqP8_fZZPtzJvmJFYnFVsqSNXkqtrZFbY5sD2IQhQ>
    <xmx:jKnSY2h9UCDwWxEnc8YyWi-_v66mQ3pM15bW3kJvg0y2vTF6z_EW7A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 675D6B60086; Thu, 26 Jan 2023 11:25:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <57e74219-d439-4d10-9bb5-53fe7b30b46f@app.fastmail.com>
In-Reply-To: <20230126161737.2985704-1-arnd@kernel.org>
References: <20230126161737.2985704-1-arnd@kernel.org>
Date:   Thu, 26 Jan 2023 17:25:29 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Arnd Bergmann" <arnd@kernel.org>,
        "Alexander Aring" <alex.aring@gmail.com>,
        "Stefan Schmidt" <stefan@datenfreihafen.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>, linux-wpan@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ca8210: move to gpio descriptors
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 17:17, Arnd Bergmann wrote:

>  	if (ret) {
> -		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
> -		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
> -		gpio_free(pdata->gpio_irq);
> +		dev_crit(&spi->dev, "request_irq %d failed\n", priv->irq_id);
> +		gpiod_put(priv->gpio_irq);
>  	}

I just realized that this bit depends on the "gpiolib: remove
legacy gpio_export" patch I sent to the gpio mailing list earlier.

We can probably just defer this change until that is merged,
or alternatively I can rebase this patch to avoid the
dependency.

   Arnd
