Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCF439A3BD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhFCO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:57:49 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:35630 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhFCO5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 10:57:48 -0400
Received: by mail-lj1-f174.google.com with SMTP id f12so7543142ljp.2;
        Thu, 03 Jun 2021 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Kiko3L3YjBWEhvM4Ti4rKrt2P5mZ6fCG/By0wjAa4Q=;
        b=MVrneGet/nqEnoMMZxopNrxZTonEFpoYm29aeZMcMMpzVM2GUdlcPj714sjtbYVkXR
         q2hW9lSdI/GeLseQ3OabJgVpDCFyPo9BuZrjTWvn5x3YslPuAz60bK7Bzkh2Gx+EKc84
         UkEkh1+VylhVyTAsMAG1dN/G7jsx8OPY1RoOAVmmHsRgLprmax8YezT3feub4k8PrMyD
         zSc6J4SpzrLo1EMwTKaf0MxoyJRgK5VBdk//yamNcwInw6l0w0hnY0FsiWxfMOrEzkZu
         amaSXKXhZqnzqrz1GrhzET+iZ9Ceqn7qnHr3Z644wiavDdv3nxBngiB+wp5vqrKTADMQ
         id7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Kiko3L3YjBWEhvM4Ti4rKrt2P5mZ6fCG/By0wjAa4Q=;
        b=WZdBMwMfqKoIHJYhSVqfKKffbOkv2J6RPv/sCaDkTyS2tZ5FuQA0giLTE3XAAE6Ew7
         93FaNGm+Sx9ck7Yc7V63yPOAuutLt9D6wRp9HJayEa8N1RRgPjbgGG/IGwTXo/AyK6zd
         7N3neQ/U10cFFLv0nmvZOcJK4FE+p2QCgvqVjFcBdLmHlEz/RPKh19u5RryvMarHm0tt
         rTDPHSYodQgkCA7Ug0fG9rMTAgSLSbLpf8y31Mxqo8Zg+kE2EoWFmi0+MqKo5xSvb3cw
         6zdtqpyRKdA3lvN7+dSJxnyH39/pz4lYFQfKbT1GPV/qC2JXib4grAZGmycW0XJhycFa
         Y1ng==
X-Gm-Message-State: AOAM530ClA+4s/WM9Xrb6CdMopS9tFD5hqrXcv0I5gQf1SnOVy/WWccA
        XVuILuBrFVU9RyqTckQphUXdhB6jdu2g5xSIrP8=
X-Google-Smtp-Source: ABdhPJyDDETY1hXTK9F05ZyM7XgRUkdPujkYgGYZQ+pXnYoAh1vdSETh5bk8gt+Pl0NCTZdlixHRP5xDwe02yfoZTJc=
X-Received: by 2002:a2e:7f16:: with SMTP id a22mr30102142ljd.360.1622732089443;
 Thu, 03 Jun 2021 07:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CADxym3baupJJ7Q9otxtoQ-DH5e-J2isg-LZj2CsOqRPo70AL4A@mail.gmail.com>
 <e91baaba-e00a-4b16-0787-e9460dacfbb9@redhat.com> <CADxym3ZdyqJ7b_PqdcjbNhKWP7_nsPRQ9Q0TtFC6Qzr75ekK+g@mail.gmail.com>
 <85310a8b-35ab-376d-ca87-7487b97232c8@redhat.com>
In-Reply-To: <85310a8b-35ab-376d-ca87-7487b97232c8@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 3 Jun 2021 22:54:38 +0800
Message-ID: <CADxym3Yrce-81kjMxg-K8BV4TuTSzxW6gz7wORa4YGAsH3Y8-Q@mail.gmail.com>
Subject: Re: The value of FB_MTU eats two pages
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 9:08 PM Jon Maloy <jmaloy@redhat.com> wrote:
>
[...]
> Yes, I think that makes sense. I was always aware of the "fragility" of
> my approach, -this one looks more future safe.
>

Ok, I will post a patch.

Menglong Dong
