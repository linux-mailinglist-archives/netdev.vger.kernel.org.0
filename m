Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510B3B3044
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhFXNnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:43:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhFXNnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 09:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kJoNj9EV1XTA3nOzVNZZ5d15uvZW2jJVc5PSAJpiypM=; b=niF93v22kDwoh3YOc+RIXkezY3
        Yfa1uVichJuoJb6DQzSf+5cCFhhk/qibdhVqv6VqWLUiozFRA40y3NLKPFyTFrmgmO7YDUZmM9mzn
        iE1sg6CaSuLwuIjEb+uQTwX04CAa4DVit6fNjGEx3NSdHdhnqtB5YRGNwO7HX9hT4sOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwPac-00AycZ-7y; Thu, 24 Jun 2021 15:40:18 +0200
Date:   Thu, 24 Jun 2021 15:40:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Message-ID: <YNSLQpNsNhLkK8an@lunn.ch>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com>
 <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
 <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, the interrupt will not be discarded. If the PHY is in interrupt mode, the
> interrupt handler will triggers and ISR will clear the WOL status bit. 
> The condition here is when the PHY is in polling mode, the PHY driver does not
> have any other mechanism to clear the WOL interrupt status bit.
> Hence, we need to go through the PHY set_wol() again. 

I would say you have a broken setup. If you are explicitly using the
interrupt as a wakeup source, you need to be servicing the
interrupt. You cannot use polled mode.

	   Andrew
