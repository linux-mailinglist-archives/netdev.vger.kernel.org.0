Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232345BDE56
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiITHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 03:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiITHfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 03:35:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF555D11A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:35:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e16so2798332wrx.7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=Trazm0Wre0pbiyr1sRcBKBLBaybFnryfemUZ85cRBms=;
        b=ZCdHwZtwyxw3uZALkY/MdyoUqYl0HjDU0k1869OyJ2sqJJsWc6JsgZUCpvPdxBGx8u
         yZaeo5+6ASBURr1q5hQh3inFgKn5ZhPE25qGJ1IVB0zvTdMjzsbreHDL6JrkyPsdwyOK
         dU8RaVtYXyuXkm7SRgC4kfjMLMnFP04a9IgEP92p0TLMfJYcXM0BKvyCeXt1aS7WnXtu
         lvDt+zlRdkfKGp8pS6WBGT876vnc2wKDrjUD1ECvl1jY/wA0vIrpUx2aYHqtA866bd2o
         cFKV9sb/zkcIt88HPHCBr/hn3cZR8rJzCaHhxBKQfXoS3W++MkxZ+L+EtK9aU7DpWZ6N
         r0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Trazm0Wre0pbiyr1sRcBKBLBaybFnryfemUZ85cRBms=;
        b=EdJj6/5jwBJ02Dv2h82KcgHKj0r5sfR9/hP3C1fj50+9Vnpaz3vfgDAf80gGkfF1x8
         Y2AqN/Xj+Dz6GNBgGuzOIjC94I1mSQlVsLwboWzcQxbnD2x+GKnZytcmsBWZiMQYe6d7
         wsID8rmiNPG2R7T+fEMh4SzCTjoJJOpN0n5UjSO4AOQnmFC8YYBV/Ofl//2lG3UFk11q
         zb4kuUZ6KfO8OsDkBswC8MR7QROgcq1XMaNor1swx9DZiOa0D8zFWv9QEZjsBP+SI/1C
         0I/+5Gg6CHCsWyxOTZqELEMP8cKqSJsAIKTF58JhYkcg19ElWjlpE2B12nutTTBqU8Jo
         uuuw==
X-Gm-Message-State: ACrzQf278uN2VFI7/JwCknpcSUvvRLbpJgv9+1Ngq6j8MB4PbtER4HgC
        Gb3Wnholbd1zcbbgbsZ4GrBfRQ==
X-Google-Smtp-Source: AMsMyM4i38b7ICghzkfFt/gzg+eHqommvczgeJ/vWe0SzAn9OmsRgeEg6inA+/waOrVeY/aZ3B+uzA==
X-Received: by 2002:a5d:48c2:0:b0:228:6226:381a with SMTP id p2-20020a5d48c2000000b002286226381amr12642946wrs.366.1663659316993;
        Tue, 20 Sep 2022 00:35:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:ad91:24d8:d1d3:3b41? ([2a01:e0a:b41:c160:ad91:24d8:d1d3:3b41])
        by smtp.gmail.com with ESMTPSA id j18-20020adfe512000000b002253fd19a6asm975299wrm.18.2022.09.20.00.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 00:35:16 -0700 (PDT)
Message-ID: <16241f25-79a3-1eb3-9f82-46d736b09d68@6wind.com>
Date:   Tue, 20 Sep 2022 09:35:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
Content-Language: en-US
To:     Patrick Rohr <prohr@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>
References: <20220916234552.3388360-1-prohr@google.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220916234552.3388360-1-prohr@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 17/09/2022 à 01:45, Patrick Rohr a écrit :
> This change adds support for not enabling carrier during TUNSETIFF
> interface creation by specifying the IFF_NO_CARRIER flag.
> 
> Our tests make heavy use of tun interfaces. In some scenarios, the test
> process creates the interface but another process brings it up after the
> interface is discovered via netlink notification. In that case, it is
> not possible to create a tun/tap interface with carrier off without it
> racing against the bring up. Immediately setting carrier off via
> TUNSETCARRIER is still too late.
> 
> Since ifr_flags is only a short, the value for IFF_DETACH_QUEUE is
> reused for IFF_NO_CARRIER. IFF_DETACH_QUEUE has currently no meaning in
> TUNSETIFF.
> 
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej Żenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c           | 15 ++++++++++++---
>  include/uapi/linux/if_tun.h |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..502f56095650 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2709,6 +2709,12 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  	struct net_device *dev;
>  	int err;
>  
> +	/* Do not save the IFF_NO_CARRIER flag as it uses the same value as
> +	 * IFF_DETACH_QUEUE.
> +	 */
> +	bool no_carrier = ifr->ifr_flags & IFF_NO_CARRIER;
nit: please, declare all variables at the beginning and use reverse x-mas tree.
