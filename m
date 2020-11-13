Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22C62B26FD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgKMVe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:34:27 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:45022 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKMVeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:11 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ADLWu0Y030268;
        Fri, 13 Nov 2020 22:33:01 +0100
Received: from [192.168.1.89] (93-36-192-249.ip61.fastwebnet.it [93.36.192.249])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 4D830120069;
        Fri, 13 Nov 2020 22:32:51 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605303172; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+X1G+Lkp2b1Tv0qjhUw8wbwmH/D+bzvKppCVUgLA64c=;
        b=cIvmJxm4rdbD5fYD5qqR4x9DjIGvUrLFhi6Ted4ndJjdDTyv334gsYvhPGaD6lZfR2/C+l
        Y+iz+I6O/TyklgCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605303172; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+X1G+Lkp2b1Tv0qjhUw8wbwmH/D+bzvKppCVUgLA64c=;
        b=q3/B3UTtgMCzojE7tWK4X1j6wkMVAzHwveZjmc8rSbs4Sr1h0nETkNMYBhsPirqtRDzqJk
        wZaLjBQmenT01zO6eczJ5Wqiy3dxgLdwzuki/KmbGlAEYV8O/Fw3mh+OuXcTzBAjcoc616
        QHuJbHHm1JhiNAmfqW61+6rqzs5VZ0TAI++ejSeR0mUUEtWqrOabfBVhw5JmGlDM0KDGzG
        5E33RhsKonvORiw71R3e/HjxPuSR4UMG8JBNNzB0c6Bg6bGI4rDCjq3M11oghNR3eDt92/
        WZEGK6hE2wD2x0vLGp8soW+DRd7bI5ItyoKxCkai+YzWjUpRdjkYwanzIBmzZw==
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
 <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
 <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
 <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
 <09381c96-42a3-91cd-951b-f970cd8e52cb@gmail.com>
 <20201113114036.18e40b32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefano Salsano <stefano.salsano@uniroma2.it>
Message-ID: <fbc0fc5f-fb78-dcf0-7535-2119389ec8e2@uniroma2.it>
Date:   Fri, 13 Nov 2020 22:32:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201113114036.18e40b32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 2020-11-13 20:40, Jakub Kicinski ha scritto:
> On Fri, 13 Nov 2020 10:04:44 -0700 David Ahern wrote:
>> On 11/13/20 10:02 AM, Stefano Salsano wrote:
>>> Il 2020-11-13 17:55, Jakub Kicinski ha scritto:
>>>> On Thu, 12 Nov 2020 18:49:17 -0700 David Ahern wrote:
>>>>> On 11/12/20 6:28 PM, Andrea Mayer wrote:
>>>>>> The implementation of SRv6 End.DT4 differs from the the
>>>>>> implementation of SRv6
>>>>>> End.DT6 due to the different *route input* lookup functions. For
>>>>>> IPv6 is it
>>>>>> possible to force the routing lookup specifying a routing table
>>>>>> through the
>>>>>> ip6_pol_route() function (as it is done in the
>>>>>> seg6_lookup_any_nexthop()).
>>>>>
>>>>> It is unfortunate that the IPv6 variant got in without the VRF piece.
>>>>
>>>> Should we make it a requirement for this series to also extend the v6
>>>> version to support the preferred VRF-based operation? Given VRF is
>>>> better and we require v4 features to be implemented for v6?
>>>
>>> I think it is better to separate the two aspects... adding a missing
>>> feature in IPv4 datapath should not depend on improving the quality of
>>> the implementation of the IPv6 datapath :-)
>>>
>>> I think that Andrea is willing to work on improving the IPv6
>>> implementation, but this should be considered after this patchset...
>>
>> agreed. The v6 variant has existed for a while. The v4 version is
>> independent.
> 
> Okay, I'm not sure what's the right call so I asked DaveM.
> 
> TBH I wasn't expecting this reaction, we're talking about a 200 LoC
> patch which would probably be 90% reused for v6...
> 

Jakub, we've considered the possibility to extend the v6 version to 
support the preferred VRF-based operation as you suggested

at first glance, it would break the uAPI compatibility with existing 
scripts that use SRv6 DT6, currently we configure the decap operation in 
this way

ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 
dev eth0

if the v6 version is extended to support the VRF-based operation, in 
order to configure the decap operation we have to do (like we do in the 
v4 version)

ip link add vrf0 type vrf table 100
sysctl -w net.vrf.strict_mode=1
ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 
dev eth0

(of course the sysctl is needed globally once... while the "ip link 
add..." command is needed once for every table X that is used in a script)

considering how much we care of not breaking existing functionality... 
it is not clear IMO if we should go into this direction or we should 
think twice... and maybe look for another design to introduce VRFs into v6

so I would prefer finalizing the DT4 patchset and then start discussing 
the VRF support in v6 version

-- 
*******************************************************************
Stefano Salsano
Professore Associato
Dipartimento Ingegneria Elettronica
Universita' di Roma Tor Vergata
Viale Politecnico, 1 - 00133 Roma - ITALY

http://netgroup.uniroma2.it/Stefano_Salsano/

E-mail  : stefano.salsano@uniroma2.it
Cell.   : +39 320 4307310
Office  : (Tel.) +39 06 72597770 (Fax.) +39 06 72597435
*******************************************************************

