Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF8123F6E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRGNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:13:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRGNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:13:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BCDE15004EAC;
        Tue, 17 Dec 2019 22:13:52 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:13:51 -0800 (PST)
Message-Id: <20191217.221351.137832734104800157.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] net: annotate lockless accesses to
 sk->sk_pacing_shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217025103.252578-1-edumazet@google.com>
References: <20191217025103.252578-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:13:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 16 Dec 2019 18:51:03 -0800

> sk->sk_pacing_shift can be read and written without lock
> synchronization. This patch adds annotations to
> document this fact and avoid future syzbot complains.
> 
> This might also avoid unexpected false sharing
> in sk_pacing_shift_update(), as the compiler
> could remove the conditional check and always
> write over sk->sk_pacing_shift :
> 
> if (sk->sk_pacing_shift != val)
> 	sk->sk_pacing_shift = val;
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
