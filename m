Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E9D4E4019
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiCVOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbiCVOFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:05:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B3C2FFDB;
        Tue, 22 Mar 2022 07:04:02 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d76so3399068pga.8;
        Tue, 22 Mar 2022 07:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VKG/1kYND0WoR55B4lqLT7k0KiJbzmuO8Y2vRUl0xR0=;
        b=Bn1p97RjLF9BxY3dry3X6BL6A0QNHbVTPaeSiQYpszmHcRBHMRldkiWcykDDU0enr6
         8s0Q1JRRpDaA7VM7nmPJ/EIVDcu4CWQ0Vi/BJWtQVzjNImof7Yi/SA2yDlaBM0O19PUt
         eOavBJD4kI6cZude4SxH01MIRg9B8/zEnTFrgmgHXl0JnAelmJSIEs4mYHFBGAsNSWgx
         EQFY2o96LOLCdQgaJW4gu3f+OYTL+xULrKiZDRkoM8ncC7l4Fn4MrBcO4DZo0S99bx0m
         I51Tfn2snPA/j1sYhqDgx7yhu2EzViZ+OfNgfWAHzut944DVMfs2XeMNYx3L80xev0Mx
         QfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VKG/1kYND0WoR55B4lqLT7k0KiJbzmuO8Y2vRUl0xR0=;
        b=EZrJaLT8BEqQMn3LFR9bRjw3ciYUVH2/Lorc8gcXx8eiKrc7v56gkD9zsJl9adWTZF
         V/YFE/la34MjZiaKyrTgBMdKmPY093Dfxvj1DC0g6zwePHNjvec8GbfVmayKKoI1rvTG
         5fYBUxgdM8hSEjRttzEWZCV1Z7z3R91c/vpSpC+jLOupX/SsfvtgF5nLPU+8/iYqBDV0
         SBFkYoQHBbGmAxohVUMc9YGDCqEY7TkLsI89upJqxkFITdHQA1/r/P/TFrPs2Hg+2fZW
         ZK+rDHPNdCGBXAhKQbs9xmaQeu2dQJczl2EsKyL5xPAxcAr+8vgxlVPtYK3pJazHc0MA
         cDHw==
X-Gm-Message-State: AOAM531hBg09/99yImT/NClCzpozyrhxpSb6Oj3YZxkZo4kFEo3B2vh3
        b1tICY0JuqjwE7lp+f87Ixc=
X-Google-Smtp-Source: ABdhPJy6TjhaP//V1y7jA7vEnRVP7B/fgoF/xy27P4PhL8ZiJNiV1cqoLHRVE8c1CWiPUp8X48cc/A==
X-Received: by 2002:a05:6a00:1741:b0:4fa:9de9:93a1 with SMTP id j1-20020a056a00174100b004fa9de993a1mr10899699pfc.64.1647957842246;
        Tue, 22 Mar 2022 07:04:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y85-20020a626458000000b004fa77892f76sm14135304pfb.200.2022.03.22.07.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 07:04:01 -0700 (PDT)
Message-ID: <92e86620-3457-6ca1-6888-fdbcdf0a4e4e@gmail.com>
Date:   Tue, 22 Mar 2022 07:03:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v3 1/3] net: ipvlan: fix potential UAF problem
 for phy_dev
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Cc:     edumazet@google.com, brianvv@google.com,
        linux-kernel@vger.kernel.org
References: <cover.1647664114.git.william.xuanziyang@huawei.com>
 <abef9f7ad2c6e6b8ae053225766d34f3fc930ddf.1647664114.git.william.xuanziyang@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <abef9f7ad2c6e6b8ae053225766d34f3fc930ddf.1647664114.git.william.xuanziyang@huawei.com>
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


On 3/19/22 02:52, Ziyang Xuan wrote:
> There is a known scenario can trigger UAF problem for lower
> netdevice as following:


But this known scenario never happens.

So maybe you should not add it 'in the future'


>
> Someone module puts the NETDEV_UNREGISTER event handler to a
> work, and lower netdevice is accessed in the work handler. But
> when the work is excuted, lower netdevice has been destroyed
> because upper netdevice did not get reference to lower netdevice
> correctly.

Again, whoever would like to use a work queue would also

need to hold a reference on the device.

Regardless of ipvlan being used or not.


>
> Although it can not happen for ipvlan now because there is no
> way to access phy_dev outside ipvlan. But it is necessary to
> add the reference operation to phy_dev to avoid the potential
> UAF problem in the future.
>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---


Your patch makes no sense to me really.


