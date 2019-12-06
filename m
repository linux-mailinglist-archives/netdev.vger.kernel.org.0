Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177B811581D
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 21:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLFUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 15:07:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLFUHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 15:07:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E3551512217D;
        Fri,  6 Dec 2019 12:07:00 -0800 (PST)
Date:   Fri, 06 Dec 2019 12:06:59 -0800 (PST)
Message-Id: <20191206.120659.1363670425922838677.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pabeni@redhat.com,
        David.Laight@aculab.com
Subject: Re: [PATCH net] net: avoid an indirect call in ____sys_recvmsg()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206173836.34294-1-edumazet@google.com>
References: <20191206173836.34294-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 12:07:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  6 Dec 2019 09:38:36 -0800

> CONFIG_RETPOLINE=y made indirect calls expensive.
> 
> gcc seems to add an indirect call in ____sys_recvmsg().
> 
> Rewriting the code slightly makes sure to avoid this indirection.
> 
> Alternative would be to not call sock_recvmsg() and instead
> use security_socket_recvmsg() and sock_recvmsg_nosec(),
> but this is less readable IMO.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
