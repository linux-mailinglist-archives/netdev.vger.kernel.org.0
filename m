Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED76F838AF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732987AbfHFSgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:36:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbfHFSgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:36:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0BF0152488DC;
        Tue,  6 Aug 2019 11:36:40 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:36:40 -0700 (PDT)
Message-Id: <20190806.113640.171591509807004446.davem@davemloft.net>
To:     firo.yang@suse.com
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ixgbe: sync the first fragment unconditionally
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806092919.13211-1-firo.yang@suse.com>
References: <20190806092919.13211-1-firo.yang@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:36:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>
Date: Tue, 6 Aug 2019 09:29:51 +0000

> In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
> could possibly allocate a page, DMA memory buffer, for the first
> fragment which is not suitable for Xen-swiotlb to do DMA operations.
> Xen-swiotlb will internally allocate another page for doing DMA
> operations. It requires syncing between those two pages. Otherwise,
> we may get an incomplete skb. To fix this problem, sync the first
> fragment no matter the first fargment is makred as "page_released"
> or not.
> 
> Signed-off-by: Firo Yang <firo.yang@suse.com>

I don't understand, an unmap operation implies a sync operation.
