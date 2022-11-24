Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10A0637184
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKXEhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKXEho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:37:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5A4D123
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 20:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82BA61F43
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 04:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FDEC433C1;
        Thu, 24 Nov 2022 04:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669264660;
        bh=He4F5MyAkYZYcdyyz2rDdpJckw58TQUKYtp4/bfpxrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NG8+h+CbuMXtuaYstsg8WnVPPV8q50w2v71iRE9LdN0VDH/neHBXURYtCGV/RTtXA
         hHZ1RAlPU/n3XqY++g54RZBmiju4DHCeBW3MWxaTVukDWUcBmyITkfFt2KTgve24pP
         CgBNUUKJ659bbbDdM+quD1UNCXLR3UAilvEv6z8vW5eryBJCi0sTmmekDJCfdOXPT/
         3vRrblzKfaiqg8WEy1DN4ZNtQAkqIf329DN6EIGnaxpx5w2F/lQ6++Fsy9n5wbUYDI
         WTKppTTVNBS73A9OQ1K3vSRNAa8uaqFAysbIKF/ImsDoepE+0ZFXwViLb7sf+miDjm
         Ued5wnHuNLZeQ==
Date:   Wed, 23 Nov 2022 20:37:38 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [net 04/14] net/mlx5: cmdif, Print info on any firmware cmd
 failure to tracepoint
Message-ID: <Y371EtdhrDCb4o0C@x130.lan>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-5-saeed@kernel.org>
 <Y343E18Hoy24Jolg@boxer>
 <Y36xN31vRfajwzgb@x130.lan>
 <20221123175550.126c7180@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221123175550.126c7180@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Nov 17:55, Jakub Kicinski wrote:
>On Wed, 23 Nov 2022 15:48:07 -0800 Saeed Mahameed wrote:
>> >> While moving to new CMD API (quiet API), some pre-existing flows may call the new API
>> >> function that in case of error, returns the error instead of printing it as previously done.
>> >> For such flows we bring back the print but to tracepoint this time for sys admins to
>> >> have the ability to check for errors especially for commands using the new quiet API.
>> >
>> > WARNING: Possible unwrapped commit description (prefer a maximum 75 chars
>> > per line)
>>
>> we don't enforce this in netdev, especially when you want to share output,
>> etc ..
>
>Maciej is right, it's one of those things I don't have stamina to
>enforce. But you just gave me motivation, please start complying with
>the rules.
>
>> also for future reference in mlx5 we allow up to 95 chars per code line, we
>> got wide screens :P, so also please ignore these warnings.
>
>"We got wide screens"? Your inability to write concise code is
>certainly not a virtue. Don't be flippant about it :/
it was an innocent very commonly used joke, what are you talking about ???

Anyway, I don't appreciate or respect your tune! if you want me to respect
your rules, you got to give some respect to your drivers maintainers !!

We have certain coding style in mlx5 and we gonna stick to it.. it's been
the case for the past 8 years, i am not going to suddenly turn the wheel
and just start obeying like a monkey.

And please watch your language, we do write concise code, your inability to
understand it is not my problem, and i don't expect you to understand it..
How the code looks like and how we interact with our HW is our problem, of
course suggestions and contributions are always welcome, but please be nice
about it.

mlx5 is the largest netdev driver and i got more than 20 active contributors
who are very happy with it. Please show some respect to those who worked
their asses off for years before you even knew what netdev is.

thank you!

