Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D5861D951
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 11:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKEKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKEKLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 06:11:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543561CB16;
        Sat,  5 Nov 2022 03:11:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so10333519pjc.3;
        Sat, 05 Nov 2022 03:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AnnGCrt5RbgHj8ZQA5nS741HGDNZdNXSMfYQ5sBboqs=;
        b=jQcm7u3oj5HYs/1R8mHFbz4i6zWvv3cQB9QwRpNBuh2FqrgZffT7WafCmWJj2OBUoq
         WnQKTchdC00n0zVD9OyMVHGbqreKRdjpnI5LuxolLZY7rTuGRlBVH9u4DHfw13tUnjsi
         GpYR0FMco3J10hSE/bTkT4SMCuEJvy4/PgmJwSMXPNbTyQqw8iRfTQRhfWn4xUYjHEmx
         kCGPKlVimXK9WQv94Q8YkJwF5W6tYlay+/Vp5qSpwCpsgxuSMfUVH4xA8N9MLkU6ZNwS
         wOtb9O/NQ39dTgI6J9GEemJDbhAF8yVdD7Dh6RHnuOXuQgB18tjQkFW0wiz8cQLKnS7D
         BuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AnnGCrt5RbgHj8ZQA5nS741HGDNZdNXSMfYQ5sBboqs=;
        b=OCJP7fYi5xdReJPjjxuBAknfUxKRjAqOQjG1RK7GHaEPnnAPI/GxUvhU9Uv/pOX9rk
         l2wt3Mm1bj1cxwRbTdEXu5vwNt2V327c/7zGUd2LX74Ngz1+E5/vMCiUyEWzLdpD+fw/
         rOfAGuhK99heFfL/qu+D+AV7lTi1sS23/dkY4XN8FDI5v0USxOCBb1NQTlbtv4/jrcOb
         /o0hDypQeeLyYvSPF3VJJDIbmgklw6lxqiqZJPCGbvpE+xvkpmqvcdb/Oo8hqQR0qkuz
         baLrjrKqpvJBlzc80Zk00EDS0RlMY6pzKR5wwwTF0tyBDJjG31K1Vt0yaaAHq1vlVcKe
         PDsw==
X-Gm-Message-State: ACrzQf0g0TMxVAAUc2W2TJPP2GvdkuzMBz3hGTQcJ22MmJ+fXjjKl9oW
        x5h3dZrBQPKe+UuG+osUm49ya2wyXxVBwJGs3j8=
X-Google-Smtp-Source: AMsMyM4QQYZiZWQhJsEOrJc5NW4GFb7wBCjHwuCqJNgGQUh9xaBeJIEhKXVCOPrlvOBW/WI1HK7NDJLLqNoMRdLfXds=
X-Received: by 2002:a17:903:185:b0:187:2430:d39e with SMTP id
 z5-20020a170903018500b001872430d39emr30430740plg.65.1667643097969; Sat, 05
 Nov 2022 03:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
 <20221104172421.8271-2-Harald.Mommer@opensynergy.com> <CAMZ6Rq+Gj0xzrsT6VJANv5k3-BgsONSqA7snNMAbpxpbybA9-A@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+Gj0xzrsT6VJANv5k3-BgsONSqA7snNMAbpxpbybA9-A@mail.gmail.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 5 Nov 2022 19:11:26 +0900
Message-ID: <CAMZ6RqK1g5GKTZWQA_BpLNq5uR29sBUwAr0VQCCqkGwW9SV75g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] can: virtio: Initial virtio CAN driver.
To:     Harald Mommer <Harald.Mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 5 Nov. 2022 at 18:11, Vincent Mailhol <vincent.mailhol@gmail.com> wrote:
> On Sat. 5 Nov. 2022 at 02:29, Harald Mommer <Harald.Mommer@opensynergy.com> wrote:
> > +/* CAN flags to determine type of CAN Id */
> > +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000u
> > +#define VIRTIO_CAN_FLAGS_FD             0x4000u
> > +#define VIRTIO_CAN_FLAGS_RTR            0x2000u
>
> I recommend the use of the BIT() macro to declare flags.

I just remembered that the BIT() macro is not meant to be used for
UAPI. Please ignore this particular comment.

> Please order those in ascending order.
> Also, what is the reason to start from BIT(9) (0x200)?

[...]
