Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8AE247969
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgHQWB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgHQWBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:01:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD9FC061389;
        Mon, 17 Aug 2020 15:01:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 688EC15D695C0;
        Mon, 17 Aug 2020 14:44:38 -0700 (PDT)
Date:   Mon, 17 Aug 2020 15:01:23 -0700 (PDT)
Message-Id: <20200817.150123.1361363231541199425.davem@davemloft.net>
To:     fazilyildiran@gmail.com
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dvyukov@google.com, elver@google.com, andreyknvl@google.com,
        glider@google.com, necip@google.com,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] net: qrtr: fix usage of idr in port assignment to
 socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200817155447.3158787-1-fazilyildiran@gmail.com>
References: <20200817155447.3158787-1-fazilyildiran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:44:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Date: Mon, 17 Aug 2020 15:54:48 +0000

> From: Necip Fazil Yildiran <necip@google.com>
> 
> Passing large uint32 sockaddr_qrtr.port numbers for port allocation
> triggers a warning within idr_alloc() since the port number is cast
> to int, and thus interpreted as a negative number. This leads to
> the rejection of such valid port numbers in qrtr_port_assign() as
> idr_alloc() fails.
> 
> To avoid the problem, switch to idr_alloc_u32() instead.
> 
> Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
> Signed-off-by: Necip Fazil Yildiran <necip@google.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

Applied and queued up for -stable, thank you.
