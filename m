Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9494FAC72
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 08:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiDJGuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 02:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiDJGuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 02:50:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC3718B36
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 23:47:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w4so18514227wrg.12
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 23:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IDWGwTCEfiChCWcpWeZf0pr+lGFB+CzIdzXpyjwDMY8=;
        b=abeXu3qaf2VF84LM1vg32P2ynG7GBF8CtVbqxphgxfCfjQpA4ujENl52TEtsu4s7YO
         zAs8ucKueJ1HvU68+/er73Xrvr3o2XispEh9y1uJjYLCpXzPQ9qUb7dOyK0ddNrAQFEl
         c7zthAOzCVVdsojC+x29TV4sBqUAW7lSTSZ0TGudpGAHrdPrWrvXnl1Qk28J2YUu/gz7
         98jdZusnJ+FW0gOdzxG1T0jZuVQ+Du5KoBNGQAQa2GFDwUwXH82WGaC9XhP4tFkmcURT
         0dpGKo30cs5GkuwOpUMQLYa7a+b2TPf/yG4vNPjNChhSV2UjXgkd2RXcRUxJRA9/iXCU
         dEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IDWGwTCEfiChCWcpWeZf0pr+lGFB+CzIdzXpyjwDMY8=;
        b=Qm+/ld0V3qlb3HOYgPyLWvwGRN3wqU7M7vEUKIBf6wPOVcizly6XApDRcIYdCNzEmg
         zMs/kgGvs7Cozd8tF06/0fnun5XuPPmTOES5QkXOJ+1nKRWFqJWflEIWxEG9iTYjs2Zb
         8MyNKzmazoWZyEXSCsyF147ZbYuMnLY2knCrXMHxCbmFxoJaibkM/GqBhdg6nyHc7gei
         gjD/WO25Sc/Uvm9vdSVj9DTL8+FWuDWUaspdd6HhoY54GrnzCgjT4chPhxNaudva4ko+
         1jXBfo/yZg2WVjwr2hEV/9SXfzaThHBasiItSfvIeVNq9hMHA9OjhZcPl/DYnvF67j1Z
         2OLA==
X-Gm-Message-State: AOAM531WpsFGRLfRJEktsheu/NNW/+HQEiEa1iIA5qRbbi+Z2vwODa7p
        XzpFGglQxFchs3mgOhfo97k=
X-Google-Smtp-Source: ABdhPJy5QJUMYwnbntfGJz/c44HZt7sFeiMHKvj6CpyVOePN4vEJu3kVNB0Cnttb6QDzwN6W9FuxMg==
X-Received: by 2002:a5d:430c:0:b0:206:1c68:fd05 with SMTP id h12-20020a5d430c000000b002061c68fd05mr20347352wrq.364.1649573273042;
        Sat, 09 Apr 2022 23:47:53 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id f66-20020a1c3845000000b0038eb64a52b5sm1856811wma.43.2022.04.09.23.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 23:47:52 -0700 (PDT)
Date:   Sat, 9 Apr 2022 23:47:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/5] ptp: Request cycles for TX timestamp
Message-ID: <20220410064751.GB212299@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403175544.26556-3-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 07:55:41PM +0200, Gerhard Engleder wrote:
> The free running cycle counter of physical clocks called cycles shall be
> used for hardware timestamps to enable synchronisation.
> 
> Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> provide a TX timestamp based on cycles if cycles are supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  include/linux/skbuff.h |  3 +++
>  net/core/skbuff.c      |  2 ++
>  net/socket.c           | 11 ++++++++++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3a30cae8b0a5..aeb3ed4d6cf8 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -578,6 +578,9 @@ enum {
>  	/* device driver is going to provide hardware time stamp */
>  	SKBTX_IN_PROGRESS = 1 << 2,
>  
> +	/* generate hardware time stamp based on cycles if supported */
> +	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> +
>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,
>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 10bde7c6db44..c0f8f1341c3f 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4847,6 +4847,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
>  					     SKBTX_ANY_TSTAMP;
>  		skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
> +	} else {
> +		skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;

Why is this needed?

>  	}
>  
>  	if (hwtstamps)

Thanks,
Richard
