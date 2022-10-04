Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075915F3B2D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 04:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJDCLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 22:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJDCLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 22:11:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCB337FA4;
        Mon,  3 Oct 2022 19:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F9161215;
        Tue,  4 Oct 2022 02:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF83C433D7;
        Tue,  4 Oct 2022 02:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664849489;
        bh=q1D/lcAfEqwQRzAJ618mSd0Fz+jYv3RXeLwsOi63dzI=;
        h=Date:From:To:Cc:Subject:From;
        b=e0q9vVpTvECT0o0QgD4DuQgmKY5uesNYOAYotsX9h1/MDyIyG21GcyyeTpbMe2JDB
         AB7KGcxqzuOv9Zsi6x+PfZ8PqN+UMPGQIK529QB2jff4egly5Yj1lsWvGDUyj45hjX
         w3syEfzjPdlTNhES7GwMBSA0XRunP8YclFoeogViHZZYoaw1BdJTV+JFBxXZZIitRs
         JQzJU5OJS048V0fleKSwkKBcLE4LXR5UKDsJGERdNt0nqZLg+1aVtQY0A4K4thw+rK
         3httrB4+L2h5tot5HIiWHzxhiqeXnbGyP+CqsFa4AkwcD0nVqL4J5kfIKGfq0SBWd4
         WiYQ6Fy07GbuA==
Date:   Mon, 3 Oct 2022 19:11:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: doc warnings in *80211
Message-ID: <20221003191128.68bfc844@kernel.org>
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

Hi,

doing basic sanity checks before submitting the net-next PR I spotted
that we have these warnings when building documentation on net-next:

Documentation/driver-api/80211/cfg80211:48: ./include/net/cfg80211.h:6960: WARNING: Duplicate C declaration, also defined at driver-api/80211/cfg80211:6924.
Declaration is '.. c:function:: void cfg80211_rx_assoc_resp (struct net_device *dev, struct cfg80211_rx_assoc_resp *data)'.
Documentation/driver-api/80211/mac80211:109: ./include/net/mac80211.h:5046: WARNING: Duplicate C declaration, also defined at driver-api/80211/mac80211:1065.
Declaration is '.. c:function:: void ieee80211_tx_status (struct ieee80211_hw *hw, struct sk_buff *skb)'.


The test is highly unscientific (checkout net, make htmldocs, checkout
net-next, make htmldocs) so IDK if these are new...
