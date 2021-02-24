Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81EA3235CA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhBXCf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhBXCfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 21:35:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C4864E7A;
        Wed, 24 Feb 2021 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614134082;
        bh=jPN3XHfb7W6XVC9wHtzNUuiSABsSKJ3RvRx2KYIzxWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+GgFUDsiqj+efWUiLi+Za61MlT95LF8B8F0q0L76R6NoXXPebhcMraqxcuyGKgJO
         sQIssEt9kIJ9qPNitu3dp09F034btXzpaVeT9qABFwRZHgVGU3kz5CxPNi7kGF5t9o
         RiPxV5f0+Do520UtIEww5IlBIAmNXTBX+Ix7FwuusWsZwsFLaj3hTZiJyAfnYjybaJ
         0Nk7N8iqdJeIJ1q1s1BZMWJBv4M9MJIGMNz/CTtCvo4mGh9jtqAqSA5jYehT+Npq2i
         pyLzy2keXn5dh6QIlBf3f0PkaTcoDND+fd2Vy3PL1lKW0EyZ+y+0KRHNlQAdBAtww3
         coXhrpewHdLfg==
Date:   Tue, 23 Feb 2021 18:34:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <20210223183438.0984bc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 02:13:05 +0000 Joakim Zhang wrote:
> > > The aim is to enable clocks when it needs, others keep clocks disabled.  
> > 
> > Understood. Please double check ethtool callbacks work fine. People often
> > forget about those when disabling clocks in .close.  
> 
> Hi Jakub,
> 
> If NIC is open then clocks are always enabled, so all ethtool
> callbacks should be okay.
> 
> Could you point me which ethtool callbacks could be invoked when NIC
> is closed? I'm not very familiar with ethtool use case. Thanks.

Well, all of them - ethtool does not check if the device is open.
User can access and configure the device when it's closed.
Often the callbacks access only driver data, but it's implementation
specific so you'll need to validate the callbacks stmmac implements.
