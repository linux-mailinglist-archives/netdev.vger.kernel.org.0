Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C6C1E2A31
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgEZSh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgEZSh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:37:57 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BEF206F1;
        Tue, 26 May 2020 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590518276;
        bh=hJ+v+ZtKPWDjeiH+8C+HiPWRoKmZsamkqUHLH+iwbrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I/uTpomiKLlkSaf1n+iWKTuJvhsT3PVquCEL8gixRG4ShJbOFdRtQNChHVA+qJCt5
         Zy+gyzI3yD2lCg7GiYxc11Ob1Avx9sxKeJzveIkGF2OB/v9Gjuz1G+pKKRTg/dlEIp
         pJCiPI40xa65YjYgtqj6LvawIt+TB8u0SbgfI7uw=
Date:   Tue, 26 May 2020 11:37:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        nikolay@cumulusnetworks.com, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 5/5] ipv4: nexthop version of fib_info_nh_uses_dev
Message-ID: <20200526113754.0d0a64f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526150114.41687-6-dsahern@kernel.org>
References: <20200526150114.41687-1-dsahern@kernel.org>
        <20200526150114.41687-6-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 09:01:14 -0600 David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Similar to the last path, need to fix fib_info_nh_uses_dev for
> external nexthops to avoid referencing multiple nh_grp structs.
> Move the device check in fib_info_nh_uses_dev to a helper and
> create a nexthop version that is called if the fib_info uses an
> external nexthop.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Dave, bunch of white space problems here according to checkpatch:

CHECK: Alignment should match open parenthesis
#31: FILE: include/net/ip_fib.h:451:
+static inline bool nhc_l3mdev_matches_dev(const struct fib_nh_common *nhc,
+const struct net_device *dev)

WARNING: suspect code indent for conditional statements (8, 24)
#33: FILE: include/net/ip_fib.h:453:
+	if (nhc->nhc_dev == dev ||
[...]
+			return true;

ERROR: code indent should use tabs where possible
#66: FILE: include/net/nexthop.h:284:
+                }$

WARNING: please, no spaces at the start of a line
#66: FILE: include/net/nexthop.h:284:
+                }$

ERROR: code indent should use tabs where possible
#67: FILE: include/net/nexthop.h:285:
+        } else {$

WARNING: please, no spaces at the start of a line
#67: FILE: include/net/nexthop.h:285:
+        } else {$

ERROR: code indent should use tabs where possible
#71: FILE: include/net/nexthop.h:289:
+        }$

WARNING: please, no spaces at the start of a line
#71: FILE: include/net/nexthop.h:289:
+        }$

total: 3 errors, 4 warnings, 1 checks, 74 lines checked
