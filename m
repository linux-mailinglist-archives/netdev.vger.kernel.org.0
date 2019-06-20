Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4981D4C836
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfFTHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:20:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42910 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTHUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 03:20:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so1810544wrl.9
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 00:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5+cZZQUiAbSFZ5vyqDnl6i0sE8+BN4xzCapTjFH6GZ0=;
        b=NKyS9gvG9OoNVIU+wvtPkKl9LryqEO3a6YKp09Ltgm2Fy2zXIaW8+E4EQ12u7PS2e5
         8SdpcYMCN6RM9rvJzkG08F/aN5s6RwMWqJBrW6VgRebiPjO4Cn/K87QL7bLl9IHdCIhn
         UPNizEIG4VXvN0Hn+imu5VErvswc4D7xZte6EuJyp/h0q/Y3YHkIMjmrCjEZiUbUvF6Y
         ruTi9vRSxs7IkMW0vU9Tagcc4F4LV1PGouu5bl7W1pU+LpTWskTQrVAI99PkoEWuJX7/
         hIINIgntTJZjYDmA3oVCKI8raOCSyNQSnoDdAO+rvA/gM70m8rf5V/g14DMv3MTB7YGY
         0SlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5+cZZQUiAbSFZ5vyqDnl6i0sE8+BN4xzCapTjFH6GZ0=;
        b=JaVNuJpfUBrRMa3uAjLjefYMTTmLGdVuVKMH9E5qw0Ed/SCXqquumiywoCaresxM/f
         yVwUF2bRq/K4VtdLPHv2bwVNi+PE1Z3QOkYJWMJmEtP9NejhJIqRj0XZ8CkCKHK9NTSk
         kcziHCoNzFOrfjb212q6dty4m+15R5/rBHjmnQu0dnGiZNDPDKdPdtrG8UeksOhqWx0g
         jsK9wVkekA6ZcNbuTaL+wfq5dZQojlGHTBD3DMRJbamwM9cbO+DtzoFcNBuOxBkdGgAi
         yLA3AuWlZoJ0jAXFS4Qc+f+iiDqN85Tw4Oz2hNk9B/AdNG66bR6JZ9R6XSVybo1pRuad
         dODw==
X-Gm-Message-State: APjAAAUJCeMuQpN3pRUmedwTRCXYsPH8UysMRd7vZdBEmgAQPwChM1pe
        f96cicPOoa++4Ia7flkRPwAoew==
X-Google-Smtp-Source: APXvYqzCBzd8J2M9XQvdsbL6G2OSFawF+v3rk18ZoTrCxdyxSjJU1aALri4iTJCgU4AEHIzAuQvoZw==
X-Received: by 2002:a05:6000:100a:: with SMTP id a10mr20639918wrx.154.1561015210289;
        Thu, 20 Jun 2019 00:20:10 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id f204sm5291869wme.18.2019.06.20.00.20.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 00:20:09 -0700 (PDT)
Date:   Thu, 20 Jun 2019 09:20:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        sdf@google.com, jianbol@mellanox.com, jiri@mellanox.com,
        mirq-linux@rere.qmqm.pl, willemb@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] flow_dissector: Fix vlan header offset in
 __skb_flow_dissect
Message-ID: <20190620072009.GA2504@nanopsycho>
References: <20190619160132.38416-1-yuehaibing@huawei.com>
 <20190619183938.GA19111@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619183938.GA19111@mini-arch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 19, 2019 at 08:39:38PM CEST, sdf@fomichev.me wrote:
>On 06/20, YueHaibing wrote:
>> We build vlan on top of bonding interface, which vlan offload
>> is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
>> BOND_XMIT_POLICY_ENCAP34.
>> 
>> __skb_flow_dissect() fails to get information from protocol headers
>> encapsulated within vlan, because 'nhoff' is points to IP header,
>> so bond hashing is based on layer 2 info, which fails to distribute
>> packets across slaves.
>> 
>> Fixes: d5709f7ab776 ("flow_dissector: For stripped vlan, get vlan info from skb->vlan_tci")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/core/flow_dissector.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
>> index 415b95f..2a52abb 100644
>> --- a/net/core/flow_dissector.c
>> +++ b/net/core/flow_dissector.c
>> @@ -785,6 +785,9 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
>>  		    skb && skb_vlan_tag_present(skb)) {
>>  			proto = skb->protocol;
>>  		} else {
>> +			if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX)
>> +				nhoff -=  sizeof(*vlan);
>> +
>Should we instead fix the place where the skb is allocated to properly
>pull vlan (skb_vlan_untag)? I'm not sure this particular place is

Yes.

>supposed to work with an skb. Having an skb with nhoff pointing to
>IP header but missing skb_vlan_tag_present() when with
>proto==ETH_P_8021xx seems weird.
>
>>  			vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
>>  						    data, hlen, &_vlan);
>>  			if (!vlan) {
>> -- 
>> 2.7.0
>> 
>> 
