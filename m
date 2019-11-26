Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249DC10A647
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfKZWAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:00:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZWAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:00:42 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8316414D3D4C4;
        Tue, 26 Nov 2019 14:00:41 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:00:39 -0800 (PST)
Message-Id: <20191126.140039.2116411993007995978.davem@davemloft.net>
To:     axboe@kernel.dk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHSET 0/2] Disallow ancillary data from
 __sys_{recv,send}msg_file()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126013145.23426-1-axboe@kernel.dk>
References: <20191126013145.23426-1-axboe@kernel.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 14:00:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 25 Nov 2019 18:31:43 -0700

> io_uring currently uses __sys_sendmsg_file() and __sys_recvmsg_file() to
> handle sendmsg and recvmsg operations. This generally works fine, but we
> don't want to allow cmsg type operations, just "normal" data transfers.
> 
> This small patchset first splits the msghdr copy from the two main
> helpers in net/socket.c, then changes __sys_sendmsg_file() and
> __sys_recvmsg_file() to use those helpers. With patch 2, we also add a
> check to explicitly check for msghdr->msg_control and
> msghdr->msg_controllen and return -EINVAL if they are set.

For the series:

Acked-by: David S. Miller <davem@davemloft.net>
