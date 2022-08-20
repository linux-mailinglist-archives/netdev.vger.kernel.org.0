Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9BB59AAC4
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 04:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiHTCx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 22:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242374AbiHTCxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 22:53:23 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE472A45B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 19:53:21 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id d1so4636570qvs.0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 19:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=tBQiPeY4LvPDSk6Ln48Z9QaTaoC2YQdUQRTthzfDkGc=;
        b=F6fCLfLc1knuk3J4tbHjYMCUiWcYVOCKfpqE2BabZOZJob4Ih5dcuZaE2jbJH9cnuL
         wWCzaQzB3Q2qhIniCTUqYMT2TLBtiVxBZw/y7HP7wmea1T1y7YSLY3BK/DXB3NCd5drD
         k4Wedp9jyCx7xAE6V8BFrm/ZfxzSNur4ax8xcyVMR6Q6TF7s+dm50nItSGFDN5r+Qoqk
         qQn+10sYI4RFbRUywlyYcYvDC6VGXjXLWlx7/RF9Yz8NaKDO6pED8cCsVdiVGGe49YtR
         SA0t+VPppyU7ZmEa78XamfiLt3pHSjEIJlaOQfShXDmQ6bd9XsaapUiQHRTP486GrfTJ
         Ar8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tBQiPeY4LvPDSk6Ln48Z9QaTaoC2YQdUQRTthzfDkGc=;
        b=WTIadr2o31joKsm645oAGW5yaoRmT8Vd5H6DDsdh0NA48a++4tWlojPZHTXdQHBmLV
         u5Mxi/8QLjY9Syu8SYMl7K5ShnGErzf4VuAcJjTMiXhJCRZwgSJMryGTucd2lzqXyD2y
         czOPyyRaRGgqnNGi6ZR6a6XsEjY0NZNGITRE9Rgbjd3L7Fu2+fRPM3u3fj+W7mGTtAUm
         dgd7g0okDnbeIalcNIrQl9PexQl6Br4t/rzobjh2ozA5fpg9ojoOYt8yCStXhe7xQcV8
         nqFEd8W0lnXcqiQZQUZU9d3Vu6LXWuYVRSJdoPSCiggIXrd2VxRnuehNu9JHY4628/q9
         xTQw==
X-Gm-Message-State: ACgBeo1/Crozn2reVgutSOVA8iJdKdoc/2HsrHtYhhwldj4fy1WzX1dx
        W+kaz4hxr89dF8oCFgDXbC4=
X-Google-Smtp-Source: AA6agR768hXjpRyOBoN/5qeGB5NnpBuseNebDaP+VdTchLLFvmojXY6OjxMVtMeIwwryNO4S08dR7w==
X-Received: by 2002:a05:6214:23c6:b0:491:99e3:80ce with SMTP id hr6-20020a05621423c600b0049199e380cemr8303097qvb.111.1660964000985;
        Fri, 19 Aug 2022 19:53:20 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bq42-20020a05620a46aa00b006b8e049cf08sm5332317qkb.2.2022.08.19.19.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 19:53:20 -0700 (PDT)
Message-ID: <bf811673-90d2-87f7-0e7b-20d8d9212b49@gmail.com>
Date:   Fri, 19 Aug 2022 19:53:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2022 10:39 AM, Vladimir Oltean wrote:
> When a driver returns -EOPNOTSUPP in dsa_port_bridge_join() but failed
> to provide a reason for it, DSA attempts to set the extack to say that
> software fallback will kick in.
> 
> The problem is, when we use brctl and the legacy bridge ioctls, the
> extack will be NULL, and DSA dereferences it in the process of setting
> it.
> 
> Sergei Antonov proves this using the following stack trace:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> PC is at dsa_slave_changeupper+0x5c/0x158
> 
>   dsa_slave_changeupper from raw_notifier_call_chain+0x38/0x6c
>   raw_notifier_call_chain from __netdev_upper_dev_link+0x198/0x3b4
>   __netdev_upper_dev_link from netdev_master_upper_dev_link+0x50/0x78
>   netdev_master_upper_dev_link from br_add_if+0x430/0x7f4
>   br_add_if from br_ioctl_stub+0x170/0x530
>   br_ioctl_stub from br_ioctl_call+0x54/0x7c
>   br_ioctl_call from dev_ifsioc+0x4e0/0x6bc
>   dev_ifsioc from dev_ioctl+0x2f8/0x758
>   dev_ioctl from sock_ioctl+0x5f0/0x674
>   sock_ioctl from sys_ioctl+0x518/0xe40
>   sys_ioctl from ret_fast_syscall+0x0/0x1c
> 
> Fix the problem by only overriding the extack if non-NULL.
> 
> Fixes: 1c6e8088d9a7 ("net: dsa: allow port_bridge_join() to override extack message")
> Link: https://lore.kernel.org/netdev/CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com/
> Reported-by: Sergei Antonov <saproj@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
