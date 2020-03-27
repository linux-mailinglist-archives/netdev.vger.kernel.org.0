Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86C195D05
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgC0Rlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:41:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51830 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0Rlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:41:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id c187so12334739wme.1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 10:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=knkgum2YAUAfH0fsZJz8OEZ8ta7hw4tSHvE49zRXFfk=;
        b=dtxdiT32SaMx9JBTw1mqatsvuwQ7lO4pJm+8SUbtjJRqTgX0Ql1eNpG9oC4MzbyFFZ
         mRj0TAv7vIAn0K7ksaq/ams80zG+xQK0a8UpmfbcQO9GdHiAQed7cBFhGclzzTHlWvdi
         LMmdsSa9fZOKJXxac0wxRD+f9CSeT7z/l8duXyp/rmypnAN40JgKvaoccknvrpQQ0xKt
         8a7qi7LxNK06w6MrTxC27cTJexfMxIxXZXvBL3/6yNzh2SECXvi0NEqaQPA2yG6EHxvp
         BU++vKjLZ7Pv7mRL4nIfweO1jOydLWtLsVdrsFBjusm0X+j3A4N+IPFz7Jwp9DtC0boV
         U12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knkgum2YAUAfH0fsZJz8OEZ8ta7hw4tSHvE49zRXFfk=;
        b=MbcF1+fre2g4SOz0eifrF56gFEDtENZjohT6Jreqo3AOG3UOLFMN7eshqVqbewNgCr
         xMg46/zwMI+feAe9YFBRqpsqpva40bwz/Da+woMwvD3/bYfaom018xCFVsDnzPdiqFND
         XX9HVTv8jnErjuITNlHEevbLyBrLsWNYT5udjJdPsQHkkVJX/NHQ+/2vR3ImghrLEs7/
         U+DwA3UZf3YfTzQ/X2icuRudQu6O9ZYDdLvnOdd7eoLohPh5CjrokhJrtgHmhj6gx34P
         sdnrIiuXRRm/HhiTK4j3twzjVt89s2QAbfwi/US7VFQknolJGHOmTLGJnYfS/ockpz+8
         w5Sw==
X-Gm-Message-State: ANhLgQ3wjxwpTE0P/6ZFU8suML7J0OW+K29o0cZsRUkNS9sXvo6rwGHk
        j4RFKPfDPhRjcgERcV0sS+M=
X-Google-Smtp-Source: ADFU+vuubu3x/i4qnc9Idb+nnD5ypqm/nxxxMjbIWPoa78uxD10mgIf1ta7COIfmqcHUPkSfInMwTA==
X-Received: by 2002:a1c:9a43:: with SMTP id c64mr6230433wme.173.1585330898016;
        Fri, 27 Mar 2020 10:41:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:9d76:401f:98cb:c084? (p200300EA8F2960009D76401F98CBC084.dip0.t-ipconnect.de. [2003:ea:8f29:6000:9d76:401f:98cb:c084])
        by smtp.googlemail.com with ESMTPSA id o16sm9129451wrs.44.2020.03.27.10.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 10:41:37 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Charles Daymand <charles.daymand@wifirst.fr>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
Message-ID: <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
Date:   Fri, 27 Mar 2020 18:41:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 10:39, Heiner Kallweit wrote:
> On 27.03.2020 10:08, Charles Daymand wrote:
>> During kernel upgrade testing on our hardware, we found that macvlan
>> interface were no longer able to send valid multicast packet.
>>
>> tcpdump run on our hardware was correctly showing our multicast
>> packet but when connecting a laptop to our hardware we didn't see any
>> packets.
>>
>> Bisecting turned up commit 93681cd7d94f
>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
>> which is responsible for the drop of packet in case of macvlan
>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
>> case since TSO was keep disabled.
>>
>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
>> issue, but we believe that this hardware issue is important enough to
>> keep tx checksum off by default on this revision.
>>
>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
>> specific revision.
>>
> 
> The referenced commit may not be the root cause but just reveal another
> issue that has been existing before. Root cause may be in the net core
> or somewhere else. Did you check with other RTL8168 versions to verify
> that it's indeed a HW issue with this specific chip version?
> 
> What you could do: Enable tx checksumming manually (via ethtool) on
> older kernel versions and check whether they are fine or not.
> If an older version is fine, then you can start a new bisect with tx
> checksumming enabled.
> 
> And did you capture and analyze traffic to verify that actually the
> checksum is incorrect (and packets discarded therefore on receiving end)?
> 
> 
>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
>> ---
>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
>> index a9bdafd15a35..3b69135fc500 100644
>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>  		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>  		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>> +		if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>> +			dev->features &= ~NETIF_F_IP_CSUM;
>> +		}
>>  	}
>>  
>>  	dev->hw_features |= NETIF_F_RXALL;
>>
> 

After looking a little bit at the macvlen code I think there might be an
issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
seem to have a dedicated maintainer).

r8169 implements a ndo_features_check callback that disables tx checksumming
for the chip version in question and small packets (due to a HW issue).
macvlen uses passthru_features_check() as ndo_features_check callback, this
seems to indicate to me that the ndo_features_check callback of lowerdev is
ignored. This could explain the issue you see.

Would be interesting to see whether it fixes your issue if you let the
macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?

By the way:
Also the ndo_fix_features callback of lowerdev seems to be ignored.
