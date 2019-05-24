Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C59729FB8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404164AbfEXUTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:19:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42788 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404156AbfEXUTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:19:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id r22so3067919pfh.9
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 13:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5nBWi4F6owvg3A/l7UKfxIyHVFOE9GjKWlPpn66NZTQ=;
        b=XZZnO0TsC2dMM/HCmvJA/cR2nNO19hXHiyi3A8bPHZ6wG2eWymlKA41WTBAC+g1TSc
         RghlTIDOTWd4zWmTR1VKZ82tetj/JGEeUORx8wWOlYkYRbP4D7ILV/L6uE5Pq/pPLlT+
         niiegqHWeaUkwk44l/6RoerN+xi2QJse40zWXjaDWB9RR4I1qfJ/4NUZQxo8c/g0z7vd
         VAUsPw+WZfjWAVuLHx0K4hl0/dOgLfQsVtVTAdSmIeWkMl9d1xNAu1jw+EA0/cPgcJbz
         OUVQCCsZXF9hik3/TaCxhR9HhG6aNj09h68bX6Bo0I3skz3iiGGUYQadYV8jJFz1mIRQ
         kPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nBWi4F6owvg3A/l7UKfxIyHVFOE9GjKWlPpn66NZTQ=;
        b=M+e9cb+yD+e/THeNhRizjHU2x8DjZX0sMuyXumAFSsh+ZZDeUtZ30Q7vPavFu6uh4i
         RUodycYDFBQASqbZj7FBnlAxF8H090MdijINsFogvRvbC2tJlOKxV89VP+uK++6BK/66
         KRkYU1dF4dpdYscp8QsLD82Rgtoo2s8sWHgawfnW1h8JcsU0f7t5WQEATkjzFulLzbIt
         g6jMlK6+Zv3gvEBNZcChW7XunWN2aCmSUs3ES8nghYPAZodn3KY8Jh35nlB94wIEbxbs
         EvfNgzZklxK5zaMKZU0ggZPpyMPBm6Ao/QQudRw3BBeWpg6P5ijzh2ekCbIRfAGaFKC9
         /CCQ==
X-Gm-Message-State: APjAAAXIatfTBPIg7tg7kipouKRUBWaxcQkDuDG55VaRq6wh91Ky9S39
        VEOA9PyQayJUaC/m5FrHSGCdJ7zK
X-Google-Smtp-Source: APXvYqyVlExAwVJsd/iv5xrSIhEFAyqQ4dKje+uSt6q0uNIUz5uwtu+tMw2vo4xYuz9bMUs2ONnaWg==
X-Received: by 2002:a17:90a:8586:: with SMTP id m6mr11869023pjn.129.1558729188051;
        Fri, 24 May 2019 13:19:48 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:59ee:6a57:8906:e2a1? ([2601:282:800:fd80:59ee:6a57:8906:e2a1])
        by smtp.googlemail.com with ESMTPSA id l21sm3569088pff.40.2019.05.24.13.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:19:47 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: local route leaking
To:     George Wilkie <gwilkie@vyatta.att-mail.com>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
Date:   Fri, 24 May 2019 14:19:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 2:05 AM, George Wilkie wrote:
> If have an interface in vrf A:
> 
>   10.10.2.0/24 dev ens9 proto kernel scope link src 10.10.2.2
>   local 10.10.2.2 dev ens9 proto kernel scope host src 10.10.2.2
> 
> and want to leak it into vrf B, it is not sufficient to leak just
> the interface route:
> 
>   ip route add 10.10.2.0/24 vrf B dev ens9
> 
> as traffic arriving into vrf B that is destined for 10.10.2.2 will
> not arrive - it will be sent to the ens9 interface and nobody will
> respond to the ARP.
> 
> In order to handle the traffic locally, the local route must also
> be leaked to vrf B:
> 
>   ip route add local 10.10.2.2 vrf B dev ens9
> 
> However, that still doesn't work as the traffic is processed in
> the context of the input vrf B and does not find a socket that is
> bound to the destination vrf A.

I presume you mean traffic arrives on another interface assigned to VRF
B with the final destination being the local address of ens9 in VRF-A.


I think this codifies the use case:
  ip li add vrf-a up type vrf table 1
  ip route add vrf vrf-a unreachable default
  ip li add vrf-b up type vrf table 2
  ip route add vrf vrf-b unreachable default
  ip ru add pref 32765 from all lookup local
  ip ru del pref 0

  ip netns add foo
  ip li add veth1 type veth peer name veth11 netns foo
  ip addr add dev veth1 10.1.1.1/24
  ip li set veth1 vrf vrf-b up
  ip -netns foo li set veth11 up
  ip -netns foo addr add dev veth11 10.1.1.11/24
  ip -netns foo ro add 10.1.2.0/24 via 10.1.1.1

  ip netns add bar
  ip li add veth2 type veth peer name veth12 netns bar
  ip li set veth2 vrf vrf-a up
  ip addr add dev veth2 10.1.2.1/24
  ip -netns bar li set veth12 up
  ip -netns bar addr add dev veth12 10.1.2.12/24

If you do route leaking this way:
  ip ro add vrf vrf-b 10.1.2.0/24 dev veth2
  ip ro add vrf vrf-a 10.1.1.0/24 dev veth1

yes, you hit problems trying to connect to a local address.

If you do route leaking this way:
  ip ro add vrf vrf-b 10.1.2.0/24 dev vrf-a
  ip ro add vrf vrf-a 10.1.1.0/24 dev vrf-b

you do not.
