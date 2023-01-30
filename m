Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF3680F28
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbjA3Nhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbjA3Nhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:37:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686B039295;
        Mon, 30 Jan 2023 05:37:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C63C860FFA;
        Mon, 30 Jan 2023 13:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFAFC4339E;
        Mon, 30 Jan 2023 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675085849;
        bh=xVUKXbUIi6xLEiIYm55wmvp+1ETe+NKrYKfL39iZqjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZWhdZxNByqgLSw9ZeTKMACA5jYn4ulj+8bWVDJshVzFGSC7BiIUszBGzEsXnrQBZN
         Y6mR3+pWmnNoRqLRkrZHQtJj9e/k4IryR/3jnJpRPLqP9UWarUAFRJ83gj7OeH0Nbf
         x+vu/g0l6yctoaZ/DAaPY/eJt8CD6euDYXXQyicQ=
Date:   Mon, 30 Jan 2023 14:37:26 +0100
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
Message-ID: <Y9fIFirNHNP06e1L@kroah.com>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com>
 <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:27:26PM +0000, Жандарович Никита Игоревич wrote:
> > What is the git commit id of this upstream?
> > 
> > And I can't apply this as-is for the obvious reason it would mess up the
> > changelog, how did you create this?
> > 
> > confused,
> > 
> > greg k-h
> 
> Commit in question is b671da33d1c5973f90f098ff66a91953691df582
> upstream. I wasn't certain it makes sense to backport the whole patch
> as only a small portion of it pertains to the fault at question.

What is the "fault"?

And why not take the whole thing?  What's wrong with that?  We almost
always want to take whatever is in Linus's tree because when we do not,
we almost always cause bugs or other problems (later merge issues.)

So always take the original fix please.

thanks,

greg k-h
