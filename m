Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E20214934
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgGDXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:43:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:59734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgGDXn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 19:43:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8EC34AFCC;
        Sat,  4 Jul 2020 23:43:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1B6C9604BB; Sun,  5 Jul 2020 01:43:26 +0200 (CEST)
Date:   Sun, 5 Jul 2020 01:43:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 1/6] Add cable test support
Message-ID: <20200704234326.renmbb3c52ooak66@lion.mk-sys.cz>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200701010743.730606-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701010743.730606-2-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 03:07:38AM +0200, Andrew Lunn wrote:
> Add support for starting a cable test, and report the results.
> 
> This code does not follow the usual patterns because of the way the
> kernel reports the results of the cable test. It can take a number of
> seconds for cable testing to occur. So the action request messages is
> immediately acknowledges, and the test is then performed asynchronous.
> Once the test has completed, the results are returned as a
> notification.
> 
> This means the command starts as usual. It then monitors multicast
> messages until it receives the results.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
[...]
> diff --git a/netlink/monitor.c b/netlink/monitor.c
> index 18d4efd..1af11ee 100644
> --- a/netlink/monitor.c
> +++ b/netlink/monitor.c
> @@ -59,6 +59,10 @@ static struct {
>  		.cmd	= ETHTOOL_MSG_EEE_NTF,
>  		.cb	= eee_reply_cb,
>  	},
> +	{
> +		.cmd	= ETHTOOL_MSG_CABLE_TEST_NTF,
> +		.cb	= cable_test_ntf_cb,
> +	},
>  };
>  

Please add also an entry to monitor_opts[] so that user can use
--cable-test as filter for --monitor.

Looks good otherwise.

Michal
