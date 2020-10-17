Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB01829121A
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 15:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438196AbgJQNqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438192AbgJQNqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 09:46:06 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8544DC061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 06:46:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id h24so7501835ejg.9
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 06:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=FPhEdIY5KuEMvseRGzglc0TnMkq8eN0fVBxf9t9vD5g=;
        b=YD6Xq6L9uo2dCF0d4GH1W7AaYY8jASnSXy0nNWzGn+xqSOiVK1aehGqWgRjOko4hnX
         ngt15q+s9eO11qmRpKM4EdnkmiVq9qdpvlCx2y5AbaPKaqow/EQmnvMTMVv3HhjGD6t8
         Hvp4yvJdEp++vYijW9YJxU63425J3IWzRfEhJWXFPxfQNU+iowpfFlKhTDbnEDzuYiJl
         UioP4xsHAwk0Cuwk7Ag4srSq5GjImFoL30FHtDrNmDlR+zNWLYaxARQ2R9qvX1nl6Gz/
         WJjbi7ka5BRjt/+b/HOpIQkD8P2ZpmkWUv1VOveatgm4kZBsfsjV0uskoNmkwaSZHbMP
         RQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=FPhEdIY5KuEMvseRGzglc0TnMkq8eN0fVBxf9t9vD5g=;
        b=gcX+FvRgh6fxI9BxwatDfNLHwChH1UucAY8rd8qpaQ24Yk/6ioS76aTtVoS67ilOj0
         yJXaqreuslH78Oz+FaO4myngv5KYmcfC0NKhe3/eP0eQT9rtY8I5FrdEOG1dsCw8r0SO
         H1DGE7hFQisZ+WtfwlY6UcjFDn3nAEjS6snRcCT6lS+opeQ6aOgWFKWCpakokCkwWMy/
         N2rtoRbyUbgiXOgjbrgDpi+EdgVIzb++zUPIyXXWXQ7dPKHGfpMvu8GqdvoahGh5hHCU
         ZwKlrgs2Il4AjqtyGH9s3gsON5ldug+GR6EO3AAa6r30+gJtF3rfV3jTPTriymK3Rvx2
         1fvg==
X-Gm-Message-State: AOAM530fTzWP77Q84G8/x8a8MEbr/3iWw2vvdMjVsRrudaPb5K0pscwm
        IiHai4XTxuKFbNSDqyirRP1XNk0Z3bM=
X-Google-Smtp-Source: ABdhPJw5gVweXS2zgH29uDh4ZR0xTYv7IACRS4dRVBO/Wcqh+FJJRv+YJCjooJPAS4RemrcmylBf4A==
X-Received: by 2002:a17:907:104f:: with SMTP id oy15mr8833258ejb.261.1602942364902;
        Sat, 17 Oct 2020 06:46:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:f845:b1c9:b817:f8d3? (p200300ea8f232800f845b1c9b817f8d3.dip0.t-ipconnect.de. [2003:ea:8f23:2800:f845:b1c9:b817:f8d3])
        by smtp.googlemail.com with ESMTPSA id i5sm5052996ejv.54.2020.10.17.06.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 06:46:04 -0700 (PDT)
To:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Remove __napi_schedule_irqoff?
Message-ID: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
Date:   Sat, 17 Oct 2020 15:45:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When __napi_schedule_irqoff was added with bc9ad166e38a
("net: introduce napi_schedule_irqoff()") the commit message stated:
"Many NIC drivers can use it from their hard IRQ handler instead of
generic variant."
It turned out that this most of the time isn't safe in certain
configurations:
- if CONFIG_PREEMPT_RT is set
- if command line parameter threadirqs is set

Having said that drivers are being switched back to __napi_schedule(),
see e.g. patch in [0] and related discussion. I thought about a
__napi_schedule version checking dynamically whether interrupts are
disabled. But checking e.g. variable force_irqthreads also comes at
a cost, so that we may not see a benefit compared to calling
local_irq_save/local_irq_restore.

If more or less all users have to switch back, then the question is
whether we should remove __napi_schedule_irqoff.
Instead of touching all users we could make  __napi_schedule_irqoff
an alias for __napi_schedule for now.

[0] https://lkml.org/lkml/2020/10/8/706
