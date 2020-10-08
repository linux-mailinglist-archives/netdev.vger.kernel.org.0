Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547A3287C12
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgJHTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHTHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:07:06 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75E6C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:07:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n6so7487741wrm.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J9wzXe0Mwlk1Aa+2RHj0fspLww1O4qz/bqm01VadWAY=;
        b=Oq8I0r8E4FxOTTfrAZHNLQlxeb4jLWlRfTP1rrrcVfNMa6h8NWqf46waLyPkt7ywgx
         cMj6gIX7juEg0GeQGwc+AxtTUW7YwGPxb4j54/hcFMHmtEvU0s13rVRbX1dQsrff4Vto
         ecqOGI8vtM14WcZQWa+WyP7uZaIIc85ligTKqI5ShTzHHuHsrNoZhSboHONt9sYu4B/v
         ozZoF9bvRwsgnaBzUS9dAqve+TzIMsqWSKgSfl5iyAuV2/pn5Hz8Agv6PbcSWJTswVAK
         H9LbREnfMlxpyBn8zWi6koeLZ+7UvaFIfRKBGTGOghV4uJJHUdO/cyp4FkXXM2ARiRfF
         aWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J9wzXe0Mwlk1Aa+2RHj0fspLww1O4qz/bqm01VadWAY=;
        b=Trsmg83tSKP2sH2sQRha1QfwojUNQNkkXu5TJ/UnvUPp9mJ5MtYL30JOQ8HE7wTNxJ
         i0jltPFjABFj4HGCGxAh8VMsX4uYEgPbDUjFHM2t3W3GDs+ck5WMWoInh41g0mIuhg8g
         NFWNpj3SKSX6CqsCVnZWNCG+lshinXCbxTVoAybBEwRI1tUskd7zFxOUnvY7V05qTzre
         q+pUEiHqUk3Ci5niAF1s8Is7ml512fGyL1yQe+j4M+zJIGksWF/D7A3H07kKkI8b1Wgj
         u+5RmoEQTR2lyRjLUZG6U5A8l9rCWsohQUL4+CZ8oPAdGyQ3KUn679bgu215qZzto+5u
         U2OA==
X-Gm-Message-State: AOAM5330CoOVubGpuWALeAWFnBGt316fhxjaR+sutu22F55KOAST+dzH
        oQbjvS6ORxgQp1x6cUJDsVd3OKdwIwY=
X-Google-Smtp-Source: ABdhPJwQZ+UVQmhjS7cgS2AQXOFdJ0QXY0kIthuClO+FpHBf1wEgm2UZA6kA/zI3ui8m8pn+rW1HTg==
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr10906739wru.368.1602184024257;
        Thu, 08 Oct 2020 12:07:04 -0700 (PDT)
Received: from [192.168.8.147] ([37.165.121.66])
        by smtp.gmail.com with ESMTPSA id d23sm8170777wmb.6.2020.10.08.12.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 12:07:03 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
 <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
 <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
 <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
 <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dbad301f-7ee8-c861-294c-2c0fac33810a@gmail.com>
Date:   Thu, 8 Oct 2020 21:07:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 8:50 PM, Eric Dumazet wrote:
>
> 
> OK, it would be nice to know what is the input interface
> 
> if4 -> look at "ip link | grep 4:"
> 
> Then identifying the driver that built such a strange packet (32000
> bytes allocated in skb->head)
> 
> ethtool -i ifname
>

According to https://bugzilla.kernel.org/show_bug.cgi?id=209423

iif4 is the tun200 interface used by openvpn.

So this might be a tun bug, or lack of proper SKB_GSO_DODGY validation
in our stack for buggy/malicious packets.


