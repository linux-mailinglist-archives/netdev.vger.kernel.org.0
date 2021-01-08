Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3892EF83E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbhAHTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:34:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:18828 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbhAHTeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 14:34:36 -0500
IronPort-SDR: 0EXBG+N0nP6x/00fXdmYHLZ55leGIBNsJnk0Wk/FZl27wjxwhFuJuESzCoGUPtYOGolQVHPNrz
 qtzpnv9yBnpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="175067803"
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="175067803"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 11:33:55 -0800
IronPort-SDR: 79/KaNk1Ms8kgYGanksZ4cSW2m9LIFrAyncUUXwJFM4a65YsUwBeDQqvsYalTdouTE2tAspl2g
 BsrFF55Hmz7w==
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="380227754"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.68.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 11:33:55 -0800
Date:   Fri, 8 Jan 2021 11:33:54 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] ice: drop dead code in ice_receive_skb()
Message-ID: <20210108113354.00000dd9@intel.com>
In-Reply-To: <20210108113903.3779510-2-eric.dumazet@gmail.com>
References: <20210108113903.3779510-1-eric.dumazet@gmail.com>
        <20210108113903.3779510-2-eric.dumazet@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> napi_gro_receive() can never return GRO_DROP
> 
> GRO_DROP can only be returned from napi_gro_frags()
> which is the other NAPI GRO entry point.
> 
> Followup patch will remove GRO_DROP, because drivers
> are not supposed to call napi_gro_frags() if prior
> napi_get_frags() has failed.
> 
> Note that I have left the gro_dropped variable. I leave to ice
> maintainers the decision to further remove it from ethtool -S results.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Jakub or David, you're welcome to apply directly as part of this series.

The original code went into the kernel right as the code to remove
GRO_DROP returns went in just before, but the reviews crossed each
other and no-one (especially me :-( ) caught it.

for reference:
commit 0e00c05fa72554c86d7c7e0f538ec83bfe277c91
Merge: b18e9834f7b2 045790b7bc66
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Jun 25 16:16:21 2020 -0700
Subject: Merge branch 'napi_gro_receive-caller-return-value-cleanups'

