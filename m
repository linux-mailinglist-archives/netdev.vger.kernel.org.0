Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A15039FA4B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFHPYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhFHPYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:24:37 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C4AC061789
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:22:30 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so20660561oth.8
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DbrexN6T3qYALxrfqnzpVNU8ZucTGPuReVbJKBBnx5M=;
        b=KF3AiI0apoSYCEwRrEU1o7jVJQ8KLVjRW9ClZLxD01DTz41fSdJPJxL9YWH8jpZtkn
         cCbskIUy0Y55bOfazmNtsNqe88y9Lo/POhMjNdW5cdleDg0Op/TVX2TJNkOV2uig3LfK
         SIR1WCAWrnzgeAj4TRr7G+0OAXPEVmwY2EhDrOUduZQsXqFe7rk+k3OJYSL3DaPpWWkg
         8GA3jy8hOxNQsNYDP5s5Lbx6h12cBAturURydzJwwOWFAByTujPMoVCazXGnrsBKYsUo
         itY1qmgz6Mcrm1HdFQrGSKZ5sLJzaUTq+ad8pafapldK/W7HFJVEdjCqduFc5Wcvv+8M
         zVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbrexN6T3qYALxrfqnzpVNU8ZucTGPuReVbJKBBnx5M=;
        b=KsJiqmz4XbRUjb/qJrmA06gIQrhSdyf1AaoGJRlz5uK00NrLx3vR+J9tuTR3uq+omx
         6q5tybwGiY5H/CyOmoSaNsCl4LNs4TNNP2NT72GjdmzOksagGtutBqrqDvEBu8G/SMpM
         9CoJKMswC9oDiWwTvU/VqrM1DHwH6I3phv5oAn7fPZPbThEM9Lvnl/IKlpo8Hr7DwrAb
         pMXQIzA1d7bHyJbUD5VeZuWEefXaUuy92HcY3ewpGq6D5u93bJUItJ2gcdO65nXU2gWF
         HaVoGjYd2+bS4Vf2cfGBmlGfdel2ZEsbIOqo+N9NZlJfj7O57s21IzcH1x0UM9T3P58T
         SgLg==
X-Gm-Message-State: AOAM531Z0FAGN8h4mk54RlSmJDVShFN0XNrnZX1EVsHoszE2Q2lismLv
        Z8PG5m4Zb+dSka51yNOcMe8=
X-Google-Smtp-Source: ABdhPJxp3vXTLUXE7o6bY8WvC7geOXXvBzcJrongYPX10cvScuHr8W+A65FE7RVVAQ+pjpXxC1i/Mw==
X-Received: by 2002:a9d:5f0c:: with SMTP id f12mr3010509oti.149.1623165750289;
        Tue, 08 Jun 2021 08:22:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 102sm3110145otf.37.2021.06.08.08.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:22:29 -0700 (PDT)
Subject: Re: [PATCH net] vrf: fix maximum MTU
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>
References: <20210608145951.24985-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f99c6805-c8ae-0938-8d33-823f36f04b75@gmail.com>
Date:   Tue, 8 Jun 2021 09:22:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608145951.24985-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 8:59 AM, Nicolas Dichtel wrote:
> My initial goal was to fix the default MTU, which is set to 65536, ie above
> the maximum defined in the driver: 65535 (ETH_MAX_MTU).
> 
> In fact, it's seems more consistent, wrt min_mtu, to set the max_mtu to
> IP6_MAX_MTU (65535 + sizeof(struct ipv6hdr)) and use it by default.
> 
> Let's also, for consistency, set the mtu in vrf_setup(). This function
> calls ether_setup(), which set the mtu to 1500. Thus, the whole mtu config
> is done in the same function.
> 
> Before the patch:
> $ ip link add blue type vrf table 1234
> $ ip link list blue
> 9: blue: <NOARP,MASTER> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether fa:f5:27:70:24:2a brd ff:ff:ff:ff:ff:ff
> $ ip link set dev blue mtu 65535
> $ ip link set dev blue mtu 65536
> Error: mtu greater than device maximum.
> 
> Fixes: 5055376a3b44 ("net: vrf: Fix ping failed when vrf mtu is set to 0")
> CC: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  drivers/net/vrf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


