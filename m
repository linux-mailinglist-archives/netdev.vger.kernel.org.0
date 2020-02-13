Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D1315B9D5
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 07:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgBMG6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 01:58:04 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41993 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbgBMG6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 01:58:04 -0500
Received: by mail-pg1-f194.google.com with SMTP id w21so2559669pgl.9
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 22:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TSSJzhLNctIxeID3U6wKVuxxMM3DTNrqfpveXN8MA5Q=;
        b=Dz7KSSd+DOjauxZG5D7M5ENIARKhvWwBqcjlXDzufq7gSVKc3aGvtf0jexOhPhnOde
         nQK08YkMtv4Qnwptf07kD9OeLVNiOOzYdQ9d8xWH1ZQc+1UinV91kNm5icjI/xn+rT47
         KxqBSgFo8x107sgXazSCVpo/sEkB83JZiSTF3Ppiy85ZHGV5pxMiErKmUbWL1sJ0NPKE
         SvTElneNkI4Ac0cwAsgK8l7HJQmu0nNkAJ0VqcLOeFcNz+b5XzSzfPOS/IAjXGN14den
         0/E0AFNN3R2+SjVaAHzM65XQXL7UwcrsAddCazwlpRGLr2Czk6voKTfb7aZO4u+elfTJ
         hCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TSSJzhLNctIxeID3U6wKVuxxMM3DTNrqfpveXN8MA5Q=;
        b=VwskEvMyXje2/XaSMlLmIudC1KDkpqoL0WxpEj20MRHa9IsymYk/N/ujs8RT/0Ol7p
         mo4Lnjfx7upTtYNvLcYD+Ej5rgPpCp4zVDCfs6fukq3tUQA6/0XYAXIX+z87M0CAQUMZ
         fn6aNZyhAxu0Iy/ZyFMSI7/xNwwlKRZastv6lxeAaDIgGCBVLZWRUIZIkWQHzpzWtYTI
         MOIMI4kNKvBtQyb114Q0ZzXh5+Xx7m22oaSSuRgqhw2W5xXn+t7DtGSUhMIDOIfkC5dD
         UBb9jR2WYPR23te+cC+VqPKPeZGbE7gHba1j7HEBcDA/bH2O6qN6WSda+uiYVhkGO+QV
         VDeA==
X-Gm-Message-State: APjAAAVVpuk8RXD7+88d1YETmcJxjuraaHS0C2pYbGlM2m1pHA5UZ3Ty
        u/Dcl63AmnrZxX6GU0Q4arg=
X-Google-Smtp-Source: APXvYqy1Qvp92aafvRNbF85fu6cTjw4FteEMyoYwxJdNEX7l0dNHoS60vv+rIFZWHMKKAbRk13JeSg==
X-Received: by 2002:a63:5947:: with SMTP id j7mr17097855pgm.48.1581577083440;
        Wed, 12 Feb 2020 22:58:03 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f8sm1529869pfn.2.2020.02.12.22.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 22:58:02 -0800 (PST)
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
To:     Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20200213045826.181478-1-edumazet@google.com>
 <20200213064532.GD22610@nanopsycho>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
Date:   Wed, 12 Feb 2020 22:58:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213064532.GD22610@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/20 10:45 PM, Jiri Pirko wrote:
> Thu, Feb 13, 2020 at 05:58:26AM CET, edumazet@google.com wrote:
>> Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
>> guarantee it is nul terminated.
>>
>> We should use nla_strdup() instead of kstrdup(), since this
>> helper will make sure not accessing out-of-bounds data.
>>
>> 
>> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Jiri Pirko <jiri@mellanox.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
>> ---
>> net/core/rtnetlink.c | 26 ++++++++++++--------------
>> 1 file changed, 12 insertions(+), 14 deletions(-)
>>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>> 	if (err)
>> 		return err;
>>
>> -	alt_ifname = nla_data(attr);
>> +	alt_ifname = nla_strdup(attr, GFP_KERNEL);
>> +	if (!alt_ifname)
>> +		return -ENOMEM;
>> +
>> 	if (cmd == RTM_NEWLINKPROP) {
>> -		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
>> -		if (!alt_ifname)
>> -			return -ENOMEM;
>> 		err = netdev_name_node_alt_create(dev, alt_ifname);
>> -		if (err) {
>> -			kfree(alt_ifname);
>> -			return err;
>> -		}
>> +		if (!err)
>> +			alt_ifname = NULL;
>> 	} else if (cmd == RTM_DELLINKPROP) {
>> 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
>> -		if (err)
>> -			return err;
>> 	} else {
> 
> 
>> -		WARN_ON(1);
>> -		return 0;
>> +		WARN_ON_ONCE(1);
>> +		err = -EINVAL;
> 
> These 4 lines do not seem to be related to the rest of the patch. Should
> it be a separate patch?

Well, we have to kfree(alt_ifname).

Generally speaking I tried to avoid return in the middle of this function.

The WARN_ON(1) is dead code today, making it a WARN_ON_ONCE(1) is simply
a matter of avoiding syslog floods if this path is ever triggered in the future.

> 
> Otherwise, the patch looks fine to me.
>

Thanks !

