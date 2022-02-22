Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B794BEFD4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiBVC4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:56:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiBVC4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:56:33 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C86125C78;
        Mon, 21 Feb 2022 18:56:09 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id l19so10565209pfu.2;
        Mon, 21 Feb 2022 18:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uy+63u5eMvVbGphKBYAIAoCM2kDIle1HkZDXPrgQl2A=;
        b=UPoYStfcx5MwyoGlXvcMj6xzJpvaTdU+mKNlr6MR3PaZ5bN8l8KFJL0DXlMT+JPtJF
         ougmX4BWAG2fTtn0aMqMzdK7teG0BIhSz/ArBeQrvlHM/svZLA+M+SsPQEurEDWCZD1Q
         e2yo0bELWZfLXXJUUYFAy0zgaqcF+LGwhi25ezIM130KBuYvVVbFajXOuza/ofUtbBTz
         hjtBsgjeVgJg0kgDB1pMNUniv0zcDOQl8bRiO6xjs1/KvwVH1M6l3pUQCFd+8rl7KUFj
         dbmu4cQ9nRASBHaTxOfK0DDHdvoyAJp0S0jyAOsIvXUeDfOen0pcnb3HM4UDO2FhYo4n
         5lNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uy+63u5eMvVbGphKBYAIAoCM2kDIle1HkZDXPrgQl2A=;
        b=lfEORVWwuipMMYL42hmBTkdq6sPFRYX4V0Sjl+AiA7iDJwTf1SqTTfI2OsWJAK9eml
         QJoKGzg6/xZKKzy1+LfSMzFrEMci1RS02iu4W6XlGT4UJlBvXJTEOqoPNT/Vl2qPWFiT
         REP1igye/GQWHaBK24yWC6HoIrchi8ByoLpmF4bC9nvACPzwMZ1c3rREVw6ZxZVyYLOI
         DrmG5VsI6c8BQ1fhQeGVrufonDK+Kj01R+ADas3CSrQeBJTf2dZ553sYxqpi/vwwqxew
         98zOdX/t8+Iphlxxp9qDpNTxe9xNWezZUI8jkiXctP7CM+echfc5QDrm36HVSFZD1THw
         r9DA==
X-Gm-Message-State: AOAM531QyMGlrGDzkRlTL2olcLtjxulmHewUdU0XCQLhLL8wp0c5BfFe
        WwfjiNFThckDWK5F7v2IXeQ=
X-Google-Smtp-Source: ABdhPJyUYAALWlcX96UrLIq7tISfijKnfu7pGvZvnPt2HZFvLSvYrT3l9p0Pd03YzjYNKOKeXO/IPQ==
X-Received: by 2002:a05:6a00:148f:b0:4bc:fb2d:4b6f with SMTP id v15-20020a056a00148f00b004bcfb2d4b6fmr22723923pfu.62.1645498569046;
        Mon, 21 Feb 2022 18:56:09 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j9sm13455031pfj.13.2022.02.21.18.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 18:56:08 -0800 (PST)
Message-ID: <f2dcb930-0b20-8956-14a3-14f8f49f4152@gmail.com>
Date:   Mon, 21 Feb 2022 18:56:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 net] net: dsa: fix panic when removing unoffloaded port
 from bridge
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220221203539.310690-1-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221203539.310690-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 12:35 PM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> If a bridged port is not offloaded to the hardware - either because the
> underlying driver does not implement the port_bridge_{join,leave} ops,
> or because the operation failed - then its dp->bridge pointer will be
> NULL when dsa_port_bridge_leave() is called. Avoid dereferncing NULL.
> 
> This fixes the following splat when removing a port from a bridge:
> 
>   Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
>   Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
>   CPU: 3 PID: 1119 Comm: brctl Tainted: G           O      5.17.0-rc4-rt4 #1
>   Call trace:
>    dsa_port_bridge_leave+0x8c/0x1e4
>    dsa_slave_changeupper+0x40/0x170
>    dsa_slave_netdevice_event+0x494/0x4d4
>    notifier_call_chain+0x80/0xe0
>    raw_notifier_call_chain+0x1c/0x24
>    call_netdevice_notifiers_info+0x5c/0xac
>    __netdev_upper_dev_unlink+0xa4/0x200
>    netdev_upper_dev_unlink+0x38/0x60
>    del_nbp+0x1b0/0x300
>    br_del_if+0x38/0x114
>    add_del_if+0x60/0xa0
>    br_ioctl_stub+0x128/0x2dc
>    br_ioctl_call+0x68/0xb0
>    dev_ifsioc+0x390/0x554
>    dev_ioctl+0x128/0x400
>    sock_do_ioctl+0xb4/0xf4
>    sock_ioctl+0x12c/0x4e0
>    __arm64_sys_ioctl+0xa8/0xf0
>    invoke_syscall+0x4c/0x110
>    el0_svc_common.constprop.0+0x48/0xf0
>    do_el0_svc+0x28/0x84
>    el0_svc+0x1c/0x50
>    el0t_64_sync_handler+0xa8/0xb0
>    el0t_64_sync+0x17c/0x180
>   Code: f9402f00 f0002261 f9401302 913cc021 (a9401404)
>   ---[ end trace 0000000000000000 ]---
> 
> Fixes: d3eed0e57d5d ("net: dsa: keep the bridge_dev and bridge_num as part of the same structure")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
