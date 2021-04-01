Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DE1351C66
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhDASRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbhDASLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:11:41 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504E0C02FE9E;
        Thu,  1 Apr 2021 09:06:45 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h25so1841105pgm.3;
        Thu, 01 Apr 2021 09:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c4YpN/VWvrS3byfnIW8qGE9xsUOvpg12XIqdmUyUU8o=;
        b=obzdZydTq3VLZLYKHwiuFEdk1I3bKx6IDB6/eymUrVHHD2lFF0IXIMs+3hRg1s73uG
         GIiB0xLRZUU1+ZnEMR5Q4ZgFiAna6E2+e8XR4XCiDxk5+qxXX6oW9XIQjGP2+uYA24qb
         6NF3hlNclEN+BbZnSWLE1mO5cUfbJ2MaaMf/WAALu3oWID5WV6IKal3qjyJqGjwpNq06
         k+LSsKNJ9wUqOdfb655IC0HSWE0QmZ1FaEpLW9I14coaYYxarLjnrFbjlND1Fo+dAwiH
         f3Rd+qyKu39qOx4J+io9TBxUZpIbHtxl5Ou/HfC+jFBNcEkY4Sidgpq2IRMqTjDLWk5k
         vAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c4YpN/VWvrS3byfnIW8qGE9xsUOvpg12XIqdmUyUU8o=;
        b=XYCR5oHBE8/5adAhHcZy8lbHyr6ZsoqS/7zG6mfiOe1mCg41ax7ovcbEfUFtbtJ9bp
         L3mNmbiXLw5GUL7c5J4EqnNd0Jxp1Ade7P6E0aKXi9FG9WnkB1dZ3KORUQgzGpV4mUPS
         Iap5PX6Zpc9yOoAoIz4e/6sk5JTcFD2JVqOM+lmyKUoROA/nXbsfK2Kc5hdHoCv8fNwn
         CTVFn9/dYWuMPlhkopJSK6QwRi50p4TGmrhrkdgNYPuqeN3emoD9NKRttbAT4/7Lf9xZ
         WmKz5a4Utol8supbSsD53q4yFseSyvu0W9EIgR8V2zl/SKhEj39zgpDzB7HJx49cmKir
         +uYQ==
X-Gm-Message-State: AOAM531A8SKPLcCL6OE2UVcDtw/MJAuhBVrpKfKPghK8ob0M4wO225VQ
        IDYpl2NVU2czWRqY6Mg9h6s=
X-Google-Smtp-Source: ABdhPJwnsOgleuOUQvjr9a9q2q0LWOlDvSbKbzfkKey1CJerH/YpWeRM+CrHZaBIab8V0TzMVODHnQ==
X-Received: by 2002:a62:1dcc:0:b029:209:7eef:b14e with SMTP id d195-20020a621dcc0000b02902097eefb14emr8293773pfd.3.1617293204825;
        Thu, 01 Apr 2021 09:06:44 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 22sm5998728pjl.31.2021.04.01.09.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:06:44 -0700 (PDT)
Subject: Re: [PATCH net-next v1 3/3] net: fec: add basic selftest support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
 <20210330135407.17010-4-o.rempel@pengutronix.de> <YGRqpxefTxZjqp6w@lunn.ch>
 <20210401074751.so4m7k3pnhcjeofx@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ea8fd02b-69bb-ccd9-10c4-82f86bd972e9@gmail.com>
Date:   Thu, 1 Apr 2021 09:06:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401074751.so4m7k3pnhcjeofx@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/21 12:47 AM, Oleksij Rempel wrote:
> On Wed, Mar 31, 2021 at 02:27:19PM +0200, Andrew Lunn wrote:
>> On Tue, Mar 30, 2021 at 03:54:07PM +0200, Oleksij Rempel wrote:
>>> Port some parts of the stmmac selftest to the FEC. This patch was tested
>>> on iMX6DL.
>>> With this tests it is possible to detect some basic issues like:
>>> - MAC loopback fail: most probably wrong clock configuration.
>>> - PHY loopback fail: incorrect RGMII timings, damaged traces, etc
>>
>> Hi
>>
>> Oleksij
>>
>> I've not done a side-by-side diff with stmmac, but i guess a lot of
>> this code is identical?
> 
> ack
> 
>> Rather than make a copy/paste, could you move
>> it somewhere under net and turn it into a library any driver can use?
> 
> yes, I assume, it is possible to make this code complete generic for all
> devices, but we will need to provide some more call backs. For example
> enable MAC loop back, enable DSA loopbacks and so on.
> 
> Do you have ideas for the new location of generic selftest code and
> where  can be added loopback options for different levels?

You could place the generic selftest code under net/core/ or net/ethernet.
-- 
Florian
