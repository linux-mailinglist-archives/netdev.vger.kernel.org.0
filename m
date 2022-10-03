Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B485F33DA
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJCQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJCQq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:46:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4468303D1;
        Mon,  3 Oct 2022 09:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC6AB81110;
        Mon,  3 Oct 2022 16:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E96AC433C1;
        Mon,  3 Oct 2022 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664815599;
        bh=8fL5ph1ZCDrgON77bewSrlo834+UKemG8iP2Ctrd8Ys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6HUDTFuONNaYpol47j298WIEye8HhGCvW3MHxPE22Hq6YyJ3uDHt2zgNiF3/N8QH
         9IVIQkWdFBQbFd6h6w0VNvuAa08trMmTWHJgV+Ir5F2w7l1OlwdYBDNRF6zi8hPadr
         Pj520SQnSKaSxdySuTfqrtq4ZAEBm9f43yK41wq6zf5GsQhNxLwwQX1JlYZn4LhGUg
         guju3Lg5qmNeuwsmII/+dLvsgCNbn4q6mFbLbsZFavij0rL6kGC9VJ1BHIXTRrAs1u
         XEiuV5J4C5muqqrC+JEq3x34+Fd4bWfImBQyNfVxJ3PTdWuIQrPB+GQy0jTwRTZHAA
         atxdVlGxo5xBg==
Date:   Mon, 3 Oct 2022 09:46:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v2 06/13] net: make drivers to use
 SET_NETDEV_DEVLINK_PORT to set devlink_port
Message-ID: <20221003094638.5e3d4cbf@kernel.org>
In-Reply-To: <20221003105204.3315337-7-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
        <20221003105204.3315337-7-jiri@resnulli.us>
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

On Mon,  3 Oct 2022 12:51:57 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Benefit from the previously implemented tracking of netdev events in
> devlink code and instead of calling  devlink_port_type_eth_set() and
> devlink_port_type_clear() to set devlink port type and link to related
> netdev, use SET_NETDEV_DEVLINK_PORT() macro to assign devlink_port
> pointer to netdevice which is about to be registered.

drivers/net/ethernet/mscc/ocelot_vsc7514.c:380:23: warning: variable 'ocelot_port' set but not used [-Wunused-but-set-variable]
                struct ocelot_port *ocelot_port;
                                    ^
