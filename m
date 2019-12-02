Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2A710EA17
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 13:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfLBMbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 07:31:49 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34366 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfLBMbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 07:31:49 -0500
Received: by mail-ot1-f68.google.com with SMTP id a15so3417949otf.1;
        Mon, 02 Dec 2019 04:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y3/WupH4Qim+Jtfwvw0/dF9jXvDuuoGX3pS6ZZoAhNc=;
        b=hmC4OqRZ+m+B5/FRgP/NMzRMPu4Mjh7PYtMnrrmI1qYtQTH2MK8Zcd2Wbouq1p7THb
         xgEiLOQaSRHebooCs1CnxEK3jH/hphrMh+PH5MCcXHsiTsNeoIu/h3q+pt1ci0vpXIfL
         vpqpGGw5xSEizZKCzoyOlkDdT14+8Kaz1MFp3dU+AiHpdzt8AwquVfhJgT6BzGn6+PcV
         w4kK+3yqnnBhP2JDXWx/B14bttTGZiuUjAPhaLg6sD4sUWyKLc0SblXRYGENSt2CYvWC
         HHBp8FrHo1JR4rJGYCvXgKiOZMj5vbDHIQgOR3sOrH04D5z5G6U+dAlvv0LnWAH3IdfG
         SITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y3/WupH4Qim+Jtfwvw0/dF9jXvDuuoGX3pS6ZZoAhNc=;
        b=h9CUL9844PBA53fm7rq9eQoohFKdUJ0MJBWacVnymiJGxWB/bAEedgRPW1sq9/fM5N
         7K0ATC5IexwBCIeB7dbrbRTU8dlAu7WNb/wX2+FOI3d7x2zLRkzG7EpV5NcS9/oWNhiv
         m0Kfj0GpUFVRQQgN2BMY0djJciTv9GSy3ga4HPLdfZlw2l5ZmIBHqjGHzZuPvEFgehgt
         kucLFGdPMGT36YthCkcgFUfIYDZYOoi9k12xVQCwrkrU+eIaal0eiwyQ8tfbhK5pCVrP
         RpsUZHANHQG6YAvfVK6CygQbg5VxlsP55dcyO6fT6dLP5+hLWxN4ESkte8Q/YhTz+xsH
         2Waw==
X-Gm-Message-State: APjAAAVK3GpNhLCtILRr/KKXWfU6YZnsiB6d/WDAXlNlb9Mlg+MdiLtG
        U+9K5qsZMPL0ZrmDVr4MddFflgt756MRPnAzOXM=
X-Google-Smtp-Source: APXvYqxTm0A+XWPhMBVpIwSs2hPG256uQnaCVIMOXQrA/Xdlgh+WtKadWFIU2w8KQ9lXr84fmeAEfBzAssk9fnm8xZU=
X-Received: by 2002:a9d:3a37:: with SMTP id j52mr496572otc.39.1575289908085;
 Mon, 02 Dec 2019 04:31:48 -0800 (PST)
MIME-Version: 1.0
References: <1575021070-28873-1-git-send-email-magnus.karlsson@intel.com> <c15a81e1-252f-936c-26f0-f21e8165c622@mellanox.com>
In-Reply-To: <c15a81e1-252f-936c-26f0-f21e8165c622@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 2 Dec 2019 13:31:37 +0100
Message-ID: <CAJ8uoz1RAwLW+smZDOWd+oCvC0LRjRgZ7avx6hobZLTLNNoVfw@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: add missing memory barrier in xskq_has_addrs()
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 10:30 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> On 2019-11-29 11:51, Magnus Karlsson wrote:
> > The rings in AF_XDP between user space and kernel space have the
> > following semantics:
> >
> > producer                         consumer
> >
> > if (LOAD ->consumer) {           LOAD ->producer
> >                     (A)           smp_rmb()       (C)
> >     STORE $data                   LOAD $data
> >     smp_wmb()       (B)           smp_mb()        (D)
> >     STORE ->producer              STORE ->consumer
> > }
> >
> > The consumer function xskq_has_addrs() below loads the producer
> > pointer and updates the locally cached copy of it. However, it does
> > not issue the smp_rmb() operation required by the lockless ring. This
> > would have been ok had the function not updated the locally cached
> > copy, as that could not have resulted in new data being read from the
> > ring. But as it updates the local producer pointer, a subsequent peek
> > operation, such as xskq_peek_addr(), might load data from the ring
> > without issuing the required smp_rmb() memory barrier.
>
> Thanks for paying attention to it, but I don't think it can really
> happen. xskq_has_addrs only updates prod_tail, but xskq_peek_addr
> doesn't use prod_tail, it reads from cons_tail to cons_head, and every
> cons_head update has the necessary smp_rmb.

You are correct, it cannot happen. I am working on a 10 part patch set
that simplifies the rings and was staring blindly at that. In that
patch set it can happen since I only have two cached pointers instead
of four so there is a dependency, but not in the current code. I will
include this barrier in my patch set at the appropriate place. Thanks
for looking into this Maxim.

Please drop this patch.

/Magnus
