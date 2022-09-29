Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6585EEAC9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiI2BPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiI2BPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DEE17586
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08F6061787
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30600C433D6;
        Thu, 29 Sep 2022 01:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664414105;
        bh=xEouCU4tMbXzuAYIYQFgY1b4c71BsMcFAMZN6c+Z6TE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sZlrYUOxZN5pIwxfwFT52SIpNYULi28s288oCZkQcn3VjIkssTZ/gTd/bUE2JCD5j
         rAuih92kqYY/Cx8C192ZzcjKQXBcIA/ffUJ1YZwKy5swvh8B5gr9kyHcpEKcwG14NN
         Jf1OCgc7Kco2Eb2L733TLsJfTwvzTJ6fOalytuYXOoaTwL4/EYV41CpM9k+EgmBsmy
         YgJ3hIXl36JpNF1yfhsIJZ3togxHg0tiViiPM+j59yeXfROkOA58YSy6ipuImEPblE
         6s/G6c9spf/vYsIW2ZZM5+1+1FCrYC2YRWIjEyUYHIo4F+h4JiEnisNcqM4340yiCA
         T8nR0bwV3YqNg==
Date:   Wed, 28 Sep 2022 18:15:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
Message-ID: <20220928181504.234644e3@kernel.org>
In-Reply-To: <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
        <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
        <20220928104426.1edd2fa2@kernel.org>
        <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
        <20220928113253.1823c7e1@kernel.org>
        <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
        <20220928120754.5671c0d7@kernel.org>
        <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
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

On Wed, 28 Sep 2022 22:14:37 +0100 Edward Cree wrote:
> On 28/09/2022 20:07, Jakub Kicinski wrote:
> > Let's solve practical problems first :) The cases with multiple devices
> > offloading are rare AFAIK.  
> 
> I know of someone who is working on such a use-case for the Alveo U25N
>  and running into Interesting difficulties with the same rule getting
>  offloaded twice; they probably would care about getting both devices'
>  error messages.  I know the plural of anecdote is not data; but I
>  think it's not so rare that we can completely ignore it.

Hm. I wonder if throwing a tracepoint into the extack setting
machinery would be a reasonable stop gap for debugging.
