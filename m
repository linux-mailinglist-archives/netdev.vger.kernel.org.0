Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFB06D2132
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjCaNKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjCaNKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:10:42 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D553993FD;
        Fri, 31 Mar 2023 06:10:41 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1piEWd-0008Ow-TB; Fri, 31 Mar 2023 15:10:39 +0200
Message-ID: <a956b2d9-9f11-ff44-4d93-f3ccffc5f9ac@leemhuis.info>
Date:   Fri, 31 Mar 2023 15:10:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Potential regression/bug in net/mlx5 driver
Content-Language: en-US, de-DE
To:     Paul Moore <paul@paul-moore.com>, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        selinux@vger.kernel.org
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680268241;77d1c0c4;
X-HE-SMSGID: 1piEWd-0008Ow-TB
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 29.03.23 01:08, Paul Moore wrote:
> 
> Starting with the v6.3-rcX kernel releases I noticed that my
> InfiniBand devices were no longer present under /sys/class/infiniband,
> causing some of my automated testing to fail.  It took me a while to
> find the time to bisect the issue, but I eventually identified the
> problematic commit:
> 
>   commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
>   Author: Shay Drory <shayd@nvidia.com>
>   Date:   Wed Jun 29 11:38:21 2022 +0300
> 
>    net/mlx5: Enable management PF initialization
> 
>    Enable initialization of DPU Management PF, which is a new loopback PF
>    designed for communication with BMC.
>    For now Management PF doesn't support nor require most upper layer
>    protocols so avoid them.
> 
>    Signed-off-by: Shay Drory <shayd@nvidia.com>
>    Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
>    Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>    Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> I'm not a mlx5 driver expert so I can't really offer much in the way
> of a fix, but as a quick test I did remove the
> 'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
> everything seemed to work okay on my test system (or rather the tests
> ran without problem).
> 
> If you need any additional information, or would like me to test a
> patch, please let me know.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
#regzbot title net: mlx5: InfiniBand devices were no longer present
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

