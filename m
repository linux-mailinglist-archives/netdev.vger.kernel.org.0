Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2A3107A1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhBEJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhBEJRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:17:40 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65FC061786
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:16:23 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id g10so6856249wrx.1
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 01:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amy4L/8jH7mtZxpeWf9Qu1vs+rFEFgpRFCEiO9AV7Ao=;
        b=RB2MTZXhxZ5xs70SUvleh2MZruvFRue7hITBRCxQUqVo12zU3OwY11g1CdptiTqGk/
         roTONKdHt08a6063IwsUqkSe5SXh1MwFOdUd1GGuT6oJ2mnXqD8234bQdT0oDsOgH4fn
         Tgm8dizKtOflG4eJqG4K+f7BMS8YY3QcEo6bPtoQPLbm8k0UFRYgjkvV5GKqZTzTcAC8
         FNbpwq/GLn0cGxRkFG63u1VG3jHHgrMHdhh4WxqAt7XiICa9pxeYRg6yoDuSIq9NXcJz
         pmlTfQLWIhw6qrzwuYV+mwoOb2oZYtEymKTiYDlF9doWLuJFC9Lnmb6i2qXIjyRIVN+3
         u4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amy4L/8jH7mtZxpeWf9Qu1vs+rFEFgpRFCEiO9AV7Ao=;
        b=rb9R2fU4KgjyrQKP1LatC9kQZn5WoCOMVJ7aKnu9LA85C2DyAiuFNwPZDbAhQZ0J7M
         BXTfKs60Cos/Fyy5/2YoJalcmu+XIJ/+jyJgiySEJbpF4jXZWzoCR8ux3TMOyXHsCy9E
         skR3tQ+QzyxCuhH+TeJ3isAZezzjVDJJtUcRaYLc1tuZdVjnaz505U84ZP6mBU3u6xfe
         Gbl49khmx13vxCvjtLTRYlAWxl13S8Z3XL7dgQ3cLj4wfgqUlbcj5+EA4hdWvEj9ZN61
         rwTUJ48oEHKFCiSgJ9+8oYBCSYClCsXSyX1MBsxudRaZ46i266zU4OgKfMaCYQaXYDeU
         X4cg==
X-Gm-Message-State: AOAM531ucuw5JXwuIA11u1E2BYGWBqaGIURvHJ9Ok2Qkmlmwz7g3ABmE
        zHVDJCRlmff6VIK5CaRlTx26ODUHhjOO4gxBloA=
X-Google-Smtp-Source: ABdhPJy+X9DJjUo7WegQRzjKz7eKAQK+k5gs4uSh/eV4wefzelFkLEo/6hWgBFLrchRP6yB+8zjpcYCgOGcy7BRrPKQ=
X-Received: by 2002:adf:f750:: with SMTP id z16mr3890879wrp.243.1612516582073;
 Fri, 05 Feb 2021 01:16:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611637639.git.lucien.xin@gmail.com> <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com>
 <645990.1612339208@warthog.procyon.org.uk> <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com>
 <655776.1612343656@warthog.procyon.org.uk> <CADvbK_ePdoJRna81YwJUL5cqu1ST3W8J8kRqhbNVGdSse-3u1w@mail.gmail.com>
 <2099834.1612516465@warthog.procyon.org.uk>
In-Reply-To: <2099834.1612516465@warthog.procyon.org.uk>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 5 Feb 2021 17:16:10 +0800
Message-ID: <CADvbK_e1iXDM9MujHBRpO7tq2F01c7+Eg7bdL4bPD4c4_h-iAQ@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4
 packets with UDP GRO
To:     David Howells <dhowells@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        vfedorenko@novek.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 5:14 PM David Howells <dhowells@redhat.com> wrote:
>
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > Subject: [PATCH net-next] rxrpc: use udp tunnel APIs instead of open code in
> >  rxrpc_open_socket
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> You can add "Acked-by: David Howells <dhowells@redhat.com>" if you want.
>
OK, Thank you so much!
