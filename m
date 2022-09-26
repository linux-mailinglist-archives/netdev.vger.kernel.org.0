Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B460A5EAE52
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiIZRkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiIZRjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BE37EFEE
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BBD36101C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846B1C433D6;
        Mon, 26 Sep 2022 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664211885;
        bh=htn06NdWvUFcL3p9966YRFE4oIuo8LE3fPjvxk+Glxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZuRLkeEyt3gbv8+54EQYBNpFpa+64K5JUAv+X28AYY5c8EYdnfOAYvDBp+luUq+I
         YavOd8L/R8IxM+JrsJsfk5hyse7FKvlbSotMG3TlZtKrZsVvCk2Z0qaBBg7VfgpiNS
         FIYoIvHiOUZtateAhlF/BiH7CUN0I6VoVWvAVvVf3ivvejRMZ640mKk00jFCRlO1Uh
         +UpTp0nCMlawIpMhQkDl585bUNnKU65qiSZvP3axNhuTyrZee+aDpJ5vApiKvi6A4N
         pzxZzYNp/sH3CwE96FSgnnim1Fped4snunipn9VOUzeTr1/2iqU/fFZUqb6Y8ra4w4
         wC1m1r3MXXEoA==
Date:   Mon, 26 Sep 2022 10:04:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
Message-ID: <20220926100444.2e93bf28@kernel.org>
In-Reply-To: <CAK+SQuRJd8mmwKNKNM_qsQ-h4WhLX9OcUcV9YSgAQnzG1wGMwg@mail.gmail.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
        <YzFYYXcZaoPXcLz/@corigine.com>
        <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
        <YzFgnIUFy49QX2b6@corigine.com>
        <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
        <YzFiXabip3LRy5e2@corigine.com>
        <CAK+SQuRJd8mmwKNKNM_qsQ-h4WhLX9OcUcV9YSgAQnzG1wGMwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 17:29:39 +0900 Juhee Kang wrote:
> I will send a patch by applying netdev_registered() helper function by
> directory.

Please hold off doing that. My preference would be to remove
netdev_unregistering(), this is all low-gain churn.
IMHO the helpers don't add much to readability and increase 
the number of random helpers programmer must be aware of.
Let me check with other netdev maintainers and get back to you.
