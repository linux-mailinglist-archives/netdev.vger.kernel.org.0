Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5664D2D7E4B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbgLKSo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgLKSoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:44:13 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BF9C0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:43:33 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r3so10068369wrt.2
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zdJOjs4dTsfUx4y7I8FwfWeld9WmUm3RT92AXbQ7uCk=;
        b=WxRGxYL08TEYNZHjLDqOYS9lXzrSamCXC6RJC07gJfBWKY9nQp4wJ71jwaCxpZcrnF
         VWguMXHh6INfY8IM/GS1xha/1tqEUnQm9oYWX/nctHYvkA5Iwd47ZEFV4nleU+miRp/Z
         BcJydnVWEd/Bm7HJ27p+KNUGMFyPX0OdQiZx4KHe8go3uL9vDyo9Z2OG43dk7PQvw8ns
         pU/SaeSBGJKfCv1GJkF5QSleqe0jxeGFvE8QqbMOY4d4fp3DAe55muZGdrzKwWIC73JC
         0w2NarE8kqgBlogU6HBBcuQYT+AE5VU8NPErcjHonvEljy2k66fyu3gNkq1IOnWJ1QKm
         1vqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zdJOjs4dTsfUx4y7I8FwfWeld9WmUm3RT92AXbQ7uCk=;
        b=JcXSEIbExviDBX7+lDE5cUhwNZ3vAbCoKw+9UNq59R4aql6OwITcrONy6NeexRcco/
         SWCnqF/hB/xk3mzMZzuNzRyi0zWi2bSh8amwZi8/HpRfHXUy9HXPewynMzs8IN5O2TKz
         eVlmd2SW5hgZOfUCkxcoM/LRbD917SdFXRUSpE7VdbklW08hnfuqDAMyIjKKo/RUc+GN
         Tll6HENOEbCdhMeAh0egKI2uF12rup7ew5BTb91dMbnMdSLbg1guVbM9+AYkSb1WZQH2
         4PESkw6WtAxIfnhTSOl7f7fkiztb6oNAgY+AV6Ey0+iOJa11J2NIKUUPn2XVHew8XnCs
         J19g==
X-Gm-Message-State: AOAM5308poeKFXbH80zFXsV1XtkbOqn0OtPL0pPekp1kf5xvrWxf5rtn
        zOGiToiMjkHtL7fWv/ezxIo=
X-Google-Smtp-Source: ABdhPJwjehiuk7uz83zaxeXY6J28+VwLRyO3Lo50+MZF1WOP0Ke+pyo1OwjcI6Vbe82aJm+ibH05Xg==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr5254294wrw.399.1607712212101;
        Fri, 11 Dec 2020 10:43:32 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id p19sm19744861wrg.18.2020.12.11.10.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 10:43:31 -0800 (PST)
Subject: Re: [PATCH v1 net-next 04/15] net/tls: expose get_netdev_for_sock
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-5-borisp@mellanox.com>
 <f38e30af-f4c0-9adc-259a-5e54214e16b1@gmail.com>
 <104d25c4-d0d3-234d-4d15-8e5d6ef1ce28@gmail.com>
 <ae89bba7-2541-e994-41da-fb791ced7aa7@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <da5594c1-47ed-e4aa-4c28-7b61529399fd@gmail.com>
Date:   Fri, 11 Dec 2020 20:43:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ae89bba7-2541-e994-41da-fb791ced7aa7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2020 5:39, David Ahern wrote:
> On 12/9/20 12:41 AM, Boris Pismenny wrote:
> 
>> is applied there is relevant here. More generally, this offload is
>> very similar in concept to TLS offload (tls_device).
>>
> 
> I disagree with the TLS comparison. As an example, AIUI the TLS offload
> works with userspace sockets, and it is a protocol offload.
> 

First, tls offload can be used by kernel sockets just as userspace
sockets. Second, it is not a protocol offload per-se, if you are looking
for a carch-phrase to define it partial/autonomous offload is what I
think fits better.

IMO, the concepts are very similar, and those who implemented offload
using the tls_device APIs will find this offload fits both hardware drivers
naturally.

To compare between them, please look at the NDOs, in particular the add/del/resync.
Additionally, see the similarity between skb->ddp_crc and skb->decrypted.
Also, consider the software-fallback flows used in both.
