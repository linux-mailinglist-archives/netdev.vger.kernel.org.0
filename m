Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED53A1BAA99
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD0RAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgD0RAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:00:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F5C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:00:30 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id j20so14043979edj.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUzyJv4+52B14oUQEw3qowBacYUhLgVssWGWS+MIvlA=;
        b=KW0j/LCh+JrC8TyOD4u0wrbGc05TwKbE3gdWmXwmTbajDh9jyM7bqQ+vwsNzBKEbNZ
         aN5Pj6mrwyseuyX1TyF3jdnh7lNiDewZ/oFLe3pI7Qjl/kaL9NF7sxh2CO8jmt3S09lX
         OiFo5FRUGdQ+DREIS01Ktx6rW6H9QPLBjWRFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUzyJv4+52B14oUQEw3qowBacYUhLgVssWGWS+MIvlA=;
        b=ujRM9FNjAJjToS27gBKONQ/GGdM4kNwfsDVX611m4vywT8xlKXz4gb4o8GMUNmDDuJ
         iVpD+vlSmMJ+u26dEqsSdKwCiq7zKNKojyeMHdYG2w2/rrJmbwPuCgertY1VlhYJXKgq
         yssexerzPy9sf0Es8aSRwBF/n64yrv9NeZp75MotwMrHEwiPxfpHk/e56NW3IzMK12BJ
         4u/A32+MBUlk1utG1RINr7QaznDZIPyL3eHqqDGuxUFOgAEzw0iturj4QxFdwYo81aDz
         Pxn9YtBJrCtvyHa7vc2NKlCwY0446f2cd3A9IQF0FFuvxVDFplvs6twyGocxDANKPeuJ
         oHKA==
X-Gm-Message-State: AGi0PubSOWo+K2jdW+2ZY8rSVML6SzWNAW1SF91w7QzhBnfwgj2t3lnk
        TrCfpdfBjCvVS5bvx/iA0yporBYLOWnqkRERGPTf1w==
X-Google-Smtp-Source: APiQypJqYtUh+PJQcIARUBP9RelZ3JKLumf4sZUaUVYuddOjHFBr8nWByP1sKnUHTt6p9Am721UTlHxrLHGZ1AWiKgc=
X-Received: by 2002:aa7:d718:: with SMTP id t24mr5783860edq.20.1588006829514;
 Mon, 27 Apr 2020 10:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
 <1587958885-29540-3-git-send-email-roopa@cumulusnetworks.com> <9d9bc36b-f4bb-0144-5144-52064b350dc4@gmail.com>
In-Reply-To: <9d9bc36b-f4bb-0144-5144-52064b350dc4@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 27 Apr 2020 10:00:20 -0700
Message-ID: <CAJieiUg+oC1Q-EUgYsmGRnmzPb_tnacQ8_6oFC0EavSmOqHEZQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: ipv4: add sysctl for nexthop api
 compatibility mode
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 6:12 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/26/20 9:41 PM, Roopa Prabhu wrote:
> > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> > index 6fcfd31..02029b5 100644
> > --- a/Documentation/networking/ip-sysctl.txt
> > +++ b/Documentation/networking/ip-sysctl.txt
> > @@ -1553,6 +1553,20 @@ skip_notify_on_dev_down - BOOLEAN
> >       on userspace caches to track link events and evict routes.
> >       Default: false (generate message)
> >
> > +nexthop_compat_mode - BOOLEAN
> > +     Controls whether new route nexthop API is backward compatible
> > +     with old route API. By default Route nexthop API maintains
> > +     user space compatibility with old route API: Which means
> > +     Route dumps and netlink notifications include both new and
> > +     old route attributes. In systems which have moved to the new API,
> > +     this compatibility mode provides a way to turn off the old
> > +     notifications and route attributes in dumps. This sysctl is on
> > +     by default but provides the ability to turn off compatibility
> > +     mode allowing systems to run entirely with the new routing
> > +     nexthop API. Old route API behaviour and support is not modified
> > +     by this sysctl
> > +     Default: true (backward compat mode)
> > +
>
> That description is a bit confusing, to me at least. It would be better
> to state what changes happen when the sysctl is disabled. Something like:
>
> New nexthop API provides a means for managing nexthops independent of
> prefixes. Backwards compatibilty with old route format is enabled by
> default which means route dumps and notifications contain the new
> nexthop attribute but also the full, expanded nexthop definition.
> Further, updates or deletes of a nexthop configuration generate route
> notifications for each fib entry using the nexthop. Once a system
> understands the new API, this sysctl can be disabled to achieve full
> performance benefits of the new API by disabling the nexthop expansion
> and extraneous notifications.

sure, I will take what you have. will send v4
