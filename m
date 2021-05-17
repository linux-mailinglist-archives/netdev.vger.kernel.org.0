Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454C2382D9A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbhEQNkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 09:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbhEQNko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 09:40:44 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0DEC061573;
        Mon, 17 May 2021 06:39:28 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id c13so1891659qvx.5;
        Mon, 17 May 2021 06:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A3NxUbNLMPXTjkL8u55YMZmOt8zksMxOha2crYcJLBA=;
        b=kmO+qJKsZcLoOF7PGkm7L32EvjE7uvAOFNYHvxVYs+HohMpY3FgbtRFNwYIxunRfy3
         QF6nFYW+Q1rX8DcIqD/0A1aPDtX8Lc8C6bNEocA1mPYbW0ydnWBkQ2UEE96b7Ptcqmt6
         rz7+Nf2fSE3WvA5jeNY8Xepddza2/Huo7nU/zH8TgkESOpyqvnDOaYqGiN4snhz+YlDf
         IoedFzl45I0+r2fcyvlu9EeAA9FBaRLnofRhDy/Cz7yoxKtA9w6BMvXqrccsz8gbts3M
         doukWLr7clciHBmHFe0/3oJkERLs+GvBkiSCaYnNTvpPVjdLF3R6MWglbb7AUWtlfk/G
         ambQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A3NxUbNLMPXTjkL8u55YMZmOt8zksMxOha2crYcJLBA=;
        b=OhZaMO+NeMNE4gde7/18ad2aGEWtjeC9HhFaT8b5DaQMKOXMnNM7bY7vkhxsuJ4Sx/
         H7tytvchavk6ZQXW5aIXKNmiByy3zQbfY7qWPO9TtON+wtjSPtm9XuZC/8JJuOLwB/rZ
         Tw/hCWANogKMh2spbZgoUsV5fMA4G22jXGOi42d96VczUpy28Fq3AY3BpyrPor/CwrMl
         W5YT4GVyaZgYTAnZ3B6EM7Sb14ZdF82EuUHX6DWYxv0sWS001huLyqi0kJKX0NVn9VCY
         52eQOOL392OFZbjA4hAxj0ysb76OJiitdjlCJex84hQ7lvd8R5wQix6pTGxa2f6Ksw5S
         BB+Q==
X-Gm-Message-State: AOAM5328/NSG2GX3vYeSEhd1NX2fMrbqYpY78z0E2FeyjDnKLfGB6JNA
        /x0y9Y8K2y1EwMG/DHNJ2HeXh/7kxD0=
X-Google-Smtp-Source: ABdhPJyFpQWas9TnjR3tLUfuTcCLS2v5FkqsbUjFFDtmU1mcdGY0L3TTuO36o/huwbr37WjGdc0i0Q==
X-Received: by 2002:a0c:9b83:: with SMTP id o3mr32661074qve.4.1621258767420;
        Mon, 17 May 2021 06:39:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm10127053qtn.89.2021.05.17.06.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 06:39:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
 <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
 <87im3hk3t2.fsf@mpe.ellerman.id.au>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e2a33fc1-f519-653d-9230-b06506b961c5@roeck-us.net>
Date:   Mon, 17 May 2021 06:39:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87im3hk3t2.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 4:17 AM, Michael Ellerman wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
>> On 3/18/21 10:25 AM, Christophe Leroy wrote:
>>> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
>>> removed the last selector of CONFIG_MV64X60.
>>>
>>> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
>>> can be removed.
>>>
>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>
>>> ---
>>>   drivers/watchdog/Kconfig       |   4 -
>>>   drivers/watchdog/Makefile      |   1 -
>>>   drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
>>>   include/linux/mv643xx.h        |   8 -
>>>   4 files changed, 337 deletions(-)
>>>   delete mode 100644 drivers/watchdog/mv64x60_wdt.c
> 
> I assumed this would go via the watchdog tree, but seems like I
> misinterpreted.
> 

Wim didn't send a pull request this time around.

Guenter

> Should I take this via the powerpc tree for v5.14 ?
> 
> cheers
> 

