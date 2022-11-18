Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A9B62ECC1
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiKREI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiKREIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:08:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2FD2FFF9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE690B82267
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF04C433C1;
        Fri, 18 Nov 2022 04:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668744526;
        bh=AMw4OT99G9dNEQL37dR8PTeMzb0YWdRUA/jpcm12mYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HZUVGx9NVsYQDVZdRz6QtEzrzph3MmBAhDn3zMeDVnBfxiwQbI6X7HJeTLy/OzIip
         UzK2m5JrqABkKeC5mbdWGMPZdYAKo83erBlpaEyyx5GFJUjAPvccEGGDS78UgjfOcH
         A/OgYKA4aL614jxVQNctpal6DvFgpppSru3HO9xl1m7CmyRf3z6fNO5D13ljq5soVv
         Wq/1h797FfM2YEl+s2bTDDgIGQo3jWf4fjf+Agd/zFXdL0qRakMiB9+/B6eAVY/42m
         xpfqrifUEOL4BAEHLxNnw7gB6pT7TqRZ/C/IQE32PzQJ9uzRjsq+s1T+RupR4w8dim
         H/IwjOVrXkRSQ==
Date:   Thu, 17 Nov 2022 20:08:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <20221117200845.5eb5b81a@kernel.org>
In-Reply-To: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 15:25:54 -0800 Sudheer Mogilappagari wrote:
> +RSS_GET
> +========

One too many =

> +	{
> +		.cmd	= ETHTOOL_MSG_RSS_GET,
> +		.doit	= ethnl_default_doit,
> +		.start	= ethnl_default_start,
> +		.done	= ethnl_default_done,

start and done are part of the dump procedure, since we have no dump
now I think we should drop those

> +		.policy = ethnl_rss_get_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_rss_get_policy) - 1,
> +	},
>  };
