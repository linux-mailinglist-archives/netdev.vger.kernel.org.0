Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468C883842
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfHFRx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:53:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35277 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFRx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:53:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so77300368wmg.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HwW3YghTsHHJFmsJfU+KppgGjjPXJ/htt5fwTBYK4lo=;
        b=oTaBZBSLyTHVyIaoRlom1I+hCTee8PRb0qGq5VCwuxnoC5Q52OLK6m4z6O65CXsPOQ
         X/TBmFcD3XP7R0wK4EijHd7kEGqdo7Yh7hYA8ESzoZTppAbTX6tiZDh3AaiHsOrREcjN
         XiioUIF+kCLClAzKd6Ig7EvHLnO4Gh4bqNTcWqHo/XAbtiGh22sDrPP5J57UzhjbI2qa
         3nyT325j/AbT7c+j22H9j81hU6Xp5nXiyFv+KlDHZv6HzroA9XdeJcvE1On4xf1ODd5G
         iWB6HxMjmWoALq/in8948XcEwE9qcdDJmcjizPhZcN4TP7inW+eYY6GQ0c/2OmpmxyoS
         G7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HwW3YghTsHHJFmsJfU+KppgGjjPXJ/htt5fwTBYK4lo=;
        b=Wvkyiu1fZvxPSFyTpnNHQQV4dg+5Unf8iGqzWzD015L0Vr2N14XPYkae29tQZrqM3A
         +h2bRqvX0Nl2rTwEk4OKxytnGTL4ClUV8gOPgJxU+5xdary+sk3AoFhHdCo2SYZf+MnX
         f6lH7DYdhhiR31ONqnuQnJ7PXsOd68suGvl2PkO6RQFv7a/3tBEpgyAdrouy2sHQsjHW
         LYDZyLAoKMwqdRxsVHijE5pF2sj23OJAlK+imzFxVC9o7cmOTuofetsgxCmfXfvUILPo
         OKk7/H1DcyWJajYExBUbz9pq+vXicsCTtTnbRc1o4DYFd3y1pvrX5PByissPrPdAlWCn
         /4zA==
X-Gm-Message-State: APjAAAVN3hUf2xU1P1sKFgXFN9uHfakTqz8Mw4OwYhOJvHaI/hCcgTxE
        EcorKtyoZBJ4bKQJQGOyDx32yw==
X-Google-Smtp-Source: APXvYqyeRYNTLprIHCsN+1wd4VPhXuv7pISKZX8u0D04ioTvPZOX++BrJ18w8zsxomKExmjT1Gya0Q==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr5709592wmb.172.1565114004383;
        Tue, 06 Aug 2019 10:53:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l2sm59932505wmj.4.2019.08.06.10.53.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:53:24 -0700 (PDT)
Date:   Tue, 6 Aug 2019 19:53:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190806175323.GB2332@nanopsycho.orion>
References: <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
 <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
 <20190805152019.GE2349@nanopsycho.orion>
 <7200bdbb-2a02-92c6-0251-1c59b159dde7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7200bdbb-2a02-92c6-0251-1c59b159dde7@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 06, 2019 at 07:34:59PM CEST, dsahern@gmail.com wrote:
>On 8/5/19 9:20 AM, Jiri Pirko wrote:
>> Mon, Aug 05, 2019 at 04:51:22PM CEST, dsahern@gmail.com wrote:
>>> On 8/5/19 8:49 AM, Jiri Pirko wrote:
>>>>> Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
>>>>> per-namepace accounting to all namespaces managed by a single devlink
>>>>> instance in init_net - which is completely wrong.
>>>> No. Not "all namespaces". Only the one where the devlink is. And that is
>>>> always init_net, until this patchset.
>>>>
>>>>
>>>
>>> Jiri: your change to fib.c does not take into account namespace when
>>> doing rules and routes accounting. you broke it. fix it.
>> 
>> What do you mean by "account namespace"? It's a device resource, why to
>> tight it with namespace? What if you have 2 netdevsim-devlink instances
>> in one namespace? Why the setting should be per-namespace?
>> 
>
>Jiri:
>
>Here's an example of how your 5.2 change to netdevsim broke the resource
>controller:
>
>Create a netdevsim device:
>$ modprobe netdevsim
>$  echo "0 1" > /sys/bus/netdevsim/new_device
>
>Get the current number of IPv4 routes:
>$ n=$(ip -4 ro ls table all | wc -l)
>$ echo $n
>13
>
>Prevent any more from being added. This limit should apply solely to
>this namespace, init_net:
>
>$ devlink resource set netdevsim/netdevsim0 path /IPv4/fib size $n
>$ devlink dev reload netdevsim/netdevsim0
>Error: netdevsim: New size is less than current occupancy.
>devlink answers: Invalid argument
>
>So that is the first breakage: accounting is off - maybe. Note there are
>no other visible namespaces, but who knows what systemd or other
>processes are doing with namespaces. Perhaps this accounting is another
>example of your changes not properly handling namespaces:
>
>$ devlink resource show netdevsim/netdevsim0
>netdevsim/netdevsim0:
>  name IPv4 size unlimited unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>    resources:
>      name fib size 13 occ 17 unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>      name fib-rules size unlimited occ 6 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>  name IPv6 size unlimited unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>    resources:
>      name fib size unlimited occ 10 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>      name fib-rules size unlimited occ 4 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>
>So the occupancy does not match the tables for init_net.
>
>Reset the max to 17, the current occupancy:
>$ devlink resource set netdevsim/netdevsim0 path /IPv4/fib size 17
>$ devlink dev reload netdevsim/netdevsim0
>$ devlink resource show netdevsim/netdevsim0
>netdevsim/netdevsim0:
>  name IPv4 size unlimited unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>    resources:
>      name fib size 17 occ 17 unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>      name fib-rules size unlimited occ 6 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>  name IPv6 size unlimited unit entry size_min 0 size_max unlimited
>size_gran 1 dpipe_tables none
>    resources:
>      name fib size unlimited occ 10 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>      name fib-rules size unlimited occ 4 unit entry size_min 0 size_max
>unlimited size_gran 1 dpipe_tables none
>
>Create a new namespace, bring up lo which attempts to add more route
>entries:
>$ unshare -n
>$ ip li set lo up
>
>If you list routes you see the lo routes failed to installed because of
>the limits, but it is a silent failure. Try to add a new route and you
>see the cross namespace accounting now:
>$ ip ro add 192.168.1.0/24 dev lo
>Error: netdevsim: Exceeded number of supported fib entries.
>
>
>Contrast that behavior with 5.1 and you see the new namespaces have no
>bearing on accounting in init_net and limits in init_net do not affect
>other namespaces.
>
>That behavior needs to be restored in 5.2 and 5.3.

Let's figure out the devlink-controlling-kernel-resources thread first.
What you describe here is exactly that.
