Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151B7B2795
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbfIMVx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:53:27 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41951 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390012AbfIMVx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:53:26 -0400
Received: by mail-oi1-f195.google.com with SMTP id w17so3890893oiw.8
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6tWJcO2b3/IPaZDXeytABtzXFx1hREA5Bw+sUdzIx9w=;
        b=DmzcN41twpvX94mV4qaufyVDYeU6f2d+WmZpmcgAvr1UJA3tRVzDf6i81wV/C52Oew
         e3Faivn/3Ehrmoj6v8Np4+Uyir6gfVc4KxFrh+YPTyrp3uhRR6EiVY6uvBWlSr1Y58cv
         kbny6t7ghNMUL5s0BiVElUuP+7pmSMFSlPUAx+yMFZ8GmV97To3ErqC/9VTfGTPk6YVX
         tUIFVwGjKwOQGtmKfu6qLs1oWEBCywIpdquXR7yCrTKP6U8vhZA275fmLTqAqTaMxaoV
         d1HRcYhojbahWMNTSPxDfImN0HdjMa4xWht73I3sDMryXFHGEZChjOYQQ1GXAubGWwsO
         1K+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6tWJcO2b3/IPaZDXeytABtzXFx1hREA5Bw+sUdzIx9w=;
        b=nTEcXTJevDFy0tnEzRqToNHHzDmpYWOIP7Ip8ODQj1BkS7lq7DclyUlgtUyup7m1CF
         DWMUMGWsMrqFeYOubTwtS4fZjhUFIgbq28yGPN9dwn3QeBEq1taQgqTT2GDPgKs+YbNx
         VuMQeRAH0F9XSayiJLYxofQI62J0mfRV4iXFmUEq5jsRvvu6ar9kMHYZzjLkMfQKRd09
         nlVYL2iUamb9EkSIpBfIy6PavXRzjDT0XKg1f7rkak4UWYxzBYpT1QwYPiixin5F9o9O
         jQRg+eAsMDFjRR6qEKRQyXmWIw752yGky62Yc9XRzUuE3q0/KHU6kRGoiIuEY/7ebKyy
         +X+g==
X-Gm-Message-State: APjAAAUr9xWE3sGiCiGMswwOX4HH1wYW30AXwhnYCv3nBnhgxKvjsFKD
        2u2c7JefuuVcF7YkvJ/I5xjnuT/10N/6NNvKsXu7Gg==
X-Google-Smtp-Source: APXvYqwZWMbrp+wvZCV1haBwaOu2SjKWBacSLd4ThkPCXxM792OINfKtg3DOyGr9zxL78pLjZgZI0l/aI/o3jSCONL0=
X-Received: by 2002:aca:3ad6:: with SMTP id h205mr3658000oia.129.1568411605728;
 Fri, 13 Sep 2019 14:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190913193629.55201-1-tph@fb.com> <20190913193629.55201-2-tph@fb.com>
 <CADVnQymKS6-jztAbLu_QYWiPYMqoTf5ODzSg3UPJxH+vBt=bmw@mail.gmail.com> <CAK6E8=ddxo+yg2tTiZm5YEbfPkeVkeZOGwB33+Qfb4Qfj4yDJA@mail.gmail.com>
In-Reply-To: <CAK6E8=ddxo+yg2tTiZm5YEbfPkeVkeZOGwB33+Qfb4Qfj4yDJA@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 13 Sep 2019 17:53:05 -0400
Message-ID: <CADVnQy=aU=veBnZF=5OgwkT6EWA+hmmu8w9eq2d83eReSjAxEw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 5:29 PM Yuchung Cheng <ycheng@google.com> wrote:
> > What if the comment is shortened up to fit in 80 columns and the units
> > (bytes) are added, something like:
> >
> >         __u32   tcpi_snd_wnd;        /* peer's advertised recv window (bytes) */
> just a thought: will tcpi_peer_rcv_wnd be more self-explanatory?

Good suggestion. I'm on the fence about that one. By itself, I agree
tcpi_peer_rcv_wnd sounds much more clear. But tcpi_snd_wnd has the
virtue of matching both the kernel code (tp->snd_wnd) and RFC 793
(SND.WND). So they both have pros and cons. Maybe someone else feels
more strongly one way or the other.

neal
