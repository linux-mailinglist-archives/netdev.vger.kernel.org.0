Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C6391791
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhEZMlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhEZMl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:41:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16986C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:39:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id z16so1584424ejr.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nZP6dV3QbVN3Sz1aVFP7FMr7Y1AyKy6+mWk1+Z4gGZg=;
        b=Xynw2JWJl1Se1ezae2FbvhVWkCbl20b5K9absNDbHhLztsSKaAwUGHU9MQNKz5Lt/E
         sKrOcuhVqJ+mGhfcl2ZNkrcM0K0WfxY33MaeiSh+HYPHkFk7IuYg4/Sy96ICPUOvKO1K
         vOWQvjFsiGiF0sJ584skOBucmz37Kp02bRmljy53oZ0qdL03kqO6vu9+6UbjWFxlMznA
         GzvvmbNCb+682aqRUTLnohMFfVRjotwgDX/QsU1yKVRSfgNaGBBvO0ESYP9OWQFoh/cz
         3hjbY+1/CMz3XFhyJGQnC+EMD9L/x9wIw2jmRRpcWKyg3yNBn2tjODLQe6dVWasK+V8v
         XS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZP6dV3QbVN3Sz1aVFP7FMr7Y1AyKy6+mWk1+Z4gGZg=;
        b=C7+KF8eiPq2iupfoTOJXpwpMSjGUM/RqGmspRGgWNXfRsWXoy4ZU32xc2x29OlhB/S
         s+UsKgRquvhK+htbqGIzYQY4guhEVZxX5sohkSZbMU69rDPyg/nHkdNUqGLxLIVtK+zJ
         LBf1fjDA4/4D4jNQdKTZu34ZOCVD9LZJfB62C/2bjIa/RFGsomyXsiu2uMdG9NiWQ+5/
         KVls2eIfLzm6dcS0G3JQZ8K3xz4uPGWIMVKzVadSPV0K9X2KbhgZesUqeBMj2gCKRa1u
         jCmsqkt0D3hJQf5IOC1TKmX2/Pk+LEiM+cOVEPoUs5lHKAQK0AQkGyWppHskbzsa5FAd
         toow==
X-Gm-Message-State: AOAM530pbxT8xjKibtJqi1cUCfRk7VAv2KJOwpCMlPijN5KXNLUw8Zvs
        R94mAqlT6/QvO5ImG5RZeFc=
X-Google-Smtp-Source: ABdhPJw1Ahk9C+SATxBS5gjrvoh6plhhJ3jvMH5UOIsnhHqpnnP8FzHA7Ssr8sxpyiLzcMbXlEshxg==
X-Received: by 2002:a17:906:c30b:: with SMTP id s11mr33292619ejz.486.1622032791705;
        Wed, 26 May 2021 05:39:51 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gz8sm10252985ejb.38.2021.05.26.05.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:39:51 -0700 (PDT)
Date:   Wed, 26 May 2021 15:39:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 02/13] net: dsa: sja1105: allow SGMII PCS
 configuration to be per port
Message-ID: <20210526123950.pcd563vozqgzsnsn@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-3-olteanv@gmail.com>
 <c2364571-dff9-2654-5160-a37d9f48ba9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2364571-dff9-2654-5160-a37d9f48ba9b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:16:20PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > The SJA1105 R and S switches have 1 SGMII port (port 4). Because there
> > is only one such port, there is no "port" parameter in the configuration
> > code for the SGMII PCS.
> > 
> > However, the SJA1110 can have up to 4 SGMII ports, each with its own
> > SGMII register map. So we need to generalize the logic.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> [snip]
> >  
> > -	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT)) {
> > -		bool an_enabled = !!(bmcr & BMCR_ANENABLE);
> > +		if (!sja1105_supports_sgmii(priv, i))
> > +			continue;
> > +
> > +		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);
> 
> Nit you could have a temporary bmcr variable here in the loop which
> aliases bmcr[i] just for the sake of reducing the diff to review.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I could have, but I don't have a good name for the bmcr array, and
"bmcr = bmcr_arr[i]" looks worse to me than just working with bmcr[i].
