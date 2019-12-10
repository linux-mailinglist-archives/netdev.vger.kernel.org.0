Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA99117EE0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfLJESE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:18:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfLJESE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:18:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F9D4154F05F5;
        Mon,  9 Dec 2019 20:18:03 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:18:03 -0800 (PST)
Message-Id: <20191209.201803.1567890316622204670.davem@davemloft.net>
To:     yyd@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        ycheng@google.com
Subject: Re: [PATCH net-next] net-tcp: Disable TCP ssthresh metrics cache
 by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209191959.100759-1-yyd@google.com>
References: <20191209191959.100759-1-yyd@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:18:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Kevin(Yudong) Yang" <yyd@google.com>
Date: Mon,  9 Dec 2019 14:19:59 -0500

> This patch introduces a sysctl knob "net.ipv4.tcp_no_ssthresh_metrics_save"
> that disables TCP ssthresh metrics cache by default. Other parts of TCP
> metrics cache, e.g. rtt, cwnd, remain unchanged.
> 
> As modern networks becoming more and more dynamic, TCP metrics cache
> today often causes more harm than benefits. For example, the same IP
> address is often shared by different subscribers behind NAT in residential
> networks. Even if the IP address is not shared by different users,
> caching the slow-start threshold of a previous short flow using loss-based
> congestion control (e.g. cubic) often causes the future longer flows of
> the same network path to exit slow-start prematurely with abysmal
> throughput.
> 
> Caching ssthresh is very risky and can lead to terrible performance.
> Therefore it makes sense to make disabling ssthresh caching by
> default and opt-in for specific networks by the administrators.
> This practice also has worked well for several years of deployment with
> CUBIC congestion control at Google.
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>

Makes sense, applied, thanks.
