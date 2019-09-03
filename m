Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B3EA605D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfICE6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:58:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39812 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfICE6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:58:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so15882204wra.6
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPI096z4NEBuTTFH5drqrRRjUYhbkf2dUb1il6NQp5Y=;
        b=NmdgCo7sNmYbJNMxrV8Q+YnV7qAlcylwQ8ygNCxYVkmhVE3BxSrQ3ajvE9jFMpeddv
         rzuHzVduSz7OkNwg0GO86s8dQCqRgSlKNE+tf//IHPDT7/0tkaZ7K7MX8wM/XnChXfAj
         qZmmQZoHPmYMBQMg77/gEDzZHkywr1PAaTOECV3xHCziZdZGlBqXRNsUiEO7i/22Wpp+
         O+bQulY/R9nXQI+aMFgKE+18ZqcIQx3YWn70bX1NBJXwrmgjoYfyoJQOyB4rdspPXL1G
         bCTnHS0ySLHoUOi/LBfDFS09Gf7lq1tIv37ja8r8rKcGsqYPANctc/wHqQgKLhY0zkPP
         YKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPI096z4NEBuTTFH5drqrRRjUYhbkf2dUb1il6NQp5Y=;
        b=BxHkIFlENeQhFHgS/5p4m5nQQXeALv40QbRTvJsS77nGNDgRQ3tPQwp8aL51jfWKgT
         01EsPjCbp2gjwFvepSIB9IgJxyFtbrnVp5pC1HLem/FFYLVP1n8P/TS+RIFpJ4ND/Qpa
         NTQl/W5lDTYVaoNp7BiYKbhwwnJYmweYMZ3gTd/5j0We9h2TsA2R0CPWekI681AyXQ0y
         ZTa8eXYuO1sArgoW8xicauxkBTMiWIuGm/jB/HWpkoZoFDEeraPHO9LCkW63x3ovhIw0
         qJsqekcp8ONUzFLNHjp9RUikJepi03EaQqE+6M2LHHQoCEUHYSl0wxjH5v5QSVvEffuE
         +rwg==
X-Gm-Message-State: APjAAAW4FxH6CdJRywmeXM9wYRcRbZeVC9PTjQLH+06Jhr6p99/mcioa
        2PUB97bdFVbHcB70V30maLSHtrcuQ57AdAGvfmWPSA==
X-Google-Smtp-Source: APXvYqwMWu6Wr03kIVK2hokN58YNIoVF9sAlM7LJUVTEIvAVqqGUuaHS4bNd8hfOKYU8Ynq/f90z7mVHVP9EQSEr1CI=
X-Received: by 2002:adf:e603:: with SMTP id p3mr9235132wrm.102.1567486699818;
 Mon, 02 Sep 2019 21:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190901174759.257032-1-zenczykowski@gmail.com>
 <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
 <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com> <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com>
In-Reply-To: <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Tue, 3 Sep 2019 13:58:07 +0900
Message-ID: <CAKD1Yr2ykCyEiUyY4R+hYoZ+eWGjbE78wtSf2=_ZjLpCyp0n-Q@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 11:18 AM David Ahern <dsahern@gmail.com> wrote:
> addrconf_f6i_alloc is used for addresses added by userspace
> (ipv6_add_addr) and anycast. ie., from what I can see it is not used for RAs

Isn't ipv6_add_addr called by addrconf_prefix_rcv_add_addr, which is
called by addrconf_prefix_rcv, which is called by
ndisc_router_discovery? That is what happens when we process an RA;
AFAICS manual configuration is inet6_addr_add, not ipv6_add_addr.

Maciej, with this patch, do SLAAC addresses still have RTF_ADDRCONF?
Per my previous message, my assumption would be no, but I might be
misreading the code.
