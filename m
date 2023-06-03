Return-Path: <netdev+bounces-7603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9919F720CCC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 03:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1984B1C21271
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 01:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B2B816;
	Sat,  3 Jun 2023 01:07:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70DB17D4
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 01:07:24 +0000 (UTC)
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A471B9
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:07:23 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-3980f932206so1804583b6e.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 18:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685754443; x=1688346443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rk7MwmJT/RKA/8bT+bq8NZnYWiepDXUZ2WOSbM/67Kc=;
        b=ADa1mYnLZvLryRogdbm5xyDYJs2pS+VRy56cK1FxOIKK+fBdvPkKqg8vexxL+PScO9
         QgYXX86s8PyQoOt0tPg2a9JvNESv/Gm0NnrbngpRSpWS3Ggn/Se4k6+WYvOGtppz9q8T
         CBw0Y1m2Kf/2NbCtO93ERx0/U2t9k20iN7LjT/fcQhiFRotb0wWznGHqPlPiy2yyiBsd
         CpgNepcR5OGfydVYh+pketrWFwCO3Xp4AHArCad7FyhNoRu2QW2h4mw3YSpAKZe79a2b
         8vuwiMYH7pkAqUzywPz8qFY+H8ArljV91J9MuL09DCpP6GxsIuKpYsVH172Dc39rY2T8
         iLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754443; x=1688346443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rk7MwmJT/RKA/8bT+bq8NZnYWiepDXUZ2WOSbM/67Kc=;
        b=NXxqnBo0dNcgeSxQ49gC3rxhFezkkYKxlN7eHZGbnWoZGD9bStXW2dSfUGWaVzgvOb
         qREBTHAE7d+O3EIFvn/im/+tbdYiZE3nlodXlSyZsDEPwXdK3syDmnhGMS+6fyuVED7Q
         eb6DTIhcMWbb6or8sLeCECDP1p//RN5Umt5+Q0mgSFUuEeEkdQ5R86h3uhrc13Xub5hC
         l7OMc8zykQsPCufMan9maBg19Ynac8MXZ8XsGH7RiA65dX+xuU/1JUZUvknEeo3UT7Gs
         2EEJ8whnzgPzMxkPjXDyVp3YrORXs56fnTDHUgm7B47/rhqJsyV2/juHDakmLf0oeC14
         r+Rw==
X-Gm-Message-State: AC+VfDx8MBwArDrH298J+YpwNw2JZ5rFq+4HSSKm3U+YQwlxJ7ibhLmX
	2F/sVnNP57hfQwrgFPKpM3rpjQ==
X-Google-Smtp-Source: ACHHUZ6Yvio28iRnqPnF69blx9B4/zfV/5T1FwL2B2HB6lmmwNJlkz1rTQ2cVgloksdkBkeYyNzpEg==
X-Received: by 2002:a05:6808:298:b0:398:41b4:5b2 with SMTP id z24-20020a056808029800b0039841b405b2mr1316618oic.23.1685754442897;
        Fri, 02 Jun 2023 18:07:22 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:643c:5e1a:4c7c:c5cd? ([2804:14d:5c5e:44fb:643c:5e1a:4c7c:c5cd])
        by smtp.gmail.com with ESMTPSA id s4-20020acadb04000000b003982a8a1e3fsm1151483oig.51.2023.06.02.18.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 18:07:22 -0700 (PDT)
Message-ID: <28802979-d237-1c9c-ad05-10aaa8f46b48@mojatatu.com>
Date: Fri, 2 Jun 2023 22:07:17 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE
Content-Language: en-US
To: Min-Hua Chen <minhuadotchen@gmail.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230602235210.91262-1-minhuadotchen@gmail.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230602235210.91262-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 02/06/2023 20:52, Min-Hua Chen wrote:
> This patch fixes the following sparse warning:
> 
> net/sched/sch_api.c:2305:1: sparse: warning: symbol 'tc_skip_wrapper' was not declared. Should it be static?
> 
> No functional change intended.
> 
> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>

LGTM,

Acked-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/sch_api.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 014209b1dd58..9ea51812b9cf 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -2302,7 +2302,9 @@ static struct pernet_operations psched_net_ops = {
>   	.exit = psched_net_exit,
>   };
>   
> +#if IS_ENABLED(CONFIG_RETPOLINE)
>   DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
> +#endif
>   
>   static int __init pktsched_init(void)
>   {


