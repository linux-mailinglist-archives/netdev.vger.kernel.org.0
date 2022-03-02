Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311DE4CAA00
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiCBQUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiCBQUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:20:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA647460F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:19:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1D1CB81EFF
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 16:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CCEC004E1;
        Wed,  2 Mar 2022 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646237984;
        bh=GjqVdLliE0HXIx3CImCp3wtAZyD3NZK2G6znZaOC7sg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HEkNQ7kH+rkvM2jcyu4V/FQSbgDktG2JvggRoDD19nkIfZkXUOcDHz/qltiSr/erR
         h8iD/Znrw+eIYjDN+gNEEzPmykn0KR07G/qwqLoGKb5846HXOQ000/nfcF3WyB1fe5
         YnjWksZ9rC/T2qkjYjo3mB/oLYuf0cmSVESsFZw9cWbzdyvg3iLikK1/xW4QzkIBGP
         3UDiUFOsbRtbXicXnHqNvEfRI2fjXSxqd281U/jgApeEKLjzbt/yD1rlUFaMUlu34T
         yLqVLQ7bP1q4/4eCYTygK69BBvdopbbXLDpMOgYRSglFAGPEavrg+e09c9JxjpnuPW
         sKY91+Z1wgb8A==
Message-ID: <a30e29bf-c182-66d7-0d5a-bd42aa6a3e47@kernel.org>
Date:   Wed, 2 Mar 2022 09:19:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
 <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
 <20220228205440.GA24680@debian.home>
 <faca5750-911d-151f-d5fa-7a8ed3b43b08@kernel.org>
 <20220301114107.GB24680@debian.home>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220301114107.GB24680@debian.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/22 4:41 AM, Guillaume Nault wrote:
> And my final point was that the need for ip_rt_fix_tos() is temporary:
> I plan to do the call paths review anyway, to make them initialise tos
> and scope properly, thus removing the need for RTO_ONLINK. I already
> have a draft patch series, but as I said that's work for net-next.

ok, if the cleanup is going to happen in -next then this simple patch
seems good for net and stable
