Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D9B1EA214
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgFAKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFAKoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:44:10 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C52C061A0E;
        Mon,  1 Jun 2020 03:44:09 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f7so8756463ejq.6;
        Mon, 01 Jun 2020 03:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sQTTy8nx24g4sA9k9wroE7mKOafWdrpZxfmI910Hnf4=;
        b=J3gAk8ITQtD3udEyuHfDt58wMvTs9TJPki6UlHOBmLxhTQqkNrrfFRJZKe96TpAsLf
         XBJIVentwfSZgYYVzg40hj35Fc+66J6HOr+3nXJ4YnhGoDovKByHruQIewqICH0x59ua
         tpCKQCnJFUD+biNTGnLL3O4W1d8cPp2AblVy4O6HzbG2+828etD3thDKHn22nGDOQEfj
         gyk41KAKseazyerYIaZDYkZK8esYTCnygob6yNyVjL5jya8GiTDYmP/b4tl9NjJuG8xu
         TUkhFPIvKHzd1etIDPNvLuaFdFSDZS3ll1wnk46hvzvFttWDQt2cwnefzOxcgsL9RKn9
         0NXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sQTTy8nx24g4sA9k9wroE7mKOafWdrpZxfmI910Hnf4=;
        b=mlH+ixKGA96xjzRiOVqpIclyixwwp0JcgDMsUbrTxjOuqdvpxR97AGGy/QrBCKv30O
         nqDFwxl6XSoxddAHVOiAEl/qTikC5e7OZbyZswr4lZ8S295FKuKTMjHpEkejqvvxLVIE
         xzJ6i1l/ZsXF4PU9y0tu+atcIiVNuRFAWCW4chuxCLzK7kKe3LzSUCYT2+Bj4TD9nNMb
         IanYiJDJyHLkW7gCGFXG/sRVqXucYak82XFfgbPxu2FIilKBfd0vA/HmCi0hhUCIM0dT
         afqaI64xP2NjM39WX0Wqc9n3B2kjKDLoXi8KXoW6klJW4LnUsB50nbCpsAQHVfAIJcyN
         wynQ==
X-Gm-Message-State: AOAM533zNofmdkadPy0g2HZFwy2LHfQD3/Va1mu/L0CwE0S/4Fcpi8dC
        4uin193AMkAjZ6yf05gzbb3tYc8zYtSNP3QxHrk=
X-Google-Smtp-Source: ABdhPJwlJp6OtNe0ZRtufcs4UM6tNghYXCv7mCoaWDMy0RU83sY+BfcIwCpZySTW1TtkoILBvyYcafnbXp31es83JaY=
X-Received: by 2002:a17:906:851:: with SMTP id f17mr7835368ejd.396.1591008248424;
 Mon, 01 Jun 2020 03:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200531180758.1426455-1-olteanv@gmail.com> <CAHp75Vc5NrDUZwv7uW+P=Ly+tz3a9XgEukX6ZgSccj_1sMYQaw@mail.gmail.com>
 <CA+h21ho-XYzWo8BqHwu9REnBVEgG2Zynuux=j_UJ8hvhXATOVA@mail.gmail.com> <CAHp75Vfg20sTa2qCQkA5g5uFzGtm7rGc9MuqpC4CSjU-4y0V9g@mail.gmail.com>
In-Reply-To: <CAHp75Vfg20sTa2qCQkA5g5uFzGtm7rGc9MuqpC4CSjU-4y0V9g@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 13:43:57 +0300
Message-ID: <CA+h21hopjyuc5t+iCbDcRpZNMzxgQNKXBe=p+WjQFGVcJ+PL6A@mail.gmail.com>
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "efremov@linux.com" <efremov@linux.com>,
        "ztuowen@gmail.com" <ztuowen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 at 13:39, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>
> On Mon, Jun 1, 2020 at 12:13 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, 1 Jun 2020 at 00:05, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > > On Sunday, May 31, 2020, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > >> Sometimes debugging a device is easiest using devmem on its register
> > >> map, and that can be seen with /proc/iomem. But some device drivers have
> > >> many memory regions. Take for example a networking switch. Its memory
> > >> map used to look like this in /proc/iomem:
> > >>
> > >> 1fc000000-1fc3fffff : pcie@1f0000000
> > >>   1fc000000-1fc3fffff : 0000:00:00.5
> > >>     1fc010000-1fc01ffff : sys
> > >>     1fc030000-1fc03ffff : rew
> > >>     1fc060000-1fc0603ff : s2
> > >>     1fc070000-1fc0701ff : devcpu_gcb
> > >>     1fc080000-1fc0800ff : qs
> > >>     1fc090000-1fc0900cb : ptp
> > >>     1fc100000-1fc10ffff : port0
> > >>     1fc110000-1fc11ffff : port1
> > >>     1fc120000-1fc12ffff : port2
> > >>     1fc130000-1fc13ffff : port3
> > >>     1fc140000-1fc14ffff : port4
> > >>     1fc150000-1fc15ffff : port5
> > >>     1fc200000-1fc21ffff : qsys
> > >>     1fc280000-1fc28ffff : ana
> > >>
> > >> But after the patch in Fixes: was applied, the information is now
> > >> presented in a much more opaque way:
> > >>
> > >> 1fc000000-1fc3fffff : pcie@1f0000000
> > >>   1fc000000-1fc3fffff : 0000:00:00.5
> > >>     1fc010000-1fc01ffff : 0000:00:00.5
> > >>     1fc030000-1fc03ffff : 0000:00:00.5
> > >>     1fc060000-1fc0603ff : 0000:00:00.5
> > >>     1fc070000-1fc0701ff : 0000:00:00.5
> > >>     1fc080000-1fc0800ff : 0000:00:00.5
> > >>     1fc090000-1fc0900cb : 0000:00:00.5
> > >>     1fc100000-1fc10ffff : 0000:00:00.5
> > >>     1fc110000-1fc11ffff : 0000:00:00.5
> > >>     1fc120000-1fc12ffff : 0000:00:00.5
> > >>     1fc130000-1fc13ffff : 0000:00:00.5
> > >>     1fc140000-1fc14ffff : 0000:00:00.5
> > >>     1fc150000-1fc15ffff : 0000:00:00.5
> > >>     1fc200000-1fc21ffff : 0000:00:00.5
> > >>     1fc280000-1fc28ffff : 0000:00:00.5
> > >>
> > >> That patch made a fair comment that /proc/iomem might be confusing when
> > >> it shows resources without an associated device, but we can do better
> > >> than just hide the resource name altogether. Namely, we can print the
> > >> device name _and_ the resource name. Like this:
> > >>
> > >> 1fc000000-1fc3fffff : pcie@1f0000000
> > >>   1fc000000-1fc3fffff : 0000:00:00.5
> > >>     1fc010000-1fc01ffff : 0000:00:00.5 sys
> > >>     1fc030000-1fc03ffff : 0000:00:00.5 rew
> > >>     1fc060000-1fc0603ff : 0000:00:00.5 s2
> > >>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> > >>     1fc080000-1fc0800ff : 0000:00:00.5 qs
> > >>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
> > >>     1fc100000-1fc10ffff : 0000:00:00.5 port0
> > >>     1fc110000-1fc11ffff : 0000:00:00.5 port1
> > >>     1fc120000-1fc12ffff : 0000:00:00.5 port2
> > >>     1fc130000-1fc13ffff : 0000:00:00.5 port3
> > >>     1fc140000-1fc14ffff : 0000:00:00.5 port4
> > >>     1fc150000-1fc15ffff : 0000:00:00.5 port5
> > >>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
> > >>     1fc280000-1fc28ffff : 0000:00:00.5 ana
>
> > > All of this seems an ABI change.
>
> > Yes, indeed. What should I understand from your comment though?
>
> You effectively break an ABI.
>
> --
> With Best Regards,
> Andy Shevchenko

I've replied to Greg about this in the v3 patch.

Regards,
-Vladimir
