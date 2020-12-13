Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C272D8E45
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 16:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgLMP2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 10:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLMP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 10:28:05 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC02C0613CF;
        Sun, 13 Dec 2020 07:27:25 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id s186so1655773ybf.3;
        Sun, 13 Dec 2020 07:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0U/jU5RkMzu5zlRR43LWUba3KGcXSHqGsMQRfeSGNUU=;
        b=VZJ/JV9lW6ZnEMtDmF4zpdsNvvy7vLU/FZKvGO9PPllC+1jUx3XrGLz8FKrUpCe8Sx
         nMvnhG8u3IrmE07cifYoFhlu4TxDXjturmIrc7P4m7Bb8PqFHGwp8ECMkJYAQO+FauSb
         HjRU0rW7FNs8s1zflZ5jqLLiYjjo4wiwfo7qpqRgMiDbTe1ZU91TIDu7bhhvUtVQt+Yv
         4g1JAnUnNcaQVieKr//CG4UTVypOY+X/27IYl4DHtOyWekzXWklghmrf4xz5AK2XUf2Y
         ACfeVt54ZCoq4K2fxqAzkphJeE3UVJivWPXyEtsIlTvW0JTCRydZ91gRJyqi5YziOklg
         cV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0U/jU5RkMzu5zlRR43LWUba3KGcXSHqGsMQRfeSGNUU=;
        b=dXUCx5OxI5FT06Qh7CD8VoC1Yftg8cXNDCIZoGTs9H3pArAORVF1xsrtEO6eHq2i/5
         hfkPcipbbr3e8tfGPwRU39fIDJZEexaiIG/KJHOClGDxNGfu82PXQlrYa6B/dJFkmZNh
         XkuZ8Wej/xPrI0tCnSj4LE3FgktwWigoVLUaTdYIGXJhrmsrliKKN0/I9PT1mAGW8iGX
         oVCnrz1mXxN1GFXJDfIdPWn7NLiptPFZDgeRDvN77ojQzWmYZy9glUt3DLrt/ws6HMfp
         ZTjfKxwZFxfkJfEYtV6u/4LWgTreQGT1KJN41g5yfcS9uTB54CuZOGkvKvLmmDeQyONn
         3A+Q==
X-Gm-Message-State: AOAM533iNI2hCe1pZLSkZc5JDqWYoi0QGfag4s6bBnTLFGjqEiF0HoKp
        QKefjr+bxk4itfq6AATN9tMBegfHK4AtR/LARbE=
X-Google-Smtp-Source: ABdhPJxi6/CjWqhWH3vgZntCXvVuEb6NihB6qIT22MoGs1z3K48dq8oW38IuHpxdu+lMQnavhVTJcWHi/RefKEktDCs=
X-Received: by 2002:a25:538a:: with SMTP id h132mr11965104ybb.247.1607873244794;
 Sun, 13 Dec 2020 07:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net> <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
 <X9YwXZvjSWANm4wR@kroah.com>
In-Reply-To: <X9YwXZvjSWANm4wR@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 13 Dec 2020 16:27:14 +0100
Message-ID: <CANiq72=UzRTkh6bcNSjE-kSgBJYX12+zQUYphZ1GcY-7kNxaLA@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
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

On Sun, Dec 13, 2020 at 4:16 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Because if you get a report of something breaking for your change, you
> need to work to resolve it, not argue about it.  Otherwise it needs to
> be dropped/reverted.

Nobody has argued that. In fact, I explicitly said the opposite: "So I
think we can fix them as they come.".

I am expecting Masahiro to follow up. It has been less than 24 hours
since the report, on a weekend.

Cheers,
Miguel
