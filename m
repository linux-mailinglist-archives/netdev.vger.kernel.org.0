Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4E15550F9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359314AbiFVQML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiFVQMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:12:10 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286693EF15;
        Wed, 22 Jun 2022 09:12:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o18so8738151plg.2;
        Wed, 22 Jun 2022 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j8r/O9ShKbOvcKjQlw/RjMna9fPcG+3RY5Q5cZe/Kro=;
        b=gYbs9y+xf51ucpxCOn+2QP0ygTyl1IwBma21U9X8bNbdTUQKv8Pado8sn5dXUqwfLX
         OOAUWBb+nc+7imt5rsGSilrDUPHm6W+FQQt2oyoHnjInzvpHo0lwUMsLxMoPfCu1k8Vh
         Lps105sJGJzcSTgapuEewSuSghMGArt5YjnhsKhi4tZUwYJFDSrafqMnQ6qGW7eXDoTk
         wqQBCfUYgyUlT6nzijiqUbfYv+D87WpN1HrsQpEI/koMoSa5rj1g0ZqcyI0gbInreNGH
         QAHASNlQd4X/vjpt4Sftef1QsZTRTYRqTOfjOcMp1BlgnHZuxBRU1ZMMdypOYe6xjmNn
         s5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j8r/O9ShKbOvcKjQlw/RjMna9fPcG+3RY5Q5cZe/Kro=;
        b=4YQJmWHsQlZ3w2XPtTGdR91JXlUbhJ5tQRo6o89m5jp0Lb1fzQZGE3mrhtgcwzHC93
         2K6lxPbHEHt5Ab4zdxG297tTbjoxQEbUNR3A83r5bVbjqlW60CvernKq0bQdUJSrfrav
         8mnx8vGRg+FRXAdD9RLPEUS19fATU0oMRXocH3Fyn5LXpbWXPTDkBlPp9/+NVS1y8erf
         WAJibQh/NuCgO9cJyNFDweEyLfhIWUqM0IDa2fU7Hf2cot/NhHd+C8q4ARo/tt9n5wp8
         +iIoZ40FrhAaxOhIOG7WP2BmVegyNt2SShLd5vRofp/tz7s3wL8ew6AkFPhh3FKhjdZa
         LgEg==
X-Gm-Message-State: AJIora86ll1f82qCQQ8rLvEeo1NOVqDTdy1jIsHhLwiXN9gBMJ47hSsk
        5WctzM9bdyQKr1W6Fe7RAa4=
X-Google-Smtp-Source: AGRyM1vie+oHJG2VipZTETlxnk4+fQelsWgavxhXjpIh/x5DAtjX0+xysq2xMqP34Ci+EMy1NZQU5g==
X-Received: by 2002:a17:902:e746:b0:16a:4515:b2d9 with SMTP id p6-20020a170902e74600b0016a4515b2d9mr5204011plf.116.1655914326564;
        Wed, 22 Jun 2022 09:12:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b9-20020a17090a550900b001eaec814132sm3088109pji.3.2022.06.22.09.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 09:12:05 -0700 (PDT)
Message-ID: <54618c2a-e1f3-bbd0-8fb2-1669366a3b59@gmail.com>
Date:   Wed, 22 Jun 2022 09:12:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-9-mw@semihalf.com> <YrDFmw4rziGQJCAu@lunn.ch>
 <CAJZ5v0g4q8N5wMgk7pRYpYoCLPQoH==Z+nrM0JLyFXSgF9y0+Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJZ5v0g4q8N5wMgk7pRYpYoCLPQoH==Z+nrM0JLyFXSgF9y0+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 05:05, Rafael J. Wysocki wrote:
> On Mon, Jun 20, 2022 at 9:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
>>> The MDIO bus is responsible for probing and registering its respective
>>> children, such as PHYs or other kind of devices.
>>>
>>> It is required that ACPI scan code should not enumerate such
>>> devices, leaving this task for the generic MDIO bus routines,
>>> which are initiated by the controller driver.
>>
>> I suppose the question is, should you ignore the ACPI way of doing
>> things, or embrace the ACPI way?
> 
> What do you mean by "the ACPI way"?
> 
>> At least please add a comment why the ACPI way is wrong, despite this
>> being an ACPI binding.
> 
> The question really is whether or not it is desirable to create
> platform devices for all of the objects found in the ACPI tables that
> correspond to the devices on the MDIO bus.

If we have devices hanging off a MDIO bus then they are mdio_device (and 
possibly a more specialized object with the phy_device which does embedd 
a mdio_device object), not platform devices, since MDIO is a bus in itself.
-- 
Florian
