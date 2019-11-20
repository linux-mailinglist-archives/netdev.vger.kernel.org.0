Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7F1030D7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKTAm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:42:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKTAm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:42:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAE30144B3066;
        Tue, 19 Nov 2019 16:42:57 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:42:57 -0800 (PST)
Message-Id: <20191119.164257.971575741444657962.davem@davemloft.net>
To:     vinschen@redhat.com
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, nic_swsd@realtek.com
Subject: Re: [PATCH net] r8169: disable TSO on a single version of RTL8168c
 to fix performance
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119090939.29169-1-vinschen@redhat.com>
References: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
        <20191119090939.29169-1-vinschen@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 16:42:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>
Date: Tue, 19 Nov 2019 10:09:39 +0100

> During performance testing, I found that one of my r8169 NICs suffered
> a major performance loss, a 8168c model.
> 
> Running netperf's TCP_STREAM test didn't return the expected
> throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
> enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
> throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I can
> test (either one of 8169s, 8168e, 8168f).
> 
> Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
> "r8169: enable HW csum and TSO" as the culprit.
> 
> I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
> special-casing the 8168evl as per the patch below.  This fixed the
> performance problem for me.
> 
> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>

Applied, but it would be really nice to know why this is happening
instead of just turning it off completely.
