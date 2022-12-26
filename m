Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A536562A9
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 13:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiLZMsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 07:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLZMsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 07:48:03 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC48CD0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:48:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u9so26015064ejo.0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zz3GS4ksT6Xy5gdDfR/1Mzp2//SjINWEE9aVrsbz22Q=;
        b=n8u28EYdxJ+GkAvPKRcGn3ZcMOrFxT5n7gmJGiZUF41IiT9y1KJ4Fj+qEaY9VHEv/N
         3erP52dWsbTIiz8lMMx7qevtSMDtVsiPcNftjaMD3XaocQOBbRM1pMZ50k54XixNZQSl
         ppMcRqsSVDLbyOF4B+88X1JUbkatodt/EGIH2yE6qV4WvwrOx3LDQCE0sRd20/s1aHyl
         87UQDSvnnso6AAvYw+/7NrmJYQajK5AOJXWW6IrsoJtJgSf79MFt8ENSP51YHo5riwK/
         ccq2o7zkY9uRupAMH7otHED3YYAP3j0yu2mTT1eh4ZYN7fZCk70Zco6ESCqOiX1FAxuT
         CuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zz3GS4ksT6Xy5gdDfR/1Mzp2//SjINWEE9aVrsbz22Q=;
        b=W/Qyte3PFitv6F0NSQi0e3dmD9DE+k/tcVrkPvjBrXH36aNb4Yq6TWr90zDWRszaxC
         8JBH7d6Uy5lG+zbOOKDKZx49EBkJHND9rxndi15FGCKAbJWBE4hpyfGKqlaxXT9KkFC8
         eLoM/1+Vw6Y1txzgVm9dpffsO5K6dJXFHjHdxGq8VvhQC9O+YR1tR3AouqT8CgxaD9n3
         yNI+1ui8Jfrjyqhn2dzoWjOMp1gXy2YGk+e1LRMDUZBAvsZd7h9R5UDhYFbkSTTfQluK
         /EShdHdmvrYC6pD9Kq/l7fe8peHLZdmeKC5o34kZpgLZD8rgxBu9fTLyWllR8IW7NfpP
         LFXQ==
X-Gm-Message-State: AFqh2ko3E1sjHSFQe6c+leb2ZDXU5koj77wkQGz48JOTp6/KtZlGrAgv
        CmPJv4NmkUHV5YIAIov+V6o=
X-Google-Smtp-Source: AMrXdXsGt6SbQRWyRnv4kAZlW4kJgtTMUXu//Cbr4UR4wX+Lf0+8UI8z08bBCnkloOf69bOs5Pd3NA==
X-Received: by 2002:a17:907:c202:b0:7c1:19e3:9f21 with SMTP id ti2-20020a170907c20200b007c119e39f21mr14397248ejc.7.1672058880460;
        Mon, 26 Dec 2022 04:48:00 -0800 (PST)
Received: from ?IPV6:2a01:c23:b980:7800:e1ac:248e:2848:f0b5? (dynamic-2a01-0c23-b980-7800-e1ac-248e-2848-f0b5.c23.pool.telefonica.de. [2a01:c23:b980:7800:e1ac:248e:2848:f0b5])
        by smtp.googlemail.com with ESMTPSA id h13-20020a0564020e0d00b0046b00a9eeb5sm4626006edh.49.2022.12.26.04.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 04:48:00 -0800 (PST)
Message-ID: <e04ef1af-56fb-4740-7420-4b1710f0fd98@gmail.com>
Date:   Mon, 26 Dec 2022 13:47:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v3 2/2] r8169: fix dmar pte write access is not set
 error
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20221226123153.4406-1-hau@realtek.com>
 <20221226123153.4406-3-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221226123153.4406-3-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.12.2022 13:31, Chunhao Lin wrote:
> When close device, if wol is enabled, rx will be enabled. When open
> device it will cause rx packet to be dma to the wrong memory address
> after pci_set_master() and system log will show blow messages.
> 
> DMAR: DRHD: handling fault status reg 3
> DMAR: [DMA Write] Request device [02:00.0] PASID ffffffff fault addr
> ffdd4000 [fault reason 05] PTE Write access is not set
> 
> In this patch, driver disable tx/rx when close device. If wol is
> enabled, only enable rx filter and disable rxdv_gate(if support) to
> let hardware only receive packet to fifo but not to dma it.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

