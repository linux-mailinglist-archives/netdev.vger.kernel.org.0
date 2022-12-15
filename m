Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EAF64DFC0
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiLORfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLORfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:35:40 -0500
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Dec 2022 09:35:34 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA7A37213;
        Thu, 15 Dec 2022 09:35:34 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1671124565; bh=ywaJJZXUkkSmvUs71ktwaaz2k3Du019540IdT+fmclA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lFYnBSKUda8fTO3gAbCmR7Cm1KVjKu5VJNHbmHUExk5fwnG5SFVcP5G9bkGULjEBI
         E3qadxDVg2kCO0wVSoNsE6kN+6HdsoZIUM6Rvkm7+UzStBz5jS1FBMPF+udvS5E9Jj
         3nrqwJCflvVf6QKrhItD4DCr4hVAe/m5dgH6jJ5vGQ2aUldH4xj6smUmlgJHW5ki+L
         LNPTWxwTDBC1OLLWu02+yobpeOiUGM0IoeKYCY/UtiTDsR1xQVxLMNVrtaZZq1kHJ3
         pK2f5hikWoiiqeIv/2+nUplmo0z23CwM1jesRrGfABsXnjhOUssR/0ZPvw7hCZMgKY
         9s1cuzwq01yoA==
To:     Arnd Bergmann <arnd@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: use proper statements in conditionals
In-Reply-To: <20221215165553.1950307-1-arnd@kernel.org>
References: <20221215165553.1950307-1-arnd@kernel.org>
Date:   Thu, 15 Dec 2022 18:16:04 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k02sd1uz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> A previous cleanup patch accidentally broke some conditional
> expressions by replacing the safe "do {} while (0)" constructs
> with empty macros. gcc points this out when extra warnings
> are enabled:
>
> drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_complete':
> drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
>   251 |                         TX_STAT_INC(hif_dev, skb_failed);
>
> Make both sets of macros proper expressions again.
>
> Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 30f0765fb9fd..237f4ec2cffd 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>  }
>  
>  #ifdef CONFIG_ATH9K_HTC_DEBUGFS
> -#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
> -#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
> -#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
> +#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
> +#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
> +#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)

Hmm, is it really necessary to wrap these in do/while constructs? AFAICT
they're all simple statements already?

-Toke
