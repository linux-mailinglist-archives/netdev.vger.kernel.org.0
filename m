Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC973273737
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgIVASM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIVASM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:18:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DAAC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:18:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72C2D127DB645;
        Mon, 21 Sep 2020 17:01:24 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:18:11 -0700 (PDT)
Message-Id: <20200921.171811.928921340970787118.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
Subject: Re: [PATCH] net: lantiq: Add locking for TX DMA channel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921223113.8750-1-hauke@hauke-m.de>
References: <20200921223113.8750-1-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:01:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 22 Sep 2020 00:31:13 +0200

> The TX DMA channel data is accessed by the xrx200_start_xmit() and the
> xrx200_tx_housekeeping() function from different threads. Make sure the
> accesses are synchronized by using locking around the accesses.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

The TX lock will be held during the xrx200_start_xmit() routine, always.

Please use that in xrx200_tx_housekeeping() instead of adding a new
unnecessary lock.

Thank you.
