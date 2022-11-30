Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55B263E3BB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiK3Wxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiK3Wxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:53:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EFB91340
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yPkms9V27PTBI839aS+Isvf8AquPKHByy1MYl0RWNSw=; b=nl2kwrhtJ3Fm9bJPG0F0ajToNC
        gcHabgTwea+7JyVZNphEUPNP1V5g5GjVhIw5+voZtZQn4hJ3jiWsSCv95bgWAnTgTgAHZEGM7p190
        NmlDp/kz1xqpe9tUjF8I9UJu1STgv6fmWepq3vSb9/Bn7e2eECUKF8QedYOtOlHrkORw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0VxO-0040UH-Nx; Wed, 30 Nov 2022 23:53:34 +0100
Date:   Wed, 30 Nov 2022 23:53:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 3/4] tsnep: Throttle interrupts
Message-ID: <Y4fe7i+UypsTbWgQ@lunn.ch>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
 <20221130193708.70747-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130193708.70747-4-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 08:37:07PM +0100, Gerhard Engleder wrote:
> Without interrupt throttling, iperf server mode generates a CPU load of
> 100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
> on a 1Gbit/s link. The reason is a high interrupt load with interrupts
> every ~20us.
> 
> Reduce interrupt load by throttling of interrupts. Interrupt delay
> default is 64us. For iperf server mode the CPU load is significantly
> reduced to ~20% and the throughput reaches the maximum of 941MBit/s.
> Interrupts are generated every ~140us.
> 
> RX and TX coalesce can be configured with ethtool. RX coalesce has
> priority over TX coalesce if the same interrupt is used.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
