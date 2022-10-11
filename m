Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121205FAE21
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJKINI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJKINH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:13:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D4A3EA49;
        Tue, 11 Oct 2022 01:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD73B80AAE;
        Tue, 11 Oct 2022 08:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46790C433C1;
        Tue, 11 Oct 2022 08:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665475982;
        bh=hdV/HagkJ26SOAJFvJzmaF51kGu9RxKTWkSj9OFXJ9o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BipUaM7W4M0iTTaKjf/MvpWknYY7hihA0mTYx0uxRN29Mp/M0UejN70x+4LkrhLXJ
         WQUxO/lGsuQo/76gHn00sLWGFuLu/rtVqVdR/7q0w2YaxYfswVpqDcGaDn35fapdCc
         qI821XfCJXBwFnBC/ITOR9oWR6J3enqSOEZ4Oh+M2SdRxte0MXHeQXXyH89XVXnb5J
         WQtykTZ9/dMOg/MQNmq/wefEGYBki3JTAorcRujJGa5p+FBO8oVSFUO2aPidwQ0cr1
         HLz53LFGilK3SEzRKmNIeSP0mFQvy+BqPSaimShSBPYpL2PPOQMUjKR40F3dX+4VoO
         7sQdaiWbLjD3A==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, ath11k@lists.infradead.org,
        regressions@lists.linux.dev, lkft-triage@lists.linaro.org
Subject: Re: drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning: 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size 0
References: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
        <87ilkrpqka.fsf@kernel.org>
        <158e9f4f-9929-4244-b040-78f2e54bc028@app.fastmail.com>
Date:   Tue, 11 Oct 2022 11:12:56 +0300
In-Reply-To: <158e9f4f-9929-4244-b040-78f2e54bc028@app.fastmail.com> (Arnd
        Bergmann's message of "Mon, 10 Oct 2022 19:52:09 +0200")
Message-ID: <87tu4aok1j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Arnd Bergmann" <arnd@arndb.de> writes:

> On Mon, Oct 10, 2022, at 6:54 PM, Kalle Valo wrote:
>> Naresh Kamboju <naresh.kamboju@linaro.org> writes:
>
>>>
>>> Build log: https://builds.tuxbuild.com/2F4W7nZHNx3T88RB0gaCZ9hBX6c/
>>
>> Thanks, I was able to reproduce it now and submitted a patch:
>>
>> https://patchwork.kernel.org/project/linux-wireless/patch/20221010160638.20152-1-kvalo@kernel.org/
>>
>> But it's strange that nobody else (myself included) didn't see this
>> earlier. Nor later for that matter, this is the only report I got about
>> this. Arnd, any ideas what could cause this only to happen on GCC 11?
>>
>> -- 
>> https://patchwork.kernel.org/project/linux-wireless/list/
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
> No idea here, though I have not tried to reproduce it. This looks
> like a false positive to me, which might be the result of some
> missed optimization in the compiler when building with certain
> options. I see in the .config that KASAN is enabled, and this sometimes
> causes odd behavior like this. If it does not happen without KASAN,
> maybe report it as a bug against the compiler.

You guessed correctly, disabling KASAN makes the warning go away. So no
point of reporting this to GCC, thanks for the help!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
