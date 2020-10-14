Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55228DAE5
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgJNIOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgJNIOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:14:36 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E08BC051129;
        Wed, 14 Oct 2020 00:59:18 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id o18so2155805edq.4;
        Wed, 14 Oct 2020 00:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X6D0Ror+2mO5zJfkz9qAnbmgE+QzWXoroVWR4akLGf8=;
        b=s5ssW1+ERHepdZYBphFnv0uGNdmvm9qfiAQ+ezzdvRMUdNLSSfX5yH9rbWeN3dajnI
         MsPJvfe/hKGZMZvtGy+2+V7Od80b210yFBfb10Kku7sofHqFrxvpy04y3AxJZEqJIJ0l
         hI3xO52Gk6IIjF7eHeSdd5jGaiAvqp5Th2mixIU0AquVhM9CmGRcXahAUQlaDlLLIRBl
         1VPaaN1rqwQz/uNu35CTX+BChIzjc0L1UiGvQcZU2bYEa8zymc2uV/mvIyimIRYRpV+u
         78mCAkllTB/rT8HR3KyzJE861EqOb2dYq7mZdKqjD0uDZj/YIYVWGHhYg9HSgBVQoGyd
         ZVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X6D0Ror+2mO5zJfkz9qAnbmgE+QzWXoroVWR4akLGf8=;
        b=p9ah5+tQt7Iv3bwvAbTcwf51BYTqwRq+FBqxkyFE/mFKsDFtGgIoHgTfLaY/MWeTrq
         Td8nc6oIfLr39XSHtbOl9jTBxoZpO0bpT96rdGgCzcNhl4l3c/+3JkYKVgvfTVLu38bJ
         3E1sg5+He5HsWEzzylDmzxvAX8Fig4Ks3gI2hn0iQVfg0/H0OoLhh6suUljdhiWOBZ2R
         l/Ng5BGDzKzztrkW0MYipeGDIY3S2SKwVQEXQZYxXtP+lpKSgr6rKLBXn5gIb2IuugvW
         14v33pcMBseutBsooTP0ZsVil5tTOMZMYDjlR5gCEnYbm2iakUm8H5qiButT874Gmnqd
         0Dig==
X-Gm-Message-State: AOAM5329LyJvJUNfPRYNc3jNznvMOlQyz4gnqhCxkeDd6Ih/Xb/IgVAY
        y08Wq+nIw5mb/NsL5hRRw4Pv88EJZrM=
X-Google-Smtp-Source: ABdhPJzARrcbOHz0JFF8UC0nfG4bzN1EODm0ruckaDcpJbPk9Rm3gs4ve4yltg1laENCjiYasBL33w==
X-Received: by 2002:aa7:cf17:: with SMTP id a23mr3821803edy.298.1602662357243;
        Wed, 14 Oct 2020 00:59:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:e563:1e0d:2b0d:aba7? (p200300ea8f232800e5631e0d2b0daba7.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e563:1e0d:2b0d:aba7])
        by smtp.googlemail.com with ESMTPSA id yd18sm1260946ejb.10.2020.10.14.00.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 00:59:16 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
 <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201014054250.GB6305@unreal>
 <3be8fd19-1c7e-0e05-6039-e5404b2682b9@gmail.com>
 <20201014075310.GG6305@unreal>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cb02626b-71bd-360d-c864-5dac2a1a7603@gmail.com>
Date:   Wed, 14 Oct 2020 09:59:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201014075310.GG6305@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.10.2020 09:53, Leon Romanovsky wrote:
> On Wed, Oct 14, 2020 at 08:13:47AM +0200, Heiner Kallweit wrote:
>> On 14.10.2020 07:42, Leon Romanovsky wrote:
>>> On Tue, Oct 13, 2020 at 05:39:51PM -0700, Jakub Kicinski wrote:
>>>> On Mon, 12 Oct 2020 10:00:11 +0200 Heiner Kallweit wrote:
>>>>> In several places the same code is used to populate rtnl_link_stats64
>>>>> fields with data from pcpu_sw_netstats. Therefore factor out this code
>>>>> to a new function dev_fetch_sw_netstats().
>>>>>
>>>>> v2:
>>>>> - constify argument netstats
>>>>> - don't ignore netstats being NULL or an ERRPTR
>>>>> - switch to EXPORT_SYMBOL_GPL
>>>>
>>>> Applied, thank you!
>>>
>>> Jakub,
>>>
>>> Is it possible to make sure that changelogs are not part of the commit
>>> messages? We don't store previous revisions in the git repo, so it doesn't
>>> give too much to anyone who is looking on git log later. The lore link
>>> to the patch is more than enough.
>>>
>> I remember that once I did it the usual way (changelog below the ---) David
>> requested the changelog to be part of the commit message. So obviously he
>> sees some benefit in doing so.
> 
> Do you have a link? What is the benefit and how can we use it?
> 
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1873080.html

> Usually such request comes to ensure that commit message is updated with
> extra information (explanation) existed in changelog which is missing in
> the patch.
> 
> Thanks
> 
>>
>>> 44fa32f008ab ("net: add function dev_fetch_sw_netstats for fetching pcpu_sw_netstats")
>>>
>>> Thanks
>>>
>>

