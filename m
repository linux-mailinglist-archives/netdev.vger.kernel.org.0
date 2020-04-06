Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B94219F757
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgDFNzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:55:43 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35714 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgDFNzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:55:43 -0400
Received: by mail-yb1-f193.google.com with SMTP id i2so3248370ybk.2;
        Mon, 06 Apr 2020 06:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4A564uO7GYoS83UthFSNGKLuETaFoTUUZVsgW2frMJ4=;
        b=Nvhj9XNuWhnqycVcer+BNfQgj5QMrS3iIyCbKJE/Jw8YviHR0ae0eXDihVJ64AwSxf
         e3zW6L1xXL+G7o16N9wSjvyituVB51TFepRa6s+7kzHoTSqexZxeyO+9mlJS+YL0xPf/
         8rwsO8kurHD50voGdRw4FvDtJ09Y5ZjfZgXeVMFQdA6VaG+7wT15ksARuht2np4uyZCi
         rcoXHE+qHi7uRgMvQSCcgyz3zMHLvJ5z6wsKMJ46Mg9/D28gmeeoJAO1W8tcgEJGm9lE
         uKqa3JbsmYSXtDXnxRfEb3dJiAx5HslmTT9kUF/kQ89VoqolsJ4QpaC7VNPilgwDRxw7
         vbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4A564uO7GYoS83UthFSNGKLuETaFoTUUZVsgW2frMJ4=;
        b=dwZdTSN4+GalXvcpJvulfHJy5phgw5w2DaG/kNudKjT8mNrCE+xY6DIzGjq300wTC+
         8LfOI2J0RD5xhp5U7mCns9rDr9fpkVnsMBvRX4FYMj87PVZFWeR4JNBNvWRBLGRjXUHQ
         NW6y3Oppe/6ZjB4X19lePcyhhozG2zytXoIYkqW435Oi+wnvz68HQJ/28yMneFbA2HnP
         ODcKGUawtHhYSv5g3nspATdRhbeoQdBwKg/bcFUUvTnUJ9pX2WeN7z8dFjHQI6YEThON
         A0sYMoijvbRuvPm4PqqvFrYxhvdMPjKpSR2bOinqyOjQt7JG3WIm9GfRemoBTCbMTz1L
         1lBA==
X-Gm-Message-State: AGi0Puak5ELyTqHh9J/lZ2JVpVBI4UsFuDz9SkQaLcilxjd5BkUHVjmV
        qZkHv8YzYzJNcvOjikK0mXmp7HpAu+GYfIf5PNM=
X-Google-Smtp-Source: APiQypJLt8xmlXCqO31w+cX00Phink2ulxeH6YpG/eytu7kYw6mbLdAyu+kvJuaHqRdzzY+m3I7A3WLxJb4Vj7CLi2o=
X-Received: by 2002:a25:da48:: with SMTP id n69mr35562310ybf.370.1586181341740;
 Mon, 06 Apr 2020 06:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
 <87ftdgokao.fsf@tynnyri.adurom.net> <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
 <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com> <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
 <87imiczrwm.fsf@kamboji.qca.qualcomm.com> <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
 <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com> <87v9mcycbf.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87v9mcycbf.fsf@kamboji.qca.qualcomm.com>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Mon, 6 Apr 2020 19:25:30 +0530
Message-ID: <CABPxzYKs3nj0AUX4L-j87Db8v3WnM4uGif9nRTGgx1m2HNN8Rg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 6:57 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Sumit Garg <sumit.garg@linaro.org> writes:
>
> > On Mon, 6 Apr 2020 at 18:38, Johannes Berg <johannes@sipsolutions.net> wrote:
> >>
> >> On Mon, 2020-04-06 at 16:04 +0300, Kalle Valo wrote:
> >> > Johannes Berg <johannes@sipsolutions.net> writes:
> >> >
> >> > > On Mon, 2020-04-06 at 15:52 +0300, Kalle Valo wrote:
> >> > > > Johannes Berg <johannes@sipsolutions.net> writes:
> >> > > >
> >> > > > > On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
> >> > > > > > >     user-space  ieee80211_register_hw()  RX IRQ
> >> > > > > > >     +++++++++++++++++++++++++++++++++++++++++++++
> >> > > > > > >        |                    |             |
> >> > > > > > >        |<---wlan0---wiphy_register()      |
> >> > > > > > >        |----start wlan0---->|             |
> >> > > > > > >        |                    |<---IRQ---(RX packet)
> >> > > > > > >        |              Kernel crash        |
> >> > > > > > >        |              due to unallocated  |
> >> > > > > > >        |              workqueue.          |
> >> > > > >
> >> > > > > [snip]
> >> > > > >
> >> > > > > > I have understood that no frames should be received until mac80211 calls
> >> > > > > > struct ieee80211_ops::start:
> >> > > > > >
> >> > > > > >  * @start: Called before the first netdevice attached to the hardware
> >> > > > > >  *         is enabled. This should turn on the hardware and must turn on
> >> > > > > >  *         frame reception (for possibly enabled monitor interfaces.)
> >> > > > >
> >> > > > > True, but I think he's saying that you can actually add and configure an
> >> > > > > interface as soon as the wiphy is registered?
> >> > > >
> >> > > > With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
> >> > > > mac80211 using ieee80211_rx(), but of course I'm just guessing here.
> >> > >
> >> > > Yeah, but that could be legitimate?
> >> >
> >> > Ah, I misunderstood then. The way I have understood is that no rx frames
> >> > should be delivered (= calling ieee80211_rx()_ before start() is called,
> >> > but if that's not the case please ignore me :)
> >>
> >> No no, that _is_ the case. But I think the "start wlan0" could end up
> >> calling it?
> >>
> >
> > Sorry if I wasn't clear enough via the sequence diagram. It's a common
> > RX packet that arrives via ieee80211_tasklet_handler() which is
> > enabled via call to "struct ieee80211_ops::start" api.
>
> Ah sorry, I didn't realise that. So wcn36xx is not to be blamed then,
> thanks for the clarification.
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
I am still confused, without ieee80211_if_add how can the userspace
bring up the interface?
(there by calling drv_start())?
