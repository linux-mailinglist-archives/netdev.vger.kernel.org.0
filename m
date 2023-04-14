Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867366E2BD2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDNVpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNVpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:45:04 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA00212E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:45:03 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-183f4efa98aso29690672fac.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681508703; x=1684100703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TV9fvev/jFW3W7mARdEbFkpSKXoMDibx4RgaJ5BFzRw=;
        b=ZvfRupAUYCEzUBD1mv57h5wcNosHVGHI8IYqp60eb4qYU2rR3bSTe5QuByyUO0EBLM
         83deD0ExwIJo325iUkRVBzRX/01jiJZQMyMK/frM9nPDqkMSWCzEO0Z07wM9d4Pkx0SW
         zzfMEFufBnHjWKD4YKgnp3nGNhG9sasl27wE2dHgaPZ3W9atbrnd+C72RTA5J7ThbXMk
         0kA8LuwUi/08hdWHoSbCLJ7cBy62a3q99w300L+txBfs40qwk/RkYYSmgSFbwTSZ8YPD
         sxQYdh/Q1rC7v1CI33WhXNnA8GR7NTSJXs0mkR3/jPVfoQgcDozBOvv/nCd6Eu4keAqI
         Jl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681508703; x=1684100703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TV9fvev/jFW3W7mARdEbFkpSKXoMDibx4RgaJ5BFzRw=;
        b=IlI3ouRWxl9g8dlIx/JfJWilLjzWBrMQs2/2hSuqgK4S5jgyvVPsLnblF1Ppiu8cXE
         tbpirnTU0T+va4pYRLmTKZMh57ig/IotDw+YtLtwMdU74mag21fi8kjY0bN+an7HDsAf
         z4sQO5ulNLBGBWqrfuBTthQ87WZtUySMyiF+R83EdD1qEWqa4Cd7Piye2gk5ikpCO+ZA
         GMzs7ueiq3sV59XSUsqQeOVtT38v0zSZxbcnukp7vujtt+Ad9bykjy5HBSKi0u69Jvf7
         /EkCMYSbyHDZMk41d6g7H1wog6YQRzdFzj5PJDKafe9g7yfRpa3lThe92e1MbBOEud4Y
         HHfQ==
X-Gm-Message-State: AAQBX9dZo789BShyIuq21lTzobws6nz6AN12DqdfwCRcrv4ma4jEZ+NE
        iZNA5dbG9MWdt0vSMkuNrQewI+ekO9+YTrqgBRU=
X-Google-Smtp-Source: AKy350bj6trqaloav73BMHW1aC8VKeEY01pOXPQyQLOf7eaaoLv8JmUasKN+7smC6tYYsCkfhzWAxg==
X-Received: by 2002:a05:6870:c687:b0:187:85b1:1258 with SMTP id cv7-20020a056870c68700b0018785b11258mr4253338oab.23.1681508702901;
        Fri, 14 Apr 2023 14:45:02 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710? ([2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710])
        by smtp.gmail.com with ESMTPSA id 3-20020a4a0003000000b0053b543b027bsm2077815ooh.42.2023.04.14.14.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 14:45:02 -0700 (PDT)
Message-ID: <54d9bd03-66b7-649f-ce72-84d08b833d50@mojatatu.com>
Date:   Fri, 14 Apr 2023 18:44:58 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net/sched: clear actions pointer in miss cookie
 init fail
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com, Palash Oswal <oswalpalash@gmail.com>
References: <20230414214317.227128-1-pctammela@mojatatu.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230414214317.227128-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2023 18:43, Pedro Tammela wrote:
> Palash reports a UAF when using a modified version of syzkaller[1].
> 
> When 'tcf_exts_miss_cookie_base_alloc()' fails in 'tcf_exts_init_ex()'
> a call to 'tcf_exts_destroy()' is made to free up the tcf_exts
> resources.
> In flower, a call to '__fl_put()' when 'tcf_exts_init_ex()' fails is made;
> Then calling 'tcf_exts_destroy()', which triggers an UAF since the
> already freed tcf_exts action pointer is lingering in the struct.
> 
> Before the offending patch, this was not an issue since there was no
> case where the tcf_exts action pointer could linger. Therefore, restore
> the old semantic by clearing the action pointer in case of a failure to
> initialize the miss_cookie.
> 
> [1] https://github.com/cmu-pasta/linux-kernel-enriched-corpus
> 
> Cc: paulb@nvidia.com
> Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> Reported-by: Palash Oswal <oswalpalash@gmail.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>   net/sched/cls_api.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2a6b6be0811b..84bad268e328 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3235,6 +3235,7 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
>   
>   err_miss_alloc:
>   	tcf_exts_destroy(exts);
> +	exts->actions = NULL;
>   	return err;
>   }
>   EXPORT_SYMBOL(tcf_exts_init_ex);


My bad, this should target 'net' instead of 'net-next'.
