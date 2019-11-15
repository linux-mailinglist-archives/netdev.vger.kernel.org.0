Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16268FE67F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKOUm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:42:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:42:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48CE514E1447C;
        Fri, 15 Nov 2019 12:42:56 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:42:55 -0800 (PST)
Message-Id: <20191115.124255.1583855143943561160.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     hsweeten@visionengravers.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ep93xx_eth: fix mismatch of request_mem_region in
 remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114154324.31990-1-hslester96@gmail.com>
References: <20191114154324.31990-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:42:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 14 Nov 2019 23:43:24 +0800

> The driver calls release_resource in remove to match request_mem_region
> in probe, which is incorrect.
> Fix it by using the right one, release_mem_region.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied, thanks.

It's a shame that you can't just pass in the thing you got back from
request_mem_region() to free it.  And honestly the only thing that makes
calling release_region() wrong is that release_region() doesn't free up
the region object after unlinking it from the tree.
