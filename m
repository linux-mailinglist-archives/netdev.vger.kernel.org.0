Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A899837F0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbfHFRfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:35:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42243 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbfHFRfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:35:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so41867510pff.9
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/1i9Oc2Ozscm3uN33DcGFO+ada50q88bxWKuinFeflo=;
        b=SFBceuZj3P/wi9/sr5WQ8FKoLX5eBHbfsrXpKMzTXHNw9qu2JUkM8q4OUMtfYa1SDQ
         me5am9f4DqNQK/lsPHdWmddjjt2ps/JXRZOqTIMeIz5WtK3PrSV6wTxF4LWqGFPwDoBO
         wpXjHWKq4pBoLt1XEwxhlEltlnwZB1Tp7KakiPMgVXGyISDg+hs6id0/dQ1P5xU2TSK9
         8mV0UNzfoBNYyStkq3nkMYDf/Da/lXz3VtGAJcen0Va5/VT1YbUE6Ozs+Dy5LCeUqkMn
         t9GpJmxb0BuYSFXWHw2zyLzcvF611hNY1UJrWGBsydAnQDcaSTjWjo1rKKne1oT5x1gB
         vSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/1i9Oc2Ozscm3uN33DcGFO+ada50q88bxWKuinFeflo=;
        b=AEJ44UVkBJQGcW3Rxs1AkJU/VTRMJRRBFFrZyfBM3HjNSQU8DPBIw25kL2aN7MqRC9
         4AKEDWn3jjIMB1immqc8M5/pvBvWLfICqs6l8OHGgO/VUMUomyase1L1XT7QXuN2+bkK
         KlRhxi3Ps0WEFS63gcvI+aSqBZAp5S7/fZc8SeV23eSiVLYCOLjuUm8l8FYHpWEyvAkc
         PLCeNlr7eM8CdV8Y3sHedISvbSR6oIlqVrJhjDZivAk4dERNvK7ZfEWl3I0O8IyiwWJ1
         8H+yOHrJn6RHtFP83v+VuFiHYP+0F8a9zU/Fycp0DhCzOCwk0kSFKDPI4RCXkYJsbHy5
         ZHug==
X-Gm-Message-State: APjAAAV4q9TEMZeBHTdPymSF3AInI+81maGzn2EOrovpflh/XzayggVq
        cV8LfgCs/myAh06X1X1yAAwHw9uGqyc=
X-Google-Smtp-Source: APXvYqxdR2r5cn5MqxSeiTZMZPiXy54NgOuUY/tKryLPENHKfLWp1AroY7v1Fq1fRCL2NaqfGDXj9Q==
X-Received: by 2002:aa7:8705:: with SMTP id b5mr5067876pfo.27.1565112902648;
        Tue, 06 Aug 2019 10:35:02 -0700 (PDT)
Received: from [172.27.227.131] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id h13sm56959808pfn.13.2019.08.06.10.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 10:35:01 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
 <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
 <20190805152019.GE2349@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7200bdbb-2a02-92c6-0251-1c59b159dde7@gmail.com>
Date:   Tue, 6 Aug 2019 11:34:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190805152019.GE2349@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/19 9:20 AM, Jiri Pirko wrote:
> Mon, Aug 05, 2019 at 04:51:22PM CEST, dsahern@gmail.com wrote:
>> On 8/5/19 8:49 AM, Jiri Pirko wrote:
>>>> Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
>>>> per-namepace accounting to all namespaces managed by a single devlink
>>>> instance in init_net - which is completely wrong.
>>> No. Not "all namespaces". Only the one where the devlink is. And that is
>>> always init_net, until this patchset.
>>>
>>>
>>
>> Jiri: your change to fib.c does not take into account namespace when
>> doing rules and routes accounting. you broke it. fix it.
> 
> What do you mean by "account namespace"? It's a device resource, why to
> tight it with namespace? What if you have 2 netdevsim-devlink instances
> in one namespace? Why the setting should be per-namespace?
> 

Jiri:

Here's an example of how your 5.2 change to netdevsim broke the resource
controller:

Create a netdevsim device:
$ modprobe netdevsim
$  echo "0 1" > /sys/bus/netdevsim/new_device

Get the current number of IPv4 routes:
$ n=$(ip -4 ro ls table all | wc -l)
$ echo $n
13

Prevent any more from being added. This limit should apply solely to
this namespace, init_net:

$ devlink resource set netdevsim/netdevsim0 path /IPv4/fib size $n
$ devlink dev reload netdevsim/netdevsim0
Error: netdevsim: New size is less than current occupancy.
devlink answers: Invalid argument

So that is the first breakage: accounting is off - maybe. Note there are
no other visible namespaces, but who knows what systemd or other
processes are doing with namespaces. Perhaps this accounting is another
example of your changes not properly handling namespaces:

$ devlink resource show netdevsim/netdevsim0
netdevsim/netdevsim0:
  name IPv4 size unlimited unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
    resources:
      name fib size 13 occ 17 unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 6 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none
  name IPv6 size unlimited unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 10 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 4 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none

So the occupancy does not match the tables for init_net.

Reset the max to 17, the current occupancy:
$ devlink resource set netdevsim/netdevsim0 path /IPv4/fib size 17
$ devlink dev reload netdevsim/netdevsim0
$ devlink resource show netdevsim/netdevsim0
netdevsim/netdevsim0:
  name IPv4 size unlimited unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
    resources:
      name fib size 17 occ 17 unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 6 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none
  name IPv6 size unlimited unit entry size_min 0 size_max unlimited
size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 10 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 4 unit entry size_min 0 size_max
unlimited size_gran 1 dpipe_tables none

Create a new namespace, bring up lo which attempts to add more route
entries:
$ unshare -n
$ ip li set lo up

If you list routes you see the lo routes failed to installed because of
the limits, but it is a silent failure. Try to add a new route and you
see the cross namespace accounting now:
$ ip ro add 192.168.1.0/24 dev lo
Error: netdevsim: Exceeded number of supported fib entries.


Contrast that behavior with 5.1 and you see the new namespaces have no
bearing on accounting in init_net and limits in init_net do not affect
other namespaces.

That behavior needs to be restored in 5.2 and 5.3.
