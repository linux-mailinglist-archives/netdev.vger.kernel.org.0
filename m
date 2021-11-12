Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1888244EE46
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 22:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhKLVEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 16:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhKLVEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 16:04:23 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C30C061766;
        Fri, 12 Nov 2021 13:01:32 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so10932040wme.0;
        Fri, 12 Nov 2021 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B3e+13s4p3dhI8Zf6QqfqzgmLP21sUtb60eTfseb1RM=;
        b=pVO9n6kHKfA/tQZdTAfy5MF2d/CmjtqXvWOhNlddj/wlSkaOl+8h44Psb3F0cFxIgV
         6JVlgYaTrOF+iDSy9aCmVN9nrgwgyv9uJoBYkRPkV0vI9lLGiotjxynXXdGjhxnkPHmP
         5F7eCsOU3p1rVmrTMB6sWdvQTOQ0aZGhHdyHEE4UxkqtCwWV/5BghiVLAsaQ0jOIxaCn
         LhsLT1T0O7H4lOjR7hU1XMIJx4pxCyrpBXN16yiZN7bOhmoSt2rGshpst07ZtpYSNoKq
         +NNYLEzj/fOtlHt5BzR3JzIh/9cfvgwWJ4HYpnKR6JjFmvBpDdtzUTKSrsYUaUkpO5BB
         39Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B3e+13s4p3dhI8Zf6QqfqzgmLP21sUtb60eTfseb1RM=;
        b=QpVEAKr+z/bEK17GYQw40UsUFyjOIy+3sPXm4NMPu/aG3sZF36LSa5cRfNqm2wZ8/R
         GsC7W0XUOhgLCVZAoW5OaT77E8iYYbjqOotpLOCdipN/ydOVJze93qEWaiAdZ/TlWhHn
         HV4LYcB7j2Ej44jNByfuAXcT4uYrCzgsdQB94O1rukU09D+k0g5/KbcYiP0Qwx95h8V0
         dGRPJJuBMiwXfxCGVDbmoqtVAhuvWpE+j3YTXedJLKCN7Vkrfv2rWIAAQnXWfQ5d1f4l
         Fd1OpjifLqBUdVt3Y2Ieef+3PN6f5RD2jUcNVOZlqwWObDf+WhZfakgmPbUB19tgbS1z
         50cg==
X-Gm-Message-State: AOAM533bsFdJLAkb7pATFJXCGC6ZrJJ0HOpDd1Dl+dvzex1dgEetdJOH
        b45CeqM9dPTjtfFcEdXi6VI=
X-Google-Smtp-Source: ABdhPJyxSpGkAnhYPgRNQITd3yeWDvqC9pDE/arAD4iC++4J6Tpe6GShMf0YqEQbw7v0W6pxqfb4Aw==
X-Received: by 2002:a05:600c:358a:: with SMTP id p10mr19821181wmq.180.1636750891230;
        Fri, 12 Nov 2021 13:01:31 -0800 (PST)
Received: from [10.168.10.170] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id t9sm7171558wrx.72.2021.11.12.13.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 13:01:30 -0800 (PST)
Message-ID: <ee12204f-0bfb-5b64-ef77-9217eb7dc456@gmail.com>
Date:   Fri, 12 Nov 2021 22:01:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
Content-Language: en-US
To:     Erik Flodin <erik@flodin.me>
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        Stefan Rompf <stefan@loplof.de>,
        "David S. Miller" <davem@davemloft.net>,
        John Dykstra <john.dykstra1@gmail.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAAMKmof+Y+qrro7Ohd9FSw1bf+-tLMPzaTba-tVniAMY0zwTOQ@mail.gmail.com>
 <b0a534b3-9bdf-868e-1f28-8e32d31013a2@gmail.com>
 <CAAMKmodhSsckMxH9jLKKwXN_B76RoLmDttbq5X9apE-eCo0hag@mail.gmail.com>
 <1cde5a72-033e-05e7-be58-b1b2ef95c80f@gmail.com>
 <CAAMKmoe8rUuoxFK2gKZL4um79gmtn-__-1ZDWuBgGTqfqPjZdw@mail.gmail.com>
 <ec0d0a2d-235c-a71f-92bc-45e1156bff9e@gmail.com>
 <CAAMKmocBEr05EfidF9CfqJQw4uj1YcYwmkJPR=c0eCCYgsAHwg@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAAMKmocBEr05EfidF9CfqJQw4uj1YcYwmkJPR=c0eCCYgsAHwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Erik,

On 10/2/21 18:35, Erik Flodin wrote:
> A bit more than a month has passed so here's a ping :)
> 
> // Erik

Thanks for the ping.

alarm(3600 * 24 * 30);  // :)

> 
> On Fri, 30 Apr 2021 at 21:32, Alejandro Colomar (man-pages) 
> <alx.manpages@gmail.com <mailto:alx.manpages@gmail.com>> wrote:
> 
>     [PING mtk, netdev@]
>     [CC += linux-kernel]
> 
>     Hi Erik,
> 
>     On 4/29/21 9:45 PM, Erik Flodin wrote:
>      > On Wed, 14 Apr 2021 at 21:56, Alejandro Colomar (man-pages)
>      > <alx.manpages@gmail.com <mailto:alx.manpages@gmail.com>> wrote:
>      >>
>      >> [CC += netdev]
>      >>
>      >> Hi Erik,
>      >>
>      >> On 4/14/21 8:52 PM, Erik Flodin wrote:
>      >>> Hi,
>      >>>
>      >>> On Fri, 19 Mar 2021 at 20:53, Alejandro Colomar (man-pages)
>      >>> <alx.manpages@gmail.com <mailto:alx.manpages@gmail.com>> wrote:
>      >>>> On 3/17/21 3:12 PM, Erik Flodin wrote:
>      >>>>> The documentation for SIOCGIFFLAGS/SIOCSIFFLAGS in
>     netdevice.7 lists
>      >>>>> IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, but those can't be set in
>      >>>>> ifr_flags as it is only a short and the flags start at 1<<16.
>      >>>>>
>      >>>>> See also
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c
>     <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c>
>      >>>>>
>      >>>>
>      >>>> I don't know what's the history of that.
>      >>>
>      >>> Judging from commit message in the commit linked above it was
>     added by
>      >>> mistake. As noted the flags are accessible via netlink, just
>     not via
>      >>> SIOCGIFFLAGS.
>      >>>
>      >>> // Erik
>      >>>
>      >>
>      >> I should have CCd netdev@ before.  Thanks for the update.  Let's
>     see if
>      >> anyone there can comment.
>      >>
>      >> Thanks,
>      >>
>      >> Alex
>      >>
> 
>      > Hi again,
>      >
>      > Have there been any updates on this one?
> 
>     No, Noone from the kernel answered.  And I'm sorry, but I'm not sure
>     what is going on in the code, so I don't want to close this here by just
>     removing those flags from the manual page, because I worry that the
>     actual code may be wrong or something.  So I prefer that when Michael
>     has some time he can maybe review this and say something.  Ideally,
>     someone from the kernel would also respond, but they haven't.  I've CCd
>     the LKML; let's see if someone reads this and can help.
> 
>     Thanks,
> 
>     Alex
> 
>     P.S.:  Please, if we haven't responded in a month from now, ping us
>     again.  Thanks again.
> 
>      >
>      > // Erik
>      >
>      >>
>      >> --
>      >> Alejandro Colomar
>      >> Linux man-pages comaintainer;
>     https://www.kernel.org/doc/man-pages/
>     <https://www.kernel.org/doc/man-pages/>
>      >> http://www.alejandro-colomar.es/ <http://www.alejandro-colomar.es/>
> 
>     -- 
>     Alejandro Colomar
>     Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
>     <https://www.kernel.org/doc/man-pages/>
>     http://www.alejandro-colomar.es/ <http://www.alejandro-colomar.es/>
> 

-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
