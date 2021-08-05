Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAC43E1DC8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 23:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241917AbhHEVNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhHEVNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 17:13:13 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD97C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 14:12:58 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id t66so7842513qkb.0
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 14:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bii+dENzpQczwFJFnqixdadN//TRfMZA7JDtAZ/DxNI=;
        b=oRaTfKXPEmNmacHOsRrfUkTy1qxqva26E1mXIcccsmC70jOXfLURI8IqAsk6LWdU7y
         qy0zGrmL7YPjbMv4UdY9u6ZoMcYGsdUyvzux6fUWA+K1GucaFyFOAG3YTlvGeFrUiR3T
         Y7iFtj8suxOoESYtuIOG2M6tyFq+DUcYwBqXS7UgzbLn+erujyeBAYLKP1YATPI0hucv
         V2Z99rOMfwXemgfVigetjZ+4P9Yz5KlyMq6YqSsdlnTePBBzMnvVO+y1woilBr7gEADb
         WoOQNbmKwNreB1zUuOGqD0RCpwlZjlgLxdzPQfRllSfhKO0NQY8n5cC7J7kUiyAYTZ/v
         /s4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bii+dENzpQczwFJFnqixdadN//TRfMZA7JDtAZ/DxNI=;
        b=XxLLvjOlwTqm4ApChO0VzghzfBvO7+2iH8lSoFUS+Rk9LJNO9pPGe2g2lJd/yNbUwS
         vfEVEbuhi7Bw0HvUew7dzSli6S7WYm898ow+HmKG7B3cC0vThB5yp4jRCSyrM187JoBn
         Ya63ymtiMnPCqLdwOqUuqmRCifyCQo+ttZgu3j6v1/NHpP4c/Kt/M8JecWQbyqHUEhEq
         fUAOhJWkZ52TgqdhY+FF8B7qHfPehJHaGimbWLw/kt7PRsNeB7ybVMRMmNVwKRGcD6MM
         t4AzawXkGoq79rGwucTJaDHw7RE5JDtXeL7pVFqMXPWgx9266Nl6KuIkDgRivvz/OxYD
         yoIw==
X-Gm-Message-State: AOAM530tua3KmBCiZNI/UggVCVGL5+PvpTQNQrWwx9Hii+XvS/rrTcnI
        4tpzOWEifEgQogqWErp0KqdlHmQoHZKEjMU5PlY=
X-Google-Smtp-Source: ABdhPJwUMiMnlz0kWB5Wq2Akibygq81zY+AChFeUNEcsCnDqRBSB5j13J5dv7b44nWPT9rEo9pDJor1G/bQAEsqX+wc=
X-Received: by 2002:a05:620a:b9b:: with SMTP id k27mr6969479qkh.469.1628197977694;
 Thu, 05 Aug 2021 14:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <CAGRyCJHYkH4_FvTzk7BFwjMN=iOTN_Y2=4ueY=s3rJMQO9j7uw@mail.gmail.com> <CAAP7ucJhO9E3vzM2-w8V6a5K07_nDQS_V6G78FMWQb-74pRbSQ@mail.gmail.com>
In-Reply-To: <CAAP7ucJhO9E3vzM2-w8V6a5K07_nDQS_V6G78FMWQb-74pRbSQ@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Thu, 5 Aug 2021 23:12:46 +0200
Message-ID: <CAGRyCJEOZbJNUA1wcm6dGriFkBX+UL8x9ioqTjO45pBf4uBOjA@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno gio 5 ago 2021 alle ore 23:01 Aleksander Morgado
<aleksander@aleksander.es> ha scritto:
>
> >> > > I'm playing with the whole QMAP data aggregation setup with a USB
> >> > > connected Fibocom FM150-AE module (SDX55).
> >> > > See https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/71
> >> > > for some details on how I tested all this.
> >> > >
> >> > > This module reports a "Downlink Data Aggregation Max Size" of 32768
> >> > > via the "QMI WDA Get Data Format" request/response, and therefore I
> >> > > configured the MTU of the master wwan0 interface with that same value
> >> > > (while in 802.3 mode, before switching to raw-ip and enabling
> >> > > qmap-pass-through in qmi_wwan).
> >> > >
> >> > > When attempting to create a new link using netlink, the operation
> >> > > fails with -EINVAL, and following the code path in the kernel driver,
> >> > > it looks like there is a check in rmnet_vnd_change_mtu() where the
> >> > > master interface MTU is checked against the RMNET_MAX_PACKET_SIZE
> >> > > value, defined as 16384.
> >> > >
> >> > > If I setup the master interface with MTU 16384 before creating the
> >> > > links with netlink, there's no error reported anywhere. The FM150
> >> > > module crashes as soon as I connect it with data aggregation enabled,
> >> > > but that's a different story...
> >> > >
> >> > > Is this limitation imposed by the RMNET_MAX_PACKET_SIZE value still a
> >> > > valid one in this case? Should changing the max packet size to 32768
> >> > > be a reasonable approach? Am I doing something wrong? :)
> >> > >
> >> > > This previous discussion for the qmi_wwan add_mux/del_mux case is
> >> > > relevant:
> >> > > https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/..
> >> > > The suggested patch was not included yet in the qmi_wwan driver and
> >> > > therefore the user still needs to manually configure the MTU of the
> >> > > master interface before setting up all the links, but at least there
> >> > > seems to be no maximum hardcoded limit.
> >> > >
> >> > > Cheers!
> >> >
> >> > Hi Aleksander
> >> >
> >> > The downlink data aggregation size shouldn't affect the MTU.
> >> > MTU applies for uplink only and there is no correlation with the
> >> > downlink path.
> >> > Ideally, you should be able to use standard 1500 bytes (+ additional
> >> > size for MAP header)
> >> > for the master device. Is there some specific network which is using
> >> > greater than 1500 for the IP packet itself in uplink.
> >> >
> >>
> >> I may be mistaken then in how this should be setup when using rmnet.
> >> For the qmi_wwan case using add_mux/del_mux (Daniele correct me if
> >> wrong!), we do need to configure the MTU of the master interface to be
> >> equal to the aggregation data size reported via QMI WDA before
> >> creating any mux link; see
> >> http://paldan.altervista.org/linux-qmap-qmi_wwan-multiple-pdn-setup/
> >>
> >
> > Right: it's not for the MTU itself, but for changing the rx_urb_size, since usbnet_change_mtu has that side effect.
> >
>
> I knew there was a reason even if not obvious. Should we fix that rx
> urb size value to 16384 to avoid needing that extra step? Was that
> what you were suggesting in that patch that was never merged?
>

Yes, that was my purpose, but thinking about it twice, I thought it
was not a very good idea.

There are too many modems/hosts/firmware versions combinations, each
one of them with its own bunch of bugs/quirks (daily experienced):
after all I think it's better to have the possibility to have the urb
size configurable (even if through an odd way), than to have it fixed.

Regards,
Daniele

>
> --
> Aleksander
> https://aleksander.es
