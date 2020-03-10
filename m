Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B39A180332
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgCJQ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:26:32 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:43126 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCJQ0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:26:31 -0400
Received: by mail-wr1-f46.google.com with SMTP id v9so16669013wrf.10
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gssi.it; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ks1urGZn2b84S3Er+eF+UoZsD/ohx1YFDvdHGp6yUg4=;
        b=Qr5bfUTrgOtCkDOGYvEAfCD/PA7cUbD9aUSIyn5cjUrk/pFSfuuKD+W0eHvRBTFGat
         7hPsp0r0sZiP3SJy1c5T1j0RgGyMNZZ7q6uZv49kdFwApFbclU4brSwzPFA9vPZ568ZG
         KT91fRrTLxDU24DsUYRUv9Zl1ObvZiSqd05Nna7tiLiRqYcXcY/vo9ty+hJwbI/+cxE1
         XvTwZ6QQ3FKbpQL0m9gYtDtfKVNYD3u0ngQV8YOpQ1QY9OVBZlp+bigP5Rgb0sPw5nh8
         +jLW0Zb6EDc8IXbPFzgwlFuXYQd20rAmFgzeymtjOJ3uq2Mo+yUIpjhNiZRtvCMAwHtl
         zaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ks1urGZn2b84S3Er+eF+UoZsD/ohx1YFDvdHGp6yUg4=;
        b=jYzYU0CPlioT6X/5sY2PCzNLCfjgy4bHPrlGGp8xJK2O9T/cwZ96fOJhJQW7vTvJEV
         6eHct9PV1QgHuWt3cg1r4EweJrCV14KCaB9ZTfmTxcZlXOP4hJJAlN1t1c0xwFSqckA4
         APM/Z2+liULeZ25kbtjTV8W05EHp1lafsH9ujldsLi+WooiBUkBaeGF16cgI03xk+7Jy
         SVnGpAx7vYSbhLkfI2SeqJz3he0wF8M/du9PqzCJy2yKF88W4aB0nT5oAbdCbJ3qYxjQ
         Enjp6devKk/ZGdpazTy8rxt1pyPXajAsmFP2BRxcIJvjekWDjqzUjA/1Eu6to6m7tjio
         wulQ==
X-Gm-Message-State: ANhLgQ2FT4S5uvrkO+0Fp6DER/Z4BJaYvNkWwVX5UR/JZQgjcbrhJyqD
        6X/wSV+rdjQfISCFlaR+rPn4Gw==
X-Google-Smtp-Source: ADFU+vuBXpIQLc0v0jdkLxgA4hf/fHDrWGcVUeSBPd/fzPSaTixJPGQuTWU0mezb427pCOaflDEn4A==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr21222303wrp.214.1583857587887;
        Tue, 10 Mar 2020 09:26:27 -0700 (PDT)
Received: from [192.168.1.125] (dynamic-adsl-78-14-150-182.clienti.tiscali.it. [78.14.150.182])
        by smtp.gmail.com with ESMTPSA id f207sm5138848wme.9.2020.03.10.09.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:26:27 -0700 (PDT)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     David Ahern <dsahern@gmail.com>,
        Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dav.lebrun@gmail.com,
        andrea.mayer@uniroma2.it, paolo.lungaroni@cnit.it,
        hiroki.shirokura@linecorp.com
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
 <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
 <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
 <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
 <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
 <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
 <a39867b0-c40f-e588-6cf9-1524581bb145@gmail.com>
 <4ed5aff3-43e8-0138-1848-22a3a1176e46@gssi.it>
 <d458b4c0-963e-d9bc-c4bb-ab689edd7686@gmail.com>
From:   Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
Message-ID: <55bbaf3f-653b-6194-fdb4-3efe2a7adcba@gssi.it>
Date:   Tue, 10 Mar 2020 17:26:24 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d458b4c0-963e-d9bc-c4bb-ab689edd7686@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for your reply.

Our goal is not really a work around what is available and what the VRF 
can do.
The main issue (you already scratched in you email) is the consistency 
between IPv4 L3VPN and IPv6 L3VPN.
We can use the VRF device for End.DT4 but this will lead to 
inconsistency with End.DT6 as it uses the table instead.
This becomes hard to operate as provisioning the IPv4 and IPv6 VPNs 
needs to be done in different ways.

We would appreciate to get get your thoughts/advices on that and how we 
should go forward.

Regards,
Ahmed


On 09/03/2020 16:36, David Ahern wrote:
> On 3/6/20 9:45 AM, Ahmed Abdelsalam wrote:
>>
>> However, in the SRv6 we don’t really need a VRF device. The SRv6
>> functions (the already supported ones as well as the End.DT4 submitted
>> here) resides in the IPv6 FIB table.
>>
>> The way it works is as follows:
>> 1) create a table for the tenant
>> $ echo 100 tenant1 >> /etc/iproute2/rt_tables
>>
>> You instantiate an SRv6 End.DT4 function at the Egress PE to decapsulate
>> the SRv6 encapsulation and lookup the inner packet in the tenant1 table.
>> The example iproute2 command to do so is as below.
>>
>> $ ip -6 route add A::B encap seg6local action End.DT4 table tenant1 dev
>> enp0s8
>>
>> This installs an IPv6 FIB entry as shown below.
>> $ ip -6 r
>> a::b  encap seg6local action End.DT4 table 100 dev enp0s8 metric 1024
>> pref medium
>>
>> Then the BGP routing daemon at the Egress PE is used to advertise this
>> VPN service. The BGP sub-TLV to support SRv6 IPv4 L3VPN is defined in [2].
>>
>> The SRv6 BGP extensions to support IPv4/IPv6 L3VPN are now merged in in
>> FRRouting/frr [3][4][5][6].
>>
>> There is also a pull request for the CLI to configure SRv6-locator on
>> zebra [7].
>>
>> The BGP daemon at the Ingress PE receives the BGP update and installs an
>> a FIB entry that this bound to SRv6 encapsulation.
>>
>> $ ip r
>> 30.0.0.0/24  encap seg6 mode encap segs 1 [ a::b ] dev enp0s9
>>
>> Traffic destined to that tenant will get encapsulated at the ingress
>> node and forwarded to the egress node on the IPv6 fabric.
>>
>> The encapsulation is in the form of outer IPv6 header that has the
>> destination address equal to the VPN service A::B instantiated at the
>> Egress PE.
>>
>> When the packet arrives at the Egress PE, the destination address
>> matches the FIB entry associated with the End.DT4 function which does
>> the decapsulation and the lookup inside the tenant table associated with
>> it (tenant1).
> 
> And that is exactly how MPLS works. At ingress, a label is pushed to the
> front of the packet encapping the original packet at the network header.
> It traverses the label switched path and at egress the label is popped
> and tenant table can be consulted.
> 
> IPv6 SR is not special with any of these steps. If you used a VRF device
> and used syntax that mirrors MPLS, you would not need a kernel change.
> The infrastructure to do what you need already exists, you are just
> trying to go around and special case the code.
> 
> SR for IPv6 packets really should have been done this way already; the
> implementation is leveraging a code path that should not exist.
> 
>>
>> Everything I explained is in the Linux kernel since a while. End.DT4 was
>> missing and this the reason we submitted this patch.
>>
>> In this multi-tenant DC fabric we leverage the IPv6 forwarding. No need
>> for MPLS dataplane in the fabric.
> 
> My MPLS comment was only point out that MPLS encap and IPv6 SR encap is
> doing the exact same thing.
> 
