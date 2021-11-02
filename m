Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76E442F1B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhKBNfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBNfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:35:11 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A8C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 06:32:36 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p16so43052032lfa.2
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7krw1+bEXcWHm2Lb+RTcgVSyvSKznVV7ccIyQF5Aco=;
        b=YQBy4O+u6TOvEb8OpE1ynDlpzrpCKfWu7ucuEnA4qXrG524vKx+lQdW7LJDpZLRN6Z
         p3eFUhpRSQHIYnMuGIdCOpOqutRBuMQSdLp97iia0juxqmCCpU++cil9rEUFnqMv/Fbn
         VxlmAAwWE5WWJMnuQjt2tBRmjefFk23JfFuZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7krw1+bEXcWHm2Lb+RTcgVSyvSKznVV7ccIyQF5Aco=;
        b=jIsa0qcIuPe9+uwPylohDBxEaH2ZReEjdfv4XEegENJ8CvEsVdkhPS8FCqsa0ZaGkW
         /5U5N/NUZYj++CQikdac1AJ5mEoK5L+5b0RcQmwa74dEIQaohhQx6FSP8j8BNuUm4EO3
         3uoO/7jJFstS2DE9jUVWjuYC+SC/j2geqOpJDG8cDIrH4LyPriv1C4YycSMQO8va5vhE
         gPibujqj4Z6t0CRnD4h5WNaz3XYjnuqkPdINXqhYDkagxdjCQTDrFcW6OMv7iOQgPd1z
         3DcaxNvFUV3kfrLnbaDrqq2KSio8ipYEw9i3KbzTYD5P9NNA8+YWR4uIZpnxuOjXUBa4
         7uWQ==
X-Gm-Message-State: AOAM532zWKrwwW1F/GL59VP8nbgeFLi6Ru3JQbtF5rZsUWb84a2os7RF
        Q1CCatLwn/vx7O6eGs2DXFU6jDpfRnxWeMCB
X-Google-Smtp-Source: ABdhPJwU1kug+s+dtu8jv+SqVWduxSXfTGKw3Ebxpq7ZZ3EKLbzf8i/masgN0EodlxeUZilrQliSWg==
X-Received: by 2002:a05:6512:3b26:: with SMTP id f38mr34133194lfv.629.1635859954369;
        Tue, 02 Nov 2021 06:32:34 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id c16sm1686718lfv.298.2021.11.02.06.32.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 06:32:30 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id v23so2194853ljk.5
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:32:29 -0700 (PDT)
X-Received: by 2002:a2e:89d4:: with SMTP id c20mr39805994ljk.191.1635859949564;
 Tue, 02 Nov 2021 06:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211102054237.3307077-1-kuba@kernel.org> <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
 <YYE9Z3wUs9HqcqhV@krava>
In-Reply-To: <YYE9Z3wUs9HqcqhV@krava>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Nov 2021 06:32:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPZM4bN=LUCrMkG3FX808QSLm6Uv6ixm5P350_7c=xUw@mail.gmail.com>
Message-ID: <CAHk-=wgPZM4bN=LUCrMkG3FX808QSLm6Uv6ixm5P350_7c=xUw@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.16
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 6:30 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> ugh, sorry.. I'll send the fix shortly

Well, I turned the "return" into "exit 0" and the end result works for me.

Holler if you think it should be anything else (like a non-zero exit).

                 Linus
