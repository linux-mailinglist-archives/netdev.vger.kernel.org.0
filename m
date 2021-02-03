Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7530D5AE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhBCI52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:57:28 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51983 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhBCI5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:57:25 -0500
Received: by mail-wm1-f50.google.com with SMTP id m2so4688859wmm.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:57:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qRDMPPpE6Q0BZsDXBuCzb37H2VewHWoPubkDh6Tm0Ak=;
        b=ejqj3MjsgmKKF5yM3Tm15+wKs6wYFDGpweMO5V5/q5//aoXQg5loTYrE6jr0H2lqe2
         s0ULKwAJen2Ve1o9NjxddsZPlpYn/sFtujrIt5YpFBv2h4PfJYB8QFDn+lg/1X1FchSQ
         YOWwvTXNgiwla/FjkedegjdEmN1nZmRCmrO3Hgw9cCQ5eeTObdF8UMVe5RYwMV0Wxu6+
         rk9FREcMlI6G7DSCck8DX2JFjlH8wUpr2q8VsS2bWjyQ8n/fEuSIOIpgNuyWheecFmF+
         9l0/BuREg7AdHM1lbPqdM1OEdUo0PmDSwMTiCimplV7poBLoUgTJ/OhGFA/XNwn8NqVr
         nWFw==
X-Gm-Message-State: AOAM530p33axxD0ElM2ifQcnEFRBDYh4p1HoQh/0mNzk4VgL6iRbPS4k
        vgtUSTNq0XZNPhnQZgCILH4=
X-Google-Smtp-Source: ABdhPJx2ARjyWIx1QP1gDjMCDFN2nXVrSB4da8n9sQfc67KWntpJplt7teI4c26GLv8D4A4I0LaaUA==
X-Received: by 2002:a1c:4303:: with SMTP id q3mr1792240wma.3.1612342603121;
        Wed, 03 Feb 2021 00:56:43 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:819b:e1e8:19a6:9008? ([2601:647:4802:9070:819b:e1e8:19a6:9008])
        by smtp.gmail.com with ESMTPSA id b4sm2421732wrn.12.2021.02.03.00.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:56:42 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Or Gerlitz <gerlitz.or@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, axboe@fb.com
Cc:     Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        yorayz@nvidia.com, boris.pismenny@gmail.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-8-borisp@mellanox.com> <20210201173744.GC12960@lst.de>
 <CAJ3xEMhninJE5zw7=QFL4gBVkH=1tAmQHyq7tKMqcSJ_KkDsWQ@mail.gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <80074375-2d37-d9b9-afbe-1f3d1db4a41f@grimberg.me>
Date:   Wed, 3 Feb 2021 00:56:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMhninJE5zw7=QFL4gBVkH=1tAmQHyq7tKMqcSJ_KkDsWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Given how much ddp code there is can you split it into a separate file?
> 
> mmm, do we need to check the preferences or get to a consensus among
> the maintainers for that one?

Not sure if moving it would be better here. Given that the ddp code is
working directly on nvme-tcp structs we'll need a new shared header
file..

Its possible to do, but I'm not sure the end result will be better..

