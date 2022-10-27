Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9360F562
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiJ0Kf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbiJ0Kfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:35:55 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930FB3DF12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:35:52 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id fy4so3241505ejc.5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=olcqBqp20ijqPE54YEtnv810clQFjmIdUzlbWquxgtg=;
        b=IkKGPcsasBLBrtwalV8QFSKUy5sCAo+ej74pAsHzyW0H9XCQrIJsjd/yC+IZ1MaDqN
         tPpCpRiXM8PZojs+FEbmpTa59EDuUbdHNlTCVBxkzL4c2APemR4Q43w8C00ioKK+o5Tw
         8sYVmXWwfN1j4eOVPiM7rGOAJPcqka0gFkTmMAKTvqSP9qkp5BtRRcfaVRixGHu26Vf+
         yMi9RMecfXJ2GMjq3P3Xch6JSR5QITZ/kTr5eTTlUljGeLKJfZz7o2Ob2BiPabS1MbKH
         C48ZOq9Bk9q8iSLjWCqJdH4ct2d41YTMFvrKOhsNreTl2ETPxfMN+lxli6pejoY3+dvk
         +fzQ==
X-Gm-Message-State: ACrzQf3tKe5ulniXz0zbUbDM4v1BbH7D6mOFEBKU7+YvvEJvFg8jDa5B
        Z3WpXHAnm6Tq82u/9/Wx2TY=
X-Google-Smtp-Source: AMsMyM4rYnExz0aFrBW9qQ4H4xsy4bm36lWxnSlbkJykRkR4bYDUrHr86IpEEGRGUwvvmAWw/TKtYA==
X-Received: by 2002:a17:907:75d4:b0:7ad:92da:379a with SMTP id jl20-20020a17090775d400b007ad92da379amr1162099ejc.681.1666866951100;
        Thu, 27 Oct 2022 03:35:51 -0700 (PDT)
Received: from [10.100.102.14] (46-116-236-159.bb.netvision.net.il. [46.116.236.159])
        by smtp.gmail.com with ESMTPSA id cw13-20020a056402228d00b0045bccd8ab83sm791888edb.1.2022.10.27.03.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 03:35:50 -0700 (PDT)
Message-ID: <f62c517e-e25e-ad2f-cf31-cba6639735ad@grimberg.me>
Date:   Thu, 27 Oct 2022 13:35:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 00/23] nvme-tcp receive offloads
Content-Language: en-US
To:     Aurelien Aptel <aaptel@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, linux-nvme@lists.infradead.org, hch@lst.de,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
References: <20221025135958.6242-1-aaptel@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
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
> The nvme-tcp receive offloads series v7 was sent to both net-next and
> nvme.  It is the continuation of v5 which was sent on July 2021
> https://lore.kernel.org/netdev/20210722110325.371-1-borisp@nvidia.com/ .
> V7 is now working on a real HW.
> 
> The feature will also be presented in netdev this week
> https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains
> 
> Currently the series is aligned to net-next, please update us if you will prefer otherwise.
> 
> Thanks,
> Shai, Aurelien

Hey Shai & Aurelien

Can you please add in the next time documentation of the limitations
that this offload has in terms of compatibility? i.e. for example (from
my own imagination):
1. bonding/teaming/other-stacking?
2. TLS (sw/hw)?
3. any sort of tunneling/overlay?
4. VF/PF?
5. any nvme features?
6. ...

And what are your plans to address each if at all.

Also, does this have a path to userspace? for example almost all
of the nvme-tcp targets live in userspace.

I don't think I see in the code any limits like the maximum
connections that can be offloaded on a single device/port. Can
you share some details on this?

Thanks.
