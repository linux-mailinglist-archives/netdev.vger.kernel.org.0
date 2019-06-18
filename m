Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C5F49BFD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 10:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfFRI0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 04:26:10 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:8100 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRI0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 04:26:10 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id B9DBE5C1A40;
        Tue, 18 Jun 2019 16:26:07 +0800 (CST)
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <22ab95cb-9dca-1e48-4ca0-965d340e7d32@ucloud.cn>
Date:   Tue, 18 Jun 2019 16:26:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVSENLS0tLSUhITU5LSUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6Ajo4HDgzMhBWASIVIhhN
        ASIaCxJVSlVKTk1LQ09NSE1DSkpCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUxOSzcG
X-HM-Tid: 0a6b69b17cf92087kuqyb9dbe5c1a40
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/18/2019 6:42 AM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> Subject: Change bridge l3 dependency to meta protocol
>>>
>>> This examines skb->protocol instead of ethernet header type, which
>>> might be different when vlan is involved.
>>>  
>>> +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
>>> +		if (expr->payload.desc == &proto_ip ||
>>> +		    expr->payload.desc == &proto_ip6)
>>> +			desc = &proto_metaeth;
>>> +	}i
>> Is this sufficient to restrict the matching? Is this still buggy from
>> ingress?
> This is what netdev family uses as well (skb->protocol i mean).
> I'm not sure it will work for output however (haven't checked).
>
>> I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
>> the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
>> NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
>
> Another unresolved issue is presence of multiple vlan tags, so we might
> have to add yet another meta key to retrieve the l3 protocol in use

Maybe add a l3proto meta key can handle the multiple vlan tags case with the l3proto dependency.  It

should travese all the vlan tags and find the real l3 proto.


>
>
>
