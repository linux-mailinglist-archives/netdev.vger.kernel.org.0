Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537124C5610
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiBZNQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 08:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiBZNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 08:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABB911166;
        Sat, 26 Feb 2022 05:15:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D6B9B8074E;
        Sat, 26 Feb 2022 13:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BB7C340E8;
        Sat, 26 Feb 2022 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645881339;
        bh=uoWuQtBGh3SA2ol8YPcbLuIujWZ7Ewkv25Ryxbm2lvQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I224m5GxLSmJJWPByfKulokgaPWKHOt8GiWaxjO8Dj7BBOFzPFjUoX5fcJhdXG7eO
         vZWLDY+Itq8RQxCXki+ung0Jgg8Y/VqJhUcoOcbzLyQlwN4E9TVkPv3CUIz7NiOylo
         4BsXl+fu8woQC3M6e3qrfjT+VUPzd4A+XCv5Hr9xgOKkxIT6zbHcuOosQ3SFMZyh4H
         stdDgDtOvE8B6Zwj5pyzaGeKL5zXMpfc62Zg1aIUKQxL4D4IAb0ickaFtw37pQqvve
         BCaTgKZOTuaKSxZo36m/Xe5S7FkO5bxL0MpNGVhgfCt9T/sy4oZ7SjS2ahRRp/GPg9
         IPezdstL0DrqQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <871qzpucyi.fsf@kernel.org> <YhojjHGp4EfsTpnG@kroah.com>
Date:   Sat, 26 Feb 2022 15:15:33 +0200
In-Reply-To: <YhojjHGp4EfsTpnG@kroah.com> (Greg Kroah-Hartman's message of
        "Sat, 26 Feb 2022 13:56:44 +0100")
Message-ID: <87wnhhsr9m.fsf@kernel.org>
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

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Sat, Feb 26, 2022 at 12:41:41PM +0200, Kalle Valo wrote:
>> + jakub
>> 
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>> 
>> > The firmware and the PDS files (= antenna configurations) are now a part of
>> > the linux-firmware repository.
>> >
>> > All the issues have been fixed in staging tree. I think we are ready to get
>> > out from the staging tree for the kernel 5.18.
>> 
>> [...]
>> 
>> >  rename Documentation/devicetree/bindings/{staging =>
>> > }/net/wireless/silabs,wfx.yaml (98%)
>> 
>> I lost track, is this file acked by the DT maintainers now?
>> 
>> What I suggest is that we queue this for v5.19. After v5.18-rc1 is
>> released I could create an immutable branch containing this one commit.
>> Then I would merge the branch to wireless-next and Greg could merge it
>> to the staging tree, that way we would minimise the chance of conflicts
>> between trees.
>> 
>> Greg, what do you think? Would this work for you? IIRC we did the same
>> with wilc1000 back in 2020 and I recall it went without hiccups.
>
> That sounds great to me, let's plan on that happening after 5.18-rc1 is
> out.

Very good, we have a plan then. I marked the patch as deferred in
patchwork:

https://patchwork.kernel.org/project/linux-wireless/patch/20220226092142.10164-2-Jerome.Pouiller@silabs.com/

Jerome, feel free to remind me about this after v5.18-rc1 is released.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
