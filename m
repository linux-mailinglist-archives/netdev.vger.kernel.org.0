Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E453FD562
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbhIAI2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243106AbhIAI2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:28:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD533C061760
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 01:27:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id me10so4829749ejb.11
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yv4dWe+5zR9Eg17o3TiXVhCmDqK5uxEiNmwREZM7k+M=;
        b=s11nzr5W2xmvSzzuoGIbKbr2b4UapW6iOYvNJkVtMT22tO5onkrO4XMOQD5EKzRg50
         Uy3x5CYCAZbtYZ4G5cI4aPp/wV9DIrRy5B7P+cl2SDGnS1gGtqTtEbaHdDKuGOfVtv3D
         wnCs74mKqpWprqcxymbGe0sEpgNhQ99iksZefxyDRZWSJR5w+5AdBkb1hNXv8rf81lwS
         oZaM77z/mBalUaO58AGFlT/UQr5VkMGKz+puQEdXhElRrPKQjbBCb4hrGTtDzCvMtMO3
         BVBEoTE4f3gKD1amwaPZhjFYGv/yAe7ruFdY3zAX9P3s0mmdY/ODEYQbQ8kGdIVe/Xdm
         roVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yv4dWe+5zR9Eg17o3TiXVhCmDqK5uxEiNmwREZM7k+M=;
        b=a1ao6xZDH/hG4GfKFv5jBm1OYJPYs3qmzbHD81AsoO2yXmpdp+W3Pcp5+aSmDbdMXQ
         xdeXjsfFh+pILiJQPvgPTCaQUqgwEkW1J4ebXU5YsS23jLooKhX189taW/OmlaZUAryQ
         /2sAgU+tOvxA2RBDMytD9O40pDQ7LJOruXRyZlAbihK55jNed79DpQMb4bOvz1/PtkkL
         5UVq6U0ey4239psa6C2f67DLPPaLCAaw4JI5/+0Egy3llZj5zeQdymFqOSyyf0QNNlIa
         t/GjGDy68KCSOFGoNTPZP71Uz0Rq+KFH4fKQEmdlxxCVTAzu7zI/a1tEi1BZzGgviSFI
         SVwQ==
X-Gm-Message-State: AOAM531t6P79+M5GgRBbFAtmDXAZ8rsugwrSdYgKOSoHZs05ggTuO0xA
        zdmlWTjfy1dfuplhEJxJihe05w==
X-Google-Smtp-Source: ABdhPJwGSqy5H7eFISaGvwvWddFd9h/Va3PXa82CtDhJWtiUqdHbvdgm/vd+oTOeotxcnkSSwAKCqQ==
X-Received: by 2002:a17:906:e82:: with SMTP id p2mr35579875ejf.50.1630484874379;
        Wed, 01 Sep 2021 01:27:54 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (94.105.103.227.dyn.edpnet.net. [94.105.103.227])
        by smtp.gmail.com with ESMTPSA id v1sm9895342ejd.31.2021.09.01.01.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 01:27:54 -0700 (PDT)
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
References: <20210901031932.7734-1-wanjiabing@vivo.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH] [v3] mptcp: Fix duplicated argument in protocol.h
Message-ID: <c519edd0-f263-0df0-40a3-8ba342c0a0fa@tessares.net>
Date:   Wed, 1 Sep 2021 10:27:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901031932.7734-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wan,

On 01/09/2021 05:19, Wan Jiabing wrote:
> Fix the following coccicheck warning:
> ./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |
> 
> The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
> Here should be OPTION_MPTCP_MPJ_ACK.
> 
> Fixes: 74c7dfbee3e18 ("mptcp: consolidate in_opt sub-options fields in a bitmask")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Thank you for the patch!

It looks good to me too and MPTCP selftests are still happy with this patch.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Just one thing: please next time mention for which "net" tree this patch
is for. That's why you got one warning on Patchwork [1]. See [2] for
more details.

Here this patch is for -net: [PATCH net].

[1]
https://patchwork.kernel.org/project/netdevbpf/patch/20210901031932.7734-1-wanjiabing@vivo.com/
[2] https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
