Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A7E6B93C4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCNM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCNM2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:28:44 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F313136C3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:26:56 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id m2so1382813wrh.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678796671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yes7QEaOi79y6U8Z5dhSkT9SxmbIBFirhjY5n/2F+XM=;
        b=QT6d/8fsy65eJA1Yf4vpCTO36EWCWaDL2H1NFl0C1cJVlMDBafH5itEV4D0aLg0uVJ
         fHzId/68SRkeRveCrIUeNcYWMLGqSusyfJO/Kjv+swe9/ahi5es68FtzugfEhDWB6RNS
         ihou2CKBrXQxRXcHQk3wlAFIWcxu4xrEiKN+AWYFnHffP1X5V2pZpolWyfDWbiO6HKx/
         6KjNU53i/257nsZbV6PBfoIyOZcfjXn/mqI6eUoY6TVMwCzj3cqrhpdromCmVV8ND6on
         KuiaDr1V/xULLa+Q3xhT4+vRVSMDPkTDHjeVqiN+nfoA/H07zRKs/YW5y+F0xQuaefZ0
         t6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678796671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yes7QEaOi79y6U8Z5dhSkT9SxmbIBFirhjY5n/2F+XM=;
        b=FvTrgQIRHTt0gDh30o+wZ+vdjyEfr+UVOVz2YBo3DCGt9xGRzi+N3C3kC+GW9nokOi
         Yd0BqqTmqNF/fZa6a3LYL0KIwGQQ9zzUrDoOmfj/3N0am14oNErjjACjFWS70F3ADd3K
         tkjTE/T6NgtPXKc9ZTN6iUQ5XLslx1SqJYDeOVPRg/KXBzbfooOcaEbTAlzgysL6mxXf
         s8G461/U5QKJR4ad6tBfnN2Kc3HHV543TN7ygYXHLR4kHr1r3C8Ddh5M7Pn9Lezrvv+r
         HoVsLnp7xil7cJUmWYiwSxSrnR87YKxjbivalp9b59UHOMf9Wh2oETuJ3vbGDCHo0mPy
         TcBw==
X-Gm-Message-State: AO0yUKU4bwlMEsnT4uUQAA/h+12bhNaPWV72LIesERjwcWuywiOKtBJb
        RFeqjdbMzk61v5Oryilk0tkUDg==
X-Google-Smtp-Source: AK7set+fYF8Q8u+N96L/zMmlualW1akSY9RXnyPjsvBz+jAOMXrQMrout7b0eNafXpUOLyCsMEn1rA==
X-Received: by 2002:a5d:4ed0:0:b0:2ce:aeb1:91a4 with SMTP id s16-20020a5d4ed0000000b002ceaeb191a4mr5967034wrv.60.1678796670938;
        Tue, 14 Mar 2023 05:24:30 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d678f000000b002cda9aa1dc1sm1969434wru.111.2023.03.14.05.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 05:24:30 -0700 (PDT)
Message-ID: <ea099909-a205-ed4c-5382-64a01435c23a@blackwall.org>
Date:   Tue, 14 Mar 2023 14:24:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 07/11] vxlan: mdb: Add MDB control path support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-8-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-8-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Implement MDB control path support, enabling the creation, deletion,
> replacement and dumping of MDB entries in a similar fashion to the
> bridge driver. Unlike the bridge driver, each entry stores a list of
> remote VTEPs to which matched packets need to be replicated to and not a
> list of bridge ports.
> 
> The motivating use case is the installation of MDB entries by a user
> space control plane in response to received EVPN routes. As such, only
> allow permanent MDB entries to be installed and do not implement
> snooping functionality, avoiding a lot of unnecessary complexity.
> 
> Since entries can only be modified by user space under RTNL, use RTNL as
> the write lock. Use RCU to ensure that MDB entries and remotes are not
> freed while being accessed from the data path during transmission.
> 
> In terms of uAPI, reuse the existing MDB netlink interface, but add a
> few new attributes to request and response messages:
> 
> * IP address of the destination VXLAN tunnel endpoint where the
>   multicast receivers reside.
> 
> * UDP destination port number to use to connect to the remote VXLAN
>   tunnel endpoint.
> 
> * VXLAN VNI Network Identifier to use to connect to the remote VXLAN
>   tunnel endpoint. Required when Ingress Replication (IR) is used and
>   the remote VTEP is not a member of originating broadcast domain
>   (VLAN/VNI) [1].
> 
> * Source VNI Network Identifier the MDB entry belongs to. Used only when
>   the VXLAN device is in external mode.
> 
> * Interface index of the outgoing interface to reach the remote VXLAN
>   tunnel endpoint. This is required when the underlay destination IP is
>   multicast (P2MP), as the multicast routing tables are not consulted.
> 
> All the new attributes are added under the 'MDBA_SET_ENTRY_ATTRS' nest
> which is strictly validated by the bridge driver, thereby automatically
> rejecting the new attributes.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-3.2.2
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Remove restrictions regarding mixing of multicast and unicast remote
>       destination IPs in an MDB entry. While such configuration does not
>       make sense to me, it is no forbidden by the VXLAN FDB code and does
>       not crash the kernel.
>     * Fix check regarding all-zeros MDB entry and source.
> 
>  drivers/net/vxlan/Makefile        |    2 +-
>  drivers/net/vxlan/vxlan_core.c    |    8 +
>  drivers/net/vxlan/vxlan_mdb.c     | 1341 +++++++++++++++++++++++++++++
>  drivers/net/vxlan/vxlan_private.h |   31 +
>  include/net/vxlan.h               |    5 +
>  include/uapi/linux/if_bridge.h    |   10 +
>  6 files changed, 1396 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/vxlan/vxlan_mdb.c


Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

