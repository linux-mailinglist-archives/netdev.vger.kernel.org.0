Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6818E71
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfEIQvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:51:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37014 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfEIQvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:51:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C99F314D08EBF;
        Thu,  9 May 2019 09:51:34 -0700 (PDT)
Date:   Thu, 09 May 2019 09:51:34 -0700 (PDT)
Message-Id: <20190509.095134.1780905261988048160.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH RFC net-next] netlink: Add support for timestamping
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509155542.25494-1-dsahern@kernel.org>
References: <20190509155542.25494-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:51:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  9 May 2019 08:55:42 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Add support for timestamping netlink messages. If a socket wants a
> timestamp, it is added when the skb clone is queued to the socket.
> 
> Allow userspace to know the actual time an event happened. In a
> busy system there can be a long lag between when the event happened
> and when the message is read from the socket. Further, this allows
> separate netlink sockets for various RTNLGRP's where the timestamp
> can be used to sort the messages if needed.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
> one question I have is whether it would be better to add the timestamp
> when the skb is created so it is the same for all sockets as opposed to
> setting the time per socket.

If the importance is that the timestamp is when the "event" occurs
then you should set it at skb creation time.
