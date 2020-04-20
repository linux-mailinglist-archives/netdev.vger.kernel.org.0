Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44A61B19E8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDTXEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTXEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:04:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C207FC061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 16:04:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA97A1277F502;
        Mon, 20 Apr 2020 16:04:10 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:04:07 -0700 (PDT)
Message-Id: <20200420.160407.599781180956473040.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: change wmb to smb_wmb in
 rtl8169_start_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3cb5e0d1-15c6-ff98-dced-44e75f1341b9@gmail.com>
References: <3cb5e0d1-15c6-ff98-dced-44e75f1341b9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 16:04:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 20 Apr 2020 22:52:59 +0200

> A barrier is needed here to ensure that rtl_tx sees the descriptor
> changes (DescOwn set) before the updated tp->cur_tx value. Else it may
> wrongly assume that the transfer has been finished already. For this
> purpose smp_wmb() is sufficient.
> 
> No separate barrier is needed for ordering the descriptor changes
> with the MMIO doorbell write. The needed barrier is included in
> the non-relaxed writel() used by rtl8169_doorbell().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
