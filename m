Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E505349C263
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiAZEBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiAZEBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:01:34 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D64C06161C;
        Tue, 25 Jan 2022 20:01:33 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id m11so66848457edi.13;
        Tue, 25 Jan 2022 20:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t8hwqyOunkzy/4SOBgRR7Syn8J2zWiYkepV3NdYM9iU=;
        b=SvjPTfyitgrO1xGhNYx/aS9IVT9rfTd/ToPZaMcZwUzOUTsDf6xazhcEZJ7gUogcwq
         od1x6hrqvxRB02bKtM8rwh96xS9E/ezViOLTCJAZ757dJ9RR0ruGiOYoZflJ4RY6pwse
         k4O0nDLkh5blU/CDzvAbepiJgHRZaxlePAzIY7TNseQxjgwPFf3WoR8yN8b9saV2bBW+
         uqHvnSx/YsieUaNFk2EbjJve/z0/vep5tevKanVLiKOWYEFyvQZY9WTCbqR+GG/S9jps
         9HRnssbTLHED673JRO40BsHT/8MWZkkSmMn2Ca+gl6m38SFFFL3rDSXNJqdYXgxRcd6y
         VBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8hwqyOunkzy/4SOBgRR7Syn8J2zWiYkepV3NdYM9iU=;
        b=x8Z1eypSGvfE61TJ1eQTgLl3SqDSIxHbGb/kmucvOf8Jd/Jbd1FU8jel1cEhPWvO1W
         h+yM+9zj7pk7apCC0GGjCOl/ToGd6KQTrFmpmxJXaDHM7seaXhuQyhxK94jYiDgGjgFy
         vqcgId/v/nl14orK5yIPIBJk1fJjwL7eil5h1F4dLCCQKfn9KIo8iGkXlyi9Db9PtmsI
         0JYsUhJgFuy0y9NSxdkGETAkbzcB1jsIUQjJXSiBvRkgWwvahUyX9YFc5Hs/pY5HcVxj
         cJ/a4vgKXCm+mJSLi3EXbf51kgjCdwM08Ez4GhnGNZSN2z7tUDyGvSJe9vnwxlIqxDlZ
         qWTA==
X-Gm-Message-State: AOAM530xh6PofaIEhq/e29XE9XD2O4fGa09lJKJolb4EP+2n3tSFVwn/
        sJIvn9pwY8GHB7kwbv5Slm4=
X-Google-Smtp-Source: ABdhPJzgDzKAmwvCfH236y0mVP7/eGzIzaSHYTAmtmblMZ3NH3i3J0RVvsmXLIJcKKqZn+XUwY5JPw==
X-Received: by 2002:a50:e608:: with SMTP id y8mr22995859edm.39.1643169691812;
        Tue, 25 Jan 2022 20:01:31 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id a11sm9139203edv.76.2022.01.25.20.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 20:01:31 -0800 (PST)
Date:   Wed, 26 Jan 2022 05:01:30 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Message-ID: <YfDHmpLxqUGWatQC@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
 <70a44baa-4a1c-9c9e-6781-b1b563c787bd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a44baa-4a1c-9c9e-6781-b1b563c787bd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 07:54:15PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > Add all the required define to prepare support for mgmt read/write in
> > Ethernet packet. Any packet of this type has to be dropped as the only
> > use of these special packet is receive ack for an mgmt write request or
> > receive data for an mgmt read request.
> > A struct is used that emulates the Ethernet header but is used for a
> > different purpose.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> [snip]
> 
> > +/* Special struct emulating a Ethernet header */
> > +struct mgmt_ethhdr {
> > +	u32 command;		/* command bit 31:0 */
> > +	u32 seq;		/* seq 63:32 */
> > +	u32 mdio_data;		/* first 4byte mdio */
> > +	__be16 hdr;		/* qca hdr */
> > +} __packed;
> 
> Might be worth adding a BUILD_BUG_ON(sizeof(struct mgmt_ethhdr) !=
> QCA_HDR_MGMT_PKG_LEN) when you start making use of that structure?

Where should I put this check? Right after the struct definition,
correct? (I just checked definition of the macro)

> -- 
> Florian

-- 
	Ansuel
