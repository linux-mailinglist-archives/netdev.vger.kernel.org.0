Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967D23F6D7A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 04:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhHYCpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 22:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbhHYCpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 22:45:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE7BC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 19:44:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j187so20018303pfg.4
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 19:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IFpAwSjFvRUpCCEgflLsEqCbO4jnDj91zb2+drlqQHY=;
        b=CRHRxzNNeLjjaYmy8LiBN60siMF08xXwdN/fHtKdWXu9q/wpOqr2lMGA3wS3gxlRDP
         4nobd+29V/TY34PayddSzKNNI+ygCGSkGGsEamK+Ds+gcFBz4omf3xpB5pjThJ/wiKZB
         JAmPNHM/LhkncS+VMglbF17MwErAhuAx/um9zLGpcEprSXACavxJB3HxUJf0jwDyOvwe
         V8DTf9jFh44xguhi+ZP8fEAWC7+j0dK/kAssVB5fukDxNFwZgESoHRt0jYrzlrF8hocR
         XKUf4vGkB5Lr0pObn5680MKbYEER0NEZQOrpR90MbR2/BjeyFqXIRt6Mr4Qjmk7P3rDD
         BsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFpAwSjFvRUpCCEgflLsEqCbO4jnDj91zb2+drlqQHY=;
        b=oima26P3XlWG9KSI4bB8+FQHADHam6HEswxwsajOXmX/raC2knpwmtrQsL/r36bmvl
         9iETjyPkeCYtF33exHcp/uc47L0ZNx4pbCmTO99gO+GaSkyb1idnI6SOp0h4LQxAPOiL
         IhneVGVVGFTQguwtHusQJAvfb7JTYuat4x05XDxgva065lxSQPRokXnMixuPOYRuyGQM
         O+fM8AdvAaqG+ZrOy/YMTP/DjtqWdaLLYm0hAQbArYmX1duqhrl6n150RHhv1HJdMpOX
         qiPUrCf+sc2eTI6AugSwkvkBIs826bbkoeGL/AtTU8VKwdhEgmhsv14Hvayut2Z3ptVT
         dnEA==
X-Gm-Message-State: AOAM530xz2U+7iNdT0ndTLToWlRuBW7TIoGDc9J4Gdj1AC/SoZ5nM9QX
        dLrtogOJEmqRBxUCv0emA48=
X-Google-Smtp-Source: ABdhPJyB3oV8U+DeTfPO5U5zwrYBp0opVEF+1OlVUZaQjzyUVYWvy9laee3ZBBYJg6zScDRmRCyWDg==
X-Received: by 2002:a63:215c:: with SMTP id s28mr39508962pgm.99.1629859467779;
        Tue, 24 Aug 2021 19:44:27 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m18sm3706158pjq.32.2021.08.24.19.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 19:44:27 -0700 (PDT)
Subject: Re: [PATCH net-next v2] tcp: enable mid stream window clamp
To:     Neil Spring <ntspring@fb.com>, davem@davemloft.net,
        edumazet@google.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com
References: <20210819195443.1191973-1-ntspring@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6070816e-f7d2-725a-ec10-9d85f15455a2@gmail.com>
Date:   Tue, 24 Aug 2021 19:44:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819195443.1191973-1-ntspring@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/21 12:54 PM, Neil Spring wrote:
> The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size of
> the advertised window to this value."  Window clamping is distributed across two
> variables, window_clamp ("Maximal window to advertise" in tcp.h) and rcv_ssthresh
> ("Current window clamp").
> 
> This patch updates the function where the window clamp is set to also reduce the current
> window clamp, rcv_sshthresh, if needed.  With this, setting the TCP_WINDOW_CLAMP option
> has the documented effect of limiting the window.
> 
> Signed-off-by: Neil Spring <ntspring@fb.com>
> ---
> v2: - fix email formatting
> 
> 
>  net/ipv4/tcp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index f931def6302e..2dc6212d5888 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3338,6 +3338,8 @@ int tcp_set_window_clamp(struct sock *sk, int val)
>  	} else {
>  		tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
>  			SOCK_MIN_RCVBUF / 2 : val;
> +		tp->rcv_ssthresh = min(tp->rcv_ssthresh,
> +				       tp->window_clamp);

This fits in a single line I think.
		tp->rcv_ssthresh = min(tp->rcv_ssthresh, tp->window_clamp);

>  	}
>  	return 0;
>  }
> 

Hi Neil

Can you provide a packetdrill test showing the what the new expected behavior is ?

It is not really clear why you need this.

Also if we are unable to increase tp->rcv_ssthresh, this means the following sequence
will not work as we would expect :

+0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [10000], 4) = 0
+0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [100000], 4) = 0


Thanks.
