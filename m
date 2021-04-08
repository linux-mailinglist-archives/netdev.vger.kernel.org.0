Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27235840F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhDHNDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhDHNDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D9086008E;
        Thu,  8 Apr 2021 13:02:51 +0000 (UTC)
Date:   Thu, 8 Apr 2021 15:02:48 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH net-next v4] net: Allow to specify ifindex when device is
 moved to another namespace
Message-ID: <20210408130248.vx5nbsd3rzy52lkn@wittgenstein>
References: <20210406075448.203816-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406075448.203816-1-avagin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 12:54:48AM -0700, Andrei Vagin wrote:
> Currently, we can specify ifindex on link creation. This change allows
> to specify ifindex when a device is moved to another network namespace.
> 
> Even now, a device ifindex can be changed if there is another device
> with the same ifindex in the target namespace. So this change doesn't
> introduce completely new behavior, it adds more control to the process.
> 
> CRIU users want to restore containers with pre-created network devices.
> A user will provide network devices and instructions where they have to
> be restored, then CRIU will restore network namespaces and move devices
> into them. The problem is that devices have to be restored with the same
> indexes that they have before C/R.
> 
> Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> ---

I've compiled a kernel with this patch and was able to successfully dump
and restore a container which relies on pre-created network devices that
need to be moved into a target network namespace with a specific
ifindex. The pull-request making use of the feature in this patch can be
found here:

https://github.com/checkpoint-restore/criu/pull/1432

Thanks!
(Always happy with the fast and painless processes in net[-next]!)
Christian
