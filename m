Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6120512A456
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 23:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLXWyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 17:54:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57250 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfLXWyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 17:54:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E0CB154C8767;
        Tue, 24 Dec 2019 14:54:46 -0800 (PST)
Date:   Tue, 24 Dec 2019 14:54:43 -0800 (PST)
Message-Id: <20191224.145443.2006645470880449664.davem@davemloft.net>
To:     amessina@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udp: fix integer overflow while computing available
 space in sk_rcvbuf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219140803.135164-1-amessina@google.com>
References: <20191219140803.135164-1-amessina@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 14:54:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Messina <amessina@google.com>
Date: Thu, 19 Dec 2019 15:08:03 +0100

> When the size of the receive buffer for a socket is close to 2^31 when
> computing if we have enough space in the buffer to copy a packet from
> the queue to the buffer we might hit an integer overflow.
> 
> When an user set net.core.rmem_default to a value close to 2^31 UDP
> packets are dropped because of this overflow. This can be visible, for
> instance, with failure to resolve hostnames.
> 
> This can be fixed by casting sk_rcvbuf (which is an int) to unsigned
> int, similarly to how it is done in TCP.
> 
> Signed-off-by: Antonio Messina <amessina@google.com>

Applied and queued up for -stable, thanks.
