Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A252683FF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgINFQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgINFQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:16:22 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED55C06174A;
        Sun, 13 Sep 2020 22:16:22 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g10so13742634otq.9;
        Sun, 13 Sep 2020 22:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ga30v+B9brT6ZJU53wEN4m1OEbWQL60LWzi0dKk+nRY=;
        b=rj/Y1151pQq9ax+I30VO3IMSLmqvyKDdBjQ3Fdbm1n6WbwIzubbgueXoliSx3tb2T6
         Yogw5qbSMFmkSrhtSKFlh5vm98M3WR+dcZ2An8BaxPbT6oP5KXGItUnzb6x/FA3X6E9p
         5rTn5Ge2WSCiiV9BmrAMHmmrQQJESb2y9/R+OTF9YNbOw9HUt2ZHgNKm1ZuC27jSl2vY
         COhdKDEn+dJ8id/GGhFMB4HsqI4TS40wjXS7WHvpCyb293I/4bm200KqI6E8SHnrZV7j
         vuRmlO66FU8D7TDS/2zdXreiUneYDEu1U9KmGsKf3DaA/+pMK/B7PgQ+l7ScVT2gbumS
         G0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ga30v+B9brT6ZJU53wEN4m1OEbWQL60LWzi0dKk+nRY=;
        b=TtnrZhtI8NTFvQOgUCb7ne7jRJWnO/YFZiEiHcqvJSwrL5CPN86kiqwxHzVkZ0Kyt2
         4zlPTFZ5WV48Ch0qDcBwsjIfmrePyG/QWSddMLU+n8juC9wzYU2/o+L6Y2d9fKBVXwle
         g3Ejf5648MWWJOfLmDNJ76k7cIbpWbXCni0PG+o7LNncnENBd/VhSMuyErq0WNhFjhoE
         RrDeWU97OqDma/I7HjAM8Q4CeWLKzM9bNuL+RRrZ8m+WvaGunsVEZllfi5qMMHtS39Bf
         u79OsXk989N1He0YlSBvdnJj8Ex37+9QrSrpvShz8IdBQfNWP+pkylZ9kclvuz/q6W8c
         ZxwA==
X-Gm-Message-State: AOAM533eJuBaKxj+pwk8gjwS3YkM0qNfqqRLRhsi/G04vM4ZHQNh5jZP
        xblMjKKFjq/9EgErERK5eLEI7cPHWSRUgd4ntTJAtmT+0HQ=
X-Google-Smtp-Source: ABdhPJxAXdN1qe3FQb6vPyr805HNfEognorXx7iQtzDv1B88Rb9FtSb8XHFyB4T7hcHgrGZFIzyp/U7dA3ajZvc0LS0=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr8097810oth.145.1600060578220;
 Sun, 13 Sep 2020 22:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200912144106.11799-1-oded.gabbay@gmail.com> <20200912144106.11799-13-oded.gabbay@gmail.com>
 <20200914013735.GC3463198@lunn.ch>
In-Reply-To: <20200914013735.GC3463198@lunn.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Mon, 14 Sep 2020 08:15:53 +0300
Message-ID: <CAFCwf12Ea-QVhPX1U=Hri7bbzdx5hkecgSCMgZCF--FODNgeRg@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using coresight
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 4:37 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int gaudi_nic_get_module_eeprom(struct net_device *netdev,
> > +                                     struct ethtool_eeprom *ee, u8 *data)
> > +{
> > +     struct gaudi_nic_device **ptr = netdev_priv(netdev);
> > +     struct gaudi_nic_device *gaudi_nic = *ptr;
> > +     struct hl_device *hdev = gaudi_nic->hdev;
> > +
> > +     if (!ee->len)
> > +             return -EINVAL;
> > +
> > +     memset(data, 0, ee->len);
> > +     memcpy(data, hdev->asic_prop.cpucp_nic_info.qsfp_eeprom, ee->len);
> > +
>
> You memset and then memcpy the same number of bytes?
Thanks for catching this, we will fix it.

>
> You also need to validate ee->offset, and ee->len. Otherwise this is a
> vector for user space to read kernel memory after
> hdev->asic_prop.cpucp_nic_info.qsfp_eeprom. See drivers/net/phy/sfp.c:
> sfp_module_eeprom() as a good example of this validation.
>
>     Andrew

Thanks for the pointer, we will take a look and fix it.
Oded
