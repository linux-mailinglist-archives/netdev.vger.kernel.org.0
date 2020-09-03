Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029E425C6CE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgICQaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICQ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:29:59 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55914C061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 09:29:59 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z22so3744990oid.1
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l3vyZwOI3Y14uRnDnLq814uedRJ4X761HNZG25FqH9Q=;
        b=fu0LVmozJssu/dIRMTLdooIEUJeEU+CKNlJdB8hA+ldoQgLMzoD1muHK+SQXYXE8UI
         KrsyE35xrrEBU5wA84t7SlPL5qENw9lNfN2j267ZsaRWq2XGMPramyBuDwCAZ1goOtxi
         ofcXZ6Q4PEFq/tgCsHT59c0MP5WLt5TtrrfD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l3vyZwOI3Y14uRnDnLq814uedRJ4X761HNZG25FqH9Q=;
        b=T27CFA3uc9ZYTnofvkywf6v5AmT04qO6F42ZZ7mtkl2SrUa0fWc1Lu6GrWdp8p4cGx
         R/oEgbNiwstfywtM5MqJ9ksDhAQjgdbwDV+DCDd+lUU9W0NjHn4OKUJUsCLxHQbJXccf
         01G+/iZCmv2hFbEjktvId6is8ez6pRH5spU+s41i9gQSldc5/Vg0W9ZNCyqqzYhB2OWM
         IdJ9UI7FAqvSyBSAEdZ5ToATtSaoFIssmuxdO/X9YYcYn4H7xg9/jwSqQhN/di8l/ITc
         It6Qy+dX5ZqsxgB897mw9ofE/gHPDCdyADIMq1wIcilmBqwFsdUP4Yj8h0Gksg+TNpWq
         7nDQ==
X-Gm-Message-State: AOAM532VW6TuEPnqBiftZeYrchCeDxedL4of52MU+HwKxbaDC9SIVASI
        VX5PCMoKp8yxSIFevFWs0YpQad2I8AV74QbG0+KBQw==
X-Google-Smtp-Source: ABdhPJxPhG7/I9tb8LafKkB56Rk8pJiMlEHGo8c/PIie7vZyRdBSzyT1VtaGhVYSQ2HoVHHqYNFjqs48jYMUvLB7Xwo=
X-Received: by 2002:a54:4e10:: with SMTP id a16mr2634018oiy.166.1599150598532;
 Thu, 03 Sep 2020 09:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200903020336.2302858-1-kuba@kernel.org>
In-Reply-To: <20200903020336.2302858-1-kuba@kernel.org>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 3 Sep 2020 09:29:22 -0700
Message-ID: <CAKOOJTwwZ0wug6Wn6vVmvyWX=vz_n1shu5t_Gf-NT21MP7HMxg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tighten the definition of interface statistics
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, f.fainelli@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz, dsahern@gmail.com,
        Michael Chan <michael.chan@broadcom.com>, saeedm@mellanox.com,
        rmk+kernel@armlinux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 7:03 PM Jakub Kicinski <kuba@kernel.org> wrote:

> +Drivers should report all statistics which have a matching member in
> +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` exclusively
> +via `.ndo_get_stats64`. Reporting such standard stats via ethtool
> +or debugfs will not be accepted.

Should existing drivers that currently duplicate standard stats in the
ethtool list be revised also?

> + * @rx_packets: Number of good packets received by the interface.
> + *   For hardware interfaces counts all good packets seen by the host,
> + *   including packets which host had to drop at various stages of processing
> + *   (even in the driver).

This is perhaps a bit ambiguous. I think you mean to say packets received from
the device, but I could also interpret the above to mean received by the device
if 'host' is read to be the whole physical machine (ie. including NIC hardware)
instead of the part that is apart from the NIC from the NIC's perspective.

> + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.
> + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.

Including or excluding FCS?

> + *   For Ethernet devices this counter may be equivalent to:
> + *
> + *    - 30.3.1.1.21 aMulticastFramesReceivedOK

You mention the IEEE standard in your commit message, but I don't think this
document properly cites what you are referring to here? It might be an idea to
say "IEEE 30.3.1.1.21 aMulticastFramesReceivedOK" here and provide an
appropriate citation reference at the end, or perhaps a link.

Regards,
Edwin Peer
