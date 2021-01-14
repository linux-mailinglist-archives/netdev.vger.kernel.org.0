Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27CC2F6791
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbhANR0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbhANR0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:26:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CB6C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:25:49 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jx16so9314060ejb.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MN1P/byoRfR9Hq6wBCiqv6JgQsQ0T1EMsT5TJM4NAhA=;
        b=J0/3WlXU09Veqlym+vAeqPR08dTqSxuvpNR6UXa8OeMSLfON8rWJqMEI8nlzQ4GqYr
         vnhul6bXNfPls2V7GVzXOc3ljcU2/04Rp2I5IEo4w/UsuaVbn+O7ZrTFfZJiBXKIf4rp
         Q6utDPqjO8a195ZqVONnimzpupu5AIogkdqN9r1nsJVyWuC8v+tGdjeJt7Fiwywjl45Z
         WuC5GqW+z8Pm0kqlpUxprSc5TKXqzuCflXEbzp/EGpMWazOKUQAM8cM+YnfLQcp3SE0b
         VovhhhPNxYVV7a+B1/GgfvtIm/3wUn8oXMeXydprzdz4Se4JkmUr722QrzkkNefVvvCJ
         XsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MN1P/byoRfR9Hq6wBCiqv6JgQsQ0T1EMsT5TJM4NAhA=;
        b=ah1Nx4lpx1C72fcNK24FRe0r6rRyJcwOfhSnfHkQsn8Hh0smYJpWGCuTMWNt2IZAJc
         1c3babIXdwVoLtjWggwsrTS20Ho2tVYCV1bBnCwShJVcFD9ZfqiqyjHI/0zv0WXfsSpI
         UcYJGThQmlfN0nil1IiMo2MWxw0nxSyLWq9oRuPsfKnAEIIbk+8+Nipvnx+v1XmSeIR9
         lDzBE+4b2JZv3lMz09gZdp5TS3CjaWvOiOm9NrENQkA7FmashBmif1lxmL+Tz5GJZ2wc
         XLfpU4QZqsOsqtLNsfgRz/dyHEoZSojZWvX0PZA2voPrYP9JS7P58Q5ERG09oFXL2Ypw
         MC4g==
X-Gm-Message-State: AOAM5322+6Yf0lVrtulKg4ANLt0aejXU9cT3om+Fd10k1nvPzORwdRbK
        4sePvXJi7AptNC0NOPdwXRE=
X-Google-Smtp-Source: ABdhPJw9B9TIxpqxyKrxCTG1vJJVV9CShzFDRTfdQY78ybZi6Rul2k+eCvkiwyD2GiUDacDgj3c5lg==
X-Received: by 2002:a17:906:e18:: with SMTP id l24mr5763974eji.434.1610645148122;
        Thu, 14 Jan 2021 09:25:48 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f8sm2404598eds.19.2021.01.14.09.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:25:47 -0800 (PST)
Date:   Thu, 14 Jan 2021 19:25:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210114172545.a4ikhnt5fgu5dllp@skbuf>
References: <20210111174316.3515736-1-olteanv@gmail.com>
 <20210111174316.3515736-9-olteanv@gmail.com>
 <20210113193033.77242881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114102743.etmvn7jq5jcgiqxk@skbuf>
 <20210114091943.3236215f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114091943.3236215f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 09:19:43AM -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 12:27:43 +0200 Vladimir Oltean wrote:
> > On Wed, Jan 13, 2021 at 07:30:33PM -0800, Jakub Kicinski wrote:
> > > On Mon, 11 Jan 2021 19:43:14 +0200 Vladimir Oltean wrote:
> > > > +struct ocelot_devlink_private {
> > > > +	struct ocelot *ocelot;
> > > > +};
> > >
> > > I don't think you ever explained to me why you don't put struct ocelot
> > > in the priv.
> > >
> > > -	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
> > > -	if (!ocelot)
> > > +	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
> > > +	if (!devlink)
> > >                  return -ENOMEM;
> > > +	ocelot = devlink_priv(ocelot->devlink);
> >
> > Because that's not going to be all? The error path handling and teardown
> > all need to change, because I no longer use device-managed allocation,
> > and I wanted to avoid that.
>
> Come on, is it really hard enough to warrant us exchanging multiple
> emails? Having driver structure in devlink priv is the standard way
> of handling this, there's value in uniformity.

I did as you requested in v5 anyway. It does not save me of having to
keep a devlink pointer in struct ocelot though, due to the fact that the
layout with struct devlink being a container of struct ocelot is not
common between the DSA felix driver and the switchdev ocelot driver. So
much for uniformity.
