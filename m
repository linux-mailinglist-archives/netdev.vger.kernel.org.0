Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6222F6ABF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbhANTSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728938AbhANTS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:18:29 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBD7C0613C1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:17:49 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b2so6934917edm.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=23yPPjHaxPNE0KQ8oCeJXs/2B0KQYJpURsDNWLZSAcw=;
        b=JP8/L5FxaJp8SIEa8lbXAMOJLRP6uOXYR+1zg4CKs2mMcKjtmd1Ju05OR1YO9KDGsc
         EHueb5Bv3XGQBGIzCBX3Jvz+G26B/f8Xp28IUN96NYmW8ciVCQw/W1N3c9OhqXAi7Qd9
         kQuv4Nt4YIEYc9+A3wYSaLDnP6feew+hrHIrChzphXSb6kJzf3VAYbHD3PlP0/PQA1Gf
         0hmoy/ni49VmWwBoXGsziVOsoFg4XTN5WDnIkVnCOcnR2nxQCNLUKWUfN+gohzh9iL0p
         6D8u+eOTQDzCvYFlnmrpinFBAoMEklm1UmM+EirqS+8kYVT1+UtMQey1b/g/XhI8+VYO
         fszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=23yPPjHaxPNE0KQ8oCeJXs/2B0KQYJpURsDNWLZSAcw=;
        b=ipKFbyAQFMbp8Du7XfLqInAoLD/TVn4xg30eNCPFGYBmZDm8wconiCq3IS8vbAqSdz
         i28+qQiHNA9iBKyjK5+8Pd7geY5Xv/aLjKx2cXvLZduq4yn7YYAh9nTXNRl0+B7pz6VC
         sFMvcDkipJic6qEGBOQ8SBx6I0AWXxZitKzGTeN5qZtNElpjwIvQzq/KfvKL2j80CRHI
         pdYT4oYpXxZX0jgfeJ4IUjD852jJOY4z+J5AE+SeYss5Xp71nXig7E7Dh8L3vtSHtwAv
         v3OnHe8Lfxn0G3kw5q/v3fSmDIb0CjPPz30t4sAI7ZHH3PvoUMqVfHrPo9kjwv5EgGAc
         l1JA==
X-Gm-Message-State: AOAM532G57ZoZaM+CoxgLEM85BvxU+r1XCn3e44zd0DaCfjQ3b8sTOuK
        8I/ApuREaO3sVz9WjuPy6K0=
X-Google-Smtp-Source: ABdhPJxnN3T7iKOqlx2qPLp1AqWPuSAkIY+4c8+TYBZzC0CHFiyIt2kw56oSY68Gpwpehf5pzKYbqQ==
X-Received: by 2002:aa7:c543:: with SMTP id s3mr6806760edr.88.1610651867820;
        Thu, 14 Jan 2021 11:17:47 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id x16sm919744ejc.22.2021.01.14.11.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:17:47 -0800 (PST)
Subject: Re: [PATCH v1 net-next 00/15] nvme-tcp receive offloads
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     yorayz@nvidia.com, boris.pismenny@gmail.com, benishay@nvidia.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        ogerlitz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <6b9da1e6-c4d0-7853-15fb-edf655ead33f@gmail.com>
Date:   Thu, 14 Jan 2021 21:17:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2021 3:27, Sagi Grimberg wrote:
> Hey Boris, sorry for some delays on my end...
> 
> I saw some long discussions on this set with David, what is
> the status here?
> 

The main purpose of this series is to address these.

> I'll take some more look into the patches, but if you
> addressed the feedback from the last iteration I don't
> expect major issues with this patch set (at least from
> nvme-tcp side).
> 
>> Changes since RFC v1:
>> =========================================
>> * Split mlx5 driver patches to several commits
>> * Fix nvme-tcp handling of recovery flows. In particular, move queue offlaod
>>    init/teardown to the start/stop functions.
> 
> I'm assuming that you tested controller resets and network hiccups
> during traffic right?
> 

Network hiccups were tested through netem packet drops and reordering.
We tested error recovery by taking the controller down and bringing it
back up while the system is quiescent and during traffic.

If you have another test in mind, please let me know.
