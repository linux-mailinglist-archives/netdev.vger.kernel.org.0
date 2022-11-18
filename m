Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC371630029
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKRWe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKRWeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:34:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C4788FB5;
        Fri, 18 Nov 2022 14:34:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005B9B81F4F;
        Fri, 18 Nov 2022 22:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0AFC433D6;
        Fri, 18 Nov 2022 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668810861;
        bh=akSlpHkxuHMmNNIBeOEp7Zb57LHGrS2/uHHPtnfozMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UPSFy/4L1Nj8b4ahyj/NatcSZwKUmkn566AgEbL/ZkVCztYl0d9nn8J6m/hNJgkHa
         Uoc3FUoBC9sOH+VBZfLhDztm7cvA4HM3XCTwDzhAIfU7Z2Tuc9Pk0NuFhtoyv89V9N
         lNpV+BDqpbcv0UPr2DTq5uaReNG/ny5JLIGCKoh7zjxyKd/+MBvwehCwJdqUKpyokB
         rXmgPQQRgLQbjz9zpKgRckzoAWBWC97/bq6wS07pdZwROYyWwpO1DfzW4ZzS0+vld1
         QZ3xCPBng0BVpdZQEOUpn3gpXcy9HBZOq6JNt+nZoXMgK52qNpeMznm8uiY1G/jWDk
         1Ed334esEXX2A==
Date:   Fri, 18 Nov 2022 16:34:08 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] carl9170: Replace zero-length array of trailing structs
 with flex-array
Message-ID: <Y3gIYJqT+U/ftlD4@work>
References: <20221118211146.never.395-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118211146.never.395-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 01:11:47PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member.
> 
> This results in no differences in binary output.
> 
> [1] https://github.com/KSPP/linux/issues/78
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Another sneaky one. :p

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/net/wireless/ath/carl9170/fwcmd.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
> index 4a500095555c..ff4b3b50250c 100644
> --- a/drivers/net/wireless/ath/carl9170/fwcmd.h
> +++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
> @@ -118,10 +118,10 @@ struct carl9170_reg_list {
>  } __packed;
>  
>  struct carl9170_write_reg {
> -	struct {
> +	DECLARE_FLEX_ARRAY(struct {
>  		__le32		addr;
>  		__le32		val;
> -	} regs[0] __packed;
> +	} __packed, regs);
>  } __packed;
>  
>  struct carl9170_write_reg_byte {
> -- 
> 2.34.1
> 
