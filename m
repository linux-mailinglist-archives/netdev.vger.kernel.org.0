Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7619D7F4
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDCNqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:46:43 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:45831
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728023AbgDCNqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:46:43 -0400
X-IronPort-AV: E=Sophos;i="5.72,339,1580770800"; 
   d="scan'208";a="344841719"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 15:46:41 +0200
Date:   Fri, 3 Apr 2020 15:46:40 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     olteanv@gmail.com
cc:     netdev@vger.kernel.org, joe@perches.com
Subject: question about drivers/net/dsa/sja1105/sja1105_main.c
Message-ID: <alpine.DEB.2.21.2004031542220.2694@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The function sja1105_static_config_reload in sja1105_main.c contains the
code:

                if (!an_enabled) {
                        int speed = SPEED_UNKNOWN;

                        if (bmcr & BMCR_SPEED1000)
                                speed = SPEED_1000;
                        else if (bmcr & BMCR_SPEED100)
                                speed = SPEED_100;
                        else if (bmcr & BMCR_SPEED10)
                                speed = SPEED_10;

                        sja1105_sgmii_pcs_force_speed(priv, speed);
                }

The last test bmcr & BMCR_SPEED10 does not look correct, because according
to include/uapi/linux/mii.h, BMCR_SPEED10 is 0.  What should be done
instead?

thanks,
julia
