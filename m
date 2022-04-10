Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3FB4FAC8D
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 09:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiDJHbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 03:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiDJHbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 03:31:44 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EECD63
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 00:29:34 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso10163359wme.5
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 00:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wPtIU4a7d0EFWOMD3JY0UNjfcbzjfjIxnYoIGPZ5/YA=;
        b=aDCBFtxJ1E54MbMA/Uvo2naHNfgwuD9Y19BNoA5Ytw5H/FNkK39ezZfrcfg7JF5GD/
         Eo7UvcxfaibauqqUv+8aTlXbGbtpNAf2BOTPH3l6iZpHmMsRMkbtv5NcEDNo/BLt8cc+
         ONF8cJBgstU8UmxzgDfgmsXaJRydTE3UNKiiYICXNRpkIUYrM5cDyEdiQ4Kf65Xtg+VA
         n/JAdF+jNfSfUYYYc/wtABJEHVfwMrjx9QT7cmtuW13qua7S38y2MnIvAFdwrXSN7WQv
         BsDl9dtjQp8swfxTcQ82+tLq16d7sdnczNiU93RrXY4tZLbrPWsl9NrwStgbmH3Teg6v
         c5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wPtIU4a7d0EFWOMD3JY0UNjfcbzjfjIxnYoIGPZ5/YA=;
        b=gvS6xzj1xPnh4N9EI6GdPGh6vydwYJRpz6UW5j+VFC76/kE7w+zikdo05NoGyNpxgY
         TLFL0RG66Pppc4WkiHKUL55HRVjpLtNao02Ia773wbWOMdYPRCDQt+TSRRGrFL88aHHR
         Zj95W/7Y9jugUiY/LaK/18MtyYx7ly3+faByWCRZlgqVvKqCG0+1ZdaL+HTr7y8tTfdE
         N7bDq6BxQmls79MybXAGABo1CPc/YzAmP4/q8wfr7/yqzPQzUwpYmpCMn+X12w13xfUT
         APuo45TcsoA793lr66cBFYwUzVMtb5IyNXINpoqi7ac9wiuKKBjzerZy9UxUFNrNKTZT
         bP9Q==
X-Gm-Message-State: AOAM531PSh9fo6FjxtAQtELvvCBAdyx1m7o31hp6nOSsBHHQqKGOtC2S
        xRrAl/lJNAfrXvFHkPay2AKwQ6SGhe0=
X-Google-Smtp-Source: ABdhPJxBX0nPNa3pAZ9WBfaOiHiJSM9vveMII/FKJtFcmeIJCaQnJG0CrBvtQ9p5iXPvnCxUXFqKVw==
X-Received: by 2002:a05:600c:3c9b:b0:38e:4c59:68b9 with SMTP id bg27-20020a05600c3c9b00b0038e4c5968b9mr23985510wmb.105.1649575772724;
        Sun, 10 Apr 2022 00:29:32 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id f66-20020a1c3845000000b0038eb64a52b5sm1930219wma.43.2022.04.10.00.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 00:29:32 -0700 (PDT)
Date:   Sun, 10 Apr 2022 00:29:30 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Message-ID: <20220410072930.GC212299@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403175544.26556-5-gerhard@engleder-embedded.com>
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

On Sun, Apr 03, 2022 at 07:55:43PM +0200, Gerhard Engleder wrote:

> @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	if (shhwtstamps &&
>  	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>  	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
> +		rcu_read_lock();
> +		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));

__sock_recv_timestamp() is hot path.

No need to call dev_get_by_napi_id() for the vast majority of cases
using plain old MAC time stamping.

Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).

Thanks,
Richard

> +		if (orig_dev) {
> +			if_index = orig_dev->ifindex;
> +			hwtstamp = netdev_get_tstamp(orig_dev, shhwtstamps,
> +						     sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC);
> +		} else {
> +			if_index = 0;
> +			hwtstamp = shhwtstamps->hwtstamp;
> +		}
> +		rcu_read_unlock();
> +
>  		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> -			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> +			hwtstamp = ptp_convert_timestamp(&hwtstamp,
>  							 sk->sk_bind_phc);
> -		else
> -			hwtstamp = shhwtstamps->hwtstamp;
>  
>  		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
>  			empty = 0;
>  
>  			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
>  			    !skb_is_err_queue(skb))
> -				put_ts_pktinfo(msg, skb);
> +				put_ts_pktinfo(msg, skb, if_index);
>  		}
>  	}
>  	if (!empty) {
> -- 
> 2.20.1
> 
