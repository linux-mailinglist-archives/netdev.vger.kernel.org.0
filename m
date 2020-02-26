Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0932B17087E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgBZTJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:09:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgBZTJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:09:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83BCB15AA10AB;
        Wed, 26 Feb 2020 11:09:22 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:09:22 -0800 (PST)
Message-Id: <20200226.110922.2164858284509225676.davem@davemloft.net>
To:     anton.ivanov@cambridgegreys.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, mst@redhat.com, jasowang@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 11:09:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: anton.ivanov@cambridgegreys.com
Date: Mon, 24 Feb 2020 13:25:50 +0000

> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> Some of the locally generated frames marked as GSO which
> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> fragments (data_len = 0) and length significantly shorter
> than the MTU (752 in my experiments).
> 
> This is observed on raw sockets reading off vEth interfaces
> in all 4.x and 5.x kernels. The frames are reported as
> invalid, while they are in fact gso-less frames.
> 
> The easiest way to reproduce is to connect a User Mode
> Linux instance to the host using the vector raw transport
> and a vEth interface. Vector raw uses recvmmsg/sendmmsg
> with virtio headers on af_packet sockets. When running iperf
> between the UML and the host, UML regularly complains about
> EINVAL return from recvmmsg.
> 
> This patch marks the vnet header as non-GSO instead of
> reporting it as invalid.
> 
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

I don't feel comfortable applying this until we know where these
weird frames are coming from and how they are created.

Please respin this patch once you know this information and make
sure to mention it in the commit log.

Thank you.
