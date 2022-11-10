Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4C624215
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiKJMQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKJMQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:16:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2626D6CA0D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668082530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NH6gLwh7jsTqY+d33ts5P5I5+81pXvNIQ/M0weJSc1o=;
        b=H7T1qGaGuD0dGUFPc9ZsTEGYY5uEKPD0TikofJEWKRJ9IS+M5647crK3s5bTFB0tpVx2Je
        tca9H5GGdFKCrg/XGyGaCZSsOooA/bec54RjrGCJ6Q+K4TcQip061BbW7XZanuBMJ5zgwj
        E1O7N0DCH52s7ldpgLQaOAwntIx8R3o=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-182-mNmt9MyMPhmOJ-31S3J5CA-1; Thu, 10 Nov 2022 07:15:29 -0500
X-MC-Unique: mNmt9MyMPhmOJ-31S3J5CA-1
Received: by mail-qk1-f200.google.com with SMTP id i17-20020a05620a249100b006fa2e10a2ecso1696113qkn.16
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NH6gLwh7jsTqY+d33ts5P5I5+81pXvNIQ/M0weJSc1o=;
        b=4iVjzlpt9VphFMddK9B8Y88hq/+DZm9ZEJ1REn4pG4wAXQC6PPe+u+zANCW7HtnbWK
         ENtboPPonsla3A2DU9um3sNbFcY9Cgldeoqex5zTUey2dbQ2+xP2vpHxiOTGKimDyXGO
         oInDuE4s7rUBBJ/ToFuPgWkNoaXBFt6fAl49xlltA8Ip7XVUNWO9kkObNdbhjKtNhzDN
         6jXVU5dbQFlnje0S4LmrSK0DvkWPNVQtc0dv0dyTJZx+wC4ZQGo93xqEb88jXiVLSA1I
         JJGaYIfO8BElm/dy5+QUxeTWZCc1Y7MmbE2BMR3AehhqOyBtGC+fymwZmRI4isSrnHaR
         509Q==
X-Gm-Message-State: ACrzQf3w7pqiK++67DzFZY4SdbD3PAAXKThSoo+CNTFoiozamfHNk4cy
        EWFpXwjXHR6AKd+AK6NtFeyPZHLE5/TQ59pcLqnZqxNb++l1saWBLJmkeHu4WsO5GenKfnuX+LZ
        Zt8y8Eo3t3k7nxzIo
X-Received: by 2002:ad4:5eca:0:b0:4ba:535a:6d45 with SMTP id jm10-20020ad45eca000000b004ba535a6d45mr58568137qvb.56.1668082528870;
        Thu, 10 Nov 2022 04:15:28 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7M6U8GJxEQais1ISo24dMFf1wdPIOng8Ysc6A4JaAJzekU608qHsDvDwAekr76nKQzkDSI1g==
X-Received: by 2002:ad4:5eca:0:b0:4ba:535a:6d45 with SMTP id jm10-20020ad45eca000000b004ba535a6d45mr58568113qvb.56.1668082528639;
        Thu, 10 Nov 2022 04:15:28 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id x25-20020ac84d59000000b003a4f14378d1sm11084757qtv.33.2022.11.10.04.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:15:28 -0800 (PST)
Message-ID: <3be7af8bd3c768c691f368300f98db9c355b5018.camel@redhat.com>
Subject: Re: [PATCH net] net: fix the address copy size to flow_keys
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        kernel test robot <lkp@intel.com>
Date:   Thu, 10 Nov 2022 13:15:23 +0100
In-Reply-To: <20221109024406.316322-1-liuhangbin@gmail.com>
References: <20221109024406.316322-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-11-09 at 10:44 +0800, Hangbin Liu wrote:
> kernel test robot reported a warning when build bonding module:
> 
>                  from ../drivers/net/bonding/bond_main.c:35:
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘iph_to_flow_copy_v4addrs’ at ../include/net/ip.h:566:2,
>     inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3984:3:
> ../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
> ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>   413 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘iph_to_flow_copy_v6addrs’ at ../include/net/ipv6.h:900:2,
>     inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3994:3:
> ../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
> ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>   413 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This is because we try to memcpy the whole ip/ip6 address to the flow_key,
> while we only point the to ip/ip6 saddr. It is efficient since we only need
> to do copy once for both saddr and daddr. But to fix the build warning,
> let's break the memcpy to 2 parts. This may affect bonding's performance
> slightly, but shouldn't too much.

The compiler should be able to unroll the memcpy loop in both cases,
but if it fails to do that, the performance hit could be measurable,
see commit 236222d39347e0e486010f10c1493e83dbbdfba8.

This looks like a straight struct_group() use-case, I suggest to use
the latter construct instead.

Cheers,

Paolo

