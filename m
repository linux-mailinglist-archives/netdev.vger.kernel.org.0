Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C79132488
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 12:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgAGLK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 06:10:56 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42247 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgAGLKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 06:10:55 -0500
Received: by mail-qk1-f194.google.com with SMTP id z14so40990163qkg.9;
        Tue, 07 Jan 2020 03:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LVBBfMH6pYaLqf4yYGX0Dv8Vt871LszKjSjUOY6Uw/4=;
        b=l8SyAsazPlptluoPonbBtnfO4NXpBvXC9rmFcQAWaGoRMEJgc2waciKeb8luqUKK3t
         gC7BpSsowLQ7iqqdzLnvMU+Lfv4lZgI23wASK+mVv9wv2XzZZK5YZU9KoagE5yzYrKtj
         CMUmnzKoMpKo/RKbLKXpbeFMLR7TGt//3bYUj6CgduRRJo3pXAzdsze6kKwoz1gKZPb1
         ZBe5lgklzZf++YsF9d6zhipazBGEydB+qIg/8yA4vtTH0RV3VJGHwSLcd1GmweoWeyFE
         Vn6btW1+XZxum+HKIg2C8ZnjwktbJkqoXI0Qy5QmaJKFmevY+OC57R/PgUE7/NpURsao
         Uqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LVBBfMH6pYaLqf4yYGX0Dv8Vt871LszKjSjUOY6Uw/4=;
        b=BY/lmW8uzRREuOeIH6z3T2AYZfdSVkPrkFnVqv/R5gjTs6L+XCGaMLx0NbypAeCss8
         OzOHDwUK6lqJt1bbJlWrFSFOEZ9MBgTPE0D+epwR6R0oqwgVOOw9oOM57HdKUmOB7dy9
         OQHLB0fdcblB8rLKXC+3lqS7F+Y3HIDiwqsxnnPNequtlXDflZVTtx1G/buD4v29ShXN
         sPamUHTMs6YZfzPBxaf23X6KJ6LdZ7m73f+SnO4DzFEvZLtNHLqwOZKy6ZzXKZzyebvt
         kem5nxGoNLbsj+dJaCrRnRVXd9dpne1aNpppYi4m22+6BrHY4NjjOQpEjpuBsuV/mFMn
         gxEw==
X-Gm-Message-State: APjAAAU8OtO7nVh8haq4utf74IClZIRAVkyuAyUcsBhGY+qzHweEgluu
        bnwgwd0Nmuvig23jMncHnhYqt899VxsP3d6m1gGu4s7G
X-Google-Smtp-Source: APXvYqy/YV4XqVhAJbEc6tWA6nMWEIpoOyUomKJ2MAtIXVl7B9Sbo/XMpQ/bZ7TUxdVX/Up/1eYApW2GEONUoLj/R4g=
X-Received: by 2002:a05:620a:14a4:: with SMTP id x4mr86611772qkj.493.1578395454804;
 Tue, 07 Jan 2020 03:10:54 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
 <20191220084651.6dacb941@carbon> <20191220102615.45fe022d@carbon> <87mubn2st4.fsf@toke.dk>
In-Reply-To: <87mubn2st4.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Jan 2020 12:10:43 +0100
Message-ID: <CAJ+HfNhLDi1MJAughKFCVUjSvdOfPUcbvO9=RXmXQBS6Q3mv3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019 at 11:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>
[...]
> > I have now went over the entire patchset, and everything look perfect,
> > I will go as far as saying it is brilliant.  We previously had the
> > issue, that using different redirect maps in a BPF-prog would cause the
> > bulking effect to be reduced, as map_to_flush cause previous map to get
> > flushed. This is now solved :-)
>
> Another thing that occurred to me while thinking about this: Now that we
> have a single flush list, is there any reason we couldn't move the
> devmap xdp_bulk_queue into struct net_device? That way it could also be
> used for the non-map variant of bpf_redirect()?
>

Indeed! (At least I don't see any blockers...)
