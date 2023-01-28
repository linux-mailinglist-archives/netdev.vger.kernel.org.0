Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B467FB35
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 22:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjA1Voq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 16:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjA1Vop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 16:44:45 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2539E24C8F;
        Sat, 28 Jan 2023 13:44:44 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 7E3B85C00E8;
        Sat, 28 Jan 2023 16:44:41 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sat, 28 Jan 2023 16:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674942281; x=1675028681; bh=8dkb3lTxU3
        ta1NqXzjpNbwolyQy6Iz0HDR4a6737HS4=; b=lJ0Hu1nEFE9mwm+8/ZyIc3GcFg
        ZgQe/p2W2cYz3c+bVLxWTSVdgQnXj5EeFjvcSSx40FcLlX0mtRxxCoGRJLzah73f
        o2mU4uiLRIrp4SOuta1N3a2uES0Tk8YG4oAljPqq1PweoIB8q/VR4vdjzXM/YeGf
        ldAnQ4k3bIkLLBrfDsHAhIPtIx80PEnT3BL5uFcZUnZjktKRQy52juOTaJUXQ9ah
        5ggmwBWi2gc0MHcSX+ayeImqBcXXyzto6nK+K2jFgsyfcglK3ncdxIIyaCVSGYB9
        i+Ux0EnhRDfKS9XQr6x9iQD1uQQepH+RJuCOVRkC18+BuZ/KLfGfmz/W4EXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674942281; x=1675028681; bh=8dkb3lTxU3ta1NqXzjpNbwolyQy6
        Iz0HDR4a6737HS4=; b=dfYKhdKyeLvAEk6FmbRvzrUj5LetxQk81rLeqJOkigF5
        lIs3BKoOii4e2W/C3xB5ytXo7bp4ifLaoSANrbhEtRei3SOG2c+3eEtzQbph7ThY
        HCbLI4/Y/i/9vWhC0ZhNIeKURExvllm2x4uC5w2C+B2PbPCJ6P26mf2mqu3St/OJ
        Lycyj8r3WQuKoLO7iv5ImU/YU9kSEHJw9C33jlgIsDWAr0CVwG0UM7uo3jmGJ+q1
        UymFwCVfhWGgcGWx6LNgMYdL8VOIqdm7oUo9Vy+J5RE9znNrjcxADw4BNCLIVOHV
        f9qAPr2d1KCjPpTCCn2anU9BR6sYO5Je8KdJ5oSxVQ==
X-ME-Sender: <xms:SJfVY6PV8saFGHE6xLlYV6V9ok0Io6B89BNNBpvVVVXvW7ppW--xGA>
    <xme:SJfVY4-Ej3UhJbSQuMereYQJttTVSuFi4qayX_ArTcqd1z1JrK0NVX0B8nelpZRId
    nw2DMha-nhfjqO8XaM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvkedgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:SJfVYxRDaCxvPZxN09k4n597SoOsQ77xr5YJj2HnzlEVmvWKOVkJtg>
    <xmx:SJfVY6vz-wdJVnFSdL7nMZNMI15Wd3s8aLY-pHiBeshfI-4ZiuIF-w>
    <xmx:SJfVYycmGusYE16DqvsXykbXoHb44Llgd1jBmOtugYQl19V6dnSftg>
    <xmx:SZfVY43yVc2fcaTOy5iuHJuydP1hS47el-8cekjVCgcS7w_2RNX4Ig>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D3A00B60086; Sat, 28 Jan 2023 16:44:40 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <2d90460c-9d30-46cb-871e-e2500243ffd3@app.fastmail.com>
In-Reply-To: <Y9RlHIqbVNG7SoDw@hoboy.vegasvil.org>
References: <20230127221323.2522421-1-arnd@kernel.org>
 <Y9RlHIqbVNG7SoDw@hoboy.vegasvil.org>
Date:   Sat, 28 Jan 2023 22:44:22 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Richard Cochran" <richardcochran@gmail.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Woojung Huh" <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, "Andrew Lunn" <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        "Jacob Keller" <jacob.e.keller@intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: ptp: add one more PTP dependency
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023, at 00:58, Richard Cochran wrote:
> On Fri, Jan 27, 2023 at 11:13:03PM +0100, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> When only NET_DSA_MICROCHIP_KSZ8863_SMI is built-in but
>> PTP is a loadable module, the ksz_ptp support still causes
>> a link failure:
>> 
>> ld.lld-16: error: undefined symbol: ptp_clock_index
>> >>> referenced by ksz_ptp.c
>> >>>               drivers/net/dsa/microchip/ksz_ptp.o:(ksz_get_ts_info) in archive vmlinux.a
>> 
>> Add the same dependency here that exists with the KSZ9477_I2C
>> and KSZ_SPI drivers.
>> 
>> Fixes: eac1ea20261e ("net: dsa: microchip: ptp: add the posix clock support")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

The randconfig builder just found another regression in the same
driver, I'll have to send a new version, so please disregard this one
for now.

      Arnd
