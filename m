Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046C1137B88
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 06:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgAKFYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 00:24:11 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35062 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgAKFYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 00:24:11 -0500
Received: by mail-ot1-f67.google.com with SMTP id i15so4135098oto.2;
        Fri, 10 Jan 2020 21:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ulN2oU6xZjaVScLYbWPyLshfWZ9NLYCBI301oK8HmTc=;
        b=KKkDsIoxY+z4pfkRvdwVhz06iHBeS+Km6wMD5Gd9lKk8HfdIe7tyFqNXw8B4M/pYSs
         rBNAE/kV7AMQn/yjzTTrPfOZik3TFDGcOvBi4xK6sdMy4GSPYPCsb0jZIGTM0HJfTVi0
         clqWSA4oPnvxYRN6plRnrQrONZ2v5/emp7HaaYs8TRO4NsfZb9Y3Ii5xiwDnjvyBE7io
         807pKvWH/9vgKwkAxvy/3nT4FKwkh8y6pcw56IG43tASV7twVeyumj/x1JPad3iOUrue
         1II8kD7pyUGAweXuFUpbL04JtsjJoAJVaHOxkgU81+Jznj4RkgbRdckZNGjFkNA5KML0
         O7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ulN2oU6xZjaVScLYbWPyLshfWZ9NLYCBI301oK8HmTc=;
        b=ddHVPldLrDGlOR0ts0YciT07f3j7aEO8V4FzL9z5ZrKGJeoK5xvVuhEv488205xHVM
         ItwM2FnM1XG02lj6XzuMpcYYB2jHRyiGN8Lt1Qj5q0tv0rqJrcP8Wnd2+DEQBeqVr9t/
         34FX6YUE6FVoTbz797xHfXaqmnvG9qJP0AahjNdBtM8PjXrTqCGY1EsWK8Mk90fMwYBD
         ZrqAyCHkPbt2mHm71h/MUoypy093NJ+6mdyiOpkWIHQdLwvJJg1dHQkui4R38wBOj97a
         IMtjfoW4dAB59GmZTL9q2596/e2mFhX4utFKXKKl0XRl8YBimtIgotRWYSRUvRFCPyel
         q+dg==
X-Gm-Message-State: APjAAAX6VdjL7zlMOlVQl+9Ov377eHXfmDTVoWC9+CBG9Hx8bSP6KbZK
        oxjzeh1PmUkujQEIv+XGXtz8r6coxKvIWVcn5XcLxj/IuUHwgw==
X-Google-Smtp-Source: APXvYqw9ewCZDB4jVPAZcXejrgmV2upwbAa/c2CbDKio7tYR1Bk+jtkM+YJNvNgdzbZ6t+UPeZMrc4fVvYqXxQYv2F8=
X-Received: by 2002:a05:6830:1515:: with SMTP id k21mr5241169otp.177.1578720250672;
 Fri, 10 Jan 2020 21:24:10 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b469059bcde315@google.com> <b5d74ce6b6e3c4b39cfac7df6c2b65d0a43d4416.camel@sipsolutions.net>
In-Reply-To: <b5d74ce6b6e3c4b39cfac7df6c2b65d0a43d4416.camel@sipsolutions.net>
From:   Justin Capella <justincapella@gmail.com>
Date:   Fri, 10 Jan 2020 21:23:57 -0800
Message-ID: <CAMrEMU_a9evtp26tYB6VUxznmSmH98AmpP8xnejQr5bGTgE+8g@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in cfg80211_wext_siwrts
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     syzbot <syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Cody Schuffelen <schuffelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed pfifo_qdisc_ops is exported as default_qdisc_ops is it
possible this is how rdev->ops is NULL

Seems unlikely, but thought I'd point it out.


On Fri, Jan 10, 2020 at 11:13 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Fri, 2020-01-10 at 11:11 -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    2f806c2a Merge branch 'net-ungraft-prio'
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1032069ee00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5c90cac8f1f8c619
> > dashboard link: https://syzkaller.appspot.com/bug?extid=34b582cf32c1db008f8e
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
>
> It's quite likely also in virt_wifi, evidently that has some issues.
>
> Cody, did you take a look at the previous report by any chance?
>
> johannes
>
