Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABE616577C
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgBTGWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgBTGWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 01:22:33 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE45124656;
        Thu, 20 Feb 2020 06:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582179753;
        bh=MXNqUjhkIuyTar8HWf3hdCAD14eiqyxSqYwVsymYXXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXil2VozUN5LbdlM/Nd8iNtGCw9mLxMuC9wQL3v6A3B/yn1tPlCPrHjMgXwrS3UC2
         kBfLemTf2vPqIg89LOzbsS1YDWy+gYNZW56vSL662wHIuYtn3hyj90+6BGTeKuSorM
         bjvvU0nK5/enXNdMPveweN9HhxWEmh6ny+z6/6IQ=
Date:   Wed, 19 Feb 2020 22:22:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/7] net/mlxfw: Improve FSM err message
 reporting and return codes
Message-ID: <20200219222231.46425175@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200220022502.38262-3-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
        <20200220022502.38262-3-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 02:25:42 +0000 Saeed Mahameed wrote:
> Report unique and standard error codes corresponding to the specific
> FW flash error. In addition, add a more detailed error messages to
> netlink.
> 
> Before:
> $ devlink dev flash pci/0000:05:00.0 file ...
> Error: mlxfw: Firmware flash failed.
> devlink answers: Invalid argument
> 
> After:
> $ devlink dev flash pci/0000:05:00.0 file ...
> Error: mlxfw: Firmware flash failed: pending reset.
> devlink answers: Operation already in progress

That sounds incorrect, no? Isn't EBUSY more appropriate here?
The flash operation is not already in progress..

Also the ERR_ERROR could perhaps be simply -EIO?

Other than the error code selection the patches look good to me!

> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

