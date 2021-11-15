Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D34511AE
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 20:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbhKOTNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 14:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbhKOTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:11:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AB1C0431A8;
        Mon, 15 Nov 2021 09:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OTCtPaHwniBROQ1KohHRpPYNoRP5VsY2XqJDv3P4Ku8=; b=p44p58onIF9Z6LsfhgifLQmpAQ
        5rbfZ5rZCcIfYI1EN82K2qOPc31bzqeDPDxORr1CCmk6ghtzXIUolrh7rKherFqFYbEe7QAEUEHT+
        C1ki1M6pI0QGkAvwgKH4ZYOKgZStlL9i3ZZKRfRq/TZO4kweYM5mhxufLO5fx+mCI9ryljqRdjiTP
        avUby45C7olHbESiRE2qoMu8fLD1e727JeYNko6BxgWGbL6jeaTMH/A/XyLIMZamG6KaLbM11fL3J
        T/SjN1AktjqOicD1baasIqVAuRpN8/TIMGtuz296vRO+qKCYMK2YvgFbzdIZ3PnPqlMUvmEtWYMhS
        AWmJaU4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmgGk-00GcKy-2q; Mon, 15 Nov 2021 17:59:50 +0000
Date:   Mon, 15 Nov 2021 09:59:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, akpm@linux-foundation.org, peterz@infradead.org,
        will@kernel.org, jhubbard@nvidia.com, yuzhao@google.com,
        mcroce@microsoft.com, fenghua.yu@intel.com, feng.tang@intel.com,
        jgg@ziepe.ca, aarcange@redhat.com, guro@fb.com,
        "kernelci@groups.io" <kernelci@groups.io>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Message-ID: <YZKgFqwJOIEObMg7@infradead.org>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJKNLEm6YTkygHM@apalos.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just popping out of nowhere on lkml, but yes ARM LPAE
uses a 64-bit dma_addr_t, as a 64-bit phys_addr_t implies that.
Same for x86-32 PAE and similar cases on MIPS and probably a few
other architectures.

But what is the actual problem with a 32-bit virtual and 64-bit
pysical/dma address?  That is a pretty common setup and absolutely
needs to be deal with in drivers and inrastructure.
