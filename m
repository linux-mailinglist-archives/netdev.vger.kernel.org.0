Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F96633851
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiKVJZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiKVJZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:25:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26F49B56
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669109068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3VVqk1FobqmR1kglBG91dZn4+J8B8jTIvbBuAdolWs=;
        b=GKLkBBdot85n653yo60XkRsaMo+QSqsutxpoNXnqBILWOvOqQy038jsAVzXaFqJTq8ca6A
        DPehU+6ujrA4fD+c/bzxp0b4KM19XjcYn0Jva6TDCeAmPPW5MZ2xGqgLC6KXxRhAJBwCPd
        jU2keMJNmazYGdC4GjTYEUmK265uikk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-252-K31Ka5ufNLOyz1AnBxJeeg-1; Tue, 22 Nov 2022 04:24:26 -0500
X-MC-Unique: K31Ka5ufNLOyz1AnBxJeeg-1
Received: by mail-qk1-f197.google.com with SMTP id w4-20020a05620a444400b006fa24b2f394so18337793qkp.15
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:24:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z3VVqk1FobqmR1kglBG91dZn4+J8B8jTIvbBuAdolWs=;
        b=MuIuErU+hbwFzn2NMNY1uNTvTUfhuUMRLt0sCVdmyWvTIZZ9z3yi1QPZhY+wQZZ86s
         Yc2rBvGgLsfeaPvSjCP1PdvLxqla1xz+g33fWcOKUV3WtuLM6Wf/cLzQ1oChljR4WWz0
         qMU1y9Q84wii0K0SEJ0V3r4NVOK30Xvfq6kiae/S6DCRhiLC65CBTia2VwA/VbTS6Vq6
         jiK4O53tAZjiFipRe7M3tmte3slAIaWN/EIrbLuKjX163+sVTguUUIdsDxzX85d9FGx+
         FzvrLp4NXKtB5niW5zc6PotAUuPGPDUdJWqNY1rr9oDKelc9f5Z3EdR9+tw2ABDxtcmi
         7kBA==
X-Gm-Message-State: ANoB5pnyRzqWDZ/V4/QFjIo6u66imeqluYOBXNM60zXIJvNZKeNEb84R
        M2m0k68RFkmbm7pRy1BA554hMkPQsNIXh6k7X34jicNR36qP23ya7I75541fYKalhX38d4m+m16
        Vx1GGSgf4WCL/TXH1
X-Received: by 2002:a05:620a:459f:b0:6fa:f76d:bbc1 with SMTP id bp31-20020a05620a459f00b006faf76dbbc1mr2670130qkb.11.1669109065982;
        Tue, 22 Nov 2022 01:24:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4NndHTnC1enH5ZhldwUXr78bILEXUWFS8kgfAOXZhJi6hWQbrf6QnncAM1MNDAVH3b80T1qw==
X-Received: by 2002:a05:620a:459f:b0:6fa:f76d:bbc1 with SMTP id bp31-20020a05620a459f00b006faf76dbbc1mr2670113qkb.11.1669109065733;
        Tue, 22 Nov 2022 01:24:25 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id i10-20020a05620a404a00b006bb8b5b79efsm10069093qko.129.2022.11.22.01.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 01:24:25 -0800 (PST)
Message-ID: <5b8e8eab4cf2f46f4ff6727097fefaf9e17a9c3b.camel@redhat.com>
Subject: Re: [net-next PATCH] octeontx2-pf: Add support to filter packet
 based on IP fragment
From:   Paolo Abeni <pabeni@redhat.com>
To:     Suman Ghosh <sumang@marvell.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com, jerinj@marvell.com, gakula@marvell.com,
        hkelam@marvell.com, lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Nov 2022 10:24:21 +0100
In-Reply-To: <20221118062248.2532370-1-sumang@marvell.com>
References: <20221118062248.2532370-1-sumang@marvell.com>
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

On Fri, 2022-11-18 at 11:52 +0530, Suman Ghosh wrote:
> 1. Added support to filter packets based on IP fragment.
> For IPv4 packets check for ip_flag == 0x20 (more fragment bit set).
> For IPv6 packets check for next_header == 0x2c (next_header set to
> 'fragment headre for IPv6')

typo above  ^^^^^^ header

> @@ -891,10 +896,22 @@ static int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
>  			req->features |= BIT_ULL(NPC_OUTER_VID);
>  		}
>  
> -		/* Not Drop/Direct to queue but use action in default entry */
> -		if (fsp->m_ext.data[1] &&
> -		    fsp->h_ext.data[1] == cpu_to_be32(OTX2_DEFAULT_ACTION))
> -			req->op = NIX_RX_ACTION_DEFAULT;
> +		if (fsp->m_ext.data[1]) {
> +			if (flow_type == IP_USER_FLOW) {
> +				if (be32_to_cpu(fsp->h_ext.data[1]) != 0x20)
> +					return -EINVAL;
> +
> +				pkt->ip_flag = be32_to_cpu(fsp->h_ext.data[1]);
> +				pmask->ip_flag = fsp->m_ext.data[1];

This causes a warning:

../drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c:882:48: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c:882:48:    expected unsigned char [usertype] ip_flag
../drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c:882:48:    got restricted __be32

and looks wrong: both pkt->ip_flag and pmask->ip_flag should get
be32_to_cpu, or neither of them

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> index e64318c110fd..a4a85e075eeb 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> @@ -532,6 +532,31 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
>  			req->features |= BIT_ULL(NPC_IPPROTO_ICMP6);
>  	}
>  
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
> +		struct flow_match_control match;
> +
> +		flow_rule_match_control(rule, &match);
> +		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
> +			netdev_info(nic->netdev, "HW doesn't support frag first/later");

Here and below you are better off reporting the error via the extack:
f->common.extack.


Cheers,

Paolo

