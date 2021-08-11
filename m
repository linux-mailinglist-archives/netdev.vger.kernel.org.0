Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0803E9646
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhHKQpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhHKQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:45:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97FDC0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:44:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q3so601948edt.5
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d5mpGO8sJm1uOS5mK3KFFxWSNmZ1Rbb1dU3WzRutSTU=;
        b=RLfkW/JqfuCtuSe+UzObJ02Yc1a0AhJ/p7ZFqx6h9e7M/ZuYs4r6xeb+4tga7TDbvW
         mivHigzw7wEYXKOzqF01YPUK0FA02F514keWiaEutmhk41l4Dqgib4xLdUbNW16T0b4h
         UoUZd5sKpU6GKlIt9NMCulDCgObbil59APzSfdJGGqQROh7lheyIUSVn1aIMUnJdkOXC
         GUanpZ17+udDvjbcDMo017/mnHcXpeda3TgCwSeWLnj8CxsaCIjT76AB1Mgeqo1uH7CF
         TmUVCzS5INsXSGalr+r1f0AAx6enMZYhz4AepfwF0D558OIxoEzyHZgTMwCa7kVhQFxv
         dprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d5mpGO8sJm1uOS5mK3KFFxWSNmZ1Rbb1dU3WzRutSTU=;
        b=f8nMm0SsuDw63UAPVIxRsJbu+ZEvWLtzFiyPFYwD2SXxyXBr/3ZOLYUriwUPsEkUmo
         GpAjySKcFEsZTLlFp2VnMoROl6fAh9RPSb1qvLKe21qihX6xAkqs7WFVRLPn6tZ+zk4s
         vpqLbILmKCED9vzOFetiLPW9dCSfJro3BnqBPe6+gN/nShspEA++qY/4jI42Er8vQrev
         /wlPYUmG5xT1s7dFDk7Bn5utuy4sF2G8fheWNNJLjoiPxaVKWdhFsdysakDPy5VDQGI2
         B5rFKOOOrJePXNJaJBemTig8CQQmTW1al1s4A5itgUbiGeq8nn4fXfoY8zQzedrjkIvN
         8EdQ==
X-Gm-Message-State: AOAM533npEm590uZwLsDS+bzeRKblBlg2LjDkiTrd445hzG6g9VOqMB1
        OgGYOngQJHLIC5ogzBWBq84=
X-Google-Smtp-Source: ABdhPJz06C8aQPZRI6RfUYGdsgdto8GZcB8YHedaNck2+tR3Qh6qwBY6fln7Teou61Sijx2G0eRihg==
X-Received: by 2002:a50:cc0b:: with SMTP id m11mr12093477edi.96.1628700283180;
        Wed, 11 Aug 2021 09:44:43 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s10sm8318281ejc.39.2021.08.11.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:44:42 -0700 (PDT)
Date:   Wed, 11 Aug 2021 19:44:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: apply MTU normalization for ports that
 join a LAG under a bridge too
Message-ID: <20210811164441.vrg4pmivx4f6cuv6@skbuf>
References: <20210811124520.2689663-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811124520.2689663-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 03:45:20PM +0300, Vladimir Oltean wrote:
> We want the MTU normalization logic to apply each time
> dsa_port_bridge_join is called, so instead of chasing all callers of
> that function, we should move the call within the bridge_join function
> itself.
> 
> Fixes: 185c9a760a61 ("net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I forgot to rebase this patch on top of 'net' and now I notice that it
conflicts with the switchdev_bridge_port_offload() work.

Do we feel that the issue this patch fixes isn't too big and the patch
can go into net-next, to avoid conflicts and all that?
