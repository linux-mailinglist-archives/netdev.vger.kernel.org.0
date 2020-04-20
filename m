Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D71B10A9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDTPsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgDTPsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:48:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8E4C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:48:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g2so4099540plo.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K998MhLuLT+vSFATUL8b4xc6Vw/qBHjQUarB0WVoK0w=;
        b=VWlxiYkdg7ZASykfdVwMuVwwmmUwW/ze47cX2l7Y1w3VzUsnAkRrcOtOAnvgkyjHmQ
         44x8YqazaSZWI9RAjd0K8YuZMScLvcyzJkfRgcmBx4KWtJ2Wz58V32dOx96+PFhvImHL
         ipOVek1OOWccFXIebK4lQBABXlng10BF3a9qYMWDGoOvCiswp8xadPt+DcmEpiQcmVlh
         xWa/ZWftr5bHGjML+h/bRfkPWfuOS24t9MKj5n/AUo6yGQoCaQDCWkCDl+rHKrNYflM/
         QOy/L4PBG2971ZDRdTVynVuEiaVZu4rI8msrIna/b5AITy069N9GBnNYGweGFBxqxGcG
         q2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K998MhLuLT+vSFATUL8b4xc6Vw/qBHjQUarB0WVoK0w=;
        b=GzPKX9geS9D1z9VYbPlYumEhQJ9VNkN0JT/BFfuoQPwfxEgMYWeZNKlcMw7caJGnEh
         NkYu94z5FF5968h4TDjSxfuwBlxaLE5oRlt8YS8iqJnKqeM0HOktgyLj8GHogK1W43DV
         EBaXcNOiOpfRG5Zd5pjc6YSWPafdhhe5NT/nxRgxDSw58/cSQTyGFFo4VyCBc9CoBZr+
         jgpilK3lv70DVqMDU/F2MXSCoDz+jpqrAPtTPbPmzlYf62xabQKEXfJzYUksKxjL54tK
         xjCnfmBa9XyRCSMugB/kHQ3GNqr1PleWG9g2FGv5HyZDPf1DAN+RB4zZxggf/hFmKjZ7
         OF7Q==
X-Gm-Message-State: AGi0PuagtGAj/CPZppqFOEuMd0WbONgcf/zAkVjh/zwo97KaJveDws3w
        f3vgl6YZggbf2aAq7LpHRQDU/mLJ
X-Google-Smtp-Source: APiQypLIUG+z4q4dS+7KqRwsh85e9SHqg3aaKebEhWXrmjLiyqZ/Qy/+5UR1wowOa9kKVP9Aw3wyqw==
X-Received: by 2002:a17:902:a601:: with SMTP id u1mr17392975plq.300.1587397718368;
        Mon, 20 Apr 2020 08:48:38 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c10sm1489257pgh.48.2020.04.20.08.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 08:48:37 -0700 (PDT)
Subject: Re: [PATCH net-next] macvlan: silence RCU list debugging warning
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200420115930.135509-1-weiyongjun1@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <643f9363-9e25-7e13-a5cf-fe189268b445@gmail.com>
Date:   Mon, 20 Apr 2020 08:48:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200420115930.135509-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/20 4:59 AM, Wei Yongjun wrote:
> macvlan_hash_lookup() uses list_for_each_entry_rcu() for traversing
> outside of an RCU read side critical section but under the protection
> of rtnl_mutex. Hence, add the corresponding lockdep expression to
> silence the following false-positive warning:
>


This changelog is misleading.

macvlan_hash_lookup() _can_ be used under RCU only, in its fast path.

So you can not claim that it is run with RTNL held.

Please be precise in the changelogs

Thanks.
 
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc1-next-20200416-00003-ga3b8d28bc #1 Not tainted
> -----------------------------
> drivers/net/macvlan.c:126 RCU-list traversed in non-reader section!!
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/macvlan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index e7289d67268f..654c1fa11826 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -123,7 +123,8 @@ static struct macvlan_dev *macvlan_hash_lookup(const struct macvlan_port *port,
>  	struct macvlan_dev *vlan;
>  	u32 idx = macvlan_eth_hash(addr);
>  
> -	hlist_for_each_entry_rcu(vlan, &port->vlan_hash[idx], hlist) {
> +	hlist_for_each_entry_rcu(vlan, &port->vlan_hash[idx], hlist,
> +				 lockdep_rtnl_is_held()) {
>  		if (ether_addr_equal_64bits(vlan->dev->dev_addr, addr))
>  			return vlan;
>  	}
> 
