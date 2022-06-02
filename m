Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433FF53BCAE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiFBQoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236745AbiFBQod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:44:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0498C64E8
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0B96B81F5F
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 16:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F1C34114;
        Thu,  2 Jun 2022 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654188269;
        bh=7uMTd8ItIUK8Ms4Vnb/Q9G7G/iwZgEwoizfq0oPIpss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=os3NFmu9aIWvXY5g629ZaKvVv1QbtlTs0FEeC/qiFn7soKnkP1dPsndkHVEGLfs5G
         PZ97xkiWz0xxfg6qYgGdR9lk9fjkSnUqany+JYODGx2XjYXPiqYwXrqDjw+Y95WlRT
         5JRp5/bsjVwOCaTMNq94gLYY+sB/G5Z0n32miXtLi1MtP9m8mOkVuViLAq1wPjDr3i
         DoWZ/gdGG6qf7uRCjyhcm5HeUOfk4BeviXlUfdlXIc0GYJFI2NLwAyWTVaDOTr7kV6
         qBuPecHCIqOovBNHm8w9I8ov5eqFP/l08Yz5kFMbV275OxCxwqXYwPQ7r3D0cKVGlX
         ErS2c7f6MDcCQ==
Date:   Thu, 2 Jun 2022 09:44:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220602094428.4464c58a@kernel.org>
In-Reply-To: <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
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

On Thu, 2 Jun 2022 12:13:53 +0300 Maxim Mikityanskiy wrote:
> I would expect to get a comment on my patch, instead of submitting your 
> own v2

I replied to v1 that the name is not okay. And you didn't go with my
suggestion. This is a trivial matter, faster for me to send my own
patch.

> and dropping my author and signed-off-by.

Sorry, you can add it now tho.

> On 2022-06-02 02:42, Jakub Kicinski wrote:
> > Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
> > sockets") used "key: value" format for the sendfile read-only
> > optimization. Move to a more appropriate "flag" display format.
> > Rename the flag to something based on the assumption it allows
> > the kernel to make.  
> 
> The kernel feature is exposed to the userspace as "zerocopy sendfile", 
> see the constants for setsockopt and sock_diag.
> ss should just print  whatever is exposed via sock_diag as is. IMO,
> inventing new names for it would cause confusion. Calling the feature
> by the same name everywhere looks clearer to me.

Sure, there discrepancy is a little annoying. Do you want to send 
the kernel rename patch, or should I?

> > the term "zero-copy"
> > is particularly confusing in TLS where we call decrypt/encrypt
> > directly from user space a zero-copy as well.  
> 
> I don't think "zerocopy_sendfile" is confusing. There is no second 
> zerocopy sendfile, and the zero-copy you are talking about is neither 
> related to sendfile nor exposed to the userspace, as far as I see.

What is your thinking based on? I spent the last 8 months in meetings
about TLS and I had to explain over and over that TLS zero-copy is not
zero-copy. Granted that's the SW path that's to blame as it moves data
from one place to another and still calls that zero-copy. But the term
zero-copy is tainted for all of kernel TLS at this point.

Unless we report a matrix with the number of copies per syscall I'd
prefer to avoid calling random ones zero-copy again.

> What is confusing is calling a feature not by its name, but by one of 
> its implications, and picking a name that doesn't have any references 
> elsewhere.

The sockopt is a promise from the user space to the kernel that it will
not modify the data in the file. So I'd prefer to call it sendfile_ro. 
I have a similar (in spirit) optimization I'll send out for the Rx path
which saves the SW path from making a copy when the user knows that
there will be no TLS 1.3 padding. I want to call it expect_nopad or
such, not tls13_zc or tls13_onefewercopy or IDK what.

> I believe, we are going to have more and more zerocopy features in
> the kernel, and it's OK to distinguish them by "zerocopy TLS
> sendfile", "zerocopy AF_XDP", etc. This is why my feature isn't
> called just "zerocopy".
> 
>  > > I suggest mentioning the purpose of this optimization: a huge
>  > > performance boost of up to 2.4 times compared to non-zerocopy
>  > > device offload. See the performance numbers from my commit
>  > > message:  
> 
>  > That reads like and ad to me.  
> 
> My intention was to emphasize some positive points and give the
> readers understanding why they may want to enable this feature.
> "Zero-copy behavior" sounds neutral to me, and the following
> paragraphs describe the limitations only, so I wanted to add some
> positive phrasing like "improved performance" or "reduced CPU cycles
> spent on extra copies". "Transmitting data directly to the NIC
> without making an in-kernel copy" implies these points, but it's not
> explicit. If you think it's obvious enough for the target audience,
> I'm fine with the current version.

Everyone wants zero-copy, if that's what was being declared here
we should just default it to enabled and not bother.

Developers need to read the fine print first.

>  > Avoid "salesman speak", the term "zero-copy"  
> 
> In the documentation you wrote, "true zero-copy behavior" was an
> acceptable term, and the "ad" was the performance numbers. 

I don't understand why you care about the numbers. They will be
meaningless for other platforms (AMD), other versions of your NICs, and
under real application loads. It seems like a declaration of a
performance boost which can't be accurately delivered on. Do you really
want the users to call you and say "your numbers show 40% improvement
but we only see 20%"? I'm not dead-set on excluding the numbers, I just
can't recall ever seeing numbers for a particular NIC included in the
documentation for a feature or an API.

> However, in the context of this patch, you call "zerocopy" a
> "salesman speak". What is different in this context that "zerocopy"
> became an unwanted term?

I put that sentence in there because I thought you'd appreciate it.
I can remove it if it makes my opinion look inconsistent.
Trying to be nice always backfires for me, eh.
