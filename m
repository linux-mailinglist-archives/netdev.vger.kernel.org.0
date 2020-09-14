Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6647326999E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgINXYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:24:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:37310 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINXYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:24:20 -0400
IronPort-SDR: 4idz1fYvjU7nLXQwXBijmam0TNjPxTU5z8ern4yBrwlgx3izNA0ZTDqpR3KWY6u3At9XkVbv+W
 A888iFGuN/8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="138679366"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="138679366"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:24:19 -0700
IronPort-SDR: nWzgMFRAmFm4INASCsK2bT9OmnJmxRtDwVU2CpHnG313JE0+v7F457PtMFnwbvNaicBIVZV8rn
 bShmDr99W0PA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482534876"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.55.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:24:18 -0700
Date:   Mon, 14 Sep 2020 16:24:18 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <edumazet@google.com>
Subject: Re: [PATCH][next][v2] iavf: use kvzalloc instead of kzalloc for
 rx/tx_bi buffer
Message-ID: <20200914162418.00007393@intel.com>
In-Reply-To: <1598592392-30673-1-git-send-email-lirongqing@baidu.com>
References: <1598592392-30673-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li RongQing wrote:

> when changes the rx/tx ring to 4096, kzalloc may fail due to
> a temporary shortage on slab entries.
> 
> so using kvmalloc to allocate this memory as there is no need
> that this memory area is physical continuously.
> 
> and using __GFP_RETRY_MAYFAIL to allocate from kmalloc as
> far as possible, which can reduce TLB pressure than vmalloc
> as suggested by Eric Dumazet

This change is no good, it's using RETRY_MAYFAIL but still using
v*alloc.

Please see my replies to the i40e version of the patch. I don't think
we should apply these.
