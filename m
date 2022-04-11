Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB984FC09D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348047AbiDKP2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244292AbiDKP2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:28:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C38D1F62B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:26:08 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q20so10159536wmq.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=y2l9zYR8acdPSFkQesTZp8O5z+IUnLb1ks1hF/81xUY=;
        b=Mtvs387POLtS3hSukjKZNP4l+kxtKa8MiNfqS+7jCXE+OzaRXdSqBgs6bHsVL23MYT
         hkBJU36p9rNx1FSGfeX2A/xgS4/dI7xPbdXUMlNsB/bgBdE/sIF9QbXNORwq7oAuUdCR
         EhmjeQ6y9NKpEczYjfvGbkcnwzg9//KSKelSEGI/0lwaEM2vAy6yelazlBkpAMjVzBhO
         8xfGniStxsSpfMa9v2PtDeF/EifjOGGUAVIGrR2FvadL9G6/fxqteAVD6y1CgLzj5/KB
         ZT9o2k7NWsXmDqk6qxf7bGgTvLIi7uSRVgaPN7dIV9wc0tKhkGg5Y4oTf0uCpNBc7Jm+
         8pBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=y2l9zYR8acdPSFkQesTZp8O5z+IUnLb1ks1hF/81xUY=;
        b=if9ew1sEuaVrAypmaBuRniKvbRi1nQ0aP5V5iGJu4ppM2NOAdSozFmRkKvRVl9B/Y2
         FFNZ01ZYqaL4kR7hJgwzx4Vys/HG5iKz51TziCM6abNNSqCCdHg/6Z58wexpTISuf7Ig
         lpoTrmeAy1oyEGrgtnM1CpIjmTSqI7ME98ofH8W4SlGg6BcXFXrBkJIPqHs7oQWNwJZY
         K3xMPUDszt7d08bdYVC1zTbID12NmeRImSHg5x3eL6C3f1YyFfKNV0HI22h6QIvI/34C
         lxhNrbaemacmhJpjPd4xmMH3SHczNE03hvArEx71uO9TXo0FcczWFzj42SScZos4eYQ7
         kDfg==
X-Gm-Message-State: AOAM532TBKGIkFAuLoGZwNXI8FJIzDfCuUO2pzCco2MQlOwam7H7d958
        Bk+8JmQK7mhDLIPFUGXneXZ9BA==
X-Google-Smtp-Source: ABdhPJzUJjn+dswo5vG9FcGXKfUzlIVhqpYv8CMazA1NxZ7Oq9ebQPfEh/0XK+l0T+xah9WRJWQINw==
X-Received: by 2002:a1c:7416:0:b0:38e:b8b7:e271 with SMTP id p22-20020a1c7416000000b0038eb8b7e271mr6909157wmc.7.1649690766559;
        Mon, 11 Apr 2022 08:26:06 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f? ([2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f])
        by smtp.gmail.com with ESMTPSA id r4-20020a1c2b04000000b0038a0e15ee13sm18304963wmr.8.2022.04.11.08.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 08:26:05 -0700 (PDT)
Message-ID: <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
Date:   Mon, 11 Apr 2022 17:26:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: What is the purpose of dev->gflags?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org> <20220408191757.dllq7ztaefdyb4i6@skbuf>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220408191757.dllq7ztaefdyb4i6@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 08/04/2022 à 21:17, Vladimir Oltean a écrit :
> On Fri, Apr 08, 2022 at 11:50:54AM -0700, Jakub Kicinski wrote:
>> On Fri, 8 Apr 2022 21:30:45 +0300 Vladimir Oltean wrote:
>>> Hello,
>>>
>>> I am trying to understand why dev->gflags, which holds a mask of
>>> IFF_PROMISC | IFF_ALLMULTI, exists independently of dev->flags.
>>>
>>> I do see that __dev_change_flags() (called from the ioctl/rtnetlink/sysfs
>>> code paths) updates the IFF_PROMISC and IFF_ALLMULTI bits of
>>> dev->gflags, while the direct calls to dev_set_promiscuity()/
>>> dev_set_allmulti() don't.
>>>
>>> So at first I'd be tempted to say: IFF_PROMISC | IFF_ALLMULTI are
>>> exposed to user space when set in dev->gflags, hidden otherwise.
>>> This would be consistent with the implementation of dev_get_flags().
>>>
>>> [ side note: why is that even desirable? why does it matter who made an
>>>   interface promiscuous as long as it's promiscuous? ]
I think this was historical, I had the same questions a long time ago.

>>
>> Isn't that just a mechanism to make sure user space gets one "refcount"
>> on PROMISC and ALLMULTI, while in-kernel calls are tracked individually
>> in dev->promiscuity? User space can request promisc while say bridge
>> already put ifc into promisc mode, in that case we want promisc to stay
>> up even if ifc is unbridged. But setting promisc from user space
>> multiple times has no effect, since clear with remove it. Does that
>> help? 
> 
> Yes, that helps to explain one side of it, thanks. But I guess I'm still
> confused as to why should a promiscuity setting incremented by the
> bridge be invisible to callers of dev_get_flags (SIOCGIFFLAGS,
> ifinfomsg::ifi_flags [ *not* IFLA_PROMISCUITY ]).
If I remember well, the goal was to advertise these flags to userspace only when
they were set by a userspace app and not by a kernel module (bridge, bonding, etc).
To avoid changing that behavior, IFLA_PROMISCUITY was introduced, thus userspace
may know if promiscuity is enabled by dumping the interface. Notifications were
fixed later, but maybe some are still missing.


Regards,
Nicolas


> 
>>> But in the process of digging deeper I stumbled upon Nicolas' commit
>>> 991fb3f74c14 ("dev: always advertise rx_flags changes via netlink")
>>> which I am still struggling to understand.
>>>
>>> There, a call to __dev_notify_flags(gchanges=IFF_PROMISC) was added to
>>> __dev_set_promiscuity(), called with "notify=true" from dev_set_promiscuity().
>>> In my understanding, "gchanges" means "changes to gflags", i.e. to what
>>> user space should know about. But as discussed above, direct calls to
>>> dev_set_promiscuity() don't update dev->gflags, yet user space is
>>> notified via rtmsg_ifinfo() of the promiscuity change.
>>>
>>> Another oddity with Nicolas' commit: the other added call to
>>> __dev_notify_flags(), this time from __dev_set_allmulti().
>>> The logic is:
>>>
>>> static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
>>> {
>>> 	unsigned int old_flags = dev->flags, old_gflags = dev->gflags;
>>>
>>> 	dev->flags |= IFF_ALLMULTI;
>>>
>>> 	(bla bla, stuff that doesn't modify dev->gflags)
>>>
>>> 	if (dev->flags ^ old_flags) {
>>>
>>> 		(bla bla, more stuff that doesn't modify dev->gflags)
>>>
>>> 		if (notify)
>>> 			__dev_notify_flags(dev, old_flags,
>>> 					   dev->gflags ^ old_gflags);
>>> 					   ~~~~~~~~~~~~~~~~~~~~~~~~
>>> 					   oops, dev->gflags was never
>>> 					   modified, so this call to
>>> 					   __dev_notify_flags() is
>>> 					   effectively dead code, since
>>> 					   user space is not notified,
>>> 					   and a NETDEV_CHANGE netdev
>>> 					   notifier isn't emitted
>>> 					   either, since IFF_ALLMULTI is
>>> 					   excluded from that
>>> 	}
>>> 	return 0;
>>> }
>>>
>>> Can someone please clarify what is at least the intention? As can be
>>> seen I'm highly confused.
>>>
>>> Thanks.
>>
