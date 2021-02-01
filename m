Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577FC30A6B4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBALjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhBALja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:39:30 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEABC061573;
        Mon,  1 Feb 2021 03:38:50 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b17so9817345plz.6;
        Mon, 01 Feb 2021 03:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Q95PqvGkUzp3INwmIRdQ7b1iYJiecOxAb6O0DpOr0g=;
        b=JGHk/DRuXxYOJY1bsikB5G3a4n25Rwz1TgpAclgFiYFbK+HZW2xwO9iTVy+izSSLAw
         +pLPpS4HE2iOzv5QSPBrfWS7Ow/dtZ1zzH5JFSHMgesI21P0aZnnIA0mBqRiJdetKdJ5
         ITeljf/RRurnq3IZnn0i4x3j5cbM5cNVpHP2rqCWnsSH2rUxA1eaGN+F3juti0aMZ3VH
         ZifR6x1yUt3M5zaW4dkQpIhDuGm972Z+B/JYQN0peDPbuMl6v0MvtiziwxG4f6GjWtlK
         cX2JjCXoWHNQKvvCADwrKmtfLCw56vhRSrSpModUUrKi8bRTAmbUsgCGR4/M5t8LI8vP
         GUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Q95PqvGkUzp3INwmIRdQ7b1iYJiecOxAb6O0DpOr0g=;
        b=i3UjXmISuWNQvfhsTRY32GhXWjNHU2G5JE9grpRAxIpRjw6e/85LeNiu2qQAWORHkV
         5ByVOYxbXEYTeNLkOhUVGzXHgoEMAppA1KQ/mcnwV2vMtmCr0ehqbH3TYil/uzD89U/W
         FXUrP4hoidRIvb7ZC6Fp1lg4HGuJnp8T4eiHy8K4OuGUHP0QiPCSot2zT1fSk/NFSawY
         Nl8vREq80TVFA86jpGbBrlvAFTEQeDhq22UpBeeCq+T4kleAWWOAaZ61DHlB8VG89RRc
         +MJHEjjCIh4RqwtvA2ruyU3xEtsPIG+EEcytDr/YpGkbqqhjVt47i2Cfs01t1dCWPCkS
         7Jug==
X-Gm-Message-State: AOAM533IJA8iealfKW/WWlEUtCfTeGVg59DGgOQizxaNsOhZlmmtehbv
        kw8XcDfmgw/mk6u4MfFjeJFr2sg266kwWK0Zxzwhmz4I
X-Google-Smtp-Source: ABdhPJxRlhN1OyRA2lmec2j7rnkmGQNZ9fdTym4x2U4fromKrodYjARBmTZl1YQb3oFlmdCqRPKgr7GR+kQnXX5TNBQ=
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr17099299pjh.198.1612179529883;
 Mon, 01 Feb 2021 03:38:49 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de> <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
 <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com> <36a6c0769c57cd6835d32cc0fb95bca6@dev.tdt.de>
In-Reply-To: <36a6c0769c57cd6835d32cc0fb95bca6@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Feb 2021 03:38:39 -0800
Message-ID: <CAJht_ENs1Rnf=2iX8M1ufF=StWHKTei3zuKv-xBtkhDsY-xBOA@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 1:18 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I have thought about this issue again.
>
> I also have to say that I have never noticed any problems in this area
> before.
>
> So again for (my) understanding:
> When a hardware driver calls netif_stop_queue, the frames sent from
> layer 3 (X.25) with dev_queue_xmit are queued and not passed "directly"
> to x25_xmit of the hdlc_x25 driver.
>
> So nothing is added to the write_queue anymore (except possibly
> un-acked-frames by lapb_requeue_frames).

If the LAPB module only emits an L2 frame when an L3 packet comes from
the upper layer, then yes, there would be no problem because the L3
packet is already controlled by the qdisc and there is no need to
control the corresponding L2 frame again.

However, the LAPB module can emits L2 frames when there's no L3 packet
coming, when 1) there are some packets queued in the LAPB module's
internal queue; and 2) the LAPB decides to send some control frame
(e.g. by the timers).

> Shouldn't it actually be sufficient to check for netif_queue_stopped in
> lapb_kick and then do "nothing" if necessary?

We can consider this situation: When the upper layer has nothing to
send, but there are some packets in the LAPB module's internal queue
waiting to be sent. The LAPB module will try to send the packets, but
after it has sent out the first packet, it will meet the "queue
stopped" situation. In this situation, it'd be preferable to
immediately start sending the second packet after the queue is started
again. "Doing nothing" in this situation would mean waiting until some
other events occur, such as receiving responses from the other side,
or receiving more outgoing packets from L3.

> As soon as the hardware driver calls netif_wake_queue, the whole thing
> should just continue running.

This relies on the fact that the upper layer has something to send. If
the upper layer has nothing to send, lapb_kick would not be
automatically called again until some other events occur (such as
receiving responses from the other side). I think it'd be better if we
do not rely on the assumption that L3 is going to send more packets to
us, as L3 itself would assume us to provide it a reliable link service
and we should fulfill its expectation.
