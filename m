Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF165297DD4
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 19:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762679AbgJXRlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 13:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762630AbgJXRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 13:41:22 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F670C0613CE
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 10:41:22 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id b69so4665839qkg.8
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 10:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QWx5TDSWu5fRzsjs5dsS+pELMgeU0759yx9l+8+ejII=;
        b=rKRBaqBn02HMw5C7HkZOW2+jtDroqzxwF7pp51ZZ8m+e6vl90cCKv4SdZnAJUeLHtp
         Q8v6bjrEUOeuMgQV5Yf5KWHAnX/rHhk21Zk5LfXegw+N5WW7Hw3mH9IVhnlPDE0AhxnM
         641Ku84kE6tTRal9U2qnDCAVHrfEjru1iFs+rOgbCsfxAt4TeqGfXp7ImmV/PYz81NYh
         xB9vM9LIyPre31BtZFE/PDkjz9Bh07zmBehyVGa/BTHC04bYJNA8MyxxdWAfbin4KS4J
         c5Ev2q2SuNoR50DSO5SRSAQWJWALTx+zclx7hPim7Ygby2pguR6lnmzX82k8yxCc0QZK
         TExg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWx5TDSWu5fRzsjs5dsS+pELMgeU0759yx9l+8+ejII=;
        b=H05ENYvEE2XROCBTewxxsorP6Iv2tYgeJ2oPkX8sFQ3TqJsRq8GyU7Wo+VG9PDWd0w
         s0xwByisLiSozMbJCLhBleB3jf49uC1nBcr6m1J3B9K9iajm6GDnwC2ONhyB/LV+Jwmy
         ssCj3vA0LR4Lk+7jNyrcDHV0RmYh7RRgDFA+OQKIPH5gw8OkqZYL0Ijse0H3oD0JgibB
         UTj+tHRh5wgNQISlrsc01xBpLStLaFLD3FFSMqmhGUEiYjiShQtorXJHj6pdjCtc9hM7
         05N1NeIKZpqO9lKxDfnjGophAhvyPmffahM7i2GgUPkp068ZkKB92yJV8DcPUObM8Qfp
         mRXQ==
X-Gm-Message-State: AOAM533mnupcTrnBL5L/agOhi9cF6CHto2+eA1ggJecOQcq62B07ArVU
        8aSjfdqiPP47X29V1CfHAfs8oQ==
X-Google-Smtp-Source: ABdhPJzEuO7NpmwFuSBA4v0YuotoxysbYR+0WYgBMZ4H23vYHHbLPnW8SYoUF9wIW+4E8fZzXUNWcw==
X-Received: by 2002:a37:88c:: with SMTP id 134mr8599049qki.17.1603561281920;
        Sat, 24 Oct 2020 10:41:21 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id w6sm3236325qkb.6.2020.10.24.10.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 10:41:21 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/2] tc: skip actions that don't have
 options attribute when printing
To:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@mellanox.com>
References: <20201023145536.27578-1-vladbu@nvidia.com>
 <20201023145536.27578-2-vladbu@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <598d7a76-e8c4-f6a5-c270-31f8072492ab@mojatatu.com>
Date:   Sat, 24 Oct 2020 13:41:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201023145536.27578-2-vladbu@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-23 10:55 a.m., Vlad Buslov wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> 
> Modify implementations that return error from action_until->print_aopt()
> callback to silently skip actions that don't have their corresponding
> TCA_ACT_OPTIONS attribute set (some actions already behave like this).
> Print action kind before returning from action_until->print_aopt()
> callbacks. This is necessary to support terse dump mode in following patch
> in the series.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
