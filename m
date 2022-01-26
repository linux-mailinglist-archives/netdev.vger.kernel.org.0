Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA449C0F0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 02:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiAZB5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 20:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiAZB5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 20:57:24 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99828C06161C;
        Tue, 25 Jan 2022 17:57:23 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id s5so34999682ejx.2;
        Tue, 25 Jan 2022 17:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ber9czAFymKJK5Nu9iiNkdrLf5dXe2HxggUhTVl2qPs=;
        b=g6yHp30iuMyCGV/f57l1JQCfLpNILbuuubyvEfqfMSVZYMB8epYXbCXl1PIaKLxn9M
         AxTOnks+EjvjPMpognpUskzE3pmYqnbZUQCEI6hVCBosEi20FfsoSqX7N2ADkFSm56wa
         EU3FS8tZTAn92ZoDZfnOAh/6klKCJVMdEq8OF3OvPVOQE70WjzRn0dVpHY8wmzLvcMw/
         w/A+XaYQtOHR8X2DBO8S0ktGYHTs3+4qMy6cXyF62vXhvKbvM0EQJcafT3GLVELp86EZ
         YDHOBA98S29FXgV1GN74PbfLRipoFpsl4hNenuyIrJreQp4l+jlfDFRExzeOswwokb7U
         MCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ber9czAFymKJK5Nu9iiNkdrLf5dXe2HxggUhTVl2qPs=;
        b=P0cmEMf/cwVlFxQVIxoSCuWR/k4AuL1mRZHbLUKsrNj1nYQmX6+me+iYBScUV72utd
         EOIJ4GnwHoQaX2NbBR5SnPaUfgGz40qq8tzMVsj1PmIrZlZeJNsYn2xosEay4BMa3bZ0
         wj1qqXo0L63Ou7S9eLwQjmWHlinpI5e2iDSY9ylE9/4Fwc7aDAWQmSHaS7fWHhWTOmOa
         pwaVPjwOYP0BQUel6g44U8bNeCbtr5IlvoP8uf1UYyubCgYwgfDiYjJzdHbn7tukZyMR
         geZyr5e3HLpvczVH1C9DP+Pxz83UwndPGtOGSWvuebSSMEmCj3IKTCw8l3wiJjqM76Gq
         dZBQ==
X-Gm-Message-State: AOAM533sAWP3t+klXjA5kX0JREVR7bZgSKXTWtLQ6Q6luZYbtU7KPK3b
        p49vGu7ywmSN1iJo6XjkS5Q=
X-Google-Smtp-Source: ABdhPJzns8HqDuDMWwv9qnqwTso18n3dyT7nM4kBIXMS/UJjPKM+sGBLxm8LhCxudbAxQ3bNtXbbHQ==
X-Received: by 2002:a17:906:148d:: with SMTP id x13mr7432802ejc.225.1643162241609;
        Tue, 25 Jan 2022 17:57:21 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id z24sm5644523ejn.101.2022.01.25.17.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 17:57:21 -0800 (PST)
Date:   Wed, 26 Jan 2022 02:57:03 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy
 read/write with mgmt Ethernet
Message-ID: <YfCqb/qHn0XR8ONV@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-13-ansuelsmth@gmail.com>
 <20220125150355.5ywi4fe3puxaphq3@skbuf>
 <61f08471.1c69fb81.a3d6.4d94@mx.google.com>
 <20220126014854.opnyrd56nsrk7udp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126014854.opnyrd56nsrk7udp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 03:48:54AM +0200, Vladimir Oltean wrote:
> On Wed, Jan 26, 2022 at 12:14:55AM +0100, Ansuel Smith wrote:
> > > At some point, you'll have to do something about those sequence numbers.
> > > Hardcoding 200 and 400 isn't going to get you very far, it's prone to
> > > errors. How about dealing with it now? If treating them as actual
> > > sequence numbers isn't useful because you can't have multiple packets in
> > > flight due to reordering concerns, at least create a macro for each
> > > sequence number used by the driver for packet identification.
> > 
> > Is documenting define and adding some inline function acceptable? That
> > should make the separation more clear and also prepare for a future
> > implementation. The way I see an use for the seq number is something
> > like a global workqueue that would handle all this stuff and be the one
> > that handle the seq number.
> > I mean another way would be just use a counter that will overflow and
> > remove all this garbage with hardcoded seq number.
> > (think will follow this path and just implement a correct seq number...)
>
> Cleanest would be, I think, to just treat the sequence number as a
> rolling counter and use it to match the request to the response.
> But I didn't object to your use of fixed numbers per packet type, just
> to the lack of a #define behind those numbers.
>

I'm just implementing this. (rolling counter)

> > > > +	mutex_lock(&phy_hdr_data->mutex);
> > > 
> > > Shouldn't qca8k_master_change() also take phy_hdr_data->mutex?
> > > 
> > 
> > Is actually the normal mgmg_hdr_data. 
> > 
> > phy_hdr_data = &priv->mgmt_hdr_data;
> > 
> > Should I remove this and use mgmt_hdr_data directly to remove any
> > confusion? 
> 
> I am not thrilled by the naming of this data structure anyway
> (why "hdr"?), but yes, I also got tricked by inconsistent naming.
> Please choose a consistent name and stick with it.

Hdr as header stuff since all this stuff is put in the hdr. Should I
just drop hdr and use mgmt_data directly? Or mgmt_eth?

-- 
	Ansuel
