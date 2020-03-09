Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8517EBCF
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCIWSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbgCIWSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 18:18:20 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D536124654;
        Mon,  9 Mar 2020 22:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583792300;
        bh=mYx3QRAvqe976CWysthxxEWxFwkuRtUp3ELo6VoNbyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p5dIPOQTiMqEXsM8sn2AG3Dpkaub0+pix9WvbKxxMDPEXgJEA7seAfPlJwrUmYetS
         sS/MOlpyaBM4JAleu8Eyu/A/K2GiHqHlVBK/vld2NINkUbsASXFC/Pgcqqbolxp2jr
         ZgLToYI37w+QO2XOEw+5Pndv00TEaA7tlPvhy8qM=
Date:   Mon, 9 Mar 2020 15:18:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/6] net: sched: Add centralized RED flag
 checking
Message-ID: <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200309183503.173802-3-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
        <20200309183503.173802-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Mar 2020 20:34:59 +0200 Ido Schimmel wrote:
> From: Petr Machata <petrm@mellanox.com>
> 
> The qdiscs RED, GRED, SFQ and CHOKE use different subsets of the same pool
> of global RED flags. Add a common function for all of these to validate
> that only supported flags are passed. In later patches this function will
> be extended with a check for flag compatibility / meaningfulness.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

The commit message should mention this changes behavior of the kernel,
as the flags weren't validated, so buggy user space may start to see
errors.

The only flags which are validated today are the gRED per-vq ones, which
are a recent addition and were validated from day one.
