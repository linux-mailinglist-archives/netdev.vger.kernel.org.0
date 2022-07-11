Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B095709EA
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiGKS3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKS3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:29:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD5A1275A
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 11:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51B96614E3
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 18:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FB2C34115;
        Mon, 11 Jul 2022 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657564160;
        bh=fEgCzjV/7eisWm3F0bfE6x6eY/udqi64CeIF8jt9A1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JrjGklWBg2ZUYOl0wEPb14xXMrLdFZNsGtujpCotXCf3BU5yiowJMpLyR/WKUNZ95
         CpH5LRdMzkxO1Hwr5pOW94eAJupWvf6sKt4R3ZS6JzUydEFgULg0vZ/IyEAacNXN6W
         M4y6gokRZYAQW9hvrY/XDjzW4iTw8wKQGIXoqkmU2T6sks5wwsqT9gVQ5LmRNNvgT1
         ysx4Yt/0z3ptOPYze11S2yqAw4VGO4vEIYhLWsUnGm1iHKw8B4jrmtQbI4+gpzD2Oc
         2IiqFFdiJldUVUtRfUyD8IAyjgXciUNgNUIGSIQJ/jPcEqwL5FTvmD38UOkFxImhvf
         IGOZZ7d3GtrYg==
Date:   Mon, 11 Jul 2022 11:29:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220711112911.6e387608@kernel.org>
In-Reply-To: <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
        <20220705182512.309f205e@kernel.org>
        <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
        <20220706131735.4d9f4562@kernel.org>
        <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
        <20220707170145.0666cd4c@kernel.org>
        <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
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

On Sat, 9 Jul 2022 22:09:12 +0200 Matthias May wrote:
> >> How should i go forward with this?  
> > 
> > I think your example above shows that "tos 0xa0" does not work but the
> > conversation was about inheritance, does "tos inherit" not work either?  
> 
> Yes inherit does not work either. This is why i started setting it statically.
> However I think I figured out what is going on.
> Setting the TOS statically to 0xa0 does work... when the payload is IPv4 or IPv6,
> which is also when inheriting works. For everything other type of payload, it is always 0x00.
> This is different than with an IPv4 tunnel.
> Should i consider this a bug that needs to be fixed, or is that the intended behaviour?

Yes, most likely a bug if you ask me :S
