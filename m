Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960644ACF6A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345923AbiBHDCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiBHDC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:02:29 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CABC061A73;
        Mon,  7 Feb 2022 19:02:29 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e28so16451252pfj.5;
        Mon, 07 Feb 2022 19:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7jHwiqDfU8WVJLniyHD+o90V7hY5Jn78yKCuk5F9hqc=;
        b=MwFHJ9pAQ9jZOc6NWhMw7KB8DVv0MAtzR7Mit8XpiFdUG9q/CUbQdi87CVGCdJQMOH
         qVDG3alvH67114qXEF8F5jVJkUy+SNfBHmO7LFBgypjUxJrumNUsrcdoRFSqq4XWiobl
         pWYEql2/2ASAqhnpwved38AYFg1MJ7MYrggmsjLdOIFLxU6j4LKSqI3bUT21X6J5fJkB
         acv2QXSEiPKx1wAg0byu/CgIn+ThJ+2mTeKy5RFuSdWKSDJ6m9ydsydzqHAPPFU2+kB6
         sHMrnmlQWK5uHaL8BqPSWRN1nQ3sYY8GZwhFOz3xE96s9G5wvVutGe1/J/parZ8mH8wX
         hauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7jHwiqDfU8WVJLniyHD+o90V7hY5Jn78yKCuk5F9hqc=;
        b=krcmw1X6nfITNJsBORgFFiakjslIjus0Qq4twWbNY9y+uUbRTcpDL6f/oJzY92KZuU
         5C9UPm6nIq3A2GMW/B9B62GS+r6Dut/35nsRsG52r5MtJQSqjceDlqgYasDSOgLb68Wu
         ++U0FvUbeL+gOvX5/mlnluMEvuWb4rPnUYhOLlLxR4pgszOPAEI6dB5odXmPqGwv/QmN
         es+aViUfW9owHNTdKwReUQnVlwxiZpDieFfPJMalmsk1NuFCJVdGlqPtPsWcfSrSx2Lp
         8QwvUyf0yozqPS1eMXXdHwzUfjSqhpZ8emdiWRs1YiQlu+tpTq/c81fBsGm3s21G56rE
         vJGQ==
X-Gm-Message-State: AOAM533Pbodls/Wymso/MIZnXVGz0pXP7OR7qRNT9nvasIWGscJCGwzp
        AFWh9drYB7yKzqD+lPHGagI=
X-Google-Smtp-Source: ABdhPJzPKbi3n4tD5jaLh2VF8pTCNNQRyDh2Jwy8fM0+T+joF2hSOjay7CspiiSlltlcMYSaZC6YfQ==
X-Received: by 2002:a05:6a00:1c96:: with SMTP id y22mr2383476pfw.8.1644289348491;
        Mon, 07 Feb 2022 19:02:28 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l20sm13953735pfc.53.2022.02.07.19.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 19:02:27 -0800 (PST)
Message-ID: <d2cd2da8-ff65-fa63-96a6-a388c228854b@gmail.com>
Date:   Mon, 7 Feb 2022 19:02:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 09/10] net: dsa: microchip: add support for
 fdb and mdb management
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-10-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-10-prasanna.vengateshan@microchip.com>
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



On 2/7/2022 9:22 AM, Prasanna Vengateshan wrote:
> Support for fdb_add, mdb_add, fdb_del, mdb_del and
> fdb_dump operations. ALU1 and ALU2 are used for fdb operations.
> 
> fdb_add: find any existing entries and update the port map.
> if ALU1 write is failed and attempt to write ALU2.
> If ALU2 is also failed then exit. Clear WRITE_FAIL for both ALU1
> & ALU2.
> 
> fdb_del: find the matching entry and clear the respective port
> in the port map by writing the ALU tables
> 
> fdb_dump: read and dump 2 ALUs upto last entry. ALU_START bit is
> used to find the last entry. If the read is timed out, then pass
> the error message.
> 
> mdb_add: Find the empty slot in ALU and update the port map &
> mac address by writing the ALU
> 
> mdb_del: find the matching entry and delete the respective port
> in port map by writing the ALU
> 
> For MAC address, could not use upper_32_bits() & lower_32_bits()
> as per Vladimir proposal since it gets accessed in terms of 16bits.
> I tried to have common API to get 16bits based on index but shifting
> seems to be straight-forward.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
