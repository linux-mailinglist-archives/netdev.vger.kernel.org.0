Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ED16373F5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKXIc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiKXIcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:32:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D987DEF8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:32:24 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5so772836wmo.1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u2iwIJ2WywsWxcK4TRKG3JycXDuYGOrVILwZeVr2PbI=;
        b=CulGb1hAcGnuefAt63s5X76Y+x87q1LmwSgJsClK05XO8b0YfC+CabdZ747hKWQ4Il
         4z8jZXlgShCsEqNaFl9WDfo7Vy/iaPuFVtd+wKRGsMNH7tdGTqIl+BXcwr0j3METPv+J
         YU0jdUWIgJMtHcEUGMbxFnWQahNla/HC8zKDPTaydMFTBblA8/inFj9+NfmntkoTPB5w
         IPp1OTzGRGPdYJlIYAml5JfInRU7YJnqwb0CkQ2kMXYG1xM+WxSTHfQnN6eYd4rRX8D0
         //SePF45GWNMYyB1aeHXQO2p9SJiGeK7fHU/tW+mBp9aYDZ62wLVTCMQVa5ll572x/KH
         sngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2iwIJ2WywsWxcK4TRKG3JycXDuYGOrVILwZeVr2PbI=;
        b=kx54XLFSLQ3ih+TyWaDHJcqJukjPNPA/IpFSGqiqUV2yrrck3lSLe8jEOjSNqf4d//
         HJF8ydLSy7GEW7HhNzXYln6tvTb3OvDtBxpaJN9xkbUQ99yceJjbYCRl9Rd18HyUXtN1
         u+mgPZIigtRLxbybIRYOEuNjH6+cbq4zXs+SF3P8y6R3DEcJkeTijHPe6eb3lqzXygWM
         yTi5NxS13bS1bHgqGZ1fGoMmpx5g7jdGYIjnzko9fdwYXu+DoXEY2XyUTKDVFBS+68Yn
         wYrlEuGF7dqym2btjvmPBgDlz0Dvac1TbMuOgC3htkgy+hL2t+mc362vcfTOjZu/Twzi
         Gajg==
X-Gm-Message-State: ANoB5pkSLuva/XilWy8jOTVdoDKRh3DmZ1t4CMkOhbaaKVYd5UX6J5F/
        JxhRag5styAAGimCXXmREWk=
X-Google-Smtp-Source: AA0mqf68FoEIdRIaqogpr15So88gfqd7rerPed8mwN8FqFNOSBiOztoPJHgfAW7cnvIdizFtjYdmQA==
X-Received: by 2002:a05:600c:5389:b0:3cf:a343:9a28 with SMTP id hg9-20020a05600c538900b003cfa3439a28mr12674330wmb.186.1669278742637;
        Thu, 24 Nov 2022 00:32:22 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id m29-20020a05600c3b1d00b003c6b7f5567csm10661246wms.0.2022.11.24.00.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 00:32:21 -0800 (PST)
Message-ID: <822ae1fd-c059-d834-60a0-af0dc944ff9f@gmail.com>
Date:   Thu, 24 Nov 2022 10:32:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 07/15] net/mlx5e: Use kvfree() in
 mlx5e_accel_fs_tcp_create()
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-8-saeed@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221124081040.171790-8-saeed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 10:10 AM, Saeed Mahameed wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> 'accel_tcp' is allocated by kvzalloc(), which should freed by kvfree().
> 
> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---

Hi Saeed,
There was a v3 of this, that changes the alloc side instead.

