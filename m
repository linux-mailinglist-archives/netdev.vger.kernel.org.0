Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47755EC7A8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiI0P1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiI0P1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:27:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD011B2624
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=00L8vXvRdI4FxVAid4+JoQi64LgoEtII4VifWlCMeUA=; b=Vnv9kxzcUGuh64E3WiR0fcht5X
        Im+wT7JPdHeGzT5nH5WXETxW3487dTpKLFbPsK07aCIawTcKOUcVtICo+1XqAS9E9Pi5FWxhp7cD6
        c8Lu4B04MHcfPmb7FKNRwLhho1dvr8B/+EAQ0UmdFT7r7nAv1laB37LYDYoWhHGC1fGk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odCUZ-000Pws-Ru; Tue, 27 Sep 2022 17:27:27 +0200
Date:   Tue, 27 Sep 2022 17:27:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        vinicius.gomes@intel.com, aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com
Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Message-ID: <YzMWX1xPC0NChKNl@lunn.ch>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 09:06:52PM +0800, Muhammad Husaini Zulkifli wrote:
> The HW TX timestamps created by the NIC via socket options can be
> requested using the current network timestamps generation capability of
> SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this socket flag
> is PTP, however other packet applications that require tx timestamps might
> also ask for it.
> 
> The problem is that, when there is a lot of traffic, there is a high chance
> that the timestamps for a PTP packet will be lost if both PTP and Non-PTP
> packets use the same SOF TIMESTAMPING TX HARDWARE causing the tx timeout.
> 
> DMA timestamps through socket options are not currently available to
> the user. Because if the user wants to, they can configure the hwtstamp
> config option to use the new introduced DMA Time Stamp flag through the
> setsockopt().
> 
> With these additional socket options, users can continue to utilise
> HW timestamps for PTP while specifying non-PTP packets to use DMA
> timestamps if the NIC can support them.

Although this is not actually for PTP, you probably should Cc: the PTP
maintainer for patches like this.

	   Andrew
