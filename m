Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6420C859BC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfHHFXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:23:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:61961 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfHHFXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:23:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="374729200"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2019 22:23:47 -0700
Date:   Wed, 7 Aug 2019 22:23:46 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     <mark.einon@gmail.com>, <davem@davemloft.net>,
        <willy@infradead.org>, <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] net: ethernet: et131x: Use GFP_KERNEL instead of
 GFP_ATOMIC when allocating tx_ring->tcb_ring
Message-ID: <20190807222346.00002ba7@intel.com>
In-Reply-To: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
References: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 09:38:42 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> There is no good reason to use GFP_ATOMIC here. Other memory allocations
> are performed with GFP_KERNEL (see other 'dma_alloc_coherent()' below and
> 'kzalloc()' in 'et131x_rx_dma_memory_alloc()')
> 
> Use GFP_KERNEL which should be enough.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Sure, but generally I'd say GFP_ATOMIC is ok if you're in an init path
and you can afford to have the allocation thread sleep while memory is
being found by the kernel.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
