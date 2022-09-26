Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B915EAF02
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiIZSEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiIZSDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C0C11A07
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A405F610A5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F38C433C1;
        Mon, 26 Sep 2022 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664214308;
        bh=U66yaBDlbF5+Hgzk6ghyJlPfwnPtNWNHT3QmGmycGcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sDWeBtnbXgjDx+FaSqI17S2+HlfyImh/2Dhtgir5/zv5qlyqljaoAnZEvu5FOMu+l
         KRR9zDjCAEMCaSSZ4NAReTpO6Ey8DYm2Ue3BeIUqV68OPupw3kg2J0jx40/2YsjurZ
         yhEWZ2jdpcegN9Dq1ywQcMB1RmTPlyqKltnABYmZ/CkGwzcQ6aQzCZBebPq7evsHEQ
         GRgHOSUUhFSwUt63wzp2RyVcr7Bb+oTt3DBlp8Gy95ef/EkXttb7heCcI82Z8ETGKF
         4/cW1ltZoqqpNJ2ypUr3epK8Sjm5bIo/qzuW1sNRNwrTEws9RSfVjXMRoLHqs+wn9P
         oEZ/hbk6fv+sg==
Date:   Mon, 26 Sep 2022 10:45:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
Message-ID: <20220926104506.559c183d@kernel.org>
In-Reply-To: <20220926100444.2e93bf28@kernel.org>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
        <YzFYYXcZaoPXcLz/@corigine.com>
        <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
        <YzFgnIUFy49QX2b6@corigine.com>
        <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
        <YzFiXabip3LRy5e2@corigine.com>
        <CAK+SQuRJd8mmwKNKNM_qsQ-h4WhLX9OcUcV9YSgAQnzG1wGMwg@mail.gmail.com>
        <20220926100444.2e93bf28@kernel.org>
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

On Mon, 26 Sep 2022 10:04:44 -0700 Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 17:29:39 +0900 Juhee Kang wrote:
> > I will send a patch by applying netdev_registered() helper function by
> > directory.  
> 
> Please hold off doing that. My preference would be to remove
> netdev_unregistering(), this is all low-gain churn.
> IMHO the helpers don't add much to readability and increase 
> the number of random helpers programmer must be aware of.
> Let me check with other netdev maintainers and get back to you.

I got hold of Paolo and he concurred. Let's remove
netdev_unregistering() instead. Thanks!
