Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DCD6294FF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiKOJ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiKOJ5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:57:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8A165F9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668506211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nu3ArU28TM2hYIfKLCvBtkAP2klHTLMumzmyu1fNa5U=;
        b=a7+sc3viiBz7V72RdTAg61KF/op8xR611D0rI8nqTotJwT+0v+TWH6u/kGHSDbBk45ynOW
        qxwWGsQm2w7GDkBdU0T4S2fcQhzcQqnVRoqeoTIKVoa06SRMPnSh9OVijgYJtfiu9YGUJQ
        XW0oft9F1ZStEDnWpZfh5VfLWAin4Js=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-X_SylCwLO7ST4JKDp2hlLg-1; Tue, 15 Nov 2022 04:56:49 -0500
X-MC-Unique: X_SylCwLO7ST4JKDp2hlLg-1
Received: by mail-qv1-f71.google.com with SMTP id d8-20020a0cfe88000000b004bb65193fdcso10254155qvs.12
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nu3ArU28TM2hYIfKLCvBtkAP2klHTLMumzmyu1fNa5U=;
        b=VwjYTYhuFKfJF8Os5bmOxdvRXzS9weNJ5rQtfpbvwdx9WFaMbOHrrPrl7kfs/4uyl3
         DN+7tT/v+3yZobHvRorFLmBdkNr1UV4uxFlAhGyeH5Ed46N97QhCfKrnlidqSy27JUh2
         2px/bsVDo5Z9N0YjHVaV52NdG2Y3AhyUs4/mi6zHDORe124tD2DuZk7lCKaxy4NXCZ59
         dPfc26kebHheWib479kSKyNIBe2o7QOJFv29XIxdhWzDOOBu1zKYCh5yVoz4eMPB+MF8
         MXy8qrwJo9mmff8PoIRYa3hNmKsfMACzTXxHqhTtQtS1B/W849NkYbsEiODUt5bNFwEl
         P/ww==
X-Gm-Message-State: ANoB5pmQKW3WcQ0gLhapobTBg1HjRrmCNQNcfoCuAVfl5mikCZHSp3Pl
        h9RuqE2d60mkKCUOAh1qgdUXhlvJijDM8ajcXVWoyAp3AD8PEDZPeDXz1kOJ6pPdisl8mcKmMGY
        8ekScaeqwE0thyzE2
X-Received: by 2002:a0c:eda2:0:b0:4bb:6692:a5a6 with SMTP id h2-20020a0ceda2000000b004bb6692a5a6mr15927771qvr.108.1668506209433;
        Tue, 15 Nov 2022 01:56:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5qErtemVdLPkg6MKl6FsmY7VSbcQ3GZi2WzT/IrqnFSATo+99+GcFPnsuSsEzWBObGu5uCDA==
X-Received: by 2002:a0c:eda2:0:b0:4bb:6692:a5a6 with SMTP id h2-20020a0ceda2000000b004bb6692a5a6mr15927757qvr.108.1668506209169;
        Tue, 15 Nov 2022 01:56:49 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id l5-20020ac87245000000b0039cc7ebf46bsm6870110qtp.93.2022.11.15.01.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:56:48 -0800 (PST)
Message-ID: <205d812ab74d721f4345eabcf3e5a86a710b40da.camel@redhat.com>
Subject: Re: [PATCH] net: neigh: decrement the family specific qlen
From:   Paolo Abeni <pabeni@redhat.com>
To:     Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Denis V. Lunev" <den@openvz.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        Yuwei Wang <wangyuweihx@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Nov 2022 10:56:45 +0100
In-Reply-To: <Y295+9+JDjqRWbwU@x1.ze-it.at>
References: <Y295+9+JDjqRWbwU@x1.ze-it.at>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Sat, 2022-11-12 at 11:48 +0100, Thomas Zeitlhofer wrote:
> Commit 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit
> per-device") introduced the length counter qlen in struct neigh_parms.
> There are separate neigh_parms instances for IPv4/ARP and IPv6/ND, and
> while the family specific qlen is incremented in pneigh_enqueue(), the
> mentioned commit decrements always the IPv4/ARP specific qlen,
> regardless of the currently processed family, in pneigh_queue_purge()
> and neigh_proxy_process().
> 
> As a result, with IPv6/ND, the family specific qlen is only incremented
> (and never decremented) until it exceeds PROXY_QLEN, and then, according
> to the check in pneigh_enqueue(), neighbor solicitations are not
> answered anymore. As an example, this is noted when using the
> subnet-router anycast address to access a Linux router. After a certain
> amount of time (in the observed case, qlen exceeded PROXY_QLEN after two
> days), the Linux router stops answering neighbor solicitations for its
> subnet-router anycast address and effectively becomes unreachable.
> 
> Another result with IPv6/ND is that the IPv4/ARP specific qlen is
> decremented more often than incremented. This leads to negative qlen
> values, as a signed integer has been used for the length counter qlen,
> and potentially to an integer overflow.
> 
> Fix this by introducing the helper function neigh_parms_qlen_dec(),
> which decrements the family specific qlen. Thereby, make use of the
> existing helper function neigh_get_dev_parms_rcu(), whose definition
> therefore needs to be placed earlier in neighbour.c. Take the family
> member from struct neigh_table to determine the currently processed
> family and appropriately call neigh_parms_qlen_dec() from
> pneigh_queue_purge() and neigh_proxy_process().
> 
> Additionally, use an unsigned integer for the length counter qlen.
> 
> Fixes: 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit per-device")
> Signed-off-by: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
> ---
>  include/net/neighbour.h |  2 +-
>  net/core/neighbour.c    | 58 +++++++++++++++++++++--------------------
>  2 files changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 20745cf7ae1a..cc0b65b7c829 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -83,7 +83,7 @@ struct neigh_parms {
>  	struct rcu_head rcu_head;
>  
>  	int	reachable_time;
> -	int	qlen;
> +	__u32	qlen;
>  	int	data[NEIGH_VAR_DATA_MAX];
>  	DECLARE_BITMAP(data_state, NEIGH_VAR_DATA_MAX);
>  };

The patch LGTM, but why did you use __u32 above? this is not part of
uAPI, plain u32 should be fine. 

Thanks!

Paolo

