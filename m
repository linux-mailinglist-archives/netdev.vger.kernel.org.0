Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174776A0D00
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjBWPds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbjBWPdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:33:47 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B921A19BE
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:33:44 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id o38-20020a05600c512600b003e8320d1c11so2899781wms.1
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:33:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z6hXYN8j62FdMOuIHfGnONjGoCuAo9ox8KU2kT7xN5I=;
        b=kL3fdcBUx3XiNH3dE1fDgOYjhJ1ZPiHfxc5dNl9SbJzEuJiJhZFXjzL5D4VjlnaWlh
         m0269zNZS0jzTdYkE8tj8GT20AaH4ylrBqWbGni76plCTIuDsgJpsxD6cC7Ro/KEV3aj
         KTykwMsk3ISd+MDaUzJ/Z9cHNua+5YyLkZ1N48NXKDrQdBMEZKm31Dabt4AEZlD3Yu2q
         S7LpMcUki+qYHhkx34kC2CstLRDoI9rnCKPBCLrfvT12DYVlv60RuEzN0WY6oJoXA0OH
         hQRX2hEr30hG3lz9uUbnlkUoP4UNN8zH+6CXSFXIV0FmHwMcF7/zKHekPjL2L3MsyNzI
         HbwQ==
X-Gm-Message-State: AO0yUKWmD95lOo/k75cCcclU/pcXa9p1lwTb9jFFDYnDn2DZQ/JWjdNp
        Cbzto5pqc0Jt3wbR0J2ZTo8=
X-Google-Smtp-Source: AK7set8H9eIuX3XvQveK6S6sVV3dnOv6DtpjIG/yxFwYLXs40/SLN5hc0pHZXNkxrAzWCP4r/JWM1Q==
X-Received: by 2002:a05:600c:28e:b0:3db:2922:2b99 with SMTP id 14-20020a05600c028e00b003db29222b99mr9364819wmk.4.1677166423089;
        Thu, 23 Feb 2023 07:33:43 -0800 (PST)
Received: from [10.100.102.14] (85-250-17-149.bb.netvision.net.il. [85.250.17.149])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c214a00b003e209186c07sm11616530wml.19.2023.02.23.07.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 07:33:42 -0800 (PST)
Message-ID: <72746760-f045-d7bc-1557-255720d7638d@grimberg.me>
Date:   Thu, 23 Feb 2023 17:33:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v11 00/25] nvme-tcp receive offloads
Content-Language: en-US
To:     Aurelien Aptel <aaptel@nvidia.com>, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        axboe@fb.com, chaitanyak@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
References: <20230203132705.627232-1-aaptel@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Hi,
> 
> Here is the next iteration of our nvme-tcp receive offload series.
> 
> The main changes are in patch 3 (netlink).
> 
> Rebased on top of today net-next
> 8065c0e13f98 ("Merge branch 'yt8531-support'")
> 
> The changes are also available through git:
> 
> Repo: https://github.com/aaptel/linux.git branch nvme-rx-offload-v11
> Web: https://github.com/aaptel/linux/tree/nvme-rx-offload-v11
> 
> The NVMeTCP offload was presented in netdev 0x16 (video now available):
> - https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains
> - https://youtu.be/W74TR-SNgi4
> 
> From: Aurelien Aptel <aaptel@nvidia.com>
> From: Shai Malin <smalin@nvidia.com>
> From: Ben Ben-Ishay <benishay@nvidia.com>
> From: Boris Pismenny <borisp@nvidia.com>
> From: Or Gerlitz <ogerlitz@nvidia.com>
> From: Yoray Zack <yorayz@nvidia.com>

Hey Aurelien and Co,

I've spent some time today looking at the last iteration of this,
What I cannot understand, is how will this ever be used outside
of the kernel nvme-tcp host driver?

It seems that the interface is diesigned to fit only a kernel
consumer, and a very specific one.

Have you considered using a more standard interfaces to use this
such that spdk or an io_uring based initiator can use it?

To me it appears that:
- ddp limits can be obtained via getsockopt
- sk_add/sk_del can be done via setsockopt
- offloaded DDGST crc can be obtained via something like
   msghdr.msg_control
- Perhaps for setting up the offload per IO, recvmsg would be the
   vehicle with a new msg flag MSG_RCV_DDP or something, that would hide
   all the details of what the HW needs (the command_id would be set
   somewhere in the msghdr).
- And all of the resync flow would be something that a separate
   ulp socket provider would take care of. Similar to how TLS presents
   itself to a tcp application. So the application does not need to be
   aware of it.

I'm not sure that such interface could cover everything that is needed, 
but what I'm trying to convey, is that the current interface limits the
usability for almost anything else. Please correct me if I'm wrong.
Is this designed to also cater anything else outside of the kernel
nvme-tcp host driver?

> Compatibility
> =============
> * The offload works with bare-metal or SRIOV.
> * The HW can support up to 64K connections per device (assuming no
>    other HW accelerations are used). In this series, we will introduce
>    the support for up to 4k connections, and we have plans to increase it.
> * SW TLS could not work together with the NVMeTCP offload as the HW
>    will need to track the NVMeTCP headers in the TCP stream.

Can't say I like that.

> * The ConnectX HW support HW TLS, but in ConnectX-7 those features
>    could not co-exists (and it is not part of this series).
> * The NVMeTCP offload ConnectX 7 HW can support tunneling, but we
>    don’t see the need for this feature yet.
> * NVMe poll queues are not in the scope of this series.

bonding/teaming?

> 
> Future Work
> ===========
> * NVMeTCP transmit offload.
> * NVMeTCP host offloads incremental features.
> * NVMeTCP target offload.

Which target? which host?
