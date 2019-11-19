Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C125101109
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfKSB6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:58:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSB6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:58:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36CB415102289;
        Mon, 18 Nov 2019 17:58:21 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:58:18 -0800 (PST)
Message-Id: <20191118.175818.1172073606217291260.davem@davemloft.net>
To:     jtoppins@redhat.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: initialize ethtool info->fw_version
 before use
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f40bcf8cd93677c12bca1f06e74385c9a5f49819.1574096873.git.jtoppins@redhat.com>
References: <f40bcf8cd93677c12bca1f06e74385c9a5f49819.1574096873.git.jtoppins@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:58:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Toppins <jtoppins@redhat.com>
Date: Mon, 18 Nov 2019 12:07:53 -0500

>     probe begin { printf("net-info  version 01.01\n")}
> 
>     function memset(msg:long) %{
>     	memset((char*)STAP_ARG_msg,-1,196);
>     %}
> 
>     probe module("bnx2x").function("bnx2x_get_drvinfo")
>     {
>       printf("In function\n");
>       memset(register("rsi"));

This makes no sense.

This function is called with the buffer cleared to zero.

You're scrambling something to simulate a "bug", but that will never
be scrambled in reality.
