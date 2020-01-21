Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F9A143960
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAUJVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:21:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUJVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:21:23 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8837A15B90CB6;
        Tue, 21 Jan 2020 01:21:21 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:19:08 +0100 (CET)
Message-Id: <20200121.101908.1503286381717753243.davem@davemloft.net>
To:     tagyounit@gmail.com
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, dlebrun@google.com,
        david.lebrun@uclouvain.be
Subject: Re: [PATCH net] ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120044837.76789-1-tagyounit@gmail.com>
References: <20200120044837.76789-1-tagyounit@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:21:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuki Taguchi <tagyounit@gmail.com>
Date: Mon, 20 Jan 2020 13:48:37 +0900

> After LRO/GRO is applied, SRv6 encapsulated packets have
> SKB_GSO_IPXIP6 feature flag, and this flag must be removed right after
> decapulation procedure.
> 
> Currently, SKB_GSO_IPXIP6 flag is not removed on End.D* actions, which
> creates inconsistent packet state, that is, a normal TCP/IP packets
> have the SKB_GSO_IPXIP6 flag. This behavior can cause unexpected
> fallback to GSO on routing to netdevices that do not support
> SKB_GSO_IPXIP6. For example, on inter-VRF forwarding, decapsulated
> packets separated into small packets by GSO because VRF devices do not
> support TSO for packets with SKB_GSO_IPXIP6 flag, and this degrades
> forwarding performance.
> 
> This patch removes encapsulation related GSO flags from the skb right
> after the End.D* action is applied.
> 
> Fixes: d7a669dd2f8b ("ipv6: sr: add helper functions for seg6local")
> Signed-off-by: Yuki Taguchi <tagyounit@gmail.com>

Applied and queued up for -stable, thanks.
