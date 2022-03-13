Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD794D7505
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 12:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiCMLmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 07:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiCMLmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 07:42:04 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7572AA1467;
        Sun, 13 Mar 2022 04:40:56 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id x15so19636493wru.13;
        Sun, 13 Mar 2022 04:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5hpgio9pD8hulFoquYbcjRBj0pBDXvlxYZEsR0wPc6k=;
        b=Tx4bUexNmturhJojYxCZKSttGkbPIA5NQWc9mTbMDDtna6Phaz5q+q4bRhmI2GrVZb
         GM8UGfqTrRh0vW1+BR9GpwuvWwTlTl0VllfCxmwqGJGtRRSjtqKphuFF4EayKX4sv5Gc
         gtOfST8tCzhujZ5vPqHti1yLHLsGRFrQd0hnWm0jptYdQJn7ActI2juxFvV2VTIKOfnU
         xpqjIYbTGBG4G/ERJbhDL0rpI+wy5tIi6eHtnBle6d1gdwMGk2yVpgwl26uK6fnOQ9yp
         cHArGeOMaKg7+ub00TU3R52AElXdD/njU3TJEf+BZJpIwb01mjppJGQGLc07CbUPZEeb
         JIOQ==
X-Gm-Message-State: AOAM531Gxuh5gYOxN0Zb+zmRwqyNrK+TFoYh5yhlFymsSVcjke9oONfs
        Z93HxK5myvxpCilxDvLLUXA=
X-Google-Smtp-Source: ABdhPJy1IlZerQti3MqLer/rw/mvsghVdBsTdaWqbe8Oz2N2hoosfT3mSJ7cYydWJ0YhpGxxMbxpDw==
X-Received: by 2002:a05:6000:18ab:b0:203:731d:1ac1 with SMTP id b11-20020a05600018ab00b00203731d1ac1mr13288082wri.411.1647171654840;
        Sun, 13 Mar 2022 04:40:54 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id l126-20020a1c2584000000b00387d4f35651sm15209301wml.10.2022.03.13.04.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 04:40:54 -0700 (PDT)
Message-ID: <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
Date:   Sun, 13 Mar 2022 13:40:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Content-Language: en-US
To:     Mingbao Sun <sunmingbao@tom.com>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
References: <20220311103414.8255-1-sunmingbao@tom.com>
 <20220311103414.8255-2-sunmingbao@tom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220311103414.8255-2-sunmingbao@tom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Mingbao Sun <tyler.sun@dell.com>

Hey Mingbao,

> congestion-control could have a noticeable impaction on the
> performance of TCP-based communications. This is of course true
> to NVMe_over_TCP.
> 
> Different congestion-controls (e.g., cubic, dctcp) are suitable for
> different scenarios. Proper adoption of congestion control would benefit
> the performance. On the contrary, the performance could be destroyed.
> 
> Though we can specify the congestion-control of NVMe_over_TCP via
> writing '/proc/sys/net/ipv4/tcp_congestion_control', but this also
> changes the congestion-control of all the future TCP sockets that
> have not been explicitly assigned the congestion-control, thus bringing
> potential impaction on their performance.
> 
> So it makes sense to make NVMe_over_TCP support specifying the
> congestion-control. And this commit addresses the host side.

Thanks for this patchset.

Generally, I'm not opposed to allow users to customize what they want
to do, but in order to add something like this we need a few
justifications.

1. Can you please provide your measurements that support your claims?

2. Can you please provide a real, existing use-case where this provides
true, measureable value? And more specifically, please clarify how the
use-case needs a local tuning for nvme-tcp that would not hold for
other tcp streams that are running on the host (and vice-versa).

3. There are quite a few of TCP tuning knobs that will affect how 
nvme-tcp performs, just like any TCP application that running on Linux.
However, Application level TCP tuning is not widespread at all, what
makes nvme-tcp special to allow this, and why the TCP congestion is more
important than other tuning knobs? I am not supportive of exporting
all or some TCP level knobs as a local shadow for sysctl.

Adding tunables, especially ones that are address niche use-cases in
nature, can easily become a slippery slope for a set of rarely touched
code and interface we are left stuck with for a long time...

But while this feels a bit random to me, I'm not objecting to add this 
to the driver. I just want to make sure that this is something that is
a) really required and b) does not backfire on us nor the user.

> Implementation approach:
> a new option called 'tcp_congestion' was created in fabrics opt_tokens
> for 'nvme connect' command to passed in the congestion-control
> specified by the user.
> Then later in nvme_tcp_alloc_queue, the specified congestion-control
> would be applied to the relevant sockets of the host side.

Specifically to the interface, I'm wandering if this is the right
interface... The user is used to sysctl with the semantics that it
provides, wouldn't it be better to expose the exact same interface
just for nvme-tcp sockets?

Something like sysctl nvme.tcp_congestion_control ?
