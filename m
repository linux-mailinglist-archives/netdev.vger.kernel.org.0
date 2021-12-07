Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227D246C82D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhLGX1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbhLGX1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:27:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3459C061574;
        Tue,  7 Dec 2021 15:24:21 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d9so894435wrw.4;
        Tue, 07 Dec 2021 15:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ky6lSfjPQirRU1cm8nyx2Yxc3fG4emfY9Mw77avulUI=;
        b=qrbWWK7V+3hP1q0w89qUG58E+8iQ1IL2KdVcHKKzCooV29dw2GJ07PrJfyRDTRKhpl
         c2f0oKcLBgbat9JK7KaQksgc6weepdG5JYCBpGDNlQf6vP/W5NR84vs3FVc/N/Ze5S6H
         wbaN+eTIbZ+New7KE2q4scLBn8K7hHhLVpL95D5D4WtycET0b1IEzL7N32m5xI+1ojdr
         VnyPhQakeKBCG4NUh91DgHLQkHHfQJFCv1EksHgGdEzs0GAoji0OygdvIxAaLHwuJqSw
         JiDTVixkJtN5D/x0/x/S7TT7KLvffZMzFzWYE8W66vft2u5YfKm4lM1GFWevb9che7yE
         F6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ky6lSfjPQirRU1cm8nyx2Yxc3fG4emfY9Mw77avulUI=;
        b=jR3EArzrEOkSYUGgaAFUwo/PaTmekwURCkYgGnYIJVnaJLlD3dhE6Cuse7N7jb0h3Y
         gcJhpWuHu+tb96lxUdrQaSq6D9lwPHY6J8JeLs4Kno0rUU1M9or72K40ICoNVRnocThj
         06Zmg9RcJLy4EDkA0k/PQZfkiAyBNn+jRLiTb7QJvZCMWvfgCAObhMS3gLaZB235QyTc
         bJZGVRSjasVbHrL2m8Jq+d79oCe7ttq/pCKMRLTk9ch+4Ml+u5sJbtUR9181Ng8gS6Kp
         o5rV+L/tHK4tUoJ9YclQJV6On18L8BlYn4K/6K6g1h2OgH/75ZxF3sN39ukrgR242PSQ
         OefA==
X-Gm-Message-State: AOAM532LOLnjzuTOsBPJrOxVlrJM/NBTD6+czDIkzmaEdsSKfhh1VSfl
        QcTF9qacon9Q7lJ+8JR1I1sdGuunuGs=
X-Google-Smtp-Source: ABdhPJxUZT4T3BISJQJ2NGIEB2/Fb3P9MfXajF2aR8eizgSj7dTr12+IiJh/k8o5swI4viBI3e3yMg==
X-Received: by 2002:adf:d202:: with SMTP id j2mr54157559wrh.271.1638919460145;
        Tue, 07 Dec 2021 15:24:20 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u23sm1159754wru.21.2021.12.07.15.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:24:19 -0800 (PST)
Message-ID: <61afed23.1c69fb81.99660.7328@mx.google.com>
X-Google-Original-Message-ID: <Ya/tIUlv3RbweLON@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 00:24:17 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <61afe8a9.1c69fb81.897ba.6022@mx.google.com>
 <20211207232020.ckdc6polqat4aefo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207232020.ckdc6polqat4aefo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 01:20:20AM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 12:05:11AM +0100, Ansuel Smith wrote:
> > Hm. Interesting idea. So qca8k would provide the way to parse the packet
> > and made the request. The tagger would just detect the packet and
> > execute the dedicated function.
> > About mib considering the driver autocast counter for every port and
> > every packet have the relevant port to it (set in the qca tag), the
> > idea was to put a big array and directly write the data. The ethtool
> > function will then just read the data and report it. (or even work
> > directly on the ethtool data array).
> 
> Apart from the fact that you'd be running inside the priv->rw_reg_ack_handler()
> which runs in softirq context (so you need spinlocks to serialize with
> the code that runs in process and/or workqueue context), you have access
> to all the data structures from the switch driver that you're used to.
> So you could copy from the void *buf into something owned by struct
> qca8k_priv *priv, sure.
> 
> > >   My current idea is maybe not ideal and a bit fuzzy, because the switch
> > >   driver would need to be aware of the fact that the tagger private data
> > >   is in dp->priv, and some code in one folder needs to be in sync with
> > >   some code in another folder. But at least it should be safer this way,
> > >   because we are in more control over the exact connection that's being
> > >   made.
> > > 
> > > - to avoid leaking memory, we also need to patch dsa_tree_put() to issue
> > >   a disconnect event on unbind.
> > > 
> > > - the tagging protocol driver would always need to NULL-check the
> > >   function pointer before dereferencing it, because it may connect to a
> > >   switch driver that doesn't set them up (dsa_loop):
> > > 
> > > 	struct qca8k_tagger_private *priv = dp->priv;
> > > 
> > > 	if (priv->rw_reg_ack_handler)
> > > 		priv->rw_reg_ack_handler(dp, skb_mac_header(skb));
> > 
> > Ok so your idea is to make the driver the one controlling ""everything""
> > and keep the tagger as dummy as possible. That would also remove all the
> > need to put stuff in the global include dir. Looks complex but handy. We
> > still need to understand the state part. Any hint about that?
> > 
> > In the mean time I will try implement this.
> 
> What do you mean exactly by understanding the state?

I was referring to the "shared state" problem but you already answer
that in the prev email.

-- 
	Ansuel
