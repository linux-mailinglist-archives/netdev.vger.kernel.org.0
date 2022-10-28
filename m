Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA4A6108B8
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiJ1D2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiJ1D2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:28:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3609CF869
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 20:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 950CEB81E57
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EE9C433D7;
        Fri, 28 Oct 2022 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666927709;
        bh=4sOKT6YNtM61EKWU5T+rP9I7odmFwcFT97U/6UmgzTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KL9hqCOwLua87ktVMZioY+13j8xpcsh7GzrBKO9FuxxRBK7MD3t8x4fx4zG1ca3Fe
         9PddWjqIBrpIIAjX95sEMwRZft11AXNxWziAuk3wmpnGst5UqaExHIbHKT83hZ39+w
         lfNlxW3NLyc76ff72kEy1SMm74ut4eXED9oO7zIP1UkHSqdS8ry4UekLbIv6dYHoYz
         2yYsFDV9hIqdnLKptHpRFpN3kPeXkSrIT9wZmLTeTMTiaeSNp/xOxuTJHh5rJJ8aEc
         ebd6XkmOcbH8GIpl0p5C+QztHTZeoDonNVjdUfLBNYMov2XDUN0odCuqQ4KMYNZRVz
         tl/OnIYN1zJpw==
Date:   Thu, 27 Oct 2022 20:28:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v7 5/9] devlink: Allow to set up parent in
 devl_rate_leaf_create()
Message-ID: <20221027202827.701a9a68@kernel.org>
In-Reply-To: <20221027130049.2418531-6-michal.wilczynski@intel.com>
References: <20221027130049.2418531-1-michal.wilczynski@intel.com>
        <20221027130049.2418531-6-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 15:00:45 +0200 Michal Wilczynski wrote:
> @@ -10327,10 +10327,11 @@ EXPORT_SYMBOL_GPL(devl_rate_node_create);
>   *
>   * Create devlink rate object of type leaf on provided @devlink_port.
>   */
> -int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
> +int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv, char *parent_name)
>  {
>  	struct devlink *devlink = devlink_port->devlink;
>  	struct devlink_rate *devlink_rate;
> +	struct devlink_rate *parent;
>  

net/core/devlink.c:10332: warning: Function parameter or member 'parent_name' not described in 'devl_rate_leaf_create'
