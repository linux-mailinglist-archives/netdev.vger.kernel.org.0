Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01245AB6C0
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiIBQmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiIBQmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:42:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0617B1F0
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 09:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pzki3RLPr1gwsYRnrFyk6Oj9gT4pENcHEcx/aqvi5Tk=; b=kb9bCBtoxWwRp0zxaJdProPeSX
        8TMNdlgvcfhZXiho2dtIDN5mGPmN8WVYd19blr0CWoscWFxJIxk9jvQA4umimYgxA03yL4ADVj7JR
        FHBX3XLd0UlwKP4acUWB1vwxK3rpQ9rm7OPPS1sskz988Y/xpGOpXMF+eyvHSEWCrhEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oU9jg-00FPlg-NR; Fri, 02 Sep 2022 18:41:40 +0200
Date:   Fri, 2 Sep 2022 18:41:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH net-next] net: sparx5: fix return values to correctly use
 bool
Message-ID: <YxIyRDzQt5cN7Lbn@lunn.ch>
References: <20220902084521.3466638-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902084521.3466638-1-casper.casan@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 10:45:21AM +0200, Casper Andersson wrote:
> Function was declared to return bool, but used error return strategy (0
> for success, else error). Now correctly uses bool to indicate whether
> the entry was found or not.

I think it would be better to actually return an int. < 0 error, 0 =
not foumd > 1 found. You can then return ETIMEDOUT etc.

    Andrew
