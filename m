Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C14601F1
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 23:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhK0WbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 17:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhK0W3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 17:29:21 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C38C061574;
        Sat, 27 Nov 2021 14:26:06 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id n66so26273613oia.9;
        Sat, 27 Nov 2021 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wcmyLXZ73rYprw4e/YcAlXmXR6M5Ol7ECGWDzfw80Jg=;
        b=LlUbAwoDvmBWw8eVw8F+acjZgI5NDtTIQHXxJka2bh3nDX1PPcuUP8HP+nmG6u7MCv
         7/ruw/a7/ZXit649bVDo1YKuF/Ftzm01J34FQgYwhejGBQwAqy5/XRorGxJ9YY1IkcDg
         FBWh8V8++MkjCv5HVNdjm2ro7ZX8FcrrzpM3XQWiV5iI1eCABoP/RkYWvUB1SRqoI36J
         Kt9VLD2CJjcIOvJk2RofdhDTjEiottNvwMqCmm0XF3Dc3HkCM8EoP604lExYwIW7dQwV
         QuNUli+1fitv2ByeuOAc4jGaFNPVs88AL6YsizBGUE9/lWgt3bCvL8lab4qjsVjSTmR7
         YI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcmyLXZ73rYprw4e/YcAlXmXR6M5Ol7ECGWDzfw80Jg=;
        b=EeDvJ9ptytPB6UhnFDi4b32DfWxREl5PAYzRn4bCzKZeyPQNGzrF78LtpygO5JvyEj
         mnDMkc/rVq2r1Rmy4Gcs+uSWuaw1WUmDzu9SKNXavEhctLvVTr4IWwxDxSobtyyAa9TC
         lf/GhXVAyZyCmJUZe88WCfh7GXQp04E8vDy+ZHjtgugDZP5QIfk8guwJc5TiNzX1IyjL
         SVG53r4hs9XrROrJa8k7X9csiDisyjhrgBgTiEeI2CA+EZX3r38U2cEYSh+WoGkuGk3N
         BLDDsgzyAW95lI3WdjfnIC37TjJze6kR0RA6z+hX7/rE0ZZl9cT79eb5LE5x4fcm1ANv
         jPdA==
X-Gm-Message-State: AOAM531Gw3NnAY/gp61j4eKfs6Fz2+rNy14FCzz12PYYbkB5oKl61qtz
        Cb4R3P+2fzlLOM83xfe/9UrRu52n+0E=
X-Google-Smtp-Source: ABdhPJwmJ7X6zjXM1EsyPQebAD0TEWSFKNUCiNA3mQNoyYYlfadypbsdNDHtHAUef6FovV9RG6OwIA==
X-Received: by 2002:a54:4692:: with SMTP id k18mr31814566oic.93.1638051966001;
        Sat, 27 Nov 2021 14:26:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t5sm1670500ool.10.2021.11.27.14.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 14:26:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v3 0/3] Limit NTFS_RW to page sizes smaller than 64k
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>
References: <20211127154442.3676290-1-linux@roeck-us.net>
 <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <228a72fd-82db-6bfe-0df6-37f57cecb31a@roeck-us.net>
Date:   Sat, 27 Nov 2021 14:26:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/21 9:49 AM, Linus Torvalds wrote:
> On Sat, Nov 27, 2021 at 7:44 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> This is the third attempt to fix the following build error.
> 
> Thanks, looks good to me.
> 
> Should I apply the patches directly, or were you planning on sending a
> pull request when everybody was happy with it?
> 

Either way is fine with me. Either apply it now and have it fixed in -rc3,
or we can wait for a few days and I'll send you a pull request if there
are no objections by, say, Wednesday.

Guenter
