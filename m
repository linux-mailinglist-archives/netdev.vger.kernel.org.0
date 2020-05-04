Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E51C45B4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgEDSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729958AbgEDSXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:23:05 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB65C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:23:05 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b188so512668qkd.9
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=W89QFzwdJ4a86mFFHyl+0XzZlABu8f6wPmHtba+o2FM=;
        b=gfBlXbwRgFX8szqyF9W2g7Ze+BYXoVJvLxaRCihKpeYMuXGpVpwYz0rk7/ZxnLXPPN
         jQ8TORFvP6INhn6Ls/pAdfLMJdFCAf3c1JT+KSgZ5lLdinZMemHeaZuTHX/wQCSOF98N
         5Wd76CiL6zBeDTAYdU+Gc+6mgk1IBy7vgy0yL01heb/zXFf+rUZw5o1Q2bdtjPmMxLAc
         WxwAzyPK5fX29T9hW74QhMz6ysVwaKuXdT3qu9k4IUHZ7IMlLZvzANmmvtLFgtZwP10x
         AweK5ge35hJd38BWiCxsam3nSUmwB1o9oaS9A72gXOztCU9nE7o5YN5jlY54gdNzUrbE
         AWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=W89QFzwdJ4a86mFFHyl+0XzZlABu8f6wPmHtba+o2FM=;
        b=NI8bas6duU5zKVFdFLhxkR8ZidOVipNwVa7HS/HJOM9DvYwACv2gITx3CUUdUekMP4
         RO+1hA/oSF77VT+a60zW4LFC1AK3MsBA9sTKr9Nd0aSlRMDMjKX2tDfwNzm/74bVIroi
         csO96owl/49hHvReI5rjFFvnwCXdtWNGalUFtME9nxUAT7OrcTYTJ/hLGh88FLiEWWMo
         1Vm4cnBcLTiAPrgd3VuCvCZFg0sRQXnuISdQeEmf1CQNrLsJhQSbBMio4+TTcH/9q3i7
         IZFiXGQETyHf+KqcvfdpSxdb0oLK5k7VG2/0hZr4FmVDDgs/q6pUexOY2SOv/twvB0la
         DNQg==
X-Gm-Message-State: AGi0Pua67p34Rf+qe8uc/R9kxcuNYtegxBKmmH/tCllipq9v9jldpFJ6
        VLfxx9fJYZelCYaxBhb593Y=
X-Google-Smtp-Source: APiQypK5+HDRj4oHpTo9TL4aQ1I4beKhu5UkfYzWcs0y12cytjQFO4qjcZiiElDhMx+FnEu4qZgj9Q==
X-Received: by 2002:a05:620a:1202:: with SMTP id u2mr526289qkj.285.1588616584571;
        Mon, 04 May 2020 11:23:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s8sm11809903qtb.0.2020.05.04.11.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:23:03 -0700 (PDT)
Date:   Mon, 4 May 2020 14:23:02 -0400
Message-ID: <20200504142302.GD941102@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net-next 4/6] net: dsa: sja1105: support flow-based
 redirection via virtual links
In-Reply-To: <20200504141913.GB941102@t480s.localdomain>
References: <20200503211035.19363-1-olteanv@gmail.com>
 <20200503211035.19363-5-olteanv@gmail.com>
 <20200504141913.GB941102@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 14:19:13 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> Hi Vladimir,
> 
> On Mon,  4 May 2020 00:10:33 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > +		case FLOW_ACTION_REDIRECT: {
> > +			struct dsa_port *to_dp;
> > +
> > +			if (!dsa_slave_dev_check(act->dev)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "Destination not a switch port");
> > +				return -EOPNOTSUPP;
> > +			}
> > +
> > +			to_dp = dsa_slave_to_port(act->dev);
> 
> Instead of exporting two DSA core internal functions, I would rather expose
> a new helper for drivers, such as this one:
> 
>     struct dsa_port *dsa_dev_to_port(struct net_device *dev)
>     {
>         if (!dsa_slave_dev_check(dev))
>             return -EOPNOTSUPP;

Oops, NULL, not an integer error code, but you get the idea of public helpers.

>     
>         return dsa_slave_to_port(dev);
>     }
> 
> The naming might not be the best, this helper could even be mirroring-specific,
> I didn't really check the requirements for this functionality yet.
> 
> 
> Thank you,
> 
> 	Vivien
