Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D62C2726EA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgIUO0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:26:01 -0400
Received: from verein.lst.de ([213.95.11.211]:40266 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUO0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 10:26:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 241E068B02; Mon, 21 Sep 2020 16:25:58 +0200 (CEST)
Date:   Mon, 21 Sep 2020 16:25:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     David Miller <davem@davemloft.net>, hch@lst.de, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bypass ->sendpage for slab pages
Message-ID: <20200921142557.GA16775@lst.de>
References: <20200819051945.1797088-1-hch@lst.de> <20200819.120709.1311664171016372891.davem@davemloft.net> <20200820043744.GA4349@lst.de> <20200821.141400.594703865403700191.davem@davemloft.net> <903c7e2c-100f-267f-efd8-b0b3345dc918@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903c7e2c-100f-267f-efd8-b0b3345dc918@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 04:37:24PM +0800, Coly Li wrote:
> Hi David and Christoph,
> 
> It has been quiet for a while, what should we go next for the
> kernel_sendpage() related issue ?
> 
> Will Christoph's or my series be considered as proper fix, or maybe I
> should wait for some other better idea to show up? Any is OK for me,
> once the problem is fixed.

I think for all the network storage stuff we really need a "send me
out a page helper", and the nvmet bits that Dave pointed to look to
me like they actually are currently broken.

Given that Dave doesn't want to change the kernel_sendpage semantics
I'll resend with a new helper instead.  Any preferences for a name?
safe_sendpage?  kernel_sendpage_safe?  kernel_send_one_page?
