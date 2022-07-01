Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385225637EF
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiGAQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGAQam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:30:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54356313A0
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD2EB830A6
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 16:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499EEC341CA;
        Fri,  1 Jul 2022 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656693038;
        bh=rcE425wGXF++IRyWHirI6zWwSJLIem/SPNP4/b3R3y0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tHf18nmSlFPvL5sx/ce8+0QwWSK8XtgITPiD/iZDMwzMEuBtqCPIoKdklMjPm/tD5
         7S1yaJKK2hgTZHCx84rpVPJ19Hc1M9UArdEn6HKDO0PbI3u71PsP/yoOZTLNTeUqHj
         pQr/g1u1r5/PVaVwnPNClnT/lDyKzFdv1G1ph0azyMnsXMT6mpS7yHBSMlyhfVkfG/
         PQGtFxd9tDZlnbJlyHUI7jXw9+g92iplG430GCm8etDr/y3X17b5bxYQ9w4TAqkkxl
         J94uTXMOIYpCQG2jS+3qZQBSx5eJQuPFnvtPa6qYvrmePcmsjZD7KqBWHtmTeuQ8dn
         QF+6VZtdzpLsw==
Date:   Fri, 1 Jul 2022 09:30:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 3/3] net: devlink: fix unlocked vs locked
 functions descriptions
Message-ID: <20220701093037.36ae3c67@kernel.org>
In-Reply-To: <20220701095926.1191660-4-jiri@resnulli.us>
References: <20220701095926.1191660-1-jiri@resnulli.us>
        <20220701095926.1191660-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 11:59:26 +0200 Jiri Pirko wrote:

> + *	Register devlink port with provided port index. User can use
> + *	any indexing, even hw-related one. devlink_port structure
> + *	is convenient to be embedded inside user driver private structure.
> + *	Note that the caller should take care of zeroing the devlink_port
> + *	structure.

Should we also mention that the port type has to be set later?
I guess that may be beyond the scope.

> + */

> +/**
> + *	devlink_port_unregister - Unregister devlink port

devl_

> + *
> + *	@devlink_port: devlink port
> + */

I wonder if we should use this as an opportunity to start following 
the more modern kdoc format:

No tab indentation, and () after the function's name.

At least for the new kdoc we add.

>  void devl_port_unregister(struct devlink_port *devlink_port)
>  {
>  	lockdep_assert_held(&devlink_port->devlink->lock);

