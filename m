Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F2E3650AE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhDTDLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 23:11:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88327C06174A;
        Mon, 19 Apr 2021 20:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AqTuRNKIkAmLe8Av3ztkUAdmYLIeq8PftziUxkdnED4=; b=cmFm54dBhWL/FJIZPa1qLdPQCh
        Hw3d+6yeN1BRhVLA8lXi0+OxBNGlwLN0iOxnz1tNw19z7dwED70uUHLHZ0QHCfVKNKBQenpL6sjTp
        RiTDO60rG0H/+Io0sMW2Sl9Yi8uXuQbOmHCm5NzIBmET6uhHQgkerVA9dwlFEY8qLE05GHB/V0PuZ
        Ao/jqa8j5AAd9wR8FIZ6K7RUe8Zya2Y8SayHTkT8KDCcVbyrGWXzGbXLEMb2IexWdlSkgwpOFyitu
        JUjQ4dGrsXV5WoOuWngimlVppnjX5FKsAVbm0+zGZtX6LrP+cU2NI9VCFMIOrg0zh0XBFnqcrMJKV
        Y0NuvgGw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYgmT-00Ee86-KY; Tue, 20 Apr 2021 03:10:34 +0000
Date:   Tue, 20 Apr 2021 04:10:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "arnd@kernel.org" <arnd@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210420031029.GI2531743@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:48:17AM +0000, Vineet Gupta wrote:
> > 32-bit architectures which expect 8-byte alignment for 8-byte integers
> > and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> > page inadvertently expanded in 2019.
> 
> FWIW, ARC doesn't require 8 byte alignment for 8 byte integers. This is 
> only needed for 8-byte atomics due to the requirements of LLOCKD/SCOND 
> instructions.

Ah, like x86?  OK, great, I'll drop your arch from the list of
affected.  Thanks!
