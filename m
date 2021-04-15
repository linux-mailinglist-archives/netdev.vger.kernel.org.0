Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0EA361304
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbhDOTll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 15:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhDOTlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 15:41:40 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5BFC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:41:17 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id b3so10669745oie.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+EuOus3COtubVRGnH7H8bJbajf8Vi/iaUyGJQH8FjuU=;
        b=nvH1V9mGhrj3ThFBTn7ANl2IefKQJQNzhxUU8adtlHmfkncFMKpqJDxfTIm+zyj/EH
         BJclXoYB0RYu4qoeq5SLT8TQVUTFktGF/YfbeIF5tvMyudz6wUm6RvqIGSzVEklmmHJ9
         F3VT0Wp3hBd8bnMCuQ/3SnB/CwGVboR8IeX+a8xd71KTX6b/Br5e6MUtwBjNp2HK5gOo
         p3TceH2l8x0IXRAYu9Oe8UMGxrR0HhMkGUPWEYzRWX7d8FnT4kt2xmN7NOXInITSgab+
         rr0I8U9oPw6zbkwGgdPaPOE/NEWR4Q4FWGviSrWXHuVS7o/Rf06zARQh5a1soXYnjkZK
         eNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+EuOus3COtubVRGnH7H8bJbajf8Vi/iaUyGJQH8FjuU=;
        b=LhqEmfu3MowBIQ4nR0WVimj8h+z+HC6xkr22JkI2NgA5GEuS90/2TmtNBLm/DIEA27
         840g+Ydy/F2qcBdoFvSEFjk+aBi4wVDRyO2XNKj213oPbDtBrKKAwpQ7TjmrjNVcRC5I
         iWyiVzWAWoZi1OI2P9r8O8mbhFpisXPeqiE0B/b83ifqiCGTaQ9OeYYZHExuZFn0Evp6
         dZQPZr0ICC/B5CVTiLqbDnGn2bLZXAJC6lhDadNAqbI7PZvhPAIh4d1UBiNeQzPkZPAK
         6ZHm+GUynJPIc+sMnTThbXm/xDeIjU6VYjb2ZcvFuHhyK7qvnzGK22OMmUhmlyWtXPFx
         E+jg==
X-Gm-Message-State: AOAM5300H5zjoHquj1/pg6d2suIsxy7roWCXAImVrURlSSuk0TFPny2q
        GcCUatm7OWsZcFuTle+gwbDTiZZc4ww=
X-Google-Smtp-Source: ABdhPJx+1ChqoxmjOdeR8CdvI6YE6nrPyTEgfcJxANlvV5yEyqeoBkJPf2ITPaAf765t6G7c4Fn11w==
X-Received: by 2002:aca:4344:: with SMTP id q65mr3603370oia.85.1618515676801;
        Thu, 15 Apr 2021 12:41:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id u9sm156934oot.22.2021.04.15.12.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 12:41:16 -0700 (PDT)
Subject: Re: Different behavior wrt VRF and no VRF - packet Tx
To:     Bala Sajja <bssajja@gmail.com>, netdev@vger.kernel.org
References: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e73269cc-1530-5749-0b62-f30b742217e1@gmail.com>
Date:   Thu, 15 Apr 2021 12:41:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 12:15 AM, Bala Sajja wrote:
> When interfaces are not part of VRF  and below ip address config is
> done on these interfaces, ping with -I (interface) option, we see
> packets transmitting out of the right interfaces.
> 
>  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
>  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
> 
>  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
>  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s8
> 
> When interfaces are enslaved  to VRF  as below and ip are configured
> on these interfaces, packets go out of one  interface only.
> 
>  ip link add MGMT type vrf table 1
>  ip link set dev MGMT up
>  ip link set dev enp0s3 up
>  ip link set dev enp0s3 master MGMT
>  ip link set dev enp0s8 up
>  ip link set dev enp0s8 master MGMT
>  ip link set dev enp0s9 up
> 
>  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
>  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
> 
>  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
>  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s3
> 
> 

I believe this use case will not work since the FIB lookup loses the
original device binding (the -I argument). take a look at the FIB lookup
argument and result:

perf record -e fib:*
perf script
