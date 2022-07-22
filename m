Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7053357D9AF
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiGVEuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGVEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:50:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B8E2253B
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:50:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g17so3675897plh.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kjB7iVHracebjn84qZWzNOHfxjUXSatRffhA3ZHcmS4=;
        b=aAbrPdeE1VuDMmwlm7tPdDcteP0TC9+yTZy8SUQHoL4AqaiQ1+W380jgcE56xNgvFj
         qvTesnDWtDvxVctf7tubNJjHuBVnbFHqHLE5wEbpQIB2zljW6MC9UjvtJp6DNR1mlHzb
         XC+GaSYF+wR6DtDyiOwRKL4MAwSbR6zQHUqAp1S6lTObcrzgd0YNijAlr1/NA10jeRiG
         Qr0+EVeBWwVu0y0HhY+ICtYtxpdgQFIodi/P6Fp74R7ypSdRQ+d9rWs8ZM6QZpPp/Zwv
         hlhejfhPp2w9to0aamWfw0LbEvjwMk3StZEvE6dE3lMBiLseDEEhhKDN8/EOhWQwtQJV
         6pCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kjB7iVHracebjn84qZWzNOHfxjUXSatRffhA3ZHcmS4=;
        b=YcCbKnj960PnLPsHkhfKgcOeMt0BaRtF6ePDk+xf9hZslFnq0pUOyeGxHVNPIHKtZS
         yFFHVEdRlw69j4YCaiEP4hde8fFCkFKFjOkceGC7xJ9nZAQonp72DbIn6GhGegEuU2fg
         cdanCy3GXnm6B9fwDhrYS0UEEuf83KZg2bPNjgK8pP0aNGem4MxwEbfdUVtLTgUTTIKj
         HhMaddi6VKd/660rPS/GE3ckPzsjmr0XIYNSvXy1QTN9+OM0BlllRwrBCgEcLn43oaYZ
         9KAJ7NbBpDiaW+ARkE/tvm5Pjk5JZzvFnjEM2/m6SKIMLB/KTzg6Q1SuqDMCUPvx1DbR
         oT/g==
X-Gm-Message-State: AJIora8RqtUJZRatGhhHIvAcunj9V8vs0iyyF+KCMXgUfF62OMq15NAK
        LU7C/bh60kYc72BD5iFs5kuiPRKAb+e/+Q==
X-Google-Smtp-Source: AGRyM1sYV9YvOuigclT5Hjue1x4Kh+Pcd5edfw0YwuafXVYXFyeqwW+JtYlLuBrjV7lEETBsxHs3gA==
X-Received: by 2002:a17:90b:3142:b0:1f0:5563:b9c2 with SMTP id ip2-20020a17090b314200b001f05563b9c2mr2080475pjb.160.1658465418695;
        Thu, 21 Jul 2022 21:50:18 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i127-20020a62c185000000b0052af2e8bba3sm2628609pfg.37.2022.07.21.21.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 21:50:18 -0700 (PDT)
Message-ID: <ecd370bb-dfd3-08e4-b526-fb93226b2dbb@gmail.com>
Date:   Fri, 22 Jul 2022 13:50:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
 <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
 <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com> <YtoNCKyTPNPotFhp@Laptop-X1>
 <YtomWhU9lR3ftEM+@Laptop-X1>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YtomWhU9lR3ftEM+@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,
Thank you so much for the test and review!

On 7/22/22 13:23, Hangbin Liu wrote:
 > On Fri, Jul 22, 2022 at 10:35:52AM +0800, Hangbin Liu wrote:
 >>> I found this bug while testing another syzbot report.
 >>> 
(https://syzkaller.appspot.com/bug?id=ed41eaa4367b421d37aab5dee25e3f4c91ceae93)
 >>> And I can't find the same case in the syzbot reports list.
 >>>
 >>> I just use some command lines and many kernel debug options such as
 >>> kmemleak, kasan, lockdep, and others.
 >>>
 >>
 >> Hi Taehee,
 >>
 >> I got a similar issue with yours after Eric's 2d3916f31891
 >> ("ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()").
 >> I use force_mld_version=1 and adding a lot of IPv6 address to 
generate the
 >> mld reports flood. Here is my reproducer:
 >
 > BTW, thanks for your fix. With your patch the issue is fixed. Please 
feel free
 > to add
 >
 > Tested-by: Hangbin Liu <liuhangbin@gmail.com>
 >

I also tested with your reproducer.
I checked that it reproduces same issue.

[   69.862696][   T58] [TEST]mld_report_work 1629
[   87.129371][   T10] unregister_netdevice: waiting for veth0 to become 
free. Usage count = 2
[   87.132106][   T10] leaked reference.
[   87.133276][   T10]  ipv6_add_dev+0x324/0xec0
[   87.134724][   T10]  addrconf_notify+0x481/0xd10
[   87.136200][   T10]  raw_notifier_call_chain+0xe3/0x120
[   87.137829][   T10]  call_netdevice_notifiers+0x106/0x160
[   87.139454][   T10]  register_netdevice+0x114c/0x16b0
[   87.140380][   T10]  veth_newlink+0x48b/0xa50 [veth]
[   87.141268][   T10]  rtnl_newlink+0x11a2/0x1a40
[   87.142073][   T10]  rtnetlink_rcv_msg+0x63f/0xc00
[   87.142956][   T10]  netlink_rcv_skb+0x1df/0x3e0
[   87.143861][   T10]  netlink_unicast+0x5de/0x850
[   87.144725][   T10]  netlink_sendmsg+0x6c9/0xa90
[   87.145595][   T10]  ____sys_sendmsg+0x76a/0x780
[   87.146483][   T10]  __sys_sendmsg+0x27c/0x340
[   87.147340][   T10]  do_syscall_64+0x43/0x90
[   87.148158][   T10]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

printk message and calltrace are same.
So, I'm sure that this is the same issue.
Also, I tested with my patch and your script for 1 hour, and the 
reference count leak disappeared.

If you are okay, I would like to attach your reproducer script to the 
commit message.

 > Cheers
 > Hangbin

Thank you so much
Taehee Yoo
