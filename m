Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDA83F686A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbhHXRwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241577AbhHXRwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:52:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DB0C05A52D;
        Tue, 24 Aug 2021 10:16:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u3so45877026ejz.1;
        Tue, 24 Aug 2021 10:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZrICEbmTTI5X+hclm7WK+PbQzG8reRJWlDrlnWqe5QM=;
        b=V7GFYricmNupzBQJITddKiJ5ku1Lqevd9U9bxpSrk0jzLvBuYGDIYibumqRNN0x5vp
         pSb64XnQkxG4tDTrNORxvVC6r/yjy64p4Gcem3ESHcB5ZNYGrW9cl6YZfdTXqGRCiVe7
         eq1VENoEhmH7DmNn4kapGxS5qi7KlF/N9RlD8Lx/C+kZGtyG1RHWVREmLQsDYZbq6lYK
         tpn2eyaAgXC2EaIIEnLDW7kcIpM7qUcG94JDw+jLRXbvxpbKffMn3jD8swoBhVDcj8Ww
         Ac9UtFbl535gK/3LeP2yd3dSnBDXYhh61E8eFOiNrBs561D7YgygGR4UvbDe91vcLyzB
         8uUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZrICEbmTTI5X+hclm7WK+PbQzG8reRJWlDrlnWqe5QM=;
        b=UBrtYsbN74rxMoQy7S0jC1MQSQ8CDx38+JEJNkcyNn9xA8DUUKiZ3UAIIy2mpL5xq2
         Azf6mUp7etVhNNwHS1UsID2GZ1OdH6jTEjXc0qZ+mu+z9PEe88B4FwG3d5GWnfSz3R/Y
         HO6bJEo7iVUSx6LdGYHCTv8V5mWpuHsiOY1gL6SMIgbrKZurpCHLXHADjgLlgS3fPDIx
         WvlaGpq5znY/BuRZ0xrG3l3DLe+/pox7/rcRn2Gwa4LDdIjLHjATvL/ZSLG5nmfN+ErJ
         s7STi19AKcxjEnAfs+ViNvkuD81MHDDloxvITRghrvjGRqmVu4AWn/AffBbLx0Ikw2dx
         k/Kw==
X-Gm-Message-State: AOAM532P40Zmch2kUz4Bym2NGyMLg+Ml0MKA3PeGW2r+EpgAzGb9NPHx
        0ZYzjepNuICGwTV4rUu+YYU=
X-Google-Smtp-Source: ABdhPJwdGCzqk1Ny2qU9cmtS61qz1uXqMNjNnjfRHaaaWhcZMJ32Yp6OFCb0QywNgpvRbXpje3KbyQ==
X-Received: by 2002:a17:906:401:: with SMTP id d1mr1200691eja.242.1629825411500;
        Tue, 24 Aug 2021 10:16:51 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v1sm9951266ejd.31.2021.08.24.10.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:16:51 -0700 (PDT)
Date:   Tue, 24 Aug 2021 20:16:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Message-ID: <20210824171649.ebcolsbsqczomiee@skbuf>
References: <20210824165253.1691315-1-dqfext@gmail.com>
 <20210824165742.xvkb3ke7boryfoj4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165742.xvkb3ke7boryfoj4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 07:57:42PM +0300, Vladimir Oltean wrote:
> > +static int
> > +mt7530_setup_vlan0(struct mt7530_priv *priv)
> > +{
> > +	u32 val;
> > +
> > +	/* Validate the entry with independent learning, keep the original
> > +	 * ingress tag attribute.
> > +	 */
> > +	val = IVL_MAC | EG_CON | PORT_MEM(MT7530_ALL_MEMBERS) | FID(FID_BRIDGED) |
> 
> FID_BRIDGED?

yes, FID_BRIDGED.

Please confirm that the Fixes: tag is the one you intend. The patch appears fine otherwise.
