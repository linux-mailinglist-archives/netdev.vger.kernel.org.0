Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06332E3395
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 03:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgL1CUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 21:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgL1CUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 21:20:55 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28D8C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 18:20:14 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so12556621ejb.1
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 18:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A9lPH1aNVQR6Tsw+yueVk6DROC5FMiqjcgZagCaLA+E=;
        b=dqnF+oV1tUDz8ROLmzZ3RFVMl8jRF20H4BGxYwpXOyTTWk6tumkG4okhsiW+bgubs0
         71EXTJarEQfzhsPuEhDnIF0e/DD5mfim3ozkmYbEH+34IgyUiSNNfcKugmmsKkMC1XL/
         EbWERw8VEZY/eLgd4XxtmMdEhLqbXc/DQE+bLxhXi7TPALSW+BCoWckYSSlLehNla+aQ
         Rtqz1+2wS9fw5/3/8OHoM4KrDrnxupredy2nc+vyTgwoZzAPhFvFPaGHsZdot8BSpRj5
         2a+Fbf9z3lBkM//+2Cvu3BbTP/U6ToiNSI6eeVIWKr2Pk363xonf8l30kD/62rJdMWcK
         t/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A9lPH1aNVQR6Tsw+yueVk6DROC5FMiqjcgZagCaLA+E=;
        b=QJwotQey336eQNQHK4VwkgvhSqcGmamOs5dYLFNEcyDOpODgJdW71USE9oQnfslkG6
         Aeuy/fAkEj6bLFf/HjPArxrnBbB1GDVn7jLyRmjio6+enld8hQqiChpl2yOqMxulciTd
         wCP4K9VbFlHTWURHpXlm+J0X+ZjEjHgaSYJG5MFuzVVB/qi8s7pMN34KC4yQ3wR2+sjY
         msfFbOIkY+mqchPnx2IY5TF3id1tqsdoNwPPImjYshVuURn5jcZWFMauzBToj1MhuuWD
         zq3T+S7UE1U9SRPSOiALgQFW6QMcI+Ku8+YjxhRZf8dpJ4wIWx8g/NW5EdbMZhj6qPTj
         m3IA==
X-Gm-Message-State: AOAM532GfjumpkoH2urTBVnNW8hUhMegOythe7xar1YSDuj0MQ2GNkwm
        5mw9EPduD9L3inx0KvnIUZYmH6vaMsZHYlpYZ+7bd+92IJ4g7g==
X-Google-Smtp-Source: ABdhPJwm0w5pnDGjp/05ttF4Mq43aHLLiBNOLymegjsXlN0WCQYhjL3FyN4cQy1d7EQWiu+KcCMDkyygD21svbjpoKo=
X-Received: by 2002:a17:906:440e:: with SMTP id x14mr1263139ejo.77.1609122013474;
 Sun, 27 Dec 2020 18:20:13 -0800 (PST)
MIME-Version: 1.0
References: <20201223165250.14505-1-ap420073@gmail.com> <CAM_iQpW_Mc4HzjtVt+AmfPYEJhafVmxwsW_ZVuLVvG0kRCAufg@mail.gmail.com>
 <CAMArcTWCY49YxbVnYjWxH=e+J+oFVjXQ1cJKxLorULXYw-c=+Q@mail.gmail.com> <CAM_iQpWHYF4SJRi+pjVpFNOpUxkJh-802Cdwa-Z_-NthFNUubw@mail.gmail.com>
In-Reply-To: <CAM_iQpWHYF4SJRi+pjVpFNOpUxkJh-802Cdwa-Z_-NthFNUubw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 28 Dec 2020 11:20:02 +0900
Message-ID: <CAMArcTXGbLdEjHZa0C25+WdDfxAM9kO5HKeYb47r0K7B+G121w@mail.gmail.com>
Subject: Re: [PATCH net] mld: fix panic in mld_newpack()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 at 04:24, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Dec 27, 2020 at 6:40 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > But I'm so sorry I didn't understand some points.
> >
> > 1. you said "both side" and I understand these as follows:
> > a) failure of allocation because of a high order and it is fixed
> > by 72e09ad107e7
> > b) kernel panic because of 72e09ad107e7
> > Are these two issues right?
>
> Yes, we can't fix one by reverting the fix for the other.
>
> >
> > 2. So, as far as I understand your mention, these timers are
> > good to be changed to the delayed works And these timers are mca_timer,
> > mc_gq_timer, mc_ifc_timer, mc_dad_timer.
> > Do I understand your mention correctly?
> > If so, what is the benefit of it?
> > I, unfortunately, couldn't understand the relationship between changing
> > timers to the delayed works and these issues.
>
> Because a work has process context so we can use GFP_KERNEL
> allocation rather than GFP_ATOMIC, which is what commit 72e09ad107e7
> addresses.
>

Thank you for explaining!
I now understand why you suggested it.
I will send a v2 patch which will change timers to delay works.

Thanks a lot!
Taehee Yoo
