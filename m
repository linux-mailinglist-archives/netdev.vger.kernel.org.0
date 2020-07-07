Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C5D217B20
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgGGWmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGWmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:42:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDABC061755;
        Tue,  7 Jul 2020 15:42:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61B9E120F19EC;
        Tue,  7 Jul 2020 15:42:51 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:42:50 -0700 (PDT)
Message-Id: <20200707.154250.1379487839723091014.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: qed: fix buffer overflow on ethtool -d
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706092553.3512-1-alobakin@marvell.com>
References: <20200706092553.3512-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:42:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Mon, 6 Jul 2020 12:25:53 +0300

> When generating debug dump, driver firstly collects all data in binary
> form, and then performs per-feature formatting to human-readable if it
> is supported.
> 
> For ethtool -d, this is roughly incorrect for two reasons. First of all,
> drivers should always provide only original raw dumps to Ethtool without
> any changes.
> The second, and more critical, is that Ethtool's output buffer size is
> strictly determined by ethtool_ops::get_regs_len(), and all data *must*
> fit in it. The current version of driver always returns the size of raw
> data, but the size of the formatted buffer exceeds it in most cases.
> This leads to out-of-bound writes and memory corruption.
> 
> Address both issues by adding an option to return original, non-formatted
> debug data, and using it for Ethtool case.
> 
> v2:
>  - Expand commit message to make it more clear;
>  - No functional changes.
> 
> Fixes: c965db444629 ("qed: Add support for debug data collection")
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied, thank you.
