Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2242C25AF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgKXM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:29:00 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10089 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXM3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:29:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbcfc920001>; Tue, 24 Nov 2020 04:29:06 -0800
Received: from [172.27.14.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 12:28:51 +0000
Subject: Re: [PATCH iproute2 1/1] tc flower: fix parsing vlan_id and vlan_prio
To:     <netdev@vger.kernel.org>
CC:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>, <zahari.doychev@linux.com>,
        <jianbol@mellanox.com>, <jhs@mojatatu.com>
References: <20201124122641.46696-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <ceb8f7c3-04f9-1d6c-f1aa-4c5690ddccc8@nvidia.com>
Date:   Tue, 24 Nov 2020 14:28:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124122641.46696-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606220946; bh=2xR3/lUsfGkem8KEe5NGki6utNP0+T3hrtUSFpvN0x8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=kyQ/xOsRc6nLLVv8uf4gZQOtLC5U9cT+yokqSFn0CyDYO2xJrKPExoefYxPCfXLO+
         aGC25MWX6xAfCOQCcFtirNLPhACMIFmPp9lkGfnLYtZ33TmA47Acbc9LM4cmHVyt0X
         z8BitGvPPeCeaR3Gh38XPQAI5OjeZ4YcNbhMEFFR6JxAxQW8xzJDwWHMtjz+6b/J80
         Qq8rKBj4ctH21LmIA60v0Up1LUEpYhmwqZG1QSwE/rxO7YipNVEWi63SgxDe4s4oUa
         PAm/SPWhKOe6Kvqdkv6V1MWOyJestYY53tC4+SdiBIkCddy3J2fh4kTxT+Tci8rRUj
         quBmub/LTttvw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-11-24 2:26 PM, Roi Dayan wrote:
> When protocol is vlan then eth_type is set to the vlan eth type.
> So when parsing vlan_id and vlan_prio need to check tc_proto
> is vlan and not eth_type.
> 
> Fixes: 4c551369e083 ("tc flower: use right ethertype in icmp/arp parsing")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>   tc/f_flower.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 58e1140d7391..9b278f3c0e83 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -1432,7 +1432,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>   			__u16 vid;
>   
>   			NEXT_ARG();
> -			if (!eth_type_vlan(eth_type)) {
> +			if (!eth_type_vlan(tc_proto)) {
>   				fprintf(stderr, "Can't set \"vlan_id\" if ethertype isn't 802.1Q or 802.1AD\n");
>   				return -1;
>   			}
> @@ -1446,7 +1446,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>   			__u8 vlan_prio;
>   
>   			NEXT_ARG();
> -			if (!eth_type_vlan(eth_type)) {
> +			if (!eth_type_vlan(tc_proto)) {
>   				fprintf(stderr, "Can't set \"vlan_prio\" if ethertype isn't 802.1Q or 802.1AD\n");
>   				return -1;
>   			}
> 


sorry should have tagged as iproute2-next.
ignore this i sent with correct tag.
