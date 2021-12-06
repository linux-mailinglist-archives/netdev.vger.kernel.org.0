Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980E46A4A6
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhLFSfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbhLFSfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:35:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F0AC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 10:31:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so46576566eda.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A4et8p40H6Zf4KYzWkDn8PJl/oJNlm4nqaGwsmGSsdY=;
        b=gngB4SKUe9aFybsD7rXyy2feRq2+OS1ISkvw7y7IPZyLdxxIJ9MqJnBCDyPVE3Ddi3
         adFcmeQN71XO6CGUynAeQhy7d1Og1wvWzyMj5+VFBP3TOAgIb5lXHhbj6wD5C/OPLl9w
         AaSyN1Tp3WdoeIMautH64Z6fA54bptd2kKEQTDwI7Cnx/5d9v+Wwin2guCIiqAii2KQ/
         605YUCXpXi0OhFKNHZAKOrhqKIzEbpViph3hYHxNRkGGP2MmD8+Cp0XhHq7gMgy8joxZ
         PeEHJhbowyvPWJHgYqAIbuj1hrQLj3Ngi9JReKZBWs5vfHTxEBTmsezA38aMEfgIq6Qk
         emoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A4et8p40H6Zf4KYzWkDn8PJl/oJNlm4nqaGwsmGSsdY=;
        b=tdvW4AQ5d31aeNADvZOEPyD2fHTx890nLoZ+K++29XkVb0RfED+p93HdKGjYFnKqor
         LO5fIwF2zyDIFX0B0GgBQdMQCW+eSA5j86q+j3Gu3tJKHZ/NqEhTKrAl6iarpS9Unf4m
         OpGqH5mSBr/V0b6xCx4tc3vMgqpLbbZSdz/pbrgcF8fW1BQxwWlJ0yzd7JWHL5ADgm+S
         R1cuXiv0AotBYnqdsVxcBiu1vsaCPkbam6M9a4YkTLWfR6cPbMjglUMrcXBG5uWgz0ar
         w2d7DpEEWhaESrGHJLam61uLW+brOgQj/6o8T80ORei5iuvj2G2GW0TUCyfZa69RrYeC
         24yg==
X-Gm-Message-State: AOAM531ypI8Jiv6MfgJC40SUCurXY1bkwTw4Lj9KQPVVLsbu0Yfu+apV
        k7nmDdC13fD2eLXorIyv0oM=
X-Google-Smtp-Source: ABdhPJwybZpZl7M4k2F/y1dX9/4RcmzHHQltTJVhDINxtwUIB4K22TEH35PUgPhcs8+l/GfuqAolJA==
X-Received: by 2002:a17:907:a0d4:: with SMTP id hw20mr47836252ejc.16.1638815509353;
        Mon, 06 Dec 2021 10:31:49 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id dp16sm8178131ejc.34.2021.12.06.10.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:31:48 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:31:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206183147.km7nxcsadtdenfnp@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:26:25PM +0000, Martyn Welch wrote:
> On Mon, 2021-12-06 at 17:44 +0000, Martyn Welch wrote:
> > On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > > > Hi Andrew,
> > > 
> > > Adding Russell to Cc:
> > > 
> > > > I'm currently in the process of updating the GE B850v3 [1] to run
> > > > a
> > > > newer kernel than the one it's currently running. 
> > > 
> > > Which kernel exactly. We like bug reports against net-next, or at
> > > least the last -rc.
> > > 
> > 
> > I tested using v5.15-rc3 and that was also affected.
> > 
> 
> I've just tested v5.16-rc4 (sorry - just realised I previously wrote
> v5.15-rc3, it was v5.16-rc3...) and that was exactly the same.

Just to clarify: you're saying that you're on v5.16-rc4 and that if you
revert commit 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will
control"), the link works again?

It is a bit strange that the external ports negotiate at 10Mbps/Full,
is that the link speed you intend the ports to work at?
