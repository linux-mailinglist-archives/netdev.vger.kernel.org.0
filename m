Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E282F5A06
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhANEsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbhANEsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 23:48:23 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C260C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 20:47:45 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id x13so4711142oic.5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 20:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TpaFTtQGBITkh7gnwnwRnxfc1yeL6k+ojODqTkBdYPA=;
        b=MK0ZqXZnn3bKw9+cxy1sR1SHP/E3yW9PuaOkIH/fIqpBgsM8GKRPI5uZdKuZqhGFhk
         pWB+ACP+63FDfrBvDeftcZ+ltL2iSzlOWQBW6ivxqBQ70kwRvYuEnyTIloXxc+IZ44oP
         TrzEcg9XFzCeD++U3lhpSv3RozGpGs8DLvbcMB0k+MG10TFeYB3XMaLnr91rspyu9xLU
         LZzD9lYZE4PM37HKsX9pxdHV5zClV7zYhglBK+5Q5B3lhppzBYEhkF5o6xNOi1CSR2oj
         wdb6qvJXfnaZT4r9dDRBt/QR4L9RWvhSe7EZNdDduNdwp1VMW31UZ7IynLnfsEiqQL4C
         3asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TpaFTtQGBITkh7gnwnwRnxfc1yeL6k+ojODqTkBdYPA=;
        b=uSdBsKgCbgsN+3OEpzhl4oJ4PLf05Z6R5VTayrbpljMe4ZcD7nFubuULXdXQtUGIV+
         Mx3lHztzOnKNwyUD0w7AQf5FgmF3htkgH5DJZQuUvjeJBbyzY52v1c7kGb+1wfeTHkML
         ZgQV8WKOlBwECcxCUW0YhiAQghjenF1pbq0oprOIUEHALIlw0IXY57zuMwz0UTAh4ekA
         8CaLsUe6iiUxOgAKURy/AOH6Ry1ku0LBEG3mHAyeJ2NX/8tfN99g7z20/b2a4NmHNJ5W
         EnhMFdI0BsKwrzIIX+mDkNhSDYP4hQqhHZP7FhAYvxF0ZddlKXqFrUodWXmze0hu0U/Z
         CXdw==
X-Gm-Message-State: AOAM533PJyB5KkfWxoNp10HJ1RO6v7ZQlDBaLa44ZKQDSPXjImxUXK/e
        Tx3Iwc9G5P/52kNaPYMChMo=
X-Google-Smtp-Source: ABdhPJzHylTd5odVg7AypxBwPKvcXHwkdIOlKdkEMQKSV44dkjFxzolrbu8aTTH9quUDrCuiPkp9yQ==
X-Received: by 2002:aca:cfc2:: with SMTP id f185mr1602038oig.136.1610599664585;
        Wed, 13 Jan 2021 20:47:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id z38sm888614ooi.34.2021.01.13.20.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 20:47:43 -0800 (PST)
Subject: Re: [PATCH v1 net-next 00/15] nvme-tcp receive offloads
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     yorayz@nvidia.com, boris.pismenny@gmail.com, benishay@nvidia.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        ogerlitz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <967ae867-42c9-731d-9cb1-2c81fcc1ef77@gmail.com>
Date:   Wed, 13 Jan 2021 21:47:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/21 6:27 PM, Sagi Grimberg wrote:
>> Changes since RFC v1:
>> =========================================
>> * Split mlx5 driver patches to several commits
>> * Fix nvme-tcp handling of recovery flows. In particular, move queue
>> offlaod
>>    init/teardown to the start/stop functions.
> 
> I'm assuming that you tested controller resets and network hiccups
> during traffic right?

I had questions on this part as well -- e.g., what happens on a TCP
retry? packets arrive, sgl filled for the command id, but packet is
dropped in the stack (e.g., enqueue backlog is filled, so packet gets
dropped)
