Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5AF11F989
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 18:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLORLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 12:11:32 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41338 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfLORLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 12:11:30 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so2295823pgk.8
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 09:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gIhKjqXFZFihOuTqCYQ9SMFzjz9Xta5r8J8lgbXYpgY=;
        b=SKPoVh4mDvHViOs7XKg3U0rBm8HOrt5iWnSjK1E83GV7RiEfUC8/+gB00diouZlOTc
         +WpLcbbcWKfnp7dXFYm16Q7hRaMvQyDBUlT2G7MVbb/lt56UOHp6RXPtbwmjPQMtwVdI
         Al4WgZdcw4ME/icYtaPl9/OjsnyPPLrhfHIcPLHH3qm9GA5UWqEN08O3pJHanvvsIiQ9
         Y88bHL5nAOwHkWz/WZIq2g0Ge6PArgBtxSlbCAKYoCBi/VV5WWHjhGt76s273FGhaE+R
         BGwoVdmAd1yQrakfrgtoFTtlIlzuoas/uuPOkdP7OkUfiDUS6//zkhqfJwWDVleZlW72
         edAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gIhKjqXFZFihOuTqCYQ9SMFzjz9Xta5r8J8lgbXYpgY=;
        b=TgBYOAfJPJt/jTHhHdp09XKKGXm4nTMwsHupsBzI6+1ycz27VEN+bGe2Ue274wT91Z
         QSopdFk5aq2oZ7t0/h8RUMgYYvOY5pcGqVpZwnvscaY8CjFuVmGjHoLdF4HHKSsGOgl/
         S2nV6zj2RGz7mfQGavewjh1yvQrQSWH4z8bTB+xaMehhQzjQYcZJJf5fItaPsACTbccA
         Ci67uFcZsQ2rhsLFrGMDqud+UwSJAwAl8mRhE/S0MnmBWdkoyMvabH0OG9odzuVsSPR+
         vOYoRtlQNYuuAwh7g+ALFN+D7y6zJPeFGYUGzcpdRfg2wlIM7Rglb/UAt+kYtji1q/uO
         UAQg==
X-Gm-Message-State: APjAAAU5+EbHNL4/oOkVb8QOxiE+fGPNeJrpbx4vXuLzVE2txHmF35mZ
        3nS7PVVfO+awvLHVdWXQLMI8sw==
X-Google-Smtp-Source: APXvYqyEf/392Icr1o5JSGcmxYTTTRzsvWVgWW0xiuqgFihnu5/rq+BxN+5JgU25+nnQe9ICy5wzJA==
X-Received: by 2002:a62:e50d:: with SMTP id n13mr11209412pff.201.1576429889133;
        Sun, 15 Dec 2019 09:11:29 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id in6sm15877804pjb.8.2019.12.15.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 09:11:28 -0800 (PST)
Date:   Sun, 15 Dec 2019 09:11:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2,net] hv_netvsc: Fix tx_table init in
 rndis_set_subchannel()
Message-ID: <20191215091120.24e581e1@hermes.lan>
In-Reply-To: <MN2PR21MB1375F30B3BEEF42DFDB3D39ECA560@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1576103187-2681-1-git-send-email-haiyangz@microsoft.com>
        <20191214113025.363f21e2@cakuba.netronome.com>
        <MN2PR21MB1375F30B3BEEF42DFDB3D39ECA560@MN2PR21MB1375.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Dec 2019 16:38:00 +0000
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Saturday, December 14, 2019 2:30 PM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
> > KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> > <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v2,net] hv_netvsc: Fix tx_table init in rndis_set_subchannel()
> > 
> > On Wed, 11 Dec 2019 14:26:27 -0800, Haiyang Zhang wrote:  
> > > Host can provide send indirection table messages anytime after RSS is
> > > enabled by calling rndis_filter_set_rss_param(). So the host provided
> > > table values may be overwritten by the initialization in
> > > rndis_set_subchannel().
> > >
> > > To prevent this problem, move the tx_table initialization before calling
> > > rndis_filter_set_rss_param().
> > >
> > > Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after  
> > subchannels open")  
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>  
> > 
> > Applied, but there are two more problems with this code:
> >  - you should not reset the indirection table if it was configured by
> >    the user to something other than the default (use the
> >    netif_is_rxfh_configured() helper to check for that)  
> 
> For Send indirection table (tx_table) ethtool doesn't have the option 
> to set it, and it's usually provided by the host. So we always initialize 
> it...
> But, yes, for Receive indirection table (rx_table), I will make a fix, so 
> it will be set to default only for new devices, or changing the number 
> of channels; otherwise it will remain the same during operations like 
> changing MTU, ringparam.
> 
> 
> >  - you should use the ethtool_rxfh_indir_default() wrapper  
> For rx_table, we already use it:
>                 rndis_device->rx_table[i] = ethtool_rxfh_indir_default(
> For tx_table, I know it's the same operation (%, mod), but this wrapper 
> function's name is for rx_table. Should we use it for tx_table too?
> 
> > 
> > Please fix the former problem in the net tree, and after net is merged
> > into linux/master and net-next in a week or two please follow up with
> > the fix for the latter for net-next.  
> 
> Sure.
> 
> Thanks,
> - Haiyang
> 
As Haiyang said, this send indirection table is unique to Hyper-V it is not part of
any of the other device models. It is not supported by ethtool. It would not be
appropriate to repurpose the existing indirection tool; the device already uses
the receive indirection table for RSS.
