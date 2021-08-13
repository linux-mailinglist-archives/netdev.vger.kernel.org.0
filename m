Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00D03EBCA2
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhHMTks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhHMTkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628883617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InGJG+98tXp8QBzxGwgPAHA4i1vKXMRIvHbCDns0IBU=;
        b=Qt7WZZCtB2Y92JBoULQ3o1ZrTcFimkLZFZb17BoV+8/UH8HR+AKrHteFDZuKWhRy3EvZkP
        ZJPtAbNTpS/tiLVDG/Q54w3HttL7KdlVITwjiRhMgilPhwBeabKm/Z6UfK124ALACtVXq6
        61QEU7ryK/ShfgODf3K4GE/P4WFXfro=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-kasbEd3iMWi_svzCEDd1_A-1; Fri, 13 Aug 2021 15:40:15 -0400
X-MC-Unique: kasbEd3iMWi_svzCEDd1_A-1
Received: by mail-qk1-f200.google.com with SMTP id w189-20020a3762c60000b02903d2cbfa310dso1892385qkb.16
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 12:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InGJG+98tXp8QBzxGwgPAHA4i1vKXMRIvHbCDns0IBU=;
        b=CPY21aAgVVb7ZvCBYM20FXNVZ4vZS0F6TBXraUGgNqOyHLVqeSeZilJEKfs/3VgDMm
         o51izZIccN+s/PZpZlOZrF7vNiky+PyNEUFGh9m2MTQhXbWG98+fnaUtgS2IWEvRItom
         qC4InfHLnZV926T+AaPv9WSNl4Cmta1rushhM06Bn3FJN5ktH/Uc9lrFe8xAoiGY4ZnW
         JziA3ulNGL92U4tHg8dwCGOlYXSgVEzsgugPWwv4BNGeZbhq9osaP+PJWBrB87Y0x5cP
         QtFhyWIK3aHTptivgPY40ezcjdJVbqI/QEldga7wMZw9f3gNaKQZSpokxrSD1kyKd9Oy
         hxdw==
X-Gm-Message-State: AOAM530wMlUsiTif2zquyEwUmT6/wGueiv3gduP7G1cWZDx20SDWv92v
        Orlge8xY3Q60kv5L8ZesEfGSqFd9oE68vuFSz9AjzKEaauzuxhoUFtoffn1yY0YUFJRN21krDoi
        SCiB6FkUWcssc2WIOpCGZ130wGoCb/1/24aaDpYj/BisybWFWaLI3X9iQiqpXjypOSHmI
X-Received: by 2002:a05:620a:28cb:: with SMTP id l11mr3632142qkp.384.1628883615229;
        Fri, 13 Aug 2021 12:40:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytd9825/cd4Foh8prgX6BNzrA4Lvowxf8WnWfIWv/XqMIalJlwFJBlwumYuRJ6WmdHgIN0jw==
X-Received: by 2002:a05:620a:28cb:: with SMTP id l11mr3632116qkp.384.1628883614955;
        Fri, 13 Aug 2021 12:40:14 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id x27sm1356762qkj.1.2021.08.13.12.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 12:40:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
To:     Jussi Maki <joamaki@gmail.com>, netdev@vger.kernel.org
References: <20210812145241.12449-1-joamaki@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <296b11ac-dd4b-6c7e-b1ce-506e8929a853@redhat.com>
Date:   Fri, 13 Aug 2021 15:40:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812145241.12449-1-joamaki@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/21 10:52 AM, Jussi Maki wrote:
> The new vlan+srcmac xmit policy is not implementable with XDP since
> in many cases the 802.1Q payload is not present in the packet. This
> can be for example due to hardware offload or in the case of veth
> due to use of skbuffs internally.
> 
> This also fixes the NULL deref with the vlan+srcmac xmit policy
> reported by Jonathan Toppins by additionally checking the skb
> pointer.
> 
> Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with xdp_buff")
> Reported-by: Jonathan Toppins <jtoppins@redhat.com>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>

Looks good, thanks.

Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>

> ---
>   drivers/net/bonding/bond_main.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index c0db4e2b2462..04158a8368e4 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -322,9 +322,15 @@ static bool bond_xdp_check(struct bonding *bond)
>   	switch (BOND_MODE(bond)) {
>   	case BOND_MODE_ROUNDROBIN:
>   	case BOND_MODE_ACTIVEBACKUP:
> +		return true;
>   	case BOND_MODE_8023AD:
>   	case BOND_MODE_XOR:
> -		return true;
> +		/* vlan+srcmac is not supported with XDP as in most cases the 802.1q
> +		 * payload is not in the packet due to hardware offload.
> +		 */
> +		if (bond->params.xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
> +			return true;
> +		fallthrough;
>   	default:
>   		return false;
>   	}
> @@ -3744,9 +3750,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *
>   
>   static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
>   {
> -	struct ethhdr *mac_hdr;
>   	u32 srcmac_vendor = 0, srcmac_dev = 0;
> -	u16 vlan;
> +	struct ethhdr *mac_hdr;
> +	u16 vlan = 0;
>   	int i;
>   
>   	data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
> @@ -3760,10 +3766,8 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhof
>   	for (i = 3; i < ETH_ALEN; i++)
>   		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>   
> -	if (!skb_vlan_tag_present(skb))
> -		return srcmac_vendor ^ srcmac_dev;
> -
> -	vlan = skb_vlan_tag_get(skb);
> +	if (skb && skb_vlan_tag_present(skb))
> +		vlan = skb_vlan_tag_get(skb);
>   
>   	return vlan ^ srcmac_vendor ^ srcmac_dev;
>   }
> 

