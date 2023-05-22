Return-Path: <netdev+bounces-4318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF3570C0B2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7188280FBA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB74B14272;
	Mon, 22 May 2023 14:09:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C133B13AEC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:09:19 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D28E;
	Mon, 22 May 2023 07:09:18 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f6077660c6so5274645e9.0;
        Mon, 22 May 2023 07:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684764557; x=1687356557;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WexhjTh9EgipPESTAcIjs8YMKr9plgty6KmA22728Fs=;
        b=VDb8SOZPw6Zet5F7yalYSYV9wdMDyhck+Db1K6DyCn8tQuiYEH+dC4Kdp5H8wLCI3c
         8X+b/oZTRESTmVQTUnzCNP6U4m7j0cPoPKS3RU/r/v6i093TPa5a9N74fUVR/GxkpxDf
         1R/FE3giFkmmxiaIPYoVg17UtL2sCbFjeiaGoMfOPoIFbEF0AhGvhtkyl34bq6TPX5Rk
         H7jrKxUtYm7NDE+dPNw9OvckuKBNEeVCl+ZYev1n2S4MH8BeCpEiopDy/UkG31idWrqm
         6dzH+c3NNcGB5cpJuXN1/BnJJYPaMYd5ocRBBm5HKnZI+QTw1X2jbY/zrOthHLWtCPJr
         iFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684764557; x=1687356557;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WexhjTh9EgipPESTAcIjs8YMKr9plgty6KmA22728Fs=;
        b=CkUm0pL/+Gj7dmLAT8tTsv5VerAZqA5zXlKCifC+6FEDQq71mkTmtSIzWJ4oYTx4jC
         WyYqcFDHRHgzzoSbR3IJNVnlNlqsy2DvFtGvafY8YznKNHd+zmWl5LpL1YcldmpZ6V6Q
         Fs5cHx/1iVvN/Z/togzRWpAgWg2SkOba9Y31zqBOdLEqrq4BqbsiAdI0Ybhc/S3R3i0z
         uE02FgiW6jTIDC6EtjUD0XxFYoUzfnCwD4zB0dOIkCLrbbg1suGY0f6Ja7itWdGnFr0I
         8veAoN3ccie6njSYCZkKTZd4xvb6Sew1nc5dXrrAePfN7qLSmGcbNmlXxRaRMFHLxA1C
         HVYQ==
X-Gm-Message-State: AC+VfDwObq5W4ZVWBZXwNbQsGut/h0xxRA3WjHRkcF9E0Q6fPk1XdHr5
	R+zArHr6q1rxMpBYOOChf98=
X-Google-Smtp-Source: ACHHUZ73Fy76JqxgxOq6PygIGGHMHrrwk/atOHcAPHzEai7lV3H36Khz2+J59mn/1eAm5zPigReK7w==
X-Received: by 2002:a1c:c903:0:b0:3eb:42fc:fb30 with SMTP id f3-20020a1cc903000000b003eb42fcfb30mr7876135wmb.32.1684764556512;
        Mon, 22 May 2023 07:09:16 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id s9-20020a1cf209000000b003f3e50eb606sm8483308wmc.13.2023.05.22.07.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 07:09:16 -0700 (PDT)
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32
 type values
To: Min-Hua Chen <minhuadotchen@gmail.com>, kuba@kernel.org
Cc: alexandre.torgue@foss.st.com, davem@davemloft.net, edumazet@google.com,
 joabreu@synopsys.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 mcoquelin.stm32@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
 peppe.cavallaro@st.com, simon.horman@corigine.com
References: <20230519152715.7d1c3a49@kernel.org>
 <20230520015527.215952-1-minhuadotchen@gmail.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <9e6b813a-bc1a-6a39-904d-5c45f983cd23@gmail.com>
Date: Mon, 22 May 2023 15:09:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230520015527.215952-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 20/05/2023 02:55, Min-Hua Chen wrote:
>> On Fri, 19 May 2023 19:50:28 +0800 Min-Hua Chen wrote:
>>> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
>>> +		if (p->des0 == cpu_to_le32(0xffffffff) &&
>>> +		    p->des1 == cpu_to_le32(0xffffffff))
>>
>> Can you try to fix the sparse tool instead? I believe it already
>> ignores such errors for the constant of 0, maybe it can be taught 
>> to ignore all "isomorphic" values?
>>
> 
> I downloaded the source code of sparse and I'm afraid that I cannot make
> 0xFFFFFFFF ignored easily. I've tried ~0 instead of 0xFFFFFF,
> but it did not work with current sparse.
> 
> 0 is a special case mentioned in [1].

I believe you can do something like
    if ((p->des0 == ~(__le32)0) && (p->des1 == ~(__le32)0))
 and sparse will accept that, because the cast is allowed under the
 special case.
HTH,
-ed

