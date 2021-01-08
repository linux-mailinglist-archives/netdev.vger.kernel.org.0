Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFBA2EF67E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbhAHRel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbhAHRek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:34:40 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D638C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:34:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id q22so15621652eja.2
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bKvVZlKvQjWwpvhAmcGVb6RYhS+JhopYBUuFSekPlvw=;
        b=d+8rTGJSn5yxbw8+c6m1hPE1VgOahbE0bYbjmY1sWXGlNu2qav0rMYQ2B0F7EJTrjx
         Ptz3Awp2IHlNNpn4mvxHsS4saoHIwSdnKdv/3ogSPrPrjFXc6to+FBuZjM4Bbp3ttB2z
         wvE4LMC1jN6BdYuWrA6ShkmlAu7UYmo30CoHEGW7QGPLDtoAAPsjfKE4NGMOTtNZgYd5
         lENk0NTrTg2LEv3zu/YgkXkA5413VaEewGtDxeDVNKiGN950pu9yA2ZgT0olQQa6rind
         cbpO99KLS8+KEJ9DlYNIgYN5AXjOVQPUNw22B7o+LcObbaYDaPYzc/h0szzZzNwrle/l
         BL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bKvVZlKvQjWwpvhAmcGVb6RYhS+JhopYBUuFSekPlvw=;
        b=BVb+D56MFHtd4FjEjPpSrM9QM/JGlR6ckcjnZuhWXemd89iTl9fOwxe0SzVlK338AK
         p9SquJNXsokRr/1w1immrkYnu3zQKtJiXTbdC/p6M/TMpuHLle32mHzmqkm7QADhnla0
         I/TNrFHx+yAVMhI4Ly5QsBGJsPQw86eETjDwBfxQ8yGlwEQ1je69zSI/dF+UxGS4sa+I
         K+eXfvtZEeuarjwaqZIbG5NBuMKouPtkiUA+QMW5cAJwWn+ZonuvRMfNi6s3MMby4A7a
         te9vqNJR2pyF7ibahRTfm++C8ha6XaT/MZqFa/KWIbn4crDIU4K8RT6j69Ph43s1asCo
         9f6g==
X-Gm-Message-State: AOAM532gZ0RRUq/5GtXeLKV2MtxSlNOc1cZ86YkRNoRbp9+kBgAMs1wy
        4awcURci+DgOUMR3n+JjV4A=
X-Google-Smtp-Source: ABdhPJyiAEkq/uEwt6axSSh/5Gjx1zu/R9XjGTgy/A+OJg7YUjoJSbt7sgyMSjT3dwFpRqzc8ghvcw==
X-Received: by 2002:a17:906:94ca:: with SMTP id d10mr3195140ejy.62.1610127239081;
        Fri, 08 Jan 2021 09:33:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j5sm4008900edl.42.2021.01.08.09.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:33:58 -0800 (PST)
Date:   Fri, 8 Jan 2021 19:33:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next 03/10] net: dsa: add ops for devlink-sb
Message-ID: <20210108173357.fhuvhnsg4hbdizkw@skbuf>
References: <20210107172726.2420292-1-olteanv@gmail.com>
 <20210107172726.2420292-4-olteanv@gmail.com>
 <X/eauzr3d7es/YpH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/eauzr3d7es/YpH@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 12:35:23AM +0100, Andrew Lunn wrote:
> > +static struct dsa_port *devlink_to_dsa_port(struct devlink_port *dlp)
> > +{
> > +	return container_of(dlp, struct dsa_port, devlink_port);
> > +}
> 
> I wonder if this should be moved to include/net/dsa.h next to the
> other little helpers used to convert between devlink structures and
> DSA structures?

I wrote this before your series for devlink regions. The way I'm using
devlink_to_dsa_port, I guess I can just replace it with your
dsa_devlink_port_to_port function.
