Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895F54256C9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhJGPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGPmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:42:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F1EC061570;
        Thu,  7 Oct 2021 08:40:10 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i11so5823198ila.12;
        Thu, 07 Oct 2021 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7jRrqeIN2Ff7fhNeRl05LpK9LcpWLgKaWr6uuwqcXss=;
        b=fSM6z68idkwQOzyYwSOc2QFqnsNNFr9HkHzjw3yuwj0J7UUwvGMwTk+N/1z6GE0Y7X
         q+/60JLPu28hZVnTReYYr5PL1+mv8ubaBURWau9zpWjIpOpqh1hULgdj/5I/XH/x0WNa
         CVGbJIKcz/YUrMMNkvRWMV7r9Ijiky6Xlp/I0NmgO0S6FjjL0w8If5dptZL3yLp5EKqj
         S3DLwNhokX4iaYtyn76b2R+bJLiy+W0m+Eyu89xezQ5Opwzi4r9jIb6f5FPKD9VANgCp
         tzXMjMpjkstTFLZ8nnsxYgdxfwLfMPLvyqr+0tKt0GP011JILUtbRl+IY/qB22+FYMeu
         xPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7jRrqeIN2Ff7fhNeRl05LpK9LcpWLgKaWr6uuwqcXss=;
        b=fLrPQ/n5czNAnHO7WVdpZHCZorknIdBwfBVzmxYdmfHXnq29KybEO5N4gXkGs346K/
         hSaTXQAjvhObPgs1IVWU7SqmW6uUv1m3kf9KLPv2IgXbupJTjToICFWZQwjogK0KYJwO
         KvukB+DyTZ18E/9qlHWl0o8d1oLfuGZOsAQPjHKqa7pRh9nr9W/vMNIidfXGU0L4NKHX
         stRumyDbrMuMqoQF346tnFqrgvzy0VMBACDjPM+FSaj81o+yU7N50wECW+6MhL9Q5jdx
         roqbzeSgWMWDzKtzTYdY7BxDYTcqXSiagFm43hAoS0PYcBo5PtnyQSr92i06PeYYRaoM
         CRLw==
X-Gm-Message-State: AOAM533NMZEHIY9D4sa4FgNvLm7v+OVNvuqkYwlDqkJHZx1xLdT0DiYn
        +Iv2+0CoY7gztoqO1iQa/p3gaHuHIm0zfX7Z5y8=
X-Google-Smtp-Source: ABdhPJzmCAOtDz+UuxP6PWhiyG+6fzRKXux3+EgPurp4BoC5M9RS/AFDw5yQUapIS1E3o7122IF4UpnHfA3HbFH+hww=
X-Received: by 2002:a05:6e02:b2a:: with SMTP id e10mr3838016ilu.151.1633621207286;
 Thu, 07 Oct 2021 08:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com> <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com> <YO13lSUdPfNGOnC3@kroah.com>
 <CANiq72=vs8-88h3Z+BON=qA4CZQ1pS1nggnCFHDEHYyG+Y+3JQ@mail.gmail.com> <YV67+vrn3MxpXABy@smile.fi.intel.com>
In-Reply-To: <YV67+vrn3MxpXABy@smile.fi.intel.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 7 Oct 2021 17:39:56 +0200
Message-ID: <CANiq72nKya4OW0Eof=7PP-U78uo+j8DL0UUDNsW3ww_5PPJVtA@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kunit-dev@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 11:21 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> It does almost 2% (steady) speedup. I will send a v2 with methodology
> and numbers of testing.

Thanks for taking the time to get the numbers!

Cheers,
Miguel
