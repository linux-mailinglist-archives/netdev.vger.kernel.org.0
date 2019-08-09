Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1D885BE
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHIWUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:20:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44844 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHIWUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:20:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id 44so66277931qtg.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=bJBzV5/ogb9AY70r7y9QfmYSQ5cTMOAIhCbMG4LtDNk=;
        b=UUzNvSJYQNDeonuef1+IutvnuJ3iZdNe7VhnKqF+JQJPnnPy6PV3nKDKzGt3fPJuL+
         42ThNAwgSf0MHmnxqYkUKBBVi96x3bmMYhhqQ1bgpVcMgyRJaAl4yUxuevIL6Pioo+Tl
         Vp19uHKF90r3j7x6A0M/lhDkHnAcbVV97m03s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bJBzV5/ogb9AY70r7y9QfmYSQ5cTMOAIhCbMG4LtDNk=;
        b=TgwpR4+6Vz5WdVdKvRRKS5n5Mf+Yq45Ne784eHgkJn3SpCm1rsjY+Rn1bZIukCQw7g
         xucFjApi7xF80n8eaP1jmiZpvlJhaLujjYFn7DybXtyKDmtPFMyG+kby79HfDSjDn9rU
         iSrMj5QKzqbmMsTWjEvSLpOijD4Qp/Lh7A5CgjedvDW9S32PQ6CWfa8jjNZv1bxKJOiu
         hE3r5UW/vputN3PPLkEzfK/2BXgFKVU3n2gZ+NDaN2GyFgxPH6Xds0ZvvJWVYpNHGcyb
         vR36UASbE86UWb/T6pR9ViXscm1gAe6Qu2rR+vpsqvo8Y8QGiyQEyPts2QOFxrgwBEmK
         sxiA==
X-Gm-Message-State: APjAAAU8RsIgYaHdqtJcbhsNYkCJdPjAVxakMqk1cMAy1BdK0qTuFWgz
        Q2JDRhXptF6DgCY3WLAc2ygE4aPWl40=
X-Google-Smtp-Source: APXvYqwYsDF82RQJyy5mqWBn8tKIe1MQFiV+ZHOTe+2mASTf/PJq+Vdm56v/SeflNNXWUI21Rmdmaw==
X-Received: by 2002:ad4:4985:: with SMTP id t5mr19728694qvx.193.1565389230235;
        Fri, 09 Aug 2019 15:20:30 -0700 (PDT)
Received: from cohiba (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id j3sm42819560qki.5.2019.08.09.15.20.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:20:29 -0700 (PDT)
Date:   Fri, 9 Aug 2019 18:20:28 -0400
From:   Matt Pelland <mpelland@starry.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH v2 net-next 2/2] net: mvpp2: support multiple comphy lanes
Message-ID: <20190809222028.GB1320@cohiba>
References: <20190808230606.7900-1-mpelland@starry.com>
 <20190808230606.7900-3-mpelland@starry.com>
 <20190809083250.GB3516@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809083250.GB3516@kwain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 10:32:50AM +0200, Antoine Tenart wrote:
> Hello Matt,
> 
> On Thu, Aug 08, 2019 at 07:06:06PM -0400, Matt Pelland wrote:
> >  
> >  static void mvpp2_port_enable(struct mvpp2_port *port)
> > @@ -3389,7 +3412,9 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
> >  
> >  	if (port->phylink)
> >  		phylink_stop(port->phylink);
> > -	phy_power_off(port->comphy);
> > +
> > +	if (port->priv->hw_version == MVPP22)
> > +		mvpp22_comphy_deinit(port);
> 
> You can drop the check on the version here, mvpp22_comphy_deinit will
> return 0 if no comphy was described. (You added other calls to this
> function without the check, which is fine).
> 
> > @@ -5037,20 +5062,18 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> >  			    struct fwnode_handle *port_fwnode,
> >  			    struct mvpp2 *priv)
> >  {
> > -	struct phy *comphy = NULL;
> > -	struct mvpp2_port *port;
> > -	struct mvpp2_port_pcpu *port_pcpu;
> > +	unsigned int ntxqs, nrxqs, ncomphys, nrequired_comphys, thread;
> >  	struct device_node *port_node = to_of_node(port_fwnode);
> > +	struct mvpp2_port_pcpu *port_pcpu;
> >  	netdev_features_t features;
> > -	struct net_device *dev;
> >  	struct phylink *phylink;
> > -	char *mac_from = "";
> > -	unsigned int ntxqs, nrxqs, thread;
> > +	struct mvpp2_port *port;
> >  	unsigned long flags = 0;
> > +	struct net_device *dev;
> > +	int err, i, phy_mode;
> > +	char *mac_from = "";
> >  	bool has_tx_irqs;
> >  	u32 id;
> > -	int phy_mode;
> > -	int err, i;
> >  
> >  	has_tx_irqs = mvpp2_port_has_irqs(priv, port_node, &flags);
> >  	if (!has_tx_irqs && queue_mode == MVPP2_QDIST_MULTI_MODE) {
> > @@ -5084,14 +5107,38 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> >  		goto err_free_netdev;
> >  	}
> >  
> > +	port = netdev_priv(dev);
> > +
> >  	if (port_node) {
> > -		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
> > -		if (IS_ERR(comphy)) {
> > -			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
> > -				err = -EPROBE_DEFER;
> > -				goto err_free_netdev;
> > +		for (i = 0, ncomphys = 0; i < ARRAY_SIZE(port->comphys); i++) {
> > +			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
> > +								    port_node,
> > +								    i);
> > +			if (IS_ERR(port->comphys[i])) {
> > +				err = PTR_ERR(port->comphys[i]);
> > +				port->comphys[i] = NULL;
> > +				if (err == -EPROBE_DEFER)
> > +					goto err_free_netdev;
> > +				err = 0;
> > +				break;
> >  			}
> > -			comphy = NULL;
> > +
> > +			++ncomphys;
> > +		}
> > +
> > +		if (phy_mode == PHY_INTERFACE_MODE_XAUI)
> > +			nrequired_comphys = 4;
> > +		else if (phy_mode == PHY_INTERFACE_MODE_RXAUI)
> > +			nrequired_comphys = 2;
> > +		else
> > +			nrequired_comphys = 1;
> > +
> > +		if (ncomphys < nrequired_comphys) {
> > +			dev_err(&pdev->dev,
> > +				"not enough comphys to support %s\n",
> > +				phy_modes(phy_mode));
> > +			err = -EINVAL;
> > +			goto err_free_netdev;
> 
> The comphy is optional and could not be described (some SoC do not have
> a driver for their comphy, and some aren't described at all). In such
> cases we do rely on the bootloader/firmware configuration. Also, I'm not
> sure how that would work with dynamic reconfiguration of the mode if the
> n# of lanes used changes (I'm not sure that is possible though).
> 

I'm new to this space, but, from my limited experience it seems unlikely that
some hardware configuration would require dynamically reconfiguring the number
of comphy lanes used depending on the phy mode. Unless you disagree, instead of
removing this check or making things really complicated to support this
scenario, I propose extending the conditional above to disable sanity checking
if no comphys were parsed out of the device tree. Something like:

if (ncomphys != 0 && ncomphys < nrequired_comphys)

This would cover Maxime's request for sanity checking, which I think is
valuable, while also maintaining compatibility with platforms that have no
comphy drivers or some other issue that prevents properly defining comphy nodes
in the device tree. Does that sound reasonable?

> Thanks!
> Antoine
> 
> -- 
> Antoine Ténart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
Matt
