Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04E42ED3C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbfE3Dc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:32:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44327 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388379AbfE3D30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 23:29:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so1106563pgp.11
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 20:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kd1xO9fYhDk1iKGLZm6kDXfHp0iuNNx0r1G+M6NMv+I=;
        b=CTmChCEq2Tye89wVCieF+cLj6csHppBMaUV4vdvvX7HdV7bJza81f3jg3pBjnYqMqo
         zlquDcaCgHTr3/SWyWprsh/3OFRRHPKJHu5QJnS7LOt3uqz1IvD4Fa/B73d2R3nZxkoD
         vcqWva9ftiwaNLkn0F/UI3fsmheGblIYnXiPRmim2nAt4EN49SKbqRtcAehE2h5T4Tb9
         /AdPB/gZ8jBxkZwQL1q+Z6KiMF6ldbLyhs/zjZBr6UXx1gdhQeC59GdEk5ha+a7LABMS
         0eWJZOI5IwogOGJsmKl5KomPDWvVwFWYwqRd3oKvsy0phTIUyCQMADKxhFlDpQnnQX1V
         wF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kd1xO9fYhDk1iKGLZm6kDXfHp0iuNNx0r1G+M6NMv+I=;
        b=tPB2jfJ/fuyfgbSYOR2a4nlpcLjQo63HSCaGbFqrNyqjnwKvwiOesGGQicqfIcCOYF
         ngWiePRSa/HFeTlOalkW+wHAw7hkbWcnowOqoFdpoqJqK5LbFmTolxrqySNSi0WjFy1D
         /9D1f7Yk1bef97WjeZs0Q9e+du809RR72xiIuStoRAvCulCD8PSXWhwGCeZL9GmCS+Of
         0cPtE5LHedPb1jA4DJ3xgXVnssRynnQzUGj1KFvd0qXGnshHJ0+wnudqz/azfGMaQU8G
         SN0XNJmLjo+77ZGv0/0GyFyWPi5sAVIONZUWgHmseFyA3133WjCtpzuAwv75z869Cs+9
         5Mgg==
X-Gm-Message-State: APjAAAUBDOhTh96HuL/GfiIr/PtTbG+jrRJGiBKOAVHMydcsdyL+R3kP
        JsmavXp1bnKfniiOPy1VmkjJkskm9Jk=
X-Google-Smtp-Source: APXvYqzsdysCrRAiX+9dymR/ymAcapIQVkkgecrGMFl95o+30MhlXMWQ/Vrd3GWg8vN0B2sMujFXtQ==
X-Received: by 2002:a17:90a:b296:: with SMTP id c22mr1662482pjr.28.1559186965385;
        Wed, 29 May 2019 20:29:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5d01:260a:aaeb:131b? ([2601:282:800:fd80:5d01:260a:aaeb:131b])
        by smtp.googlemail.com with ESMTPSA id 124sm1090197pfe.124.2019.05.29.20.29.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 20:29:24 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: local route leaking
To:     George Wilkie <gwilkie@vyatta.att-mail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
 <20190527083402.GA7269@gwilkie-Precision-7520>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
Date:   Wed, 29 May 2019 21:29:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190527083402.GA7269@gwilkie-Precision-7520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/19 2:34 AM, George Wilkie wrote:
> On Sat, May 25, 2019 at 09:13:13AM -0600, David Ahern wrote:
>>> Using a loopback doesn't work, e.g. if 10.1.1.0/24 was on a global interface:
>>>    ip ro add vrf vrf-a 10.1.1.0/24 dev lo
>>
>> That works for MPLS when you exit the LSP and deliver locally, so it
>> should work here as well. I'll take a look early next week.
> 
> OK, thanks.
> 
>> I would prefer to avoid it if possible. VRF route leaking for forwarding
>> does not have the second lookup and that is the primary use case. VRL
>> with local delivery is a 1-off use case and you could just easily argue
>> that the connection should not rely on the leaked route. ie., the
>> control plane is aware of both VRFs, and the userspace process could use
>> the VRF-B path.
>>
> 
> Although it isn't always possible to change the userspace process -
> may be running in a specific vrf by 'ip vrf exec'
> 

sure, but that is a design choice for the control plane. Effectively,
you have this setup:

    { process }
         |
         |  packet
         |
  +--------------+          +--------------+
  |     VRF A    |          |     VRF B    |
  |              |          |              |
  |              |     <------ route to A  |
  |   +------+   |          |   +------+   |
  +---| ens1 |---+          +---| ens2 |---+
      +------+                  +------+
                                    ^
                                    |
                                    |
                                 packet

ie., the process is potentially bound to VRF-A, and you want it handle
packets from VRF-B and without binding to VRF-B.

I already mentioned one solution that works well if the route is only
used for forwarding (add a route to VRF-B using ens1 as the egress
device) and a solution that works for local delivery (add route to VRF-B
using vrf-A device to do a second lookup).

you are correct that use of loopback here for default VRF does not work
-- the lookup code gets confused because it is a forward path (as
opposed to MPLS which is a local input). I found a couple of solutions
that work for default VRF.

Again, using namespaces to demonstrate within a single node. This is the
base setup:

 ip li add vrf-b up type vrf table 2
 ip route add vrf vrf-b unreachable default
 ip ru add pref 32765 from all lookup local
 ip ru del pref 0

 ip netns add foo
 ip li add veth1 type veth peer name veth11 netns foo
 ip addr add dev veth1 10.200.1.1/24
 ip li set veth1 vrf vrf-b up
 ip -netns foo li set veth11 up
 ip -netns foo addr add dev veth11 10.200.1.11/24
 ip -netns foo ro add 10.200.2.0/24 via 10.200.1.1

 ip netns add bar
 ip li add veth2 type veth peer name veth12 netns bar
 ip li set veth2 up
 ip addr add dev veth2 10.200.2.1/24
 ip -netns bar li set veth12 up
 ip -netns bar addr add dev veth12 10.200.2.12/24

Cross VRF routing can be done with a veth pair, without addresses:

 ip li add xvrf1 type veth peer name xvrf2
 ip li set xvrf1 up
 ip li set xvrf2 master vrf-b up

 ip ro add vrf vrf-b 10.200.2.0/24 dev xvrf2
 ip ro add 10.200.1.0/24 dev vrf-b

or with addresses:

 ip li add xvrf1 type veth peer name xvrf2
 ip li set xvrf1 up
 ip addr add dev xvrf1 10.200.3.1/30
 ip li set xvrf2 master vrf-b up
 ip addr add dev xvrf2 10.200.3.2/30

 ip ro add vrf vrf-b 10.200.2.0/24 via 10.200.3.1 dev xvrf2
 ip ro add 10.200.1.0/24 via 10.200.3.2 dev xvrf1

Yes, this does have a double FIB lookup - one in VRF-B and again in
VRF-A, but I contend this is a design choice. Bind the process to VRF-B
and it works with 1 lookup.
