Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66E02D8E1C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405606AbgLMO7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbgLMO7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 09:59:12 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F5C0613CF;
        Sun, 13 Dec 2020 06:58:31 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id w127so13028137ybw.8;
        Sun, 13 Dec 2020 06:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plNVcmrce8g2J8M3GvZaxtbh0wYjjwJH9EhP4nToGcg=;
        b=LpFXWaQL6fLau/RHuV7zuorCsHamAKs9/0ITBJlTv5NR82LANrttpzO2ebQMsHpZfG
         18b+X5d4gAG21gQxCKibZHkhKwIbA39zfcomdlccbTuhTTpTYE8s66MoSH14+4HiQUnr
         g4mbJj/cbabq1rM/S6PMysI3haCDy9iyIGpBgd0he39coQdvcCX3FGp28qe7ki5efaDV
         DBw+xjWRj9e3WpJE8JAacbCQFHl5SMH3FRHCj/uBZ6C2eT+VmDlUybrGEq1alP6Zll1R
         oPZbKzlxxQp7fxvY3PmQ59y30aadQOZGheSPiTTOv/SGokObhWdsdMTtSemZUbpWin2k
         P+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plNVcmrce8g2J8M3GvZaxtbh0wYjjwJH9EhP4nToGcg=;
        b=ssEYGbdNTuw6FZhE7RTTWkkkoDB0yhjJT5a7NuZ23B18ZBrew1jVVc3Kzgu311V6oP
         wNtygylQbDusexVTgz/1FdXlZnFnXcr904e1Wi4r9YdcmXCIx2uSRFu7KtoGLk+Bz+6b
         Nh6N7cNLc7YsgQDZQ8wJbex7qAhzEsBNoyht8kqdfhzOrLAy+DL/QkERiJMTG4vP+i+W
         LPRNrJJOHtGrlhHqq7ebl0I2xUDEQ/o1wxnyqT0/Mj9L71Zrfq2DEddZ2f1j67Q/ysHC
         AOfKl13FKmWD+4RpFuc3TX98Xr76Uq5BNJTGzE+gDx66/j2jN6ltH0Z0SYBY0SrDf8Zd
         ukQA==
X-Gm-Message-State: AOAM532LHjlDIclXAGky5patU+xQLOCkIa5TfRkVv8iIISoEaayA6sKf
        goHRMCT7MUURs1paHdYTVSl+WwHicA5PvRhCZz8=
X-Google-Smtp-Source: ABdhPJyleUHOQ1Dzwsvco4D8Kb6ED8lXDzo42gqSNXB0njsWpLnkEVMEMAkYlMTU9I4fZNhLo+xUhDEMmRjvFVpRMyU=
X-Received: by 2002:a25:538a:: with SMTP id h132mr11841975ybb.247.1607871511230;
 Sun, 13 Dec 2020 06:58:31 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com> <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
In-Reply-To: <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 13 Dec 2020 15:58:20 +0100
Message-ID: <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 1:55 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Witz komm raus, Du bist umzingelt.

Please, explain this reference. :-)

> The key here is "if nobody complains". I would argue that it is _your_
> responsibility to do those builds, and not the reponsibility of others
> to do it for you.

Testing allmodconfig for a popular architecture, agreed, it is due
diligence to avoid messing -next that day.

Testing a matrix of configs * arches * gcc/clang * compiler versions?
No, sorry, that is what CI/-next/-rcs are for and that is where the
"if nobody complains" comes from.

If you think building a set of code for a given arch/config/etc. is
particularly important, then it is _your_ responsibility to build it
once in a while in -next (as you have done). If it is not that
important, somebody will speak up in one -rc. If not, is anyone
actually building that code at all?

Otherwise, changing core/shared code would be impossible. Please don't
blame the author for making a sensible change that will improve code
quality for everyone.

> But, sure, your call. Please feel free to ignore my report.

I'm not ignoring the report, quite the opposite. I am trying to
understand why you think reverting is needed for something that has
been more than a week in -next without any major breakage and still
has a long road to v5.11.

Cheers,
Miguel
