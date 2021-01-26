Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B836C30383E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390378AbhAZIne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:43:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390387AbhAZImg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:42:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q7TwEe152538;
        Tue, 26 Jan 2021 07:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SJ15W1q+FIQewIC7/ta0Gam/PBScbc3sS8SJfQABM8k=;
 b=yfl5WGMhTpd/DXeQgDuA4Tubu7v9oSADO5smZXJqV2rnKPR5OtonhX/s3jwZVelrO5DZ
 WsKeCZymXwZ1fedKbeEkVPEiB/aF/SuH4m/zdN4rpxpyitBdzj+n+c/4YdxFTDKgDVGx
 t89pqHt3J9pNRpIu8aPscHGIzW/bOeZ8IRpNgEAaIv20mD+eADBgTytm7XdUVVnJMC+A
 VeJnfEJ7oyOfE/jJpReCnSjZ3tfykQ45BhfEhmP7v/jkfOZqk6vbN9KLArLhJKgPEw0x
 /eeqcVoGVXJMcE3a2I91jfv3bpnwddRP9YdJTmzMwq37r8s/VgTaYCvzpH9Qr3ai7qyn jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7qrt2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 07:30:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q7K5QJ013329;
        Tue, 26 Jan 2021 07:28:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 368wqw2rxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 07:28:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10Q7S3P7026709;
        Tue, 26 Jan 2021 07:28:03 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 23:28:02 -0800
Date:   Tue, 26 Jan 2021 10:27:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2 1/2 net-next] net: mscc: ocelot: fix error handling
 bugs in mscc_ocelot_init_ports()
Message-ID: <20210126072753.GU2696@kadam>
References: <20210125081940.GK20820@kadam>
 <YA6EW9SPE4q6x7d3@mwanda>
 <20210125161806.q5rmiqj6r3yvp3ke@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125161806.q5rmiqj6r3yvp3ke@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260037
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:18:07PM +0000, Vladimir Oltean wrote:
> Hi Dan,
> 
> On Mon, Jan 25, 2021 at 11:42:03AM +0300, Dan Carpenter wrote:
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index 9553eb3e441c..875ab8532d8c 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -1262,7 +1262,6 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
> >  	ocelot_port = &priv->port;
> >  	ocelot_port->ocelot = ocelot;
> >  	ocelot_port->target = target;
> > -	ocelot->ports[port] = ocelot_port;
> 
> You cannot remove this from here just like that, because
> ocelot_init_port right below accesses ocelot->ports[port], and it will
> dereference through a NULL pointer otherwise.
> 

Argh...  Thanks for spotting that.

> >  	dev->netdev_ops = &ocelot_port_netdev_ops;
> >  	dev->ethtool_ops = &ocelot_ethtool_ops;
> > @@ -1282,7 +1281,19 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
> >  	if (err) {
> >  		dev_err(ocelot->dev, "register_netdev failed\n");
> >  		free_netdev(dev);
> > +		return err;
> >  	}
> >  
> > -	return err;
> > +	ocelot->ports[port] = ocelot_port;
> > +	return 0;
> > +}
> > +
> > +void ocelot_release_port(struct ocelot_port *ocelot_port)
> > +{
> > +	struct ocelot_port_private *priv = container_of(ocelot_port,
> > +						struct ocelot_port_private,
> > +						port);
> 
> Can this assignment please be done separately from the declaration?
> 
> 	struct ocelot_port_private *priv;
> 
> 	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> 
> > +
> > +	unregister_netdev(priv->dev);
> > +	free_netdev(priv->dev);
> >  }
> 
> Fun, isn't it? :D
> Thanks for taking the time to untangle this.
> 
> Additionally, you have changed the meaning of "registered_ports" from
> "this port had its net_device registered" to "this port had its
> devlink_port registered". This is ok, but I would like the variable
> renamed now, too. I think devlink_ports_registered would be ok.
> 
> In hindsight, I was foolish for using a heap-allocated boolean array for
> registered_ports, because this switch architecture is guaranteed to not
> have more than 32 ports, so a u32 bitmask is fine.
> 
> If you resend, can you please squash this diff on top of your patch?

Yep.  I will resend.  Thanks for basically writing v2 for me.  Your
review comments were very clear but code is always 100% clear so that's
really great.  I've never seen anyone do that before.  I should copy
that for my own reviews and hopefully it's a new trend.

> 
> Then you can add:
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Also, it's strange but I don't see the v2 patches in patchwork. Did you
> send them in-reply-to v1 or something?

I did send them as a reply to v1.  Patchwork doesn't like that?

regards,
dan carpenter

