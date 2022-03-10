Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8BA4D444A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiCJKJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiCJKI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:08:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862A91C93C;
        Thu, 10 Mar 2022 02:07:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C9E2B8258D;
        Thu, 10 Mar 2022 10:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A2DC340F3;
        Thu, 10 Mar 2022 10:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646906873;
        bh=DAXaxPhIHmB2MF8XpLLIhDWnZYiL+Px39F37xpKSkgA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=e2gkrtlvGZxaRZ7LaGobNndXWLZbv48jZ6KFQEHajqwDhIoBY1Wj8DYgHjzbRRZLs
         qCzvxa5/5teYQnQmSNwOjIC/3tIQGtIWxJ3RFIcnZc4Y+RJn0kvDLAq2mHnPiM8qMA
         6s/afH0bF3XJNqCtnucZSZDOZR8grHZ5yVrOjbkchuC+5J2AaIqPffWiVUb6VNSYxu
         Rk0n4m3G9SOiyoHmEfQl9PqAG6pSU1WXcYT3SPGyPFLRFUN+6oUCnEm8B6PPXuVHZS
         d6BbrsCe604OvSj/mfLb6vjy3DnUNOUfVF/BRaZs5jhLt8NiD6tr9HATBikGX0yeMh
         oULJ4ZtLjDqmg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>,
        kernel test robot <lkp@intel.com>,
        ath10k <ath10k@lists.infradead.org>, kbuild-all@lists.01.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
        <202201110851.5qAxfQJj-lkp@intel.com>
        <CACTWRwtCjXbpxkixAyRrmK5gRjWW7fMv5==9j=YcsdN-mnYhJw@mail.gmail.com>
        <87y23is7cp.fsf@kernel.org>
        <CAD=FV=W-kJQwBPStsGpNu09dN+QHTEZOgb5sZwZYzWnn_Zhv4A@mail.gmail.com>
Date:   Thu, 10 Mar 2022 12:07:49 +0200
In-Reply-To: <CAD=FV=W-kJQwBPStsGpNu09dN+QHTEZOgb5sZwZYzWnn_Zhv4A@mail.gmail.com>
        (Doug Anderson's message of "Mon, 7 Mar 2022 16:50:05 -0800")
Message-ID: <87o82eqfwq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> On Fri, Jan 14, 2022 at 6:46 AM Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Abhishek Kumar <kuabhs@chromium.org> writes:
>>
>> > On this patch I have a kernel bot warning, which I intend to fix along
>> > with all the comments and discussion and push out V3. So, any
>> > comments/next steps are appreciated.
>>
>> Please wait my comments before sending v3, I think this is something
>> which is also needed in ath11k and I need to look at it in detail.
>
> I'm wondering if you have a timeframe for when you might post your
> comments. We've landed this patch locally in the Chrome OS kernel
> tree, but we are always also interested in it landing upstream. If you
> have ideas for a path forward that'd be keen!

You had a good comment on v1 so I replied to that one.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
