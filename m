Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33036050B9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiJSTtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiJSTtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:49:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF832C127
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B086CE2347
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E679C433C1;
        Wed, 19 Oct 2022 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666208973;
        bh=exLKw0hKEVpdBkII1tHDabo/M3iHgKUZflm6l95WXQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s1SqlsNlJsrloPkfUOxoD/nZgiC/sEITVqDIgnUEF2dtun7dhA9sIki54hv+6OXvX
         eHBXwG2w9ApUuQSerkyxgxyLHCY6DAb2t+LtlfInNIWwk2DUKAn9yZtWdsxnXi095+
         Uj2JvD2c0horgTunv0FYQhfvvbzGfQewDXUKiZRGGgEzXqZmyqp5Zrcuu47dWjRC+g
         1IMXwM8jQ0ZTq3LoJxenjzsalO5KrbzBkYAxUK2ilxdITANRuSUQnTvJA5ItAiOXgt
         rUJ/ZXqVHCVeqqXnA4oZCkMCN1kz/sHAR9bgMBYhCy4v8ROQu2ZPbE8gCcQPc9xGdx
         ozIUw9zTHOd4A==
Date:   Wed, 19 Oct 2022 12:49:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 04/13] genetlink: load policy based on
 validation flags
Message-ID: <20221019124932.39200cd7@kernel.org>
In-Reply-To: <2bc3395a3aa8f3789990b58739daaaed85d99bc0.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-5-kuba@kernel.org>
        <4c0f8e0aa1ed0b84bf7074bd963fcaec96eff515.camel@sipsolutions.net>
        <20221019122039.7aff557c@kernel.org>
        <2bc3395a3aa8f3789990b58739daaaed85d99bc0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 21:33:43 +0200 Johannes Berg wrote:
> > Do you mean that we no longer populate op->maxattr / op->policy and
> > some op may be reading those? I don't see any family code looking at
> > info->op.policy / maxattr.
> > 
> > First thing genl_family_rcv_msg_attrs_parse() does is:
> > 
> > 	if (!ops->maxattr)
> > 		return NULL;
> > 
> > So whether we skip it or call it - no difference.
> >   
> 
> Oh. I missed that, ok, thanks for clearing that up!

I'll put this info in the commit message, as requested.
