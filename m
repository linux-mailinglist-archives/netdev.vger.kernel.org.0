Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B991C34D8F7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhC2UTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhC2USc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:18:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E201CC061574;
        Mon, 29 Mar 2021 13:18:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j25so10622884pfe.2;
        Mon, 29 Mar 2021 13:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWbAtqchcbLb5oDUoEL+XwBoKafnvSXklPKlf/DyzV0=;
        b=MCJ2tQF+Q7xaPMi3yGBMb53Mz+Uk4YvobS6WbLycmk5x8wwhodKC9mQi/fNoXjg5SJ
         fTY51z5Rbv6DYK24kYMPNQeRprw8SqoxPqUQIS6mQo2D55PfRd48aOwvKWu4G4l1nFCT
         QLWgBXk6utF1oOqylx6JnifLQu0uVIrNhShe6gyLBbMJF2EXDlBFjeOOurPTlKAHQTJP
         3ekE/i/3Ih8ZEP+JBSAAkUcwliTikgymRfQrGRrRBqUDlEETJUaH+gQAXTo/AYwqhEJF
         GkLTt0NiOVz7PrR+8J+O9Ua/GcFe/faIN/zxF+XnyBI4AGbGM0TlgnhV4ztzJdL8mYA3
         ww9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWbAtqchcbLb5oDUoEL+XwBoKafnvSXklPKlf/DyzV0=;
        b=ueLXKZGjjN5thcygq1GpC9BHajnhNHut/LpgT3+hLqLddZNpN3hy29MGlLCPybN8V2
         SEF7qbqGtdbpyhwCY5zhp/DXDew4YWO1NUnaZJMqyLTacqf0268KmuwVmy5yF5I3KZbv
         G3M+X58FpAAc+x4ldawgQy9TbxvN7+vJy/xx7RZN+1mQ4wR0QhYvxQxx7rLzzMhz33f4
         rNSVFParvStBjJpJ6Os5cDyqi7EI7PvqagQpTUXciVlie7KNvwRv+bwGVUUZ7Fmg72Y/
         xEOK8m9IS7fnEXq8/YhTk83GZpA9y72eMuZPfzcRfmbD9I3T7pEcyFPgglqgshX15OXk
         szPQ==
X-Gm-Message-State: AOAM5302Q33xuFJYTZ/R3bv9Ao2wVrGae5pBh/vdHdF1oxiVrUTMTDAg
        8BZRAgU3mncDQv3kh1DUNa9q18FJ76wDYU9hKXMSnA9+OLm+DQ==
X-Google-Smtp-Source: ABdhPJx6FsEr7dHz8sVsJ+GO+sqdgq0Rc3aDSKYuDQ9mwcECzzpHmJIN1r9PzU2LEOiCtDwxr+lqGxr39VilLdQwcS8=
X-Received: by 2002:aa7:99c6:0:b029:1f5:c49d:dce7 with SMTP id
 v6-20020aa799c60000b02901f5c49ddce7mr26182634pfi.78.1617049111326; Mon, 29
 Mar 2021 13:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com> <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 13:18:20 -0700
Message-ID: <CAM_iQpUmkb9cbyWKcerQcJJAyGLzgtDus643FL1cyQL3FzTrfg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 6:24 PM Martin KaFai Lau <kafai@fb.com> wrote:
> Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> is not set?

On my side, with pahole==1.17, changing CONFIG_DYNAMIC_FTRACE
makes no difference. With pahole==1.20, CONFIG_DYNAMIC_FTRACE=y
makes it gone, but CONFIG_DYNAMIC_FTRACE=n not.

Thanks.
