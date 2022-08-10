Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36058F1A7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiHJRgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiHJRgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3888261118
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C912861388
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 17:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B9C433D6;
        Wed, 10 Aug 2022 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660152962;
        bh=s9cndrWyn+mnyHvQxMbSvQvSdKyqc57LuKFNEQHA2hA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOjQi5A5GW6d7WiAIEtZNdty0V98RJi+Sp8F8FNMOq79NLNNeGmDuTQu+rnXQq+sN
         V1ZxQbs5+787TfcvlcZrOuQy6p8NC9/EGSoz9G+sTYVNF6TEzrpliuKn9vu+AuZiQL
         7HKGzcp27oI7ppw1LWH1oLwUGb7gu+Ewlb0Vmi/kHYTqwPFogJDqcX9WTj/mMVrNmh
         kTcurhzoGoR9jOkvuCB6t4r4filpDszyTtr5F4euDHKBumVokinUza901BAxlRsAA4
         Ng72cNXUKkZ6yEc7KRe3uE82uvVI0SIuUPPm8OGdK+LV0ugZf6em8Fdn0nic/BjXHo
         qUeREF5S05h8g==
Date:   Wed, 10 Aug 2022 10:36:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
Message-ID: <20220810103601.0dccbc63@kernel.org>
In-Reply-To: <9ec77cf1ffaa29aedd57c29ac77b525d0e700acf.camel@sipsolutions.net>
References: <20220804174307.448527-1-prestwoj@gmail.com>
        <20220804174307.448527-2-prestwoj@gmail.com>
        <20220804114342.71d2cff0@kernel.org>
        <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
        <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
        <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
        <d585f719af13d7a7194e7cb734c5a7446954bf01.camel@gmail.com>
        <9ec77cf1ffaa29aedd57c29ac77b525d0e700acf.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 19:17:19 +0200 Johannes Berg wrote:
> Thinking about that now, maybe it's not _that_ bad? Especially given
> that "live" can mean different things (as discussed here), and for
> wireless that doesn't necessarily mean IFF_UP, but rather something like
> "IFF_UP + not active".
> 
> Jakub, what do you think?

Agreed, even tho the concept of a live address change seems generic 
the implications and definition of "live" are very area specific.
Let's handwave that nl80211 is a subordinate API of RT netlink :)
