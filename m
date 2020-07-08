Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89312218106
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 09:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbgGHHWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 03:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbgGHHWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 03:22:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F98206E2;
        Wed,  8 Jul 2020 07:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192928;
        bh=gZLYphm/8a/epa3E7RA5fX3xr14yYSnJtxLzPsd4g7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YftndEr5NH4IRw/bTOP+tIRhjZ0Yu/1xeV4AHGIBIEwZCWgmbs6K2WY0AsfgvwWJ2
         eO6B8vOtQVAm7mVJ0WKvN06Tk4pkGkZ2E+A6zZU/GxDPopPNfLDMdhSnocE67McmX9
         qc7rerPIdwLwNuDAO0B5bYMJ6315kbq2FH4LXswc=
Date:   Wed, 8 Jul 2020 09:22:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chucheng Luo <luochucheng@vivo.com>
Subject: Re: [PATCH net-next 1/9] debugfs: make sure we can remove u32_array
 files cleanly
Message-ID: <20200708072200.GC353684@kroah.com>
References: <20200707212434.3244001-1-kuba@kernel.org>
 <20200707212434.3244001-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707212434.3244001-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 02:24:26PM -0700, Jakub Kicinski wrote:
> debugfs_create_u32_array() allocates a small structure to wrap
> the data and size information about the array. If users ever
> try to remove the file this leads to a leak since nothing ever
> frees this wrapper.
> 
> That said there are no upstream users of debugfs_create_u32_array()
> that'd remove a u32 array file (we only have one u32 array user in
> CMA), so there is no real bug here.
> 
> Make callers pass a wrapper they allocated. This way the lifetime
> management of the wrapper is on the caller, and we can avoid the
> potential leak in debugfs.
> 
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Chucheng Luo <luochucheng@vivo.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
