Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F372C3B1B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgKYIbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 03:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgKYIbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 03:31:05 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A57C0613D4;
        Wed, 25 Nov 2020 00:31:05 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w4so1751011pgg.13;
        Wed, 25 Nov 2020 00:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7xGopky69OBXYiirtoLdMN6Zr9cEz2IQpL5ojSkxnM=;
        b=Xk6NMfOL3m5WhIAFhwkEIqOHkI16g7MRWX6o+UdNUxBLjRHs/n9n7viSWmiHsKSmA2
         zju2iLn/g6TfHUsdXJK61M4kCTYQMwvrc0twhq9HOJGQt5bqAJgHDiwF18UTmfp7JLBQ
         OBQOwMdsDKalNEdHzSzzgOqRPWT41e3F3IAX32kCSAj4X76q4iNV5HPmwe2+4TidUS3L
         86yIoIOZNg0n8T1zcBKXvBB/Ld4BeLLhCQfU2h5Dlu8PmPtzKA8vg/Vm4rjkF4u3WHzP
         Fjpjs8HL1UzixIJwP57/ZMEhEdkOCLl8JNv9dOMpAiGW2RC9zp85zSQPi+yIUD47gRdH
         ZS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7xGopky69OBXYiirtoLdMN6Zr9cEz2IQpL5ojSkxnM=;
        b=VVq81uZ0l7GfPzcKYg0sFtpl+QLQnxa/raNxhCqa/a+W+0EH8CuRBrArg8dhwfSP9z
         WMKTP1H4kP255HUeqFRJffff++zlCrnjjiYCHGBtarTNZk/3fJ5u8xEr1wcdN6VjLt2/
         DYpxaIUgO0VkwqTfqKMcogcXjMR0lBZi3R8GMizbMxHixWgZddONd8fVK0pQG01FdMIz
         9i9Gk74lqpYZroy4wPDnQKyAIdXoMFDbYYLNYRdni6l6r7pxhro3+2tHf4mJ2aOq2kTJ
         cINfTyEhqWOK6umQdMZ7uw/y19ZO29+aCqu+DnLthgWQNR1MxH9tXMJDwryivs/HUumu
         s0qA==
X-Gm-Message-State: AOAM53274/p+CzHsGavOSnvVBmdDrwPfDk8l0dxB4paQ43wzLT7eXdjC
        XN5JL5xVWMuYDjTjxCz+B3xNJEvJrSydI5lCX5k=
X-Google-Smtp-Source: ABdhPJweLpimAZFICk7o14nG9tAxizh24vU608v80QOUQtpP+fVDzRK5HR1hWu1fqCBKcZKXSSD2OTU/f7UsdxGjAGc=
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id
 r199-20020a622bd00000b029018adf0fdd61mr2168919pfr.19.1606293065179; Wed, 25
 Nov 2020 00:31:05 -0800 (PST)
MIME-Version: 1.0
References: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com> <fe9eeaa5-d40a-9be4-a96b-cdd80095da47@iogearbox.net>
In-Reply-To: <fe9eeaa5-d40a-9be4-a96b-cdd80095da47@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 09:30:53 +0100
Message-ID: <CAJ8uoz1JdmHc9nwa4cY20S-GN62RAJUEPGY4LcmdTM4FjuGTow@mail.gmail.com>
Subject: Re: [PATCH][V2] libbpf: add support for canceling cached_cons advance
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 10:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/24/20 9:12 AM, Magnus Karlsson wrote:
> > On Tue, Nov 24, 2020 at 8:33 AM Li RongQing <lirongqing@baidu.com> wrote:
> >>
> >> Add a new function for returning descriptors the user received
> >> after an xsk_ring_cons__peek call. After the application has
> >> gotten a number of descriptors from a ring, it might not be able
> >> to or want to process them all for various reasons. Therefore,
> >> it would be useful to have an interface for returning or
> >> cancelling a number of them so that they are returned to the ring.
> >>
> >> This patch adds a new function called xsk_ring_cons__cancel that
> >> performs this operation on nb descriptors counted from the end of
> >> the batch of descriptors that was received through the peek call.
> >>
> >> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> >> [ Magnus Karlsson: rewrote changelog ]
> >> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> >> ---
> >> diff with v1: fix the building, and rewrote changelog
> >>
> >>   tools/lib/bpf/xsk.h | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> >> index 1069c46364ff..1719a327e5f9 100644
> >> --- a/tools/lib/bpf/xsk.h
> >> +++ b/tools/lib/bpf/xsk.h
> >> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
> >>          return entries;
> >>   }
> >>
> >> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
> >> +                                        size_t nb)
> >> +{
> >> +       cons->cached_cons -= nb;
> >> +}
> >> +
> >>   static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
> >>   {
> >>          /* Make sure data has been read before indicating we are done
> >> --
> >> 2.17.3
> >
> > Thank you RongQing.
> >
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> @Magnus: shouldn't the xsk_ring_cons__cancel() nb type be '__u32 nb' instead?

All the other interfaces have size_t as the type for "nb". It is kind
of weird as a __u32 would have made more sense, but cannot actually
remember why I chose a size_t two years ago. But for consistency with
the other interfaces, let us keep it a size_t for now. I will do some
research around the reason.

> Thanks,
> Daniel
