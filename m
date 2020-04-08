Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6327F1A29FB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgDHT4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:56:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgDHT4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:56:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05E69127BE380;
        Wed,  8 Apr 2020 12:56:07 -0700 (PDT)
Date:   Wed, 08 Apr 2020 12:56:06 -0700 (PDT)
Message-Id: <20200408.125606.1078177957758077983.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        cjhuang@codeaurora.org, tglx@linutronix.de, arnd@arndb.de,
        hofrat@osadl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH v2] net: qrtr: send msgs from local of same id as
 broadcast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408033249.120608-1-wenhu.wang@vivo.com>
References: <20200407132930.109738-1-wenhu.wang@vivo.com>
        <20200408033249.120608-1-wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 12:56:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: WANG Wenhu <wenhu.wang@vivo.com>
Date: Tue,  7 Apr 2020 20:32:47 -0700

> -		enqueue_fn = qrtr_bcast_enqueue;
> -		if (addr->sq_port != QRTR_PORT_CTRL) {
> +		if (addr->sq_port != QRTR_PORT_CTRL &&
> +			qrtr_local_nid != QRTR_NODE_BCAST) {

This is still not correct, it should be:

		if (addr->sq_port != QRTR_PORT_CTRL &&
		    qrtr_local_nid != QRTR_NODE_BCAST) {
