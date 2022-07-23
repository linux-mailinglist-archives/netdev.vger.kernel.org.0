Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5857F183
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiGWUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 16:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbiGWUsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 16:48:37 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D21D312
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 13:48:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id oy13so14100335ejb.1
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 13:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=XfdNu1mNrirsJ/aSN5rWH2t7rMCgYB5V7IhZ/SSPJys=;
        b=f229UqiefVvTYRbjmasvE9DD0cq2X+f/uTDgAzWFSN6Wq8+wToiN6FdGmG84WhT8rH
         v78/h0VsC7p6WhujS43JukibpmcoAp+rYq8fpD5OY6MapX2JXJHIIz42B2uHrCk0Du0A
         rvtDBfom/MYkp+sILAm/A5KO/uVzigTU52ZAmDIECFIcplCUPCswzfHyHq3Zmi7Emxzw
         LOqZURnel9vZUORn7xIhbEeuRcYBDd0yu/QWs/14iiMO68/w9uXS2zD9u2o8WijGgN0s
         hk+u8jjhqeXNHCSpVrREa9ipYJtzE+LlI+dcByOS2nDD7D4KvcA3JNyey6wyb5Ts0X7Q
         YGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XfdNu1mNrirsJ/aSN5rWH2t7rMCgYB5V7IhZ/SSPJys=;
        b=5Ayz2z5PWX+UxnHgXIQe99ZzFWQgW4ZUdn1s3WYe8bRtJ61q1xA6l07qVKWaGHxnJM
         LHuurWnbRdQdzaWJLw0LfI0QIqPExwstwKC6YZg4e5EtVTRuZPVgfUaYRrE0Gm+SMKuj
         V07/8ITB99ofcKoISu/3/PJrcutfcW+x0T+h1KGnmAssRBnSLn9JaXLYuZGmo46e3Uvj
         k9DVAqhkEjHtlJ68M7IaFbObN5GSgNHqnofZOfNm6fEIVuWg8Fi65B4p+YxqQjdMtMr1
         I+icAXOOjH9K3JICA3ZcRmwUI144c2tnRsou0rzcyeNZEemhF6X8BCq4o02WahqmDl3D
         Rzag==
X-Gm-Message-State: AJIora/s6VimRZ80cAatXdGitghocSs0enB0Dcws+lN+YeujqHOURxuj
        R6dMmIsffJhQu0LIwaHctBA=
X-Google-Smtp-Source: AGRyM1vBah38Dro3W4NH7F3A3b76EhJo8FB7lq9wxho7GBmPcHmUR/dLKgSnVB8019iWZePSvACwrQ==
X-Received: by 2002:a17:907:a06f:b0:72b:564c:465b with SMTP id ia15-20020a170907a06f00b0072b564c465bmr4525693ejc.344.1658609315264;
        Sat, 23 Jul 2022 13:48:35 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b964:6300:7d1b:1ec6:2a72:1cf5? (dynamic-2a01-0c23-b964-6300-7d1b-1ec6-2a72-1cf5.c23.pool.telefonica.de. [2a01:c23:b964:6300:7d1b:1ec6:2a72:1cf5])
        by smtp.googlemail.com with ESMTPSA id ku7-20020a170907788700b007052b183d51sm3479211ejc.132.2022.07.23.13.48.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jul 2022 13:48:34 -0700 (PDT)
Message-ID: <68983671-039d-ce1c-e5c2-33e0d03e6a5f@gmail.com>
Date:   Sat, 23 Jul 2022 22:48:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Mason Loring Bliss <mason@blisses.org>
Cc:     netdev@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
References: <YtxI7HedPjWCvuVm@blisses.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Issue with r8169 (using r8168 for now) driving 8111E
In-Reply-To: <YtxI7HedPjWCvuVm@blisses.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.07.2022 21:15, Mason Loring Bliss wrote:
> Hi all. I was happily running Debian Buster with Linux 4.19.194 driving a
> pair of 8111E NICs as included on this board:
> 
>     https://www.aaeon.com/en/p/mini-itx-emb-cv1
> 
> I upgraded to Debian Bullseye running 5.10.127 and started seeing this
> popping up regularly in dmesg, with the status varying:
> 
>     r8169 0000:03:00.0 eth1: Rx ERROR. status = 3529c123
> 
> As this box is being used as a firewall, I didn't want to leave it with an
> obvious issue, so I installed r8168-dkms and it appears to function with no
> issues.
> 
> If it matters, I was not seeing the error against eth0, just eth1, and in
> this case eth1 is used for PPPoE to the world, while eth0 talks to my
> internal network.
> 
> I've not yet tried the Debian-backports kernel to see if the r8169 there
> works, but I can do so given some scheduled downtime. I'm writing in
> advance of that in case the nature of the issue jogs a memory of something
> already seen and addressed.
> 
> If you tell me what debugging data might be useful, I can supply it.
> 

The error message indicates an incoming packet CRC error.
4.19 doesn't report rx errors per default whilst more recent
kernel versions do.
