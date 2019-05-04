Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76313707
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEDCXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:23:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53113 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:23:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id v189so258669wmf.2;
        Fri, 03 May 2019 19:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vy6SVGBEM6Og4OE2RW7BuROW403oEvGMLl81g4MfGf0=;
        b=BQ9E+W8aHmRHwRxstMGtUHaTUzb63Uvmf/Goo25OEunRSKEc97DTsi05Q4Lwfv5rql
         uO15DjXTQ3SNT/JGkjzUESj5pkUhyXyGXMoN+iPF312bhAub+u/waJyiAzSElyIwm/Oz
         MSNii622HFXP3WY5IFOqR1DBLItwJvHwn67ZH2C2+/Wq+yo22LTVmvcfR6/uSl5CoFji
         rBCimCGfMfbkb5x8aS/chE5kdl4f5SeGpqP5YacTdmvhEuUfV0aGCnS41WYSiHcUQ+mS
         jwJhM9IZCcDrKxiM45KXrgZ9Xm6ykgmWTDgMXaD7S5c029Bsq/U05AiVEEYeb/d69xYX
         468w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vy6SVGBEM6Og4OE2RW7BuROW403oEvGMLl81g4MfGf0=;
        b=mKFlEDJmoaEfzzCie8hIqH61u91q3zBcPyESMSfoJpV7Up9zEa/k2kuvh90IFCd2Ep
         e48/e3y5WDD//uMQxxXZ3o8J8RD5fUk7zRe+pd/E2aRvAEcvM2GOkH8rO6tMN2tTMaRg
         7galSRGHN3CpO+cKE8Rx/zRfXJS9sP46ZINNHWXtkzXkXicdeosrOlx/vwedQUSDjhBH
         Dm2CMYv9oVRnNwxcbYEk0uuJAjy/bGqYxLIjPQGQjHSuyQakaI/mWhgvb5ED8hNpzaYm
         GoncZ8OAmPAPIUv655S0SdchG8XVBtCdnU7jHJ/kRMCP3dq0f4qx3VJ2tOeeRKy/bHZh
         /dOg==
X-Gm-Message-State: APjAAAW5EOBjEoA2IzOc2VdDLuz+8C14ieMHVWDDEzValOPNh8gtP7Q3
        lrlgW3tF65/liksDxRw32lE5/oigANSGBx4okoQ=
X-Google-Smtp-Source: APXvYqwjYm5lze0XG/xZtIqpU7RudQ9UzbQb/oWkKPqFCsSlmvCrxBQ2vv93lKeMU0HBPLoSh115ueBkJyfM+u2vp9w=
X-Received: by 2002:a1c:e904:: with SMTP id q4mr8174644wmc.43.1556936614101;
 Fri, 03 May 2019 19:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190504011826.30477-1-olteanv@gmail.com> <20190504011826.30477-5-olteanv@gmail.com>
 <4d3ea715-676c-c550-cff6-18c94a9d93e6@gmail.com>
In-Reply-To: <4d3ea715-676c-c550-cff6-18c94a9d93e6@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 4 May 2019 05:23:23 +0300
Message-ID: <CA+h21hqjKCZ5+ETRU-qPaCNkRQf1-D2pKpFbxJa4wwEU6nCX8Q@mail.gmail.com>
Subject: Re: [PATCH net-next 4/9] net: dsa: Keep private info in the skb->cb
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     vivien.didelot@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 at 05:04, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> > Map a DSA structure over the 48-byte control block that will hold
> > persistent skb info on transmit and receive.
> >
>
> On receive you cannot quite do that because you don't know if the DSA
> master network device calls netif_receive_skb() or napi_gro_receive().
> The latter arguably may not be able to aggregate flows at all because it
> does not know how to parse the SKB, but the point remains that skb->cb[]
> on receive may already be used, up to 48 bytes already. I tried to make
> use of it for storing the HW extracted Broadcom tag, but it blew the
> budge on 64-bit hosts:
>
> https://www.spinics.net/lists/netdev/msg337777.html
>
> Not asking you to change anything here, just to be aware of it.
>
> > Also add a DSA_SKB_CB_PRIV() macro which retrieves a pointer to the
> > space up to 48 bytes that the DSA structure does not use. This space can
> > be used for drivers to add their own private info.
> >
> > One use is for the PTP timestamping code path. When cloning a skb,
> > annotate the original with a pointer to the clone, which the driver can
> > then find easily and place the timestamp to. This avoids the need of a
> > separate queue to hold clones and a way to match an original to a cloned
> > skb.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Hi Florian,
This is good to know. So I'm understanding that you tried to pass data
in the skb->cb between the master netdev and DSA, and GRO got
in-between? That's kind of expected in a way. I'm proposing a more
minimalistic use even on receive, which should be ok. If you look at
07/09 you'll see I'm setting the frame type from within the
eth_type_trans callback (technically still not in the DSA packet_type
handler yet, but quite close) and using it in the actual rcv. Then for
timestamping I'm communicating between the rcv function and a
workqueue that I start from .port_rxtstamp.
-Vladimir
