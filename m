Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CAF42FF70
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhJPA30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhJPA30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:29:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD05BC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:27:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w19so44087944edd.2
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jNHMFmIIWmrzSChsqzBq2iHkjFLiK7xRecuDgNQ5/rs=;
        b=J0+ckxqMuBOfXwxjLQTqKdo13tPDmh6mBcb9hGjbO872//qgTlxK65zF/vF4EmvU7E
         f499tqDc6AWkiKbReDHBWJMeXnzR9KOc70GROL/qy1LHCbwMXH7D2uNNZtE4cD+84iRK
         NI681H2dDbZlwiWkMOZZvQMQz1YdQKWyYPCcrb/TPZ0/KWtATWTFtR03xDPbM+3gjjSx
         EJc4Q9NXm+RqIr9S06V2OvyfKvUueMnJHXUPssGGm13Wpfg09i7uJreZSYVs/VdvfGaz
         w7sToClkWnOau9wTL/K3OGcMaNhLBmKmBcTmLxmFdS/ewtlamwGWNxkB3wGWclJDD8tP
         yTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jNHMFmIIWmrzSChsqzBq2iHkjFLiK7xRecuDgNQ5/rs=;
        b=ztioFyBeJxYUGLaVb7Wbi637t8gzYXgE68wLP6jiuxGF1289QYuZWKb25V4G/2Gdo/
         OUqthIqzJxsGArJMsOtv8kA6OlwyW4UZOIiKOgDPurLkqbQa40X0DOm0XeenZhgs3qcm
         4TWoEqlBb32M6ZUzTFyglMmyZqdhbXY2d4mn56EKbDB3+O9SMKPC6IGgy5yTtUp9bF6t
         i0lNpGcdC4JNqRYdJfcSNo0nvLCDpOiX4vakYSEEzQNjx9ujmmwR7WMbMoovMu+a3Qml
         yZcYVerkbML9LZYQas824Unp+ctH92vCZl3aQ0o2IAO8lSXyuc3qjEvUeuTbOMbk60Bo
         jTUQ==
X-Gm-Message-State: AOAM533No53wGrcGZP1iX1oRmOY65tQKpm2UlxgetfJ9/KC9S0jAORML
        3+Vc8Orpw/BEAnpPwBMM9vE=
X-Google-Smtp-Source: ABdhPJwakKoG+QUzLwpiCKZxXY76coyvHcL3Q/icxT2ywii3FrJJ7ZH3VVC5kcJSYSsvv1PTREWs9w==
X-Received: by 2002:aa7:cb92:: with SMTP id r18mr22660382edt.282.1634344037540;
        Fri, 15 Oct 2021 17:27:17 -0700 (PDT)
Received: from skbuf ([188.26.184.231])
        by smtp.gmail.com with ESMTPSA id ay7sm5125567ejb.116.2021.10.15.17.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 17:27:17 -0700 (PDT)
Date:   Sat, 16 Oct 2021 03:27:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, vkochan@marvell.com, tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Message-ID: <20211016002716.j3v4pamavkvxodsv@skbuf>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <20211015235130.6sulfh2ouqt3dgfh@skbuf>
 <20211015171730.5651f0f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015171730.5651f0f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 05:17:30PM -0700, Jakub Kicinski wrote:
> On Sat, 16 Oct 2021 02:51:30 +0300 Vladimir Oltean wrote:
> > > @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> > >  	/* firmware requires that port's MAC address consist of the first
> > >  	 * 5 bytes of the base MAC address
> > >  	 */
> > > -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> > > -	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> > > +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
> > > +	eth_hw_addr_set_port(dev, addr, port->fp_id);  
> > 
> > Instead of having yet another temporary copy, can't we zero out
> > sw->base_mac[ETH_ALEN - 1] in prestera_switch_set_base_mac_addr()?
> 
> Will do unless Marvel & friends tell us FW cares about the last byte
> (prestera_hw_switch_mac_set() send the whole thing).

You can always zero out the last byte after the call to
prestera_hw_switch_mac_set(), and then it shouldn't even matter.
