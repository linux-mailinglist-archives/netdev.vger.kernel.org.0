Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850512D8ADF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 02:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388973AbgLMBnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 20:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgLMBnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 20:43:06 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB7C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 17:42:25 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id b18so12204699ots.0
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 17:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=80pmt/cXcoOFoAdT/xC/ICK5qXn4ry7F1vcudUkuP+c=;
        b=Kppv1xreTkzn19WyPSjr2xp2NotyPxMPutkGiNRTfnMzx8viioSCyrOdvMXYaLTO2u
         oV8Mwth5FkTp9G5KEztux01tfEr4b0AzQmzGnc9C+uc2xbo5ImWjdiycL4TFnSQ4w1GC
         9wuTSgnx4ka8QcILClWtt1nqVwN/Ga7s+MdlLMXPBnmYts+qfSAaXGtc+jYenT0sG5gJ
         +GIO/bgd+59GQ2yBo3xqH+7SLhiaTDBhhMX77hzPVw1slFI7DHXcAU8BAfY2XXal+PMQ
         SGkYtrU/zGmFsq/BxpjA7uYwC9zuaJSnWtFZAAJuq8ktfbRh4qDFatqRkn7NQPvSl56i
         OE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=80pmt/cXcoOFoAdT/xC/ICK5qXn4ry7F1vcudUkuP+c=;
        b=Asc1UbnroabXXbxUbZTeruf1F6jRgwTny4yQRqQGiuAablwyWJ/XqlwJTUsj60uKjE
         j9OkF+y1rxlW+n2mvQfOIC7jGX6JbHKY/vJSos5esueZ0Sk/drRmEimsq+Q1HC2EipKn
         CAp/0tSIzjOxovO95KxLz7dVkrQab3GZF49tO/99tizTgRXpgPyiG8IKonvD1ByyNskk
         KPrDyKRcoTBgORKIHDrMy6Vek387bCvgKL9YSN8asksKqSagAZYP3BbOK+dPb5IEJ/xf
         XrJ8OrAMzdqXt8MWKRYXxpZdMtWGxHTEMf4+7gTeMNbKCcShJB3elQ5zeeXSXa/0gNPz
         jZkw==
X-Gm-Message-State: AOAM530H4ku47KQrRKU4Gt/oygkzBQBtEHZg2uS56iuMQ8lsg0huWXA7
        ggOqX358PKWhGUkUbN62sAE=
X-Google-Smtp-Source: ABdhPJyDWko5EvotQ86iHzZ5Iacio1F0Nptr/Fw1wqFOz4QgMoCb8DGpegBQUeusHwMoxeV9gtdpnA==
X-Received: by 2002:a9d:620f:: with SMTP id g15mr14403885otj.361.1607823745181;
        Sat, 12 Dec 2020 17:42:25 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id x12sm3085540oic.51.2020.12.12.17.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 17:42:24 -0800 (PST)
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch> <20201212221858.audzhrku3i3p2nqf@skbuf>
 <20201213000855.GA2786309@lunn.ch> <20201213001418.ygofxyfmm7d273fe@skbuf>
 <20201213003410.GB2786309@lunn.ch> <20201213004933.pbjwfltwudvokrej@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e3e7311e-f205-9b91-7eaa-5f8e371d12c3@gmail.com>
Date:   Sat, 12 Dec 2020 17:42:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213004933.pbjwfltwudvokrej@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 4:49 PM, Vladimir Oltean wrote:
> On Sun, Dec 13, 2020 at 01:34:10AM +0100, Andrew Lunn wrote:
>> On Sun, Dec 13, 2020 at 12:14:19AM +0000, Vladimir Oltean wrote:
>>> On Sun, Dec 13, 2020 at 01:08:55AM +0100, Andrew Lunn wrote:
>>>>>> And you need some way to cleanup the allocated memory when the commit
>>>>>> never happens because some other layer has said No!
>>>>>
>>>>> So this would be a fatal problem with the switchdev transactional model
>>>>> if I am not misunderstanding it. On one hand there's this nice, bubbly
>>>>> idea that you should preallocate memory in the prepare phase, so that
>>>>> there's one reason less to fail at commit time. But on the other hand,
>>>>> if "the commit phase might never happen" is even a remove possibility,
>>>>> all of that goes to trash - how are you even supposed to free the
>>>>> preallocated memory.
>>>>
>>>> It can definitely happen, that commit is never called:
>>>>
>>>> static int switchdev_port_obj_add_now(struct net_device *dev,
>>>>                                       const struct switchdev_obj *obj,
>>>>                                       struct netlink_ext_ack *extack)
>>>> {
>>>>
>>>>        /* Phase I: prepare for obj add. Driver/device should fail
>>>>          * here if there are going to be issues in the commit phase,
>>>>          * such as lack of resources or support.  The driver/device
>>>>          * should reserve resources needed for the commit phase here,
>>>>          * but should not commit the obj.
>>>>          */
>>>>
>>>>         trans.ph_prepare = true;
>>>>         err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
>>>>                                         dev, obj, &trans, extack);
>>>>         if (err)
>>>>                 return err;
>>>>
>>>>         /* Phase II: commit obj add.  This cannot fail as a fault
>>>>          * of driver/device.  If it does, it's a bug in the driver/device
>>>>          * because the driver said everythings was OK in phase I.
>>>>          */
>>>>
>>>>         trans.ph_prepare = false;
>>>>         err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
>>>>                                         dev, obj, &trans, extack);
>>>>         WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);
>>>>
>>>>         return err;
>>>>
>>>> So if any notifier returns an error during prepare, the commit is
>>>> never called.
>>>>
>>>> So the memory you allocated and added to the list may never get
>>>> used. Its refcount stays zero.  Which is why i suggested making the
>>>> MDB remove call do a general garbage collect. It is not perfect, the
>>>> cleanup could be deferred a long time, but is should get removed
>>>> eventually.
>>>
>>> What would the garbage collection look like?
>>
>>         struct dsa_host_addr *a;
>>
>>         list_for_each_entry_safe(a, addr_list, list)
>> 		if (refcount_read(&a->refcount) == 0) {
>> 			list_del(&a->list);
>> 			free(a);
>> 		}
>> 	}
> 
> Sorry, this seems a bit absurd. The code is already absurdly complicated
> as is. I don't want to go against the current and add more unjustified
> nonsense instead of taking a step back, which I should have done earlier.
> I thought this transactional API was supposed to help. Though I scanned
> the kernel tree a bit and I fail to understand whom it helps exactly.
> What I see is that the whole 'transaction' spans only the length of the
> switchdev_port_attr_set_now function.
> 
> Am I right to say that there is no in-kernel code that depends upon the
> switchdev transaction model right now, as it's completely hidden away
> from callers? As in, we could just squash the two switchdev_port_attr_notify
> calls into one and nothing would functionally change for the callers of
> switchdev_port_attr_set?
> Why don't we do just that? I might be completely blind, but I am getting
> the feeling that this idea has not aged very well.

IIRC that was the conclusion that Ido and I had reached as well way back
when doing the commit you cited below.

> 
> Florian, has anything happened in the meantime since this commit of yours?

This is where I stopped, mainly because the series that had motivated
this work was the one bringing management mode to bcm_sf2 and CPU RX
filtering had me wire up yet another switched attribute that drivers
like b53 wanted to veto (namely the disabling of IGMP snooping). We did
not agree on the approach to use switchdev for notifying drivers about
UC, MC lists down to drivers and so the series stalled.

IIRC Jiri and Ido were also keen on merging the switchdev with the
bridge code but I did not do that part, nor did I completely remove the
transaction model, but those were the next steps had I not been side
tracked with work on other topics.

> 
> commit 91cf8eceffc131d41f098351e1b290bdaab45ea7
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Wed Feb 27 16:29:16 2019 -0800
> 
>     switchdev: Remove unused transaction item queue
> 
>     There are no more in tree users of the
>     switchdev_trans_item_{dequeue,enqueue} or switchdev_trans_item structure
>     in the kernel since commit 00fc0c51e35b ("rocker: Change world_ops API
>     and implementation to be switchdev independant").
> 
>     Remove this unused code and update the documentation accordingly since.
> 
>     Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>     Acked-by: Jiri Pirko <jiri@mellanox.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> There isn't an API to hold this stuff any longer. So let's go back to
> the implementation from v2, with memory allocation in the commit phase.
> The way forward anyway is probably not to add a garbage collector in
> DSA, but to fold the prepare and commit phases into one.

Agreed.
-- 
Florian
