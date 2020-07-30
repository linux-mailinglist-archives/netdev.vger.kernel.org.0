Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B844233A58
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgG3VKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgG3VKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:10:23 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94920C061574;
        Thu, 30 Jul 2020 14:10:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c2so15113696edx.8;
        Thu, 30 Jul 2020 14:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2LS+lsv6BvDaBlta6f0iZC0wQ8SWNLdIF6mK8BSsBkc=;
        b=oR2b908xTvNqBccDhi4kJMZR7ZhEijb9wHfTvmPJr31mn237Itvtf7kKlwn+nKc04I
         A6QbGcayxdWY1huhNzPuwqSajwtAkcp6bKd9W03Z5caH0Sy8N493LR3KQqZubEqMhY7/
         2bN1PLfR7xxFBPGVXKRFr/ycMWMTylNRDNAz1q+BCaS9cMRR2+34+r8wxSMs1Usm4AI/
         ScPNnBGGQIYTHR+zR4sNzEoXj8oJ1G380GVUgexEkPZhqB7ZSL3E3MMB8hU7TivzdiMs
         vA9kx6HPjhdLLMkWmus0LFCnPGnhdMx3KGSi5JZXSNQoxtQqNxnfxfLNU0Q6Xn0DJjtp
         sUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2LS+lsv6BvDaBlta6f0iZC0wQ8SWNLdIF6mK8BSsBkc=;
        b=LzHvBjsjZqDEi/89DwdIeDOhrs45bLdXffQq1mDtkY/lq3/xTtfTaP15qR314Osx5C
         lRqjrnVGkxv31WWKb+hIQyLCKRtG2SNT1Pg9v0nrs+d1WUE3FNsRA6SWOXBLaEUX+mwX
         54R+PlC8xgJ15Q2FJgEQz2VOFuTCNWysBP3dOrjYzUPyKUICMI/pQoKDDbgTbVFd9qth
         xqer0Bygk3JhvOhsXU8BUfm7SG+xiG7qowIiCSr1fXZnx4aJQxROu6pOUJmSSksDeC/L
         /KO5FXGzMRD4dsTnmUeRpWP20nyHKr2C7LW2q0n2SX/drab/y0mWQyuv5n/AqQ1nOapV
         /Fpg==
X-Gm-Message-State: AOAM5322K9aQ4c/BNAeruPYxnhTDlOVKtF3KHaxqnRLQ7Xf3M+HgR52g
        zJUTs/OAVEDOBIjeEiguawSzttsD
X-Google-Smtp-Source: ABdhPJwCwBAXUVJ1q6Hm+e1asYDAniuJEjwV6i5ig5xSp11YmPoBbn2WbQRp6wM72Y96QWfUDeksKw==
X-Received: by 2002:a05:6402:1b1c:: with SMTP id by28mr923522edb.89.1596143422188;
        Thu, 30 Jul 2020 14:10:22 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id bi2sm7630231edb.27.2020.07.30.14.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 14:10:21 -0700 (PDT)
Date:   Fri, 31 Jul 2020 00:10:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200730211019.lsqar5vbrxu5xw2u@skbuf>
References: <20200721171624.GK23489@earth.li>
 <20200726145611.GA31479@earth.li>
 <20200728163457.imcrsuj7w2la5inp@skbuf>
 <20200730104029.GB21409@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730104029.GB21409@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 11:40:29AM +0100, Jonathan McDowell wrote:
> > > +
> > > +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> > > +		ret = qca8k_vlan_add(priv, port, vid, !untagged);
> > > +
> > > +	if (ret)
> > > +		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
> > > +
> > 
> > If for some reason there is a temporary failure in qca8k_vlan_add, you'd
> > be swallowing it instead of printing the error and stopping the
> > execution.
> 
> I don't follow; I'm breaking out of the for loop when we get an error? I
> figured that was a better move than potentially printing 4095 error
> messages if they were all going to fail.
> 

Oh, you are. What an exotic way to write this loop, my brain stopped
parsing beyond "vid_end".

Thanks,
-Vladimir
