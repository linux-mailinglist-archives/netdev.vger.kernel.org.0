Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE63417AC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhCSIpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhCSIpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:45:16 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39568C06174A;
        Fri, 19 Mar 2021 01:45:16 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i81so2509413oif.6;
        Fri, 19 Mar 2021 01:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b7wm5QMKB239t1tplTFKDCbeyIsyOshCN0mI6FznUvI=;
        b=rqA5ewD896q0KlEZ+3JV9R9sYifcOh0EgtP7oEHhvKGSKbqeg2wDrhvHiAKAZBZvtG
         FSEu/nrYDGDa9dsDXRVW1+72ceXlxq4ZiErhgV3wmd/dmDioWNyYSjV4IXVUr5xuGb+V
         t6H875aA8ostTholvNxDJZoePZxxoj1nQguMGo2AUtxxTFUPQJHYW8tjZQ5YMcjOva8s
         z0rN2c3EXCMo6fweaQoHCcu8Pmdt1oSIOyFkfRByYGWx7RyfuxHXjrhFQuQtVzHhSbuh
         4OXJAbiQ3y3/H2J4dpWOXrhCLdNfi0oRUO1vokBJdyIwjQSJBKTy2flRYUa/TedMIm4E
         ffrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b7wm5QMKB239t1tplTFKDCbeyIsyOshCN0mI6FznUvI=;
        b=CmTvLdZt7Dt0Y2V6N6zHjtL+tGInwwloBHXo3mpFKiIiKkZoXoCnm7q5I+FI8Ee0JV
         imtdDOMfCJmwnARKMJS/w+Vky0gpyVZQHFKEc831ygrLN8bxyPo4QR8qkNZJBeTTQIGx
         avjoxr1sMATEsVP32YlTlHNC2XP/0NpxzWeJNxQ379kl5LhFdQwbku/XgLF7IkVL9WCe
         Ytha5oTX2JqdYfaLv+ZAmgD+UcsNe36KSW215LZL1AgOw2GQvpzFLGBMi9862XntQKkM
         C8Eeffvgr+jMVsXBXQYCawd0E3hPPhLOPN3SO/LSzI6e5/JkdvfGbaNUj6Oy8FUV5Ntq
         a9Fg==
X-Gm-Message-State: AOAM533P8apwYw2GwWYMFoTV/0jPDvTwUtOf/yRR6EIfoCf35INvhW+o
        v02BFyVbYtQz/6kcaF/SEYz415D73OQ21BYIkTRxoiBnmMZohkEz
X-Google-Smtp-Source: ABdhPJyJhsaTtn9yzl0Cx3+n8/FKJ740qWUy6C3Eh2DasLzrDrzNFMdDHV99sq3C2XmR4tUBWUILMAiO4wv7w6jw/n8=
X-Received: by 2002:aca:a9d8:: with SMTP id s207mr222332oie.18.1616143515761;
 Fri, 19 Mar 2021 01:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <87tupl30kl.fsf@igel.home> <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
 <87o8fhoieu.fsf@igel.home> <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
In-Reply-To: <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
From:   Yixun Lan <yixun.lan@gmail.com>
Date:   Fri, 19 Mar 2021 08:42:25 +0000
Message-ID: <CALecT5g5NLYSemdb5i-n66vYmBTk1xNSLn24fDQgZ+uX6rmj4Q@mail.gmail.com>
Subject: Re: macb broken on HiFive Unleashed
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Claudiu.Beznea@microchip.com, linux-riscv@lists.infradead.org,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch, w@1wt.eu,
        Nicolas.Ferre@microchip.com, daniel@0x0f.com,
        alexandre.belloni@bootlin.com, pthombar@cadence.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Andreas:

On Fri, Mar 19, 2021 at 8:28 AM Yixun Lan <yixun.lan@gmail.com> wrote:
>
> HI Andreas:
>
> On Wed, Mar 17, 2021 at 4:27 PM Andreas Schwab <schwab@linux-m68k.org> wrote:
> >
> > It turned out to be a broken clock driver.
> >
>
> what's the exact root cause? and any solution?
> seems I face the same issue, upgrade kernel to 5.11, then eth0 fail to bring up
>
oh, sorry for the noise, just saw you already commented in another thread..

https://lkml.kernel.org/r/87v99qyjaz.fsf@igel.home
