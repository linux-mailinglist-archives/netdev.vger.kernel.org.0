Return-Path: <netdev+bounces-2178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1794700A44
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162051C2122A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F61E1EA6F;
	Fri, 12 May 2023 14:27:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0396EBE4E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:53 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B974A272D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:27:51 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-306281edf15so9419761f8f.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683901670; x=1686493670;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLjacI7bwNj7xlMfR2N58cEaNJ04ToI0rFi45A2nIuw=;
        b=ldqYoQLKSEmYXZs2hS9v3EXHrSajY5URQrMcWCren+yrIREZk5fWlLQJd2xg4/4us3
         zxvgHQ5HamBI/9ZJRbnfCO9og58hc3LWfQsRTtmfXpjIIUYrItojGWNpRVXZ2rxJHC8B
         2O7PePe31XOgI9RVplP8j9D8vK8ewtJ+RLQgzSuUsyyE8kkXXlZrPfyqw+RBLjhdeEEN
         9lFYOsMWa/dmQ5G9s0/R0GsEbLBgTzgUO7wiWWdSI83yx6jDJ5wIVg+kraiw7YDkAJmN
         ZeM+n3oiHNQhaCfRRulgSjcgo/8izCgVT5MOtCPDHUPyFy02fjcPLC7g/7JvIftTP2N2
         yJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683901670; x=1686493670;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLjacI7bwNj7xlMfR2N58cEaNJ04ToI0rFi45A2nIuw=;
        b=ClF5AKhsQw8MKHaQsimQ2to4EF+2Ea96/Oz/rLS/sc04hZONiWa8yi1NYXiBQIQBSi
         jrEVYBdQJ65X8w2Tbx9Mdcwwi7tOpDmeP67QcceCrD7kfZTEY3kvxCY3pAbYD3w47Nhz
         9ynNKqmxExsb3IjQWWYbS1yVdtOVTd7JYYSeQf+MQ+88W7AUMu8ZKVtt3faO2Ige99VG
         uoE9JMYx0hHJ5SEvKlCGklwvGmjXeLjsb8Aw8CBw3Fqa+DdViqeadcC2G6K6OB0YMjZA
         66iCfBTDmqP9TYGT4wqh9WeeQJYmsB9Si3YDrMTb0PyCOL9l+4sS8PPzYL5T493lyGqL
         cyKQ==
X-Gm-Message-State: AC+VfDw13PNcppBOze5FNqfCajeHca+9dSyIfcygHEoGxDeq9fUG1UK0
	NnlnoKRaMTNtV3A0Nnh6+tY=
X-Google-Smtp-Source: ACHHUZ6YuxS++XSioKQrJQZWDgE7UStsTk/8L+PGknuZaDQKjIpBIS47YZGQM0QfRyBCQ4iXCHpoUg==
X-Received: by 2002:adf:e351:0:b0:306:2eab:fb8c with SMTP id n17-20020adfe351000000b003062eabfb8cmr18331651wrj.42.1683901669968;
        Fri, 12 May 2023 07:27:49 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q18-20020a056000137200b003063176ef09sm23779851wrz.6.2023.05.12.07.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 07:27:48 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/4] sfc: support TC decap rules matching on
 enc_ip_tos
To: Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1683834261.git.ecree.xilinx@gmail.com>
 <acc9f66562f7a82b2b033bc3ee3470e580036b81.1683834261.git.ecree.xilinx@gmail.com>
 <ZF4MJaY8/3bC4G5e@corigine.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <03258f61-8ed5-d99a-3e9f-9e162f038691@gmail.com>
Date: Fri, 12 May 2023 15:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZF4MJaY8/3bC4G5e@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/05/2023 10:51, Simon Horman wrote:
> On Thu, May 11, 2023 at 08:47:30PM +0100, edward.cree@amd.com wrote:
>>  	if (old) {
>>  		/* don't need our new entry */
>>  		kfree(encap);
> 
> Hi Ed,
> 
> encap is freed here.
> 
...
>> +			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
>> +				NL_SET_ERR_MSG_FMT_MOD(extack,
>> +						       "%s encap match conflicts with existing pseudo(MASK) entry",
>> +						       encap->type ? "Pseudo" : "Direct");
> 
> But dereferenced here.
> 
...
>> +			NL_SET_ERR_MSG_FMT_MOD(extack,
>> +					       "%s encap match conflicts with existing pseudo(%d) entry",
>> +					       encap->type ? "Pseudo" : "Direct",
> 
> And here.

Good catch, thanks.  We should use em_type instead.
Dave already applied so I'll send a follow-up fix shortly.

