Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090F4E30DD
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245480AbiCUTo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242624AbiCUTo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:44:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC8572E10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:43:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D64B819BE
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 19:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D79C340E8;
        Mon, 21 Mar 2022 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647891810;
        bh=x//9Wh+ojA5nbP498FO16reYQz7a7y5jcbtEgIJ1nJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dqLzIO3327uROD0ZcthcuEUvrpJ0GHKlmTpTQxQNHLXhKRd5euDGc4n/fNo26p/uq
         mP1uS8olSm4ffZ6Dv4/r+t+I7kumlLET7+WCgs0ciVndMnUokgkNaA3ah+8tiTuVve
         Rpe08DJldmeIlJ6qbbsLjS/aExjUW8PGTHpepyBNew8W21wYEmLNZnJx+v9Wlxk+/T
         gIQSsZtn0IjhjbV7DrtG84y4+h0VVN7D3W4EnBcUY4AaJTT8tjbOjlLUR7Lh2/i2Hy
         gIJWmJlJ60JYEItivsfZpDLR3nmwxokmiRyiEm6xFrqvU8aZy4Wc2O+JVEbs3o6Nwa
         +iH/LtGXzHUVg==
Date:   Mon, 21 Mar 2022 12:43:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>, netdev <netdev@vger.kernel.org>,
        Neil Spring <ntspring@fb.com>
Subject: Re: [PATCH net] tcp: ensure PMTU updates are processed during
 fastopen
Message-ID: <20220321124328.524139c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89i+2WXu2dFf6sg-G1NbBnoEmQuFmek3RxjW5HL6t93zG4g@mail.gmail.com>
References: <20220321165957.1769954-1-kuba@kernel.org>
        <CANn89i+2WXu2dFf6sg-G1NbBnoEmQuFmek3RxjW5HL6t93zG4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 12:32:34 -0700 Eric Dumazet wrote:
> Do you have a packetdrill test by any chance ?

I don't :( I was using veths to repro.
