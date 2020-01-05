Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913EF130A4B
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAEWrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:47:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:47:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42DC515554F98;
        Sun,  5 Jan 2020 14:47:05 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:47:04 -0800 (PST)
Message-Id: <20200105.144704.221506192255563950.davem@davemloft.net>
To:     wgong@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103045016.12459-1-wgong@codeaurora.org>
References: <20200103045016.12459-1-wgong@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:47:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>
Date: Fri,  3 Jan 2020 12:50:16 +0800

> The len used for skb_put_padto is wrong, it need to add len of hdr.

Thanks, applied.

There is another bug here, skb_put_padto() returns an error and frees
the SKB when the put fails.  There really needs to be a check here,
because currently the code right now will keep using the freed up
skb in that situation.

Thanks.
