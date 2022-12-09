Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4ED648B3A
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLIXDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiLIXDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:03:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1B717E28
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 15:02:55 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gh17so14818778ejb.6
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 15:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/aeKMFQU+iFrGssD2HzuTKSQiDy/WnYgEIq5mTFJ33E=;
        b=jqWnXQKXNRdFIn+/lxGvv6ReoEWdXOkC3kGAPRxqUoEfsoSuxpPtCUTZn1XX6urYbM
         qlsMTUTvVV4Qe47DsR/XpMnnvEDi4rr0aH/6lOVvDcP6HGR4R4UJvWA4EDUWUEfKRY8S
         +Ax2O0ihI3fZ2XEG+5qdNzh4IVfnTRTuNNoi6DZ+/Uu6mZglsfdsrfa+B+9eti8r79Bf
         E1jUqFLoxv5Isu6lMJUpMh+noQnIx8ZM5sG+EBpdKArDKd8FJ63IttxtTZ19l6ZSb7dW
         XLAihCoLFnpbagKGJNpDygDR5W34AUl0t2SYfKeJSEPlXftDg3+VZUJs8PiEFRmGjZ9+
         6s9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aeKMFQU+iFrGssD2HzuTKSQiDy/WnYgEIq5mTFJ33E=;
        b=d3XC4njKjNmDC8s5iA6iVWkikLEIV87KuuXer+LESE0Y3nfbe7Q6i1pSLXVVsp+qr2
         Lu1ZC87BdnTydH3MEg4/O0lV9ZqxsCq8ZMyq9emR1DZNJQz8L8lX4fmpmwyiRsohkmbg
         pvCnwFQo11NtLMb1nRnx2lzNJC4jQZnGIC8koGHsPflZd2WMLVg2ULlLaflDEVqOCIGL
         2Ztf6+FH87XuJmk23Uy8/fQQCoktR4DxHVByYxu2mT1Ttx00uNQQRvP6IsfNc33CwS01
         WLPhUuRXCpEnw1u495xhxm/yW30bVgYbIhJbW6dHf4iIiFdSgH//sGDj9+XpVnJFRKbT
         7wOg==
X-Gm-Message-State: ANoB5pn5CiJBcTshsMimLFkCqHfhnY8c9cGAJXopw25PAL6JPvSqEfga
        xb6CiMxxVYkvtMoLIUt1V1ECjQu7sIo=
X-Google-Smtp-Source: AA0mqf6N3/Y9WKhn0cX81FUbJP1YAGMyniNhEYzKnOaletdcP3MX2XADys1qRxXLbtYJTsNApUblsA==
X-Received: by 2002:a17:906:a3c1:b0:7ad:a2ee:f8e6 with SMTP id ca1-20020a170906a3c100b007ada2eef8e6mr6271902ejb.15.1670626973608;
        Fri, 09 Dec 2022 15:02:53 -0800 (PST)
Received: from ?IPV6:2a01:c23:c56b:2400:e99f:52d8:9f37:ca2e? (dynamic-2a01-0c23-c56b-2400-e99f-52d8-9f37-ca2e.c23.pool.telefonica.de. [2a01:c23:c56b:2400:e99f:52d8:9f37:ca2e])
        by smtp.googlemail.com with ESMTPSA id 14-20020a170906300e00b0073dd8e5a39fsm390130ejz.156.2022.12.09.15.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 15:02:52 -0800 (PST)
Message-ID: <6de467f2-e811-afbb-ab6f-f43f5456a857@gmail.com>
Date:   Sat, 10 Dec 2022 00:02:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
 <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
 <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.12.2022 16:29, Hau wrote:
>>
>> OK, I think I get a better idea of your setup.
>> So it seems RTL8211FS indeed acts as media converter. Link status on MDI
>> side of RTL8211FS reflects link status on fiber/serdes side.
>> RTL8168H PHY has no idea whether it's connected to RJ45 magnetics or to the
>> MDI side of a RTL8211FS.
>>
>> I think for configuring RTL8211FS you have two options:
>> 1. Extend the Realtek PHY driver to support RTL8211FS fiber mode 2.
>> Configure RTL8211FS from userspace (phytool, mii-tool, ..). However to be
>> able to do this you may need to add a dummy netdevice
>>    that RTL8211FS is attached to. When going with this option it may be better
>> to avoid phylib taking control of RTL8211FS.
>>    This can be done by setting the phy_mask of the bit-banged mii_bus.
> 
> Thanks for your advaice.
> Is that possible for us to register a PHY fixup function(phy_register_fixup()) to setup rtl8211fs instead of setup it in PHY driver?
> 
From where would you like to register the PHY fixup? r8169 would be the wrong place here.
There are very few drivers using a PHY fixup and AFAICS typically PHY drivers apply
fixups from the config_init callback.
Having said that, if possible I'd recommend to avoid using a PHY fixup.

