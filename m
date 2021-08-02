Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7C3DDC96
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhHBPhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhHBPhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:37:37 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E9EC06175F;
        Mon,  2 Aug 2021 08:37:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qk33so31516394ejc.12;
        Mon, 02 Aug 2021 08:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XB6BGIdQEwggVbLWSap7UjJdUQbesE+7hXxtVRkvtSk=;
        b=rDgtou/WbtTDhDKzfBGhBu4uvJfyhWBsWAxHFuW9Uzlp5nJ3BeYLS9hFJ6uYan+XlA
         v64gxnDd+uPjdy5P40q3FE3aFbjQaYfl6fVsYz9S/ZvgipjkqocwLLC/k65S+tT4GD/V
         6qRfZ/LFxNexi7P7IaYSo1a1ORsD+p0GdQU3kJVmIcs83pNTtbyNvp29pTiq7tZdwaQy
         1+xgrNvtS6cqNcaOeGDbMZAqyq6zwpgjD5vYW0/zb4OUymOVJpJcKO3EYTOArQWfWfs5
         pxWTHz/GplFX1P0MaGR+nqqgz7Us6YE2zb6I/zjsBy03P49f9Dt1GOKxG1FEhRxt7LqB
         eKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XB6BGIdQEwggVbLWSap7UjJdUQbesE+7hXxtVRkvtSk=;
        b=XofECvqOLeBp2+Miyd+zXOAaUsjrh5anWBd2T+y3oNzkkQFery7nwvo3aa1eoRuI5Z
         q3JWXS9oqgw89SEnBIf7rRXtmDosNB5HM5DK+oBDyMrT7UKZb9pa0eay6oPQddTNh01y
         Ounl1TYxcPPPDlRpZqikml5aumHcmqQJ5ofQObp4E6EeBmHyfYpTM7PWUDD7YIVSvV8v
         LDKUlG+mOxj3XDl4Akrw5iIHbOLgJBZ0y8VVQ32r8bWw2GsN0sMr/d3923sDO2UgE9Jp
         tVgCqhNxiL8m9KHsIaLDtPpzsz0a54mly3FNQ+BMyjtqW5cVwsbbTJfXdg7+VJKbgJaZ
         vVCA==
X-Gm-Message-State: AOAM530pYPoCDTqzbVdJCJne1oBhwTLswPL+9OnPJe1czXJJDX7Pfj4t
        +4dY9bIqLtAlH/SMAHFQ+Fc=
X-Google-Smtp-Source: ABdhPJwNA606jeIUW8D3Xc9aglUyLqwZ8AK4aJSyOW9uThzja/YvGoz+mlh0pFUyNiwzwVegXRONCA==
X-Received: by 2002:a17:906:49d5:: with SMTP id w21mr15755703ejv.30.1627918645497;
        Mon, 02 Aug 2021 08:37:25 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id l9sm1105962edt.55.2021.08.02.08.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:37:25 -0700 (PDT)
Date:   Mon, 2 Aug 2021 18:37:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/6] net: dsa: qca: ar9331: add forwarding
 database support
Message-ID: <20210802153723.vp4phpinclsuhlzz@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:34PM +0200, Oleksij Rempel wrote:
> +static int ar9331_sw_port_fdb_add(struct dsa_switch *ds, int port,
> +				  const unsigned char *mac, u16 vid)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	u16 port_mask = BIT(port);
> +
> +	if (vid)
> +		return -EINVAL;

When did you test this patch last time on net-next?
Asking because when a port joins a VLAN-aware bridge, it will replay the
FDB entries towards the bridge, which include a VLAN-unaware FDB entry
with VID 0, and a VLAN-aware one with the bridge's default_pvid.
If you return -EINVAL, that br_fdb_replay call will fail and you will
fail to join the bridge.

> +
> +	return ar9331_sw_port_fdb_rmw(priv, mac, port_mask, 0);
> +}
> +
> +static int ar9331_sw_port_fdb_del(struct dsa_switch *ds, int port,
> +				  const unsigned char *mac, u16 vid)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	u16 port_mask = BIT(port);
> +
> +	if (vid)
> +		return -EINVAL;
> +
> +	return ar9331_sw_port_fdb_rmw(priv, mac, 0, port_mask);
> +}
