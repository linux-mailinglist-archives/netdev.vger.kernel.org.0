Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F398248E4B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgHRSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:55:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:34447 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgHRSz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:55:58 -0400
IronPort-SDR: /lbcQ0KV4/0yVVNRXSzRXMkVPFIaZfeZAMIHgt7Q6rMX9qs9ox4ZJaNE151x6BoXQ7QxQ6x499
 17QG/NFX1BRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="219292957"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="219292957"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:55:57 -0700
IronPort-SDR: Zgr4sRcYRIBVBVr6S4SJOqp1MJSNUPlWZum/nA9772p3UdcLBggO+OGxIjPaZrHyFuF+DqHRH2
 mVcAT4Zo3uiw==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471919907"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:55:57 -0700
Date:   Tue, 18 Aug 2020 11:55:57 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/4] sfc: take correct lock in ef100_reset()
Message-ID: <20200818115557.0000489a@intel.com>
In-Reply-To: <38c7df29-b013-7408-90aa-ed4c3797df34@solarflare.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
        <38c7df29-b013-7408-90aa-ed4c3797df34@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 13:43:57 +0100
Edward Cree <ecree@solarflare.com> wrote:

> When downing and upping the ef100 filter table, we need to take a
> write lock on efx->filter_sem, not just a read lock, because we may
> kfree() the table pointers.
> Without this, resets cause a WARN_ON from
> efx_rwsem_assert_write_locked().
> 
> Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and
> related gubbins")
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Fix makes sense
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
