Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389BA4A551
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfFRP2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:28:05 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45591 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfFRP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:28:05 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so30666995ioc.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kCg5TixV3kZtc727Mfv9yC2tysgzxF24OFRCZLS3NVM=;
        b=AZ5OMNCi+splm/75iW/UCdmmKTRsKtaHKWC4qmYACTyVtua0bLWH/XhRdwQuA5t4bv
         cgznmCzp1X7jrRA1jKVC+xlsqqHnEohLIxnkpxlxLSzQPvgwH5kQCuGP4Upiqifghmqg
         EU1ezJwiL6Aa/f5jSACQmR/9GBnBwldF3u44SCWR5BpfHgoMHwTu+6ML0A2z2EvuWDSC
         +WggDyEkyejmfcfgzNwjnjgMYqh/t+I78oZ0a0C9xpDSt2FKeh1eu4+yjqd+kjNVhij2
         gDUD4TraAjadOM8l1KJ/a5zHYWlzAJGT93FzL1/LLTpwb3Kh8Dop8TkpXfvAL3ghti+X
         4NOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kCg5TixV3kZtc727Mfv9yC2tysgzxF24OFRCZLS3NVM=;
        b=VwDarGwffMWWt+cL/FCsKyMWbbO666EoGw7ZqEH91UXtSVsuaHMMKjjPTrQh/8gNYQ
         BbfnPjsV2zPxVJ5Wvmft70yF8OsBLqhKelAbYryLZioCUz4HSZQlbR46fIXjSdF9/tZV
         FMprZ72fCBTqfKhVZmYCJDJFcsyEiitJiyxxy8+1nquA+/OQIYw+Swc11iaWx78Dxd9R
         W0+cGsvXuji8i4Y8c0Wxz8tCCbRRFp18HibJrpg9ACqKMibsL6ZGM9iBIagjURaSY3E7
         NmnqoxnnPHdUfFCOsJxsNrgdjyQY1Z73YDPO2UeFICsnSHcCyIBOyU3UjktTJxHENsTt
         0hTg==
X-Gm-Message-State: APjAAAWcYwOJhimr40uUw8gnDLYPjNDXlGgOUPVMbldpiQuOPw/cYmLh
        /wmkrySM6HAp0EpuqlSFxtJY7hyZ
X-Google-Smtp-Source: APXvYqy9jyvad1x6y/JEuFW5M5vOsyZ5ClBPAOCMBZaNLfJlA2rv4IOQ5O8qfnYzH7bB0uPdNOsTVg==
X-Received: by 2002:a02:938f:: with SMTP id z15mr27504531jah.108.1560871685098;
        Tue, 18 Jun 2019 08:28:05 -0700 (PDT)
Received: from [172.16.99.114] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id y20sm12345420ion.77.2019.06.18.08.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:28:04 -0700 (PDT)
Subject: Re: [PATCH net-next v2 15/16] ipv6: Stop sending in-kernel
 notifications for each nexthop
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190618151258.23023-1-idosch@idosch.org>
 <20190618151258.23023-16-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d84bf20a-ee6d-0f15-7cad-ce1f013b7256@gmail.com>
Date:   Tue, 18 Jun 2019 09:28:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190618151258.23023-16-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 9:12 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Both listeners - mlxsw and netdevsim - of IPv6 FIB notifications are now
> ready to handle IPv6 multipath notifications.
> 
> Therefore, stop ignoring such notifications in both drivers and stop
> sending notification for each added / deleted nexthop.
> 
> v2:
> * Remove 'multipath_rt' from 'struct fib6_entry_notifier_info'
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 --
>  drivers/net/netdevsim/fib.c                   |  7 -----
>  include/net/ip6_fib.h                         |  1 -
>  net/ipv6/ip6_fib.c                            | 29 +++++++++++--------
>  4 files changed, 17 insertions(+), 22 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


