Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2C23526D
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgHAMp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgHAMp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 08:45:58 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E883C06174A;
        Sat,  1 Aug 2020 05:45:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so18600724plx.6;
        Sat, 01 Aug 2020 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFe+K+RIpsuMdBoFu+zsJoKd01qjdO0sdJp2aF1Jixg=;
        b=ju1mKBvsuq7y2HUb+aIDhl5DEV8iocOWdju1zhvKCa6TpDFsEL1p9NXDWrPnPiGaqN
         DeaF6GU5pXB+TZwo/vz2aU1jvyXNZLNugAtBCTcRLfaGI1yneAu2DWBoje4/EqH2F+K1
         K6fpnG1ZV04ycAVtJjeZlE4Vk/kSsFJbGqCEVK29X5/jar4xMbtrOBCViKyukx6vfi7j
         8Ai6G/WrNpZtVl0aze1Z5GblW3Eo9MI3ITje7eed6Cp77zwNpiWcm6kI2vPBTnDvreKm
         AZjKEjyGnRVBcADdoQ7C+1M+DfQtmPEA78TZgdPOSUkNrYMIXJKw6cwW/mA5+DB3ih1k
         LnIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFe+K+RIpsuMdBoFu+zsJoKd01qjdO0sdJp2aF1Jixg=;
        b=nBxnfjMdpxBx6knFxblN9wYRwkQX0bidn8wzRXF3xYuQ0y1ZzvHwPRs7UzKXhskjSm
         KWaNN4yYO5ikYG8xnFxRhYpJS4sYQKXFvLHf+38OaS6QeGNKEe3VZYH5/GQidWR+Y0MS
         cl/MUP8Qaf02jKV3vpRnldgZofUsDEimjgkawfrL74UdVyPtjZCSORoKFqjYsM2PL3WO
         +SmmmDX3g3hHTz8zmogHMUJDtciGzzS4CGFdqzKYHvzWTmoffmVZPqvsRsTuzXrcGZ2R
         EqATTZ0sfFZoYiqfDVtE+FH/mSqEqJ4y2O6BQRP5MBOjqCh26eEOOF5NzGrFr8UDEp6H
         MTzw==
X-Gm-Message-State: AOAM533TRI7xVsCuvZjaD72fNUIb3STIvyoaaOnCmzYmsoUUFyI823DZ
        6mk0uUzaTrpcAVZrpbgxQrEmELhiMW+hHVxcB9k=
X-Google-Smtp-Source: ABdhPJwCeSTSwShKQcPXNlapNXD0FdH0+2CcK/Eqlkm6aXKtmmzQSmYKog89Oo7z0QxTvYkFuVnkDXR18gR8bXXT/QI=
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr7860775plp.322.1596285958111;
 Sat, 01 Aug 2020 05:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com> <CAJht_ENjHRExBEHx--xmqnOy1MXY_6F5XZ_exinSfa6xU_XDJg@mail.gmail.com>
 <CA+FuTSf_nuiah6rFy-KC1Taw+Wc4z0G7LzkAm-+Ms4FzYmTPEw@mail.gmail.com>
 <CAJht_ENYxy4pseOO9gY=0R0bvPPvs4GKrGJOUMx6=LPwBa2+Bg@mail.gmail.com> <CA+FuTSeusqdfkqZihFhTE9vhcL5or6DEh8UffaKM2Px82z6BZQ@mail.gmail.com>
In-Reply-To: <CA+FuTSeusqdfkqZihFhTE9vhcL5or6DEh8UffaKM2Px82z6BZQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 1 Aug 2020 05:45:46 -0700
Message-ID: <CAJht_EO4b=jC8KarwZyF1M3T57MrFCDvo-+Agnm9qD4pSCmODQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 7:33 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> I quickly scanned the main x.25 datapath code. Specifically
> x25_establish_link, x25_terminate_link and x25_send_frame. These all
> write this 1 byte header. It appears to be an in-band communication
> means between the network and data link layer, never actually ending
> up on the wire?

Yes, this 1-byte header is just a "fake" header that is only for
communication between the network layer and the link layer. It never
ends up on wire.

I think we can think of it as the Ethernet header for Wifi drivers.
Although Wifi doesn't actually use the Ethernet header, Wifi drivers
use a "fake" Ethernet header to communicate with code outside of the
driver. From outside, it appears that Wifi drivers use the Ethernet
header.

> > The best solution might be to implement header_ops for X.25 drivers
> > and let dev_hard_header create this 1-byte header, so that
> > hard_header_len can equal to the header length created by
> > dev_hard_header. This might be the best way to fit the logic of
> > af_packet.c. But this requires changing the interface of X.25 drivers
> > so it might be a big change.
>
> Agreed.

Actually I tried this solution today. It was easier to implement than
I originally thought. I implemented header_ops to make dev_hard_header
generate the 1-byte header. And when receiving, (according to the
requirement of af_packet.c) I pulled this 1-byte header before
submitting the packet to upper layers. Everything worked fine, except
one issue:

When receiving, af_packet.c doesn't handle 0-sized packets well. It
will drop them. This causes an AF_PACKET/DGRAM socket to receive no
indication when it is connected or disconnected. Do you think this is
a problem? Actually I'm also afraid that future changes in af_packet.c
will make 0-sized packets not able to pass when sending as well.

> Either lapbeth_xmit has to have a guard against 0 byte packets before
> reading skb->data[0], or packet sockets should not be able to generate
> those (is this actually possible today through PF_PACKET? not sure)
>
> If SOCK_DGRAM has to always select one of the three values (0x00:
> data, 0x01: establish, 0x02: terminate) the first seems most sensible.
> Though if there is no way to establish a connection with
> PF_PACKET/SOCK_DGRAM, that whole interface may still be academic.
> Maybe eventually either 0x00 or 0x01 could be selected based on
> lapb->state.. That however is out of scope of this fix.

Yes, I think the first solution may be better, because we need to have
a way to drop 0-sized DGRAM packets (as long as we need to include the
1-byte header when sending DGRAM packets) and I'm not aware
af_packet.c can do this.

Yes, I think maybe the best way is to get rid of the 1-byte header
completely and use other ways to ask the driver to connect or
disconnect, or let it connect and disconnect automatically.

> Normally a fix should aim to have a Fixes: tag, but all this code
> precedes git history, so that is not feasible here.

Thanks for pointing this out!
