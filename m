Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02D3A7803
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFOHdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhFOHdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:33:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0119C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:31:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lt3XY-0074Cg-Na; Tue, 15 Jun 2021 09:31:16 +0200
Message-ID: <badd96aa7c475819ed3b9ca48743e10e756b2820.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Date:   Tue, 15 Jun 2021 09:31:15 +0200
In-Reply-To: <20210615003016.477-11-ryazanov.s.a@gmail.com> (sfid-20210615_023031_352839_BA76437F)
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
         <20210615003016.477-11-ryazanov.s.a@gmail.com>
         (sfid-20210615_023031_352839_BA76437F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-06-15 at 03:30 +0300, Sergey Ryazanov wrote:
> The WWAN core not only multiplex the netdev configuration data, but
> process it too, and needs some space to store its private data
> associated with the netdev. Add a structure to keep common WWAN core
> data. The structure will be stored inside the netdev private data before
> WWAN driver private data and have a field to make it easier to access
> the driver data. Also add a helper function that simplifies drivers
> access to their data.
> 
> At the moment we use the common WWAN private data to store the WWAN data
> link (channel) id at the time the link is created, and report it back to
> user using the .fill_info() RTNL callback. This should help the user to
> be aware which network interface is binded to which WWAN device data

Nit: "binded" -> "bound".

> +static size_t wwan_rtnl_get_size(const struct net_device *dev)
> +{
> +	return
> +		nla_total_size(4) +	/* IFLA_WWAN_LINK_ID */
> +		0;
> +}
> 

Not sure I like that code style, but I guess I don't care much either :)

johannes



