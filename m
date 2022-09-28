Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D185EDD91
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiI1NRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbiI1NRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:17:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E284A0625
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 06:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664371069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8CHATsj+W21+19tV87eTnDiAyPk+14vnUWU7b9stwM=;
        b=gwKJXtex+qb+Gj6QPpnTHz6Emt1gsflJDSDS+nLFud79yPkxCCKVl2JoDbyHvK9JYM928I
        Vghkk+mwIC52uY2n4YT24TOGA9KMHXdCWhx9gduGznzuSE80aSudrYuHaUye3xo0WVq1Hk
        yfmDz6Vcp/ZwA42h0XhEGFOmqDH0u1Y=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-9ijaaoPmN_OEdbLnAHLEyA-1; Wed, 28 Sep 2022 09:17:48 -0400
X-MC-Unique: 9ijaaoPmN_OEdbLnAHLEyA-1
Received: by mail-qt1-f198.google.com with SMTP id e22-20020ac84b56000000b0035bb64ad562so8901813qts.17
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 06:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=O8CHATsj+W21+19tV87eTnDiAyPk+14vnUWU7b9stwM=;
        b=xcjUN7HxRl3SiIOms49BQFja8vz/0tIH/IAijVYvWeGz5tDrAfvfiw6GAMcyWslGz6
         9WmBekLiZL6kL2nVkOF/1ZZmOZk8HL57qPcWChx0OvrA+E3W9utMDJIaMSgF3GozPAUo
         iwBMEWsAf6JZCS9HznVWMe5ca3DV1li/ZnxC4sgt28kSMVCg3PkJfYxk5DxlLv6isIA6
         JZ/exhMhra8Jnh8Hi13ur4yFbITCBU+hBljgeH4sBZ4xpMEttqr/rdVe8AGgZtXR9Ouz
         E7+y86g76marRc1wtQdmjJ75vxAB4Vnv7UrTVEdhdIlEMNl1lR79DDsmeWmr99+VgO3e
         JViA==
X-Gm-Message-State: ACrzQf2YqDyQXbIyx7T+Bcx5bwUKhzSnTMfeOFesMfGWTjNlmmuHuzAT
        lGhYidZW49obRZp4/oI2yfJeoUboqbhdINyilv+lUo1R/4Os/A6zzRio3T0rykmuKLRrziwHLej
        p/8c3ol5+U+okxYtD
X-Received: by 2002:a05:622a:648:b0:35d:4b13:362d with SMTP id a8-20020a05622a064800b0035d4b13362dmr7498462qtb.283.1664371067783;
        Wed, 28 Sep 2022 06:17:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6rWOKRCql6jp+ThtkcUj/iVHpzkuOy1DcinAZ1erkLV+yzruSMLBErZUaZakiMOPlE9rUUDw==
X-Received: by 2002:a05:622a:648:b0:35d:4b13:362d with SMTP id a8-20020a05622a064800b0035d4b13362dmr7498435qtb.283.1664371067508;
        Wed, 28 Sep 2022 06:17:47 -0700 (PDT)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id fg12-20020a05622a580c00b0035d5374efccsm2015266qtb.16.2022.09.28.06.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 06:17:46 -0700 (PDT)
Message-ID: <b08b12ca-c729-c50b-9364-76d940bf80f3@redhat.com>
Date:   Wed, 28 Sep 2022 09:17:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net/tipc: Remove unused struct distr_queue_item
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, ying.xue@windriver.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
References: <20220928085636.71749-1-yuancan@huawei.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20220928085636.71749-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/22 04:56, Yuan Can wrote:
> After commit 09b5678c778f("tipc: remove dead code in tipc_net and relatives"),
> struct distr_queue_item is not used any more and can be removed as well.
>
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>   net/tipc/name_distr.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
> index 8267b751a526..190b49c5cbc3 100644
> --- a/net/tipc/name_distr.c
> +++ b/net/tipc/name_distr.c
> @@ -41,14 +41,6 @@
>   
>   int sysctl_tipc_named_timeout __read_mostly = 2000;
>   
> -struct distr_queue_item {
> -	struct distr_item i;
> -	u32 dtype;
> -	u32 node;
> -	unsigned long expires;
> -	struct list_head next;
> -};
> -
>   /**
>    * publ_to_item - add publication info to a publication message
>    * @p: publication info
Acked-by: Jon Maloy <jmaloy@redhat.com>

