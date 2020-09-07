Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADE25FD42
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgIGPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbgIGPgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:36:37 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892FDC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 08:36:29 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id c127so1828767vsc.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nJEsEWjWRZObVJF4DyxZILWVHWpY6Co2ImRdKDFB6Bk=;
        b=Rmd0HzKEhIYWj4J0+ibVku7J26nrdN7aK/pIQ5FwuU+LGlR797B1TVsy0Nn8QC3JoE
         sQCrtCQxeOYzHfyZPBDBdk/aH9ZL8wgJhgnKbNJMVpxK76oXl2mu4RbUixYjke0kQ6B4
         7+ukuVyPkqyHD8iWKJlOojYj9GQLZwiqIhpprzIq2dh4YVrCiGyCfAkT1cSkReyJOc0+
         4Dn+QZbIgHOBVHxeDhl3FazNXEkLOScRWu+/YR9LZNTM3pU02c8jeT5l4dhpODuJbMAL
         D/SfkC2vIbbt6wBqh/p1/AKsQ4L1CIzC0aq2/1K3p6VHBHVlxvNUeYNM4/Q/IESfHskU
         XPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nJEsEWjWRZObVJF4DyxZILWVHWpY6Co2ImRdKDFB6Bk=;
        b=RY5BM5NSZFHNSOz7PzrvH4hTjYKZytHGrQ+7nVtv+z7Jm97G5tg9UvxENDYGeK21tx
         iCKlurcKAx8dg34AKA8oxHPR2q/l4/vmqHT9LdjxQUv99apWn3AbTotCcyJiOS4nqPK9
         p8zQtzfjeoDAhfWaNWidLIHbIDOu8PumzxqDvlgHpOUP73grxxOTcmM5iYAezji/JxZW
         p5FVc8cqgfGyMMaU94IRiiFWZN39Elh064Ggil67k1PF0xZdKIEPA1jKjYv48mOl6vAW
         WyHpDHD6N48I+uQCfWEpoIRm3Em5iyyocOjR/J9ISZITsViMKCBkZx+QlGc967dD3hb4
         /uxA==
X-Gm-Message-State: AOAM530cp1YYfav6UlH90aMi1sbgmFS9RbAkqyMPhuAKrG9GlCzb43kx
        RosuPjmg5P9ypNSyYg5+EvQa22ILytpDKA==
X-Google-Smtp-Source: ABdhPJxq9Y/fMgaGe0n6hxqyQ1YpjYvkiltsh0qXvFao/PhJJw8Rbu81ETszdSrK5YkaXjre8+NXJQ==
X-Received: by 2002:a67:c31d:: with SMTP id r29mr11997736vsj.0.1599492987828;
        Mon, 07 Sep 2020 08:36:27 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id p3sm2429204vkd.41.2020.09.07.08.36.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 08:36:27 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id y15so4256806uan.9
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:36:26 -0700 (PDT)
X-Received: by 2002:ab0:60d7:: with SMTP id g23mr11098331uam.122.1599492985684;
 Mon, 07 Sep 2020 08:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
 <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com> <126e5424-2453-eef4-d5b6-adeaedbb6eca@huawei.com>
In-Reply-To: <126e5424-2453-eef4-d5b6-adeaedbb6eca@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Sep 2020 17:35:48 +0200
X-Gmail-Original-Message-ID: <CA+FuTSecsVRsOt7asv7aHGvAXCacHGYwbG1a1X9ynL83dqP8Bw@mail.gmail.com>
Message-ID: <CA+FuTSecsVRsOt7asv7aHGvAXCacHGYwbG1a1X9ynL83dqP8Bw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: two updates related to UDP GSO
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 3:38 PM tanhuazhong <tanhuazhong@huawei.com> wrote:
>
>
>
> On 2020/9/7 17:22, Willem de Bruijn wrote:
> > On Sun, Sep 6, 2020 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Sat, 5 Sep 2020 14:11:11 +0800 Huazhong Tan wrote:
> >>> There are two updates relates to UDP GSO.
> >>> #1 adds a new GSO type for UDPv6
> >>> #2 adds check for UDP GSO when csum is disable in netdev_fix_features().
> >>>
> >>> Changes since RFC V2:
> >>> - modifies the timing of setting UDP GSO type when doing UDP GRO in #1.
> >>>
> >>> Changes since RFC V1:
> >>> - updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
> >>>    and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
> >>>    - add #2 who needs #1.
> >>
> >> Please CC people who gave you feedback (Willem).
> >>
> >> I don't feel good about this series. IPv6 is not optional any more.
> >> AFAIU you have some issues with csum support in your device? Can you
> >> use .ndo_features_check() to handle this?
> >>
> >> The change in semantics of NETIF_F_GSO_UDP_L4 from "v4 and v6" to
> >> "just v4" can trip people over; this is not a new feature people
> >> may be depending on the current semantics.
> >>
> >> Willem, what are your thoughts on this?
> >
> > If that is the only reason, +1 on fixing it up in the driver's
> > ndo_features_check.
> >
>
> Hi, Willem & Jakub.
>
> This series mainly fixes the feature dependency between hardware
> checksum and UDP GSO.
> When turn off hardware checksum offload, run 'ethtool -k [devname]'
> we can see TSO is off as well, but udp gso still is on.

I see. That does not entirely require separate IPv4 and IPv6 flags. It
can be disabled if either checksum offload is disabled. I'm not aware
of any hardware that only supports checksum offload for one of the two
network protocols.

Alternatively, the real value of splitting the type is in advertising
the features separately through ethtool. That requires additional
changes.
