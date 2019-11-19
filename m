Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544F1101085
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKSBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:10:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfKSBKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:10:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4431150FA101;
        Mon, 18 Nov 2019 17:10:36 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:10:36 -0800 (PST)
Message-Id: <20191118.171036.1233493018225366675.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_router: Fix determining underlay
 for a GRE tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118071842.31712-1-idosch@idosch.org>
References: <20191118071842.31712-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:10:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 18 Nov 2019 09:18:42 +0200

> From: Petr Machata <petrm@mellanox.com>
> 
> The helper mlxsw_sp_ipip_dev_ul_tb_id() determines the underlay VRF of a
> GRE tunnel. For a tunnel without a bound device, it uses the same VRF that
> the tunnel is in. However in Linux, a GRE tunnel without a bound device
> uses the main VRF as the underlay. Fix the function accordingly.
> 
> mlxsw further assumed that moving a tunnel to a different VRF could cause
> conflict in local tunnel endpoint address, which cannot be offloaded.
> However, the only way that an underlay could be changed by moving the
> tunnel device itself is if the tunnel device does not have a bound device.
> But in that case the underlay is always the main VRF, so there is no
> opportunity to introduce a conflict by moving such device. Thus this check
> constitutes a dead code, and can be removed, which do.
> 
> Fixes: 6ddb7426a7d4 ("mlxsw: spectrum_router: Introduce loopback RIFs")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied and queued up for -stable.
