Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FD77FC37
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394931AbfHBO1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:27:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40506 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbfHBO1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:27:54 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so72525233eds.7;
        Fri, 02 Aug 2019 07:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C9LPjwmpCbhIG9fa404OYjDh216Z1i9HjOGON92MWYk=;
        b=Iqz2OamAaYolMP2nQ42QOA+OqHFEvmp+/aHWq5wTA0vcNcHZzeEc0ykVqbJfNgQYbQ
         wHFuVsEDpuuPoeNMnJJcaAaYj2y43eyKCNk3NkxakxTXkwzNzp1hKPTDZX1JjICdNQPd
         GS9QwXTdV92L8zl/BcOHze2ejPClmNiknhHIqDYNQZGQzKF+e5TxQoWvQNirqTIZW+wH
         P20M2Tvxuc5JCJ+H5KsXYIhJZ7icjDGLzc16jOeYzOu3RWJBAWqY506d5i3gxsGh3GfZ
         /zUowVXzWV4SiT894PKjJovd8YteDxA9COu/P10KC7n4J2efS94S27kvA82fhxX0tGYU
         /CRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C9LPjwmpCbhIG9fa404OYjDh216Z1i9HjOGON92MWYk=;
        b=Yshgt4rROfcAH8OvwuCqR3mqY0/FEJDhUnnY0JHd4Jlhjh5LEDavqeAkf+Mj2+tj0I
         UMFjN5tD58BpvcKqIw1SH7rUpTldH+ugAnpjaOILj6YMRyPDmd3k2/LeOc96lWqQ1PGe
         k07VAg3fHILZKIUcF8GVEtc1gPlJcF/Zs52Nu0wDI/XZiDR2rOZqFnGWn+RQl1wQmqQA
         v69XeyKGZhn5OY5bjNhLzMnUNXdiF3wFj3vW2P6q9FgMD8gD2+ZvKzza+Ig2zfNpdJAy
         Mcuty2vdZ3S63Vfrxlob51roQY1kuX3tN9y8O1A6U064XbfOE2ySuHl5/MVpwXavgUTN
         sCVw==
X-Gm-Message-State: APjAAAXLc0toG00WnYFi/Rc8OAqxuE2SB5AvEpLYTdQnmBd7pSC+0sNz
        DOl4fzQbnKNvOXribGBC3hEnqH1tOYo6wAvudgE=
X-Google-Smtp-Source: APXvYqx+n4u9oJJMuDA0ns2aDhTyoGkwwKiA4D4tHIfuVxnjL9ix5kO3F+lS+1evpIh5xhMhcwgVnx9sHpvKvTblzcM=
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr115658449edy.202.1564756073161;
 Fri, 02 Aug 2019 07:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190802083541.12602-1-hslester96@gmail.com> <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
In-Reply-To: <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Fri, 2 Aug 2019 22:27:42 +0800
Message-ID: <CANhBUQ2TRr4RuSmjaRYPXHZpVw_-2awXvWNjjdvV_z1yoGdkXA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cxgb4: sched: Use refcount_t for refcount
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> =E4=BA=8E2019=E5=B9=B48=
=E6=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=889:40=E5=86=99=E9=81=
=93=EF=BC=9A
>
> On Fri, Aug 2, 2019 at 4:36 AM Chuhong Yuan <hslester96@gmail.com> wrote:
> >
> > refcount_t is better for reference counters since its
> > implementation can prevent overflows.
> > So convert atomic_t ref counters to refcount_t.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> > Changes in v2:
> >   - Convert refcount from 0-base to 1-base.
>
> This changes the initial value from 0 to 1, but does not change the
> release condition. So this introduces an accounting bug?

I have noticed this problem and have checked other files which use refcount=
_t.
I find although the refcounts are 1-based, they still use
refcount_dec_and_test()
to check whether the resource should be released.
One example is drivers/char/mspec.c.
Therefore I think this is okay and do not change the release condition.
