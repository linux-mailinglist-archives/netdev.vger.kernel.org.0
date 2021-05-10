Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DAA378F2D
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhEJNnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351737AbhEJNMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:12:54 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C9EC06134E
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:10:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l4so24409263ejc.10
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FZDMTPCULjSf0lzvx2raxLVBYmqffQ6Bdl+gvRYCSY=;
        b=IdOQZUJinUslnh2xZd2gIt5OK7y4J7fxVxhuj/i0pyvfai41VVHcW/AbelUIaH9BTD
         nPCQoCT+3h0ihCPbLPmwny4kLjFXSrULnpOtHud0/wLyEyJBNzDvtLsHow92aBTylyZk
         gBpTFIR7N/iyHdhTMGqEWLIBWqeaE4NZweXHhjm3jIiRoano4XyfMXF6F9MYFlBzATBB
         svcyJh4ZgKhlzdVSv6pXU6oVywdzWrtpMxOR9v0KR4kHNR7WOTjIX5HDHyJJa0Bw2L7E
         iFJbQscd++dEogcng9FRuJujlVNeGx7JtK7sXZ9QMwg1qIH+wSzKLK2Zm9vRfQPec+rD
         sB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FZDMTPCULjSf0lzvx2raxLVBYmqffQ6Bdl+gvRYCSY=;
        b=kZyzxWspGdd5sbTshVs+oDFeBZ16KfOcah9SfprU1jmKt+oY16BfPyyeMj827aSNtb
         jE4P6wqQkj8ycyAg+0FqUAAl0rt2OP9kWViyQAiQBBDWR/ilYM90iqOqEwTXzgkRR48O
         IKx0AU1nEppFBiyO2TzF7SnlgLlLinU1G6MwtHpvxqdApYivMuODlfYwwJVwfHEEV0ZH
         HErC1X7G7+V/84FQaFAipMqbfw4WwwpgVeqETCvuOx9KqyF0nIhoIYijdsU0pFNFCric
         y+zT9y/etLRNR1jBiGGvk3EN+Ergh+wn3EpLtBXhU/4e3JD58IJYTOpHK2J1ZCV6gE2k
         1otg==
X-Gm-Message-State: AOAM532NYsgCZ70/Uhvr+T/RMngDj3yT7OvoSs0rjWd9ONt9NshOwBwn
        F/EpZxEDYBteoA9qrsx7JV/8dVcl3XbNz+YFe26bKPcrW0k=
X-Google-Smtp-Source: ABdhPJzXcrfWYwBjLfFKfxlMSVp3f7XQlXMigEsfFglTvMNXBHhUEFEzfHQoif5QuVqau44ZjPgTy12c21BkRF2vpHU=
X-Received: by 2002:a17:906:7ac9:: with SMTP id k9mr26190253ejo.229.1620652234919;
 Mon, 10 May 2021 06:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com> <a20d5593-f59a-4161-5df0-ef57f9c6d82b@kontron.de>
In-Reply-To: <a20d5593-f59a-4161-5df0-ef57f9c6d82b@kontron.de>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 10 May 2021 08:10:23 -0500
Message-ID: <CAHCN7xLsQ98godj9FqXPUbSgyaQDS4xYKHB=XL_wFG-ZxFxFGg@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 7:52 AM Frieder Schrempf
<frieder.schrempf@kontron.de> wrote:
>
> Hi Adam,
>
> On 06.05.21 21:20, Adam Ford wrote:
> > On Thu, May 6, 2021 at 9:51 AM Frieder Schrempf
> > <frieder.schrempf@kontron.de> wrote:
> >>
> >> Hi,
> >>
> >> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
> >>
> >> So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
> >>
> >> To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
> >>
> >>         iperf3 -c 192.168.1.10 --bidir
> >>
> >> But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
> >>
> >>         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
> >>
> >> The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
> >> There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
> >>
> >> If there's anyone around who has an idea on what might be the reason for this, please let me know!
> >> Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!
> >
> > I have seen a similar regression on linux-next on both Mini and Nano.
> > I thought I broke something, but it returned to normal after a reboot.
> >   However, with a 1Gb connection, I was running at ~450 Mbs which is
> > consistent with what you were seeing with a 100Mb link.
>
> Thanks for your response. If you say "regression" does this mean that you had some previous version where this issue didn't occur? As for me, I can see it on 5.4 and 5.10, but I didn't try it with anything else so far.

I have not seen this in the 4.19 kernel that NXP provided, but I have
seen this intermittently in the 5.10, so I called it a regression.

adam
>
> Best regards
> Frieder
