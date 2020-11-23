Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCEC2C02FC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgKWKIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgKWKIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:08:16 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF426C0613CF;
        Mon, 23 Nov 2020 02:08:14 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x24so2176887pfn.6;
        Mon, 23 Nov 2020 02:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq+GpfO2gw/px08Gc8Ao87p67ooWQK82Ig1Fe5tdBxQ=;
        b=mHnsPITnNU+s25kR1sMD6EGzHhppd68DOyo0El7jQGNzKNfOILf7LxeWw3vN2AuRCg
         cVIi0E8kKAWV3jvH5UC2C2KfkfAoAsCa6hOBrUyBmspU9Kzx0iWAgLPPseWDsaxMezQe
         06nYSprynZb+9kb90ljsXaq1IAdETsok4Cb4eq+6vrs/6mjhRH1hf45PKAuCsvWICMUq
         2dPPoji5Hx5td+6CrMuojI10lL53dU0fRmnAgi3krYky8E/VVLDHWj5yktF/LPS2VgTx
         j6z2m84lTOyDeoK3JIZMsGqeSnzlXB0D6cXuKBWH+PWoKlNqoQqRjAStqUTMIOt89WBV
         1OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pq+GpfO2gw/px08Gc8Ao87p67ooWQK82Ig1Fe5tdBxQ=;
        b=Le4s3FphfZf4Nu2zJkKJqC1Fn6/WR/78xi1FyvPXYWxuck/j06QJXipOnbG+iTyXOb
         kQyEqClQ32G+0u38XS4/hkPczBXz5akqdTPKBL6wNl9g0aXOd2zRyYeYN7u7jrnoSoUq
         cB//mJZ3NItOhazrX9F8Zd4ByDRznGa6awjXx3FZ4fVe2WjOyr+3MbJQfoQhc3AiUQYN
         59dw4/K8qk60eJuUdtPTmOqAkE8+9iMW8A0SAdDAeP2Bh4DkV80LSPP9U4bUjH5KLRlU
         0+BopVLiqcvEM5hJuwc267/HXNGKb0ZMcg0oNBxbasr3BYhBxGoeIoi/iGuUGED+MF2t
         S9Og==
X-Gm-Message-State: AOAM532EUshgoIumSVYWeE+V88KhiGbAJTAcAUpFssi9oDDAGY00LGyA
        PPkxaRDbfDWXlDaeW+gZhwG9AZBpKmsQdPfVYrtMCX+WmUo=
X-Google-Smtp-Source: ABdhPJwOl6MN766kwT1IyuhwcGbndBX2wq7s6AtGjLzjNTGUBeHeDVuplDzZeFxVzBZSYhGiaM7DG+SdVxzN0BwtDH8=
X-Received: by 2002:a62:170a:0:b029:196:5765:4abc with SMTP id
 10-20020a62170a0000b029019657654abcmr24618032pfx.4.1606126094535; Mon, 23 Nov
 2020 02:08:14 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de> <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de> <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
In-Reply-To: <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 23 Nov 2020 02:08:03 -0800
Message-ID: <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 1:36 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> Some drivers don't support carrier status and will never change it.
> Their carrier status will always be UP. There will not be a
> NETDEV_CHANGE event.
>
> lapbether doesn't change carrier status. I also have my own virtual
> HDLC WAN driver (for testing) which also doesn't change carrier
> status.
>
> I just tested with lapbether. When I bring up the interface, there
> will only be NETDEV_PRE_UP and then NETDEV_UP. There will not be
> NETDEV_CHANGE. The carrier status is alway UP.
>
> I haven't tested whether a device can receive NETDEV_CHANGE when it is
> down. It's possible for a device driver to call netif_carrier_on when
> the interface is down. Do you know what will happen if a device driver
> calls netif_carrier_on when the interface is down?

I just did a test on lapbether and saw there would be no NETDEV_CHANGE
event when the netif is down, even if netif_carrier_on/off is called.
So we can rest assured of this part.
