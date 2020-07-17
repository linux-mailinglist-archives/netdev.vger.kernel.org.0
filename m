Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1FB223034
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 03:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGQBJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 21:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgGQBJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 21:09:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A68207BC;
        Fri, 17 Jul 2020 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594948183;
        bh=YgKWBSEhMz+NBsILDChvn58XB6zvrCT46NsLfN2Wlvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G1B1dSdQxJSbAwQbKGWfetCMby9xFfC7p/pGY5CWr4Okt2I0vXrAgr6WRzjFNORXB
         AdjvdYH6Mh/eFqHoyigXwYxQzusAMPqLZff6rZXhrpCGImdP+F/cOm77Ia3K0zKOKw
         LI2qL2r2VXGG7bboN3eJbgOSfNKleZ6O5z6D5FDQ=
Date:   Thu, 16 Jul 2020 18:09:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
Message-ID: <20200716180942.2c52ecd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716155114.72625-1-paolo.pisati@canonical.com>
References: <20200716155114.72625-1-paolo.pisati@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 17:51:14 +0200 Paolo Pisati wrote:
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

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
