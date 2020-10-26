Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58882986A9
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 06:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770116AbgJZF6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 01:58:16 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:35595 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770109AbgJZF6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 01:58:16 -0400
Received: by mail-wr1-f52.google.com with SMTP id n15so11007567wrq.2;
        Sun, 25 Oct 2020 22:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKVG20c6o237CUyhCCGYjgzodFcI4lwb/+jy6XdBe+k=;
        b=iqz4/KnVtU8iMD2GOjKAnm/JP/sI1dcLLhpY7sVJ3Vax/bEZ26JmIL2ogJ+iYXxPMb
         rdRA4kL9yiYdMkFigZB0mwfpx2WO13gcLA7itBc5x/UdJb34uN/uRYAzdQQxIPx4CY0Q
         uD2hodQ626wLrJM+i7BZqucqjm9FpclTT6XuYAzKdQcgAG+ecJ9y5kZGFyRb0s2U3WXf
         W0oD4nyoHX1ap2fiO6GwPll4cdL7tJdOF29fO5KtiCBFs+3wVUi6IC/jbq1ytHGAH3qu
         wGfvsxPScYLrf7dPK3oB5xvKhHCX9VBCGHdMnPoxmK60dV+xn3Qt+q7FboH8X0jWFHY7
         8cwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKVG20c6o237CUyhCCGYjgzodFcI4lwb/+jy6XdBe+k=;
        b=g/YNGXKVyB6zgjhXRoRsXOJwgfj/GbrOe1Ay+fOQhXIrSm8SJcDHJ31WaGtOYGwlvT
         3n04GGaOF5tepwdw+zpiST1yIsnKU8B9yufXlxe4gfwoYnd8dI816bLjhQXNHtESgQpm
         wt+UPQRQIcnzL1grNcD4+LbpkfNVViLogD6ylC6IHABQW0T5ao9cxe7uOX6SwTXrsVQL
         1Ed7yTbcoW74C0XJlh8zsnt2hV8y1igXSkGHJ0yJLy0EK0n0wl+SgPz2Lokf6357NC9S
         sO1dxvrL22V3y945hbX37N5HTQnbrOvGlRXK6rTXHUSU/I1Hz3BW8mXSF3B+OZVNAuLk
         A1eA==
X-Gm-Message-State: AOAM531TSflDh72jr1xv6LTfQSNxx97iYpG34t+KVuHP639JBnmqUOPq
        f4bCRpGBQdPdrStLmxDXJRlaTC2SkSVowW2DiPI=
X-Google-Smtp-Source: ABdhPJxuK5xrMpzX3Y19K7NBzo/k1VAmR4Emro9UtLH3WyZesMBrp1ZQ4ycvRJi9vCRdL2RzOCcljxqWdaEJrz0OL5Y=
X-Received: by 2002:adf:f043:: with SMTP id t3mr15100249wro.234.1603691893764;
 Sun, 25 Oct 2020 22:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603110316.git.lucien.xin@gmail.com> <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain> <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain> <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain> <CADvbK_csZzHwQ04rMnCDw6=4meY-rrH--19VWm8ROafYSQWWeQ@mail.gmail.com>
 <5EE3969E-CE57-4D9E-99E9-9A9D39C60425@fh-muenster.de> <CADvbK_cZua_+2e=u--cV4jH5tR=24DvcEtwcHfAp1kyq9sYofA@mail.gmail.com>
 <d36e186fd50c44a29adb07f16242f3fd@AcuMS.aculab.com>
In-Reply-To: <d36e186fd50c44a29adb07f16242f3fd@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 26 Oct 2020 13:58:02 +0800
Message-ID: <CADvbK_fqqzJjm38Hv4BrpQwPdXmPojKE6RQWsowdh7AQ8Ha00Q@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
To:     David Laight <David.Laight@aculab.com>
Cc:     Michael Tuexen <tuexen@fh-muenster.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 4:47 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 22 October 2020 04:13
> ...
> > I was thinking that by leaving it to 9899 by default users don't need to
> > know the port when want to use it, and yet I didn't want to add another
> > sysctl member. :D
>
> Could you make 1 mean 9899?
still feel not good, since it's called 'udp_port'.

I will add a note in ip-sysctl.rst:

udp_port - INTEGER
        The listening port for the local UDP tunneling sock. Normally it's
        using the IANA-assigned UDP port number 9899 (sctp-tunneling).
        ...

Thanks.
> So:
>   0 => disabled
>   1 => default port
>   n => use port n
> I doubt that disallowing port 1 is a problem!
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
