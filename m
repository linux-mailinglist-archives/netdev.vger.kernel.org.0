Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829595A7F31
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiHaNra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiHaNr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:47:29 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ADE6260
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:47:29 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 202so13555007pgc.8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=pdUOJ+AuSij07LL7ft2dDXBE7Pd0mloReedqS38/DO0=;
        b=EjnivyWMCf3dVHEGcgNuXS6FpSwOopWQuQBJihFDOCf0OPQLIqWi44LGxDjXbRMZDS
         ifZmTGCWZapH/GF6RT5/sETAXjux96aEiYoHfz0mm82BfN5+taUBbQm7pMnZk56+ljO8
         sZB+d1o+SNIZrkVkSTyyBY3poAAAtYm/203p/Sra6AddVdN5CW5uz7mdk7PCU3q3qtaC
         Yn1LTr08DdB5xXRjFaqic/vDWWlfJLTMe9JXkw9uqf6Dyhc5A6OmJs3TAx8+zlNkWsxZ
         8kZ32CFvbmiA3ve+fHdOdIhRKQ+VtYsNeaLQDYdj7I30ilvavcSRKB3KAmSAVbjb5gCs
         l3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pdUOJ+AuSij07LL7ft2dDXBE7Pd0mloReedqS38/DO0=;
        b=yNRdCSMbHPoFFUyL4rfNIo7f57OGI7i6Hfr5x39EWzOP+wn2vBkP0HNVkZ8UCkts2u
         EBWL6UGR8SS6yvSHHJ/tjr2NbgnN0tXjAiOlJKu3KnfnFjGZ2tqiDZZ7Uy1I65QlWcIC
         JX1O0sg7VN/3AmXb/i2fyMikbR9M+GLH9szB+w9ZHE0VEKhti2BuQaG2SxpPBtfKvafb
         X8h7IntXa+7EElMFs8aezW9YQh8TcdDNlqhEGm4hhT508iWS8dN2rQTqg3Gngk5lT5Bf
         yvuHNloLRETOPEcugk5Rtmnh2JyoRHdvL3QKA/MCZXpkbARsc5yZZ6o8EdmULCM3Mjjc
         szZw==
X-Gm-Message-State: ACgBeo0tjffUXY+e76KXpWu07mUgssbv8WxaJ7wL1mr0eEFtpRxT1ZBX
        Mi0HBJMLjqQ5h1tdfBEV98M=
X-Google-Smtp-Source: AA6agR7td4/4WuaEq+402hvdWxi3e+NR60XprfJ7P79MVyLuHIUPgI43tbsAU2kLaOHfFPFUnePaWA==
X-Received: by 2002:a62:640a:0:b0:536:1f9b:8ace with SMTP id y10-20020a62640a000000b005361f9b8acemr26370531pfb.23.1661953648640;
        Wed, 31 Aug 2022 06:47:28 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902e94e00b00172b8e60019sm7627524pll.249.2022.08.31.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:47:28 -0700 (PDT)
Date:   Wed, 31 Aug 2022 06:47:25 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <Yw9mbTrUYX7S8NQn@hoboy.vegasvil.org>
References: <20220825090242.12848-1-ihuguet@redhat.com>
 <20220831101631.13585-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831101631.13585-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 12:16:28PM +0200, Íñigo Huguet wrote:
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
> 
> Íñigo Huguet (3):
>   sfc: allow more flexible way of adding filters for PTP
>   sfc: support PTP over IPv6/UDP
>   sfc: support PTP over Ethernet
> 
>  drivers/net/ethernet/sfc/filter.h |  22 +++++
>  drivers/net/ethernet/sfc/ptp.c    | 131 ++++++++++++++++++++----------
>  2 files changed, 111 insertions(+), 42 deletions(-)

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
