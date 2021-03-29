Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F834C4B2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhC2HQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhC2HQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 03:16:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE558C061574;
        Mon, 29 Mar 2021 00:16:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x21so13044514eds.4;
        Mon, 29 Mar 2021 00:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FJcPCNegtTNY6tjrs0+qJzDacUnxk6/HlUNmGPp/Ezs=;
        b=A8JlPkDBNZoMCmparFyuMFqTBBL8NymWvmW17R+Yk3I8T6I3QcgyZA2gJLJ5bU7pd1
         MMDZI/qKBH0skcjyOj9gP7EDc/Edlr8oetIoEHYf/UiLwQz7qCdTtxR6VbZPhDr6fi2h
         XeITrvDLDCPIk7d3eEK+RPMiOZIguwr53/67q44+ZaOFak7EeD7zPEQN9C+jwuh9YcFn
         Gzb/Qlpfpb/mlYHeS3iBXY96fMGmLfUm5EAe2O7VvV8JMy4nan692l1XrnILrcRQxiIr
         bfzucm9nPSIZ+xYzME8AFhfvjPMjXeZ2IUoyszp7CQZcsdcNoKOpD71XFPTa/1s54Aqn
         LIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FJcPCNegtTNY6tjrs0+qJzDacUnxk6/HlUNmGPp/Ezs=;
        b=UbBAbqX+MvqCi49TA9wXKIvmfAf0GSdAZO/MyOSq78x4kJz1MGKdHxPSm0ImiYgITx
         4QNJnVjlC6a2ZduNED4c9pVleRjw71ZPfBPpJ0clWWENuoLXjkyPRwKJgV0g0f/N2dOJ
         X5LnHBtBsvCPJ/i/h4NDWdnn+QjzfjGo50oSReuIgAuO6iTAN+ebhbzV8DvoHtKClBoz
         IPBS4R0Nskj3+J50VWqcSsSDMMVVlyNDsB1GH+eZAE1vyRoTdzHBd5WHl1O/fDCHBkX/
         caihovjXgaEhQ6+dl98SJNAzDnE1Enci3wH3fnwIFgS9GdYK6l0GjcXrA5ynMI1zP5ny
         ObnA==
X-Gm-Message-State: AOAM530auEACUASoiBcIRhqYtbT2jA1zhPopQ5fg4L1ftheEjZv07GPT
        PdT4rqpPHUvq1CB1osYGzyQ=
X-Google-Smtp-Source: ABdhPJwV2N9jQkHfaPnw02erYh3eVSN2frpGIkfJ/Is+KJo2kbOtZu3jsOxq143bPZJhj//ecU9/Fw==
X-Received: by 2002:a05:6402:11c9:: with SMTP id j9mr27178789edw.348.1617002160538;
        Mon, 29 Mar 2021 00:16:00 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i2sm8468828edy.72.2021.03.29.00.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 00:16:00 -0700 (PDT)
Date:   Mon, 29 Mar 2021 10:15:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <20210329071559.nmg56nxft5vim5r7@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
 <YGCmS2rcypegGmYa@lunn.ch>
 <20210328215309.sgsenja2kmjx45t2@skbuf>
 <YGD9d/zeJtAXxC8K@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGD9d/zeJtAXxC8K@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:04:39AM +0200, Andrew Lunn wrote:
> On Mon, Mar 29, 2021 at 12:53:09AM +0300, Vladimir Oltean wrote:
> > On Sun, Mar 28, 2021 at 05:52:43PM +0200, Andrew Lunn wrote:
> > > > +static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
> > > > +{
> > > > +	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
> > > > +	struct dsa_switch_tree *dst = ds->dst;
> > > > +	int port, err;
> > > > +
> > > > +	if (tag_ops->proto == dst->default_proto)
> > > > +		return 0;
> > > > +
> > > > +	if (!ds->ops->change_tag_protocol) {
> > > > +		dev_err(ds->dev, "Tag protocol cannot be modified\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	for (port = 0; port < ds->num_ports; port++) {
> > > > +		if (!(dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port)))
> > > > +			continue;
> > >
> > > dsa_is_dsa_port() is interesting. Do we care about the tagging
> > > protocol on DSA ports? We never see that traffic?
> >
> > I believe this comes from me (see dsa_switch_tag_proto_match). I did not
> > take into consideration at that time the fact that Marvell switches can
> > translate between DSA and EDSA. So I assumed that every switch in the
> > tree needs a notification about the tagging protocol, not just the
> > top-most one.
>
> Hi Vladimir
>
> static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
> {
>         if (dsa_is_dsa_port(chip->ds, port))
>                 return mv88e6xxx_set_port_mode_dsa(chip, port);
>
> So DSA ports, the ports connecting two switches together, are hard
> coded to use DSA.
>
>         if (dsa_is_user_port(chip->ds, port))
>                 return mv88e6xxx_set_port_mode_normal(chip, port);
>
>         /* Setup CPU port mode depending on its supported tag format */
>         if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
>                 return mv88e6xxx_set_port_mode_dsa(chip, port);
>
>         if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
>                 return mv88e6xxx_set_port_mode_edsa(chip, port);
>
> CPU ports can be configured to DSA or EDSA.
>
> The switches seem happy to translate between DSA and EDSA as needed.

I agree, and this is a particular feature of Marvell, not something that
can be said in general. However, I have nothing against deleting the
dsa_is_dsa_port checks from dsa_switch_tag_proto_match and from Tobias'
patch, since nobody needs them at the moment.
