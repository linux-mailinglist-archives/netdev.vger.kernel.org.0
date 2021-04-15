Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19C1361570
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhDOWXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbhDOWXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:23:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8F4C061763;
        Thu, 15 Apr 2021 15:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yCQQJkhIcMUmiG+jHzQ5AkwvKN7ARCVTOi/VwlhPfFg=; b=G7souXSd1HEpHpbqWUh5lxEnqG
        72yPOet6m6dISSd7axpLwF1GuIay1RV/45F6tKEj6BDbJeHO2gR22kOlntma0FZZPbcvmmD/MXrGS
        ZotJA+5b3Jkfa2AaHAwGam44BVigQtO2OUUWx5K1MxtG1pZ5CiucXxAz7iHzXIdBtZHCcO6t1Akn0
        Jf6e7BP75Cnv6p6VHUjizlw9iKFlwP1TXfBnuT7H8BBwGli/+jYj8lop4Y87z4ime9iPQZllplUcx
        wCGblTZ9lVpuPqcW+hkdOWg1I0lN04CeqlSLB7/d6d7euI/yXPCIGsLBBIFSox+o2XhR8MFrZidLv
        V60jL89w==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXANH-0099VJ-Ux; Thu, 15 Apr 2021 22:22:19 +0000
Date:   Thu, 15 Apr 2021 23:22:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210415222211.GG2531743@casper.infradead.org>
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210415182155.GD2531743@casper.infradead.org>
 <5179a01a462f43d6951a65de2a299070@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179a01a462f43d6951a65de2a299070@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 09:11:56PM +0000, David Laight wrote:
> Isn't it possible to move the field down one long?
> This might require an explicit zero - but this is not a common
> code path - the extra write will be noise.

Then it overlaps page->mapping.  See emails passim.
