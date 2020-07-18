Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44502247C9
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGRBfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:35:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3E0C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 18:35:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7FA411E45910;
        Fri, 17 Jul 2020 18:34:59 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:34:59 -0700 (PDT)
Message-Id: <20200717.183459.1613002913279592264.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        mslattery@solarflare.com
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717235336.879264-1-kuba@kernel.org>
References: <20200717235336.879264-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:35:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 17 Jul 2020 16:53:36 -0700

> Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
> the info, which will hopefully protect us from -EPERM errors
> the previous code was gracefully ignoring. Shared code reports
> the port information back to user space, so we really want
> to know what was added and what failed.
> 
> The driver does not call udp_tunnel_get_rx_info(), so its own
> management of table state is not really all that problematic,
> we can leave it be. This allows the driver to continue with its
> copious table syncing, and matching the ports to TX frames,
> which it will reportedly do one day.
> 
> Leave the feature checking in the callbacks, as the device may
> remove the capabilities on reset.
> 
> Inline the loop from __efx_ef10_udp_tnl_lookup_port() into
> efx_ef10_udp_tnl_has_port(), since it's the only caller now.
> 
> With new infra this driver gains port replace - when space frees
> up in a full table a new port will be selected for offload.
> Plus efx will no longer sleep in an atomic context.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Edward et al., please review.

Thank you.
