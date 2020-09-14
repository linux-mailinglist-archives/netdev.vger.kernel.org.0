Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ED7269210
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgINQrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:47:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F5020829;
        Mon, 14 Sep 2020 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600102048;
        bh=LipKN19DLm+NuifYFHmitiE/2o2q0Ll13jeI5eHrFAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AuGHsxB5+fJRUdE4As/+MNl0akYExcn1cmbW9dJEp9PJ2f9akrHTtLZbuDf8Yye1B
         hdGdYlhVnI/5PPFVkeZUIpqtHeV5YoAE+bRARpBNS/+OLuKPUfbQJgM94RJfeN7ptC
         TGy8Ub60gbp8BOUZlG9X9VkLBdrWz6ZHe7g2MiAQ=
Date:   Mon, 14 Sep 2020 09:47:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Omer Shpigelman <oshpigelman@habana.ai>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 05/15] habanalabs/gaudi: add NIC Ethernet support
Message-ID: <20200914094726.1c5f747c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0PR02MB5523D7FD712C3B50DA733CDDB8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-6-oded.gabbay@gmail.com>
        <20200910130307.5dee086b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR02MB5523D7FD712C3B50DA733CDDB8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 09:52:00 +0000 Omer Shpigelman wrote:
> On Thu, Sep 10, 2020 at 11:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 10 Sep 2020 19:11:16 +0300 Oded Gabbay wrote:  
> > > +module_param(nic_rx_poll, int, 0444);  
> > MODULE_PARM_DESC(nic_rx_poll,  
> > > +	"Enable NIC Rx polling mode (0 = no, 1 = yes, default no)");  
> > 
> > If your chip does not support IRQ coalescing you can configure polling and the
> > timeout via ethtool -C, rather than a module parameter.  
> 
> I couldn't find an example for that in other drivers and I didn't see
> anything regarding polling mode in the parameters description of this
> ethtool callback.
> Can you please specify some pointer for that? Or in other words, what
> parameter can we use to enable polling/setting the timeout?

Look at stmmac, hip04_eth..
