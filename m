Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C876BF20E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjCQUC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCQUCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:02:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65510C562C;
        Fri, 17 Mar 2023 13:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hjoCaoMyVwfgWhD4Puq2LxQCA6EVw2Wv3xpe0y2HjhU=; b=VvMDgXSWSuISs5SyCvjp+lODMu
        QqCrLOmqRKDsGdp2VWRP0XhGosjp0gk1Lla1MRRpO5WQVdw/xQ+l59VfBCAQwkjOR4in31O5/QLJC
        ZJQ5Ypl0AqdPgvpwTY56U1qi7FV2qUr4OImCXjmZIJAnDOJBk8WnsS/KZlij+tr01sqs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdGHi-007eEh-Qs; Fri, 17 Mar 2023 21:02:42 +0100
Date:   Fri, 17 Mar 2023 21:02:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 2/2] net: stmmac: move fixed-link support fixup
 code
Message-ID: <166f45dc-c27e-41fd-aa82-bad696f32184@lunn.ch>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:02:08PM +0800, Michael Sit Wei Hong wrote:
> xpcs_an_inband value is updated in the speed_mode_2500 function
> which turns on the xpcs_an_inband mode.
> 
> Moving the fixed-link fixup code to right before phylink setup to
> ensure no more fixup will affect the fixed-link mode configurations.

Please could you explain why this is correct, when you could simple
not set priv->plat->mdio_bus_data->xpcs_an_inband = true;
in intel_speed_mode_2500()?

This all seems like hacks, rather than a clean design.

     Andrew
