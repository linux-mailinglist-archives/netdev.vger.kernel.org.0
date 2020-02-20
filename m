Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63A16539F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgBTAcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:32:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBTAcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:32:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64B0A15BD9500;
        Wed, 19 Feb 2020 16:32:51 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:32:50 -0800 (PST)
Message-Id: <20200219.163250.1284615020212149795.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com
Subject: Re: [PATCH net v4] net/tls: Fix to avoid gettig invalid tls record
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219041022.22701-1-rohitm@chelsio.com>
References: <20200219041022.22701-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:32:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Wed, 19 Feb 2020 09:40:22 +0530

> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL.
> As part of the fix, start looking each record only if the sequence number
> lies in the list else return NULL.
> There is one more check added, driver look for the start marker record to
> handle tcp packets which are before the tls offload start sequence number,
> hence return 1st record if the record is tls start marker and seq number is
> before the 1st record's starting sequence number.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied and queued up for -stable.
