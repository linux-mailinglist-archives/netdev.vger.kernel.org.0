Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC9534F00
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiEZMSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiEZMSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:18:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A82CEBA8;
        Thu, 26 May 2022 05:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m2FP5IpgKamAC5k0mppMCSKAd6ddAm9dQQpEqx93+S8=; b=GenS8i0287bKb6Z9UL2JzpKbea
        RETCRElL4hXbU98Szz3b+ye91a8q4My0r3hozB27fhK+RXJ4FiWJox5aqXeUBg7N4qImYW6uMdJgG
        lOikZQWFAjsEc0lTgRL3m/SFcFZuhWC+DepM9fmHMVUGnvhVP634lu2e66/bg0VKJgrg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nuCRn-004Lll-8e; Thu, 26 May 2022 14:18:35 +0200
Date:   Thu, 26 May 2022 14:18:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix refcount leak in
 mv88e6xxx_mdios_register
Message-ID: <Yo9wG64tuB2Tx0SK@lunn.ch>
References: <20220526112415.13835-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526112415.13835-1-linmq006@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 03:24:15PM +0400, Miaoqian Lin wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when done.
> This function missing of_node_put() in an error path.
> Add missing of_node_put() to avoid refcount leak.

What about releasing the reference on the non error case?
Where is that.

     Andrew
