Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48AB53139A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiEWOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbiEWOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:48:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D125535C;
        Mon, 23 May 2022 07:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16360B81142;
        Mon, 23 May 2022 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B379EC385AA;
        Mon, 23 May 2022 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653317327;
        bh=JJUowl47ptnLiKQVZlPgElSH7N0NgsCjov8dxq9v10Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnp8uE3xRSrq1EFCEfPYIoPnop6vaKngaXYjQT0GxqMofZ80GTaY+w1NWy6s6EG5E
         MFFdsdZtgGFbTy8/CpHirFEs0cE4CseNwRvx26I31rOaPSw6a5XMAof0+u+iLOgIWw
         uq0CgYlfgeMukSFYf6Tew/f+31f8hdDIzuvdjFp5oMkroBGBF7aZaWCT4zuh+6Dfsn
         qd4PDUV4O/Ntqz7THtjrEQWe3YrAnGWP0K/+K1Y0Q6eG9U0feVI2/e0wOgT517/nYH
         Mdu0TAhnGC5n+4b/046SYxHp5IplQlJpcgBIaAWhi1NrX+Mn9pja+YrbmlSxqrrdrw
         MqPNr/FlloZHA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nt9MS-0006hx-2D; Mon, 23 May 2022 16:48:44 +0200
Date:   Mon, 23 May 2022 16:48:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ath11k: fix netdev open race
Message-ID: <YouezMIwm3PYxOKY@hovoldconsulting.com>
References: <20220517103436.15867-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517103436.15867-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 12:34:36PM +0200, Johan Hovold wrote:
> Make sure to allocate resources needed before registering the device.
> 
> This specifically avoids having a racing open() trigger a BUG_ON() in
> mod_timer() when ath11k_mac_op_start() is called before the
> mon_reap_timer as been set up.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---

For completeness:

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Johan
