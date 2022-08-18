Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D16F598309
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbiHRMVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244538AbiHRMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:21:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30606B2766
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dq9dbm0tmnjrwAD5XBorx46WWBa5P2aFLxVzpomgOjg=; b=BQZjeIQoUuJIVQnKFobAbGVYgA
        qj9UbilpprJFa7RZ6hyauMDl/4C+21PMPqXNSlWpmW0F0UKoOic+LY93isiUOQ9gqvPtQtO5nBlbw
        RL9AulASzqTE9SHOAj6dOdjHecVkVUWO1vxUBKl1z8+eJx1jRz4Sh95SVBUbi5w1P3tA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOeWB-00Djtw-Pa; Thu, 18 Aug 2022 14:20:59 +0200
Date:   Thu, 18 Aug 2022 14:20:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Guobin Huang <huangguobin4@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v2] net: moxa: MAC address reading, generating, validity
 checking
Message-ID: <Yv4uq9nYp4Gu+PC4@lunn.ch>
References: <20220818092317.529557-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818092317.529557-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:23:17PM +0300, Sergei Antonov wrote:
> This device does not remember its MAC address, so add a possibility
> to get it from the platform. If it fails, generate a random address.
> This will provide a MAC address early during boot without user space
> being involved.
> 
> Also remove extra calls to is_valid_ether_addr().
> 
> Made after suggestions by Andrew Lunn:
> 1) Use eth_hw_addr_random() to assign a random MAC address during probe.
> 2) Remove is_valid_ether_addr() from moxart_mac_open()
> 3) Add a call to platform_get_ethdev_address() during probe
> 4) Remove is_valid_ether_addr() from moxart_set_mac_address(). The core does this
> 
> v1 -> v2:
> Handle EPROBE_DEFER returned from platform_get_ethdev_address().
> Move MAC reading code to the beginning of the probe function.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
