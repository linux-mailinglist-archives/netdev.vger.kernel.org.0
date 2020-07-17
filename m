Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF8B224496
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgGQTtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgGQTtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:49:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD85C0619D2;
        Fri, 17 Jul 2020 12:49:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81B8A11E45928;
        Fri, 17 Jul 2020 12:49:44 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:49:43 -0700 (PDT)
Message-Id: <20200717.124943.1418473237939036327.davem@davemloft.net>
To:     paolo.pisati@canonical.com
Cc:     kuba@kernel.org, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716155114.72625-1-paolo.pisati@canonical.com>
References: <20200716155114.72625-1-paolo.pisati@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:49:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>
Date: Thu, 16 Jul 2020 17:51:14 +0200

> Fix ip_defrag.sh when CONFIG_NF_DEFRAG_IPV6=m:
> 
> $ sudo ./ip_defrag.sh
> + set -e
> + mktemp -u XXXXXX
> + readonly NETNS=ns-rGlXcw
> + trap cleanup EXIT
> + setup
> + ip netns add ns-rGlXcw
> + ip -netns ns-rGlXcw link set lo up
> + ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_high_thresh=9000000
> + ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_low_thresh=7000000
> + ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_time=1
> + ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_high_thresh=9000000
> + ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_low_thresh=7000000
> + ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_time=1
> + ip netns exec ns-rGlXcw sysctl -w net.netfilter.nf_conntrack_frag6_high_thresh=9000000
> + cleanup
> + ip netns del ns-rGlXcw
> 
> $ ls -la /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
> ls: cannot access '/proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh': No such file or directory
> 
> $ sudo modprobe nf_defrag_ipv6
> $ ls -la /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
> -rw-r--r-- 1 root root 0 Jul 14 12:34 /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
> 
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

Applied, thanks.
