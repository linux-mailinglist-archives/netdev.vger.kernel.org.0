Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA26C647E9B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLIHcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiLIHbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:31:47 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA21D276
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:31:18 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h7so4315195wrs.6
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=je/hcoSOt+coZaybXz7eb8R7zv6LEFeKDF9n70ZMzAc=;
        b=ysYDYD5RtN+wIYSi1bI5J111qdXzPFrAlv/bvN5yu0u4v+Tp7pVZVf0rIVPV6a+E/a
         yeTu3/8SIWMxOXG1MAms01hgZADrUoGEPy0MQzC5IKkfT1P0iCLOHul8aAUfxlwVT4AP
         HHyQBC5kg1010G1exzh2LJ3eOMui03e2/P2i61X5KCjqJEDzZcj1A4TtllwKBM+4pTr3
         qTyPCJgltrX7kNjxJ4X5FPwC2iHIKv5oI1NgSHVC7pm9NUaW3t1p8N1SfahlApEXlK8g
         v2oNkxxa+QUxD+JO2m1tSDNORSe9g1JSb0UBke9CSw47YcawfLmnu3drQUhuecq4l0M/
         yI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=je/hcoSOt+coZaybXz7eb8R7zv6LEFeKDF9n70ZMzAc=;
        b=uyryMbSsV9soFc4DsXEZbAUj3EAXfVcB9zUTQwksrl3QFeLDadhRXwsbbrsJwGA6ni
         PRjSvsnc8Gse864FE7dPckPDmbSbgRAY3GUnLIZ01nBZLrunNCgOFKtzsUR7+o+CJjB0
         Ft5cOCu960Qu80DslRlJFE7GXQCe0pVhQ8/V3uaupVnwi0TqwehAGBEtPLonkofAsp15
         DKUrL+z6qTv3vHfeF8WHF8byuJot+ZgoqNQdmYvtddaGNsomxYLA885yvMAB2f2oI57q
         IKE3hXjwXUY1zzI5fajgUt8St7a41p0LE+dgDTg/Q2s1BlBXtYJ2o23u17sxLTDrOf+3
         F7Cw==
X-Gm-Message-State: ANoB5plNZnxqtJXxhyqKDQhXZkBhXRi6lIqf9hclfQqq+YK1QF0mqpAc
        Z2Z4rz6JoVAdKgOWX7fZ2U32sg==
X-Google-Smtp-Source: AA0mqf4f+bMO0EQ7ILvvThfbCMXmS9BhrpIxBk3cGlPvrgr44rqBBwPI1dJhxQbk+BRFXb1yi2MXag==
X-Received: by 2002:adf:cd86:0:b0:242:1d69:1ba1 with SMTP id q6-20020adfcd86000000b002421d691ba1mr4075094wrj.44.1670571077471;
        Thu, 08 Dec 2022 23:31:17 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id s4-20020a5d4ec4000000b00242246c2f7csm616574wrv.101.2022.12.08.23.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:31:17 -0800 (PST)
Message-ID: <68714375-7d33-a9de-e59d-48a4250831d0@blackwall.org>
Date:   Fri, 9 Dec 2022 09:31:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 06/14] bridge: mcast: Expose
 __br_multicast_del_group_src()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-7-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-7-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> Expose __br_multicast_del_group_src() which is symmetric to
> br_multicast_new_group_src() and does not remove the installed {S, G}
> forwarding entry, unlike br_multicast_del_group_src().
> 
> The function will be used in the error path when user space was able to
> add a new source entry, but failed to install a corresponding forwarding
> entry.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * New patch.
> 
>  net/bridge/br_multicast.c | 11 ++++++++---
>  net/bridge/br_private.h   |  1 +
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


