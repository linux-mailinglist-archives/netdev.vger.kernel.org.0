Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CEE9D3C5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfHZQNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:13:54 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44264 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:13:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id a21so27228141edt.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MP3WX6Yut/wNfb5+xnboXIYIullJwV0X8jIZhBg2RFc=;
        b=bwNQFe0cQ9xm/Y0RrbXB+4T6Kl4Yd0hvYlSJHhcis7WVh+o8LUw3mI6acAAbEVntnC
         le5XRP3rZzSnPDPSko2wP1IVIjF0jUxgzr2Dn9tZZki+UQX1GDy9GAevAqdqXvShTHk4
         m+2/XRwIrmpljo+yxISddFswG9Ur0Ywdnu7W1/yI31jKROU9LkNK5H/638zbHvYtoUdR
         QIkoRxfKB+HNgg5Dx3zSc2pn9Of8htqp88NYwLG7Tpkj0eLFlk5u4+Gq6WKL78SuYaSo
         x5ZI00HVnHMWxRemjn1WmsmYoG/p29pWLoRqHAJvOK8wn5YBOO5Pi+tqktjYdQO57jWc
         hMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MP3WX6Yut/wNfb5+xnboXIYIullJwV0X8jIZhBg2RFc=;
        b=baEW7PSWIhJ5sv0LJ+QTxfvyOJoLizZhU11PepuAk2peQKjkDHcBtJS9pfy+mahkJ9
         Q1HazgXvMu7YWDvToCySpvD/Uep5Bx9OkBnfL8OTZDOcRmdPgq6Qdj7uBFaP8nwmCoto
         XZZ146IAyDhuhtFYXOWD7P5Aa5dvHOhRve1RQcwp21sPCSP5DjCVl9Rf383QJqJWNv7T
         jRmGzXQ4BUl7aSAJE7kW29BB0YIvs3vOZOOvAfCzIU7peyMbWaXaViLyoPtdokQwT057
         QTrqpZVOJGwkwbNOUoxgcx78w1gPW/XTRCHlv1N5CowXtCPmzd8zyJG1Jdz6Voykvp5P
         oq4Q==
X-Gm-Message-State: APjAAAW7g3jrzNGpG1EbPyru+v73MGukEursuFACqJRBKzeL/6tZnm8m
        cELVElairsQF8xpglupp3P2G1cjYS7yE9swu7nw=
X-Google-Smtp-Source: APXvYqybzANG3v9WZ4im7N4nkscOOYronGE7U9blSu6QOFJmrEe6lKWkJ1czNh9bcuX+daVxv5s31o/eorq2GWfZdbc=
X-Received: by 2002:a50:9dc8:: with SMTP id l8mr19669001edk.108.1566836031994;
 Mon, 26 Aug 2019 09:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190825184454.14678-1-olteanv@gmail.com> <20190825184454.14678-3-olteanv@gmail.com>
 <20190826112049.GB27025@t480s.localdomain>
In-Reply-To: <20190826112049.GB27025@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 26 Aug 2019 19:13:40 +0300
Message-ID: <CA+h21hqgmPR5Py-NwP8=DbVALR8Bon4X4Edd_F5aZh3oTCyrCg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs
 when enabling vlan_filtering
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On Mon, 26 Aug 2019 at 18:20, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Sun, 25 Aug 2019 21:44:54 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > -     if (enabled)
> > -             err = dsa_port_vid_add(upstream_dp, tx_vid, 0);
> > -     else
> > -             err = dsa_port_vid_del(upstream_dp, tx_vid);
> > +     err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
> >       if (err) {
> >               dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
> >                       tx_vid, upstream, err);
> >               return err;
> >       }
> >
> > -     return 0;
> > +     if (!enabled)
> > +             err = dsa_8021q_restore_pvid(ds, port);
> > +
> > +     return err;
> >  }
>
> I did not dig that much into tag_8021q.c yet. From seeing this portion,
> I'm just wondering if these two helpers couldn't be part of the same logic
> as they both act upon the "enabled" condition?
>
> Otherwise I have no complains about the series.
>

I thought too about trying to merge the 2 into the same function (not
a lot, though).
But consider that they do different things in the "!enabled" case:
- dsa_8021q_vid_apply: check if this specific vid (provided as
argument) was installed in the bridge, and if so, restore it
- dsa_8021q_restore_pvid: search for the bridge port's pvid, and restore that
I don't think that the end result will look cleaner if I merge these 2 things.

>
> Thanks,
>
>         Vivien

Thanks,
-Vladimir
