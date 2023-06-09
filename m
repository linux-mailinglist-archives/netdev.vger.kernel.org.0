Return-Path: <netdev+bounces-9695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957CA72A3FD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E57511C2106A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA67221090;
	Fri,  9 Jun 2023 20:01:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE54C408DB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:01:38 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277CF30EC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:01:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30ae5f2ac94so2090218f8f.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686340895; x=1688932895;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZITErX6VGRcRsjtWCtdpCct4qtPX2aPqYCU12aX+Dq8=;
        b=jAzorB4aN7FpscYjqUatFVmN2PmaxcipOrsd1cKco0FZHad532QKm3I/1HugwMtWyj
         kXgmgChyUCrZYH3RhMqesVy3FZTbuTSMuMFa0v1GI0JOH/nRu4/4X0OZ3zSin1KmPaQH
         gUpbcz7EU4spZFo1ZJJw5S8vSaf9F4ZKVsyhYEN3IiNra4KnZ5M0U3LRXSGenbvJWcsz
         iiAwyYw3dZ+H2iqEZYp7HMHXtIW2mt+LrTlcjlrHMBL5yIJgVkoYNjLQXdkhshl78mGK
         qPRo/+cAfAfFBx2cxFWsQ1ZbW2v/wmrcZPilw+mZoENR+y995i41u/UOjPu4dXG2sZ/h
         OkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686340895; x=1688932895;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZITErX6VGRcRsjtWCtdpCct4qtPX2aPqYCU12aX+Dq8=;
        b=J1Yt+NdoC8SsMaaPtcxa9ShRx3DGq/cvtR0MWqWVC1nm7OhUNQK4fJ63ND0Z5PdC05
         usHxafTuzIFNVPz31q6Jkv+XLXO65Y8xGywGTTUx13ZHacFIGT+aE0VWlT7/t80Vfutx
         Wb6VnYnR4ew7GBdsMH2TuEcySXYaJ2J/pydDhRES+Zfvr80AWC1ImCwmV67i1s34J3bi
         ZN8+IcbFyohv4yodjUDbNGGXMOkg2WSxfNOs3DpbtWRYTiYtJ+NcEfAsZ0LErzGDfrhV
         Hgj9RgC2syTvAsJPAvKzI6VFd4eweCwLInOleqdshwcMppyfTXa8MJpw2ZnYJQEZypdw
         dJeQ==
X-Gm-Message-State: AC+VfDwohynU9oIQ02kGpWFAzV7dAxhKOMtRJ3aPzInfE4H5ZEy3on8j
	8an3znf1ZVEca6Ap9B04uME=
X-Google-Smtp-Source: ACHHUZ5JpwvZHscKtTjejZE6pRlxbvr2aKK7+nM6MokNeeqzXSu0Y2D/sQqzwZU/9zhWaVruPWd1nQ==
X-Received: by 2002:a5d:6883:0:b0:30a:a715:66c8 with SMTP id h3-20020a5d6883000000b0030aa71566c8mr1942218wru.8.1686340895405;
        Fri, 09 Jun 2023 13:01:35 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id k20-20020a05600c0b5400b003f4266965fbsm3631077wmr.5.2023.06.09.13.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 13:01:34 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 3/7] net: ethtool: record custom RSS
 contexts in the IDR
To: Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
 sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <5ac2860f8936b95cf873b6dcfd624c530a83ff2d.1681236653.git.ecree.xilinx@gmail.com>
 <20230412184927.63800565@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bf7ba840-e876-eecb-8772-faa6aed6e7c7@gmail.com>
Date: Fri, 9 Jun 2023 21:01:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230412184927.63800565@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/04/2023 02:49, Jakub Kicinski wrote:
> On Tue, 11 Apr 2023 19:26:11 +0100 edward.cree@amd.com wrote:
>>  	if (rxfh.rss_context)
>>  		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
>>  					    &rxfh.rss_context, delete);
>> @@ -1350,6 +1377,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
>>  		else if (rxfh.indir_size != ETH_RXFH_INDIR_NO_CHANGE)
>>  			dev->priv_flags |= IFF_RXFH_CONFIGURED;
>>  	}
> 
> This is probably transient but I think we're potentially leaking @ctx
> in a goto out hiding inside the context here, and...
> 
>> +	/* Update rss_ctx tracking */
>> +	if (create) {
>> +		/* Ideally this should happen before calling the driver,
>> +		 * so that we can fail more cleanly; but we don't have the
>> +		 * context ID until the driver picks it, so we have to
>> +		 * wait until after.
>> +		 */
>> +		if (WARN_ON(idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context)))
>> +			/* context ID reused, our tracking is screwed */
>> +			goto out;
> 
> here.

Wasn't entirely transient.  Fixed for v3.

