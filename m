Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233148F598
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbfHOUQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:16:46 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:44141 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOUQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 16:16:46 -0400
Received: by mail-qt1-f173.google.com with SMTP id 44so3671232qtg.11;
        Thu, 15 Aug 2019 13:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7KRPwJULNqRo6IzIC4npJ99jz76FoEXrOgj5D0TU8bk=;
        b=PBrPCafUUXdBgtBzuQ+kIjJ1IM3yqR+ueS+ncvaazBBTkEKSeyVTLmkoCMw6WmfTmb
         ah7drTBJYxwiuQVcue3hOQC4JsncaKfA2JHeyGk3tNQ8+UqKZXTYIYihq8MoHNzvBJC8
         Ftwr4t+ZoodrgnDQ9C2UidnrdVUyUazd6BSyR3Tv+8WXXPH4Ri40/M8qk1zX7WqtDvBZ
         KIExAb0oHMv7JiXbLscBZoVUSow0NCcxgfdazPnG3fC1H/9vKRKAv8mN4mTv1wuShySR
         DOKwSnqxtQNuWdpZ6Jo3XGZeZKFvjiJt36De1HXHaxayJgbnKhxZZ8l2kTA+dTx85Dpv
         aD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7KRPwJULNqRo6IzIC4npJ99jz76FoEXrOgj5D0TU8bk=;
        b=n6vGxahmcma8HHuuQXmfFrFiMPSixsr9bp3oPO0gb/fz3lqL0QbXnLIsO/O+NsMY0x
         mZdTHDENLRJ8vpVFOEAXPjvzPs7pwzkA22m1ewuq3sEINj/SerzN5wWicEUisTFMme06
         6YCAQubFtKQ4LZUVb5xgBrLSa09M5AYNGfog6ZC7GOlGDE1p6MPOya5JaHE+bIL+Uai/
         1yCgaYrZuaYonwujV6kVzXlvRNjcerNfJZsVn4JKDHY13LLFPB2XqMl2/y58kIpmv7EF
         H8ErvksRPiVk+K+APNgYC8zaxRidQx8eH47LvjHF2GzlKgkh6MoAkb/bjxR3hYInfiSZ
         Otww==
X-Gm-Message-State: APjAAAXKWSJuz9sxO9YsTokBJhArPADkaqik8ySOUKIBV5hXQ6PPyYWA
        N+hFmRPa1P2h2LJfpG7Vy6ejuV4d3kKNKgpeKwLwVG5Hl+z5pQ==
X-Google-Smtp-Source: APXvYqx3Qbr72U7R2/nBNOwPfWyZERng1bgg0cBzJ5TaX2uRmGv3EGFj9lnmH1A8aW0/tQbqfnounvVqgHnyR1Za+d8=
X-Received: by 2002:ac8:43d1:: with SMTP id w17mr4020208qtn.171.1565900204855;
 Thu, 15 Aug 2019 13:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142223.2203-1-quentin.monnet@netronome.com>
 <CAEf4BzbL3K5XWSyY6BxrVeF3+3qomsYbXh67yzjyy7ApsosVBw@mail.gmail.com>
 <20190815103023.0bd2c210@cakuba.netronome.com> <CAEf4BzYL-pJ79nKywsAH1b2S-EP_4SUZY5jS2wzYJ32pywsyrw@mail.gmail.com>
 <20190815110917.657de4e3@cakuba.netronome.com>
In-Reply-To: <20190815110917.657de4e3@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 13:16:33 -0700
Message-ID: <CAEf4Bza4W11KQKdUocJA-KoyQHbDimSLnKUJ6RajrkBJ-kB2Pg@mail.gmail.com>
Subject: Re: [PATCH bpf] tools: bpftool: close prog FD before exit on showing
 a single program
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:09 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 15 Aug 2019 11:05:16 -0700, Andrii Nakryiko wrote:
> > > > Would it be better to make show_prog(fd) close provided fd instead or
> > > > is it used in some other context where FD should live longer (I
> > > > haven't checked, sorry)?
> > >
> > > I think it used to close that's how the bug crept in. Other than the bug
> > > it's fine the way it is.
> >
> > So are you saying that show_prog() should or should not close FD?
>
> Yup, it we'd have to rename it to indicate it closes the fd, and it's
> only called in two places. Not worth the churn.

OK, I'm fine with that.

Acked-by: Andrii Nakryiko <andriin@fb.com>
