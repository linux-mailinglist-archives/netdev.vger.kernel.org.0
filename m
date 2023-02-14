Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D555695909
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjBNGR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBNGRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395441C7F6
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB336143F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D1CC433D2;
        Tue, 14 Feb 2023 06:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676355434;
        bh=harneXshAE8LxCLxcwI88kltuba7S9Lvkyck5miFg1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ft1XFSH74fxakyvm4H7vatuVU1DHKw6soS0B19aGfh+dXpn9MJu18M/EpPVThYOYw
         9rRkDKvCxZ7YaI9Atccwm0die22Js9Rc+ELQCo+Q4B5594AqbQZghs/bMvTBE85yTl
         aifV1FTSk2ch9TTq5ZYih5+87czYXxIJ2Y9fqg9yIgVwgqzEK8eBhPMa1Cq61BaBFF
         32YMz/De9gk0630KqF+Hnh3dTQ9p7WYb/AQH6SO44p+qwWL2dAUVOa51wn6hG0Vf4J
         jh0Y/BgrCYqisSr+dvU1nRqb54lAncFuJsEyUUi0Hvd0i6s8b2aqxLrBfvnRniW735
         fv4k5GMKnWRGA==
Date:   Mon, 13 Feb 2023 22:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/10] devlink: Split out health reporter
 create code
Message-ID: <20230213221712.3f91f288@kernel.org>
In-Reply-To: <1676294058-136786-2-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
        <1676294058-136786-2-git-send-email-moshe@nvidia.com>
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

On Mon, 13 Feb 2023 15:14:09 +0200 Moshe Shemesh wrote:
> +/**
> + *	devl_port_health_reporter_create - create devlink health reporter for
> + *	                                   specified port instance
> + *
> + *	@port: devlink_port which should contain the new reporter
> + *	@ops: ops
> + *	@graceful_period: to avoid recovery loops, in msecs
> + *	@priv: priv
> + */

Can we drop or touch-up the kdoc as we move?

The indent should just use a space, not a tab.
() after function name

@port: devlink_port to which the health reports will relate
@ops: driver health reporter ops
@graceful_period: min time between recovery attempts
@priv: driver priv pointer
