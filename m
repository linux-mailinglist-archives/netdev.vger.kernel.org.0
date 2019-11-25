Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1511095DD
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKYWxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:53:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:53:37 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDED0150728AF;
        Mon, 25 Nov 2019 14:53:36 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:53:36 -0800 (PST)
Message-Id: <20191125.145336.1803100409578989775.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jbenc@redhat.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net] ipv6: set lwtstate for ns and na dst
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3743d1e2c7fc26fb5f7401b6b0956097e997c48c.1574662992.git.lucien.xin@gmail.com>
References: <3743d1e2c7fc26fb5f7401b6b0956097e997c48c.1574662992.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 14:53:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 25 Nov 2019 14:23:12 +0800

> This patch is to fix an issue that ipv6 ns and na can't go out with the
> correct tunnel info, and it can be reproduced by:

And why shouldn't RS and redirects get this treatment too?

And then, at that point, all callers of ndisc_send_skb() have this
early route lookup code (and thus the "!dst" code path is unused), and
the question ultimately becomes why doesn't ndisc_send_skb() itself
have the dst lookup modification?

I'm not too sure about this change and will not apply it.
