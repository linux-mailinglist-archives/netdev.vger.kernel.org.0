Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5043DF05A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhHCOdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbhHCOdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:33:01 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9122C061757;
        Tue,  3 Aug 2021 07:32:50 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x15so28331675oic.9;
        Tue, 03 Aug 2021 07:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SOCfIEH2j9G9zTnYlmTQahFNZrsF6MnMcDCjvCkaZ7U=;
        b=lP89XUc0nfNSvTOOpPc3cPSFuOAv6RkXHnmAWVEF4UY+9Zrxwa/9D8bfFWJZRSW0eQ
         rTUg7+QWJInd5VlXSHN8Tc2Oi432pR3mcYABiG3pHVB4e/zOfN8jVIiBr6WZ2fj0DMWE
         13W9CrDYSlKpjtwptjS+ggiekrx9D38qFZG5TSuARkqZJ1R/Ykj/NXaIaattIj8cUfHe
         nJieVi/CuJzcrLG/5fonGGmyQvb4a0Ec640QzPRNPOWcu4OhrnH8Dr3OIZRLqu4Uj4lu
         EFOQhSb/x+GgCO3Ixtn/ewd7EvxLX/QR7IOS3Tqrfm/IQSvt0/vTBS4i9XIJOhFEVVNn
         W4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SOCfIEH2j9G9zTnYlmTQahFNZrsF6MnMcDCjvCkaZ7U=;
        b=PSRFqhvEUsK4Hp1sV6N8bT9RMqG6DWDils8GFqOM8L76JBij4j593PyliKgHHbwSH6
         DVpniWR+ClOY/HVH9gDgvyS/19pFeVVsPZKSHi1TyiBQN4IT7TAxTJKcFcpRKfthE7IQ
         vC+v28BcrJRzK8LASCzS9zVKJGPEVxG2U9B6mcPVCCxmJmqkWWbdx2R7asbWDl/juEzF
         uE0Q8g41VG6qv5EonyBtkzMtQX+Tl8SzwnShGojale6+UGfKgX+sbbexYhlQi44cm/vY
         199PsCgHlhuekucycITZU5syIwTLd0N0N1836LCQKAF+K3fuENANC2u6twDhBddOfGju
         9FrA==
X-Gm-Message-State: AOAM530K8Q+sjlj6m+mP/PDKQLQLcjWUXXimSuXQkNpGv7sQLxjBYBPm
        3y0/l/oSgeej6Vo7U7fQNAc=
X-Google-Smtp-Source: ABdhPJzmDycLIxOOfr1TXxB4X/LwSri3dv/Dr1S4HM1kwG2oCJ4Pk8l337iTvxrauijBrRCPEswIZw==
X-Received: by 2002:aca:a8cf:: with SMTP id r198mr14370480oie.143.1628001170299;
        Tue, 03 Aug 2021 07:32:50 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id b21sm2272075oov.26.2021.08.03.07.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:32:49 -0700 (PDT)
Subject: Re: [PATCH net-next] net: add extack arg for link ops
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210803120250.32642-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f6f10fe7-afdd-fdce-c091-861a738feb8a@gmail.com>
Date:   Tue, 3 Aug 2021 08:32:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803120250.32642-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 6:02 AM, Rocco Yue wrote:
> Pass extack arg to validate_linkmsg and validate_link_af callbacks.
> If a netlink attribute has a reject_message, use the extended ack
> mechanism to carry the message back to user space.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  include/net/rtnetlink.h | 3 ++-
>  net/core/rtnetlink.c    | 9 +++++----
>  net/ipv4/devinet.c      | 5 +++--
>  net/ipv6/addrconf.c     | 5 +++--
>  4 files changed, 13 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
