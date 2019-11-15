Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E4DFE65A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKOUZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:25:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOUZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:25:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9225A14E0FDAE;
        Fri, 15 Nov 2019 12:25:05 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:25:05 -0800 (PST)
Message-Id: <20191115.122505.1808638053211732367.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_router: Allocate discard
 adjacency entry when needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114095419.27762-1-idosch@idosch.org>
References: <20191114095419.27762-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:25:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 14 Nov 2019 11:54:19 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
> invalid nexthops") allocated an adjacency entry during driver
> initialization whose purpose is to discard packets hitting the route
> pointing to it.
> 
> These adjacency entries are allocated from a resource called KVD linear
> (KVDL). There are situations in which the user can decide to set the
> size of this resource (via devlink-resource) to 0, in which case the
> driver will not be able to load.
> 
> Therefore, instead of pre-allocating this adjacency entry, simply
> allocate it only when needed. A variable indicating the validity of the
> entry is added and is used to ensure it is only allocated and written
> once and that it is freed after all the routes were flushed.
> 
> Fixes: 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via invalid nexthops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Applied.
