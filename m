Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006653B0BDE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhFVRzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhFVRzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:55:23 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6737C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:53:06 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so2322023wme.3
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nK6XvUi1XHJh4gJT8GIP60RF/sTy1UMAu5Mfh5TijcI=;
        b=gYG8qYgRbbjnCxoXuu201wRxRmFAZ93B/VmYffbMRq/1+vjFww68dZY8q83mysv+qF
         GfWP2vfaHJssJjemDMGCsyFaIUB+B6JIjRwfKLRp2SNVj5PxGTLeKuRu0K2sImpQxglz
         aX7EVA6sij2uA+6lKOTOQqYy213ANeckDgcrDUVSTwICxLGh1M1j8YVtXu18jkrCppz5
         nmBOpCMi5/a3fmLGryg7+KloYlcKmfOgttKXSds7pZNcy1JA0oZ0UA2x+KjBTSbf06yZ
         4Q3+XOGxWUqoUZvG+/gUPHrityLAhwwoXNQ3jdfORf81F6D9QDiq3BOkEIY0DqTT7+HB
         crTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nK6XvUi1XHJh4gJT8GIP60RF/sTy1UMAu5Mfh5TijcI=;
        b=fotRC1woDTMnlcyPmQh8iA2TN6WlRonvFegzQlaqB4GU8rSfxsbHN3sFCZ9KsndoEJ
         xSPKcjUuPeCQAlNvPH3PR8ZpCSExh4Ro3iRXMOrBzutK3OZN0IN8yaOz5C37WK6xK8bf
         uR7LHs5pVdJKnDQL+r28dEJ5bKiMsO0LLtyQ9+/wpQo8kV5a/8dOUKOIPshM35xgLnn/
         a7oR5ve9uSknqytMIG5t8nkPv1rCGAKzbs328FU/8KOWaRuiYjrITOUXI6bRTUONPR+y
         nNHlyXBiApEeDl3+Lf2YDSS5+mqZ7hR36Vvqco+q8Fd+0QXLHrktOg0gD8OmbnpeL9JP
         R/aw==
X-Gm-Message-State: AOAM532l0Offh6XkZfSTtX8uXeuO63VdZta8g4oChRTY1pSI/Z8A6tYt
        No/ZPazcMd60JSv6qz/bFp4=
X-Google-Smtp-Source: ABdhPJwSRTHepftKRX7WE7yqh2X5ws8QOQYRqXpFPruUHIpWZ+l+2RTilB0vjO+5Ieuzszau8N/Mnw==
X-Received: by 2002:a05:600c:4f53:: with SMTP id m19mr5822436wmq.36.1624384385339;
        Tue, 22 Jun 2021 10:53:05 -0700 (PDT)
Received: from [192.168.181.98] (15.248.23.93.rev.sfr.net. [93.23.248.15])
        by smtp.gmail.com with ESMTPSA id v16sm95347wrr.6.2021.06.22.10.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:53:04 -0700 (PDT)
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
To:     zhudi <zhudi21@huawei.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rose.chen@huawei.com
References: <20210622030929.51295-1-zhudi21@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <59607f35-f9af-47f3-bbb2-cf9e4ddee391@gmail.com>
Date:   Tue, 22 Jun 2021 19:53:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622030929.51295-1-zhudi21@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 5:09 AM, zhudi wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> The following steps will definitely cause the kernel to crash:
> 	ip link add vrf1 type vrf table 1
> 	modprobe bonding.ko max_bonds=1
> 	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
> 	rmmod bonding
> 
> The root cause is that: When the VRF is added to the slave device,
> it will fail, and some cleaning work will be done. because VRF device
> has IFF_MASTER flag, cleanup process  will not clear the IFF_BONDING flag.
> Then, when we unload the bonding module, unregister_netdevice_notifier()
> will treat the VRF device as a bond master device and treat netdev_priv()
> as struct bonding{} which actually is struct net_vrf{}.
> 
> By analyzing the processing logic of bond_enslave(), it seems that
> it is not allowed to add the slave device with the IFF_MASTER flag, so
> we need to add a code check for this situation.
> 
> Signed-off-by: Di Zhu <zhudi21@huawei.com>
> ---
>  drivers/net/bonding/bond_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index c5a646d06102..16840c9bc00d 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1601,6 +1601,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  	int link_reporting;
>  	int res = 0, i;
>  
> +	if (slave_dev->flags & IFF_MASTER) {

Missing NL_SET_ERR_MSG( ?

> +		netdev_err(bond_dev,
> +			   "Error: Device with IFF_MASTER cannot be enslaved\n");
> +		return -EPERM;
> +	}
> +
>  	if (!bond->params.use_carrier &&
>  	    slave_dev->ethtool_ops->get_link == NULL &&
>  	    slave_ops->ndo_do_ioctl == NULL) {
> 

This is strange, can you tell us why we keep the following lines after your patch ?

	if (bond_dev == slave_dev) {
		NL_SET_ERR_MSG(extack, "Cannot enslave bond to itself.");
		netdev_err(bond_dev, "cannot enslave bond to itself.\n");
		return -EPERM;
	}

I was under the impression that a stack of bonding devices was allowed.

