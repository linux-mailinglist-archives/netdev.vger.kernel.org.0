Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B127E21A054
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgGIMy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 08:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgGIMyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 08:54:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580CCC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 05:54:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id o5so2141563iow.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24/ET2HxWh0GkoLM7w5zuWzmjh5T8FbYz3qPSsOV6p4=;
        b=B4Szxu6gi8Ox/6Sz9y55Sc8TM15pcjTO2LNntTmHIUCkw3vMM7PWWchVNMxSVlE1X1
         mtii6G5Y3nNtsk/fFW7pQtojJrPbWXGFKv4KgwRuy2x5qSkkFxC1g9q4Y/jVnUib9fFC
         3ZdhpT58LOLJ3mdyZlr0MVo6ZmkWnhnVAZj0HtiIqcN1i6LMeh63+oaIHMupDs4UgB4Z
         NVLSPJ3IQIxO3o3uw3VZvH35AdvkkrjOEUCrgLS38izC7tc+Deqjq5AN9X0ajpVInXdG
         EO+2otnXgFJCUqzZ3xlRF+hFPIYGCHn5bbonxp/Aq2rwnZSwJ0+vjATmoxk3jtX75pmS
         n6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24/ET2HxWh0GkoLM7w5zuWzmjh5T8FbYz3qPSsOV6p4=;
        b=hJZFjAVwPA1MdDKubuxn4kdTOznbiitl8a7Z3tVtOViRuXz/+x3aV6rFqQQknUI1dx
         PwoPdFVET/5CNjUAHpOQ3GBRg+pyzFZVPzLIaNlpyNUn5FB8IfXjZSXwucOGjjrEv6sj
         BldBLGxde6H6ziB2J3LYG2SdgpnXEpBjXYXiRPXsL1vLkjWAHCRJz64QbH0NtM5Kzb9F
         iOJ55xz0Rk5qCv4drRMzR1hitv1C/cJ+Z9GtfdG64ZS4XfLDDfIcV8hZUQ5zbbL0zAj+
         exWX+wGy6rSpujWrGzSwsCviUaF5VU9OQ6DknbPzqiMKdh45CWDsfz2GEcmiVpMUV1K/
         hnEw==
X-Gm-Message-State: AOAM530FtPgP8u6zTgDpUATRL66sVi9cj4Kxg6AasHx8BU0n6epmt7zH
        aqmboYZgkz8XSbHATjrJyvn08SoUz3QrrYBKRTg=
X-Google-Smtp-Source: ABdhPJxdGP5htTaIrON9JwIg39qJq8qlCSSET5lrIhIZ5F3o+38EOBBjSMMxz5QbxpW368MnfeC3vA5gq1dwEPswFvs=
X-Received: by 2002:a6b:197:: with SMTP id 145mr41907622iob.77.1594299293694;
 Thu, 09 Jul 2020 05:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <1594227018-4913-1-git-send-email-sundeep.lkml@gmail.com>
 <1594227018-4913-4-git-send-email-sundeep.lkml@gmail.com> <20200708104056.1ed85daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708104056.1ed85daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 9 Jul 2020 18:24:42 +0530
Message-ID: <CALHRZupLPK22=fia+sRNG5k0HDe7xjxfCOB+tFN5fhZOf4K_-Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Jul 8, 2020 at 11:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  8 Jul 2020 22:20:18 +0530 sundeep.lkml@gmail.com wrote:
> > From: Aleksey Makarov <amakarov@marvell.com>
> >
> > This patch adds PTP clock and uses it in Octeontx2
> > network device. PTP clock uses mailbox calls to
> > access the hardware counter on the RVU side.
> >
> > Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> Please address the new sparse warnings as well:
>
> drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c:130:42: warning: cast to restricted __be64
>
Sure. There are some already existing in octeontx2/ for those I will
fix and submit after this patch set.

> > +static inline void otx2_set_rxtstamp(struct otx2_nic *pfvf,
> > +                                  struct sk_buff *skb, void *data)
> > +{
>
> Please don't use static inline in C files, compiler will know which
> static functions to inline, and static inline covers up unused code.
>
Sure.

Thanks,
Sundeep

> > +     u64 tsns;
> > +     int err;
> > +
> > +     if (!(pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED))
> > +             return;
> > +
> > +     /* The first 8 bytes is the timestamp */
> > +     err = otx2_ptp_tstamp2time(pfvf, be64_to_cpu(*(u64 *)data), &tsns);
> > +     if (err)
> > +             return;
> > +
> > +     skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(tsns);
> > +}
