Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF0131459
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEaSAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:00:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfEaSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:00:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3BCC14BEAFA9;
        Fri, 31 May 2019 11:00:50 -0700 (PDT)
Date:   Fri, 31 May 2019 11:00:50 -0700 (PDT)
Message-Id: <20190531.110050.517935401011629843.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     barbette@kth.se, xdp-newbies@vger.kernel.org, toke@redhat.com,
        saeedm@mellanox.com, leonro@mellanox.com, tariqt@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: Bad XDP performance with mlx5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531181817.34039c9f@carbon>
References: <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
        <20190531181817.34039c9f@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 11:00:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 31 May 2019 18:18:17 +0200

> On Fri, 31 May 2019 08:51:43 +0200 Tom Barbette <barbette@kth.se> wrote:
> 
>> I wonder if it doesn't simply come from mlx5/en_main.c:
>> rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
>> 
> 
> Nope, that is not the problem.

And it's easy to test this theory by forcing DMA_FROM_DEVICE.
