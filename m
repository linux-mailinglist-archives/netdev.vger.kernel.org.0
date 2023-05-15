Return-Path: <netdev+bounces-2526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 739B8702599
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FAEC280FF0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB79C79D1;
	Mon, 15 May 2023 07:02:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09901FB1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:02:10 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B555112B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:02:08 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f4ad71b00eso33785945e9.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1684134127; x=1686726127;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zn3E0Ej00294lOMAnsiZlPFF+J3kiZ/gHrIyox7Ww5s=;
        b=CXG9njWEvhCtZRnAW5kl2lvZg9iUidY7xCI6xSmQfnzx2lVMY6OPpBe+D2sCiXxRxz
         iDwTUlDzs9umBML0beEqU6z361jP938Gs95QqtoE4/kH7sJa7jG2wmJkPoUBIbHJpP9I
         JlUA+UyDfNZWCGQ7hhqAETY4h8z7HvcgXgZwjWrca+QvwJcJdsLvaxW7LBOx3g/mEGM8
         YQmponLUHDleBLDFM8Co+z5t0+XINCJ3ySN39G6oCVAuwWX1FNV0NtQdx+bZHvOz5SvR
         4dSnfT9U8gfLQUvNBIDSmGPGxMfWfoT8YITHmXIuYhu03j2TpLrW/o44vGEz8t9a6LsN
         m2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684134127; x=1686726127;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zn3E0Ej00294lOMAnsiZlPFF+J3kiZ/gHrIyox7Ww5s=;
        b=YfBzw5IuCgmgGBYhpv/z7o9Wvb72n3WaKqgu3uDJhRg7Seh8Enn8XLLHpJmpjg/VLT
         RZyMVRN8r/9sCwXP8yO/3T32E6XLHhZHKgGXg4g0VXroj3lEEYUocVBuJpKObStPRSW/
         1vVf59bo8IZCq7xMm91zHqMWo6taYDzjhXU9ZOvaMjbooo695Lk4SxAEeeV4Bznr/vlY
         fSJ3jgSRPOALQmE3nxYDBC8bnbsOxUcJzrrEqLMw35GWpcXSIbWqi8JUfCzYh0tD9LEx
         1jJFdS8Cm9qneB5IyNpGC31O2qPjtSH1gLTEN5KaU2IWnFq3m8sg28EHdif1wmC4meq8
         DhsQ==
X-Gm-Message-State: AC+VfDwJMtabjVjmgKolMsFqhGXGoAkLdsxK3mjbc30BKEDA204pPMKj
	fxR4Fy3gwyrFXfhA+a9kVp/7a7JimnogLzYQThU=
X-Google-Smtp-Source: ACHHUZ7Kd9sX1CUmwG3t/k1XwSKnRLAOhIu8HhBl/sMsD1z7w/K9deWO2MqyKGgoB4dYeLa5+h/psg==
X-Received: by 2002:a7b:c7d4:0:b0:3f4:2d22:536a with SMTP id z20-20020a7bc7d4000000b003f42d22536amr12546510wmk.19.1684134127146;
        Mon, 15 May 2023 00:02:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:3125:d487:bd00:c138? ([2a01:e0a:b41:c160:3125:d487:bd00:c138])
        by smtp.gmail.com with ESMTPSA id k13-20020a7bc30d000000b003f4ebeaa970sm12050620wmj.25.2023.05.15.00.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 00:02:06 -0700 (PDT)
Message-ID: <61280687-03d3-eaf0-8fb8-8ae1e59ada9f@6wind.com>
Date: Mon, 15 May 2023 09:02:05 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <klassert@kernel.org>, netdev@vger.kernel.org
References: <20230511141946.22970-1-nicolas.dichtel@6wind.com>
Content-Language: en-US
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20230511141946.22970-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Le 11/05/2023 à 16:19, Nicolas Dichtel a écrit :
> With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
> protocol field of the flow structure, build by raw_sendmsg() /
> rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
> lookup when some policies are defined with a protocol in the selector.
> 
> For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
> specify the protocol. Just accept all values for IPPROTO_RAW socket.
> 
> For ipv4, the sin_port field of 'struct sockaddr_in' could not be used
> without breaking backward compatibility (the value of this field was never
> checked). Let's add a new kind of control message, so that the userland
> could specify which protocol is used.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
The patch has been marked 'Awaiting Upstream' in the patchwork. But, I targeted
the 'net' tree.
Should I target the 'ipsec' tree? Or am I missing something?


Regards,
Nicolas

