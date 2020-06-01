Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D816E1EA203
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgFAKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:39:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3674C061A0E;
        Mon,  1 Jun 2020 03:39:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o6so3346000pgh.2;
        Mon, 01 Jun 2020 03:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wbSoj81hNK/1EU2ds//RtXqFhWnRq2mf+eo2Urk3LrU=;
        b=roXHqP0TAp4n0CMGxg7AzwWNbUDlWj0yMAQGuZ5JFULxMd+q1YjxyPkGaOC6iYSA+n
         xA1Gv9hR7udcpuIxbeZbHMEpoLzdRSD0EhCZLtm5ba9CmDYOeHqJ2lW6m91dn+p1Bqr/
         bJKkPoJIhml6Ls4yNkjzjFd9f3lgKdtUrA2dhjdOmGL1MR2uraRNWyoeTbv7WZ9+xhIA
         sfhQqvOkC9Fg29Krjb5+6DJ7Ub0ku5xkot4EHB9MOgMyVqDt/NAUepa8jm1DSdsR9Cyv
         WUqPirxuEIrtc+rJTfnY63eO1QiurK4Q+KsJalcqMsRQ14SMWVYCptHYMzSsBWjYqLjy
         4uBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wbSoj81hNK/1EU2ds//RtXqFhWnRq2mf+eo2Urk3LrU=;
        b=HmGqBX6tVR898oTUhC/PS/6mCwvo8Axbih9XAdtdxA9deGvlaioMnSqhr4eXH254J+
         /K9kBe4SIKKU6z1FiXPv9u6D8wsZrXXEEq8KGjSzLB8ACaiyl0qbG7e8GImYjRoFntjE
         WUYDJ60Hh2suNMURwUzatnvJBFAuuri1nS8uY61bsqps6kXGOfSXwVTTRffBuBt/907g
         JBH7Bas7hPdUqzC17TFmrW+bQroi/mAm4xGSPiOpUt4oZUgkcId8p3grCarPGkwgKsJN
         OxG6vCI/WRPHLFYS7tXGqCK6ebcy5tMv5TM1309EcHBboLP/wnKiTRg4jrhPWVFEI440
         XZ2A==
X-Gm-Message-State: AOAM533MtrbgL89c/cpZ0GBmfzi73wRXGAPJg50cwh6s1FujJkamzBh+
        2HsOUY8y186owGVSpy0+Z4QhvFYxGtoU6cypj1A=
X-Google-Smtp-Source: ABdhPJyF+mLsyoHFPQ8v2O6tqmHT7N+VH5dWRjzxqVHMMaoUoz6X/U3g1aAyEd29LxFMjGsORKe9iZRKH40lurlWyZY=
X-Received: by 2002:a63:ff52:: with SMTP id s18mr2372296pgk.203.1591007998120;
 Mon, 01 Jun 2020 03:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200531180758.1426455-1-olteanv@gmail.com> <CAHp75Vc5NrDUZwv7uW+P=Ly+tz3a9XgEukX6ZgSccj_1sMYQaw@mail.gmail.com>
 <CA+h21ho-XYzWo8BqHwu9REnBVEgG2Zynuux=j_UJ8hvhXATOVA@mail.gmail.com>
In-Reply-To: <CA+h21ho-XYzWo8BqHwu9REnBVEgG2Zynuux=j_UJ8hvhXATOVA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 1 Jun 2020 13:39:46 +0300
Message-ID: <CAHp75Vfg20sTa2qCQkA5g5uFzGtm7rGc9MuqpC4CSjU-4y0V9g@mail.gmail.com>
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
To:     Vladimir Oltean <olteanv@gmail.com>
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

On Mon, Jun 1, 2020 at 12:13 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, 1 Jun 2020 at 00:05, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Sunday, May 31, 2020, Vladimir Oltean <olteanv@gmail.com> wrote:

> >> Sometimes debugging a device is easiest using devmem on its register
> >> map, and that can be seen with /proc/iomem. But some device drivers have
> >> many memory regions. Take for example a networking switch. Its memory
> >> map used to look like this in /proc/iomem:
> >>
> >> 1fc000000-1fc3fffff : pcie@1f0000000
> >>   1fc000000-1fc3fffff : 0000:00:00.5
> >>     1fc010000-1fc01ffff : sys
> >>     1fc030000-1fc03ffff : rew
> >>     1fc060000-1fc0603ff : s2
> >>     1fc070000-1fc0701ff : devcpu_gcb
> >>     1fc080000-1fc0800ff : qs
> >>     1fc090000-1fc0900cb : ptp
> >>     1fc100000-1fc10ffff : port0
> >>     1fc110000-1fc11ffff : port1
> >>     1fc120000-1fc12ffff : port2
> >>     1fc130000-1fc13ffff : port3
> >>     1fc140000-1fc14ffff : port4
> >>     1fc150000-1fc15ffff : port5
> >>     1fc200000-1fc21ffff : qsys
> >>     1fc280000-1fc28ffff : ana
> >>
> >> But after the patch in Fixes: was applied, the information is now
> >> presented in a much more opaque way:
> >>
> >> 1fc000000-1fc3fffff : pcie@1f0000000
> >>   1fc000000-1fc3fffff : 0000:00:00.5
> >>     1fc010000-1fc01ffff : 0000:00:00.5
> >>     1fc030000-1fc03ffff : 0000:00:00.5
> >>     1fc060000-1fc0603ff : 0000:00:00.5
> >>     1fc070000-1fc0701ff : 0000:00:00.5
> >>     1fc080000-1fc0800ff : 0000:00:00.5
> >>     1fc090000-1fc0900cb : 0000:00:00.5
> >>     1fc100000-1fc10ffff : 0000:00:00.5
> >>     1fc110000-1fc11ffff : 0000:00:00.5
> >>     1fc120000-1fc12ffff : 0000:00:00.5
> >>     1fc130000-1fc13ffff : 0000:00:00.5
> >>     1fc140000-1fc14ffff : 0000:00:00.5
> >>     1fc150000-1fc15ffff : 0000:00:00.5
> >>     1fc200000-1fc21ffff : 0000:00:00.5
> >>     1fc280000-1fc28ffff : 0000:00:00.5
> >>
> >> That patch made a fair comment that /proc/iomem might be confusing when
> >> it shows resources without an associated device, but we can do better
> >> than just hide the resource name altogether. Namely, we can print the
> >> device name _and_ the resource name. Like this:
> >>
> >> 1fc000000-1fc3fffff : pcie@1f0000000
> >>   1fc000000-1fc3fffff : 0000:00:00.5
> >>     1fc010000-1fc01ffff : 0000:00:00.5 sys
> >>     1fc030000-1fc03ffff : 0000:00:00.5 rew
> >>     1fc060000-1fc0603ff : 0000:00:00.5 s2
> >>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> >>     1fc080000-1fc0800ff : 0000:00:00.5 qs
> >>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
> >>     1fc100000-1fc10ffff : 0000:00:00.5 port0
> >>     1fc110000-1fc11ffff : 0000:00:00.5 port1
> >>     1fc120000-1fc12ffff : 0000:00:00.5 port2
> >>     1fc130000-1fc13ffff : 0000:00:00.5 port3
> >>     1fc140000-1fc14ffff : 0000:00:00.5 port4
> >>     1fc150000-1fc15ffff : 0000:00:00.5 port5
> >>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
> >>     1fc280000-1fc28ffff : 0000:00:00.5 ana

> > All of this seems an ABI change.

> Yes, indeed. What should I understand from your comment though?

You effectively break an ABI.

-- 
With Best Regards,
Andy Shevchenko
