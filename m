Return-Path: <netdev+bounces-6065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C09714A1B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3888C280E68
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620B86FDA;
	Mon, 29 May 2023 13:18:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED3D3D60
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:18:01 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B1411B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:17:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5147f5efeb5so5335898a12.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685366258; x=1687958258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KVHCP9GjMtC8qGNoGPmmcW2n7fokm+mXHG6bkqQl4dY=;
        b=03mfx0ayiG0g5gZAkaaZrOEZcURS53wiLiY5XKrCqoqeWUopFUtoCdP3lSOwwJjq9Y
         F0xuSja3LEukr90mGXgI48sG6D5PypA5AnBDO4iX5qMJRMjW4NxHLk+rKwqzvTYjLbFc
         bY68vk4vmVD89r1EExry645zx5+Sq36ZvbZRixZ62MPHDjxdhHpGuTDngrwV+PNFXkU/
         lQcQed/At5NP1pkIkTPbw7PgMUMdqQdpqm9dUrvsqKnxI6zFV6H2CpCWt4pYdg8eVCbv
         6IiJ7BiojjEnuLXxctttXWi5m+onKPW9J4r8KQCvBxWB4L83ukO0uyC1CxN+VoQl21HN
         2Ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685366258; x=1687958258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KVHCP9GjMtC8qGNoGPmmcW2n7fokm+mXHG6bkqQl4dY=;
        b=ls3lWQ3wibCCB9mohC/8VDFkbAntVayy+4/0WiWgb6uhKjj/Z0Y+sMfBoROy20KYMK
         TPI7EnFf+bZ2JL4t/9LZt5aPfaKRe7dYsE9c9FWunggp/8oA3W0dWCLVMCV7kdHsf4yT
         i5jctGBYqonLwqUdJU9uU0Waqg4qZ6fz4h1LaaIQcw0LtLLvNJKxNG663DmW/vvQPNmU
         55KAeAa3jI4det4HNHOBL4pGET8IdxNcY+eapPjILyB7LCqQ+j+WRE+3+4EMeA4KITkr
         i5974DHMF0TiSFkSVd9hGMRsw8vKT1aDmTsF+ZKsAaRiV54rJvDm46BMKdqBEB4GhIgI
         dO4g==
X-Gm-Message-State: AC+VfDzIBsjlGPJkeEMzl9yUA59k4kZkneWyEizFTmI1ZslEtEKBgrSu
	GJpC50KQNPfVE22EG3VYEtNGiQ==
X-Google-Smtp-Source: ACHHUZ5ehB7xMRH1caM3gKqELrLRKVaUdfl7akJJUHSnVGiZIYbODab67lQFivuY/qj4QWXAWKpprg==
X-Received: by 2002:a17:907:168d:b0:974:76:dcdd with SMTP id hc13-20020a170907168d00b009740076dcddmr4366969ejc.55.1685366257783;
        Mon, 29 May 2023 06:17:37 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id v19-20020a1709060b5300b0096621340285sm5914547ejg.198.2023.05.29.06.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 06:17:37 -0700 (PDT)
Message-ID: <58d3e95f-ee23-06c7-b690-64fe42b9c56b@blackwall.org>
Date: Mon, 29 May 2023 16:17:35 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 1/8] skbuff: bridge: Add layer 2 miss
 indication
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
 leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, roopa@nvidia.com, simon.horman@corigine.com
References: <20230529114835.372140-1-idosch@nvidia.com>
 <20230529114835.372140-2-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> For EVPN non-DF (Designated Forwarder) filtering we need to be able to
> prevent decapsulated traffic from being flooded to a multi-homed host.
> Filtering of multicast and broadcast traffic can be achieved using the
> following flower filter:
> 
>  # tc filter add dev bond0 egress pref 1 proto all flower indev vxlan0 dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 action drop
> 
> Unlike broadcast and multicast traffic, it is not currently possible to
> filter unknown unicast traffic. The classification into unknown unicast
> is performed by the bridge driver, but is not visible to other layers
> such as tc.
> 
> Solve this by adding a new 'l2_miss' bit to the tc skb extension. Clear
> the bit whenever a packet enters the bridge (received from a bridge port
> or transmitted via the bridge) and set it if the packet did not match an
> FDB or MDB entry. If there is no skb extension and the bit needs to be
> cleared, then do not allocate one as no extension is equivalent to the
> bit being cleared. The bit is not set for broadcast packets as they
> never perform a lookup and therefore never incur a miss.
> 
> A bit that is set for every flooded packet would also work for the
> current use case, but it does not allow us to differentiate between
> registered and unregistered multicast traffic, which might be useful in
> the future.
> 
> To keep the performance impact to a minimum, the marking of packets is
> guarded by the 'tc_skb_ext_tc' static key. When 'false', the skb is not
> touched and an skb extension is not allocated. Instead, only a
> 5 bytes nop is executed, as demonstrated below for the call site in
> br_handle_frame().
> 
> Before the patch:
> 
> ```
>         memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
>   c37b09:       49 c7 44 24 28 00 00    movq   $0x0,0x28(%r12)
>   c37b10:       00 00
> 
>         p = br_port_get_rcu(skb->dev);
>   c37b12:       49 8b 44 24 10          mov    0x10(%r12),%rax
>         memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
>   c37b17:       49 c7 44 24 30 00 00    movq   $0x0,0x30(%r12)
>   c37b1e:       00 00
>   c37b20:       49 c7 44 24 38 00 00    movq   $0x0,0x38(%r12)
>   c37b27:       00 00
> ```
> 
> After the patch (when static key is disabled):
> 
> ```
>         memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
>   c37c29:       49 c7 44 24 28 00 00    movq   $0x0,0x28(%r12)
>   c37c30:       00 00
>   c37c32:       49 8d 44 24 28          lea    0x28(%r12),%rax
>   c37c37:       48 c7 40 08 00 00 00    movq   $0x0,0x8(%rax)
>   c37c3e:       00
>   c37c3f:       48 c7 40 10 00 00 00    movq   $0x0,0x10(%rax)
>   c37c46:       00
> 
> #ifdef CONFIG_HAVE_JUMP_LABEL_HACK
> 
> static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
> {
>         asm_volatile_goto("1:"
>   c37c47:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>         br_tc_skb_miss_set(skb, false);
> 
>         p = br_port_get_rcu(skb->dev);
>   c37c4c:       49 8b 44 24 10          mov    0x10(%r12),%rax
> ```
> 
> Subsequent patches will extend the flower classifier to be able to match
> on the new 'l2_miss' bit and enable / disable the static key when
> filters that match on it are added / deleted.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Use tc skb extension instead of adding a bit to the skb.
>     * Do not mark broadcast packets as they never perform a lookup and
>       therefore never incur a miss.
> 
>  include/linux/skbuff.h  |  1 +
>  net/bridge/br_device.c  |  1 +
>  net/bridge/br_forward.c |  3 +++
>  net/bridge/br_input.c   |  1 +
>  net/bridge/br_private.h | 27 +++++++++++++++++++++++++++
>  5 files changed, 33 insertions(+)
> 

Nice approach.
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>



