Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6611E84AE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfJ2JrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:47:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42641 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfJ2JrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:47:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id a15so574656wrf.9
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 02:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=89r1rNHEMVi51X8QptG2oJ8PZcM46Qw8VvMwF8b1wgo=;
        b=wiEzjzXZjxbDnTURVXFofslvFJq1OnqyzLxdVOYTiEK4BkKtV9oSdFm/F24JGKSKqH
         sJ3VU9bJai0Nd261G++OtTT/wZhXe9FuJ8SofZb0B8j7NngXjv6qFTH9tEImIwGHKg0/
         opCMiE1lfo6WxkMYwfiiEsAN4QwZAW+TQuus/EtEwd5tXjEgSmRdWs4ixZtIJyktgOOt
         zuBzBT34xzcKnKe1CK5OVdeUze3ktefiP7LhxMbKcNN4dUmRBYHYDmEcCp47ykpm4zNH
         y7jpULJazBd3Mq6DftIH/r7aUsS3Nsx0ryO+8ttaIN5ZlnokpEE4MAjYzPuRE1NPnTKk
         3uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=89r1rNHEMVi51X8QptG2oJ8PZcM46Qw8VvMwF8b1wgo=;
        b=WzYGzxV3ytjrdxkiypB2TuVqH8UdIHMEZOZ8t6lLYBQqjmr6yV1/9GcJB3Gk/7VM7w
         e6FJmpmVA2IX1Wc4wAWHrcs7txYceqp05LQj2nVFxLuMEXTq4VkRDEktygLkuBG3fqz/
         5juF4sVub8ddZgN2hoqthgCRjxIrKiYMJnUBmqT+fKVeGrs2PkGhLhMQZ0ow5zVIUQhn
         PqBhnCd+F8TgEx3Ia1yyupHmcPHsmePccF4Q0mr6gwyCgWdtr9j4jzwRidubMfgSLVoe
         5e6WgDZgMYUQN79/wj8mDTy9EtYreg188+iztctaCkrLx2REzdQPFJzHyQwbi+Ce6vlL
         o9lA==
X-Gm-Message-State: APjAAAXqaqBivDlQwq1B2YCuqJQEOrYw5pzd9ocD2RzxLBKQUPMiUXxl
        6JmHLIHURGj/EJcTLVKym7xMHA==
X-Google-Smtp-Source: APXvYqyr6dueVY98vyKdLQa7Cf+zesIqhhu9E22W8jO6/0960zTgfomp23nR4r174U6ZncxgF8OO4g==
X-Received: by 2002:adf:e850:: with SMTP id d16mr18218775wrn.251.1572342428276;
        Tue, 29 Oct 2019 02:47:08 -0700 (PDT)
Received: from [192.168.3.176] (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id v6sm15209634wru.72.2019.10.29.02.47.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 02:47:07 -0700 (PDT)
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
 <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
 <30465e05-3465-f496-d57f-5e115551f5cb@ncentric.com>
 <dbbc8c3e898ec499f30a6ac1f262666ced6905fb.camel@sipsolutions.net>
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
Message-ID: <6967a862-c040-565a-3644-c804b188d13e@ncentric.com>
Date:   Tue, 29 Oct 2019 10:47:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <dbbc8c3e898ec499f30a6ac1f262666ced6905fb.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.10.19 10:03, Johannes Berg wrote:
> On Tue, 2019-10-29 at 09:41 +0100, Koen Vandeputte wrote:
>
>> I can confirm the issue as I'm also seeing this sometimes in the field here.
>>
>> Sometimes when a devices goes out of range and then re-enters,
>> the link refuses to "come up", as in rx looks to be "stuck" without any
>> reports in system log or locking issues (lockdep enabled)
> Right. I've recently debugged this due to issues in distributed
> beaconing (rather than moving in/out of range), but I guess it would be
> relatively simple to reproduce this with wmediumd, if that can be
> controlled dynamically?
>
> What kernel are you running? You could check if you have
>
> 95697f9907bf ("mac80211: accept deauth frames in IBSS mode")
> 4b08d1b6a994 ("mac80211: IBSS: send deauth when expiring inactive STAs")
>
> which might help somewhat, but don't fully cover the case of moving out
> of range.
>
> johannes
>
I'm running OpenWrt (kernel 4.14.150 with 4.19.79 mac80211)
I noticed these fixes last week and made a build 2 days ago with them 
backported to it.
Running in the field on roughly 4 devices since a day.

Koen

