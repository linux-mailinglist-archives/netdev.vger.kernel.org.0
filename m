Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AB1332B31
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhCIP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhCIPzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:55:47 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3759FC06174A;
        Tue,  9 Mar 2021 07:55:47 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id t16so13256737ott.3;
        Tue, 09 Mar 2021 07:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b5sJf5a/Nsswl7kMHUtt9MARj1P3JFHsuY5CgeMMi5Q=;
        b=reguRV/Ku7o0pbogf/jH0d0oJ9bs8Gg7KnDshPUabTd0DMCyxupAWt3RvDINC7r5FN
         m1aKVH3ls8zAmYf5cgXn/koNUdgNiQZmBhTWj9z9HZK0Tp53SThuvtBjv0ieLH7yTRvE
         +0qzoYZoepRwZ47CR3eucxI6LDO5zP4cMOPXY0uBEgTRKko+XJMdUCaOKgFPjHKuCDaO
         nElHP50cjUEn4xXnHEUvRKTxuRSigssWkPdnbFU3tIpGonKW5WraAixFe6K0qfiy1OkI
         IKfncQi9IMoGZmKdPl9y9aVs0gFU/Rwh9DvTS8INIPDwqR0xMo0Te4UZhoLqtyzwVVow
         M+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b5sJf5a/Nsswl7kMHUtt9MARj1P3JFHsuY5CgeMMi5Q=;
        b=TmUZZUPCXDdez/GIs/TiQzEP64e7SAGo73OZOP2TS7cwZ2kwEF3NEVex9xE+zaSmKb
         mFwT+HXALKeCD4XL2WDyQIED9/5BSqcm2BvmO48p5k8YwfgteRUADJGx4tneH7TmezT+
         rlHCZAbpCMvKuBgLahc4n3MifLuaqbJGRECvwrhWebggNINNtuj88QQPyGDJGgbBeABe
         MSbVQZMIHsJ9GWCgXl0hSIBQND/tUzE07DmaM2+jfwjWXVMlEj2oTabt4qMeQKBhcuE1
         4+zbFKhi9Uev+iAmHZqrgc7Gya6gDr4Uq3AvNqsqu6PfBMkNh1Z7AegkGchiPXqAJWyM
         6xlw==
X-Gm-Message-State: AOAM532Ut3qtqTbjDhDEJ1rPuS0+vaZjnAeW+bvHEYUsI7AfeN5Ct72m
        5fXsxWTwSZ7ww/AgKW3ltA4=
X-Google-Smtp-Source: ABdhPJzOTAJZeoOCLFXCyS3YX0cMxQ/nL2IbduyYBDXUYZMUVtkvcAeYnXQmjN3m07qD/56Cnm4Nmw==
X-Received: by 2002:a9d:650d:: with SMTP id i13mr25180280otl.12.1615305346631;
        Tue, 09 Mar 2021 07:55:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id d1sm2950488oop.0.2021.03.09.07.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 07:55:46 -0800 (PST)
Subject: Re: [PATCH net v3 2/2] net: avoid infinite loop in mpls_gso_segment
 when mpls_hlen == 0
To:     Balazs Nemeth <bnemeth@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org
References: <cover.1615288658.git.bnemeth@redhat.com>
 <9b79f43d2dfec8b2cb8e896b5591e7b1c3cc1f6c.1615288658.git.bnemeth@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0c2f075e-ea66-66df-82e4-2c5fa71b2d43@gmail.com>
Date:   Tue, 9 Mar 2021 08:55:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <9b79f43d2dfec8b2cb8e896b5591e7b1c3cc1f6c.1615288658.git.bnemeth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 4:31 AM, Balazs Nemeth wrote:
> A packet with skb_inner_network_header(skb) == skb_network_header(skb)
> and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
> from the packet. Subsequently, the call to skb_mac_gso_segment will
> again call mpls_gso_segment with the same packet leading to an infinite
> loop. In addition, ensure that the header length is a multiple of four,
> which should hold irrespective of the number of stacked labels.
> 
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
> ---
>  net/mpls/mpls_gso.c | 3 +++
>  1 file changed, 3 insertions(+)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

