Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E4475DFB
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245072AbhLOQ5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245068AbhLOQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:56:56 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25740C061574;
        Wed, 15 Dec 2021 08:56:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z7so15741414edc.11;
        Wed, 15 Dec 2021 08:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5b5jU0TCGDw/48m7qe2gUv1TVmRIQHO+I/cM8raoaew=;
        b=acnpFHlgwqM7vtYz2AIsuioSXkjM1vXHntbQPVOev7xHJNQxKiUJnAksFJrMl2WZVJ
         qvA1mm9b7cPQyzbrO2XA8Nh3XwV9imknQhJQccDOXlyCUhc7Qa2Y5VoDeY581rHYvVzX
         N0wJuyY+nyFuVRmJ5QiRz+vBgGxTC+4km30wbGEvodt+Uzw0bROK5PDwG1qTtgYMXhwd
         NmOHa1wsQ+Lqz14+J0iK+IOQkajFPsGJeYt4YVvkcjG+9rOQS0jU6fodMCJf2mBS8/+9
         qkTLdz9A7Z+oAZdQ9mKUjLuouXUvl35OlfbAxoduY7OLuCeh1Xtbf50PBMDJTu8TwZik
         o2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5b5jU0TCGDw/48m7qe2gUv1TVmRIQHO+I/cM8raoaew=;
        b=xdimpZxuDMAQxMvt+gzxJJdM1aqpn4WrMKYktlhrhaaHom85F5wLFwlCAD0ZEJ988Y
         9h5nhQsKLckfWSN5lyOhlel7PO2FY/PO4gkXCGKlm2zjrsVIQfFrJu06IDqMtAYXYckX
         5caf4HsoaIDwQPXsoWuU1xwxkz3BfER6nEVyeYDT/wFUHcvfXGYE0jWTwklU/79moUL3
         5Q4SCJbvF0hwARVo/O94eSrVWKXejfVSZuaR01W3yX7vHPVKbUNWDMOTqa+NtvpgvXcG
         jhK+Bdhs7O+4wQIOWOIWIiH2fJKpHGmLqZbPZylLI8LJtnxCNjpGC8GBDWwDXn0T//oG
         7SGA==
X-Gm-Message-State: AOAM530eDq5MfTjAmA3GMlc2Zc5stY9vC7BaA2gwIKDAmFBDwHy2QSU4
        uJAlEFwpkcyQzQaIpHYU2dUjJzbXw935ZQ==
X-Google-Smtp-Source: ABdhPJye7VaYObMkeycWS7yvnBJlOOkovtexL9i/+aqr9dTICOEhpy5yhW0MeyfbtrwapqjTSEJdMw==
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr15728690edz.96.1639587407222;
        Wed, 15 Dec 2021 08:56:47 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id r25sm1241164edt.21.2021.12.15.08.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:56:46 -0800 (PST)
Message-ID: <61ba1e4e.1c69fb81.7ede4.493e@mx.google.com>
X-Google-Original-Message-ID: <YboeS39tDcaXupxf@Ansuel-xps.>
Date:   Wed, 15 Dec 2021 17:56:43 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 12/16] net: dsa: qca8k: add support for
 mdio read/write in Ethernet packet
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-13-ansuelsmth@gmail.com>
 <20211215124758.4sxjusutfoab5gzt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211215124758.4sxjusutfoab5gzt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 02:47:58PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 14, 2021 at 11:44:05PM +0100, Ansuel Smith wrote:
> > +static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> > +				      enum dsa_tag_protocol proto)
> > +{
> > +	struct qca8k_priv *qca8k_priv = ds->priv;
> > +
> > +	switch (proto) {
> > +	case DSA_TAG_PROTO_QCA:
> > +		struct tag_qca_priv *priv;
> 
> Actually this fails to compile:
> 
> drivers/net/dsa/qca8k.c: In function ‘qca8k_connect_tag_protocol’:
> drivers/net/dsa/qca8k.c:2893:3: error: a label can only be part of a statement and a declaration is not a statement
>  2893 |   struct tag_qca_priv *priv;
>       |   ^~~~~~
> make[3]: *** [scripts/Makefile.build:287: drivers/net/dsa/qca8k.o] Error 1
> 
> This is what the {} brackets are for.
> 
> Also, while you're at this, please name "priv" "tagger_data".
>

I didn't have this error, sorry. Just to make sure I didn't make these kind of
error anymore what compile did you use and with what flags? 

> > +
> > +		priv = ds->tagger_data;
> > +
> > +		mutex_init(&qca8k_priv->mdio_hdr_data.mutex);
> > +		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
> > +
> > +		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> > +
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> >  }

-- 
	Ansuel
