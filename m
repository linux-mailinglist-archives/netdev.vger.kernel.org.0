Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C502C464973
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhLAIVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhLAIVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:21:47 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A05AC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 00:18:26 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso21558336wms.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 00:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhJW+9opegtBmg/vvEbcApUZeD/bLQN5cLKvGNtuOsk=;
        b=d/0ktreiQUpcB732uQ1gyQMEOhSYXXXmtBNJRlEKMt9odu+BViiNltMp1ba02Xgh0b
         usZe9dMTWcdb20qnE+l1POhrKt83DyCPFhqxkvn8OsO/U/E5N+zWJHWoUixVK/j4EbQP
         kfED6JIqqdOsBeDiUNtdnmiNHu6li68OsYDzG5ihxmIwftkYf3L35uq61/J6QOJ36Ens
         oLVMGXX2Mrt87UuyXQk7Y8r3WPhji96U5A8R9u0xdCgIRfaLd8N27oUMvodO7OJ8NaH6
         eS1lwxSIdh/+K45laromb5fOUeyxALYSWdJmcl9w4+cAOI9uAnFHIHII5RsiuTRGM05Z
         C6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uhJW+9opegtBmg/vvEbcApUZeD/bLQN5cLKvGNtuOsk=;
        b=g1B+B2dohQSaGrH4lkHEu0PF9UD/10UJMaSrHpFOymkMorryQkSxhmmDL7Y1E3nRhJ
         PtSK8LloTKkEr3OnKl14f7W5/s/xjlrs+HKjHGaR/CB+2iN61slzfCsNrNH4LmrzDXR9
         a87RTQ/7go7R56YSIJBOUHKi5wMDKY7A11+0yCj2USclaZtfCcRN4Xa/dJTjMoTc0/mB
         C2rm1r1LM12pgxyOWxczwWDVR2jev7VG5iFgJfh8F7ci7m8+Avt68T+qnKC2QHZ0x7lD
         oZ/jR2HdTb/3N4U5bwWB7w2M+rGyTu1YVoG9/eDnvBtrSmvdo4eISdpXPb0orpBGd+Km
         WmTg==
X-Gm-Message-State: AOAM532CVCLaLuf89Ccx8PSW7EO2kfPd/BW/Hjp2oplrwaQ523B9ctaz
        f4czk5dWdzSBbH3s7kQS6t52Bw==
X-Google-Smtp-Source: ABdhPJxXXN2bKFMla/dtgZS6jHW0gS7M0Y1D7wJMmVEwk/5ys4n00T/g88YrlXGHbvIJLYRSN2W4AA==
X-Received: by 2002:a05:600c:4f8a:: with SMTP id n10mr5057178wmq.54.1638346704928;
        Wed, 01 Dec 2021 00:18:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:c1e4:d45e:bc53:784a? ([2a01:e0a:b41:c160:c1e4:d45e:bc53:784a])
        by smtp.gmail.com with ESMTPSA id m9sm277781wmq.1.2021.12.01.00.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 00:18:24 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] vrf: Reset IPCB/IP6CB when processing outbound pkts
 in vrf dev xmit
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, stable <stable@vger.kernel.org>
References: <20211130162637.3249-1-ssuryaextr@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7dc2911a-0cb5-6901-0dd6-d4385a8f8d7a@6wind.com>
Date:   Wed, 1 Dec 2021 09:18:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211130162637.3249-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/11/2021 à 17:26, Stephen Suryaputra a écrit :
> IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
> in the codepath of vrf device xmit function so that leftover garbage
> doesn't cause futher code that uses the CB to incorrectly process the
> pkt.
> 
> One occasion of the issue might occur when MPLS route uses the vrf
> device as the outgoing device such as when the route is added using "ip
> -f mpls route add <label> dev <vrf>" command.
> 
> The problems seems to exist since day one. Hence I put the day one
> commits on the Fixes tags.
> 
> Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
> Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Cc: stable@vger.kernel.org

Thanks,
Nicolas
