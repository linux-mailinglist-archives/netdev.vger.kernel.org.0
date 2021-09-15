Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E786240CD9A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhIOT7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhIOT7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 15:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D6661056;
        Wed, 15 Sep 2021 19:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631735897;
        bh=chwJXG3cCxNkxThAaeaYd2H28rFX+0jWYFGsJuceJ0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pHL3rgfrOBpACshuCWFSmZpCuiQScECRjk3qlbljiMw8IudtYTmlFxW4EoappohQ/
         QgxVcRdxYIRn40RpKLwsJsaGSpH9TmzJlBXE9S7b5xHy8tFBIvPjIoFWprCwr9s1mS
         uY3l5ERORaEUsnQ7h4EVwlZU+OMYRZHpDIs1y1H5UBkfkPJPaH8LZST8f0fxwtnjJj
         qjjOIQsJmlMd3LeaV1mKPx5g8xwC0ZNMokgWeUyJywE3qxzx7TUR8gmt2lroNrn9fs
         1WKiqUalek7w/cHJ80RiRvSgSlTrKKB2xBPXtVSKDpKlNkAiB/Z3vh0M7frrIBstSL
         2Nbp+8LEmDJ4Q==
Date:   Wed, 15 Sep 2021 12:58:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: wwan: iosm: fix memory leak in
 ipc_devlink_create_region()
Message-ID: <20210915125815.5908968d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB5008F3D88D66FAC431FC98BDD7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20210915103559.GA7060@kili>
        <SJ0PR11MB5008F3D88D66FAC431FC98BDD7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 11:05:42 +0000 Kumar, M Chetan wrote:
> > This doesn't free the first region in devlink->cd_regions[0] so it's a memory
> > leak.
> > 
> > Fixes: 13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump
> > collection")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/wwan/iosm/iosm_ipc_devlink.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)  
> 
> Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>

I'll toss this from patchwork because I'm going to post a revert 
of the entire patch.

The abuse of devlink params for configuring flashing process is
unacceptable.
