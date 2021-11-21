Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBA4585DA
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhKUSOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238554AbhKUSOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:14:19 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36D3C061574;
        Sun, 21 Nov 2021 10:11:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so66719228edb.8;
        Sun, 21 Nov 2021 10:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ExCLIqDm13f0yuY3rnyYpbfOPnkdb+UFdS/LSQdgQ1M=;
        b=nOgopgxfZtBh5mtZQ2wJZ6OGr/jGvhvhaL4oerMODvJVmJqn66jBUqIj1pgCIGuO27
         /RrRhMJ9VixjKQs75t4y5FG0beOhrrTi3zuwohW5bVNwF1QN1eiXdDSTWNn1tMl8162k
         +5D38CpLdFdQ9zHVo9p8o0tn9ge6W7kq90hDc9DBUFnZZx1yaKaazdTg4eKqQSD/vsx7
         w1McvhCrvuA8J7cwOnJMUXz9dnsBLePdIfVMVZOZOnarC3u2R22jqsOOf1l1yTpqs7fR
         UibgEsUhZ30TeJzSQHcc8kpqCMtmoIJPhEaKhjGKQgdKOfZeuqUrOdtMT8c1+6bz+0Fw
         Xlsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ExCLIqDm13f0yuY3rnyYpbfOPnkdb+UFdS/LSQdgQ1M=;
        b=GyisLJOhxQ/4HKyzEvDnwlLumeE6JndZyasCOeLmKZRzvIewoAlseRAG++Q4PjCn6A
         aYRv3Cy7M2wy2DcGeJI+Vu0hyt11A0qUt6XNAShIwjXegaGfBI4qZy09kPPlCDIZ6eWl
         vNxjCVbylXLM93fvdWCnfDNSDO+DkYHG7b2wkM10hu6xgRICrVVKd0Eec/ZkMz5/vSrH
         2gGfAnF3QRwgMAWuh7zaI15xshaCQ8s3WzvTEXJedNbdfZkK68ZVBkatzYEHrcjOXxAT
         +336VoOqJOP2jWWi89C72pjbyANdH3fqv1rmKTH3Cdo/CPvanZYibko8gKVOUUBqWgUz
         P2PQ==
X-Gm-Message-State: AOAM533S6b1nU7sOIFLKvu0cB5kBenLYggyiPhrQsv6wZnS2e0CGvN9T
        dhQ8mR8QvcbOxjBPpiukCVc=
X-Google-Smtp-Source: ABdhPJz8oHUvYDZ1AR4aAGl7CrCg4zIPQTbR3WzAIvubIymaLSDMBKdJ9hauJQCZDz3uR2eD1ljmiw==
X-Received: by 2002:a17:907:d89:: with SMTP id go9mr32486514ejc.330.1637518272358;
        Sun, 21 Nov 2021 10:11:12 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id yd20sm2617139ejb.47.2021.11.21.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:11:11 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:11:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 16/19] net: dsa: qca8k: enable
 mtu_enforcement_ingress
Message-ID: <20211121181110.c7cgkunrzmobea77@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-17-ansuelsmth@gmail.com>
 <20211119022008.d6nnf4aqnvkaykk3@skbuf>
 <61970bf5.1c69fb81.6852b.3a87@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61970bf5.1c69fb81.6852b.3a87@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:28:48AM +0100, Ansuel Smith wrote:
> On Fri, Nov 19, 2021 at 04:20:08AM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 17, 2021 at 10:04:48PM +0100, Ansuel Smith wrote:
> > > qca8k have a global MTU. Inform DSA of this as the change MTU port
> > > function checks the max MTU across all port and sets the max value
> > > anyway as this switch doesn't support per port MTU.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > >  drivers/net/dsa/qca8k.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > index c3234988aabf..cae58753bb1f 100644
> > > --- a/drivers/net/dsa/qca8k.c
> > > +++ b/drivers/net/dsa/qca8k.c
> > > @@ -1315,6 +1315,9 @@ qca8k_setup(struct dsa_switch *ds)
> > >  	/* Set max number of LAGs supported */
> > >  	ds->num_lag_ids = QCA8K_NUM_LAGS;
> > >  
> > > +	/* Global MTU. Inform dsa that per port MTU is not supported */
> > > +	ds->mtu_enforcement_ingress = true;
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > -- 
> > > 2.32.0
> > > 
> > 
> > This doesn't do what you think it does. If you want the dev->mtu of all
> > interfaces to get updated at once, you need to do that yourself. Setting
> > ds->mtu_enforcement_ingress will only update the MTU for ports belonging
> > to the same bridge, and for a different reason. Or I'm missing the
> > reason why you're making this change now.
> 
> Got confused by the Documentation. Just to confirm in DSA we don't have
> a way to handle the case where we have one MTU reg that is applied to
> every port, correct?

No we don't, because usually it is not a problem. The interface MTU
represents the minimum L2 payload size that can be accepted and
transmitted by the interface. It can be larger than that.

> We already handle this by checking the max MTU set to all port in the
> port_change_mtu but I was searching a cleaner way to handle this as
> currently we use an array to store the MTU of all port and seems a bit
> hacky and a waste of space. 

It depends on what your goal is. The current implementation seems to get
the job done fine, unless I'm missing something. If you set one
interface's MTU to e.g. 4000, the MTU of the other interfaces will
remain the same at 1500, although they can also receive larger frames.
But to also transmit larger frames on those other ports, you'd have to
increase their MTU as well, and even though that wouldn't increase
anything in hardware, it would tell the kernel to use the larger value.
This is in line with the user interaction that would be required if the
MTU was a per-port value, which seems fine to me.
