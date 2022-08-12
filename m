Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6D591606
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiHLTk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHLTk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:40:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBD881B36
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 12:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06776617BE
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 19:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA7DC433D6;
        Fri, 12 Aug 2022 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660333224;
        bh=KQndtb7GZ8wzc0MGvcEWUA7KiZr8eJmcn79Z2DmEJsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erITtFfd9/5EsBNW7LayL5dzO03Z+f5e2aoXrk0rgr/AJP5+u2UjleOFtFDry6f8a
         9ynDgkDvwCxWEeAAxT+stVgOTq9j7yextDaI+X2ALcuNjhYCuesfWjpdfyuIOA4Guq
         ym4dTV7zkzTYRU4wf8T/t5oDlgwwBghypuNAnuemJic/lHfcElx7VXqdmQc4Nldw5s
         I4PhW1Mm+Ni/qtQ2Ttjj7EtS3Y6Q7dS+aQN3FF9M5bQLUqrkO/cIlso7gU3S2FrB4Q
         mIXt3BT5ac9T7sRSqjuyhMhxdCVTZIFRvVBuHkGxBrbh+DOh9ihSm8Lbz6c9RppFVh
         dsWvwddS4UW3w==
Date:   Fri, 12 Aug 2022 12:40:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        van fantasy <g1042620637@gmail.com>
Subject: Re: [PATCH net] l2tp: Serialize access to sk_user_data with sock
 lock
Message-ID: <20220812124023.470e5ccf@kernel.org>
In-Reply-To: <87edxlu6kd.fsf@cloudflare.com>
References: <20220810102848.282778-1-jakub@cloudflare.com>
        <20220811102310.3577136d@kernel.org>
        <87edxlu6kd.fsf@cloudflare.com>
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

On Fri, 12 Aug 2022 11:54:43 +0200 Jakub Sitnicki wrote:
> On Thu, Aug 11, 2022 at 10:23 AM -07, Jakub Kicinski wrote:
> > On Wed, 10 Aug 2022 12:28:48 +0200 Jakub Sitnicki wrote:  
> >> Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")  
> >
> > That tag immediately sets off red flags. Please find the commit where
> > to code originates, not where it was last moved.  
> 
> The code move happened in v2.6.35. There's no point in digging further, IMHO.

We can discuss a new "fixes-all-stable-trees" tag but until then let's
just stick to the existing rules.

As luck would have it in this case I think the tag is actually correct,
AFAICT the socket _was_ locked before the code move / refactoring?

> >> Reported-by: van fantasy <g1042620637@gmail.com>
> >> Tested-by: van fantasy <g1042620637@gmail.com>  
> >
> > Can we get real names? Otherwise let's just drop those tags.
> > I know that the legal name requirement is only for S-o-b tags,
> > technically, but it feels silly.  
> 
> I don't make the rules. There is already a precendent in the git log:

Ack, I'm aware, that's why I complained. If it's a single case meh, but
Haowei Yan seems to be quite prolific in finding bugs so switching to 
the real name is preferable.

Thanks!
