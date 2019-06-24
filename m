Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A630450DBA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfFXOVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:21:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54634 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFXOVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:21:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 377421504100C;
        Mon, 24 Jun 2019 07:21:35 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:21:34 -0700 (PDT)
Message-Id: <20190624.072134.1587556039627335168.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        alexei.starovoitov@gmail.com, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net] net/tls: fix page double free on TX cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624042658.19198-1-jakub.kicinski@netronome.com>
References: <20190624042658.19198-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:21:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sun, 23 Jun 2019 21:26:58 -0700

> From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> 
> With commit 94850257cf0f ("tls: Fix tls_device handling of partial records")
> a new path was introduced to cleanup partial records during sk_proto_close.
> This path does not handle the SW KTLS tx_list cleanup.
> 
> This is unnecessary though since the free_resources calls for both
> SW and offload paths will cleanup a partial record.
> 
> The visible effect is the following warning, but this bug also causes
> a page double free.
 ...
> Fixes: 94850257cf0f ("tls: Fix tls_device handling of partial records")
> Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied and queued up for -stable, thanks.
