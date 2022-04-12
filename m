Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C069C4FDE98
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244538AbiDLLyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350732AbiDLLxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A19F5D67F;
        Tue, 12 Apr 2022 03:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF75DB81CA4;
        Tue, 12 Apr 2022 10:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CB0C385A9;
        Tue, 12 Apr 2022 10:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649759822;
        bh=aW4x6amHzum00rDQPT0FUG+ggRroUKbynU3+mFAMVMs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qA+nHcZTf76+eD7wAm4dguMty2X7Md0r/KunP1VnoFC53/YPOSJyFrJRjRb1C6Os/
         i77YGzYijefmhXDTFLslXAKRS7T2NiScf7dO4p60+AswhP8uWewlnKa/Up6uG3pNq+
         dnOGUKfms80yp8RYw5UlMXDllY8DOMX7hUiEW6kESVrVdaJNe61vTUNQubYMBQ9H5+
         a9+jCxp3Pa7OqtWH+p8q87XlwbsgDcoN+RiYFKb/SeB4wqrph9EZl15pKyxMalpeND
         BaS9myYIVHQQfIzqcrUIWj3I1U3qRBz2Qi4XFNlbIRp3hOIYZkm+qEsoLy6gpgDpGV
         IYMdLHZ7etrSA==
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
Date:   Tue, 12 Apr 2022 13:36:52 +0300
In-Reply-To: <7aa0bbd0-5498-ba74-ad6d-6dacbade8a3d@leemhuis.info> (Thorsten
        Leemhuis's message of "Tue, 12 Apr 2022 11:55:13 +0200")
Message-ID: <87o816oaez.fsf@kernel.org>
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
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.

BTW, maybe you could add that boilerplace text after P.S. into the
signature (ie. under "-- " line)? That way your mails would more
readable and make it more clear that you didn't write the boilerplate
text specifically for this mail.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
