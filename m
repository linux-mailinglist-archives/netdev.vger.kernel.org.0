Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869B449D4D1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiAZWFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiAZWFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:05:09 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEF5C06161C;
        Wed, 26 Jan 2022 14:05:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id h7so1620514ejf.1;
        Wed, 26 Jan 2022 14:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OxILoILCkoMLSMTN/6RX7BA5Ckr169OhivC4CXZZE/Y=;
        b=FwSQklzT+27SbdvfgyJEAr62I92RVD7qL22jZex/Lfr6miGFBfr9CYhEfYQsAiDyXm
         ZEMdeWiFkmVPIsFifqZAviKg7QUJDCq6A6kpqnj5/Sc+cGfRSP51Cv58XwAdDd0/nvW/
         BnT02AyRMp3zQPQWscAsH+ZgWd5p+wBUuEzCR7/Bf4kyh4IALjujm8adqAdr7tHAOHqZ
         WqbNDLmWPQqp2cMCUglrdb7iEqhKLrjuHcCPB1d0osjnbKhjsjuF62BZ3cDd1YcBOUA2
         X/vLWcfl9/7nnSK09eC1smKOYUPK0DS/iSVjqefvLxSXtZ8OHMUe4zFYIX4mSibnXWqw
         7+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OxILoILCkoMLSMTN/6RX7BA5Ckr169OhivC4CXZZE/Y=;
        b=lXYHU/8+ovfqMUWzEREaTBNWUF5WwCpvLNrCSDTX6qwLnN0v/9wcw6N71pZP3VoNd2
         x/IRGGC2bNIQiz24Fg3WR+hPYGXUDhRU1aNSJePP6a3aUWx18wDqrT+yV+8zMqJFKl0m
         o95kp5YQFPTtfQl/9eylK5o0nsxVJeIsYg55fPSnqgLGSiFA1dUrZ6iKiBpfj+BSfG27
         zqnYmyl+SUQ3eKRK5N4bHAmk1ox2iaDeAMWQjzkONt3bApzG585Owz/nMe49JPvd/dWf
         hU2Y/KkGSzun4+AT7ACwEbsIIr/PRWncBn2S1OHcPe4y2caD0zZWqpcVSpMozh4UCNNY
         kCfQ==
X-Gm-Message-State: AOAM5302+esNOnlOXSdZvs/s/1C5iHEWsxLbDRhVBR8mrDaE/Px7/csw
        M8wITqrx6hRUSTvx7xdoIqs=
X-Google-Smtp-Source: ABdhPJwyAikVZPjvY7HXg/VKNXDTJVt3BL1FZuLJzBQo5C7iQuIaEYfJldDJ5VTGN6fAFmuH1MTg+g==
X-Received: by 2002:a17:907:7b87:: with SMTP id ne7mr631722ejc.556.1643234707061;
        Wed, 26 Jan 2022 14:05:07 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id by22sm7939933ejb.5.2022.01.26.14.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:05:06 -0800 (PST)
Date:   Thu, 27 Jan 2022 00:05:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy
 read/write with mgmt Ethernet
Message-ID: <20220126220505.iccabgu3olbaxhbi@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-13-ansuelsmth@gmail.com>
 <20220125150355.5ywi4fe3puxaphq3@skbuf>
 <61f08471.1c69fb81.a3d6.4d94@mx.google.com>
 <20220126014854.opnyrd56nsrk7udp@skbuf>
 <YfCqb/qHn0XR8ONV@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfCqb/qHn0XR8ONV@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 02:57:03AM +0100, Ansuel Smith wrote:
> > > > Shouldn't qca8k_master_change() also take phy_hdr_data->mutex?
> > > > 
> > > 
> > > Is actually the normal mgmg_hdr_data. 
> > > 
> > > phy_hdr_data = &priv->mgmt_hdr_data;
> > > 
> > > Should I remove this and use mgmt_hdr_data directly to remove any
> > > confusion? 
> > 
> > I am not thrilled by the naming of this data structure anyway
> > (why "hdr"?), but yes, I also got tricked by inconsistent naming.
> > Please choose a consistent name and stick with it.
> 
> Hdr as header stuff since all this stuff is put in the hdr. Should I
> just drop hdr and use mgmt_data directly? Or mgmt_eth?

I don't have a strong preference because I can't find a good name.
Consistency in naming this feature is the most important part.
Maybe it is just me who is reading it this way, but I associate a
structure whose name contains "hdr" with something that pertains to data
from an skb (such as "mgmt_ethhdr" which is exactly that), hence the
earlier comment. I opened the manual and the phrasing that the vendor
uses is that "[ the switch ] supports the read/write register (sic)
through the Atheros header". So it makes more sense now and it's in line
with that, at least to some degree. I understand if you prefer not to
change it, but "mgmt_data" sounds less confusing to me.
