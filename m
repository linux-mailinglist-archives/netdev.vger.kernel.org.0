Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5AC6BCA28
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCPI52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCPI5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:57:12 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663C013DE1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:55:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso2640241wmr.3
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678956939;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eLCjSCBDqMq/ciVVpyfzYuWBjZ8nlT4qHwYgluMAIAM=;
        b=GuW8V60Zy8eSbpYheOlmqkZlOIriPSrSI/NlE9pBhqmlXl4T74wFhwxbwk7mgyyISH
         pATgvo7UZcUEh8H06PgZ2m0vCdckNPgmVcflZukpW8Caqy85FFrrVVbxiWDa3JTgM4ih
         bNDx/GjZTU0D4WEWtKteeeI0UWPWIEcr+qAaGDUhUC1Y0e7CFyC8haS4mj0OFTGd7dGw
         RlWXZcsgufL8I5puKi6E/txz6MjNjd/AUonJCSc57uPZIGCfRxTLyzHKyAu7+GAkeFap
         Tykjmu4DAHRtf6uoY5e2PVJsMGn+1k6Dl9AuAmnPBbLa8zksAe82B1OW5gi8FKjHZhGd
         rBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678956939;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLCjSCBDqMq/ciVVpyfzYuWBjZ8nlT4qHwYgluMAIAM=;
        b=KJ0SEV+s1czy6amAsDVJhbf8JJNqah0tLaExtLk+m4f25nTLxkaSgf2d+TWIZJqGRo
         D53+iESYOKgvTtKqOPI4tjp20Y3Coyp+v9T/0FF+WxmP1uHiMmff0aXKzKuBsc1LnGWq
         fQz/SfpHOrZ3AKIX3kZJwikBxGvbkmoNazSY8VZq+e2IFFn5PoSU4tIcvSxbvFUIDzVH
         79dEXNI1yquBha6nnRus6cXiPWg1/Ftv+5UwCITRDULFQ5Qtn/babRsHwKDjuiMwnx4t
         5HFAu81v/apIB27wco8Y4xSkEyyz3W3Dijr3O5IlL/gqJ4zn6sT6W6EDdvDBr4nfvtit
         3kpw==
X-Gm-Message-State: AO0yUKWUUoMOm2jWFMI3EURjxdvqxPPAjDygrJ/+s+INIPWK4ouhNSe2
        h4JT7Wxl6y+CAS+H9QupfpLtBQ==
X-Google-Smtp-Source: AK7set+ohwPDh/6S1iVW3YxhaxNH2kKYgV1Sr9OgkFgYxfzoB3bUa7c4n6d+XCZ77q1YfXYqgatW2w==
X-Received: by 2002:a05:600c:a39b:b0:3ed:2311:4fb9 with SMTP id hn27-20020a05600ca39b00b003ed23114fb9mr7652951wmb.1.1678956939319;
        Thu, 16 Mar 2023 01:55:39 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c214700b003eaf666cbe0sm4291540wml.27.2023.03.16.01.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:55:39 -0700 (PDT)
Message-ID: <4e6c9f88-d241-1e5f-78c2-cf4f592750b9@blackwall.org>
Date:   Thu, 16 Mar 2023 10:55:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 09/11] vxlan: Add MDB data path support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230315131155.4071175-1-idosch@nvidia.com>
 <20230315131155.4071175-10-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230315131155.4071175-10-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 15:11, Ido Schimmel wrote:
> Integrate MDB support into the Tx path of the VXLAN driver, allowing it
> to selectively forward IP multicast traffic according to the matched MDB
> entry.
> 
> If MDB entries are configured (i.e., 'VXLAN_F_MDB' is set) and the
> packet is an IP multicast packet, perform up to three different lookups
> according to the following priority:
> 
> 1. For an (S, G) entry, using {Source VNI, Source IP, Destination IP}.
> 2. For a (*, G) entry, using {Source VNI, Destination IP}.
> 3. For the catchall MDB entry (0.0.0.0 or ::), using the source VNI.
> 
> The catchall MDB entry is similar to the catchall FDB entry
> (00:00:00:00:00:00) that is currently used to transmit BUM (broadcast,
> unknown unicast and multicast) traffic. However, unlike the catchall FDB
> entry, this entry is only used to transmit unregistered IP multicast
> traffic that is not link-local. Therefore, when configured, the catchall
> FDB entry will only transmit BULL (broadcast, unknown unicast,
> link-local multicast) traffic.
> 
> The catchall MDB entry is useful in deployments where inter-subnet
> multicast forwarding is used and not all the VTEPs in a tenant domain
> are members in all the broadcast domains. In such deployments it is
> advantageous to transmit BULL (broadcast, unknown unicast and link-local
> multicast) and unregistered IP multicast traffic on different tunnels.
> If the same tunnel was used, a VTEP only interested in IP multicast
> traffic would also pull all the BULL traffic and drop it as it is not a
> member in the originating broadcast domain [1].
> 
> If the packet did not match an MDB entry (or if the packet is not an IP
> multicast packet), return it to the Tx path, allowing it to be forwarded
> according to the FDB.
> 
> If the packet did match an MDB entry, forward it to the associated
> remote VTEPs. However, if the entry is a (*, G) entry and the associated
> remote is in INCLUDE mode, then skip over it as the source IP is not in
> its source list (otherwise the packet would have matched on an (S, G)
> entry). Similarly, if the associated remote is marked as BLOCKED (can
> only be set on (S, G) entries), then skip over it as well as the remote
> is in EXCLUDE mode and the source IP is in its source list.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Use htons() in 'case' instead of ntohs() in 'switch'.
> 
>  drivers/net/vxlan/vxlan_core.c    |  15 ++++
>  drivers/net/vxlan/vxlan_mdb.c     | 114 ++++++++++++++++++++++++++++++
>  drivers/net/vxlan/vxlan_private.h |   6 ++
>  3 files changed, 135 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


