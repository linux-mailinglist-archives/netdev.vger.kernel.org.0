Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20E19D88E
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390994AbgDCOEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:04:40 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12606 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgDCOEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:04:40 -0400
X-IronPort-AV: E=Sophos;i="5.72,339,1580770800"; 
   d="scan'208";a="443711742"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 16:04:38 +0200
Date:   Fri, 3 Apr 2020 16:04:38 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     sergei.shtylyov@cogentembedded.com, horms+renesas@verge.net.au,
        tho.vu.wh@rvc.renesas.com, uli+renesas@fpond.eu
cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: question about drivers/net/ethernet/renesas/ravb_main.c
Message-ID: <alpine.DEB.2.21.2004031559240.2694@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

In the function ravb_hwtstamp_get in ravb_main.c, the following code looks
suspicious:

        if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
                config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
        else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
                config.rx_filter = HWTSTAMP_FILTER_ALL;
        else
                config.rx_filter = HWTSTAMP_FILTER_NONE;

According to drivers/net/ethernet/renesas/ravb.h,
RAVB_RXTSTAMP_TYPE_V2_L2_EVENT is 0x00000002 and RAVB_RXTSTAMP_TYPE_ALL is
0x00000006.  Therefore, if the test on RAVB_RXTSTAMP_TYPE_ALL should be
true, it will never be reached.  How should the code be changed?

thanks,
julia
