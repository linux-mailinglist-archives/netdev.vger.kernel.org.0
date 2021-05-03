Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F973716DC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhECOpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhECOpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:45:39 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CDAC06174A;
        Mon,  3 May 2021 07:44:46 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id v24so5592567oiv.9;
        Mon, 03 May 2021 07:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6dkv1diytowCkvVVBDe3P56VdfrlcPPTRc/t0hgxBUs=;
        b=gKJpHRFyBXao+qZ4Tt4X8Fz6f/f7n0hpHarXlfd1k8R+G4OB/+ibnU3L+PAnBRQyFA
         u8Dh+ZsXDgV3+LDcaSuqFMmuiDTYyPWeOIKx5/73cGBbSNJT/wNFcAcoL2G61G7TwwEg
         pGIDSlpCX/B0SDqDQUnCtiIaAr4FhqU6HqXlqXW3UTI1nTZTSwyKVYUhC6AWDHK6PpFo
         8ngdzo3ri0MYZ3X7Laca2KrB07am+yKyDZI6kHZRcIb+4QqEfCvdbnRBzF7qla9OXxw4
         4WbY5vmCmOxf8Au5zKmpeqXpmoeCf/4b0mP6Em7YNBIjJIjpCpRBU6/ypO7bjd+hH1dz
         XiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6dkv1diytowCkvVVBDe3P56VdfrlcPPTRc/t0hgxBUs=;
        b=USC1xwadicJfWnwyia9PRn3dLyqVJouGUoZAZnGrQyBt2JzuARn/8Xg84dO5DTnYAQ
         Ie+3tNX8bzTAqpI/UE4wLUe3luFmX08yJSWxClv8u5ajt4cqB8+Hvt7wnicEYYXWsNgH
         o8cSdVRv8pGubuC35KI6AI+zI4t9Y3r3VsnQhlhsJ2ne55WzfV5t3eb6dO6QIrFrx6nq
         FsqMFp/0JQ3s63G1M4V6jlZacWZcySSE+Bejzh39LefxNEbuqZe51jaXOmlYoyK3zmCS
         1Y8m1uzBf1dgT1l83A6b/I/kORQoH7ju+EmEuzhs+SUCSa8fPcWT8iW+aafJicQrasFb
         mFeA==
X-Gm-Message-State: AOAM531qNmg0WzR426IwBvV8DLowN4EFjF3Dl7f1U7yCHfb5bIj9Wyh9
        uSLIbLl9Y0wWOuhjqnhwFjc=
X-Google-Smtp-Source: ABdhPJwWs4dF9JkdG0wp3no7YgV70u43/cyLduOygM7cE3NXALRe0dsmwywxq4FjenXK+Q9W0VyPrQ==
X-Received: by 2002:aca:488f:: with SMTP id v137mr3865337oia.173.1620053085795;
        Mon, 03 May 2021 07:44:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id d62sm2752650oia.37.2021.05.03.07.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:44:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/2] Add copy-on-fork to get sys command
To:     Gal Pressman <galpress@amazon.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20210429064803.58458-1-galpress@amazon.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bc278121-ed27-597b-cbc7-38129a58b7e1@gmail.com>
Date:   Mon, 3 May 2021 08:44:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429064803.58458-1-galpress@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 12:48 AM, Gal Pressman wrote:
> This is the userspace part for the new copy-on-fork attribute added to
> the get sys netlink command.
> 
> The new attribute indicates that the kernel copies DMA pages on fork,
> hence fork support through madvise and MADV_DONTFORK is not needed.
> 
> Kernel series was merged:
> https://lore.kernel.org/linux-rdma/20210418121025.66849-1-galpress@amazon.com/
> 
> Changelog -
> v1->v2: https://lore.kernel.org/linux-rdma/20210428114231.96944-1-galpress@amazon.com/
> * Rebase kernel headers
> * Print attributes on the same line
> * Simplify if statement
> 
> Thanks
> 
> Gal Pressman (2):
>   rdma: update uapi headers
>   rdma: Add copy-on-fork to get sys command
> 
>  rdma/include/uapi/rdma/rdma_netlink.h |  3 +++
>  rdma/sys.c                            | 11 ++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 

applied to iproute2-next
