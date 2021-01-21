Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A172FE9FB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbhAUM0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbhAUMYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:24:06 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE0C0613C1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 04:23:18 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g12so2293950ejf.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 04:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S8N7yhX1dINgXYzahMjyuEMkUcPg6hu16xnSBBDmAJQ=;
        b=uBZSO3n8umYpk0VOfoeaCwa77KtExQBCLzc9ES/H60K8ItCBvwrFqB/QBzZiS9ykua
         pHMWGKbdEp0lV9UazNRpaZ+wiBiRgZqgGrvEwHSUAKR4PQAtiE+rUi78aCxCR7BvFrM/
         PuCBxtq8QntC0bVfXNfLOcp0vHzKB5RnU7n/nE6urScFB62EhNM+k20hbD7X7fEcNa3a
         BQPztqwH9K3qYKnnak6nKBcU8DssRjc2Fru5WSN2MknCH+1rIGMLqUcXs/3D3JQvXs7b
         OHjVpApy4pd9QkPWFY8JxA4V1DUfKkYbLzawZwJvLOKqN8Bv4eFwipVvAlnkHEXjCmoN
         /OpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S8N7yhX1dINgXYzahMjyuEMkUcPg6hu16xnSBBDmAJQ=;
        b=GzERviC/NsYlfejb5uvlgNZIc/2xo7UCqWwTC8Xh6Wqs85yd9FdekCbp8jib3YJYFp
         6kQRuUYhpSUzrCyoxAPdlg1M+E3mRc6F87fru5LWm5V0BZ6ZGQ5ZhwrAlcadyz5oVmn0
         PXpinqGOBVyuaojB3KlqEj7uuv8xBAL+fqGn+HZtESDziPjJ3zuM94i48plzYWMu4hgZ
         aeGLhTdWV19twuOnB3Qo+EP6OuKvwg9pvsiikWHufPQxH1zDJnen6pcBQYM5VfNmn3+q
         WoXZwmOPkuNw7lr3BffGs1BbyVza0Hlnp0YXLLmMXN9YNUiVUZbpIe9ucSxEYT98pMIW
         P/gA==
X-Gm-Message-State: AOAM531TkMCTrLTn7Pr8bg4juD74OFNd9M+tPF4YdJipNb50ptqvnsF4
        CBPFKiTXWA5Olth7mhY+y7yrqedteOk=
X-Google-Smtp-Source: ABdhPJxFbK8Uo9DctZW/krtbRebqyxplLB1nPmsisCFPGkvCwmb5346ABGGpGxV7NkaiBzJKvbvZ1w==
X-Received: by 2002:a17:906:7d4f:: with SMTP id l15mr1566949ejp.95.1611231796773;
        Thu, 21 Jan 2021 04:23:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a10sm2158713ejk.75.2021.01.21.04.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 04:23:15 -0800 (PST)
Date:   Thu, 21 Jan 2021 14:23:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210121122314.2jfxuwu2cpokx3w5@skbuf>
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-8-olteanv@gmail.com>
 <9c5f179b-056b-f513-6500-eb36f9f8df0e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c5f179b-056b-f513-6500-eb36f9f8df0e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Jan 20, 2021 at 07:53:41PM -0800, Florian Fainelli wrote:
> > +static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
> > +				    struct dsa_notifier_tag_proto_info *info)
> > +{
> > +	int err = 0, port;
> > +
> > +	for (port = 0; port < ds->num_ports; port++) {
> > +		if (!dsa_switch_tag_proto_match(ds, port, info))
> > +			continue;
> > +
> > +		/* Check early if we can replace it, so we don't delete it
> > +		 * for nothing and leave the switch dangling.
> > +		 */
> > +		if (!ds->ops->set_tag_protocol) {
> > +			err = -EOPNOTSUPP;
> > +			break;
> > +		}
> 
> This can be moved out of the loop.

Thanks a lot for reviewing.
Yes, you are right, this can be moved out. It is a left-over from using
dsa_broadcast in the previous version. It is not the only left-over: the
info->tree_index is now redundant because we are notifying within a
single DSA switch tree.

> > +
> > +		/* The delete method is optional, just the setter
> > +		 * is mandatory
> > +		 */
> > +		if (ds->ops->del_tag_protocol)
> > +			ds->ops->del_tag_protocol(ds, port,
> > +						  info->tag_ops->proto);
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static int dsa_switch_tag_proto_set(struct dsa_switch *ds,
> > +				    struct dsa_notifier_tag_proto_info *info)
> > +{
> > +	bool proto_changed = false;
> > +	int port, err;
> > +
> > +	for (port = 0; port < ds->num_ports; port++) {
> > +		struct dsa_port *cpu_dp = dsa_to_port(ds, port);
> > +
> > +		if (!dsa_switch_tag_proto_match(ds, port, info))
> > +			continue;
> > +
> > +		err = ds->ops->set_tag_protocol(ds, cpu_dp->index,
> > +						info->tag_ops->proto);
> > +		if (err)
> > +			return err;
> 
> Don't you need to test for ds->ops->set_tag_protocol to be implemented
> before calling it? Similar comment to earlier, can we do an early check
> for the operation being supported outside of the loop?

My assumption was that I had already added the check in tag_proto_del.
There are no code paths that call one but not the other. I can add the
check here too.

There's one more thing I would change: the dsa_switch_tag_proto_match.
Right now I am matching only on the CPU port, but if I take a look at
the mv88e6xxx driver:

static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
{
	if (dsa_is_dsa_port(chip->ds, port))
		return mv88e6xxx_set_port_mode_dsa(chip, port);

	if (dsa_is_user_port(chip->ds, port))
		return mv88e6xxx_set_port_mode_normal(chip, port);

	/* Setup CPU port mode depending on its supported tag format */
	if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
		return mv88e6xxx_set_port_mode_dsa(chip, port);

	if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
		return mv88e6xxx_set_port_mode_edsa(chip, port);

	return -EINVAL;
}

DSA links call the same function as CPU ports configured for
DSA_TAG_PROTO_DSA. So to cater to Marvell switches too, and to ease a
potential conversion to this API, I could add dsa_is_dsa_port to the
matching function too.
