Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D601AFC00
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfIKL6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:58:50 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39975 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfIKL6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:58:50 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so19689996ljw.7
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7y00Zo+5wfahV0f4/m81h1l5nqsfXa8NWKboTHI3bB8=;
        b=IlGa9i2PgZ+p/7vPskXhJMz24AHlJrognoCRIq6cXUTri02E8LYJ3BVJxl0TCIs5xW
         aaMVjXylk4QgfGuLFaXhqfexFBZp8KMJmssk0x1OFhAAfHIVz9C8V+VmtHVQP/C/CTZu
         2Ffzul3fzuvdBRW8zyUDq8vdQs6F98erwQq+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7y00Zo+5wfahV0f4/m81h1l5nqsfXa8NWKboTHI3bB8=;
        b=g4ikpeNxqsgLdSNCdCyuK5m1AKv5OWOs9i5aFPDJkXITlun+GXFnGrd5CPJ8tGYPut
         QrDQUyLSavtuwuyYzRdgevk1d2DQ4fQB937zfCAfASnax0Xc+Gn0IWAKvbUd93f3MMn9
         kDEuVGUaA0H3GBHvFWvc3FJNmiCLB4YJhCj9D1kv2cWiuYq0G1PKsZw6agpKNtPGsFso
         n4lw8SPVADkJo3d/TA4NLx78N4WZEA031B0Ye+fTtNIHHGc1UBpe2B4LbzhplvTayDls
         ++sqUHpqwx90j13RkZf84CffSxx/JKBddbyFlb25d7fiL9Anx/ABVhO41cFmJLr99qcY
         DLRw==
X-Gm-Message-State: APjAAAWlJXB75nRoSRLM//4kO3aNADTJhf33F/Og5ovdK11tZjaFbgXi
        kA3cq3CppQ4UtYfeW+3LOTBkaJWKbmFDUQ==
X-Google-Smtp-Source: APXvYqwArKRqialKgEdbPVNHoBKtWbhc2Tu/dzJzCUz0mmSHRj9K3Y49fXK1xdl7nGVWjYQ0PPj5yA==
X-Received: by 2002:a05:651c:113c:: with SMTP id e28mr22125556ljo.184.1568203127215;
        Wed, 11 Sep 2019 04:58:47 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id m9sm4689853lji.66.2019.09.11.04.58.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:58:46 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 7so19689885ljw.7
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:58:46 -0700 (PDT)
X-Received: by 2002:a2e:3c14:: with SMTP id j20mr22307828lja.84.1568203125714;
 Wed, 11 Sep 2019 04:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
 <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
In-Reply-To: <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 Sep 2019 12:58:29 +0100
X-Gmail-Original-Message-ID: <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
Message-ID: <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 11:26 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Hi,
>
> > So I'm at LCA
>
> When did LCA move to Portugal? ;-))

Heh. I may be jetlagged and not thinking straight.  LCA/LPC ;)

> > Previous resume looks normal:
> > [snip]
> >    wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised by
> > 54:ec:2f:05:70:2c
>
> Is that the message you meant?
>
> > I say _almost_, because I don't see the "No TX power limit" for the
> > country lookup (yes, Portugal) this time?
>
> because here you had it too, just a bit earlier. It usually comes when a
> beacon is received the first time, which depends on the AP timing.

Duh. I'm blind and didn't notice, because I was expecting it in the same order.

And I didn't think about it or double-check, because the errors that
then followed later _looked_ like that TX power failing that I thought
hadn't happened.

> I don't _think_ any of the above would be a reason to disconnect, but it
> clearly looks like the device got stuck at this point, since everything
> just fails afterwards.

Yeah, maybe the power stuff was just another effect of things getting
stuck, rather than the reason for it getting stuck.

So I probably mis-attributed the cause.

> >    WARNING: CPU: 4 PID: 1246 at net/mac80211/sta_info.c:1057
> > __sta_info_destroy_part2+0x147/0x150 [mac80211]
>
> Not really a surprise. Perhaps we shouldn't even WARN_ON() this, if the
> driver is stuck completely and returning errors to everything that
> doesn't help so much.
>
> Then again, the stack trace was helpful this time:
>
> >     ieee80211_set_disassoc+0xc2/0x590 [mac80211]
> >     ieee80211_mgd_deauth.cold+0x4a/0x1b8 [mac80211]
> >     cfg80211_mlme_deauth+0xb3/0x1d0 [cfg80211]
> >     cfg80211_mlme_down+0x66/0x90 [cfg80211]
> >     cfg80211_disconnect+0x129/0x1e0 [cfg80211]
> >     cfg80211_leave+0x27/0x40 [cfg80211]
> >     cfg80211_netdev_notifier_call+0x1a7/0x4e0 [cfg80211]
> >     notifier_call_chain+0x4c/0x70
> >     __dev_close_many+0x57/0x100
> >     dev_close_many+0x8d/0x140
> >     dev_close.part.0+0x44/0x70
> >     cfg80211_shutdown_all_interfaces+0x71/0xd0 [cfg80211]
> >     cfg80211_rfkill_set_block+0x22/0x30 [cfg80211]
> >     rfkill_set_block+0x92/0x140 [rfkill]
> >     rfkill_fop_write+0x11f/0x1c0 [rfkill]
> >     vfs_write+0xb6/0x1a0
>
>
> Since we see that something actually did an rfkill operation. Did you
> push a button there?

No, I tried to turn off and turn on Wifi manually (no button, just the
settings panel).

I didn't notice the WARN_ON(), I just noticed that there was no
networking, and "turn it off and on again" is obviously the first
thing to try ;)

> You don't happen to have timing information on these logs, perhaps
> recorded in the logfile/journal?

Sure. I cleaned up the logs to not spam people with lots of illegible
data, but it's all in the journal log.

Rough timeline:

Sep 11 03:40:00 xps13 kernel: PM: suspend entry (s2idle)
Sep 11 03:40:00 xps13 kernel: Filesystems sync: 0.028 seconds
...
Sep 11 10:13:14 xps13 kernel: Restarting tasks ... done.
Sep 11 10:13:14 xps13 kernel: PM: suspend exit
Sep 11 10:13:14 xps13 kernel: ath10k_pci 0000:02:00.0: UART prints enabled
Sep 11 10:13:14 xps13 kernel: ath10k_pci 0000:02:00.0: unsupported HTC
service id: 1536
Sep 11 10:13:23 xps13 kernel: wlp2s0: authenticate with 54:ec:2f:05:70:2c
Sep 11 10:13:23 xps13 kernel: wlp2s0: send auth to 54:ec:2f:05:70:2c (try 1/3)
Sep 11 10:13:23 xps13 kernel: wlp2s0: authenticated
Sep 11 10:13:23 xps13 kernel: wlp2s0: Limiting TX power to 23 (23 - 0)
dBm as advertised by 54:ec:2f:05:70:2c
...
Sep 11 10:13:23 xps13 kernel: ath: regdomain 0x826c dynamically
updated by country element
Sep 11 10:13:24 xps13 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0:
link becomes ready
Sep 11 10:27:07 xps13 kernel: ath10k_pci 0000:02:00.0: wmi command
16387 timeout, restarting hardware
...
Sep 11 10:27:07 xps13 kernel: ath10k_pci 0000:02:00.0: failed to read
hi_board_data address: -16
Sep 11 10:27:10 xps13 kernel: ath10k_pci 0000:02:00.0: failed to
receive initialized event from target: 00000000
Sep 11 10:27:13 xps13 kernel: ath10k_pci 0000:02:00.0: failed to
receive initialized event from target: 00000000
...
Sep 11 10:27:13 xps13 kernel: WARNING: CPU: 4 PID: 1246 at
net/mac80211/sta_info.c:1057 __sta_info_destroy_part2+0x147/0x150
[mac80211]

but if you want full logs I can send them in private to you.

I do suspect it's atheros and suspend/resume or something. The
wireless clearly worked for a while after the resume, but then at some
point it stopped.

> It seems odd to me, since the RTNL is acquired by
> cfg80211_rfkill_set_block() and that doesn't even have an error path, it
> just does
>         rtnl_lock();
>         cfg80211_shutdown_all_interfaces(&rdev->wiphy);
>         rtnl_unlock();
>
> The only explanation I therefore have is that something is just taking
> *forever* in that code path, hence my question about timing information
> on the logs.

Yeah, maybe it would time out everything eventually. But not for a
long time. It hadn't cleared up by

  Sep 11 10:36:21 xps13 gnome-session-f[6837]: gnome-session-failed:
Fatal IO error 0 (Success) on X server :0.

which is when I shut down the machine (and had to then force a hard
power-off because the shutdown wanted things that needed the rtnl_lock
to go away)

                 Linus
