Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B06B52ED
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCJVir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjCJVio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:38:44 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429CDCC20;
        Fri, 10 Mar 2023 13:38:43 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id x3so25969436edb.10;
        Fri, 10 Mar 2023 13:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678484322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+T3X20snXTbkBcSvSdaoVOnFGTG4Yh38ZDxO6+oPVD8=;
        b=Mh0WbNCxUr5hDLadagRRxkR3X7em5HUeCfkrDidWZHCJgxWAHGhE42PpDZQjBolHo3
         J4YywM10whrh57paLpGMfEbxbrGwgXdK4pMbWCOLHmnXw0bryF3Qu4csaXx69dlPH+HR
         Dg5Wj4hZP93c0Y0EgFqDq0RxD9QDrSJ6zOzsfXuj1R77lxP04tmKf6y7lsvcH528wjv4
         QAA7CDbSUtw4r9UmzmNvqq9+H1+qUMmkeI+Zy9FDNnhPjiLSUm+dBmCoQUS6pYEDx6FG
         2vlW1xIxbFqGPDVBulseYxgmHO0DyYAMUoP97FDK/+vhlxJbcG8UdMOHQlOZH+oZIsz6
         LMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+T3X20snXTbkBcSvSdaoVOnFGTG4Yh38ZDxO6+oPVD8=;
        b=5z+KxkDx7i/PT8COOyLHAL4iWtJNT+g3A6qyq5S0t7ofCIZBb5JZ5TZELZTzq7wQ61
         HdmXpr9YVT8uPxBd5gz7vLCJDo8yPYy6OjQHb42nq2WQgR7KrBEf7aN4jwg7tnIq7G1X
         /CpMDkuAXl4xO/9GxHI0qIeGcY3xuxtZaGvBgtTpxS0MCTqwdU4la9T1qUTGgYSQXJ/3
         +JNDZnL/qRqCN3ekj3Z2FfXn37YO6xhOmqZVhiqwZDyXzPdTuRfF+WlBJFygHhTMuIhX
         xxsUBthCqYhnFjWA8jzF044y2D41x0vq/J+PNXZeIaSqYvizWWyakLqHvBzgnqqmQWFN
         q5GA==
X-Gm-Message-State: AO0yUKW83UQmhFMdFz5a1EVXZfL2BkbX8YOmgDwe3OgLOvVUO9Bt58h7
        uYHh0BO81zrk9aUs8jl9/Up4WSwgdDkMwQ==
X-Google-Smtp-Source: AK7set+I1e9Wd7mibFs8QwzzA0r28kPxnReCJyX70b+DHFQ6X1MzlwDo2HTH7FgB+SP9RsCZOjmHQQ==
X-Received: by 2002:a17:906:b099:b0:8b1:fc1a:7d19 with SMTP id x25-20020a170906b09900b008b1fc1a7d19mr23761629ejy.3.1678484321543;
        Fri, 10 Mar 2023 13:38:41 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id s24-20020a170906bc5800b008ba365e7e59sm317642ejv.121.2023.03.10.13.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:38:41 -0800 (PST)
Date:   Fri, 10 Mar 2023 22:38:39 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230310213839.zsiz7sky7q3zmjcp@apollo>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com>
 <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo>
 <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo>
 <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:15:41PM CET, Alexei Starovoitov wrote:
> On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > >
> > > > > I agree this is simpler, but I'm not sure it will work properly. Verifier won't
> > > > > know when the lifetime of the buffer ends, so if we disallow spills until its
> > > > > written over it's going to be a pain for users.
> > > > >
> > > > > Something like:
> > > > >
> > > > > for (...) {
> > > > >         char buf[64];
> > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > >         ...
> > > > > }
> > > > >
> > > > > .. and then compiler decides to spill something where buf was located on stack
> > > > > outside the for loop. The verifier can't know when buf goes out of scope to
> > > > > unpoison the slots.
> > > >
> > > > You're saying the "verifier doesn't know when buf ...".
> > > > The same applies to the compiler. It has no visibility
> > > > into what bpf_dynptr_slice_rdwr is doing.
> > >
> > > That is true, it can't assume anything about the side effects. But I am talking
> > > about the point in the program when the buffer object no longer lives. Use of
> > > the escaped pointer to such an object any longer is UB. The compiler is well
> > > within its rights to reuse its stack storage at that point, including for
> > > spilling registers. Which is why "outside the for loop" in my earlier reply.
> > >
> > > > So it never spills into a declared C array
> > > > as I tried to explain in the previous reply.
> > > > Spill/fill slots are always invisible to C.
> > > > (unless of course you do pointer arithmetic asm style)
> > >
> > > When the declared array's lifetime ends, it can.
> > > https://godbolt.org/z/Ez7v4xfnv
> > >
> > > The 2nd call to bar as part of unrolled loop happens with fp-8, then it calls
> > > baz, spills r0 to fp-8, and calls bar again with fp-8.
>
> Right. If user writes such program and does explicit store of spillable
> pointer into a stack.
> I was talking about compiler generated spill/fill and I still believe
> that compiler will not be reusing variable's stack memory for them.
>

But that example on godbolt is about the _compiler_ doing spill into a
variable's stack memory, once it is dead. There is no explicit store to spill
from the user happening there.

Maybe buffer in explicit program scope {} is not that common, but always_inline
functions will have a similar effect, since they introduce a scope out of which
poisoned buffer's storage can be reused.

> [...]
