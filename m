Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67F4C2AE3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiBXL05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiBXL04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:26:56 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB62929A57E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:26:25 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id cm8so2363881edb.3
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0njhmFMB7YGM1lxXw8lv8Du+QtFIF36U2sCeO/sbrqc=;
        b=4cOto6GTLyrG1vHzK/XU21unLBboPvpGxq/9dOU9VzTvXqGmm7w/90Jaql6sz6XvpV
         KJhq3pSsDkQWkpQLpKwh0oz80v4yPqTpPj+IHBsTmYt/KsKOF2OHKyi2in/lFldM/e6A
         L+rLaJSSQZC2UypDSzRDo4l7ZRxXvD7ZxAGqf1Tzc7RmsiXOvJ+lR942gefInlGGgGr3
         KrilYlhlQYDxpkuFsswaJbsS0pXH1Htz4B9ASN32Xyhqlv89x1ISg6U+jjYmw39E6M6R
         1LYpioTnmWuCqGsXm6qyq8fd0VWYs9J8dSYUCah2sNarP3mhc7qQkFAMZSvzaHGr3diS
         oRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0njhmFMB7YGM1lxXw8lv8Du+QtFIF36U2sCeO/sbrqc=;
        b=3vfB9MvmA1CJxu5U7c4TVUCoL+fXCHgGJuYp3HoSGP/36bjLptVvMeNAT1o6MSbaop
         uZo4KulOA1zqjlJyTW1SUMV8Zvq6NxmHH46D3cEK7aHZ4Xe/hXCYuu1PitmCpu8SgFmp
         sEZ8Pg1h8jMHYOnyW/WrMTYM6AUMlTdfsyfViR83Yw2hR4VlFCzJoevUtnXNHsNcKNpu
         Plskg7NnbiuMMqdPSL09EZL3R14b245JZrGjslButQ2gmdv2wQO1Nd9ZTm9JcMRczo5j
         vgI7qqP7oxnrjG05VvKZJOGdTy0E40Tt8o4/MaTE97qLirzzsZFgk68g4XEtDW38wI5q
         RGkA==
X-Gm-Message-State: AOAM5312BpUH0DGKAt9pJ40bXCInHe4RUMKzzzttOoKLdhieJ/TDixf6
        ACcWJBbaJq++PHH6XKS+TDW+QdGqMrBVxZm8
X-Google-Smtp-Source: ABdhPJzzX65huOzpn9V2Rt2En85LVpCl2fy7WzIH+sMUEgIVZllXml9NcgRj2gEARhKzt825lGWeyw==
X-Received: by 2002:a05:6402:50cb:b0:412:ab6d:c807 with SMTP id h11-20020a05640250cb00b00412ab6dc807mr1829651edb.382.1645701984402;
        Thu, 24 Feb 2022 03:26:24 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id q12sm1165991edv.99.2022.02.24.03.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 03:26:23 -0800 (PST)
Message-ID: <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org>
Date:   Thu, 24 Feb 2022 13:26:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb
 entries
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220223172407.175865-1-troglobit@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220223172407.175865-1-troglobit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2022 19:24, Joachim Wiberg wrote:
> This patch expands on the earlier work on layer-2 mdb entries by adding
> support for host entries.  Due to the fact that host joined entries do
> not have any flag field, we infer the permanent flag when reporting the
> entries to userspace, which otherwise would be listed as 'temp'.
> 
> Before patch:
> 
>     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
>     Error: bridge: Flags are not allowed for host groups.
>     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee
>     Error: bridge: Only permanent L2 entries allowed.
> 
> After patch:
> 
>     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
>     ~# bridge mdb show
>     dev br0 port br0 grp 01:00:00:c0:ff:ee permanent vid 1
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  net/bridge/br_mdb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

It would be nice to add a selftest for L2 entries. You can send it as a follow-up.
The patch looks good to me.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

