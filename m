Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1346092A
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 20:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhK1TEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 14:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhK1TCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 14:02:44 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE57C061574;
        Sun, 28 Nov 2021 10:59:27 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id p2-20020a4adfc2000000b002c2676904fdso5021064ood.13;
        Sun, 28 Nov 2021 10:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B9P6WMjxC8/fIqPYLfI9IFXh8XTtDuAHtkDHh/xjesY=;
        b=V+OvyCxa+39vWxiqtXWpngGTm/XQgxkkldgc4jo1vhX4F2zgPR3uBM/J3aafMKYNay
         VwnV6JldZVH5VyqNbkbX7ie61+IAiIFBjpu61e8GT+CwdGSGvAsHSY49hLVkI7Jtm+25
         3YOXovZdT4KQg1agn1JLA9Ii+cB+k9HEKH0TpuiyYckybeqnTsI/eCS7KRkyVPVhm2a5
         xTJJaKT/OlX+9yEUWkpZOQlIQtjsaszScAgnxZl/jePeCNOn63lblzHlSftlQm/VsdSp
         OJZhR/qwVkjf3gdI3/VimyrYEUVo4uGQcNGZCx8UZdn1ZgcXlktl12mnUf4nffvxs7SY
         vr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B9P6WMjxC8/fIqPYLfI9IFXh8XTtDuAHtkDHh/xjesY=;
        b=cTsxLc/zzIjlqTnQMAmJcCEyhikNa4YYSq+5eXU0n4jMsxb7ibQqFqE7rM8f+xeZ/b
         Zx+w87eCCVMxk01GK96hWsU6s2ube/knFxVa9uOJUdouTYZtErIOdk29CIGEZsArKz7K
         VSGtDvrC97vJBV9L8+vGdh0XwnXxHZlNnar3RRfFgeRAG3lnjwpJNGZWlPJzGemcAoMU
         2TpUhDQ99InV987fv/YZl+AsMXCJi72Dr4eqMNkSBXGcHl+ADOH5kd+uQZ3GXSzGNBdX
         KdN9lNUDZOUmeO+wWu8VmK1ViC62f9V0fs2BR+WOqpcTi2GHdxyXHmmsiepLOuo0wgwx
         JIdA==
X-Gm-Message-State: AOAM531n3onHu4KCU9n6HQFPne+GeaoDBav+qWCJ/9zG5AP8ym7ceKCb
        0/mvs5IWrcDcm2/pV/2sWhY=
X-Google-Smtp-Source: ABdhPJz3P1jvKnuMrqZtoEu0CxuIbJ7H4HqjKYVa4XCzwl+Jc/6qrzbHLM426V7D+HD+Z4ieDW+XIA==
X-Received: by 2002:a4a:e4c9:: with SMTP id w9mr28077105oov.10.1638125967183;
        Sun, 28 Nov 2021 10:59:27 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 3sm2465888oif.12.2021.11.28.10.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 10:59:26 -0800 (PST)
Message-ID: <75f4ceed-b556-42ca-0a87-0bc0539139bb@gmail.com>
Date:   Sun, 28 Nov 2021 11:59:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH nf] vrf: don't run conntrack on vrf with !dflt qdisc
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, fw@strlen.de,
        pablo@netfilter.org
Cc:     lschlesinger@drivenets.com, dsahern@kernel.org,
        crosser@average.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/21 7:36 AM, Nicolas Dichtel wrote:
> After the below patch, the conntrack attached to skb is set to "notrack" in
> the context of vrf device, for locally generated packets.
> But this is true only when the default qdisc is set to the vrf device. When
> changing the qdisc, notrack is not set anymore.
> In fact, there is a shortcut in the vrf driver, when the default qdisc is
> set, see commit dcdd43c41e60 ("net: vrf: performance improvements for
> IPv4") for more details.
> 
> This patch ensures that the behavior is always the same, whatever the qdisc
> is.
> 
> To demonstrate the difference, a new test is added in conntrack_vrf.sh.
> 
> Fixes: 8c9c296adfae ("vrf: run conntrack only in context of lower/physdev for locally generated packets")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  drivers/net/vrf.c                             |  8 ++---
>  .../selftests/netfilter/conntrack_vrf.sh      | 30 ++++++++++++++++---
>  2 files changed, 30 insertions(+), 8 deletions(-)
> 


Good catch. Thanks, Nicolas.

Reviewed-by: David Ahern <dsahern@kernel.org>
