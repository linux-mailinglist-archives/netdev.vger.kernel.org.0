Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36121BE38C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgD2QQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgD2QQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:16:17 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BE6C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:16:14 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AEC4222ED8;
        Wed, 29 Apr 2020 18:16:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588176973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a2nzkHuAooKHpiosYQ35Mk5X3AQv0VvYBHegOxXveQc=;
        b=bOBCbzNFlmZNw0L68KLuKZUFt2oOl4BZ8Ew0aKQ+ax4Fem+1wMqGcGZmObndsJHt8wX6W1
        dIyRnui2U6vxI0tZF5qWiuxeL1E9TKnn8b+VuKAnSLQRFPywv27yvj3/MAJoALVw+AgZO3
        OsF2b21lYQP25FquAZb3mBiFF0DIdf4=
From:   Michael Walle <michael@walle.cc>
To:     andrew@lunn.ch
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable test reports
Date:   Wed, 29 Apr 2020 18:16:05 +0200
Message-Id: <20200429161605.23104-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200425180621.1140452-5-andrew@lunn.ch>
References: <20200425180621.1140452-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: AEC4222ED8
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,davemloft.net,suse.cz,vger.kernel.org,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > > > +enum {
> > > > +	ETHTOOL_A_CABLE_PAIR_0,
> > > > +	ETHTOOL_A_CABLE_PAIR_1,
> > > > +	ETHTOOL_A_CABLE_PAIR_2,
> > > > +	ETHTOOL_A_CABLE_PAIR_3,
> > > > +};
> > > 
> > > Do we really need this enum, couldn't we simply use a number (possibly
> > > with a sanity check of maximum value)?
> > 
> > They are not strictly required. But it helps with consistence. Are the
> > pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?
> 
> OK, I'm not strictly opposed to it, it just felt a bit weird.

Speaking of the pairs. What is PAIR_0 and what is PAIR_3? Maybe
it is specified somewhere in a standard, but IMHO an example for
a normal TP cable would help to prevent wild growth amongst the
PHY drivers and would help to provide consistent reporting towards
the user space.

-michael
