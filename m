Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441F832101C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhBVFGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhBVFGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:06:33 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA074C061574;
        Sun, 21 Feb 2021 21:05:53 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id c16so10939942otp.0;
        Sun, 21 Feb 2021 21:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0IK9DLxki6SqxTG9lDZWezFEq9f+5L8fVOWIJWBJcgc=;
        b=g/9QDjeiIwY+SOlK16krLiqxHVJIm7RHFeIudP3cD0+oX/ziWfJbaxTqf8dRiB+oh+
         Z2NRwAl6tMCUK9eufuaSmlHXnoGbiZV+ESjISSGH1sNEugt3Eu1/5rb5rrD4BPSXpYIN
         mnlC3/muNdWjJFoziVQgf+C5rNi3fC3xFC3eyR/SqaDTQnIgW9YjmiNTw7VJezXNxSw9
         3JbugPFz0cUiFd2Q4MjAVx7ROLPjve6CXUsTeXfyypnzs13zjjX1vZh2zFhxzEwgVLV9
         yV/WFpqyPvnvamDsWei+MSBiFR69Tx8SwZC6WX+MfORTlBTEhDaodMQSpuXWK0Zzbh2B
         z0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0IK9DLxki6SqxTG9lDZWezFEq9f+5L8fVOWIJWBJcgc=;
        b=rrCbRlYyYlKdnNTjHPr82OHPNY1sE+TGmD5V0Wh/0JuNZxQLbb0QRVDtrBkrGs9kJz
         ELrpebDcEB7Sm0FM5hl+1qxi66EBKDu8GvPDTb4wOVq2q1tf5WXb46c/8VPl2C5vskaW
         OJb0cHpbPjdikQadcII6O2q8Fw2PwGHQhZJMA0W4/o6XCNl2xiCDuIThpGTz3eXjgBY9
         yQdLrD8ZKtGEXvENrVfdolNtMONTi3rFzPdo3OiGJaVhNE8g6cvs+VTZ661B+tP790xr
         K5PWwaX9qvRd57RN5VBFcaoA2gMeU22drXeAUsl2fZsp2w6bt3YKZhAjJh+T+GY1NPgE
         G5sw==
X-Gm-Message-State: AOAM5305gjKJwmiii0hq7V6RFw0waT7ekCWA3JmuCZ0b7sZuuMIV2p82
        PihdTLZ+P6m0YegerV4vLSBMKzv9J4c=
X-Google-Smtp-Source: ABdhPJzpYSscCuDBWQEd/tRzW0amNsQ6jx7Nm4YsORf9VsCjvFjjm4ESDu2I2erNinKEz9TGFdRXNg==
X-Received: by 2002:a9d:6317:: with SMTP id q23mr15068819otk.301.1613970351714;
        Sun, 21 Feb 2021 21:05:51 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id s6sm55231oon.46.2021.02.21.21.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:05:51 -0800 (PST)
Subject: Re: [PATCH net] bcm63xx_enet: fix sporadic kernel panic
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210222013530.1356-1-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f382effd-a4f5-b860-c521-5728f1f6200d@gmail.com>
Date:   Sun, 21 Feb 2021 21:05:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222013530.1356-1-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 17:35, Sieng Piaw Liew wrote:
> In ndo_stop functions, netdev_completed_queue() is called during forced
> tx reclaim, after netdev_reset_queue(). This may trigger kernel panic if
> there is any tx skb left.
> 
> This patch moves netdev_reset_queue() to after tx reclaim, so BQL can
> complete successfully then reset.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 4c59b0f5543d ("bcm63xx_enet: add BQL support")
-- 
Florian
