Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D8B6D5EFE
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjDDLau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjDDLas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:30:48 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872BF1FEF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:30:46 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n19so18810136wms.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 04:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680607845;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmeovZ9mSN4MDfTKbY7u/EycY/cDvMXCAzBFKvOV/P8=;
        b=kNMUXSaD7sQrlzMNB23v+fFq7e1WejMmCiYgUHfWHMQU5u6nZmFYqIW1s1fV7FPxNv
         zMHwqDuJ5yruhXaZ9+dCADb2a17W40GzLAokSwLd26E3hgvgGl4epGvWJDmDmFbgo9Kd
         A5S3u2rRboOrC4HqmKLM12LxgLBgPY2o2WDSVHdVxpAqXYbgEBF/GKE7MI9EYbEP4HFO
         Wjfq4CW/IVCwA94lwaueK9MKnF1RmwZqWlMndvwna8tJSTXnu2LI+37ll0w2YQrFUgft
         dBFwpsE7m8h2O5pAI0/FHhVfeDeKIfjygcturJD1RMt3yl290Uh9edbCnbAEBSPuzQuj
         o0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680607845;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmeovZ9mSN4MDfTKbY7u/EycY/cDvMXCAzBFKvOV/P8=;
        b=Bp4/IAD5VETyz05Vh7INWq93MhB1JtdUmOjBxlpWuKLw20GXOrDctO2DLUyKZHvaae
         LIE4APEgzVlVASfBe1BRAEUbiolgASu5UjPWUvgDCVnAw3wHNe5ULy95G4uoqOmojvfd
         w0j+wmYCh44x7Tp1S4UIlvnmPP7LLa9XOsfELhM2PWMG2f1+tKVRNzvcPfvSWgh+LeyA
         KGUThfzEnadevSS+7nhG1WdziFAczuZM9AIAC2M1CQTtNMTx1sg0Adzq1+whaO+3LjH5
         95NWx422Vaxwzki22kFkA8AHjT2tbO2TVwudsC4+VLEEBi4wy4S2rlYe8vSI4Dwi2Har
         psBw==
X-Gm-Message-State: AAQBX9dtkeirOiHjYz8bUaMWnpbvTN/5QhNp1y0SPhSmPthM1f7pZA7U
        7gX4Xvzeh8XnnhGc1G19rbg=
X-Google-Smtp-Source: AKy350YOCFT1pkFu3k/Sj2VKkOpHUs/LwzLT3r5j6HJBIxlPXsFpkCwqcgiy/dmOlLMumn8mpCw+2Q==
X-Received: by 2002:a1c:ed07:0:b0:3ee:1084:aa79 with SMTP id l7-20020a1ced07000000b003ee1084aa79mr1483764wmh.20.1680607844725;
        Tue, 04 Apr 2023 04:30:44 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c191300b003ee1acdaf95sm22527712wmq.36.2023.04.04.04.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 04:30:43 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/6] net: ethtool: attach an IDR of custom
 RSS contexts to a netdevice
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
 <671909f108e480d961b2c170122520dffa166b77.1680538846.git.ecree.xilinx@gmail.com>
 <20230403144357.2434352d@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <8617a74b-959a-761b-3c4a-228a06d2794a@gmail.com>
Date:   Tue, 4 Apr 2023 12:30:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230403144357.2434352d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2023 22:43, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 17:32:58 +0100 edward.cree@amd.com wrote:
>> +	/* private: indirection table, hash key, and driver private data are
>> +	 * stored sequentially in @data area.  Use below helpers to access
>> +	 */
>> +	u8 data[];
> 
> I think that something needs to get aligned here...
> Driver priv needs to guarantee ulong alignment in case someone puts 
> a pointer in it.
> 
>> +static inline void *ethtool_rxfh_context_priv(struct ethtool_rxfh_context *ctx)
>> +{
>> +	return ethtool_rxfh_context_key(ctx) + ctx->key_size;
> 
> ALIGN_PTR() ... ?
> Or align data[] and reorder..

Very good points.  Indir also needs 4-byte alignment.
Will fix in next version.

>> +	u32			rss_ctx_max_id;
>> +	struct idr		rss_ctx;
> 
> noob question, why not xarray?

Because I know how to use the IDR API, but have never used
 xarray directly, so would need to learn it.

> Isn't IDR just a legacy wrapper around xarray anyway?

I see it as a *convenience* wrapper.  Is it deprecated?
