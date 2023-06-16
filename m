Return-Path: <netdev+bounces-11533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 009BF7337EF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFF8D1C20443
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961601DCAE;
	Fri, 16 Jun 2023 18:13:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819ED19E69
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:13:24 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D640F35AB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:13:22 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51a3e7a9127so1487551a12.1
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686939201; x=1689531201;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Yo1Z9K8UtO5Dfd1hdZDib6j7KoTr5Fzn/88kTii7DY=;
        b=qOVpXLdfES13PU1m2ec2bqE5Pp1214f754JeRRzgSyptsTK87zHtH5EGEeQjRiLTPB
         7SM26tHVkk9Pq3UeWVnn7A9CDkweqfoc/Z7+BqlBdgU6fbkWBDrjbg0I40jyw5qoQlms
         pYXkNmQWPFqqm0kIuig1GUN1He+Jmh4hSoNmbh7qGFNAx8HvdujI3oLWJuYaWSAXWnTT
         Z9nKk5qlbHhSNwAH7ixvJoVC+yCsxyeT8f02EpFfB3KRbD/3X7rc1/zQH9A28cVUjUjs
         9+EEUSliy2SSKsTYHCA2D+ab33UFSHdtILgXkkpSXLBayvvb7CWfAvLM0HtzLxFVQ+IV
         1cpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686939201; x=1689531201;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Yo1Z9K8UtO5Dfd1hdZDib6j7KoTr5Fzn/88kTii7DY=;
        b=GAAPiEh7eD+yrhzwe8agCGNwKIGTUvKpV5kyovKp3ZObxHYS1h5tDlGHW3vMOUsn5V
         gdHkc5tg9C00u1m1Ccfg6PK+tRWDbuVF5a6G68tWY03zdxGVBBuBb2Sao1LlvigwLHzF
         uMVyhYIdvgq72cPHNIYVn8k8NWKs5ShyY8ajyTOLJOQHyVPBPtRF07Hm8v1tdFkA8kbu
         8iwKaFp2CeTq6009FwZbVLpIVf/gjtJ84mJa3isdKX8LMkwIingk87uVrdgQDFovk0lg
         pUNgGcmsm4yvQAt1o1ebZmSLYMMUTDoW/4ugwn6DCh1OBVZmHScyutFn9WjtNq9yifvg
         2x0g==
X-Gm-Message-State: AC+VfDxYpmXctzA+VLhu5ZGM7U293HKD1nuuJuNEo3qfdZBcasf+t+uF
	9UGxSZPXJ2OdCnPOPbEE40MKo5ZZMZL5hl+ZPq4=
X-Google-Smtp-Source: ACHHUZ7Dn2thHpZ13gMr5jo7QNC0P4OrFpB9OrqTZrWOZ7LuGp9ode6DLDwTeJciMc0IzBLOpfdlPg==
X-Received: by 2002:aa7:d64a:0:b0:50b:c456:a72a with SMTP id v10-20020aa7d64a000000b0050bc456a72amr2634682edr.19.1686939201299;
        Fri, 16 Jun 2023 11:13:21 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7c90d000000b0051879590e06sm462560edt.24.2023.06.16.11.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 11:13:20 -0700 (PDT)
Message-ID: <a52cd9f8-c6e5-ca7a-4117-d3d24e0c7577@linaro.org>
Date: Fri, 16 Jun 2023 20:13:19 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] nfc: fdp: Add MODULE_FIRMWARE macros
Content-Language: en-US
To: Juerg Haefliger <juerg.haefliger@canonical.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
 shangxiaojing@huawei.com
References: <20230616122218.1036256-1-juerg.haefliger@canonical.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230616122218.1036256-1-juerg.haefliger@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/06/2023 14:22, Juerg Haefliger wrote:
> The module loads firmware so add MODULE_FIRMWARE macros to provide that
> information via modinfo.
> 
> Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> ---
>  drivers/nfc/fdp/fdp.c | 3 +++


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


