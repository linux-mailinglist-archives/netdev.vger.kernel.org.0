Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3F2B1953
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgKMKrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgKMKrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:47:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1603C0613D6;
        Fri, 13 Nov 2020 02:47:14 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id j7so9275115wrp.3;
        Fri, 13 Nov 2020 02:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=4t6Go8s2wuljbP+CKsMvEmJeK2UV1YCceUwBdC4gPWQ=;
        b=PrlqCL+y+Nimhok7ieyk2TVyXiDQx4yB0yRW8G1lamoNMJe8cSroQcFYXraf2MYCm2
         Jc80fjDkgy7ZEBYmLK5rOpHb3s2w17ZeIKQtRTsqiDeQgplrNOxN40keYNIpXInzzoou
         Kc0LUE78hrq3PV2Y/yB40Ly45utldM7GHf5JCOO9JmYWlh3ZTJ3XUYJYHluOiOMnmZnJ
         tXAGDyvNjcCPSWAcQMVcqL71G7ajlOA2wucAkaCTfnQRGzSn7NVOK1U1KtIueR8P2X0K
         13/KS6twTNx0u5M3v7Mn0GQbAN5fmSGgC+Xgh0KocPXISixJMvh1JgmqJTZ6Mqo8tv6A
         KtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=4t6Go8s2wuljbP+CKsMvEmJeK2UV1YCceUwBdC4gPWQ=;
        b=Wfq0oU2dPVkRZOKLsMoqFg2cmQhUw94rHw/mY0Q25uShfsyQFaQ33mNuhuckCMpPFU
         8CHLN5km2qB/8oqjtQhyBXzmZA2tPA8MOHd4QPAHgjrIgK7ZNKVEuB6VoNpa/Fsraai2
         a/kgxmCWUN1lk7YZHYKDX2M+Jl2hOm9BsHTub3CHcCfWjKIhZ9yceD2MVjYSxiraNFSd
         jUSOtseGqdhpym0ZRF4wqO9LCRIIHPGq0lTbM786kNpiwP1dp7nwzc0U9LlxvWesQFj5
         xH6FyNiqMaqCAMCFhkq6PG0Znjg88sszzeVRU+7Q6NWe2lRDcZ26dNRiN5G6Fb/A5HJV
         +upg==
X-Gm-Message-State: AOAM532rrerlgtO9Uwg7Lm3YE+PFNT1JH6Lu5uvPAs2bdtGSNXmcMjNj
        AKCTXHxTRL9jBw4XBP6t116b3zBvQxkZrw==
X-Google-Smtp-Source: ABdhPJyVWozexVIZbyTwEL+afu4k/aEzfnibs44FZG6h5upqaXD+EqnRvGGkSuG5ZUCXPb258UHcIg==
X-Received: by 2002:adf:9104:: with SMTP id j4mr2871481wrj.198.1605264433404;
        Fri, 13 Nov 2020 02:47:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id i5sm11296099wrw.45.2020.11.13.02.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 02:47:12 -0800 (PST)
Subject: Re: [PATCH v2 2/3] net: openvswitch: use core API to update/provide
 stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <598c779c-fb0b-a9a6-43be-3a7cd5b38946@gmail.com>
 <20201113090240.116518-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c4409cfe-4d58-27da-0c0d-3c59ce508aea@gmail.com>
Date:   Fri, 13 Nov 2020 11:46:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113090240.116518-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13.11.2020 um 10:02 schrieb Lev Stipakov:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code.
> 
> While on it, remove internal_get_stats() and replace it
> with dev_get_tstats64().
> 
> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
> 
>  v2:
>   - do not delete len variable and add comment why
>   - replace internal_get_stats() vs dev_get_tstats64()
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

