Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5925969848B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBOTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOT37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:29:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D5A3C292
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FBB5B8208F
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E79C433EF;
        Wed, 15 Feb 2023 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676489396;
        bh=nLFo7p+XQTXhFxPEJG83Edy6aFX3Xb2I9t6sOTjUfTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nNYinktvAkMTaJcog3U2Lh/Mw+cFTlcIxrSoNlokVSk/60qkPFQ6Zn0Dkrbifyomk
         HOO8rEhOQyrGr4Ppkap1qbwxjnu5D2oZmNvqEzynMUt+ozXwjp13OFONgnWrD9+i94
         vjdFKn7gnNXjB56uQEB8Qn4b3xI3fKCpeNCnapq9tQkI6GaNFeKqpFuyNZmfKD5H1A
         Wn/kNMf039UNFF1jKOxgHy3573kAkwB1Y73h2s9woJ7He2fgtezmZnRNi19FAPHogq
         8Bwzn42WlKOJNHc5JBf9s1O/UAst7uaffrvubJzOWpYX8ByuWnZ+8YB/9W9RxeJANu
         9N+qnHq8IozPA==
Date:   Wed, 15 Feb 2023 11:29:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH net-next 0/2] net: default_rps_mask follow-up
Message-ID: <20230215112954.7990caa5@kernel.org>
In-Reply-To: <cover.1676484775.git.pabeni@redhat.com>
References: <cover.1676484775.git.pabeni@redhat.com>
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

On Wed, 15 Feb 2023 19:33:35 +0100 Paolo Abeni wrote:
> The first patch namespacify the setting: once proper isolation
> is in place in the main namespace, additional demux in the child
> namespaces will be redundant.

Would you mind spelling this out again for me? If I create a veth with
the peer in a netns, the local end will get one RPS mask and the netns
end will get a RPS mask from the netns. If the daemon is not aware of
having to configure RPS masks (which I believe was your use case) then
it won't set the default mask in the netns either.. so we assume veth
is first created and then moved, or we don't use veth, or I'm lost
completely?
