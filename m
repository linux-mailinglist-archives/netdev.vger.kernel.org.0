Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E874D58CFA8
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiHHVam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbiHHVal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:30:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51271103A
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 14:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17C76B81059
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 21:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B724BC433D6;
        Mon,  8 Aug 2022 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659994237;
        bh=loaqGAQtscdD7pttz6hcD+sSY+1Yp2oCjycWZKscoo0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dkawPl6Xq71q2RyKlJ8JZ2YcIkpaLNb214sp4ErpnAOFzDKdc5bsnr5iKLKoXnCly
         nFYLiin+45Ogyq4dUyN0gIyk3mATwCjIgZUAMCYclvZndnarQzB7XVK1ENot0NjMha
         8TbUwJPZWAUIxCBQ+NqdG6AoWppKZGg4SUtHy/CrfkNdR/P4lOVF8eAoO5drLq888Y
         gPOGTVa2DqoWLe5xiPbgmFOEF+ngWCH7hyykFXfI4Fal/tsSTNORlOKBtKQJagCrdi
         8ZTSXFkXdl/QT1mPCxePB0YbnHHvvztZ87yrcfBgpT+TQzRss+7iMsCKBOZpiI/ku9
         iCUD2/+IvSuHQ==
Date:   Mon, 8 Aug 2022 14:30:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] tsnep: Fix tsnep_tx_unmap() error path
 usage
Message-ID: <20220808143036.2f22e809@kernel.org>
In-Reply-To: <44114097-15bc-77ff-51f5-bfc0b5e02b70@engleder-embedded.com>
References: <20220804183935.73763-1-gerhard@engleder-embedded.com>
        <20220804183935.73763-3-gerhard@engleder-embedded.com>
        <20220808122319.4164b5c6@kernel.org>
        <44114097-15bc-77ff-51f5-bfc0b5e02b70@engleder-embedded.com>
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

On Mon, 8 Aug 2022 21:30:02 +0200 Gerhard Engleder wrote:
> On 08.08.22 21:23, Jakub Kicinski wrote:
> > On Thu,  4 Aug 2022 20:39:35 +0200 Gerhard Engleder wrote:  
> >> If tsnep_tx_map() fails, then tsnep_tx_unmap() shall start at the write
> >> index like tsnep_tx_map(). This is different to the normal operation.
> >> Thus, add an additional parameter to tsnep_tx_unmap() to enable start at
> >> different positions for successful TX and failed TX.
> >>
> >> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>  
> > Is this correct:
> >
> > Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
> >
> > ?  
> Yes, that's correct. Sorry I forget to add it. Shall I add it and resend?

It's okay, I'll add it.
