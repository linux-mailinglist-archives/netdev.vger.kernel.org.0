Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446853BEA51
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhGGPIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhGGPIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:08:06 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB44C061574;
        Wed,  7 Jul 2021 08:05:26 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 65so1715582oie.11;
        Wed, 07 Jul 2021 08:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vV+yejyaKmFblQMQhljd/KTv7T5WzF1kB2W0gv6r/cE=;
        b=Voz5ggbq5byusiRtpmIrkvLAxxlNmKMlFKkmmE1D2B3AmWW7e0dI2GaLlhlFzZMKpC
         cqx0NS2Sc9Gi3Wnkesq5BoD8FIhuAz3z13/K1sQSi8d10UD76vpiGRwCncvm24HyD6a/
         RYVvhzA4Ny4mJiIYbg64zzZ+OsDAY3jeB9qj8RzbangxcpQNEaRwvCTDHpH9ZEWreu3d
         1NmIQ2h1PL8RZ6NQp9XgxS3xjPGlqj/HIFCxdMXM/LXi037HERZmJEOw2bSB+4LIkWJV
         U+DecBoAAwxYnNGgyfyRTEkdYA301nK0v4Gxzh7EcBt+BhSSZMn5w0tzbZvcmr5MmzEy
         EWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vV+yejyaKmFblQMQhljd/KTv7T5WzF1kB2W0gv6r/cE=;
        b=DEtW64D+VfEd94O+V25HMwgmACoFxqvawFXIeGWNqxc+U5Yc3Lha+k+i2gCdWiRyAO
         W80WCdxFOYgNFQQTU/b86M1SNQs8XeM0KLd0LeFiV/jBLdZwxyYNmp0k5hJ9jKpNe0A2
         yIuG0Trg7X7BYR5D+NLR2e26gtDPY6LUeEJr6rmzcG4p2AyZMoFrvZ3pbRRt0zmQ+rEw
         LozMdJc6zXn3KE1pks6oDByjvZKWW9Xk9nw/JQVcNRK1DEtE74LYZ+lxKQ6b/Gv/KYSv
         f6QAyOeWiVwRraUWx1PCQW/rSb7FuaLyeMqntFT9txeZ31qei+BCX3c+r1FKSsZOw/hU
         gNbA==
X-Gm-Message-State: AOAM532EWoZqRNaHsp+hn+wO13+ysEZjYIpH2LIuipzGsYN7dam7T6JE
        YkUUiO42E03Apn+zN3YGbm9SIM2jo8JWlw==
X-Google-Smtp-Source: ABdhPJyAcbTIDF2nomja+xTYgmiYBmUUKqr0PQRmc1euQgu5Dk/lZYteKgBLd4zXko/tju1WX6HGdA==
X-Received: by 2002:aca:c207:: with SMTP id s7mr16847874oif.86.1625670325948;
        Wed, 07 Jul 2021 08:05:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id t15sm3990552oiw.16.2021.07.07.08.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 08:05:25 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder> <20210701145943.GA3933@pc-32.home>
 <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
 <20210706190253.GA23236@pc-32.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f017bb67-73ff-7745-0da5-b267fe0f0501@gmail.com>
Date:   Wed, 7 Jul 2021 09:05:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706190253.GA23236@pc-32.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/21 1:02 PM, Guillaume Nault wrote:
> On Thu, Jul 01, 2021 at 09:38:44AM -0600, David Ahern wrote:
>> On 7/1/21 8:59 AM, Guillaume Nault wrote:
>>> I first tried to write this selftest using VRFs, but there were some
>>> problems that made me switch to namespaces (I don't remember precisely
>>> which ones, probably virtual tunnel devices in collect_md mode).
>>
>> if you hit a problem with the test not working, send me the test script
>> and I will take a look.
> 
> So I've looked again at what it'd take to make a VRF-based selftest.
> The problem is that we currently can't create collect_md tunnel
> interfaces in different VRFs, if the VRFs are part of the same netns.
> 
> Most tunnels explicitely refuse to create a collect_md device if
> another one already exists in the netns, no matter the rest of the
> tunnel parameters. This is the behaviour of ip_gre, ipip, ip6_gre and
> ip6_tunnel.
> 
> Then there's sit, which allows the creation of the second collect_md
> device in the other VRF. However, iproute2 doesn't set the
> IFLA_IPTUN_LINK attribute when it creates an external device, so it
> can't set up such a configuration.
> 
> Bareudp simply doesn't support VRF.
> 
> Finally, vxlan allows devices with different IFLA_VXLAN_LINK attributes
> to be created, but only when VXLAN_F_IPV6_LINKLOCAL is set. Removing
> the VXLAN_F_IPV6_LINKLOCAL test at the end of vxlan_config_validate()
> is enough to make two VXLAN-GPE devices work in a multi-VRF setup:

Thanks for the details. In short, some work is needed to extend VRF
support to these tunnels. That is worth doing if you have the time.
