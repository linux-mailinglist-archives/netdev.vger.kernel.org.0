Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD37E31277
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfEaQeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:34:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38843 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfEaQeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:34:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so6323283wmh.3;
        Fri, 31 May 2019 09:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTB2NKgVdICLn8njHL99y9c+1LJk3zwP4lVhi6sGfig=;
        b=J5lxEyoJPRE/ns2CXrVUrEAZLwC7wYzb5EaoLfKgY06ChFsvrKgkAfYihuC0brkKaG
         IITEYHHN3/PkacgzUs1YUqIh98M3DSY1CuHUxb42eNMyAya2rnHAIssAcSOe/Uof2sf1
         K2bylUOKAklImTn9y/l8rpuFC7MuKQxt9KlbX91qCZxzPcuAvyE6WgGNJzvHlsAqOeFr
         Pl4b9dtQtNlMkPFx+lGRebrjqkfD6wlBfJDur+Xo4LTG/RwDhUOZQ43/Zznh2RE4HTFt
         O8RDvOBH8zqG5IgyXiuYrlNMGapn81d3AyGUJ49YPypLgW3xp2mjohNIKZqk9S/LV1hB
         HrMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FTB2NKgVdICLn8njHL99y9c+1LJk3zwP4lVhi6sGfig=;
        b=JFWYT9sk+nIt6cdkjlq+NQwQZ+qrV/5f14zGaqYHWl4iryxDylS0pnhxVQFY84SaaB
         SfmJaOgGwMgIQHSe9ONTneymC+IkMHJhd4IQd4BgmZzV6G+mIhj3qksljXlA8f09S7QZ
         e304pzSrY69I96SrGRUW6hKF2CGB5W+I9TPmICYWt+KqRorhpRJFo5WlcVIo35KYPP19
         RqiQ87A7DlomWhPwbbkcAlaTR+/6hvT0XdPaRmwn0YpuP0kFACB3JXJkpi9pb5WEt0eA
         lmFnf6yJkfQ3Cbpg7WdRF57EeYoNYnfvjgxEwQ7qkIRSCXR15eIJ+/GFsd33OJGbfxCF
         gjYw==
X-Gm-Message-State: APjAAAU5SpT75j1LRWo163sdLT5GGsHOUrRrekRg8s1+zHMH3mxE1n9E
        xRFN/3zRAjACrQZcGOmpKtF/NImz
X-Google-Smtp-Source: APXvYqy8UDcBYLnijL5333o7A+ntw4xHVUkyZz9083lqwyd0Un/ogcWEIgYeQgL9c8JXW/WNWyWuiQ==
X-Received: by 2002:a1c:f507:: with SMTP id t7mr6407981wmh.149.1559320454552;
        Fri, 31 May 2019 09:34:14 -0700 (PDT)
Received: from [10.67.49.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r8sm13217936wrr.63.2019.05.31.09.34.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:34:13 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <1814b2e2-1a89-89f8-9699-f13df5e826b2@gmail.com>
Date:   Fri, 31 May 2019 09:34:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531143758.GB23821@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 7:37 AM, Andrew Lunn wrote:
>> I'm not sure that I like the semantic of it, because the driver can actually
>> support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
>> calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.
>>
>> Florian, Andrew, wouldn't the following patch be more adequate?
>>
>>     diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>>     index 1e2ae9d59b88..80f228258a92 100644
>>     --- a/net/dsa/slave.c
>>     +++ b/net/dsa/slave.c
>>     @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>>             struct bridge_vlan_info info;
>>             int ret;
>>      
>>     +       /* VID 0 has a special meaning and is never programmed in hardware */
>>     +       if (!vid)
>>     +               return 0;
>>     +
>>             /* Check for a possible bridge VLAN entry now since there is no
>>              * need to emulate the switchdev prepare + commit phase.
>>              */
>  
> Hi Vivien
> 
> If we put this in rx_kill_vid, we should probably have something
> similar in rx_add_vid, just in case the kernel does start using VID 0.

We use the prepare/commit model in the rx_add_vid() path so we deal with
-EOPNOTSUPP, that was caught fairly early on by Heiner when I added
programming of VLAN filtering through rx_{add,kill}_vid.

Nikita's patcha s it stands is correct and would make both
mv88e6xxx_port_check_hw_vlan() and mv88e6xxx_vtu_get() consistent.

I will respond to other comments.
-- 
Florian
