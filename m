Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E64ADB05
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377919AbiBHOTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351022AbiBHOT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:19:29 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6259C03FECE;
        Tue,  8 Feb 2022 06:19:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso2160396pjt.4;
        Tue, 08 Feb 2022 06:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wxTG+XyoVyvm3qwt67A3uD8d+hQFZ2NnOQ/flBE0K98=;
        b=Dcro/51npE6vWkDlp954rF9hqbFflacWu4JiIGGktclCeAmxm93szVWwkjci8bhdFJ
         36QJEAczLxpsK0jwHsOuPvdjL2WToJgY8N6aGnUP+w9Gj9WgMP5r0XsFE9yIv4NdnMlu
         qfYKz8q0A1LMRLC/dRdGUw94ANm9VgfZC+Ljakagf8CsKcv5Occ3rxLsAfjrGm5Uy37D
         8lAMM00gBwsDDMrFyNMhI0YpEesWLlk2gvmGPe4Dpra7S+uucD57GJ1CAmsaN5RruBio
         nabdG4q6UQb6hkdxr08YJY9bZObUVDCuO/tlaF1Q2MuUGuo1A8N5HpVqWPXRQDqMcRkJ
         f2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wxTG+XyoVyvm3qwt67A3uD8d+hQFZ2NnOQ/flBE0K98=;
        b=qngM5bA7epZ885Qrq3ETHaNVBYqRZyQoMHOYTSD0yEcf99oxFirkqyXn3oTQ8gEEwd
         BA74DUSlvpd6A9r5FlGeVcH8IgPL73VGw1DK36/iajZGk3x7KLgY4jno630APGGR5cRz
         h+IEoAbioc34Y6rI+aP/499ZZ6REILdGD1nDUR5JO7Wi93Oeam9SlowRjU53uF6SUZMA
         0Xk2Lrvip/mjibTDB/sovxMNHo1F1F9m/ZyWnGDnERPseZsa3T/CSbxDV3Ik5JllMuN5
         hUwU9IMZr6PT/k0Yb763NI8LcNERFYbVHkaa/f4aLbPu0YdSHzbilKSLX608PuHO21Du
         YoXA==
X-Gm-Message-State: AOAM5300+RO+6W3HS9hqynu3/TxGpn/9PXzBvmthTJOp/9bKdErQmd1Y
        WOXNXZpJ3SSdQS2X7ZIgwsIxa/Xtuw+pGBQ8
X-Google-Smtp-Source: ABdhPJz67xSgge/ra2Q7eUO/CH9AuwGGYdwz22g+8hA50Wkv9TgPYjVaIUTlf8RdSMiEj29u5mBg6A==
X-Received: by 2002:a17:903:120e:: with SMTP id l14mr4691979plh.124.1644329968221;
        Tue, 08 Feb 2022 06:19:28 -0800 (PST)
Received: from ?IPV6:2404:f801:10:102:8000::f381? ([2404:f801:8050:1:c1::f381])
        by smtp.gmail.com with ESMTPSA id f15sm16713478pfv.189.2022.02.08.06.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 06:19:27 -0800 (PST)
Message-ID: <6ee926b0-5579-bb9b-da94-51d793a3d782@gmail.com>
Date:   Tue, 8 Feb 2022 22:19:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] Netvsc: Call hv_unmap_memory() in the
 netvsc_device_remove()
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220201163211.467423-1-ltykernel@gmail.com>
 <MWHPR21MB15935F58E55D05A171AE9ED4D7279@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB15935F58E55D05A171AE9ED4D7279@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2022 1:05 AM, Michael Kelley (LINUX) wrote:
> From: Tianyu Lan<ltykernel@gmail.com>  Sent: Tuesday, February 1, 2022 8:32 AM
>> netvsc_device_remove() calls vunmap() inside which should not be
>> called in the interrupt context. Current code calls hv_unmap_memory()
>> in the free_netvsc_device() which is rcu callback and maybe called
>> in the interrupt context. This will trigger BUG_ON(in_interrupt())
>> in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
>> remove().
> I think this change can fail to call hv_unmap_memory() in an error case.
> 
> If netvsc_init_buf() fails after hv_map_memory() succeeds for the receive
> buffer or for the send buffer, no corresponding hv_unmap_memory() will
> be done.  The failure in netvsc_init_buf() will cause netvsc_connect_vsp()
> to fail, so netvsc_add_device() will "goto close" where free_netvsc_device()
> will be called.  But free_netvsc_device() no longer calls hv_unmap_memory(),
> so it won't ever happen.   netvsc_device_remove() is never called in this case
> because netvsc_add_device() failed.
> 

Hi Michael:
       Thanks for your review. Nice catch and will fix in the next
version.

