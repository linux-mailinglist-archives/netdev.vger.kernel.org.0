Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4855217E3BA
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCIPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:36:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34341 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCIPgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:36:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id 59so7311987qtb.1;
        Mon, 09 Mar 2020 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R3DooPh2yevxib7OX0+4fWi6Vz6O2eWxJlitrIuPivY=;
        b=rMpJ5aMp+4Fa8AOYiMvodgd1VykYZ9T2AW/DfwPBNMuWHqP4j+pyl598fx/hyebENv
         WhGgCFfNNZFmKMuONOG9MkxdhkyuIfhUfP6N7jmb28FUzsYFbqk20HylZk+dbdiOP3Q2
         O8NNIijLVC5RpH8fSiFxqaRsBAeNKvihx6xetMfpdoR1O1Z6Xwl9xPfdpLzyfXg9B+Qn
         J7SsgUztlu0at0XSFSFIXsmCe0UqK7VsDZ2yBt3eLNzEf7jcfBu5xP5fk3tgqJd6Rp94
         The+jdOviCUfI76JYGcaHEq/91ivkgJgR2kxDClLiIyiC9zOxz/CvPjIjVOw1DO9CHjV
         SilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R3DooPh2yevxib7OX0+4fWi6Vz6O2eWxJlitrIuPivY=;
        b=DMBWqHuxsRDV9QJp93hs5+eJR04CsP/KsRKdjEocx9J8JSJgvVpwE62Li1kknMCmqv
         7kLVZhXHuJzZtREGAV9L0qqdBvyzIa8OpkJKsppYJe9ahEXgRPkIpnodFfRDuC+kbtg1
         4CBIl/6k5+hGnSBCaGPvYP0FCj4s2rhUQ2TYyeF/hTED+53+iEVlUyv2WlD8w+wgQ1hi
         kF9cXVD6IAd4IYTWt/8MC4ttzKPKTNU+mWffk/ZlohCIm940iiqlPVfpxZO3j3ZIzJbN
         UFYWUUNhi7BdIMBB/23nwzffLhrcfnm4PCRkWnDQ74/IR9RzKI0Sc2Wct9mUIIFmzN0M
         ZO7g==
X-Gm-Message-State: ANhLgQ3A3+VWTJc/bG+JxBVHklQWyXtT1u4kV24rEyTtSaWwvJgjV9iG
        bEQDEu1/PLt8tZafoW/D1qY=
X-Google-Smtp-Source: ADFU+vtJmE2sKPK9aljbzaPahTAvZa53+alfdl67ij/4w48I/IA1HKHuON8PnhjDekW1t6yERJtnXw==
X-Received: by 2002:ac8:6b44:: with SMTP id x4mr3818509qts.186.1583768211793;
        Mon, 09 Mar 2020 08:36:51 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c8c4:d4d8:cd2d:6f68? ([2601:282:803:7700:c8c4:d4d8:cd2d:6f68])
        by smtp.googlemail.com with ESMTPSA id c12sm1210884qtb.49.2020.03.09.08.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 08:36:50 -0700 (PDT)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d458b4c0-963e-d9bc-c4bb-ab689edd7686@gmail.com>
Date:   Mon, 9 Mar 2020 09:36:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4ed5aff3-43e8-0138-1848-22a3a1176e46@gssi.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 9:45 AM, Ahmed Abdelsalam wrote:
> 
> However, in the SRv6 we don’t really need a VRF device. The SRv6
> functions (the already supported ones as well as the End.DT4 submitted
> here) resides in the IPv6 FIB table.
> 
> The way it works is as follows:
> 1) create a table for the tenant
> $ echo 100 tenant1 >> /etc/iproute2/rt_tables
> 
> You instantiate an SRv6 End.DT4 function at the Egress PE to decapsulate
> the SRv6 encapsulation and lookup the inner packet in the tenant1 table.
> The example iproute2 command to do so is as below.
> 
> $ ip -6 route add A::B encap seg6local action End.DT4 table tenant1 dev
> enp0s8
> 
> This installs an IPv6 FIB entry as shown below.
> $ ip -6 r
> a::b  encap seg6local action End.DT4 table 100 dev enp0s8 metric 1024
> pref medium
> 
> Then the BGP routing daemon at the Egress PE is used to advertise this
> VPN service. The BGP sub-TLV to support SRv6 IPv4 L3VPN is defined in [2].
> 
> The SRv6 BGP extensions to support IPv4/IPv6 L3VPN are now merged in in
> FRRouting/frr [3][4][5][6].
> 
> There is also a pull request for the CLI to configure SRv6-locator on
> zebra [7].
> 
> The BGP daemon at the Ingress PE receives the BGP update and installs an
> a FIB entry that this bound to SRv6 encapsulation.
> 
> $ ip r
> 30.0.0.0/24  encap seg6 mode encap segs 1 [ a::b ] dev enp0s9
> 
> Traffic destined to that tenant will get encapsulated at the ingress
> node and forwarded to the egress node on the IPv6 fabric.
> 
> The encapsulation is in the form of outer IPv6 header that has the
> destination address equal to the VPN service A::B instantiated at the
> Egress PE.
> 
> When the packet arrives at the Egress PE, the destination address
> matches the FIB entry associated with the End.DT4 function which does
> the decapsulation and the lookup inside the tenant table associated with
> it (tenant1).

And that is exactly how MPLS works. At ingress, a label is pushed to the
front of the packet encapping the original packet at the network header.
It traverses the label switched path and at egress the label is popped
and tenant table can be consulted.

IPv6 SR is not special with any of these steps. If you used a VRF device
and used syntax that mirrors MPLS, you would not need a kernel change.
The infrastructure to do what you need already exists, you are just
trying to go around and special case the code.

SR for IPv6 packets really should have been done this way already; the
implementation is leveraging a code path that should not exist.

> 
> Everything I explained is in the Linux kernel since a while. End.DT4 was
> missing and this the reason we submitted this patch.
> 
> In this multi-tenant DC fabric we leverage the IPv6 forwarding. No need
> for MPLS dataplane in the fabric.

My MPLS comment was only point out that MPLS encap and IPv6 SR encap is
doing the exact same thing.

