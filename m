Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE695BC68
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfGANKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:10:54 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39804 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGANKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 09:10:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so14518285qta.6;
        Mon, 01 Jul 2019 06:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hBqqOfAzGbzl/D2babDWeF0YoSFJC5IfACjSA3b99fU=;
        b=pnVdNCENtriillJ7LrCzscnOug9P3F8gawxi3YesIVadbIXX3OYkjMkYhkVjIThMB6
         9+gOpMJlUxfO0XGPHiT84pwW1yPO9LrhWJ9JfthJ7thu2Jb9aZ4N7Q269NM6vwBpzmwW
         vvsJKF8iV75UxBr05Zu9GnCcKPXIyOLCZSW/mww7KBKmyWYt6lt0UkPRRx2SRoh9G7DR
         37rUx1Z3f2Kr3NwKorztWUOpDQFoW7vUqI5ZoCqEuhhOXLDlRfs32aCdY1prSQwOXyi0
         XvZdH0xbi3xvXOvkDR2xnHl92Qab9qIQeFJci3609+uHGETuBpFGjOB6EB1T8onbgG26
         7rkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hBqqOfAzGbzl/D2babDWeF0YoSFJC5IfACjSA3b99fU=;
        b=HSdx8LUYa5y2NY+nCdSZ7aR34fygje352gSxzKJyrFmbhQNRDlsH75e+Y9SDECZ2HW
         VOCbU3Ln/2Z2Tga0Tr9Kt/RYoYIcIV7nhTL1h7gu8wDdZuhU+uNzDCO/yN2oEtc5D6Q8
         fDP3DyWYeonGkWCCLy9bWNw4rhQILF04YLzg6BoAbJoSfmeknwo2rMbi4qUlvLToBYEs
         xKhfaogZy7wyqLqtljhiPkP+PxxktulHxIdYuZCHv4sCQrbTvKnNZPvCqFyLgDlKLdtu
         dqivNitk1Qh2tzjVVD+0cO7Z5KxatTIo6WZfi+x063HHMaPXyYNT6yrW/Aewi5naC9xD
         IfOw==
X-Gm-Message-State: APjAAAXcesRXPbx8UeAhw0HgDDVTdCKBl/Cf5ldF3Uy7x8/eOessWmSW
        aOeBFPYXd9yk0oM/oM0t0XssebBe7xaEElmG17o=
X-Google-Smtp-Source: APXvYqyK/Igd9RHCvatr9CYk9ik99HwYaCQLpSv/aNdEylvKwl0yJjjS7gUOwpUrW9hY3ikB8CEfUGcRBAblbDVujxw=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr20820589qtn.107.1561986653046;
 Mon, 01 Jul 2019 06:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
 <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com> <20190629.105306.762888643756822083.davem@davemloft.net>
In-Reply-To: <20190629.105306.762888643756822083.davem@davemloft.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 1 Jul 2019 15:10:40 +0200
Message-ID: <CAJ+HfNi3+hu+D=nJOrtC_xVzE442BoYo4mXqT28rGPG83Dr_sw@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
To:     David Miller <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 at 19:53, David Miller <davem@davemloft.net> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Date: Wed, 26 Jun 2019 22:50:23 +0200
>
> > On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
> > <ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> Use kmap instead of page_address as it's not always in low memory.
> >>
> >
> > Ah, some 32-bit love. :-) Thanks for working on this!
> >
> > For future patches, please base AF_XDP patches on the bpf/bpf-next
> > tree instead of net/net-next.
> >
> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Alexei and Daniel, I'll let you guys take this one.
>
> Thanks.

Ivan, kbuild reported some build issues. Faulty, or not; Please have a
look at them.


Cheers,
Bj=C3=B6rn
