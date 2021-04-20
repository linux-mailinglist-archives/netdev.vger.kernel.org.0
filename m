Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA28E3653E7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhDTIVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhDTIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:21:17 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E175C06174A;
        Tue, 20 Apr 2021 01:20:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y3so7680756eds.5;
        Tue, 20 Apr 2021 01:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpUVM6DLGPNfVadjMrY94cpXZGTdruG63Wzesfn55es=;
        b=RaNBkPjah7sMGOsN5eQAC5h9N0FeHARo/mtafE743B/oBuKn06NLSSj5EbjlvuPtJp
         uUbB4/JI2BrPIiE7r5NqMD0jGB3/7ZlJPw4z5zGhKrhd+85zmMe+V+t69nXxFJSXMqiY
         q3kPySV08rcS5iPJwGVwkb0Dd2cASsmER/od4eMSzJH1canAHTwtRtJM1vPIZ1Z9zcCV
         0jXYkLI8r0p0n48gNQ3M0XPlos+jxozwZ9bQQ7prHjO04eakSB+SFW8KdjdxWCjb4jQ/
         kfZXCzM+vTC8shl65zN4IbZZEOc1aHl/x3WWNVEdrElzDdoGHcHHdWZpUZ8v7iKzEts6
         EiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bpUVM6DLGPNfVadjMrY94cpXZGTdruG63Wzesfn55es=;
        b=AhkzacmCHDWUczeDL855FNTOMASEpTZwc3y3fmzIjRX4yE5uOMGD86AW7KQXSNhO0W
         zMNl5Y6FHNmR65/Xi/oHuV6DkA/Cfv2/7/mLEFRYlgabH5HEhe7GOrH3qjON1Ysg2Gre
         FnNPanQh12LYpAYt3mc3x/4gwRtAUVAJWdiLMxRWc4M8/qXxR8r1VidB5h5sP08C1ReR
         XYuNdGhnETaYJAQj1bC6IuWkOObmiV6zX3vNwJNSC/qmGz7rJ5LmApvVQzf1z1jtw3hU
         ahNlOl5KvW3mDDLiu//YdCv3Mb+0Q8Yopk74PvmaEunQl8mfWNoywK1ZYJpmvNRB5hvs
         CODA==
X-Gm-Message-State: AOAM5316OyVTQ9o6AqgGPFfReKc0Z4JA+jDipZSpi0/PzX3gryKmr7OF
        I/1d3cDLsUumCecbtiNH87k=
X-Google-Smtp-Source: ABdhPJyY1xR1JA81jnOLYKmFXQQhdiH1ydyHrrj8Jdb7eJaUMTvU73MFe1QiUZ7Yp3OEiljNBnGi8w==
X-Received: by 2002:a05:6402:350e:: with SMTP id b14mr1115170edd.307.1618906843215;
        Tue, 20 Apr 2021 01:20:43 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gn19sm11673126ejc.68.2021.04.20.01.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 01:20:42 -0700 (PDT)
Date:   Tue, 20 Apr 2021 11:20:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
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
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 3/3] net: mscc: ocelot: support PTP Sync one-step
 timestamping
Message-ID: <20210420082041.tcthzr6ubtdk6ztf@skbuf>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-4-yangbo.lu@nxp.com>
 <20210418094609.xijzcg6g6zfcxucp@skbuf>
 <AM7PR04MB6885B46EB5C55BD1B92DD746F8489@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB6885B46EB5C55BD1B92DD746F8489@AM7PR04MB6885.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 07:33:39AM +0000, Y.b. Lu wrote:
> > > +	/* For two-step timestamp, retrieve ptp_cmd in DSA_SKB_CB_PRIV
> > > +	 * and timestamp ID in clone->cb[0].
> > > +	 * For one-step timestamp, retrieve ptp_cmd in DSA_SKB_CB_PRIV.
> > > +	 */
> > > +	u8 *ptp_cmd = DSA_SKB_CB_PRIV(skb);
> >
> > This is fine in the sense that it works, but please consider creating something
> > similar to sja1105:
> >
> > struct ocelot_skb_cb {
> > 	u8 ptp_cmd; /* For both one-step and two-step timestamping */
> > 	u8 ts_id; /* Only for two-step timestamping */ };
> >
> > #define OCELOT_SKB_CB(skb) \
> > 	((struct ocelot_skb_cb *)DSA_SKB_CB_PRIV(skb))
> >
> > And then access as OCELOT_SKB_CB(skb)->ptp_cmd,
> > OCELOT_SKB_CB(clone)->ts_id.
> >
> > and put a comment to explain that this is done in order to have common code
> > between Felix DSA and Ocelot switchdev. Basically Ocelot will not use the first
> > 8 bytes of skb->cb, but there's enough space for this to not make any
> > difference. The original skb will hold only ptp_cmd, the clone will only hold
> > ts_id, but it helps to have the same structure in place.
> >
> > If you create this ocelot_skb_cb structure, I expect the comment above to be
> > fairly redundant, you can consider removing it.
> >
>
> You're right to define the structure.
> Considering patch #1, move skb cloning to drivers, and populate DSA_SKB_CB(skb)->clone if needs to do so (per suggestion).
> Can we totally drop dsa_skb_cb in dsa core? The only usage of it is holding a skb clone pointer, for only felix and sja1105.
> Actually we can move such pointer in <device>_skb_cb, instead of reserving the space of skb for any drivers.
>
> Do you think so?

The trouble with skb->cb is that it isn't zero-initialized. But somebody
needs to initialize the clone pointer to NULL, otherwise you don't know
if this is a valid pointer or not. Because dsa_skb_tx_timestamp() is
called before p->xmit(), the driver has no way to initialize the clone
pointer by itself. So this was done directly from dsa_slave_xmit(), and
not from any driver-specific hook. So this is why there is a
DSA_SKB_CB(skb)->clone and not SJA1105_SKB_CB(skb)->clone. The
alternative would be to memset(skb->cb, 0, 48) which is a bit
sub-optimal because it initializes more than it needs. Alternatively, it
might be possible to introduce a new property in struct dsa_device_ops
which holds sizeof(struct sja1105_skb_cb), and the generic code will
only zero-initialize this number of bytes.
I don't know, if you can get it to work in a way that does not incur a
noticeable performance penalty, I'm okay with whatever you come up with.
