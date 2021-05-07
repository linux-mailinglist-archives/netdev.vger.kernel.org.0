Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF533376D42
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhEGX1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGX1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 19:27:03 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9EC061574;
        Fri,  7 May 2021 16:26:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t18so10780168wry.1;
        Fri, 07 May 2021 16:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vbrNxANfkOr6pEcFz9icGSiGQCo3L7gVB2ABhVnqq5w=;
        b=dCRYuTURbMLll5rWraaAKd3bSKKZNtNlGwWApBo/FChUFbI4q76Lw+OlT/dWIUTwUP
         DBU2JPRCK7DLY2PgINYc1iGdS8CA6ZCVFqLde4g3jGVEw/Hjy+dbvDsTsFf5ecWuGGu5
         +F7HHxqS7IGt140RvJpt7C18RX/LqU3VM7SFHIx5M0a1nm/bRxRjqfvJwIByBRzqu9pp
         e6WAU0p0rNg6NRRC2I8Ta2nUPG77vVBIgp7KvBMn2SaU8MqHLujhRgdyeXR9WcjKrLR3
         IBtrvCoNOT/OSFm+t1EwPIBtOZqpHzsu5H6cHR9oSzFcH7KRFO2/pE4kiZLFvFR09odD
         ggsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vbrNxANfkOr6pEcFz9icGSiGQCo3L7gVB2ABhVnqq5w=;
        b=QovNsMX/bEUiQqala0Pb0QiAgBc8uj4xb6rTuxny/lDLOiHH/Rw9llACAX3TkQ39f2
         jiEsoUlbMZ5X2c8JwpGwScMJkabnjvK/ApOpPHUChGc3D8EC8KbVFGbgFjJ9rrdwxxXr
         NDwpqz2Kt8rbN3xW/D59nq6uco/ZBNG+aC5nFadjylDIdDtDUl7f6T2vVW9w4oaucv/B
         O844kOdk9ZqPIHOdY0C6laIGiT4NwV/BB9bwmZeUJgeObjPl+8kL5GiF6ngbW3uZs0dZ
         JsFUaGbGiEXkf2t0vaD63pGyWgyHwFM/OEhMwiuOYrA9yYi8H0Gcuo1iwVM2q8WUOTyt
         Z3WA==
X-Gm-Message-State: AOAM5336a3HPxamhKpXlwCz6/Yx7VezWukbKfydWZCL3MPntf5Hith45
        Fi51jJJv5wYaLOqlGLC+SJ+phmljY2KFIA==
X-Google-Smtp-Source: ABdhPJwLcFoOHeex3b8IxFhZ5pDw7vWc05H6B7S+FG0Kr/0KhIhFN67Waj/nBB03wqXQyQlnAEdQrQ==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr15446327wrw.108.1620429959944;
        Fri, 07 May 2021 16:25:59 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id a9sm8371790wmj.1.2021.05.07.16.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 16:25:59 -0700 (PDT)
Date:   Sat, 8 May 2021 01:26:02 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <YJXMit3YfBXKM98j@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
 <20210506112458.yhgbpifebusc2eal@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506112458.yhgbpifebusc2eal@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 02:24:58PM +0300, Vladimir Oltean wrote:
> On Wed, May 05, 2021 at 12:29:13AM +0200, Ansuel Smith wrote:
> > Define get_phy_flags to pass switch_Revision needed to tweak the
> > internal PHY with debug values based on the revision.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index b4cd891ad35d..237e09bb1425 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1654,6 +1654,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
> >  	return ret;
> >  }
> >  
> > +static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +
> > +	pr_info("revision from phy %d", priv->switch_revision);
> 
> Log spam.
> 
> > +	/* Communicate to the phy internal driver the switch revision.
> > +	 * Based on the switch revision different values needs to be
> > +	 * set to the dbg and mmd reg on the phy.
> > +	 * The first 2 bit are used to communicate the switch revision
> > +	 * to the phy driver.
> > +	 */
> > +	if (port > 0 && port < 6)
> > +		return priv->switch_revision;
> > +
> > +	return 0;
> > +}
> > +
> >  static enum dsa_tag_protocol
> >  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
> >  		       enum dsa_tag_protocol mp)
> > @@ -1687,6 +1705,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> >  	.phylink_mac_config	= qca8k_phylink_mac_config,
> >  	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
> >  	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
> > +	.get_phy_flags		= qca8k_get_phy_flags,
> >  };
> >  
> >  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > -- 
> > 2.30.2
> > 
> 
> Florian, I think at one point you said that a correct user of
> phydev->dev_flags should first check the PHY revision and not apply
> dev_flags in blind, since they are namespaced to each PHY driver?
> It sounds a bit circular to pass the PHY revision to the PHY through
> phydev->dev_flags, either that or I'm missing some piece.

Just to make sure. This is the SWITCH revision not the PHY revision. It
was pointed out in old version that I should get this value from the PHY
regs but they are different values. This is why the dsa driver needs to
use the dev_flags to pass the SWITCH revision to the phy driver. Am I
implementing this in the wrong way and I should declare something to
pass this value in a more standard way? (anyway i'm pushing v4 so i
don't know if we should continue that there)

