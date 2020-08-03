Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC023B132
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgHCXqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgHCXqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:46:45 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D73C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:46:45 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v22so23719600qtq.8
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nBRimnbLtH1IO9cj2v8X7IRjoaOLYzGc3sHDO+P34nc=;
        b=K9OQZOuVWeRNjPymBonHG4+wJWct5PsNIaGAwHS3CnaDMWx8GXqJdKHGGgvHwD+Jds
         ffAz2gM4w3jY/mIqrPGZgwqr8MdrVcMGoU7NeasdPYrD8eRxU73nUMAErJkrqOV9KX2o
         8JudElsqbYFlRSjhDxNzEeHIry5cy2+lEjLBFKCSpvOPgqaA6l9CuOOMGf+9vzQsLJhw
         8kdcz8WTl4X/iGekoEeFiXdyWmVtKhJjtkpqHpc8NvoxPUVHx/y2AhR7RpsNXXvHq2Nx
         rAHtKL/4xxI8mWoA/mqBlSLqF+VP07+c9Z+s27nRWVQZiU0PTEC7l47m8RoHCx19InCI
         P3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBRimnbLtH1IO9cj2v8X7IRjoaOLYzGc3sHDO+P34nc=;
        b=uRc7F47hN1T8z/H6BVdS2Oin0eq4N/qSMzd6Fe8rnQWPDMOnTKvhufg2YmiZtDIH38
         UYGlZyHIJGxZOKbH/jtrz3MWxnRT0QX4Y18nH/QTyLwjeAcko/z/v8Qi1riL28rCUKk/
         bqvpCx+w3S4StzteXXse3TQX5lfReY7QSR4s4358+n6JKTCz5voCiP6uHMyTgiichYr/
         d8/y4BSjTvGAtsJaZgT6yVz2tvzZJNwFeI8OfzLJpf12LjPKKGj0TbYNk2MttlwLo98p
         53e4LDJ8hmhhe1OmOpdrTmH5ZkovTagV9hfXi+tDBA4Xh1RrAwsyv8kNEifSAkMpt46y
         so9Q==
X-Gm-Message-State: AOAM533O+BO0rgH8qaFxnmd3T1PZBAqlfu8E9KrSl4zEEp9jnxjnVdaC
        S2SC15VtOn09/BXW3QKul0XfDgPV
X-Google-Smtp-Source: ABdhPJzJxnviyzZ7yb47ZdkNqwHX8cgQaosxDWzBXTx7dfPSUT90ExEbCO6G6Ig9UMs1DDGf/kcJnQ==
X-Received: by 2002:ac8:345c:: with SMTP id v28mr19195241qtb.390.1596498404032;
        Mon, 03 Aug 2020 16:46:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id 22sm20631069qkg.24.2020.08.03.16.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:46:43 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] Support PMTU discovery with bridged UDP
 tunnels
To:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596487323.git.sbrivio@redhat.com>
 <20200803232819.GA26394@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <04959252-b338-defb-9c45-4d0159f7cc34@gmail.com>
Date:   Mon, 3 Aug 2020 17:46:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200803232819.GA26394@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 5:28 PM, Florian Westphal wrote:
> Stefano Brivio <sbrivio@redhat.com> wrote:
>> Currently, PMTU discovery for UDP tunnels only works if packets are
>> routed to the encapsulating interfaces, not bridged.
>>
>> This results from the fact that we generally don't have valid routes
>> to the senders we can use to relay ICMP and ICMPv6 errors, and makes
>> PMTU discovery completely non-functional for VXLAN and GENEVE ports of
>> both regular bridges and Open vSwitch instances.
>>
>> If the sender is local, and packets are forwarded to the port by a
>> regular bridge, all it takes is to generate a corresponding route
>> exception on the encapsulating device. The bridge then finds the route
>> exception carrying the PMTU value estimate as it forwards frames, and
>> relays ICMP messages back to the socket of the local sender. Patch 1/6
>> fixes this case.
>>
>> If the sender resides on another node, we actually need to reply to
>> IP and IPv6 packets ourselves and send these ICMP or ICMPv6 errors
>> back, using the same encapsulating device. Patch 2/6, based on an
>> original idea by Florian Westphal, adds the needed functionality,
>> while patches 3/6 and 4/6 add matching support for VXLAN and GENEVE.
>>
>> Finally, 5/6 and 6/6 introduce selftests for all combinations of
>> inner and outer IP versions, covering both VXLAN and GENEVE, with
>> both regular bridges and Open vSwitch instances.
> 
> Thanks for taking over and brining this into shape, this looks good to
> me.

+1. I'm sure this took quite a bit of your time. Thanks for doing that.
I like this version much better.
