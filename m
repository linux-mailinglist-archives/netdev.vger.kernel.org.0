Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB768244CC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfETXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:53:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfETXxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:53:23 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0200913F1847C;
        Mon, 20 May 2019 16:53:22 -0700 (PDT)
Date:   Mon, 20 May 2019 19:53:19 -0400 (EDT)
Message-Id: <20190520.195319.201742803310676769.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: vxlan: disallow removing to other namespace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 16:53:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Fri, 17 May 2019 19:42:23 -0700

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Don't allow to remove the vxlan device to other namesapce,
> because we maintain the data of vxlan net device on original
> net-namespace.
> 
>     $ ip netns add ns100
>     $ ip link add vxlan100 type vxlan dstport 4789 external
>     $ ip link set dev vxlan100 netns ns100
>     $ ip netns exec ns100 ip link add vxlan200 type vxlan dstport 4789 external
>     $ ip netns exec ns100 ip link
>     ...
>     vxlan200: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     vxlan100: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> 
> And we should create it on new net-namespace, so disallow removing it.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

I don't understand this change at all.

You keep saying "Remove" but I think you might mean simply "Move" because
the NETNS_LOCAL flag prevents moving not removing.

And why is it bad to allow vxlan devices to be moved between network
namespaces?  What problem would it cause and can you guarantee that
you are not breaking an existing user?

I'm not applying this as-is.
