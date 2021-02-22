Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0C5322077
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhBVTsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232792AbhBVTsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 14:48:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903FA64E02;
        Mon, 22 Feb 2021 19:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614023260;
        bh=mUGGnGRNZKGtz3pVXah+J2/q/SklbJnP/BvcoxfjLNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZQriSX31Ac+1hzTlJ341TsHmOPTrjeoquPCkRw3ADhs4RFjLX6IolHb0IgUdFAlGP
         50wdlMUVyitOTC9O9hzVd9V6FawKFTK7z5IwDIRPCZeHRhzoZRZ8kSYmLFIVAwLo1W
         cYp3T4zQjcylopLVgOF4gKBo5YyirxrmBf/gi01V9+pEB+Wzx7DwKpjyEgUovxYakR
         0DQXn/OIVTYHhEVc2jZt3h5HUve/nU8nR5nFYj6twF9ufP53sGQPRfi84eON7MoMjJ
         ChrQBXgmBEWuktqu6W65MQowYdq0JTrytH36CUz1q3B3bjZqFYxaOhDMpyA0+ql9OY
         KxmjQkGCQIuPg==
Date:   Mon, 22 Feb 2021 11:47:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Message-ID: <20210222114737.740469eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB67953DBABBB9B1B85759AE58E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-6-qiangqing.zhang@nxp.com>
        <20210206123815.213b27ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB67953DBABBB9B1B85759AE58E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Feb 2021 07:52:46 +0000 Joakim Zhang wrote:
> > I'm not sure why you recycle and reallocate every buffer. Isn't it enough to
> > reinitialize the descriptors with the buffers which are already allocated?  
> 
> As I know, the receive buffer address is not fixed after allocated,
> it will recycle and re-allocate in stmmac_rx(), where to handle the
> receive buffers.

Not sure what you mean by that. The driver must know the addresses of
the memory it allocated and handed over to the device.

> It should be enough to re-initialize the descriptors with the buffers
> if it is possible. Could you point me how to do it?

