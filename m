Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA81824C3
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgCKWYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:24:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36037 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgCKWYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:24:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id m33so2879522qtb.3;
        Wed, 11 Mar 2020 15:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bX2IVROdPZk+Lpen2b1LMA6hCikzQ/+KSNMeEM/lemU=;
        b=mjViEJFGfgqzw2ET4ZjoC3GUK5vU9lPehFAEPTK4bGaxgWcYn1kBeUtXxH7ShTFbKa
         VQHUM+KScwjH3T6mTdI3UvSz/FKpsxxCiiHHigMKGGt0gJcfrwkrzE1/6Q25PWDuKYNd
         xNBHiy93uLjZvcUWMK6Fz6hIjYYnBigsChgl9OY5WA0O8QySgeGFu3cYgWOE62r89RlN
         8vgMMnBa6XGqjThoByFGyX/n8mgHAWSRY9OefKgRn0DAY2VQWCiGVwwewdD7yhj4BRTN
         hl2uUSNdo95XucRp4xtnLdoh41YueUt5hXeSZ7tnoKNq5C4OOB8J/aHJ+6R+/kByD8hy
         SpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bX2IVROdPZk+Lpen2b1LMA6hCikzQ/+KSNMeEM/lemU=;
        b=n8xRDoOZ8XSCz/DrzS/AQjaMUO6tGr6kg7LhtZhpULCT1ZAS7WxJe9F+evuVfj1g+B
         Cepu1Hzhivifuq7ErmrVbnCGpJDmzMpi+VBZW8b+novwvvcwdWrPThW2B6I2uUEw1Z9x
         IqMvqm8+HcvVSyPm06ktT5GbUWNOmVjTwFKnPNPcjw42kLQzaLSUV563TqfkeezBplt4
         kwsZdYdeDvfeXzLh7YQRqr7H5Uix1yxfWlDRJlxhpbyAZ/kpVcqfQQZppWL7b/dG0bCs
         qGvEA5pqa4mslYEzlirr0RASpN9KNvNJMhYlW/049oLPirDnykXWK1U7xY4DhxQD4A6A
         RFfQ==
X-Gm-Message-State: ANhLgQ0ZH8151TNULlyGnilhhC17KMTzfUiNlg0PC6/CWDw6RuViInhR
        8AKrmpb9+JxI31pWqum0KvuqzQdhO+m/RkCOTzU=
X-Google-Smtp-Source: ADFU+vu3ISkN7+C3jkjPbaNNxvSE8GVRyX8L0IJ7Q7VkYTDfRiHcYaWwCcFw/lFdwzaYf7UFy/YQ+5uIylxnNslAs04=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr4488618qtk.93.1583965460396;
 Wed, 11 Mar 2020 15:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200311191513.3954203-1-andriin@fb.com> <20200311204106.GA2125642@mini-arch.hsd1.ca.comcast.net>
 <CAEf4BzZpL83aAhDWTyNoXtJp5W8S4Q_=+2_0UNeY=eb14hS8aQ@mail.gmail.com> <20200311221424.GB2125642@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20200311221424.GB2125642@mini-arch.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 15:24:09 -0700
Message-ID: <CAEf4BzbniQyBw2W=SR9gVh+7KHb9p6f6=45GUDBUXoP=59kxLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make tcp_rtt test more robust to failures
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 3:14 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 03/11, Andrii Nakryiko wrote:
> > On Wed, Mar 11, 2020 at 1:41 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 03/11, Andrii Nakryiko wrote:
> > > [..]
> > > > +     pthread_join(tid, &server_res);
> > > > +     CHECK_FAIL(IS_ERR(server_res));
> > >
> > > I wonder if we add (move) close(server_fd) before pthread_join(), can we
> > > fix this issue without using non-blocking socket? The accept() should
> > > return as soon as server_fd is closed so it's essentially your
> > > 'server_done'.
> >
> > That was my first attempt. Amazingly, closing listening socket FD
> > doesn't unblock accept()...
> Ugh :-(
>
> In this case, feel free to slap:
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>
> My only other (minor) suggestion was to add a small delay in the first
> loop:
>
>         while (!server_done) {
>                 accept()
>                 if (!err) {
>                         udelay(50) <--
>                         continue
>                 }
>         }
>
> But I suppose that shouldn't be that big of a deal..

It's actually bad, I'll fix it. Not sure how I missed that one... Thanks!
