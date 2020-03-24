Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A541913B5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgCXOyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:54:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:37510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgCXOyS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 10:54:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69202AC46;
        Tue, 24 Mar 2020 14:54:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 92351E0FD3; Tue, 24 Mar 2020 15:54:15 +0100 (CET)
Date:   Tue, 24 Mar 2020 15:54:15 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH V2 ethtool] ethtool: Add support for Low Latency Reed
 Solomon
Message-ID: <20200324145415.GQ31519@unicorn.suse.cz>
References: <20200324140141.20979-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324140141.20979-1-tariqt@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 04:01:41PM +0200, Tariq Toukan wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
> and initialization functions accordingly. In addition, update related
> man page.
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> ---
[...]
> @@ -754,6 +755,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>  			fprintf(stdout, " RS");
>  			fecreported = 1;
>  		}
> +		if (ethtool_link_mode_test_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
> +					       mask)) {
> +			fprintf(stdout, " LL-RS");
> +			fecreported = 1;
> +		}
> +
>  		if (!fecreported)
>  			fprintf(stdout, " Not reported");
>  		fprintf(stdout, "\n");

Kernel uses "LLRS" for this bit since commit f623e5970501 ("ethtool: Add
support for low latency RS FEC") so if you use "LL-RS" here, the output
will differ between ioctl and netlink code paths.

It's not necessary to use the same name also for --show-fec/--set-fec
(string set and netlink support for these is still work in progress) but
it would IMHO be better to be consistent.

Michal Kubecek
