Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8504974E0
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 20:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiAWTEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 14:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiAWTEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 14:04:01 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E302FC06173B;
        Sun, 23 Jan 2022 11:04:00 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so52783927edn.0;
        Sun, 23 Jan 2022 11:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hikcqL8mS8nMF1CzMfm8luBGcU7GRgMoFevUVKAg5Ug=;
        b=UiASGjdh1VQ8Hp21AjanbFzPUBArgoJogAZ4hzN4sig0CppgTiTlavhcRfIW+grqtA
         vnS7Vj57dS0rLco7TbGy4r6bHFqId/f1mCPtZ6poBg/M1y1Qn5rjY3+PNYnYwBZulxqo
         UM51keKFIrf4vhUjMDNntfGpM2r2Uvp0fvJvwa/gz7HVb1CwqnJk8xJbYpOyZMMAhcij
         PZICVfpO0GPp4mc+iyrSbI8l4foRlZ5U8uako6wmcuBMyGtQxdCjdQG3RXc4xokYOvfo
         8FIo3H2aHiZSK/OM2zs17p6QBgRb6x8x1fplevrEprUK1TQFA7IWf0xU0+W1kTmM5nZz
         YQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hikcqL8mS8nMF1CzMfm8luBGcU7GRgMoFevUVKAg5Ug=;
        b=Mpt0PZ3QbBI3n2gy30dJGxaCMxoS6ff66KHeZk3Kye4xquKppyREt+g8J8msqfhSky
         iH3JlFnnYTBjmz+AQrKpzkfi2ryY69DzuGE0nXO19SxhoBg7+tsVbVYJULrbqKZXfksI
         c/HYcompLm4Czh0toj+C0zSurAye5FnD8M7Cqcc7bf50OhWaxnyNo+fUsizK98Cn0dba
         spPnocDkz6gpwRX3geKU99p0ucLQoSwYsmfKkKr6oSPvsxYLlnNEKAHhpZNN4hW/GmXM
         fY6hl/DulwwSHwXwYqIImmlP9XLIQhPkIw5GGndER5+GyNQ+Dq7AErtgaN4XVaJPWY0X
         euJQ==
X-Gm-Message-State: AOAM531H/hbuBdvxlZWiSoS+gpxegQtHDw64N7pY66ZpI3tZthYw4HYX
        B5URnizdt5tkGsTOCDp/1IrAJcPgw9kzN6BoYFqWtwIf8PE=
X-Google-Smtp-Source: ABdhPJyEuGbEhaR8JMUnLmh2cEdtZcPv7gUuWDVYmzphuzl4za6aIJpjmP9yx3btWANqlBt565j/QDo76VxdGi0NRUA=
X-Received: by 2002:a50:eacb:: with SMTP id u11mr12866389edp.290.1642964639421;
 Sun, 23 Jan 2022 11:03:59 -0800 (PST)
MIME-Version: 1.0
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com> <423f474e15c948eda4db5bc9a50fd391@realtek.com>
In-Reply-To: <423f474e15c948eda4db5bc9a50fd391@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 23 Jan 2022 20:03:48 +0100
Message-ID: <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Fri, Jan 21, 2022 at 9:10 AM Pkshih <pkshih@realtek.com> wrote:
[...]
> >
> > I do stressed test of connection and suspend, and it get stuck after about
> > 4 hours but no useful messages. I will re-build my kernel and turn on lockdep debug
> > to see if it can tell me what is wrong.
First of all: thank you so much for testing this and investigating the deadlock!

> I found some deadlock:
>
> [ 4891.169653]        CPU0                    CPU1
> [ 4891.169732]        ----                    ----
> [ 4891.169799]   lock(&rtwdev->mutex);
> [ 4891.169874]                                lock(&local->sta_mtx);
> [ 4891.169948]                                lock(&rtwdev->mutex);
> [ 4891.170050]   lock(&local->sta_mtx);
>
>
> [ 4919.598630]        CPU0                    CPU1
> [ 4919.598715]        ----                    ----
> [ 4919.598779]   lock(&local->iflist_mtx);
> [ 4919.598900]                                lock(&rtwdev->mutex);
> [ 4919.598995]                                lock(&local->iflist_mtx);
> [ 4919.599092]   lock(&rtwdev->mutex);
This looks similar to the problem fixed by 5b0efb4d670c8b ("rtw88:
avoid circular locking between local->iflist_mtx and rtwdev->mutex")
which you have pointed out earlier.
It seems to me that we should avoid using the mutex version of
ieee80211_iterate_*() because it can lead to more of these issues. So
from my point of view the general idea of the code from your attached
patch looks good. That said, I'm still very new to mac80211/cfg80211
so I'm also interested in other's opinions.

> So, I add wrappers to iterate rtw_iterate_stas() and rtw_iterate_vifs() that
> use _atomic version to collect sta and vif, and use list_for_each() to iterate.
> Reference code is attached, and I'm still thinking if we can have better method.
With "better method" do you mean something like in patch #2 from this
series (using unsigned int num_si and struct rtw_sta_info
*si[RTW_MAX_MAC_ID_NUM] inside the iter_data) are you thinking of a
better way in general?


Best regards,
Martin
