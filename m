Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67431243CE3
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 17:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHMP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 11:57:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:56998 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgHMP5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 11:57:54 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 07DFvTYl016888;
        Thu, 13 Aug 2020 10:57:29 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 07DFvRQB016882;
        Thu, 13 Aug 2020 10:57:27 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 13 Aug 2020 10:57:27 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc_ef100: Fix build failure on powerpc
Message-ID: <20200813155727.GF6753@gate.crashing.org>
References: <44e26ec6a1bc01b5b138c29b623c83d5846718b2.1597329390.git.christophe.leroy@csgroup.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44e26ec6a1bc01b5b138c29b623c83d5846718b2.1597329390.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.4.2.3i
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 02:39:10PM +0000, Christophe Leroy wrote:
> ppc6xx_defconfig fails building sfc.ko module, complaining
> about the lack of _umoddi3 symbol.
> 
> This is due to the following test
> 
>  		if (EFX_MIN_DMAQ_SIZE % reader->value) {
> 
> Because reader->value is u64.
> 
> As EFX_MIN_DMAQ_SIZE value is 512, reader->value is obviously small
> enough for an u32 calculation, so cast it as (u32) for the test, to
> avoid the need for _umoddi3.

That isn't the same e.g. if reader->value is 2**32 + small.  Which
probably cannot happen, but :-)


Segher
