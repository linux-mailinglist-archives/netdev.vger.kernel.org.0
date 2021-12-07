Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B566446C77B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbhLGWeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbhLGWeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:34:04 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CFDC061574;
        Tue,  7 Dec 2021 14:30:33 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u17so723625wrt.3;
        Tue, 07 Dec 2021 14:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MZzO6WHr2WdHlrF/eneFoD5oyj4uybD8nE4vEwKz14=;
        b=k8Ys2c4aqrn6APGYdpjVW4r3/8STl+EH2opweEcuOutlSV2HNmzqz1MHLt/VAtYO17
         sgHTj90qJ2FuL6VsJORonRdQtQIT9p2C8wZCTitYUj6Pd2KzG+xtB1fHIfCCbeq9N8yT
         nzMohy6pcQbraFEQmo1YrN3hP84ZruClqA69uctW6oi9rbTl80qdUOsa9wl+aGXVVKXr
         6XiMwswiGGbXAjUx9LTfgHswTKTYbyOXflx7VF0kF9UdXBTikYBaEr4im8mFrf7Fdwdv
         upP0pwa1kpTRsqlJ8bNYOY9Hp+NQFDt80ntlQjTU3GRnynQNpPu9qRkOQJ4RP272gyoc
         8a8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MZzO6WHr2WdHlrF/eneFoD5oyj4uybD8nE4vEwKz14=;
        b=EJnDPe/8QKawTPHddo4VNmWUEeGEdcgIFRexsf7zh7T/IEX/8oNeuF7hWJBI88Fl/W
         vTVQt2hFyU9lhmy1Sf+CUdoleE539ke9aT04/RVSpg2qipZQz2tlrE4l30Dt1XkiUfyF
         FwYQBzmMTSYwhcULJmxw74DhNh9epKOCCPigza+dmfexSb+kO6fwCvOX8Xuqo9VFQ3yH
         OCj7IilI7KljJTr6CdO4ARVfnJcGzISF4rgokla+3OrQRicNkx0ZzFnoEeu1JHROurrC
         UhHmFtA5s8MZpV1NQMNtY5WPvyahhadzaCoPRuBLD+UTCSPpTWqLTXGzw88oDyZtUQVk
         OhmQ==
X-Gm-Message-State: AOAM53045BnepcMqe8LAdtxsn5GWkx6BFk4YlQEKNncmyTNBjpw4kGkR
        bA169m1qSWP8LcRS3njqLSs=
X-Google-Smtp-Source: ABdhPJyxn+LKEWcaHu1r5m3t5RGWsbrWhoOCTYBk6gNVaAhJd7EpqH9tdEeAZcTEJEbPcrT7fYl7tg==
X-Received: by 2002:adf:e501:: with SMTP id j1mr52964552wrm.516.1638916231782;
        Tue, 07 Dec 2021 14:30:31 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id h13sm944142wrx.82.2021.12.07.14.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:30:31 -0800 (PST)
Message-ID: <61afe087.1c69fb81.45db8.5d80@mx.google.com>
X-Google-Original-Message-ID: <Ya/ghT2sFt5bxb6m@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 23:30:29 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya/esX+GTet9PM+D@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:22:41PM +0100, Andrew Lunn wrote:
> > The main problem here is that we really need a way to have shared data
> > between tagger and dsa driver. I also think that it would be limiting
> > using this only for mdio. For example qca8k can autocast mib with
> > Ethernet port and that would be another feature that the tagger would
> > handle.
> 
> The Marvell switches also have an efficient way to get the whole MIB
> table. So this is something i would also want.
>

Again same think... they just put the type in the qca hdr (placed in the
EthType position) and everything else is a mib. The switch send 7 packet
and each correspond to the MIB for the port (the port number is
comunicated in the qca hdr)

> > I like the idea of tagger-owend per-switch-tree private data.
> > Do we really need to hook logic?
> 
> We have two different things here.
> 
> 1) The tagger needs somewhere to store its own private data.
> 2) The tagger needs to share state with the switch driver.
> 
> We can probably have the DSA core provide 1). Add the size to
> dsa_device_ops structure, and provide helpers to go from either a
> master or a slave netdev to the private data.

I'm just implementing this. It doesn't look that hard.

> 
> 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> driver can use N tag drivers. So we need the switch driver to be sure
> the tag driver is what it expects. We keep the shared state in the tag
> driver, so it always has valid data, but when the switch driver wants
> to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> if it does not match, the core should return -EINVAL or similar.
> 

Mhh this looks a bit complex. I'm probably missing something but why the
tagger needs to share a state? To check if it does support some feature?
If it's ready to be used for mdio Ethernet? Or just to be future-proof?

>    Andrew

-- 
	Ansuel
