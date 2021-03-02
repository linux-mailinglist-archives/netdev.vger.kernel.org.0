Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31632B396
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449789AbhCCEDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839169AbhCBQFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 11:05:54 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE36C06121D
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 08:05:13 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f1so32116241lfu.3
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 08:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u3vrCOqBqiGMoxwM/+kt6E9YSBHI9AFXy4UzoBkJwk=;
        b=JFAf2cQTX3pjJy/IKn8T+yEF7LZz0gU/ysRGaYoMRfr/37vv7anyyPz9VzZmIWVt6I
         Zsp14STWWYVBxjNclWI9hIAwb7nn2PM5hDVF/Ffa/HC+hvwAyRO9d3wsmZ5IvYABOBme
         DXYNcGkMM/CRtBJUpM5fbK4dK1BhxaPbdKTZVhBb6x/wWT1T8XI9nz7jTzD+quVAj5ly
         ka5YgHXkbfTsCB0ALtae03KR7m2SBwEYHIeCJVWelgcuW+wM0mp+QC6hYCv6H7E1nPEp
         zB/9WYmRIQ+BSoC/icIfiW9x6uHOTop96bov3Bc2tZYQGdpV502MeVnrB8R76qAYg/Sb
         IwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u3vrCOqBqiGMoxwM/+kt6E9YSBHI9AFXy4UzoBkJwk=;
        b=GnK3/roQz0/08IkSmj/NpRscmnWBEVhkIu8im5/A9uOVgaSKtGp6CPBezRGQ4UYpJL
         DFZI6tGkvxsLNwO0HiArhYE/n6iOtb5SfPaI6liApf1rqVcBY/WEnun8ASQVd8ZU89Un
         o83JAPkQSfvFO2T7lAnBlzYgk+rBOTsWPvtFSAdCJKQU1UGa0VwlQYTDRq2ZqgUBhHr6
         LOMEuXVZ6qIEsNVO5eHwcBWWkwW+jhwS/xL6ycBvpHkCPLiXXrCBDUI9zU1RClZKSOLD
         lqSoIEtkIwVWN0Oi7YMibmOiXBmgaHFuPbvv1ioL0pRsnCF1yx2nitHTsgln/u8GuLlA
         sdrQ==
X-Gm-Message-State: AOAM531e/X7pTPPvt9iMgPaubLXJMfszC4vSewpwiDpe3cp4nwC5gop2
        POvCaDRjpUVb/g43agDQREAIfTLuAlr2loh6E6X0vQ==
X-Google-Smtp-Source: ABdhPJzfGV7wd4O5cGyjJs+MbRVCgtXtQ4Vx7cbYfsSAQGGRpI3lbvsgIUESHKBcLEdBQv9avqoVykyxwph6YEXPPHY=
X-Received: by 2002:a19:6b13:: with SMTP id d19mr12460951lfa.291.1614701111630;
 Tue, 02 Mar 2021 08:05:11 -0800 (PST)
MIME-Version: 1.0
References: <20210224061205.23270-1-dqfext@gmail.com> <CACRpkdZykWgxM7Ge40gpMBaVUoa7WqJrOugrvSpm2Lc52hHC8w@mail.gmail.com>
 <CALW65jYRaUHX7JBWbQa+y83_3KBStaMK1-_2Zj25v9isFKCLpQ@mail.gmail.com>
In-Reply-To: <CALW65jYRaUHX7JBWbQa+y83_3KBStaMK1-_2Zj25v9isFKCLpQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 2 Mar 2021 17:05:00 +0100
Message-ID: <CACRpkdZW1oWx-gnRO7gBuOM9dO23r+iifQRm1-M8z4Ms8En9cw@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 4:58 AM DENG Qingfang <dqfext@gmail.com> wrote:
> On Mon, Mar 1, 2021 at 9:48 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> > With my minor changes:
> > Tested-by: Linus Walleij <linus.walleij@linaro.org>
>
> How about using a mutex lock in port_bridge_{join,leave} ?
> In my opinion all functions that access multiple registers should be
> synchronized.

That's one way, in some cases the framework (DSA) serialize
the accesses so I don't know if that already happens on a
higher level? Since it is accessed over a slow bus we should go
for mutex in that case indeed.

Yours,
Linus Walleij
