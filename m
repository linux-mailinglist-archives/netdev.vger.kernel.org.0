Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB931F6E16
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFKToM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgFKToM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:44:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D17C08C5C1;
        Thu, 11 Jun 2020 12:44:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EC2D128657AC;
        Thu, 11 Jun 2020 12:44:12 -0700 (PDT)
Date:   Thu, 11 Jun 2020 12:44:11 -0700 (PDT)
Message-Id: <20200611.124411.1798325783779516035.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] xdp: fix xsk_generic_xmit errno
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591852266-24017-1-git-send-email-lirongqing@baidu.com>
References: <1591852266-24017-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 12:44:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu, 11 Jun 2020 13:11:06 +0800

> @@ -353,7 +353,6 @@ static int xsk_generic_xmit(struct sock *sk)
>  		len = desc.len;
>  		skb = sock_alloc_send_skb(sk, len, 1, &err);
>  		if (unlikely(!skb)) {
> -			err = -EAGAIN;
>  			goto out;
>  		}

Since the result is a single-statement basic block you must remove the
curly braces.
