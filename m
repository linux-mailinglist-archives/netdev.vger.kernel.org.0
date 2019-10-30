Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91169EA3AA
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfJ3Szc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:55:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfJ3Szc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:55:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90DDA14788BA4;
        Wed, 30 Oct 2019 11:55:31 -0700 (PDT)
Date:   Wed, 30 Oct 2019 11:55:30 -0700 (PDT)
Message-Id: <20191030.115530.829611129255271384.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] vxlan: fix unexpected failure of vxlan_changelink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030081512.25743-1-ap420073@gmail.com>
References: <20191030081512.25743-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 11:55:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed, 30 Oct 2019 08:15:12 +0000

> After commit 0ce1822c2a08 ("vxlan: add adjacent link to limit depth
> level"), vxlan_changelink() could fail because of
> netdev_adjacent_change_prepare().
> netdev_adjacent_change_prepare() returns -EEXIST when old lower device
> and new lower device are same.
> (old lower device is "dst->remote_dev" and new lower device is "lowerdev")
> So, before calling it, lowerdev should be NULL if these devices are same.
> 
> Test command1:
>     ip link add dummy0 type dummy
>     ip link add vxlan0 type vxlan dev dummy0 dstport 4789 vni 1
>     ip link set vxlan0 type vxlan ttl 5
>     RTNETLINK answers: File exists
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
