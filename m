Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144422D2D3
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfE2AX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:23:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2AX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:23:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3319E1400E0D1;
        Tue, 28 May 2019 17:23:28 -0700 (PDT)
Date:   Tue, 28 May 2019 17:23:27 -0700 (PDT)
Message-Id: <20190528.172327.2113097810388476996.davem@davemloft.net>
To:     rick.p.edgecombe@intel.com
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, luto@kernel.org, dave.hansen@intel.com,
        namit@vmware.com
Subject: Re: [PATCH v5 0/2] Fix issues with vmalloc flush flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
References: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:23:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Date: Mon, 27 May 2019 14:10:56 -0700

> These two patches address issues with the recently added
> VM_FLUSH_RESET_PERMS vmalloc flag.
> 
> Patch 1 addresses an issue that could cause a crash after other
> architectures besides x86 rely on this path.
> 
> Patch 2 addresses an issue where in a rare case strange arguments
> could be provided to flush_tlb_kernel_range(). 

It just occurred to me another situation that would cause trouble on
sparc64, and that's if someone the address range of the main kernel
image ended up being passed to flush_tlb_kernel_range().

That would flush the locked kernel mapping and crash the kernel
instantly in a completely non-recoverable way.
