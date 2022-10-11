Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6655FAA63
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJKBzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJKBzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:55:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F878357DE
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KGZ6a7aafWZtq0DwkFE0E0w6vssTGVZafhVHgbngNe0=; b=YGCwsLiZLbJ0KI7L86vxvfRZQb
        uNquYyfRgGb6A5HSCpU8biXi6vRpBn8a5+QxkkZ9dvLOiF2xrXQPocaEmPPGxzFdqo63t9Q2jCwOG
        tgUvlhjDI5zf7fSyzBtaLCRenx7jQM7pO546jTpXPn1tBfgqhD9uvosTupBLWbpPZIaE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oi4U5-001g2W-T2; Tue, 11 Oct 2022 03:55:05 +0200
Date:   Tue, 11 Oct 2022 03:55:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 2/3] net: txgbe: Reset hardware
Message-ID: <Y0TM+eHBtGa0YLXq@lunn.ch>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
 <20220929093424.2104246-3-jiawenwu@trustnetic.com>
 <YzXL1WoOwUnU93Lq@lunn.ch>
 <00f601d8dc71$f0ded460$d29c7d20$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00f601d8dc71$f0ded460$d29c7d20$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So you have an IO barrier before and a read barrier afterwards.  So all i think you need is a
> mb(), not a
> > full rd32().
> > 
> >    Andrew
> > 
> 
> I think we need a readl(), because there are problems that sometimes IO is not synchronized with
> flushing memory on some domestic cpu platforms.
> It can become a serious problem, causing register error configurations.
 
So please document this as a comment in the code.

I also then start to wounder if more such flushes are needed, to
handle this broken hardware. Do you have a detailed description of
what actually goes wrong? Otherwise how do you know when such a flush
is needed?

   Andrew
