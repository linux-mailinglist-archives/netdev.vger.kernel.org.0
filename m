Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708BE6182A2
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiKCPZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKCPZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:25:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98883D5A;
        Thu,  3 Nov 2022 08:25:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v3so1955805pgh.4;
        Thu, 03 Nov 2022 08:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WUQgPY5LlhEQkDbEFu400GoVmGB8P4bd1+MGak4qYKo=;
        b=Gor4YRFoxRJZT9UaDxUxYPqsA24bFRjGhIXCXIW/UDjSUkzD0J3VLUiYKKR1i9alm1
         sJTz8Fz0P1VeBrVxc8Ql0OatGP907sfKFk8N2Eu/jw1bWtcU3AMYxN/LD50yjBPIw+ex
         ucLRjmt6/fOFtnS0Z5VVgeh3WQ0CIOmmPAzc2YySqXd4CZM/F7NaQ0ojQRuMEbstlJfv
         hmTLZ3RWVhBkehdr99oFys8hz8RGkv59dnmgOHdWP4Za30Rt673SnDDSLS88tlArfq4D
         DeNXStoXGM7ExTcA7tjTyQ7pECuQysemEZ5UbA0Hx2fntNx6AfdsGXKhc6zuAIlA/haF
         bCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUQgPY5LlhEQkDbEFu400GoVmGB8P4bd1+MGak4qYKo=;
        b=octXuNykNaLr3V3uVcCNHD4tjzV3aQ3uh9wS0ELSWVPn+XBSJ2WeZ6s0iX+3PmbLyM
         8rR5cmZ/icTPTGTfZJtAUgIRO6mnhYjjUdybDtQvhah5J36lPL7ICARus7hsLgJXIsnR
         cOPUpFFwa6m5zrtdMVSDB4kQdl766F8Pm47phaP0E0Zu6glBUyDGWIqoHZk6Et3ZVVme
         7AXBpj+HwtN5dHvIhzSrFZZPRIjYt994ZY6EQtgJh/TnRqOVrZazT+mwYhqqNhCtEBr/
         BXzqbJ7vvNu1gzoAPWUTZbSpFXulO5T7sRtVZz6V9k6ndlSMwtHe9szugsx8KgBRyiZv
         9vag==
X-Gm-Message-State: ACrzQf3GRBopNjOSDhExBqepdO6zLm71snIpq5SKpsKcMGruIQYAIZTR
        5zAP7eqQUKjP1epQ5KhTtbM=
X-Google-Smtp-Source: AMsMyM7RlBAEQPJB/ysiIbhg6yyEIGOXEXML6b/Ot1TWySn1fJWemfKUcS+hMg3DQj0gpM9hVmYQxg==
X-Received: by 2002:a05:6a00:88f:b0:530:dec:81fd with SMTP id q15-20020a056a00088f00b005300dec81fdmr30822569pfj.64.1667489133099;
        Thu, 03 Nov 2022 08:25:33 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:1a:efea::75b])
        by smtp.gmail.com with ESMTPSA id bi11-20020a170902bf0b00b001866a019010sm815765plb.97.2022.11.03.08.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:25:32 -0700 (PDT)
Message-ID: <941fe781-674c-ad08-3f33-b99d1c7e3539@gmail.com>
Date:   Thu, 3 Nov 2022 23:25:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 10/12] Drivers: hv: Don't remap addresses that are above
 shared_gpa_boundary
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-11-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-11-git-send-email-mikelley@microsoft.com>
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

On 10/21/2022 1:57 AM, Michael Kelley wrote:
> With the vTOM bit now treated as a protection flag and not part of
> the physical address, avoid remapping physical addresses with vTOM set
> since technically such addresses aren't valid.  Use ioremap_cache()
> instead of memremap() to ensure that the mapping provides decrypted
> access, which will correctly set the vTOM bit as a protection flag.
> 
> While this change is not required for correctness with the current
> implementation of memremap(), for general code hygiene it's better to
> not depend on the mapping functions doing something reasonable with
> a physical address that is out-of-range.
> 
> While here, fix typos in two error messages.
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>
> ---

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
