Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122115E6049
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiIVK7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiIVK66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:58:58 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDEAD576E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:58:55 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1obJuv-0004Hy-WC; Thu, 22 Sep 2022 12:58:54 +0200
Message-ID: <fc761257-d8e2-8f3e-fd49-1584fe414c07@leemhuis.info>
Date:   Thu, 22 Sep 2022 12:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [REGRESSION] Re: [PATCH v2] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on` #forregzbot
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     regressions@lists.linux.dev
Cc:     netdev@vger.kernel.org
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <20220914145317.GA1868385@roeck-us.net>
 <f026b273-472a-8af9-c9be-c08be0f60d53@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <f026b273-472a-8af9-c9be-c08be0f60d53@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663844335;eb312354;
X-HE-SMSGID: 1obJuv-0004Hy-WC
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.09.22 20:59, Thorsten Leemhuis wrote:
> TWIMC: this mail is primarily send for documentation purposes and for
> regzbot, my Linux kernel regression tracking bot. These mails usually
> contain '#forregzbot' in the subject, to make them easy to spot and filter.
> 
> On 14.09.22 15:53, Guenter Roeck wrote:
>> On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
>>> Mutexes cannot be taken in a non-preemptible context,
>>> causing a panic in `fec_ptp_save_state()`. Replacing
>>> `ptp_clk_mutex` by `tmreg_lock` fixes this.
>>>
>>> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
>>> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
>>> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
>>> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
>>
>> For regzbot:
> 
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
> 
> #regzbot ^introduced b353b241f1eb9b626
> #regzbot title net: fec: backtrace: BUG: sleeping function called from
> invalid context at drivers/clk/imx/clk-pllv3.c
> #regzbot ignore-activity
> #regzbot monitor:
> https://lore.kernel.org/all/20220912073106.2544207-1-bence98@sch.bme.hu/
> #regzbot monitor:
> https://lore.kernel.org/all/20220912070143.98153-1-francesco.dolcini@toradex.com/

#regzbot fixed-by: 01b825f997ac28f
