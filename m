Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6D5147AE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357967AbiD2LCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiD2LCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:02:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020CAB6443;
        Fri, 29 Apr 2022 03:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=kmc13/9QXKmxSe5KTNtIvDaUnhBa/LBzSHNpr/JlHjc=;
        t=1651229956; x=1652439556; b=MGtZqaTln8kneYOUmUxxOjG+sy20jct3Y/eWQcRcjBh3FiL
        QlwkhrNgiB6MmwZXhX3z5THBWW0cKvIFXUuDJc5z5+xkpiZM7QvFLMkqasks90X/AX5W1SFKwbSuV
        JXyUrzAqORX5+vGDjeFIwLdsB5pcQfwFKAcjMul5YDI3r2opzJ89z/RMVc2eT5woYXhiKD5gRaukU
        GtQbOvjNO/OAYmdfdzP4u8FluaG7pZa6+0g2s3fAa+ek72d7d3Yh/KuxR6BaHAFCYQuWRh4MHVW6V
        Pv2KwZAqluynPHkY8KR/Td/rUcdBgTzF63MLN/snXRi/2zgpPhgQe279zc2cOYxw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nkOL3-00GukB-L5;
        Fri, 29 Apr 2022 12:59:05 +0200
Message-ID: <b16d831f7f8601702297d92fc28f2ae9bb159016.camel@sipsolutions.net>
Subject: Re: [PATCH] [v2] plfxlc: fix le16_to_cpu warning for beacon_interval
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 29 Apr 2022 12:59:04 +0200
In-Reply-To: <CWLP265MB32172ACD5B2F2ECD0A512F0DE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB32172ACD5B2F2ECD0A512F0DE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-04-29 at 10:44 +0000, Srinivasan Raju wrote:
> Fix the following sparse warnings:
> 
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> ---
>  drivers/net/wireless/purelifi/plfxlc/chip.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
> index a5ec10b66ed5..79d187cf3715 100644
> --- a/drivers/net/wireless/purelifi/plfxlc/chip.c
> +++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
> @@ -29,11 +29,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
>                                u8 dtim_period, int type)
>  {
>         if (!interval ||
> -           (chip->beacon_set &&
> -            le16_to_cpu(chip->beacon_interval) == interval))
> +           (chip->beacon_set && chip->beacon_interval) == interval)
> 

I think you got the parentheses wrong.

johannes
