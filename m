Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7148222B3BE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgGWQkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgGWQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:40:40 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3512C0619E7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 09:40:39 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 133so3160378ybu.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 09:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gMZVcJy5uwQT4vGlr1ERHcQqosY3c4kI9divmT2Lqpo=;
        b=gwjAdDF942fvpXcwvyR0uuIMKC72vX+1xaZmY+P/HlmQuhIFDMmqtrrmpEAYoODFls
         2whE4wMib2QcLaOVE4J+SdVBQ6P2JsY+v8YTFDd3JbEzache4FI5T4xBht2IkLXzQ/Sy
         1WIGux4f/lVv0pdf+puWJ2nV8J8wAU2lYqlJCRbXSl2WNeWZR9h1y1lVklRZc/KIqgKe
         Aj/ehWw+f2o0CsdkKfDY/zbJ5hlw20DhQPkwOJEN7mcdPxjJE6/p+eukZAHUXZngVbCf
         sdt5+ZH+ulKqsBPsP5u7/dtuM4Y4W/S7rVtNSNPkcxfWu5kl7dPPev0Qj6brKbcngU4o
         aoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gMZVcJy5uwQT4vGlr1ERHcQqosY3c4kI9divmT2Lqpo=;
        b=njgjpkQYaCc+7+FuTP6HmFlLvX440k7tN9zSMJYt7gMmS3GPZO5FEwT87KU6pJyjvr
         A5ulxR+ab83XCZ8KHbvnqked5YQF72jhnhc+JsuvLYRqLyWQRExH4VYJ6DJTC8E5ThRc
         VQA30rZVyV8u8xhylFEVnbbEgHBdEF7alQ+HIVyJpbNLOw76JNWyPw49MFM4i4a+iJ40
         jAGszhWrdEdFHcS4l0tmNX35EcOLSVuDPtkL/csarf9drNrNS9TOeEEq5m6uLRX+1tJ2
         WHLTwWxXR54+WpkuSYTOli2hr1YQgrf+QgYCy7q7Q2BVox63km902jn3SR2hg98cmC5f
         hS5g==
X-Gm-Message-State: AOAM530M2aQGBb37DF6rpLs2VjOqIGWNvc7SmeSlBkG18hTf6f1hI3ig
        gAF99n0rqe8Iykp+7u2vJnX+MUVkms/GuuQd5yePbFyV
X-Google-Smtp-Source: ABdhPJwjoH5EQjleheyC3y94ZN3qZdobs4/50/anePotqNf3BbB0YqTnucY8g4u2RzRMw5fRhYkM1LWDXZ+gqUBrIW0=
X-Received: by 2002:a25:a121:: with SMTP id z30mr8500302ybh.408.1595522438544;
 Thu, 23 Jul 2020 09:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-5-hch@lst.de>
In-Reply-To: <20200723060908.50081-5-hch@lst.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Jul 2020 09:40:27 -0700
Message-ID: <CANn89iJ3LKth-iWwh0+P3D3RqtDNv4AyXkkzhXr0oSEvE_JoRQ@mail.gmail.com>
Subject: Re: [PATCH 04/26] net: add a new sockptr_t type
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:09 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a uptr_t type that can hold a pointer to either a user or kernel
> memory region, and simply helpers to copy to and from it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/sockptr.h | 104 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 include/linux/sockptr.h
>
> diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> new file mode 100644
> index 00000000000000..700856e13ea0c4
> --- /dev/null
> +++ b/include/linux/sockptr.h
> @@ -0,0 +1,104 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2020 Christoph Hellwig.
> + *
> + * Support for "universal" pointers that can point to either kernel or userspace
> + * memory.
> + */
> +#ifndef _LINUX_SOCKPTR_H
> +#define _LINUX_SOCKPTR_H
> +
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +typedef struct {
> +       union {
> +               void            *kernel;
> +               void __user     *user;
> +       };
> +       bool            is_kernel : 1;
> +} sockptr_t;
>

I am not sure why you chose sockptr_t   for something that really seems generic.

Or is it really meant to be exclusive to setsockopt() and/or getsockopt() ?

If the first user of this had been futex code, we would have used
futexptr_t, I guess.
