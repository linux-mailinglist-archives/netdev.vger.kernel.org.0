Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC10E4F2489
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 09:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiDEHWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 03:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiDEHVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 03:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E187BE0F;
        Tue,  5 Apr 2022 00:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F78A61659;
        Tue,  5 Apr 2022 07:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC7AC3410F;
        Tue,  5 Apr 2022 07:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649143026;
        bh=aYpALUpGIhvwoqvnAr4xyO9/+4aLJKCPdk1Wh7E09AM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tfRzrIN56Qr3iYvSUHEtst9hY32ltX5sTZ9kTMxaXTsA1vGqaqeFEGtcOiDQIrqlV
         ip9r9w86q85V9NjEjuWwQrXOTL64A5IIKG4jmn5wpwN9g/hUpNYAEe+EEf4Up6UHFu
         K53ogdeTAhl7Xqxt2xXZikV4IIHfoDa4NUJ27D+SwK2VE+Nziuuy/QLA1KFeXAObTs
         2p5rnmxd9Lsaxp3wRad0WhxWjIBKgefpXE7G26jyyegx73aWdfYUmT8PxayG8jFpge
         PFylYwENBPdbsEGvyQFYOPRmu7CXZS8oKiGGINX89LBukwpFcoKHUsm/PJ8dGpkNj8
         GiMgJQAtQIs7A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com> <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42> <878rslt975.fsf@tynnyri.adurom.net>
        <20220404232247.01cc6567@kernel.org>
        <20220404232930.05dd49cf@kernel.org>
Date:   Tue, 05 Apr 2022 10:16:58 +0300
In-Reply-To: <20220404232930.05dd49cf@kernel.org> (Jakub Kicinski's message of
        "Mon, 4 Apr 2022 23:29:30 -0700")
Message-ID: <878rskrod1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 4 Apr 2022 23:22:47 -0700 Jakub Kicinski wrote:
>> On Mon, 04 Apr 2022 13:49:18 +0300 Kalle Valo wrote:
>> > Dave&Jakub, once you guys open net-next will it be based on -rc1?  
>> 
>> Not normally. We usually let net feed net-next so it'd get -rc1 this
>> Thursday. But we should be able to fast-forward, let me confirm with
>> Dave.
>
> Wait, why is -rc1 magic? If you based the branch on whatever
> the merge-base of net-next and staging-next is, would that be
> an aberration?

Sure, that would technically work. But I just think it's cleaner to use
-rc1 (or later) as the baseline for an immutable branch. If the baseline
is an arbitrary commit somewhere within merge windows commits, it's more
work for everyone to verify the branch is suitable.

Also in general I would also prefer to base -next trees to -rc1 or newer
to make the bisect cleaner. The less we need to test kernels from the
merge window (ie. commits after the final release and before -rc1) the
better.

But this is just a small wish from me, I fully understand that it might
be too much changes to your process. Wanted to point out this anyway.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
