Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0DBDCCC
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404453AbfIYLNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:13:31 -0400
Received: from salem.gmr.ssr.upm.es ([138.4.36.7]:60962 "EHLO
        salem.gmr.ssr.upm.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfIYLNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:13:30 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 07:13:29 EDT
Received: by salem.gmr.ssr.upm.es (Postfix, from userid 1000)
        id F161DAC0A99; Wed, 25 Sep 2019 13:05:43 +0200 (CEST)
Date:   Wed, 25 Sep 2019 13:05:43 +0200
From:   "Alvaro G. M" <alvaro.gamez@hazent.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
Message-ID: <20190925110542.GA21923@salem.gmr.ssr.upm.es>
References: <20190925105911.GI3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925105911.GI3264@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Dan

On Wed, Sep 25, 2019 at 01:59:11PM +0300, Dan Carpenter wrote:
> The "lp->phy_mode" is an enum but in this context GCC treats it as an
> unsigned int so the error handling is never triggered.
> 
>  		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
> -		if (lp->phy_mode < 0) {
> +		if ((int)lp->phy_mode < 0) {

This (almost) exact code appears in a lot of different drivers too,
so maybe it'd be nice to review them all and apply the same cast if needed?

Best regards

-- 
Alvaro G. M.
