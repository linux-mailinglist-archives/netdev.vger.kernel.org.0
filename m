Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3656730FC2F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbhBDTFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:05:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:46255 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239587AbhBDTEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:04:04 -0500
IronPort-SDR: WhgJSyIWnYctIOkzr1PBl1WUgla7TuIk8X3rDMf6SoM2pm+xyvSnzVhyGMwnwHhg5xzV/HfpuU
 hXhrbzYr0ong==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="200301947"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="200301947"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:03:23 -0800
IronPort-SDR: jpKQen8Rw1w/GTlGqKxz5LW6mJtMIWqq23SRrSqGanQFPBDmmS6/gNVqQhCKbsB29Izz3kT1nU
 eplBTt5FbMTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393325665"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 04 Feb 2021 11:03:22 -0800
Date:   Thu, 4 Feb 2021 19:54:03 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes
 under XDP
Message-ID: <20210204185403.GD2580@ranger.igk.intel.com>
References: <cover.1612456902.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1612456902.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 06:49:25PM +0200, Camelia Groza wrote:
> This series addresses issue with the current workaround for the A050385
> erratum in XDP scenarios.
> 
> The first patch makes sure the xdp_frame structure stored at the start of
> new buffers isn't overwritten.
> 
> The second patch decreases the required data alignment value, thus
> preventing unnecessary realignments.
> 
> The third patch moves the data in place to align it, instead of allocating
> a new buffer for each frame that breaks the alignment rules, thus bringing
> an up to 40% performance increase. With this change, the impact of the
> erratum workaround is reduced in many cases to a single digit decrease, and
> to lower double digits in single flow scenarios.
> 

For series:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> Changes in v2:
> - guarantee enough tailroom is available for the shared_info in 1/3
> 
> Camelia Groza (3):
>   dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
>   dpaa_eth: reduce data alignment requirements for the A050385 erratum
>   dpaa_eth: try to move the data in place for the A050385 erratum
> 
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 42 +++++++++++++++++--
>  1 file changed, 38 insertions(+), 4 deletions(-)
> 
> --
> 2.17.1
> 
