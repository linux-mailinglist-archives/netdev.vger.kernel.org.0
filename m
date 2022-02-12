Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D59C4B33C0
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 09:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiBLIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 03:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBLIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 03:20:15 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF36D26AF3
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:20:10 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIndU-000SLD-KX; Sat, 12 Feb 2022 09:20:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nInZD-005Am5-Av;
        Sat, 12 Feb 2022 09:15:39 +0100
Date:   Sat, 12 Feb 2022 09:15:39 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v5 1/6] gtp: Allow to create GTP device
 without FDs
Message-ID: <YgdsqzOPZJLLkhAk@nataraja>
References: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
 <20220211175500.7805-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211175500.7805-1-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

I'm sorry if you think this is too much nit-picking, but moving
around functions and removing forward declarations is making it
unneccessarily hard to read the generated diff:

Now it's not possible to see which bits of the code you really changed,
as entire functions have moved position within the file.

On Fri, Feb 11, 2022 at 06:55:00PM +0100, Marcin Szycik wrote:
> -static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
> -static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
> +static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
> +{
> +	int i;
> +
> +	gtp->addr_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
> +				       GFP_KERNEL | __GFP_NOWARN);
> +	if (gtp->addr_hash == NULL)

...

I would appreciate if you could do any re-ordering of functions in a
separate, marked "cosmetic" commit, so we can see the actual changes you
make to the code in one patch, and the re-arranging in another.

Thanks!
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
