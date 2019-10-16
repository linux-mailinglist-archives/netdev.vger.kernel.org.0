Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6547FD8F74
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404949AbfJPLbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:31:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35750 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbfJPLbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:31:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so2382697wmi.0
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 04:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gasO2NKYvI0S5z8iOzj6BlRaqKD0q5Pd3Yh4RN2L7cg=;
        b=JVgXvzeaus/TLOkJgTNAugQgISTXqvDqTOmQEJ05+Sit18bSi4thJ+qmmlUAUt+qd3
         mBY479gtPwPeX43UYrV6Y47CJts5LxLL4ZvIK5fiFj/EcLGq+mo6jqJIhI+z6us7l7ay
         LGiZOaL6JUoBhTqWW7LJz/FkFCaEdFAPfA2paFsAJ6x5ERSN/l/6cxPRbZNZcTXfKKXG
         6Mm3kDVebpT60nWQA5xGBB/GDPdl2OQ8B2UXnEJdtJM2cfLOKZyGDaOOlozx1BI99EeU
         Ds8PsEqUGI3tVC8DoaUemwvl5Wmsh8EQ0PjYSrRc6oyyWCN8xp7v+e4qIh3sSEtqG2l+
         AhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gasO2NKYvI0S5z8iOzj6BlRaqKD0q5Pd3Yh4RN2L7cg=;
        b=Mxc71f27bffVq4+aWUUGwr8y0yXzlAxmtc25+ZMjfEkbRAUThMZzLt3sff9jDifgun
         pLCqcz6lL94+4H79kiwvbckVv5kZ7Ab3/Jd8ZZgbdt8jk9zeguoKF30rrh2EJY7yycQl
         wRXzmcTLtAxIR2LWL/9m4n729u4Qe+PeYvxXzmP2BtIEti8WpkpCdl2i4T7QKG6f8Gd2
         od3iGIryYzyjOirev9aLBXt723pc7nqKeImB+WwcZgBMn70j3cyOgWpTfrLPtbBZCMRg
         JysFcNDhdIefYd84P8dyVpq5mE99/7q+dEwcqrpWLcqa8EjV9yKzYQ9LFWblviJ0Up5j
         domQ==
X-Gm-Message-State: APjAAAVM6iW6INc3ce2/RbqUfQXDkKpOwlZhANcteMLKKfZe+G6cRnCT
        RcKJ6NbdUNJHTbli5YsImK5+vQ==
X-Google-Smtp-Source: APXvYqy8u+0ytJMC02uxQNM8/B+/eup0sZvLJPLiPtvmgkuRh9EPXtkjB8XiKLaePbcF+CP9PmzVrw==
X-Received: by 2002:a7b:ca4d:: with SMTP id m13mr3019579wml.95.1571225470993;
        Wed, 16 Oct 2019 04:31:10 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id o18sm6039337wrm.11.2019.10.16.04.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 04:31:10 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:31:08 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>
Subject: Re: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
 connect/disconnect event
Message-ID: <20191016113106.j3fuxpkjwxmanhak@netronome.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
 <1571211383-5759-2-git-send-email-ioana.ciornei@nxp.com>
 <20191016110751.rkt3tgdlkxjf4ip3@netronome.com>
 <VI1PR0402MB28006BF6356B03030C245E78E0920@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28006BF6356B03030C245E78E0920@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 11:10:56AM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
> > connect/disconnect event
> > 
> > On Wed, Oct 16, 2019 at 10:36:22AM +0300, Ioana Ciornei wrote:
> > > From: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> > >
> > > Add IRQ for the DPNI endpoint change event, resolving the issue when a
> > > dynamically created DPNI gets a randomly generated hw address when the
> > > endpoint is a DPMAC object.
> > >
> > > Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> > > Changes in v2:
> > >  - none
> > > Changes in v3:
> > >  - none
> > >
> > >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++++-
> > >  drivers/net/ethernet/freescale/dpaa2/dpni.h      | 5 ++++-
> > >  2 files changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > index 162d7d8fb295..5acd734a216b 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > @@ -3306,6 +3306,9 @@ static irqreturn_t dpni_irq0_handler_thread(int
> > irq_num, void *arg)
> > >  	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
> > >  		link_state_update(netdev_priv(net_dev));
> > >
> > > +	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
> > > +		set_mac_addr(netdev_priv(net_dev));
> > > +
> > >  	return IRQ_HANDLED;
> > >  }
> > >
> > > @@ -3331,7 +3334,8 @@ static int setup_irqs(struct fsl_mc_device *ls_dev)
> > >  	}
> > >
> > >  	err = dpni_set_irq_mask(ls_dev->mc_io, 0, ls_dev->mc_handle,
> > > -				DPNI_IRQ_INDEX,
> > DPNI_IRQ_EVENT_LINK_CHANGED);
> > > +				DPNI_IRQ_INDEX,
> > DPNI_IRQ_EVENT_LINK_CHANGED |
> > > +				DPNI_IRQ_EVENT_ENDPOINT_CHANGED);
> > >  	if (err < 0) {
> > >  		dev_err(&ls_dev->dev, "dpni_set_irq_mask(): %d\n", err);
> > >  		goto free_irq;
> > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > > b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > > index fd583911b6c0..ee0711d06b3a 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> > > @@ -133,9 +133,12 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
> > >   */
> > >  #define DPNI_IRQ_INDEX				0
> > >  /**
> > > - * IRQ event - indicates a change in link state
> > > + * IRQ events:
> > > + *       indicates a change in link state
> > > + *       indicates a change in endpoint
> > >   */
> > >  #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
> > > +#define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002
> > 
> > Perhaps (as a follow-up?) this is a candidate for using the BIT() macro.
> > 
> 
> I wouldn't add another change to this patch set (targeting the net) but definitely will change this in net-next.

Thanks, that's fine be me.
