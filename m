Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4563A9B91
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhFPNJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhFPNJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:09:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0596C06175F;
        Wed, 16 Jun 2021 06:07:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ba2so2626296edb.2;
        Wed, 16 Jun 2021 06:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8b/okOVnhsmC8WOydmuYGzKaGTkrkLvWV3Zt6yVl/cU=;
        b=Ems3Z3Wy4snMpUrp8UAukFpyWqZQ0pcxSa8V7C/OJuxQkMFvihA8spkzlKwoqQptit
         fao5ZPLzxEjQOJqyRqaZb/zdZKOkubHt6s95lUHtA1q7SKGfo1Lyf8aS5LOMhcytxf82
         MbYDOB0xSaZbOdhz12E+ltKWAMCAYJ3Or4IB0MEVZYxiqQHFx1FG2mjNUomNgvtDvQ3E
         RDI43w/LTEWPlK4/HYJfxI1bDimcsvNaWeoU3yz2lBIH6xBOqLO0owznKx/qmke4ZdzR
         Gln82sQMEshK1Zm14NgIQvJYMwg8Ix3i6qtKNZhsrY+3sMHCBPcb/EEtrqVxpyNVXR95
         yO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8b/okOVnhsmC8WOydmuYGzKaGTkrkLvWV3Zt6yVl/cU=;
        b=laOJMyBxKNFr+2ZEQuevKjmIHm5NdCpJe9nEOD0JA/wOb4U3m/5m1KRbaAV1WTbk7W
         NUVK91rC5F2WoLeXhHjXzp1adKU3BNkmAhhiEB/0vZV2wZH9W+EG6VU5IdVbdSxhUwzL
         p3daExBSODqXPSHcxqyAa8BdvMmjruDDRH0crb53VvsF1U8uz3jdDz8QNn8ii0ZV778K
         F3btcOvfbegX7s5GafQIdVduRtHG8tEs55yt3DzKZDkVL5+QshueqNK8T3RZYEMmsolm
         qHEjRmeYSJfefMkdF25TNlanZdHaJ0Pk7nwJlWvwsC66wjnsSVRu+mPNNy5zt8W97iAx
         o0rQ==
X-Gm-Message-State: AOAM532B7zbgVolxseq5YpdulqVQG63h1mBe9dnPFYGJzQpVeovprUhX
        Qu/v6564zanvcgutxralwkY=
X-Google-Smtp-Source: ABdhPJx2HOuYDcPiSLJADs9bN4VN7WBNFjqgA71Hh99Ixd/1LHWIvCnQZ5kKYyzErotDxYud+D7TBA==
X-Received: by 2002:a05:6402:b76:: with SMTP id cb22mr4092635edb.112.1623848823499;
        Wed, 16 Jun 2021 06:07:03 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id qq26sm1555929ejb.6.2021.06.16.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 06:07:03 -0700 (PDT)
Date:   Wed, 16 Jun 2021 16:07:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/2] net: marvell: Implement TC flower offload
Message-ID: <20210616130701.e4k2izlthmj5j6yc@skbuf>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
 <20210615125444.31538-2-vadym.kochan@plvision.eu>
 <20210616005453.cuu3ocedgfcafa7o@skbuf>
 <20210616130424.GB9951@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616130424.GB9951@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 04:04:24PM +0300, Vadym Kochan wrote:
> Hi Vladimir,
> 
> On Wed, Jun 16, 2021 at 03:54:53AM +0300, Vladimir Oltean wrote:
> > On Tue, Jun 15, 2021 at 03:54:43PM +0300, Vadym Kochan wrote:
> > > +static int prestera_port_set_features(struct net_device *dev,
> > > +				      netdev_features_t features)
> > > +{
> > > +	netdev_features_t oper_features = dev->features;
> > > +	int err;
> > > +
> > > +	err = prestera_port_handle_feature(dev, features, NETIF_F_HW_TC,
> > > +					   prestera_port_feature_hw_tc);
> > 
> > Why do you even make NETIF_F_HW_TC able to be toggled and not just fixed
> > to "on" in dev->features? If I understand correctly, you could then delete
> > a bunch of refcounting code whose only purpose is to allow that feature
> > to be disabled per port.
> > 
> 
> The only case where it can be used is when user want to disable TC
> offloading and apply set of rules w/o skip_hw.
> 
> So you think it is OK to not having an ability to disable offloading at
> all ?

Because adding "skip_hw" is already possible per filter in the first
place, I don't think that this feature justifies the added complexity, no.
