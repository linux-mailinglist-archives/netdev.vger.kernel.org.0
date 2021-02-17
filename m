Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98731DFD6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBQTwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:52:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBQTv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 14:51:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCSqy-006xZ8-Fp; Wed, 17 Feb 2021 20:51:16 +0100
Date:   Wed, 17 Feb 2021 20:51:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: HSR/PRP sequence counter issue with Cisco Redbox
Message-ID: <YC1ztKr/bpmc71Xh@lunn.ch>
References: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
 <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com>
 <11291f9b05764307b660049e2290dd10@EXCH-SVR2013.eberle.local>
 <CAFSKS=OiwGKqAvEZtxpOOabWbyN-dFA5YukAxBrtfk_fS+Lttg@mail.gmail.com>
 <e20bb1bd30e9465ea36d26b274b8b2b6@EXCH-SVR2013.eberle.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e20bb1bd30e9465ea36d26b274b8b2b6@EXCH-SVR2013.eberle.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From 8836f1df35a884327da37885ff3ad8bfc5eb933c Mon Sep 17 00:00:00 2001
> From: Marco Wenzel <marco.wenzel@a-eberle.de>
> Date: Wed, 17 Feb 2021 13:53:31 +0100
> Subject: [PATCH] net: hsr: add support for EntryForgetTime
> 
> In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
> node does not send any frame within this time, the sequence number check
> for can be ignored. This solves communication issues with Cisco IE 2000
> in Redbox mode.
> 
> Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>

It would be nice to have a Fixes: tag here to indicate which commit
introduced the problem. If it has been broken forever, reference the
commit which added HSR. 

> diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
> index 86b43f539f2c..7a120ce3e3db 100644
> --- a/net/hsr/hsr_framereg.h
> +++ b/net/hsr/hsr_framereg.h
> @@ -75,6 +75,7 @@ struct hsr_node {
>  	enum hsr_port_type	addr_B_port;
>  	unsigned long		time_in[HSR_PT_PORTS];
>  	bool			time_in_stale[HSR_PT_PORTS];
> +	unsigned long	  time_out[HSR_PT_PORTS];

It looks like the indentation is wrong here, and is using a mixture of
tabs and spaces.

     Andrew
