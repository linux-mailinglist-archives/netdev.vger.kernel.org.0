Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BDB465359
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242662AbhLAQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243570AbhLAQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 11:52:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04BBC061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 08:49:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h24so18462218pjq.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 08:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oCR74RTPFXg3q7CRJFQXZiqEchC+wJmVLauxX8CenVk=;
        b=GH5SQFTL0LNbtor/wB3hDRTeJ89uCB/ZDw++QvnlDRDl6xbByCrm78IxLotVJlIrSA
         ZRGzbBujl4TrGhnXDYe4xHwqEcBpeuGiF1fxaZa0iXDohrdmp7tY1a+nWWyqhFBunoiX
         3ml00ssi0Og5U/wZ0UqPbzHzDnPe/Liqq711HAl1zyiOK0zvtqeFDYrrtA4vnClFp5ly
         /xPxC+rNIGj8fCsswsVCUr17YSpGfAO8N1tNXdd9SwUgNmJqQn7dwr8EMJvVjXYwt+pU
         B5aOfmGyO8u+tTCW8whRebb4m4XccDIu5oDhQt0MdmrZ1/xKC1OwgEWfZVjKzIYKWwLj
         0UyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oCR74RTPFXg3q7CRJFQXZiqEchC+wJmVLauxX8CenVk=;
        b=yS/2hBt2no+W1i+LaDpSEv+WI13t3Kd+QsBBGc66caRAx+uitMQTbf/IOyRnKaJAVa
         zKwNGzNIJMeXkGnDs5XH52DHnIMH8a0+HoYF6F//OMKV+HzyGDU/CvjHrx4PlfCw+QDP
         SaFkMZhlh7Xn67KaDFdsZQurGF5AolkTpWtN2FtkWAOQxAsTbKHgi5V5H1XwXOBlEfcy
         s8N8XBdghiGK1iy6bgMy68RDxoCQZ9skeqh1QpzIvzC/31rFhpCvWHdse6gdkhKL6a28
         mdps/e0ce2OzdiLaUv9n/EG/lL404jlF7hywzSUK631j6WQN4qBQyFMjuZvGZdA/g04K
         2I1w==
X-Gm-Message-State: AOAM530f5LKOghF6fBtvUtmS3koaPq4HzAnISkmxngZBnQMzwsviqyAV
        hUcag6clc+W8XckkPkfUtkIXRNMhk4U=
X-Google-Smtp-Source: ABdhPJwJO219JewWzGTln4tSw1Uw1dBPKSmbGoEXm0L85MPEP37hyJBdilC9s6cb1ZCLDk1rgRLYAQ==
X-Received: by 2002:a17:902:f2c2:b0:141:9ce8:930f with SMTP id h2-20020a170902f2c200b001419ce8930fmr8584206plc.68.1638377371419;
        Wed, 01 Dec 2021 08:49:31 -0800 (PST)
Received: from [192.168.86.22] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a6sm115684pjd.40.2021.12.01.08.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 08:49:31 -0800 (PST)
Subject: Re: [RFC PATCH v2 net-next 0/4] txhash: Make hash rethink
 configurable
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     Alexander Azimov <mitradir@yandex-team.ru>, netdev@vger.kernel.org,
        tom@herbertland.com, zeil@yandex-team.ru
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
 <69C55C6B-02FC-429D-BD25-AA0D78EADCFF@yandex-team.ru>
 <82E7E49A-5EB9-4719-87FC-836718A031A9@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
Date:   Wed, 1 Dec 2021 08:49:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <82E7E49A-5EB9-4719-87FC-836718A031A9@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/21 1:58 AM, Akhmat Karakotov wrote:
> Hi Eric,
>
> I wonder if you have time to provide review regarding my last update to the patch.


Sorry, your patches did not reach me. Can you resend them, adding

"Eric Dumazet <edumazet@google.com>"  address to make sure I can catch 
them ?


Thanks !



>
>> On Nov 23, 2021, at 16:20, Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>>
>> Hi Eric,
>>
>> I've sent v2 of the patch. I've removed confusing part with sysctl default values
>> and made other changes according to your comments. I look forward for your
>> review.
>>
>>> On Nov 12, 2021, at 21:19, Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>>>
>>> As it was shown in the report by Alexander Azimov, hash rethink at the
>>> client-side may lead to connection timeout toward stateful anycast
>>> services. Tom Herbert created a patchset to address this issue by applying
>>> hash rethink only after a negative routing event (3RTOs) [1]. This change
>>> also affects server-side behavior, which we found undesirable. This
>>> patchset changes defaults in a way to make them safe: hash rethink at the
>>> client-side is disabled and enabled at the server-side upon each RTO
>>> event or in case of duplicate acknowledgments.
>>>
>>> This patchset provides two options to change default behaviour. The hash
>>> rethink may be disabled at the server-side by the new sysctl option.
>>> Changes in the sysctl option don't affect default behavior at the
>>> client-side.
>>>
>>> Hash rethink can also be enabled/disabled with socket option or bpf
>>> syscalls which ovewrite both default and sysctl settings. This socket
>>> option is available on both client and server-side. This should provide
>>> mechanics to enable hash rethink inside administrative domain, such as DC,
>>> where hash rethink at the client-side can be desirable.
>>>
>>> [1] https://lore.kernel.org/netdev/20210809185314.38187-1-tom@herbertland.com/
>>>
>>> v2:
>>> 	- Changed sysctl default to ENABLED in all patches. Reduced sysctl
>>> 	  and socket option size to u8. Fixed netns bug reported by kernel
>>> 	  test robot.
>>>
>>> Akhmat Karakotov (4):
>>> txhash: Make rethinking txhash behavior configurable via sysctl
>>> txhash: Add socket option to control TX hash rethink behavior
>>> bpf: Add SO_TXREHASH setsockopt
>>> tcp: change SYN ACK retransmit behaviour to account for rehash
>>>
>>> arch/alpha/include/uapi/asm/socket.h  |  2 ++
>>> arch/mips/include/uapi/asm/socket.h   |  2 ++
>>> arch/parisc/include/uapi/asm/socket.h |  2 ++
>>> arch/sparc/include/uapi/asm/socket.h  |  2 ++
>>> include/net/netns/core.h              |  1 +
>>> include/net/sock.h                    | 28 ++++++++++++++-------------
>>> include/uapi/asm-generic/socket.h     |  2 ++
>>> include/uapi/linux/socket.h           |  4 ++++
>>> net/core/filter.c                     | 10 ++++++++++
>>> net/core/net_namespace.c              |  2 ++
>>> net/core/sock.c                       | 13 +++++++++++++
>>> net/core/sysctl_net_core.c            | 15 ++++++++++++--
>>> net/ipv4/inet_connection_sock.c       |  3 +++
>>> net/ipv4/tcp_output.c                 |  3 ++-
>>> 14 files changed, 73 insertions(+), 16 deletions(-)
>>>
>>> -- 
>>> 2.17.1
>>>
