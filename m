Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C693240CD45
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhIOTgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhIOTgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 15:36:47 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CC0C061574;
        Wed, 15 Sep 2021 12:35:28 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id t2-20020a4ae9a2000000b0028c7144f106so1268564ood.6;
        Wed, 15 Sep 2021 12:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P1ECcmsmuba1oAFsdBaIaunXX4jIoXBz4adWd+uAznQ=;
        b=lNS86u2XWmjJVaOW2UI3pL79UP1Ks4vqPGTj8jc+1t6xRg7OAI5d95gkLp+ZhCV6jZ
         AYLwqR8qUVdKzijyYwASyT47/6S4mNpAeONL5btF61E0ZLbBplc+vDJddX1qUeNWMGYr
         BuKqTQxBhNt9BDRNshou7yG4f7t8arqoUSgT6X7KWHbfEfATnv2Cs2+vQ8WaGEqv+TJW
         yEaiv/ZJ24fLjVW+6oIKph8lQTbM0YsFR9L++sq/5Dk6hsYBJ6nY5Q6xy28l5eFkhRcT
         MZVKv1xAuh2RGw6JvSEL9jj04GlT8k2GEy8vkFkkgmuAHkiFq3IcMnC1fHWnzi2BJcWQ
         gjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P1ECcmsmuba1oAFsdBaIaunXX4jIoXBz4adWd+uAznQ=;
        b=NAeSPBteL0CnNnUjKt97LdO1m9iyXco1xFbSFajk/fv67tk3ugO6T4sx06XHYXJGZN
         PcvTlzHt3aiOotAyNL/ILglFyiLLSFIvXsbfLNnJr1EXr3IVWqKdDtNNYzHaxbDFpbli
         Yx2tKR4uIE4yNoSUhc5WFsec74bWimkMS57+byuz5ephXq0Paa4N91BKEepquQfumEds
         3sByRVX0Gzh7DOwDPcHB/PQRsWDPIqBddhKye/Xp1frlONUVNEhFl2rgfsW0HyR2sLKu
         ARuxdpBsDGALmoz1sPKUBBTksbauYEcB38Az4D7qoonWwGeaK2KOMtxGJO5KJJp+V+I+
         2sig==
X-Gm-Message-State: AOAM5333OmOOwEXNSsoDV6fVVrfLjYjQAe+RZmgDWS8B6UHNc9fDIAye
        3STiySwWJtXZvwo2xbfsBwIk0GFgOpc=
X-Google-Smtp-Source: ABdhPJwerRN9lMY4WH/E6kjE1a3oWD1opiz2Tpxg2yT0xmyCHXbAckelh2K7PFloaVahuOC4fRY1mg==
X-Received: by 2002:a4a:a8c9:: with SMTP id r9mr1271861oom.49.1631734527451;
        Wed, 15 Sep 2021 12:35:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x13sm219710otk.42.2021.09.15.12.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 12:35:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
References: <20210915035227.630204-1-linux@roeck-us.net>
 <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
Message-ID: <47fcc9cc-7d2e-bc79-122b-8eccfe00d8f3@roeck-us.net>
Date:   Wed, 15 Sep 2021 12:35:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/21 12:18 PM, Linus Torvalds wrote:
> On Tue, Sep 14, 2021 at 8:52 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> This patch series introduces absolute_pointer() to fix the problem.
>> absolute_pointer() disassociates a pointer from its originating symbol
>> type and context, and thus prevents gcc from making assumptions about
>> pointers passed to memory operations.
> 
> Ok, I've applied this to my tree.
> 
> I note that the physical BOOT_PCB addresses in the alpha setup.h file
> might be useful for things like MILO in user space, but since I
> couldn't even find MILO sources any more, I couldn't really check.
> 
> I suspect alpha is basically on life support and presumably nobody
> would ever compile a bootloader anyway, so it's unlikely to matter.
> 
> If somebody does find any issues, we'll know better and we can ask
> where the user space sources are that might use that alpha setup.h
> file.
> 

FWIW, I did find a set of MILO sources. Search for milo-2.2-18.tar.bz2;
it points to a variety of gentoo mirrors.
That version does not reference BOOT_PCB. I thought about removing this
define as well as a couple of other unused defines, but wanted to keep
the changes minimal.

On a side note, we may revive the parisc patch. Helge isn't entirely
happy with the other solution for parisc; it is quite invasive and
touches a total of 19 files if I counted correctly.

Thanks,
Guenter
