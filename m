Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949B71B7E7A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgDXTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgDXTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 15:01:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55023C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 12:01:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x4so11796430wmj.1
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 12:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fuVH2zlAk3e6K7JvE8Krj1RMsqD9P58GyyY6EtX13Eo=;
        b=DOU0z6Tk5K2khHa7ZaBEvV3VKJF9JsfsKcE9LO/NjVmP8p/Fc0I+PIF4NKoC28hszq
         +O2YoHQoiFg/VEWodK/Zb660WBnSxX894I6rsXq/Rr987mTKt1U1o4DSiCVzI6jfyjLY
         iPX+Irn6+xkiO6/2/trFXghBF5HyckCBHQOcoF6rdSixHygHsiuwaE3WqqZemwtuk61Y
         ykUJVc2sKyWi+7iYduNMS+4BwfJQ5NtHheT6Zr7aSFjLPlo5jtOgg5yQtui8HkayOeXD
         Ef4ia126JB3eYaXmQkzOSaOq8EBZ46irpHWEtCdB19lHIkaY2a6Esyviyq6QhiUnSfhl
         Usww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fuVH2zlAk3e6K7JvE8Krj1RMsqD9P58GyyY6EtX13Eo=;
        b=Fm3bV3F6GymjAzcgK/ZkwnLcyCO/ws5ZBJ8Ms4eeVjxgc5ZGg5fqBbGFwRNOM4Cz57
         foqBSiyhpa17SFMn5b4Gv09qh9+9MxQr2vexohauc2yV2jGj36Xm283rlS+NTcqvZZv6
         rpteQA3/L3hipXv0F9vLHBzYhID2MjLXOg40FapV6MMzw3FePwXZTwZQcyEDBNzJMZNY
         sKxPO42Ur96t2l+KgDkNzpo9bqCs5gflZDiCUyLK8c0ef5k5a7VFwFNXAT6/cSmrR5TF
         TyCkEekmCH6+iFp/yCklsvoQ7M8u6tfYTpNmVJ2IGL4p5LyNPMam5HkR9tv6G/jthHJG
         MVqA==
X-Gm-Message-State: AGi0PuYt7oxfK1LHPSbhhG1RPQBXs7KthpGzuSDj1hrG1kbsvdH0cUxm
        PEbjezLSJkDCHMV1U27xe9oAz+oUfkA=
X-Google-Smtp-Source: APiQypL1aPIh9d8uaedrNWxzPLmH79gedWWPlfs8qqd15Op3NFG2ta2f6IJS9S6M2xgAfBDzSRcI5w==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr12111534wme.126.1587754887822;
        Fri, 24 Apr 2020 12:01:27 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.129])
        by smtp.gmail.com with ESMTPSA id q184sm3878375wma.25.2020.04.24.12.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 12:01:27 -0700 (PDT)
Subject: Re: [PATCH bpf] bpftool: Respect the -d option in struct_ops cmd
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200424182911.1259355-1-kafai@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <8fd56f56-0b2e-472d-0e8c-a9f4e80c057f@isovalent.com>
Date:   Fri, 24 Apr 2020 20:01:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424182911.1259355-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-24 11:29 UTC-0700 ~ Martin KaFai Lau <kafai@fb.com>
> In the prog cmd, the "-d" option turns on the verifier log.
> This is missed in the "struct_ops" cmd and this patch fixes it.
> 
> Fixes: 65c93628599d ("bpftool: Add struct_ops support")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Looks good to me, thanks!
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
