Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD722428E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgGQRsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbgGQRs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:48:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8D4C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:48:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so16205583wme.5
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5cA5RUvmio3ClfgI8pU8wP7vKSaKk9ymiyczHiblSGI=;
        b=UJ82aaZ4PJK8DnGxDFuapcONUWsOBY4gwWplow/60/Zk2yXslUz9HCaPjWO+Km5nKC
         27vfnD952Rb/9LSYSZOL02rQnrSnJaK1IwSwmE/rX2/ln1d4/fFEbSNhxTiC+EOs1ncU
         NnK44j2uDxeNyoYTQtYB2cZqLPuF4QPR7Bg7vkLkr2yoZvhMNf+wTLkojOlmr+xcWTVn
         ZdgntFQnkGBIBWbSnwueqHT4tjrr8V+jnPTtwx3QRfyvEutVRHQcaXCxGJH1NSc5s6iy
         BntSWida+dRK+0gBvTvmEQ1apQxLxX653kDCCWPaLlix1Twrr2qLZuUNhb4tkFfX6Cxp
         HVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5cA5RUvmio3ClfgI8pU8wP7vKSaKk9ymiyczHiblSGI=;
        b=fPSF7GFs34V8p3ORFXQ8qkzUTUTGrePQtgLv/+uHb1/qoQmlF26P8GnjVJdZ8FM6UI
         IucD0Nfq7jGA4A2orgk5OtzSNlySpoeQaE11SowO9s/2h3DqH3YffRqG97wfOH0Zsl6j
         AbdlCGedTE4ihookh5ejfysm89v4vvVy12oZ+DQ/h8hmmOa5XV4ZkEj+eHq0jjm1SuqN
         +DHrjDCXX8IqYPRiDZvhM+3uPZWOsp5+z4KyUMapjylbuOZhs0PZtu3XSyExFIxA0B+f
         +xH/SK5C9iXTibfy3M3f3OWBj9FdzIsWPpZL2t7I7wezO/CBODSfluHNjnxPzuwrkfzP
         BAmg==
X-Gm-Message-State: AOAM533Db0hsz95jEw4c0LijGKTkyflraE27QejE8yUvAyMZC2+QdmFP
        5iz474Pc/DT0dtsPfHH6Y+4BKmzspmU=
X-Google-Smtp-Source: ABdhPJyWMku0BhtQCMKfPdwWx2yy2ByNeIqXqO791I/1KbbAS5AmVGrTO2Xbjy3zaxaCCCEHxjDZ+g==
X-Received: by 2002:a05:600c:2511:: with SMTP id d17mr10745367wma.127.1595008108118;
        Fri, 17 Jul 2020 10:48:28 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:45c9:b95c:ccef:aae6? ([2a01:e34:ed2f:f020:45c9:b95c:ccef:aae6])
        by smtp.googlemail.com with ESMTPSA id l15sm15314927wro.33.2020.07.17.10.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 10:48:27 -0700 (PDT)
Subject: Re: [PATCH] net: genetlink: Move initialization to core_initcall
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        johannes.berg@intel.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200715074120.8768-1-daniel.lezcano@linaro.org>
 <3ab741d2-2d44-fbcb-709d-c89d2b0c3649@linaro.org>
 <20200717.103439.774880145467935567.davem@davemloft.net>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <059ad7df-b555-a08d-1f81-5fcb31e2e21e@linaro.org>
Date:   Fri, 17 Jul 2020 19:48:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717.103439.774880145467935567.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/07/2020 19:34, David Miller wrote:
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Date: Wed, 15 Jul 2020 09:43:00 +0200
> 
>> if you agree with this change, is it possible I merge it through the
>> thermal tree in order to fix the issue ?
> 
> No problem:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks!


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
