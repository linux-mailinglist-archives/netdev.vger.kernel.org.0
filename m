Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B75F456E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 16:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJDO04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 10:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJDO0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 10:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C30606AF;
        Tue,  4 Oct 2022 07:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EEE6146F;
        Tue,  4 Oct 2022 14:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB85C433D6;
        Tue,  4 Oct 2022 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664893607;
        bh=QZ2653spgHjRMR3e6WKRMxQMSlvQSp9fSLVm9Ed6dxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bbBTYqnFFFP+dO4enwEkIS+II+AMlCqmZYw1/FCbGBe6WXv6T7M84yS8kkpzcp3b5
         jD1CPbv61fMxmjVRp14l63Q0eAuQBBH+mtwspfsCf8rtjNAhcUDBDcJdZrX92lDaS9
         Xxdgt4PAevIrCZr8Se2hMt7c4Afj8IDbd1BWqVrlVa6cuOunXab5w2c9HsmLwRM8eI
         LgQDDm17ojA0j7ymbyojjZQhPUxTZl1ykYZ7nhCkjZ1HyW2Kc2MER1wclllf9hFnXV
         X4xazn8WKd3zGjROmQo5EaFUrDdYxMceCmMM9KgnC9CodVCFC+KHr6/NUriOXBr+AQ
         wrN5GQRhim1Tg==
Date:   Tue, 4 Oct 2022 07:26:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: doc warnings in *80211
Message-ID: <20221004072646.64ad2c8c@kernel.org>
In-Reply-To: <62b8bf6f739d1e6e0320864ed0660c9c52b767c4.camel@sipsolutions.net>
References: <20221003191128.68bfc844@kernel.org>
        <62b8bf6f739d1e6e0320864ed0660c9c52b767c4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Oct 2022 09:51:07 +0200 Johannes Berg wrote:
> > doing basic sanity checks before submitting the net-next PR I spotted
> > that we have these warnings when building documentation on net-next:
> > 
> > Documentation/driver-api/80211/cfg80211:48: ./include/net/cfg80211.h:6960: WARNING: Duplicate C declaration, also defined at driver-api/80211/cfg80211:6924.
> > Declaration is '.. c:function:: void cfg80211_rx_assoc_resp (struct net_device *dev, struct cfg80211_rx_assoc_resp *data)'.  
> 
> Hmm. That's interesting. I guess it cannot distinguish between the type
> of identifier?
> 
> struct cfg80211_rx_assoc_resp vs. cfg80211_rx_assoc_resp()
> 
> Not sure what do about it - rename one of them?
> 
> > Documentation/driver-api/80211/mac80211:109: ./include/net/mac80211.h:5046: WARNING: Duplicate C declaration, also defined at driver-api/80211/mac80211:1065.
> > Declaration is '.. c:function:: void ieee80211_tx_status (struct ieee80211_hw *hw, struct sk_buff *skb)'.  
> 
> Same here actually!
> 
> I don't think either of these is new.

Thanks for checking!

Adding linux-doc, but I presume Jon & co are aware if this is not new.
