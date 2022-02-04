Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1F4AA31C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349083AbiBDWYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbiBDWY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:24:29 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA987D32DC4C
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:24:25 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id z62so10546115ybc.11
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H5tsXpigjy8/GqkEn/RWupsHMsvf4jYImCTbTpMGJ+Q=;
        b=afipZ7gTtAriiXYFn7I8YzBJ++IXgeBghl/YXdk8pT3kiw+/9akScclcEmtNtObpF6
         djlbnnT9Mf+bVBiFmVp/TdA7/Fnq3oKvdJAOJFZmQzo3KVdpIwJu2jM7tTAX7bVkTG6D
         YydjcnlDoxAsrUtvD9mW9b96knMkMeVOh/BB/t9VIIEnbHbVFZXwttVLLsrGRKBFVTcY
         cjQGQMiQxZQDfbESanAG99VlvvFF7pJHOl9CPFVuMSRCgVePlYpqJdOpgDBepr1r2J8w
         icz/ocLR1E159SwBkqReWbBxVzRA9BscPIfVKB3M36pimEXP6W5eUiDeReH/R3KzXCDM
         nF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H5tsXpigjy8/GqkEn/RWupsHMsvf4jYImCTbTpMGJ+Q=;
        b=e5AKwfd39cJCab44vSH2wfToBlD87i6II9m8J0anVjUXifF7Rb0w0XhwhKK8XzjonF
         /YUD0XA73wB6zQF9/wJyKFnyQVOP0QqPhtcowLSQNnsY1PXJmrCSY3P+SD6cQX46o62m
         iX+okgs7+HzWMWZWwQ3nmXRyojD3Ypzx8YPqheKbbdG7JH8+iirk+Gu6Zh9Ha+2HCJpV
         XOAy1EqSJgYMYJBgU8ak1CRYEgoaGeHwyxb8UdVs97YScTrmX7jEkhXFBxQf2Jy4lP2l
         QUH1X1Wb4o2C6oY94F0FppmCFT3pm1b8aOUvtIu1nPEWKiAPKXAZ+cVloTzEmS2Lro/z
         OY8g==
X-Gm-Message-State: AOAM531+9IpWR499HE0HthnLJO5s4zekM310emUPJOEYf3iwEg760SIy
        0u/og2cs0Hv46Njt/S0GhT6INDgkZcx8/jdQTOxdTvVq1hSQInKlQZU=
X-Google-Smtp-Source: ABdhPJych//KyXkrPQb6CJ6Xs0cQ29wSJsr9YkMt86H8tH5ILBkBWtWghr0fcUamky9ipPNZR3nSg7MrPDecNJjKFfs=
X-Received: by 2002:a25:d2cb:: with SMTP id j194mr1309599ybg.277.1644013464654;
 Fri, 04 Feb 2022 14:24:24 -0800 (PST)
MIME-Version: 1.0
References: <20220204183630.2376998-1-eric.dumazet@gmail.com> <CANn89iKp2jY-Yr1PX_Ug+6izpYjYzZPBNaYN63T16Wz=3AJ16Q@mail.gmail.com>
In-Reply-To: <CANn89iKp2jY-Yr1PX_Ug+6izpYjYzZPBNaYN63T16Wz=3AJ16Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 14:24:13 -0800
Message-ID: <CANn89iK0n6yNR+Bgj_rWqz=sYcp2nLVFOE_G0UXppL5KxHSUdA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: device tracking improvements
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 1:51 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Feb 4, 2022 at 10:36 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Main goal of this series is to be able to detect the following case
> > which apparently is still haunting us.
> >
> > dev_hold_track(dev, tracker_1, GFP_ATOMIC);
> >     dev_hold(dev);
> >     dev_put(dev);
> >     dev_put(dev);              // Should complain loudly here.
> > dev_put_track(dev, tracker_1); // instead of here (as before this series)
>
>
> Please do not merge.
>
> I have missed some warnings in my tests, it seems I need to refine
> things a bit more.

I had to add the following on top of the last patch, I will send a V2 soon.

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index b0f5344d1185be66d05cd1dc50cffc5ccfe883ef..95098d1a49bdf4cbc3ddeb4d345e4276f974a208
100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -166,10 +166,10 @@ static void linkwatch_do_dev(struct net_device *dev)

                netdev_state_change(dev);
        }
-       /* Note: our callers are responsible for
-        * calling netdev_tracker_free().
+       /* Note: our callers are responsible for calling netdev_tracker_free().
+        * This is the reason we use __dev_put() instead of dev_put().
         */
-       dev_put(dev);
+       __dev_put(dev);
 }

 static void __linkwatch_run_queue(int urgent_only)
