Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F28131DB8
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 03:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgAGCmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 21:42:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGCmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 21:42:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00379159E963D;
        Mon,  6 Jan 2020 18:42:16 -0800 (PST)
Date:   Mon, 06 Jan 2020 18:42:16 -0800 (PST)
Message-Id: <20200106.184216.2300076228313231081.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] ionic: fix for ppc msix layout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106210512.34244-3-snelson@pensando.io>
References: <20200106210512.34244-1-snelson@pensando.io>
        <20200106210512.34244-3-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jan 2020 18:42:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon,  6 Jan 2020 13:05:10 -0800

> The IBM Power9 ppc64 seems to have a problem with not wanting
> to limit the address space used by a PCI device.  The Naples
> internal HW can only address up to 52 bits, but the ppc does
> not play well with that limitation.  This patch tells the
> system how to work with Naples successfully.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Then dma_set_mask_and_coherent() should fail, either that or the mask
being passed in isn't correct.

There is no reason this hack should be necessary in any driver.

Our DMA abstractions are built to handle exactly this kind of
situation.

Please find out what is really going on and fix this properly.

Thank you.
