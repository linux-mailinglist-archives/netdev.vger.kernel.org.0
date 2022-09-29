Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C505EF226
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiI2JfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235524AbiI2Jep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:34:45 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C426B148A34;
        Thu, 29 Sep 2022 02:33:47 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1odpvO-0004SL-5f; Thu, 29 Sep 2022 11:33:46 +0200
Message-ID: <d6202c8a-47c4-ed5a-45be-1434c73dcd89@leemhuis.info>
Date:   Thu, 29 Sep 2022 11:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: setns() affecting other threads in 5.10.132 and 6.0 #forregzbot
Content-Language: en-US, de-DE
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
 <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
 <YxYytPTFwYr7vBTo@localhost.localdomain>
 <6204a74ef41a4463a790962d0409d0bc@AcuMS.aculab.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <6204a74ef41a4463a790962d0409d0bc@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664444027;4312ca7c;
X-HE-SMSGID: 1odpvO-0004SL-5f
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 06.09.22 12:48, David Laight wrote:
> From: Alexey Dobriyan
>> Sent: 05 September 2022 18:33
>>>> -----Original Message-----
>>>> From: David Laight <David.Laight@ACULAB.COM>
>>>> Sent: 04 September 2022 15:05
>>>>
>>>> Sometime after 5.10.105 (5.10.132 and 6.0) there is a change that
>>>> makes setns(open("/proc/1/ns/net")) in the main process changes
>>>> the behaviour of other process threads.
>>
>> Not again...
> 
> I've realised what is going on.
> It really isn't obvious at all.
> Quite possibly the last change did fix it - even though
> it broke our code.

In that case this seems to be appropriate, unless I misunderstood things:

#regzbot invalid: apparently not a regression

> /proc/net is a symlink to /proc/self/net.
> But that isn't what the code wants to open.
> What it needs is /proc/self/task/self/net.
> But there isn't a 'self' in /proc/self/task.
> Which makes it all a bit tedious (especially without gettid() in glibc).
> (This is a busybox/buildroot system, maybe I could add it!)
> 
> I'd probably have noticed earlier if the /proc/net
> symlink didn't exist.
> I guess that is for compatibility with pre-netns kernels.
> 
> 	David

