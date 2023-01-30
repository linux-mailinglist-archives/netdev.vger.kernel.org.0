Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB7681489
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbjA3PP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbjA3PP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:15:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC209F;
        Mon, 30 Jan 2023 07:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F4DCB810C5;
        Mon, 30 Jan 2023 15:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B30C433EF;
        Mon, 30 Jan 2023 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675091697;
        bh=a90xOxXdB9OfE6RDvIPeW0/Rs9qLjfMK4/iU5SQsr+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qhg7Gq0GRWzDG5WdtbKlYpHeurP+ox7s6RY3ZxVqgYy4MD+SlfNvlTqMud9BvVmgn
         toS83V+xCfsTDkxn6G+XbNfr+xoGIos68x1ytoBWb742IgNud/mWDZybq2qAo8pU5w
         j94Ed+1zOKFp+EUvby24Iig8Cp8L9HtfPoscQqn4=
Date:   Mon, 30 Jan 2023 15:01:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?0JbQsNC90LTQsNGA0L7QstC40Ycg0J3QuNC60LjRgtCwINCY0LPQvtGA0LU=?=
         =?utf-8?B?0LLQuNGH?= <n.zhandarovich@fintech.ru>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Message-ID: <Y9fNs5QWbrJh+yH6@kroah.com>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com>
 <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
 <Y9fIFirNHNP06e1L@kroah.com>
 <e17c785dbacf4605a726cc939bee6533@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e17c785dbacf4605a726cc939bee6533@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:48:24PM +0000, Жандарович Никита Игоревич wrote:
> > On Mon, Jan 30, 2023 at 01:27:26PM +0000, Жандарович Никита Игоревич
> > wrote:
> > > > What is the git commit id of this upstream?
> > > >
> > > > And I can't apply this as-is for the obvious reason it would mess up
> > > > the changelog, how did you create this?
> > > >
> > > > confused,
> > > >
> > > > greg k-h
> > >
> > > Commit in question is b671da33d1c5973f90f098ff66a91953691df582
> > > upstream. I wasn't certain it makes sense to backport the whole patch
> > > as only a small portion of it pertains to the fault at question.
> > 
> > What is the "fault"?
> 
> In 5.10.y "mt7615_init_tx_queues() returns 0 regardless of how final
> mt7615_init_tx_queue() performs. If mt7615_init_tx_queue() fails (due to
> memory issues, for instance), parent function will still erroneously
> return 0."

And how can memory issues actually be triggered in a real system?  Is
this a fake problem or something you can validate and verify works
properly?

Don't worry about fake issues for stable backports please.

thanks,

greg k-h
