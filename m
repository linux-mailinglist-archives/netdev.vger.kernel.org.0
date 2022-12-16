Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33E564ECE3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 15:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiLPOdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 09:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiLPOdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 09:33:12 -0500
X-Greylist: delayed 76056 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Dec 2022 06:33:11 PST
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7619C566D0;
        Fri, 16 Dec 2022 06:33:11 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1671201189; bh=dm0GBBree+SzylXPIjAaBNY2/TXFZ6Txd1DUGNgA7kM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=arjRdpzmmwyuBBv92opnBlSC6VrJWXzN266Fc1S1FE5zJC5gntpkUE5y0CwDDOieo
         EGyz9oOBQTHDH9numOR3RSPNRWKixD2c9L+eZ0ApVbAbR3pBx+lgAJvh2qt+Ovu/WJ
         zfIJfl1wrCt5CQUpUvkfX+gwVQj80nUOA/RW/9t6y8ukCUYDzNqnZe6LtI84tNfWZz
         SEjangNkQEpYvp0BKO2UlvLHBh8yQWo1M1oRaAsxNjCzdTCFSoujOcI48f/Y10cPwk
         t6wqY7Sg1rhdnznF3543cKAWwFtO9rvCrHvb87LcN1Uu4SO+4NVO3n6X8mcLRV+NYK
         NzKfu/uyh4BfA==
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: use proper statements in conditionals
In-Reply-To: <486f9bc9-408f-4c29-b675-cbd61673f58c@app.fastmail.com>
References: <20221215165553.1950307-1-arnd@kernel.org>
 <87k02sd1uz.fsf@toke.dk>
 <486f9bc9-408f-4c29-b675-cbd61673f58c@app.fastmail.com>
Date:   Fri, 16 Dec 2022 15:33:07 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fsdfbeqk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Arnd Bergmann" <arnd@arndb.de> writes:

> On Thu, Dec 15, 2022, at 18:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> index 30f0765fb9fd..237f4ec2cffd 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>>> @@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(s=
truct sk_buff *skb)
>>>  }
>>>=20=20
>>>  #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>>> -#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? =
(expr) : 0)
>>> -#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
>>> -#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]+=
+)
>>> +#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_pr=
iv ? (expr) : 0); } while (0)
>>> +#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++)=
; } while (0)
>>> +#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stat=
s[q]++); } while (0)
>>
>> Hmm, is it really necessary to wrap these in do/while constructs? AFAICT
>> they're all simple statements already?
>
> It's generally safer to do the same thing on both side of the #ifdef.
>
> The "do { } while (0)" is an empty statement that is needed to fix
> the bug on the #else side. The expressions you have on the #ifdef
> side can be used as values, and wrapping them in do{}while(0)
> turns them into statements (without a value) as well, so fewer
> things can go wrong when you only test one side.

Alright, makes sense; thanks for explaining!

> I suppose the best solution would be to just use inline functions
> for all of them and get rid of the macros.

Let's merge this patch to fix the bug, and if someone wants to follow up
with a conversion to inline functions, that would be awesome, of course :)

-Toke
