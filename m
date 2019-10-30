Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F610EA3C1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfJ3TE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:04:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3TE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:04:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FF4F1493C1FF;
        Wed, 30 Oct 2019 12:04:58 -0700 (PDT)
Date:   Wed, 30 Oct 2019 12:04:57 -0700 (PDT)
Message-Id: <20191030.120457.1939571805404166408.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: core: Unpublish devlink parameters during
 reload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030090422.24698-1-idosch@idosch.org>
References: <20191030090422.24698-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 12:04:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 30 Oct 2019 11:04:22 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The devlink parameter "acl_region_rehash_interval" is a runtime
> parameter whose value is stored in a dynamically allocated memory. While
> reloading the driver, this memory is freed and then allocated again. A
> use-after-free might happen if during this time frame someone tries to
> retrieve its value.
> 
> Since commit 070c63f20f6c ("net: devlink: allow to change namespaces
> during reload") the use-after-free can be reliably triggered when
> reloading the driver into a namespace, as after freeing the memory (via
> reload_down() callback) all the parameters are notified.
> 
> Fix this by unpublishing and then re-publishing the parameters during
> reload.
> 
> Fixes: 98bbf70c1c41 ("mlxsw: spectrum: add "acl_region_rehash_interval" devlink param")
> Fixes: 7c62cfb8c574 ("devlink: publish params only after driver init is done")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied and queued up for -stable.
