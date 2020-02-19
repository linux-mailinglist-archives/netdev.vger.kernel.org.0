Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5991164E5B
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgBSTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:04:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSTEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:04:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECD4F15ADF45D;
        Wed, 19 Feb 2020 11:04:44 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:04:44 -0800 (PST)
Message-Id: <20200219.110444.1076444130408435728.davem@davemloft.net>
To:     christian.brauner@ubuntu.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        haw.loeung@canonical.com
Subject: Re: [PATCH net-next] net/ipv4/sysctl: show
 tcp_{allowed,available}_congestion_control in non-initial netns
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219120253.2667548-1-christian.brauner@ubuntu.com>
References: <20200219120253.2667548-1-christian.brauner@ubuntu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 11:04:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Wed, 19 Feb 2020 13:02:53 +0100

> It is currenty possible to switch the TCP congestion control algorithm
> in non-initial network namespaces:
> 
> unshare -U --map-root --net --fork --pid --mount-proc
> echo "reno" > /proc/sys/net/ipv4/tcp_congestion_control
> 
> works just fine. But currently non-initial network namespaces have no
> way of kowing which congestion algorithms are available or allowed other
> than through trial and error by writing the names of the algorithms into
> the aforementioned file.
> Since we already allow changing the congestion algorithm in non-initial
> network namespaces by exposing the tcp_congestion_control file there is
> no reason to not also expose the
> tcp_{allowed,available}_congestion_control files to non-initial network
> namespaces. After this change a container with a separate network
> namespace will show:
> 
> root@f1:~# ls -al /proc/sys/net/ipv4/tcp_* | grep congestion
> -rw-r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_allowed_congestion_control
> -r--r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_available_congestion_control
> -rw-r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_congestion_control
> 
> Link: https://github.com/lxc/lxc/issues/3267
> Reported-by: Haw Loeung <haw.loeung@canonical.com>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Applied, thank you.
