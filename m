Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFF1B916B
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgDZQDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZQDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:03:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2418C061A0F;
        Sun, 26 Apr 2020 09:03:21 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u189so14391049ilc.4;
        Sun, 26 Apr 2020 09:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gM1zLb2VprrXVVyNgONb3K01QXl3DJ4XTL2qYslX44g=;
        b=fDLHjiiEVIZxnSyZTwEUGxLLb3apbVNIOXPDwSEIEDFdECyxMF2eTYon6gH1bWHcKX
         mklIE38mSSoZ++dLulEpCglcfYjAYrzEKwibnpb32QmBFBbRvyaulEhGnX8+qoW4qwKp
         DTzkJ9UKv0VW8v7SJl6m4r4V5wzED//i3J4ug2Hmq4enZ4yOPoH6KfDVh0ZOcQpSy6Ow
         v2Hdd3fpGxdTmw1pOLC4OBsp/zDtKw9aMBmdfkff4wseV2DaUjKnJZGLGrdfXFtnWy26
         t3Ho90GhwXy8Pg4mqb4uPBD2EJ1Spdcqzxm8WLDHjhPMpPR9h021WZs5hqmFpFs1fY+N
         l6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gM1zLb2VprrXVVyNgONb3K01QXl3DJ4XTL2qYslX44g=;
        b=UE435IUIAb9e4c7ya9xqLZ0gPM90TgXpCR3IrZOV2BVGTyEVN8XvRIAIz9hBAAe8hT
         +/4fnGdRJVHidUlK3jmfnRRUYrH4Yg+4zQpuxjqKNQJIqFxbyjNZeWzgApwMf/kc9EPd
         AfQxjZTAYIabRapKfskj91AEFnF/FlkJQdwygaCp1KW0Hm5J4P/MulqaCouIqQVMf8DY
         fzgG/rSM9TfcAnI4Nv3IE69gWOtzIfo7HZ5pGGzhalQuZXbbcv69DuZ2/z0uC9RUZDFF
         dzTnavFzAipW4dRa5xq0Mty5FR35U0D2V20dUbAWSeA+6QJ+SQ64Kfapj1RbZYUoyMMZ
         5vIg==
X-Gm-Message-State: AGi0PuZlGocsjAW3a6HYQappSisJOuPKDCAzWV0y6/RswnPJHrfKs+gK
        UYQERr/+L+TS6FyPsAcfyCw/u6AK
X-Google-Smtp-Source: APiQypJRWuIiJzke2AHVt0VWrQsfEUm/HJN2o7/pWSM0IlwG9Wx3jDI4AZFf7XL4piT3yPyErUT/zQ==
X-Received: by 2002:a92:3a48:: with SMTP id h69mr16833427ila.150.1587917001077;
        Sun, 26 Apr 2020 09:03:21 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id n6sm4101251iog.16.2020.04.26.09.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 09:03:20 -0700 (PDT)
Subject: Re: [PATCH V6 mlx5-next 01/16] net/core: Introduce
 netdev_get_xmit_slave
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-2-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e3a9bb52-7ac5-e31f-30b8-74eab8db80b2@gmail.com>
Date:   Sun, 26 Apr 2020 10:03:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426071717.17088-2-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 1:17 AM, Maor Gottlieb wrote:
> Add new ndo to get the xmit slave of master device. The reference
> counters are not incremented so the caller must be careful with locks.
> User can ask to get the xmit slave assume all the slaves can
> transmit by set all_slaves arg to true.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/linux/netdevice.h | 12 ++++++++++++
>  net/core/dev.c            | 22 ++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

