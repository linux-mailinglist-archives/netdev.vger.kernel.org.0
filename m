Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5393C4DE300
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240910AbiCRU4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbiCRU4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:56:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B71A1AA8E4;
        Fri, 18 Mar 2022 13:55:12 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 47EF922239;
        Fri, 18 Mar 2022 21:55:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647636910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xlvyVwPz1c1jgNM8C0j/OWMHzndCfpBmElGsRKCvqOU=;
        b=Wk1ymgOVBsdLfg9tDk3A6BvUqx/jUo0pUroFm8eZhqpkVF2ymv0ajn7lsIpD3YuutZ/VZ8
        NEAVUMpfsyPPwmJ0lx4LwC+TyD3LJ7+WHZyB1dETM2HAzo0ls0ibgW1u5Spx4Qpt3Cp5ND
        py/p5x6AVGcuZ2YIgrp1gFd+dXnvofE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Mar 2022 21:55:10 +0100
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 0/4] net: lan966x: Add support for FDMA
In-Reply-To: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
References: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c8cfb46356ab32421fbe7c0cdf4168a0@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-18 21:47, schrieb Horatiu Vultur:
> Currently when injecting or extracting a frame from CPU, the frame
> is given to the HW each word at a time. There is another way to
> inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
> In this way the entire frame is given to the HW. This improves both
> RX and TX bitrate.
> 
> v1->v2:
> - fix typo in commit message in last patch
> - remove first patch as the changes are already there
> - make sure that there is space in skb to put the FCS
> - move skb_tx_timestamp closer to the handover of the frame to the HW
> 
> Horatiu Vultur (4):
>   net: lan966x: Add registers that are used for FDMA.
>   net: lan966x: Expose functions that are needed by FDMA
>   net: lan966x: Add FDMA functionality
>   net: lan966x: Update FDMA to change MTU.
> 
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 775 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |  44 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h | 120 +++
>  .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
>  .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
>  6 files changed, 1038 insertions(+), 12 deletions(-)
>  create mode 100644 
> drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

Tested-by: Michael Walle <michael@walle.cc>

Thanks,
-michael
