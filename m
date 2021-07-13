Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4E3C7689
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhGMSm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhGMSmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 14:42:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D84C0613DD;
        Tue, 13 Jul 2021 11:39:33 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z11so6723450iow.0;
        Tue, 13 Jul 2021 11:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dvhTzTGuwGaxvYP49OCa62HCoxmtDuXHty07kjzc4tQ=;
        b=p6lH0Pf9OmSWBFQl92qBpyl7xdKbccrbq7NjhAgHC62ORJ3ULLCws7qTa69osGy8iu
         s/K9I8Olglp/uwNswevPsbwUoNKYGTVFwQ+BbwK5YiQLlybmy/HbOb+XM63SYyINJfoh
         vXPWhKbLoGArVyOXDMl+JEjtzN2zz32Tb6pEdD/Tz6JhE1kbmLFysAK346kieRxVHq7D
         9gksqPeVhIfxmvr22kO529va1RrB8yYhQU1ia2PpHj+q5kEmdAiBWCmLNU7hzm7QJZBZ
         645Oyk+6vnYwhZfydXCzUMjRrM1DbqfO1IakvrKXyR76lPNF5ttk2Rz7bLRJyLZh5ICI
         Elfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dvhTzTGuwGaxvYP49OCa62HCoxmtDuXHty07kjzc4tQ=;
        b=psIPaC5HMH+bO4rfXClXinEbSVeeRPhtNblbG0+AUzsHmITwOk5a3pJwl+YrPJXwmE
         qn7FKoocU6VnFkbqoX1TGSkvzO0OB5PiHGFcjLcEVCSnAUWPGxXeG+GVVGUhK3FDk6ep
         Wj280F1v/HWm5L89ZPVjNoe1+SmkOiYMQ9iRSHL3/x1JCIS3+txHRDAh8ebecDlSNVDA
         pUne4TE9kGk1tVws9hzn+Zrc0W9lAMJyuEZjljrrUDAvVuKv1vgqDsZtsnTtcuzQtnAA
         /JEemOVjxc2+MJL0mT9H2auzNLHB7NrxCfX4RWoBmRgA7ACdOlpPQPG5bivoZ4UbxX7B
         YRbw==
X-Gm-Message-State: AOAM530AWa6hI+73szbKsC1MfqVKGhqKKdchlLoWEJBqdX4SJ29Lc3tG
        jBQC35IyxIBgwE0zYIRTm9Z5q0D2x7LG6lE0UuU=
X-Google-Smtp-Source: ABdhPJwpTjUp3UniqBaKrgdpc+yOJB6FaS6hkA5OBwgCiueGrCrCf7PVlzeQETyowNt2XoKgBr9TdfK/YQqEyQIzWmA=
X-Received: by 2002:a02:2b21:: with SMTP id h33mr5075656jaa.31.1626201573037;
 Tue, 13 Jul 2021 11:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com> <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com> <YO13lSUdPfNGOnC3@kroah.com>
In-Reply-To: <YO13lSUdPfNGOnC3@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 13 Jul 2021 20:39:22 +0200
Message-ID: <CANiq72=vs8-88h3Z+BON=qA4CZQ1pS1nggnCFHDEHYyG+Y+3JQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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

On Tue, Jul 13, 2021 at 1:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Life is messy and can not easily be partitioned into tiny pieces.  That
> way usually ends up being even messier in the end...

I agree measurements would be ideal.

Having said that, even if it makes no performance difference, I think
it is reasonable to split things (within reason) and makes a bunch of
other things easier, plus sometimes one can enforce particular
conventions in the separate header (like I did when introducing
`compiler_attributes.h`).

Cheers,
Miguel
