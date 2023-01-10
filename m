Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C16A664CFE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjAJUGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjAJUF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9532C4;
        Tue, 10 Jan 2023 12:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1184618E5;
        Tue, 10 Jan 2023 20:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAE3C433EF;
        Tue, 10 Jan 2023 20:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673381151;
        bh=Vd0GZVeHo6JIhOHYGd6tKf+QIQ4pPMNDJBgviINx9fE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o3eiLY3U8M8pGbVPR2U3WTwZagHMpVndZHKQPrnuRHRNxiGG0Ie9Usxn3wvM3m4Dc
         FsFY4HJrAYujIGOytwA18gM04V882HzdcHC34KF5ooDnT8Bl4JGb1rVBgg3CqqPKym
         egfFnUPTR7YUaSaRfpEgB8mZ9Rf71CIhD6j80fsgSHdHQM+khuwGR/KfsYNZ2WD8US
         avcxktNzqZPKtmedCdiOmwl5tF69wtQomwDcPmLY6W6dIs5J4OGnLbIQSUI+CReOXp
         XECbioWHgMI+ZB3PBi5p57fSPoaZJGaBJ3oS9yvBTDpULvmyIpepV8y+OzpYRix12w
         D0OkRDt/tnkGg==
Date:   Tue, 10 Jan 2023 12:05:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20230110120549.4d764609@kernel.org>
In-Reply-To: <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
        <20221207152157.6185b52b@kernel.org>
        <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
        <Y5MW/7jpMUXAGFGX@nanopsycho>
        <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
        <20221209083104.2469ebd6@kernel.org>
        <Y5czl6HgY2GPKR4v@nanopsycho>
        <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
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

On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
> This is a simplified network switch board example.
> It has 2 synchronization channels, where each channel:
> - provides clk to 8 PHYs driven by separated MAC chips,
> - controls 2 DPLLs.
> 
> Basically only given FW has control over its PHYs, so also a control over it's
> MUX inputs.
> All external sources are shared between the channels.
> 
> This is why we believe it is not best idea to enclose multiple DPLLs with one
> object:
> - sources are shared even if DPLLs are not a single synchronizer chip,
> - control over specific MUX type input shall be controllable from different
> driver/firmware instances.
> 
> As we know the proposal of having multiple DPLLs in one object was a try to
> simplify currently implemented shared pins. We fully support idea of having
> interfaces as simple as possible, but at the same time they shall be flexible
> enough to serve many use cases.

I must be missing context from other discussions but what is this
proposal trying to solve? Well implemented shared pins is all we need.
