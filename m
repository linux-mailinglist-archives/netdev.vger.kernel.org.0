Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3927456826
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhKSCgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhKSCgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:36:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A63C061574;
        Thu, 18 Nov 2021 18:33:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so36163319edd.3;
        Thu, 18 Nov 2021 18:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D4E/VvbjTImjT6hdknQHPiigP2+uulrrrS27pwScwLk=;
        b=W1IMXWrzaWv41ks2x86Ctim6RDqiJm22oJDyJyqjeBhwiiYehMvGFGZ4K3eE+d7tzk
         onkLreHhARQZf7PXQWYG1LEM+aaw0nm25ETCBw2MMrM4xbJen7EVyHY5GiTmeIao9gI3
         x+LfeU6SxwYPft9KHPnmeCtpBfvW/RpEx3+7MW/xL1UDlxFswLzHKuShW/Baag9QYuXc
         2j9uFowj8GCfvywcZffEQ4xXkIcswxnY74VK+RAmM/1sqESWqtNclmq2rAEL9fnizG+9
         uVAk6OXztIdsdNl2gezfHOSFIPlf8oG3gvgTfQlgz758yo3YX3/OsMDEB7FVuOQCSddk
         9jXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D4E/VvbjTImjT6hdknQHPiigP2+uulrrrS27pwScwLk=;
        b=MqD0ZhmNXqluvxpGUs9S6UJub+pg80+JwnRqJUjx4d9yV0RIf7MnadkPX2O7LXbk0S
         0f5djkRNhPCXrT5/7SkWOnlJMiKRf7Epn6InRNBFzCMrW2xV2DoUIuD5vB55MUixTVHf
         bpSjcSRPHUxlqfA7g2VESUJ4JVSVoGaAOTPlSWW9qr+0LtOz4B7Cbi+OjMTnzCelvyJZ
         MDMe8gY1AWnFzJrzmoK9IXijZrqvPsIkKZni3S7WSAee0U5z8Rudwd4g9g/fUnzbVngg
         X2xFADn2VHZ7Wz86w1/B3hxFgGchGux0V1dN5QSIuQfk9Nwt/CK90IK8D3bsORxhxiQ4
         1dgQ==
X-Gm-Message-State: AOAM5303K8w4WToQwChfvRI0MUcJ3UJZqHquvJ2uHrGfIVpG/BJ+Kn9b
        n/2k4gBoy9jO/iyLDRMx1FlUqph4Hgs=
X-Google-Smtp-Source: ABdhPJyScpM9dTcacSYSDkxY251rRLBbdckDGnHFyDBXakqNMMpAotPkeHkjSMcbhTaSlbZrlavZXQ==
X-Received: by 2002:a50:9eca:: with SMTP id a68mr18357883edf.127.1637289221012;
        Thu, 18 Nov 2021 18:33:41 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id hv17sm604422ejc.66.2021.11.18.18.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:33:40 -0800 (PST)
Date:   Fri, 19 Nov 2021 04:33:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 14/19] net: dsa: qca8k: add support for
 mdb_add/del
Message-ID: <20211119023339.i6xifnhhe5eli3ck@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-15-ansuelsmth@gmail.com>
 <20211119020657.77os25yh4vhiukvi@skbuf>
 <619709b5.1c69fb81.83cb5.4150@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619709b5.1c69fb81.83cb5.4150@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:19:30AM +0100, Ansuel Smith wrote:
> > > +static int
> > > +qca8k_port_mdb_del(struct dsa_switch *ds, int port,
> > > +		   const struct switchdev_obj_port_mdb *mdb)
> > > +{
> > > +	struct qca8k_priv *priv = ds->priv;
> > > +	struct qca8k_fdb fdb = { 0 };
> > > +	const u8 *addr = mdb->addr;
> > > +	u8 port_mask = BIT(port);
> > > +	u16 vid = mdb->vid;
> > > +	int ret;
> > > +
> > > +	/* Check if entry already exist */
> > > +	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	/* Rule doesn't exist. Why delete? */
> >
> > Because refcounting is hard. In fact with VLANs it is quite possible to
> > delete an absent entry. For MDBs and FDBs, the bridge should now error
> > out before it even reaches to you.
> >
>
> So in this specific case I should simply return 0 to correctly decrement
> the ref, correct?

No, it's fine, don't change anything.

See these?

[  365.648039] mscc_felix 0000:00:00.5 swp0: failed (err=-2) to del object (id=3)
[  365.648071] mscc_felix 0000:00:00.5 swp1: failed (err=-2) to del object (id=3)
[  365.648091] mscc_felix 0000:00:00.5 swp2: failed (err=-2) to del object (id=3)
[  365.648111] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
[  365.648130] mscc_felix 0000:00:00.5 swp4: failed (err=-2) to del object (id=3)
[68736.079878] mscc_felix 0000:00:00.5 swp0: failed (err=-2) to del object (id=3)
[68736.079912] mscc_felix 0000:00:00.5 swp1: failed (err=-2) to del object (id=3)
[68736.079934] mscc_felix 0000:00:00.5 swp2: failed (err=-2) to del object (id=3)
[68736.079954] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
[68736.079974] mscc_felix 0000:00:00.5 swp4: failed (err=-2) to del object (id=3)

err=-2 is -ENOENT, this driver is complaining about the fact that
->port_mdb_del() is called on MDB entries that are no longer in
hardware. And the system isn't doing anything, mind you, just idling.

Long story short, this used to be an issue until commit 3f6e32f92a02
("net: dsa: reference count the FDB addresses at the cross-chip notifier
level") - if you backport anything to v5.10 you'll notice that it'll
complain there, the refcounting is something that appeared in v5.14.

My comment was just to explain "why delete if there's no entry in
hardware" - because there isn't (wasn't) any logic to avoid doing so.

> > > +	if (!fdb.aging)
> > > +		return -EINVAL;
