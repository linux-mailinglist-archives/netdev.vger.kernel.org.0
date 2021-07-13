Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20413C70B2
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhGMMtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbhGMMtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:49:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67F3C0613DD;
        Tue, 13 Jul 2021 05:46:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 62so21550604pgf.1;
        Tue, 13 Jul 2021 05:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OSSm6vgQ/hSSbGft4asv3z9r3hlk04ITp8gGHFuDvJw=;
        b=O39QOghdBj2CErHDzCypebVvNfoixfpYts0+Kds4Ts4zA0Yh+shjkOTnx0g2yp7mIN
         gAW8vorFQtxLHvSPiqQVLIkfYfS3J32Rm/7zqaNd3W8YexLbuAKA0/1QuRfWMKFYyekv
         VPxl06BGV7KvPuaeq5qqPAKPFkE1xCRYPzl/Fi0z3kYLdS3aY41tN6AeaytCgX8CLlHc
         +VxTbEErb/axjLe8hMOsnQmzkYTCj3RFBaT7XVFqGs2WMXbcpFQYY/ts89D2GtvhMK7w
         E7311D/UuhrIXxgOoWXK4ytFyOoT0GBJVzpa1dUZXtw+emVEKXFBz1+3XdwOASmtsso5
         5r8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OSSm6vgQ/hSSbGft4asv3z9r3hlk04ITp8gGHFuDvJw=;
        b=ZhI/4/Lbd15yIdE6ntWlGwqDdlJ7tT5hWDPYS3VgB/pFtGviZxjmiaYwdDqFFdVnMl
         K2WiqXEfkQA7j8/wYa7+1AuDjj1CmoE268n+DWG7d5gISnS8D+jP0RjIgEuHpwRZvrEP
         tD9k1g3p9VnTsSuNNrzVTyq4SSc8etptjx8mLuKP1zQXdhBPucASkPbeooTxXY6rcaZ9
         Lp/Pc3E8LXWtca+5XpVsv1BR+vbODY2FwLLd46Kd8PbEv29hm5LsLuS+GbuEfkwTTbpY
         1u9bQKWjUsy6jZXZMSTdabBrpDWIpqPQc+XJdc4XNigSpDKHtce316uUKU+W+ua118zJ
         K7Tw==
X-Gm-Message-State: AOAM532fWKQ4hd71NKc+IbBglCxgHb41LHH/t4+LJP5R/QF6FAYdIVhV
        OxEQjAPTHNhQqj5t4Sf+c80mnsog1krinu0ZxiU=
X-Google-Smtp-Source: ABdhPJx/eA7qttUtbxpBlfH2rmDd3YHt9oPD7s1U8eIfqlDXzmWYLqbH+5Zu/3++zSAoGtFtVxI3MqkvwM4efGpLntE=
X-Received: by 2002:aa7:8055:0:b029:303:36a6:fec7 with SMTP id
 y21-20020aa780550000b029030336a6fec7mr4670949pfm.40.1626180390255; Tue, 13
 Jul 2021 05:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com> <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com> <YO13lSUdPfNGOnC3@kroah.com> <20210713121944.GA24157@gondor.apana.org.au>
In-Reply-To: <20210713121944.GA24157@gondor.apana.org.au>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 13 Jul 2021 15:45:51 +0300
Message-ID: <CAHp75VfGd6VYyCjbqxO91B4RyyYuNQd_XKJA=yLMWJpa7-Yi9Q@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Tue, Jul 13, 2021 at 3:21 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jul 13, 2021 at 01:23:01PM +0200, Greg Kroah-Hartman wrote:
> >
> > Life is messy and can not easily be partitioned into tiny pieces.  That
> > way usually ends up being even messier in the end...
>
> One advantage is less chance of header loops which very often
> involve kernel.h and one of the most common reasons for other
> header files to include kernel.h is to access container_of.

Thanks, yes, that's also one important point.

> However, I don't see much point in touching *.c files that include
> kernel.h.

The whole idea came when discussing drivers, esp. IIO ones. They often
are using ARRAY_SIZE() + container_of(). kernel.h is a big overkill
there.

-- 
With Best Regards,
Andy Shevchenko
