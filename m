Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB93B82CA
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 15:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhF3NWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 09:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbhF3NWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 09:22:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95CC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 06:20:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j34so2039630wms.5
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 06:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhaTOxwiv0G5pOoKD1haOhhYSHrm2ybALBhLQmjGz2o=;
        b=cLZC+U55FdGehnaXGYZ74WBciK5NY8a6KgcHwuVo5kdD9nnCl/cQpX+RDDCYYTJDoc
         mdwS7hXiQ6iXdflU8/mSQUU8JuOfC8TJM7vlGiuKon5Wm5SlilMT92wjf3lmWo4aQYWY
         2E6Nmst1nG3piBQVJfNlymXdhHfquYETcm6asNw1PSdyz0c+8OGDT9ky4u3IKAWuTNBR
         hUIgoC/HkevTl/zup/wNtZlDcxrIuqsmWqY3fLJk6J2oSTTe+d9yEZlgWmDQoek/xyfq
         0u7YqFo1LtCuH+BDgG/mOvNWKd9GFjC7j1iiJMO2ueJlvG/zQky0NZ+AV2Mcj7qL4IvT
         QuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhaTOxwiv0G5pOoKD1haOhhYSHrm2ybALBhLQmjGz2o=;
        b=YQdQPsvuH/xMoKSD98mzt0ue74d6vCh6MU2byzECuauoqIh1WShydrsUdvNO0Sf0N+
         UxuKTr0uI5xYdaAiXaNc4QngCtTo68xZ17dmc+8Q+mQ+z8gzJtzCfR+eALVyP9GKVCsi
         4bOZ1rVRYWyL+M1a6yLTWlAmCGhQnFcxldg3NTN4+ZMxyjjRC4u2NIC/THQt9z26ULDt
         c6SFTk3rQuR0vWTzomEoC/zDoCPu32DXrCJdtzC0NRHH1VwC+JrInz8byA0RM6fndp5u
         jeCxqzutEDCn3abhroEe7X+/LNw07c0tbkpSsGKLYbTdr7AIe2wLtWTfuTMzfJ34Pxmx
         74gw==
X-Gm-Message-State: AOAM533GimjMmy1Kgg2kxytEe4w7VFwYT4WJyEj0KAUbgVOok14WNkhn
        m5zKjUQ+P79k/i+/o0L3kVM=
X-Google-Smtp-Source: ABdhPJyXjbPjcO7ISDSJx3gWb6XKmaF94FzVUMS/hIJNmE8pUho63dsIJ2Qd/nbGcGFDyZDQRVo4vQ==
X-Received: by 2002:a7b:c092:: with SMTP id r18mr15918234wmh.181.1625059206010;
        Wed, 30 Jun 2021 06:20:06 -0700 (PDT)
Received: from [192.168.98.98] (80.17.23.93.rev.sfr.net. [93.23.17.80])
        by smtp.gmail.com with ESMTPSA id n8sm21903934wrt.95.2021.06.30.06.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 06:20:05 -0700 (PDT)
Subject: Re: [PATCH net] tcp: consistently disable header prediction for mptcp
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.linux.dev
References: <7f941e06e6434902ea4a0a572392f65cd2745447.1625053058.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4638ad50-5495-aad2-86e9-8e89273a74a8@gmail.com>
Date:   Wed, 30 Jun 2021 15:20:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7f941e06e6434902ea4a0a572392f65cd2745447.1625053058.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/21 1:42 PM, Paolo Abeni wrote:
> The MPTCP receive path is hooked only into the TCP slow-path.
> The DSS presence allows plain MPTCP traffic to hit that
> consistently.
> 
> Since commit e1ff9e82e2ea ("net: mptcp: improve fallback to TCP"),
> when an MPTCP socket falls back to TCP, it can hit the TCP receive
> fast-path, and delay or stop triggering the event notification.
> 
> Address the issue explicitly disabling the header prediction
> for MPTCP sockets.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/200
> Fixes: e1ff9e82e2ea ("net: mptcp: improve fallback to TCP")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

