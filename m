Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA01E8806
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgE2TkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgE2TkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:40:16 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715892068D;
        Fri, 29 May 2020 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590781215;
        bh=pHAWiXtXi82k1H2JV3es73QRsipXYFr8isypVyWkMJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YvHC7pBZUm1D7WWDvZRrCp9BbBALz+4UwZWX8Qc24xbi7Pe5L3uOFh2cciIr9iSFA
         9AOycN1RVb6KEzQNy9R9lqFM/jfrdW9G0bNfQpvFcuj7FDFXNnc+oBuW3PfQ3Qm6kK
         zwuNvZQjTB9SR1lR97BZOn4JpBiPNkO//kUw38Es=
Date:   Fri, 29 May 2020 12:40:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200529124013.216c3970@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <VI1PR0402MB387176400D9ED1670801A474E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387176400D9ED1670801A474E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 11:45:08 +0000 Ioana Ciornei wrote:
> > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
> > classes
> > 
> > On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:  
> > > > With the Rx QoS features users won't even be able to tell via
> > > > standard Linux interfaces what the config was.  
> > >
> > > Ok, that is true. So how should this information be exported to the user?  
> > 
> > I believe no such interface currently exists.  
> 
> Somehow I missed this the first time around but the number of Rx traffic classes
> can be exported through the DCB ops if those traffic classes are PFC enabled.
> Also, adding PFC support was the main target of this patch set.
> 
> An output like the following would convey to the user how many traffic classes
> are available and which of them are PFC enabled.
> 
> root@localhost:~# lldptool -t -i eth1 -V PFC
> IEEE 8021QAZ PFC TLV
>          Willing: yes
>          MACsec Bypass Capable: no
>          PFC capable traffic classes: 8
>          PFC enabled: 1 3 7

Ack, the DCB APIs are probably the closest today to what you need. I'm
not sure whether there is an established relation between the tcs
there, and the number of queues reported and used in ethtool, though :(
