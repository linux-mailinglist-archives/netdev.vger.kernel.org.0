Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D991C4CAB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgEED24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEED24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:28:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F607C061A0F;
        Mon,  4 May 2020 20:28:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so408104pjh.2;
        Mon, 04 May 2020 20:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YpdSRN+x4uVDUx7f+wGOYPQR8ogpOw7w3pdmT1GKO9I=;
        b=B/kKyMn+x5V4QfHr2Mc0u+5WbvAGNbcNqUeZDYyEXvmnbM8vLMQjFBNZawtvJo63jR
         UfX5cRR6zKkuiqQ5DI7vkpteNu1/VVi7r42XgwErcKzjZ9jWOKs5/fWrVsPQOqIDVxaJ
         as+62dGM4TmHI1eM+JTVTZp5yUs+aqvPK1uJKE8RL0dwkhmt3G42CwMNN5sG0YHXlyBP
         6iAc48bVRtFrsq/2BcKprvc1AIpKFnZR66+zS7qLpHUKZsKPn3PFsW2qbqIbP+26XoBw
         7ntQyaDruyNp/l0SGqU2y09lfrOxpzmDIV17LogW6/qeY5Ga28y6S1N5zmQfLcMw4hDJ
         SLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YpdSRN+x4uVDUx7f+wGOYPQR8ogpOw7w3pdmT1GKO9I=;
        b=WLfpv6CnbSB03OTo6a6JMdceTWM1utgMOLzMUtGmKzCeKyqXB/6HN7/x4a/XYYiRHA
         S4Fae20vV/xoUaT2m6ukVvcJAiDQSTqE2VgdDmMsisVAdQevJtky6bpge9M2PdTKN/KC
         +zz+PuZWdyBJiLWdry1V5F8igVYaoKeqZ5vfW5+SgfQn3o9Dn2Jl+FnM5K83JAV0o2Xk
         Ap8FWwYkfliOmXICenlKzlKriH4KtxwGnH986mpyi9w1gDmXOzc6XfvSD2ZQ+5K6Rer1
         /BbJ22u4VoLiaRS/WALV8Mq0I2js7Nkzy2KtK+DvqJDH2YkwlS909IMUeiXaRHHhOUkd
         BOSA==
X-Gm-Message-State: AGi0PubL2nktfvvjEUPkys9VDhIOZmo1sXKNlg/24vlc37pilD4gT6jS
        06DY+WNYpAoLaTL9tJRmBYM=
X-Google-Smtp-Source: APiQypJqZdNXbfyg+9HRIDHsvJLX4VZ1p6EogDHqNkfciQU8cdfd5pDxlipr0OQERKnqLN3t08oewQ==
X-Received: by 2002:a17:902:9a8a:: with SMTP id w10mr1175883plp.218.1588649335660;
        Mon, 04 May 2020 20:28:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i13sm380423pja.40.2020.05.04.20.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:28:54 -0700 (PDT)
Subject: Re: [PATCH net v1] net: broadcom: fix a mistake about ioremap
 resource
To:     Dejin Zheng <zhengdejin5@gmail.com>, davem@davemloft.net,
        swboyd@chromium.org, ynezz@true.cz, netdev@vger.kernel.org,
        jonathan.richardson@broadcom.com
Cc:     linux-kernel@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>
References: <20200505020329.31638-1-zhengdejin5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8b71b3ba-edc8-ce78-27ba-ce05230efc31@gmail.com>
Date:   Mon, 4 May 2020 20:28:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505020329.31638-1-zhengdejin5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 7:03 PM, Dejin Zheng wrote:
> Commit d7a5502b0bb8b ("net: broadcom: convert to
> devm_platform_ioremap_resource_byname()") will broke this driver.
> idm_base and nicpm_base were optional, after this change, they are
> mandatory. it will probe fails with -22 when the dtb doesn't have them
> defined. so revert part of this commit and make idm_base and nicpm_base
> as optional.
> 
> Fixes: d7a5502b0bb8bde ("net: broadcom: convert to devm_platform_ioremap_resource_byname()")
> Reported-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
> Cc: Scott Branden <scott.branden@broadcom.com>
> Cc: Ray Jui <ray.jui@broadcom.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
