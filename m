Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995B86D7AF6
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbjDELQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237580AbjDELQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:16:48 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DEB55B6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 04:16:42 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pk17z-0004DI-K8; Wed, 05 Apr 2023 13:16:35 +0200
Message-ID: <04288ea7-a9d5-6a79-b0f7-fd2a714af8f5@leemhuis.info>
Date:   Wed, 5 Apr 2023 13:16:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US, de-DE
To:     =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680693402;0e69774e;
X-HE-SMSGID: 1pk17z-0004DI-K8
X-Spam-Status: No, score=-1.4 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.23 15:46, Ricardo Cañuelo wrote:
>
> On mar 07-02-2023 23:53:27, Rafał Miłecki wrote:
>> While bringing hardware up we should perform a full reset including the
>> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
>> specification says and what reference driver does.
>>
>> This seems to be critical for the BCM5358. Without this hardware doesn't
>> get initialized properly and doesn't seem to transmit or receive any
>> packets.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> KernelCI found this patch causes a regression in the
> bootrr.deferred-probe-empty test [1] on sun8i-h3-libretech-all-h3-cc
> [2], see the bisection report for more details [3]
> 
> Does it make sense to you?
> 
> Cheers,
> Ricardo
> 
> [1] https://github.com/kernelci/bootrr/blob/3ae9fd5dffc667fa96012892ea08532bc6877276/helpers/bootrr-generic-tests#L3
> [2] https://linux.kernelci.org/test/case/id/642a0f5c78c0feaf5d62f79c/
> [3] https://groups.io/g/kernelci-results/message/40156
> 
> #regzbot introduced: f6a95a24957a

Thx for telling regzbot about this. It seems something went wrong here,
the patch this thread about is f99e6d7c4ed3 (which contains a Fixes: tag
for f6a95a24957a); copy and paste mistake maybe, whatever.

Fixing this and while at it giving this a better title:

#regzbot introduced: f99e6d7c4ed3
#regzbot title: net: bgmac: bootrr.deferred-probe-empty test fails in
KernelCi on sun8i-h3-libretech-all-h3-cc
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

