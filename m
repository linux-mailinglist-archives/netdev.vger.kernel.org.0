Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841035AD719
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiIEQIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiIEQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:08:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E752DC8
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:08:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qh18so17959547ejb.7
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=kZb8LxjUs4rs339Qlfn0ll5dDkR7w7NWYerQVZOzhaU=;
        b=aCqukWNPuGPKkofCWg1pyVGGttBNpJVSEhKPxra+uW9rAodo5yPmYhYeWc9qJr7fsG
         A/kQRx0O1mbdukEyIevxJwW8pe2PsPjBzvu+ZW9vxPQFfkvOEn/wQUjwdcJ8KQiUR/an
         YC09okkXjZy9PxVULDUDa4s8SVE/0SVmwG7sGqRDFs8Jc1nFhMrzmG6+6Wo/mLv2ERDH
         oGNu7rZLeI9EaGuOVWv0gioploWsgl/StOp9kuMkw3EUoZadZ5xppo8MKyUDcDWcXnE2
         dLttjN9AcK0qHasxU81NoGI/LCPp8WOj778g+Y1WHJtfweFvwaVs+dd5pSsIStLxVXls
         oc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kZb8LxjUs4rs339Qlfn0ll5dDkR7w7NWYerQVZOzhaU=;
        b=NJFqBkpWmdDctXDwNEJp+3nDCjaiX5s1Ec8fMQ1vWr77jT4EDMek0YpgEiUjx011nc
         O4EqSlxOUuvnTWLvIJQ+06NEZGS8GYOiWS13URwq7CbGvIth5NiNHBws7OIzgL6DjzXY
         OoNUaqw0s1iG9IJetab2C41a9qrbwk+R/0zGCauLMZ7Uzinf9FvcI/xo6dVmn9P41kDd
         RUoUzoA83N2btHEW2chL6H8jVIpyjQJ2SdPpkSmCcY5XUc3Bdwwghu5FuB8eWq1uYM5M
         b1t3Le+AANeoZ3z6YtEvOwJOVcRIgsFJP4/t+W8EMgzwH6hPNwB5UFvYvs3RAGifulAq
         f7DQ==
X-Gm-Message-State: ACgBeo3evFXJXOYueJu5+/TA9Vw/NHBbLDtUV5H1xIo8CoY2yxeHzBIj
        Y+/3erqSMO+VqemNI57kE9LTMA2TsU0=
X-Google-Smtp-Source: AA6agR58YUfSiM7c3OD0eg/WbBJLuinBqHtqdhG+lY2SyTi9jeMn7MGk1hKOLp1FjHXxJwx1g5z5bA==
X-Received: by 2002:a17:907:2d86:b0:741:662f:f1f7 with SMTP id gt6-20020a1709072d8600b00741662ff1f7mr27942234ejc.34.1662394094883;
        Mon, 05 Sep 2022 09:08:14 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d20-20020a17090694d400b007417c5dbfeesm5226871ejy.70.2022.09.05.09.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 09:08:14 -0700 (PDT)
Subject: Re: [PATCH net-next v5 0/3] sfc: add support for PTP over IPv6 and
 802.3
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220831101631.13585-1-ihuguet@redhat.com>
 <20220905082323.11241-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <554e710c-4329-c650-6092-3315cd4864d2@gmail.com>
Date:   Mon, 5 Sep 2022 17:08:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220905082323.11241-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/09/2022 09:23, Íñigo Huguet wrote:
> Most recent cards (8000 series and newer) had enough hardware support
> for this, but it was not enabled in the driver. The transmission of PTP
> packets over these protocols was already added in commit bd4a2697e5e2
> ("sfc: use hardware tx timestamps for more than PTP"), but receiving
> them was already unsupported so synchronization didn't happen.
> 
> These patches add support for timestamping received packets over
> IPv6/UPD and IEEE802.3.
> 
> v2: fixed weird indentation in efx_ptp_init_filter
> v3: fixed bug caused by usage of htons in PTP_EVENT_PORT definition.
>     It was used in more places, where htons was used too, so using it
>     2 times leave it again in host order. I didn't detected it in my
>     tests because it only affected if timestamping through the MC, but
>     the model I used do it through the MAC. Detected by kernel test
>     robot <lkp@intel.com>
> v4: removed `inline` specifiers from 2 local functions
> v5: restored deleted comment with useful explanation about packets
>     reordering. Deleted useless whitespaces.
> 
> Íñigo Huguet (3):
>   sfc: allow more flexible way of adding filters for PTP
>   sfc: support PTP over IPv6/UDP
>   sfc: support PTP over Ethernet
> 
>  drivers/net/ethernet/sfc/filter.h |  22 +++++
>  drivers/net/ethernet/sfc/ptp.c    | 128 +++++++++++++++++++++---------
>  2 files changed, 111 insertions(+), 39 deletions(-)

For the series:
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

(and thanks for doing this work :)
-ed
