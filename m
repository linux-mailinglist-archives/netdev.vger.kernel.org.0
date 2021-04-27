Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF7A36C8F1
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbhD0P5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbhD0P5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 11:57:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC6FC061574;
        Tue, 27 Apr 2021 08:56:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso7484888pjn.3;
        Tue, 27 Apr 2021 08:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g4D6mo9ANGWmNDKoakg3uqUKRnf9rNH4O+OR6Lx34oY=;
        b=DrJKE/IevpqN9opxieOYTY8lBVF/GEC+fcHmGMHGO943kt4GgnW1WmSM4H0n9iuLVr
         BGD+jNHRqml1q/B8mXon2CaVdwyQxJyaLW23iFtft6ucBTr0sE6nGioas6WFq85wfZbI
         D8cF0LAko1AYtYdlTF96o529pnvbkt2YOhgrW6796XebG8ZjvPFVEG9e1NTgAIPJlphq
         zmEObWX3mxvfCZdIl150VAAPlYXNM1vaehhzL2pms993xqkOEtU16yRSEAKjfq9CMEnS
         mlSskzk23REfv1lwuUFlI63Xpo4d5Dw1x3CVgUVseUWIXvsk3flToKhrbQX/TwpFHxzr
         wxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g4D6mo9ANGWmNDKoakg3uqUKRnf9rNH4O+OR6Lx34oY=;
        b=Zjj803MIGi1Y2TkEnK8mur8ghtGKojqUTFaK2OCunD+YlU+P4PnvFIjUQPDltqejfN
         jfFQaJr1fqGgGeisfdnMTHhGujkqQLp0Nsf3+kJOX3Y7N9GLB4wY0J2k4TvVDbj5q0lq
         /JkMY4YToJ2hX+j3ctmGUjOjPSxSAAlFm7xgg32LBLHLq/LdctdXMOyLRBCi3S5TokmX
         EH3i3CBOCvx7MyJBeLZzCTdXtfiHCkegLXTkTcYXptCozZstPsExA9fR102RM5XY3tYC
         E23anbcWrch0kt9qBSNIF/7Gip5+6qeTSxddJQ0xLalS9z+WCDB4L66OIyNV37EMDs3+
         TqNA==
X-Gm-Message-State: AOAM531RQxIUoPOBJzR/dQj56r4cNAmHFD+4sZC+XzFWn73BWxWFHB8r
        O62N9PVrl3xm8HipW35WQyQ=
X-Google-Smtp-Source: ABdhPJxaMh4UoeGrf1LxxjVrpqFOptZksFCOhKl5mEUU8kqooUk8wJDHWwSUysFFleCxh8Be9zj4AQ==
X-Received: by 2002:a17:90a:dd45:: with SMTP id u5mr5875428pjv.15.1619538997142;
        Tue, 27 Apr 2021 08:56:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ca6sm1959338pjb.48.2021.04.27.08.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:56:36 -0700 (PDT)
Date:   Tue, 27 Apr 2021 08:56:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Message-ID: <20210427155633.GB14187@hoboy.vegasvil.org>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
 <20210426133846.GA22518@hoboy.vegasvil.org>
 <20210426183944.4djc5dep62xz4gh6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426183944.4djc5dep62xz4gh6@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:39:44PM +0300, Vladimir Oltean wrote:
> On Mon, Apr 26, 2021 at 06:38:46AM -0700, Richard Cochran wrote:
> > On Mon, Apr 26, 2021 at 05:37:58PM +0800, Yangbo Lu wrote:
> > > @@ -624,7 +623,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> > >  
> > >  	dev_sw_netstats_tx_add(dev, 1, skb->len);
> > >  
> > > -	DSA_SKB_CB(skb)->clone = NULL;
> > > +	memset(skb->cb, 0, 48);
> > 
> > Replace hard coded 48 with sizeof() please.
> 
> You mean just a trivial change like this, right?
> 
> 	memset(skb->cb, 0, sizeof(skb->cb));

Yes.

Thanks,
Richard
