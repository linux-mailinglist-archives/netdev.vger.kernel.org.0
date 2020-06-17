Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB31FCD9E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgFQMov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 08:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQMot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 08:44:49 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C811C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 05:44:48 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id i16so1335744qtr.7
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 05:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k9LNQfCAySzi08kz7tqvnH5enzfs2Vt+9MUO1njrjfM=;
        b=KTkh7ANwj6dUmCEX5UDaxjRb6tFy7cX14tMnD/7OC3G4Pv4Bth3KQrw7bF75VC8vZn
         yfv651mLfded5lEv/4QHY8X1AA4y0TeFkYjjpxkq0sOsiJG7oW7RrQBwMjRi0FMO3HoO
         5wPDMNErWdq5ZOD4ZnTNyLqpWESxJrvGVINJspW3hmXV4VF30z2QqSpdJWBttIIetDmm
         lS8sc4HUxJiduh7kNMCdSrUXKxYpSrFCpNLbZy797Rti06wWrur/U9httDrGy3YJuGrH
         Zcl7/5jFISnn+yk4dF9MSIAD/p1CSe7ZpQAg59sUIYUi45xHo45LGiq2GjRkkRDY4kFs
         VgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k9LNQfCAySzi08kz7tqvnH5enzfs2Vt+9MUO1njrjfM=;
        b=bEYPJDiTIu1QoWrRwjsDINlxyFoGsmkufX3QR6YFsNCmDKEQ1SOLI3JOHqJe2fmOiJ
         Tx/vEx69DNi1FeDutFAGvterKIVu6+oEj1qRmEXoot4bxcKDmAwoIaZA/musB8rcYcLT
         dLI0QaXk8ik/A5hhRBiYh2/ik0vnX/9eWjw/YcWMt4YR+Rwtf0gCl9U2U16ZR1u8GVaX
         Sx4sOs3GOsJv3MNmqBKyd1D3VbVuJ5snQsQVMGKCiz9Cq/MaSVRa7jzcWAGf0rJ0v3Nt
         3jI85jC5RdWMtmIPxuA3lkAGPAQHSBEUutB65WgM+48mO67KPWhJxW5Cx6g87pgIuGCF
         Hc7w==
X-Gm-Message-State: AOAM530muiOqVWeaOi85XFUvdm/nV2MTbLfzYio9RrM5zd4dzovz+9c5
        LsJvMLEXX4Ieik8Spjt3Sfn4t0lD
X-Google-Smtp-Source: ABdhPJwekWP/XUlsLJklH8b1GMt0rsY/j2NBd9Dluf5CaxjRuKpXSeD7NJCktX/0+DCYQ+vw2zmEiA==
X-Received: by 2002:ac8:435b:: with SMTP id a27mr27383092qtn.184.1592397886045;
        Wed, 17 Jun 2020 05:44:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f993:5e02:4f6b:9ce? ([2601:282:803:7700:f993:5e02:4f6b:9ce])
        by smtp.googlemail.com with ESMTPSA id p16sm15778524qkg.63.2020.06.17.05.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 05:44:45 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXSBuZXQ6IEZpeCB0aGUgYXJwIGVycm9y?=
 =?UTF-8?Q?_in_some_cases?=
To:     "Guodeqing (A)" <geffrey.guo@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsa@cumulusnetworks.com" <dsa@cumulusnetworks.com>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <1592359636-107798-1-git-send-email-geffrey.guo@huawei.com>
 <39780a81-8ac8-871b-2176-2102322f9321@gmail.com>
 <55929b71c9b24aeeba760585fc59497f@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8ca4f200-11e8-c82d-9c87-7b98d557f6a5@gmail.com>
Date:   Wed, 17 Jun 2020 06:44:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <55929b71c9b24aeeba760585fc59497f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 9:38 PM, Guodeqing (A) wrote:
> rt_set_nexthop in __mkroute_output will check the nh->nh_scope value to determine whether to use the gw or not.
> 		if (nh->nh_gw && nh->nh_scope == RT_SCOPE_LINK) {
> 			rt->rt_gateway = nh->nh_gw;
> 			rt->rt_uses_gateway = 1;
> 		}
> 
> (ip_route_output_key_hash-> ip_route_output_key_hash_rcu-> __mkroute_output-> rt_set_nexthop)
> 

ok, I see now. Thanks.


Reviewed-by: David Ahern <dsahern@gmail.com>
