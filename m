Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0693B093D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhFVPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhFVPjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:39:07 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A46C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:36:49 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w127so24237520oig.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uAf/ffwpYCket7ohqavaEu/aRUylps2eG8H+bOmZxJ8=;
        b=YvjfOlGPx6qacI6vAdwFuNgJflmdGg6sH6QS1saL9uTtuEtv51dnURbD6rqRZnDRFZ
         3AsEQVAYmfyACC6p4cyijKD1oqIjxGW8h9eTgFMeUdHjitMq8Z8E7kigpMx5xrSPbka8
         yQWjH4QTUCzrxNqq16+KVX5CA/AE3pJSntW+QgCRN8V011lU6dkuXG8UPCVWxDRoYzgy
         vDkBZzTE+ViZ3BXSp6Hc8I3Bql9Af6YJEh+PcDYVb37lbb9CDTdWCbtSdJ7xRrldV0uC
         uhnl/FEYhSWnIQKmfi2fCrbhyteuOTzcLDVOxJt31uzJAAxQOMgrfgopLvNOe37UALtj
         j33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uAf/ffwpYCket7ohqavaEu/aRUylps2eG8H+bOmZxJ8=;
        b=TZrpEyDX09it6m7p1XawCWKcbgfZtx542076+a4c6NIK//88CrZ6MIDR1zoVfquE8y
         bVeR5Rujw3VrXjSqfJu42UgcdGuJY3bCy6qQ7tjbxXOd8vqclfjzl6LCJt4qDZldNfyi
         lIZ6c+SRRyuw4/4mbTmvbJ7YHIQsUDVbh8ck1sRPa+bvJFmt3gbSWHm3vYDEdglvAats
         OqNLzybjkIHNOa8j6o24viYQG+zagIQvVqXY1l3G8XZW7TBe7yP6Gy1KJGgyeh+Slzeo
         BM2Sx4Zm6b3rI9pEVB547vaKqCDPb/o01bbZwsLsqXO2pDbwb4T8DR6F78Ryi+QbgPqN
         Mtww==
X-Gm-Message-State: AOAM531wyxC6Nu6BM9UoibABO+TUiKFDg48kAqKv56SeVsjIPDjK5aTn
        64DD3r2J1j06Cybdk8C8K1E=
X-Google-Smtp-Source: ABdhPJzSJO9kUNEpwRR7h1Boy/DSCEx8Nm2zd6CktTLjGf1Mt8Z2GCV0L1yCcnyJwCg1lPn0OxcZFw==
X-Received: by 2002:aca:6106:: with SMTP id v6mr3557248oib.175.1624376208825;
        Tue, 22 Jun 2021 08:36:48 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id l7sm4618948otu.76.2021.06.22.08.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 08:36:48 -0700 (PDT)
Subject: Re: [iproute2-next v1] seg6: add support for SRv6 End.DT46 Behavior
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20210617172354.10607-1-paolo.lungaroni@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6423b21b-8feb-486f-f06b-cf7921894b16@gmail.com>
Date:   Tue, 22 Jun 2021 09:36:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210617172354.10607-1-paolo.lungaroni@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 11:23 AM, Paolo Lungaroni wrote:
> We introduce the new "End.DT46" action for supporting the SRv6 End.DT46
> Behavior in iproute2.
> The SRv6 End.DT46 Behavior, defined in RFC 8986 [1] section 4.8, can be
> used to implement L3 VPNs based on Segment Routing over IPv6 networks in
> multi-tenants environments and it is capable of handling both IPv4 and
> IPv6 tenant traffic at the same time.
> The SRv6 End.DT46 Behavior decapsulates the received packets and it
> performs the IPv4 or IPv6 routing lookup in the routing table of the
> tenant.
> 
> As for the End.DT4 and for the End.DT6 in VRF mode, the SRv6 End.DT46
> Behavior leverages a VRF device in order to force the routing lookup into
> the associated routing table using the "vrftable" attribute.
> 
> To make the End.DT46 work properly, it must be guaranteed that the
> routing table used for routing lookup operations is bound to one and
> only one VRF during the tunnel creation. Such constraint has to be
> enforced by enabling the VRF strict_mode sysctl parameter, i.e.:
> 
>  $ sysctl -wq net.vrf.strict_mode=1
> 
> Note that the same approach is used for the End.DT4 Behavior and for the
> End.DT6 Behavior in VRF mode.
> 
> An SRv6 End.DT46 Behavior instance can be created as follows:
> 
>  $ ip -6 route add 2001:db8::1 encap seg6local action End.DT46 vrftable 100 dev vrf100
> 
> Standard Output:
>  $ ip -6 route show 2001:db8::1
>  2001:db8::1  encap seg6local action End.DT46 vrftable 100 dev vrf100 metric 1024 pref medium
> 
> JSON Output:
> $ ip -6 -j -p route show 2001:db8::1
> [ {
>         "dst": "2001:db8::1",
>         "encap": "seg6local",
>         "action": "End.DT46",
>         "vrftable": 100,
>         "dev": "vrf100",
>         "metric": 1024,
>         "flags": [ ],
>         "pref": "medium"
> } ]
> 
> This patch updates the route.8 man page and the ip route help with the
> information related to End.DT46.
> Considering that the same information was missing for the SRv6 End.DT4 and
> the End.DT6 Behaviors, we have also added it.
> 
> [1] https://www.rfc-editor.org/rfc/rfc8986.html#name-enddt46-decapsulation-and-s
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  2 ++
>  ip/iproute.c                    |  4 +--
>  ip/iproute_lwtunnel.c           |  1 +
>  man/man8/ip-route.8.in          | 48 +++++++++++++++++++++++++++++++++
>  4 files changed, 53 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks,

