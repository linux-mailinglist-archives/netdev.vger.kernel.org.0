Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672456E9D5B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjDTUlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDTUll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:41:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5342128;
        Thu, 20 Apr 2023 13:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QZ7z7uB29RQBHquVUum9Sz9RB67bfCPqLptEE5uQ75k=; b=qfP64YB7LDbZsGZvH29OLAqhqF
        wmXSb08KfeWpx03CxhqsHu1hFwenNIQA+YkeA075mtTOnL8XyEz7ZX7VhDedIZxFCCjwrxADBssNI
        85aOM8EYIrgOtJSEhLSGc61OK+OmnYVe+4+xYjQNxVnuVllMpQikMKOCQbHZg7vXOqYY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppb5r-00Aoxq-5V; Thu, 20 Apr 2023 22:41:27 +0200
Date:   Thu, 20 Apr 2023 22:41:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Herve Codina <herve.codina@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <277bcf23-146a-4fb0-b57d-5545770b5db2@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
 <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
 <20230414165504.7da4116f@bootlin.com>
 <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
 <20230417121629.63e97b80@bootlin.com>
 <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
 <20230417173941.0206f696@bootlin.com>
 <9e7fe32a-8125-41d5-9f8e-d3e5c6c64584@lunn.ch>
 <20230419090406.681e0265@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419090406.681e0265@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I can move to a basic framer abstraction as you suggested. At least:
> - devm_of_framer_optional_get()
> - devm_framer_create()
> - framer_notifier_register() or something similar.
> 
> Where do you expect to see this framer abstraction and the pef2256
> framer part ?
> driver/net/wan/framer/, other place ?

That seems like a good location.

> I think driver/net/wan/framer/ can be a good place to start as only HDLC
> will use this abstraction.

> I can use the framer abstraction from the QMC HDLC driver itself or try
> to move it to the HDLC core. Do you think it will be interesting to have
> it move to the HDLC core ?

Having it in the core would be nice. But i don't know that code, so i
cannot say how easy/hard it will be do to. hdlc.c already seems to
have some code for carrier. So you need to be careful not to break
that.

	Andrew
