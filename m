Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B701C46FD
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEDTYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDTYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:24:32 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D49C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:24:32 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di6so229208qvb.10
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=/mUqdVtF70H+35IVX4FCu5eCLVKu3U0NlGPYWJMhDjc=;
        b=i0Na3U+QitmTMxU9mhgCA1nX2pJsofRxZMM0Xz2ac1l/LNFVYe4kiz/NYQOlRiQEub
         GDAVU6ioWZN4EKWy+sXjawq+9cGXxuLJyV5qNCvHr4oaYHakdYZFLJuub0Ehi0YwBs9R
         4tTtdF+QTMXRdKUJQGsxHi+bVm4+4hJNUCW2lCQSoXIBa5puzn/KAn2LbnGk3cjvJS5n
         A+e7wrbhwf8CSlf1Uejl+AR9akwUzTyp6ufdqFUF/jDCG2smFcYZc6sKTWWLv07MNQqM
         sJnzkGiCwX8REzLU+vyD+0q9Crjan+AufATmO22zkSytSDUrMvSHakQCjhP4yPfr3+n0
         /r3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=/mUqdVtF70H+35IVX4FCu5eCLVKu3U0NlGPYWJMhDjc=;
        b=fLTsetxntAFOlIejwUHzYtzI2E2cAqypZMuGAV54j3nv61taEsASf70Iddxc9Geejt
         ntHnCBMEmnM534dqYK6HtPwARjTaW4w3efGIBDq0kHYk+/aDdkYl+REBIq/pwL4XKEIP
         W34bbRszzc5BG6yEaVgTe9YEFC+pSUbeHkTseHcnacmrU+YxuBbjnnf24WS04S56i+30
         n9yC5k1rRFyYPpJThzp6alQ9NZnvzJXhzpsTP1K9IliJGRnShxfn9E3ED7yy+uTlVLAL
         DjbiYFwscmmTcAQf0NfJ4bWL+kn32W99KYQb98tLBdM6jG5tqhoqY+6eMLelCoP5msk8
         wzzQ==
X-Gm-Message-State: AGi0PubJ4/FrIziZ8xZK1/buimp1OLnNX7IhZAbwDxEPaXx1/VuerrxZ
        VtphmETBYOD12KPNTZ+agJ4TJHQLunE=
X-Google-Smtp-Source: APiQypJq6yZoC0LfYT2TK5PLZNksH95nbH9vqhwGcUKfSBWuE2Yx21Y53asbU6TeuerV1JlJ1Y57xg==
X-Received: by 2002:a05:6214:7e1:: with SMTP id bp1mr666914qvb.208.1588620271190;
        Mon, 04 May 2020 12:24:31 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g16sm8765792qkk.122.2020.05.04.12.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 12:24:30 -0700 (PDT)
Date:   Mon, 4 May 2020 15:24:28 -0400
Message-ID: <20200504152428.GB950689@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        vlad@buslov.dev, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 4/6] net: dsa: sja1105: support flow-based
 redirection via virtual links
In-Reply-To: <CA+h21howxs23VkvTVk3BiepQz7Z1vXgRiE1w+F1eeHYqYZmLpA@mail.gmail.com>
References: <20200503211035.19363-1-olteanv@gmail.com>
 <20200503211035.19363-5-olteanv@gmail.com>
 <20200504141913.GB941102@t480s.localdomain>
 <20200504142302.GD941102@t480s.localdomain>
 <CA+h21howxs23VkvTVk3BiepQz7Z1vXgRiE1w+F1eeHYqYZmLpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, 4 May 2020 21:38:26 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Vivien,
> 
> On Mon, 4 May 2020 at 21:23, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> >
> > On Mon, 4 May 2020 14:19:13 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > > Hi Vladimir,
> > >
> > > On Mon,  4 May 2020 00:10:33 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > +           case FLOW_ACTION_REDIRECT: {
> > > > +                   struct dsa_port *to_dp;
> > > > +
> > > > +                   if (!dsa_slave_dev_check(act->dev)) {
> > > > +                           NL_SET_ERR_MSG_MOD(extack,
> > > > +                                              "Destination not a switch port");
> > > > +                           return -EOPNOTSUPP;
> > > > +                   }
> > > > +
> > > > +                   to_dp = dsa_slave_to_port(act->dev);
> > >
> > > Instead of exporting two DSA core internal functions, I would rather expose
> > > a new helper for drivers, such as this one:
> > >
> > >     struct dsa_port *dsa_dev_to_port(struct net_device *dev)
> > >     {
> > >         if (!dsa_slave_dev_check(dev))
> > >             return -EOPNOTSUPP;
> >
> > Oops, NULL, not an integer error code, but you get the idea of public helpers.
> >
> > >
> > >         return dsa_slave_to_port(dev);
> > >     }
> > >
> > > The naming might not be the best, this helper could even be mirroring-specific,
> > > I didn't really check the requirements for this functionality yet.
> > >
> > >
> > > Thank you,
> > >
> > >       Vivien
> 
> How about
> 
> int dsa_slave_get_port_index(struct net_device *dev)
> {
>     if (!dsa_slave_dev_check(dev))
>         return -EINVAL;
> 
>     return dsa_slave_to_port(dev)->index;
> }
> EXPORT_SYMBOL_GPL(dsa_slave_get_port_index);
> 
> also, where to put it? slave.c I suppose?

dsa.c is the place for private implementation of public functions. "slave"
is a core term, no need to expose it. Public helpers exposed in dsa.h usually
scope the dsa_switch structure and an optional port index. mv88e6xxx allows
mirroring an external device port, so dsa_port would be preferred, but this
can wait. So I'm thinking about implementing the following:

net/dsa/dsa.c:

int dsa_to_port_index(struct dsa_switch *ds, struct net_device *dev)
{
    struct dsa_port *dp;

    if (!dsa_slave_dev_check(dev))
        return -ENODEV;

    dp = dsa_slave_to_port(dev);

    if (dp->ds != ds)
        return -EINVAL;

    return dp->index;
}

include/net/dsa.h:

int dsa_to_port_index(struct dsa_switch *ds, struct net_device *dev);


What do you think?

	Vivien
