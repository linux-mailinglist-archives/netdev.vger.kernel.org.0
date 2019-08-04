Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA280B4F
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 16:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfHDO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 10:58:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37181 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDO6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 10:58:32 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so76515821eds.4;
        Sun, 04 Aug 2019 07:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vxyYB1Aq9u4CCTpYWtWmXj3GAEknEiHUBIBc1JvXqZs=;
        b=daW/hpWPxtNOzuktRo0A4gQ2yUzkZfbJxd9czvuxIjrNDZ3kewOTxxDAPEBAFgsVPV
         /QWn6AF2V/LZL81XZvo4dNgUw9gdpW2Ac8OJiWkOvGs+n7myp1OAd10W65/fj57g6t+k
         iGyBhtmahI2Hm/8TfMWlZwMgLp+KyirFR8CMK3TNkKR/8BOoH94yyZgpNElZXf9Cr3Sm
         IxqCh9oVzjdSWAq5/CxJ1In77rw3DMBUgXyysW8PuzjyRqRi4JMDqs6vnqfMU5a7lH9u
         bWn/jbBjMkWUpowsf4M2oIlItzynJ5N1mcyGCgZqQ7QqAkaSh8mEk5JxzJaJUB1nyRWM
         YSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vxyYB1Aq9u4CCTpYWtWmXj3GAEknEiHUBIBc1JvXqZs=;
        b=q9O6KDNeWTe+AwQM0PNmgM3VmtBDjgZwh63nNd5jBdi4gYg/bgQZCbkhmQ9kNrANfH
         Dq8+cxUahw8QXbuVgQMJHvOdEADIVn1qZl0RINSSx6oom2SDcJQuCopBGOmUJuBOdWFp
         jiRbZHt6R1oyUr+kPHkK6FXUdTXhgY+IQbMcddiY/u7+q36GbPh6Bkgsm3UCXvQezaid
         TmNOn/IGEh+n0sxBBZHhmuk4U0TUkcfGRu1wIlFnI5Z8EwScxt3EvxC40plK4yPJFgiV
         YvvDd+NNzDB2LP1cY8cwNNb5AfB4Cd4UEFhhItXXEn4XLptxzVcW6fxHYi1E3F5Pd3pJ
         mLDQ==
X-Gm-Message-State: APjAAAVMDF3SrxptUTkUnNI9+QOGl3nC1HCZ0BPsa0G9gXZCGut0cbIV
        3f+JT0QWrbk2CNPq7QEsCn5Mt2qtwTA50m030fs=
X-Google-Smtp-Source: APXvYqywB49X4tnVMViZN6HXtXvVriSKwTTDhggBaGXZNsT0us14HOf/K3OieJyZOvNn5qL0On4jmdoXasobBLWngAo=
X-Received: by 2002:a17:906:32c2:: with SMTP id k2mr21513931ejk.147.1564930710909;
 Sun, 04 Aug 2019 07:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190802121035.1315-1-hslester96@gmail.com> <20190804124820.GH4832@mtr-leonro.mtl.com>
In-Reply-To: <20190804124820.GH4832@mtr-leonro.mtl.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sun, 4 Aug 2019 22:58:19 +0800
Message-ID: <CANhBUQ0rMKHmh4ibktwRmVN6NU=HAjs-Q7PrF9yX5x5yOyOB2A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Use refcount_t for refcount
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 4, 2019 at 8:48 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Aug 02, 2019 at 08:10:35PM +0800, Chuhong Yuan wrote:
> > Reference counters are preferred to use refcount_t instead of
> > atomic_t.
> > This is because the implementation of refcount_t can prevent
> > overflows and detect possible use-after-free.
> >
> > First convert the refcount field to refcount_t in mlx5/driver.h.
> > Then convert the uses to refcount_() APIs.
>
> You can't do it, because you need to ensure that driver compiles and
> works between patches. By converting driver.h alone to refcount_t, you
> simply broke mlx5 driver.
>

It is my fault... I am not clear how to send patches which cross
several subsystems, so I sent them in series.
Maybe I should merge these patches together?


> NAK, to be clear.
>
> And please don't sent series of patches as standalone patches.
>

Due to the reason mentioned above, I sent them seperately.

> Thanks,
