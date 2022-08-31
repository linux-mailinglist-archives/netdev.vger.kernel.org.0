Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3455A8234
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiHaPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiHaPtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:49:52 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7DF1112
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:49:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so11938009wmk.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=5KSJENTLk4SwH6uBRAADUZRugnJgHy7M1ZUyZ80xvbU=;
        b=UuvidNMcW217OEM2ndpSB4/tsiQ56ipGh8h9mA4onZjlL6i4PFoZdBQ/aJpIsByrTs
         +QrldLkXXm6mnz4LUWAAS3r3txRooDJJkPqsTlaQBfCOJNeaogdeItc9ABS9X40KrAWH
         UgyZ5lgE2i7+CkT/157sZflhvstLd5yRpxRMNBiIsusISFBum9QYyf1jyhO8TQBzBtCk
         hEqQWLoCKQzAXmC1Za78zXxlc17K0yiFRc9GA0b6FDtpZBQKI50hYb6GpNTZud42mztJ
         zDUzFfhk7NaHanaGuoPvU3caDtPB/miUKIGJHM3qeaPOBqUXBzcWMWOmnIAhj8pmuuPi
         db0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5KSJENTLk4SwH6uBRAADUZRugnJgHy7M1ZUyZ80xvbU=;
        b=bXoiM8T125wyhV8BStI6ln6wP/Z/aP2W3mTSQYGvdkqFxDg7WydfhMjE25O0NmYCqw
         qKMToRV+AdRmlg/7kGp/S0SYBnkqTIDj8jbBwEF8OyCrxHG59Uizyl0V2ogD7EqzhpZn
         RIkkxD7iKpwtCyvOlsh9ifo1I9tmIRL+R4jqCSAe7a73gkSqpju5X1xOgMpJzm8nH9Xu
         cjsJHk5i+HDX4QAMMcYogqHzvDG2ZrWZmukqWBe0EcUlu+taXhpqKeuzdoGHj3PCAJXW
         3qq5be0hB0ns9T8+I1xx5KVSZ++MJDoXU9zeL+C/+R801JOg18GYGIjp50XfA0QUwsWL
         6Nuw==
X-Gm-Message-State: ACgBeo1Deucqtk82ZDnbvKZHGtq3DgV3cXw/3+FD+y0TG3pSvNS50jrC
        4B8RyhkYampBdGKQ2mbasno=
X-Google-Smtp-Source: AA6agR6DJiKx03ROlEasqlNDP9qULhfhsYMp0wtNUaapmbrtsMsZtsKGSghOEfhHGZufs2iV3kH1rA==
X-Received: by 2002:a05:600c:2256:b0:3a5:c27d:bfb2 with SMTP id a22-20020a05600c225600b003a5c27dbfb2mr2378008wmm.102.1661960986933;
        Wed, 31 Aug 2022 08:49:46 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id ay19-20020a05600c1e1300b003a682354f63sm2880078wmb.11.2022.08.31.08.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 08:49:46 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] sfc: support PTP over IPv6/UDP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, richardcochran@gmail.com
References: <20220825090242.12848-1-ihuguet@redhat.com>
 <20220831101631.13585-1-ihuguet@redhat.com>
 <20220831101631.13585-3-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cba0d678-259b-7802-85c1-0cb15dcbb63f@gmail.com>
Date:   Wed, 31 Aug 2022 16:49:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220831101631.13585-3-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 11:16, Íñigo Huguet wrote:
> commit bd4a2697e5e2 ("sfc: use hardware tx timestamps for more than
> PTP") added support for hardware timestamping on TX for cards of the
> 8000 series and newer, in an effort to provide support for other
> transports other than IPv4/UDP.
> 
> However, timestamping was still not working on RX for these other
> transports. This patch add support for PTP over IPv6/UDP.
> 
> Tested: sync as master and as slave is correct using ptp4l from linuxptp
> package, both with IPv4 and IPv6.
> 
> Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
<snip>> -	rc = efx_filter_insert_filter(efx, &rxfilter, true);
> +	int rc = efx_filter_insert_filter(efx, rxfilter, true);
>  	if (rc < 0)
>  		return rc;
> -
>  	ptp->rxfilters[ptp->rxfilters_count] = rc;
>  	ptp->rxfilters_count++;
> -
>  	return 0;
>  }

These whitespace changes seem like churn given that this code was
 added in patch #1.  If respinning maybe make the two consistent?

-ed
