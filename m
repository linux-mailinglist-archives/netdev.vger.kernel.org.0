Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D38B1CBC31
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgEIBsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEIBsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 21:48:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A72CF2184D;
        Sat,  9 May 2020 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588988896;
        bh=1Yq8ETdj2RiWGbRAmpZXiiimnP7VGCPSm9Ed+hkuj0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jyKl7SXRcWXWq5imKX647QsE8ox1R/mLLI5pgfKj/GuuF5vNyleinXiN1DB6qZIYs
         2hzFd6LWWdZQB/nBLgNKu/4nmDuJmj9WMSakljsOFYZRP7ZGJMhoEf6VNXKgC5T9lS
         Vm4EQByrNVHtcl4+8DazaV07KTFjEqnXuJq+HTzQ=
Date:   Fri, 8 May 2020 18:48:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Joe Perches <joe@perches.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tg3: tidy up loop, remove need to compute off with
 a multiply
Message-ID: <20200508184814.45e10c12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160ce1ee-3bb5-3357-64f3-e5dea8c0538d@canonical.com>
References: <20200508225301.484094-1-colin.king@canonical.com>
        <1890306fc8c9306abe11186d419d84f784ee6144.camel@perches.com>
        <160ce1ee-3bb5-3357-64f3-e5dea8c0538d@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 00:31:03 +0100 Colin Ian King wrote:
> > My preference would be for
> > 
> > {
> > 	int i;
> > 	u32 off = 0;
> > 
> > 	for (i = 0; i < TG3_SD_NUM_RECS; i++) {
> > 		tg3_ape_scratchpad_read(tp, (u32 *)ocir, off, TC3_OCIR_LEN);
> > 
> > 		if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
> > 		    !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
> > 			memset(ocir, 0, TG3_OCIR_LEN);
> > 
> > 		off += TG3_OCIR_LEN;
> > 		ocir++;
> > 	}
> >   
> OK, I'll send a V3 tomorrow.

I already reviewed and applied v2, just waiting for builds to finish,
let's leave it.
