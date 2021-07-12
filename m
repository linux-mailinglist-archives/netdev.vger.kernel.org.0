Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A9A3C5E9D
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhGLOzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbhGLOzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:55:44 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2648AC0613DD;
        Mon, 12 Jul 2021 07:52:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f9so20351609wrq.11;
        Mon, 12 Jul 2021 07:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+x+zr9ONjlZOuhXr6t1OO4P+POH9dhlr8Gi6NrOJJxQ=;
        b=EujNK+zaJboWFgVsCuu5VpOBafhUz5mODdNrhLcrbNzMyfBjCaHqxWzpch6+irr+/r
         Fc1FX1XDKjdK1CJP0aIGsYvaRLqgzzZw5/Np0U89ne8jj+S4ijRpy6x9/e4l7A6o5ukW
         3H3b4la9oIQhh/xGk2/KpUWzT0teqb3XtmIiuSyuzvQ0gbELvICheFc08q5CHUqrCAO+
         zs5s3O2ulH78X2XIaCs960KEn/BsIGXYCE5Mu+vMcof0eZxxkLSWK1Zopkxi3iYlP5mJ
         lbJw/RYHLZyDdTUqNIn5FMiDl/JzNRvwcZt27EW7AeAnTdjywklaqFYwfudlpuWWcrLT
         NQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+x+zr9ONjlZOuhXr6t1OO4P+POH9dhlr8Gi6NrOJJxQ=;
        b=Ga2gCdNj6cZszwcQ0WXGmwQaJK8tQ11m9xxycPnpnIZwFONYxdK/KUIbN4oJZK7ZsN
         28CXWorNNE2qOVAJh0zZ7fQaEc3g9Tp1qp7OOCezA8b07D9Cqc5PCNDA68HKjG4M/qOu
         3QSe7c+2PALAJHxk1mq8KJfNsxYuSKfjvqGfUnVGrOD8j1UhtMUp6YUXomzn8eqUDWLD
         LMLXQKLrRStD8/UZTlFhA1yezppeeiJ/lK1JR2bYlYy3x+lElUYyXOFZ5fcwgBZIThMu
         66kwkJyu5pDzpogiBzCV0KdcwtqkEACxmsQHzClJfl0gx6hmZJF8DE7tr15tNnxI4OX+
         Dz8g==
X-Gm-Message-State: AOAM531lErOxvkHUjcjYEKTgto51Gayl/drDBIlrfr8evl+nP7qKgeaA
        XxkBkro/u/hXOCRFHlRv0UzZ1fpkR+keIA==
X-Google-Smtp-Source: ABdhPJwix3xJ1vHh8FxkOk5WGB+Cibk+iAjVo+hBFjKHoLwJbWwjtIHWTy47faz1U06tD4WN8VK+dQ==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr61111151wrn.248.1626101574829;
        Mon, 12 Jul 2021 07:52:54 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s1sm19993485wmj.8.2021.07.12.07.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 07:52:54 -0700 (PDT)
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev
 queues"
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
 <20210707130140.rgbbhvboozzvfoe3@gmail.com>
 <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
 <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com>
 <4189ac6d-94c9-5818-ae9b-ef22dfbdeb27@redhat.com>
 <CACT4ouf-0AVHvwyPMGN9q-C70Sjm-PFqBnAz7L4rJGKcsVeYXA@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <681117f7-113b-512d-08c4-0ca7f25a687e@gmail.com>
Date:   Mon, 12 Jul 2021 15:52:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CACT4ouf-0AVHvwyPMGN9q-C70Sjm-PFqBnAz7L4rJGKcsVeYXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2021 14:40, Íñigo Huguet wrote:
> That's a good idea, which in fact I had already considered, but I had
> (almost) discarded because I still see there 2 problems:
> 1. If there are no free MSI-X vectors remaining at all,
> XDP_TX/REDIRECT will still be disabled.
> 2. If the amount of free MSI-X vectors is little. Then, many CPUs will
> be contending for very few queues/locks, not for normal traffic but
> yes for XDP traffic. If someone wants to intensively use
> XDP_TX/REDIRECT will get a very poor performance, with no option to
> get a better tradeoff between normal and XDP traffic.
[snip]
> So I think that we still need a last resort fallback of sharing TXQs
> with network stack:
> 1. If there are enough resources: 1 queue per CPU for XDP
> 2. If there are not enough resources, but still a fair amount: many
> queues dedicated only to XDP, with (hashed) locking contention
> 3. If there are not free resources, or there are very few: TXQs shared
> for network core and XDP

I think the proper solution to this is to get this policy decision out
 of the kernel, and make the allocation of queues be under the control
 of userspace.  I recall some discussion a couple of years ago about
 "making queues a first-class citizen" for the sake of AF_XDP; this
 seems to be part and parcel of that.
But I don't know what such an interface would/should look like.

-ed
