Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCE3546BA
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhDESUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbhDESUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:20:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9316DC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 11:20:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g10so6066510plt.8
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 11:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ni8GqaXNqFEgHRFNLzpfO9KJYfSGNoPCg8poqxavFxQ=;
        b=rb3mMzpxdTiOvGdm46oklb8RwWpM3Y3lGBRCE68p7c4JhfozsoimPFF558MGw3T1Kh
         X+NsrCN+K7V2HDf0i7p2h4+G/hw1gTvur0ETHEmyyT1JDbTMLNxNlTQGHmfreu50IdJq
         jST/CirbwmshxW+0+52P89HjU7z3N7edHmhrFm8wDrEHs489qajlwbk/7dARsJJwhclv
         xnkmzkkgWifLW+Vh1rRkCL4hVKeIQLohCNpY9MOU0qGpEtQJVLriXcFRzCLeqlSogmB4
         U3Jf7lshFMlzbLkTfc2TDHPgP3wJhzdH7CHxJBfH8bFoALFN/jqmo9cjVbN1z8FzdyT7
         S9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ni8GqaXNqFEgHRFNLzpfO9KJYfSGNoPCg8poqxavFxQ=;
        b=YTJ06jUI7t5OWeMC0I22uJZ2RCIiY+F8frGOz5iwP0Ypi9zJRaZkYDuE7BhtQxgB9g
         eKgDJ+uLTm+CfQUiwV3ykcMbBHQN0KYkVKoFrlV184tg5duEpKSGqS8upGSjcWScsQZq
         M5DKdc3LQLCFDU1+akz+Iuo43vmFGLE8PITK9y0oANXuBIkBaGqTysfHCagsQbW4or6u
         V3XF9pUJwpPnBAmGsmjk7USIQUycO366ry9uykj/Pknfbmedmc8ZtTurzbU+VP8L/ade
         vgJuAwjJRlcLqQ1OyW4PEvsU5dgwWAZiEZiMw9vV9IUCk13l8cZFovRf20N9v5x6tSJ1
         mnTg==
X-Gm-Message-State: AOAM530QzWIDvOJYehZ1Qt2dsLRtx/xWe5KWu8Eo+6e3IMGpBS0wGoEb
        eo/rmgH9oAnvC3dweqX0zofWrUkJOOV20Q==
X-Google-Smtp-Source: ABdhPJxzVZdLjxIEN/ofhI8gnikizx660QMTkajxzqMZhBl2EdW4rJl2iH4WU0+Scd5xrY/zFZZzrQ==
X-Received: by 2002:a17:90b:fce:: with SMTP id gd14mr452733pjb.8.1617646845191;
        Mon, 05 Apr 2021 11:20:45 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x20sm147940pjp.12.2021.04.05.11.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 11:20:44 -0700 (PDT)
Date:   Mon, 5 Apr 2021 11:20:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp
 handling
Message-ID: <20210405182042.GB29333@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-10-snelson@pensando.io>
 <20210404234107.GD24720@hoboy.vegasvil.org>
 <6e0e4d73-f436-21c0-59fe-ee4f5c133f95@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0e4d73-f436-21c0-59fe-ee4f5c133f95@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 09:28:44AM -0700, Shannon Nelson wrote:
> On 4/4/21 4:41 PM, Richard Cochran wrote:
> > On Thu, Apr 01, 2021 at 10:56:07AM -0700, Shannon Nelson wrote:
> > 
> > > @@ -1150,6 +1232,10 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> > >   		return NETDEV_TX_OK;
> > >   	}
> > > +	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> > > +		if (lif->hwstamp_txq)
> > > +			return ionic_start_hwstamp_xmit(skb, netdev);
> > The check for SKBTX_HW_TSTAMP and hwstamp_txq is good, but I didn't
> > see hwstamp_txq getting cleared in ionic_lif_hwstamp_set() when the
> > user turns off Tx time stamping via the SIOCSHWTSTAMP ioctl.
> 
> Once the hwstamp queues are up, we leave them there for future use until the
> interface is stopped,

Fine, but

> assuming that the stack isn't going to send us
> SKBTX_HW_STAMP after it has disabled the offload.

you can't assume that.  This is an important point, especially
considering the possibiliy of stacked HW time stamp providers.  I'm
working on a patch set that will allow the user to switch between MAC
and PHY time stamping at run time.

Thanks,
Richard
