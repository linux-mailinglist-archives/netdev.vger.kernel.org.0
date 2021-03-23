Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC16346457
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhCWQEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhCWQER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:04:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7BDC061574;
        Tue, 23 Mar 2021 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r7+igJ9I87Xh8bxlKqYfdSgKCX2KNmm4MEakh98beFw=; b=os62iuDYvApfDmg2N7at90eK0V
        lX/O8fluacIAn/6uLJvBkKZeli2m8dQtEvPSdbDYlurCHbajtH3C1QxSvI7BrkEe7Ee3VcX4+QsVI
        7Jit+hLJBH2EtiaUi+XBp49kw7uBdU3DjrMxPP0RuBn/7JWz38wQQgi0Ny7KP4kKIMdvdOgKJi2gH
        7HXBH7TKpZ2rHGEADi2IO4jckaC1g/neIISBb42JvVoSLYvinCd5JsdSV4+0F4dxe57nsWIpCrDur
        v4/qIiLhgL7OVbmamIh2gEPGyJx9GYPJ8m2VP3SKwV2K9YFasf6r9dV/mVaTww6nVaect4YmjtqkN
        p1qamv8A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOjT8-00AFf4-Ou; Tue, 23 Mar 2021 16:01:39 +0000
Date:   Tue, 23 Mar 2021 16:01:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
Message-ID: <20210323160122.GC2438080@infradead.org>
References: <20210322161822.1546454-1-vinicius.gomes@intel.com>
 <20210322161822.1546454-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322161822.1546454-2-vinicius.gomes@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:18:20AM -0700, Vinicius Costa Gomes wrote:
> Make pci_enable_ptm() accessible from the drivers.
> 
> Even if PTM still works on the platform I am using without calling
> this function, it might be possible that it's not always the case.
> 
> Exposing this to the driver enables the driver to use the
> 'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.
> 
> This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Without an EXPORT_SYMBOL_GPL this is not going to be very useful for
your driver.
