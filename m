Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836504FDE99
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345839AbiDLLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355056AbiDLLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69867B7DD;
        Tue, 12 Apr 2022 03:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C8D6189B;
        Tue, 12 Apr 2022 10:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF10C385A1;
        Tue, 12 Apr 2022 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649759639;
        bh=h/Lw9izRLusTDmD2KCubgYWO5EB0A5SrBYBfsF6EwZk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=b61UQ4X4zw6b2oqj7cqsksnVXuQh9qJJdTlX3mzgxfveyIxmCmtf8lGtk7t/KIU4/
         8KWpULW509FC+eUFEQvwEY9UlYa+9ykC2UgVDxngpNkJ+yrIuJWcpryAzpT3tRB3dH
         P2tiezjzuF2emFaeVhIRg1EHSBrhgn/EU+3v5s/IKYlo2y/66AEBvtoApANjBVn5qL
         qVU4HVdRH7pe49LUiABwacPBbDdo83V+4Xu5aW5tq8ZXgXRyGz+f8Ei9zi5mNC4LRl
         I2p9vq5G6dRG5UpuHGe+I2mbNqtIw9WJmAyRBFMrgkbEccPu+TCfoqnqYl38EG7hx4
         X9N3CA/7efcLg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Philippe Schenker <dev@pschenker.ch>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Deren Wu <deren.wu@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "regressions\@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
References: <20220412090415.17541-1-dev@pschenker.ch>
        <87y20aod5d.fsf@kernel.org>
        <7aa0bbd0-5498-ba74-ad6d-6dacbade8a3d@leemhuis.info>
Date:   Tue, 12 Apr 2022 13:33:52 +0300
In-Reply-To: <7aa0bbd0-5498-ba74-ad6d-6dacbade8a3d@leemhuis.info> (Thorsten
        Leemhuis's message of "Tue, 12 Apr 2022 11:55:13 +0200")
Message-ID: <87sfqioajz.fsf@kernel.org>
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

Thorsten Leemhuis <regressions@leemhuis.info> writes:

> On 12.04.22 11:37, Kalle Valo wrote:
>> Philippe Schenker <dev@pschenker.ch> writes:
>> 
>>> This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
>>>
>>> This commit introduces a regression on some systems where the kernel is
>>> crashing in different locations after a reboot was issued.
>>>
>>> This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest firmware.
>>>
>>> Link:
>>> https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/
>>> Signed-off-by: Philippe Schenker <dev@pschenker.ch>
>> 
>> Can I take this to wireless tree? Felix, ack?
>> 
>> I'll also add:
>> 
>> Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
>
> Sorry, stupid questions from the regression tracker: wouldn't this cause
> a regression for users of kernel versions post-bf3747ae2e25, as the
> power consumption is likely to increase for them? Without having dug
> into the backstory much: would disabling ASPM for this particular
> machine using a quirk be the better approach? Or are we assuming a lot
> of machines are affected?

Kernel crashing is far more serious than increased power consumption. If
there's a better fix available in the next day or two of course that can
be considered. But if there's no such fix available, we have to revert
the commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
