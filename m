Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14E5194B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbfFXRGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:06:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26311 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbfFXRGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:06:42 -0400
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5OH6bYZ014171;
        Mon, 24 Jun 2019 10:06:38 -0700
Date:   Mon, 24 Jun 2019 22:36:37 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH v2 net-next 0/4] cxgb4: Reference count MPS TCAM entries
 within a PF
Message-ID: <20190624170635.GA6413@chelsio.com>
References: <20190624085037.2358-1-rajur@chelsio.com>
 <20190624.075132.2137301224911651949.davem@davemloft.net>
 <20190624.075323.2257534731180163594.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190624.075323.2257534731180163594.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, June 06/24/19, 2019 at 07:53:23 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 24 Jun 2019 07:51:32 -0700 (PDT)
> 
> > From: Raju Rangoju <rajur@chelsio.com>
> > Date: Mon, 24 Jun 2019 14:20:33 +0530
> > 
> >> Firmware reference counts the MPS TCAM entries by PF and VF,
> >> but it does not do it for usage within a PF or VF. This patch
> >> adds the support to track MPS TCAM entries within a PF.
> >> 
> >> v1->v2:
> >>  Use refcount_t type instead of atomic_t for mps reference count
> > 
> > Series applied, thanks.
> 
> Umm, REALLY?!?!?!
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c: In function ‘cxgb4_mps_ref_dec_by_mac’:
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c:17:29: error: passing argument 1 of ‘atomic_dec_and_test’ from incompatible pointer type [-Werror=incompatible-pointer-types]
>     if (!atomic_dec_and_test(&mps_entry->refcnt)) {
>                              ^~~~~~~~~~~~~~~~~~
> 
> You just changed it to a refcount_t and didn't try compiling the
> result?
> 

No. I'm pretty sure that I have compiled and tested the changes. But, my bad
I had missed to '--amend' the last patch after 'git add'.

I'll send out next version.

> The whole point of refcount_t is that it uses a different set of
> interfaces to manipulate the object and you have to therefore
> update all the call sites properly.
> 
> Reverted...
