Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1185911FA8C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 19:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLOSwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 13:52:21 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39778 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfLOSwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 13:52:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so4368189pfx.6
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 10:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QnNY+Mw+UVdVWeKYYvlKA4C+OdsBsnlX2ZtfFoGOHL0=;
        b=yNmSUGT9fXfYeBddmaS3QYt97onm53IgZs9RKXw8p+RDGz63GBsW5QbRrVqI2IIbvb
         LdBeq8l9SBnxJiSnCu6vtyEioBuYPj29AtlfQ4dU0hgEJdQ6qgG5EysdLgB4QLmaSUe1
         Rm7wckgFqz16+opDRLkvd7zHNivq+jWKwAKMtgvNdimevZcFnEJZTQvkO6GeOLbSqrpf
         ypLZ3TzN5zqjVRmRAxSo3Xo72FT0oHuLNt5CNg28zX565RK1AOykg7PcLfjmqmU8TXXH
         2CCJVDc64gFBeeVVo2K1fPjqmSDruJSX8bIwHvBV7z2RrAOnNVgqtdndVHxLEwCzLa1v
         T8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QnNY+Mw+UVdVWeKYYvlKA4C+OdsBsnlX2ZtfFoGOHL0=;
        b=X24mYk6l+cT7JzU32agudfTI9HpQuhB26zMsDBvRZp87qAYDDjRY2JuETHbbo+DOCA
         1po3V+dTUs+TGpqfD5VL51mkkRlU+/fpYRBWH9iyylW9NptQwNbCqm9MFzmEas290NUI
         LiL89Pq+EQ+O43E5xdwa6sXt2wex++p8HC9y/jO/+njl3b3cysZTCHlqZpc54MMEtFzW
         nLTFwvqj8izbIT/yhZjIF2Sk7Oxv1u/RmHlDN/Gwaof/JTuBs3+vMiSKOswuRZofvKpb
         DTZrsoMrJuUG8tzC+hwfMfhhJksRlxspVCll+9opu/5EtVmoZiIB73bjUO5uV6vTZFCL
         o7Ew==
X-Gm-Message-State: APjAAAUwIOmfHhWxkNKY3tCdxQ+7kV5vOfnn/9wShXIg+ZHKutH4qdQP
        4Bnqk1FYhWoptp5oDQGHwY4epA==
X-Google-Smtp-Source: APXvYqwIHaYLj97P+Ar5TEr7VF035L68ohjENGS5/kMDH7RlupJAWbewR6YVVDvvHMi6tGhZUN51vA==
X-Received: by 2002:a62:b418:: with SMTP id h24mr12095255pfn.137.1576435940673;
        Sun, 15 Dec 2019 10:52:20 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b98sm16829404pjc.16.2019.12.15.10.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 10:52:19 -0800 (PST)
Date:   Sun, 15 Dec 2019 10:52:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
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
Message-ID: <20191215105216.4a4f3fad@cakuba.netronome.com>
In-Reply-To: <20191215091120.24e581e1@hermes.lan>
References: <1576103187-2681-1-git-send-email-haiyangz@microsoft.com>
        <20191214113025.363f21e2@cakuba.netronome.com>
        <MN2PR21MB1375F30B3BEEF42DFDB3D39ECA560@MN2PR21MB1375.namprd21.prod.outlook.com>
        <20191215091120.24e581e1@hermes.lan>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Dec 2019 09:11:20 -0800, Stephen Hemminger wrote:
> > > On Wed, 11 Dec 2019 14:26:27 -0800, Haiyang Zhang wrote:    
> > > > Host can provide send indirection table messages anytime after RSS is
> > > > enabled by calling rndis_filter_set_rss_param(). So the host provided
> > > > table values may be overwritten by the initialization in
> > > > rndis_set_subchannel().
> > > >
> > > > To prevent this problem, move the tx_table initialization before calling
> > > > rndis_filter_set_rss_param().
> > > >
> > > > Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after    
> > > subchannels open")    
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>    
> > > 
> > > Applied, but there are two more problems with this code:
> > >  - you should not reset the indirection table if it was configured by
> > >    the user to something other than the default (use the
> > >    netif_is_rxfh_configured() helper to check for that)    
> > 
> > For Send indirection table (tx_table) ethtool doesn't have the option 
> > to set it, and it's usually provided by the host. So we always initialize 
> > it...
> > But, yes, for Receive indirection table (rx_table), I will make a fix, so 
> > it will be set to default only for new devices, or changing the number 
> > of channels; otherwise it will remain the same during operations like 
> > changing MTU, ringparam.

Thank you!

> > >  - you should use the ethtool_rxfh_indir_default() wrapper    
> > For rx_table, we already use it:
> >                 rndis_device->rx_table[i] = ethtool_rxfh_indir_default(
> > For tx_table, I know it's the same operation (%, mod), but this wrapper 
> > function's name is for rx_table. Should we use it for tx_table too?
> >   
> > > 
> > > Please fix the former problem in the net tree, and after net is merged
> > > into linux/master and net-next in a week or two please follow up with
> > > the fix for the latter for net-next.    
> > 
> > Sure.
> > 
> > Thanks,
> > - Haiyang
> >   
> As Haiyang said, this send indirection table is unique to Hyper-V it is not part of
> any of the other device models. It is not supported by ethtool. It would not be
> appropriate to repurpose the existing indirection tool; the device already uses
> the receive indirection table for RSS.

I see, I got confused by the use of the term RSS.
