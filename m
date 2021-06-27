Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B703B5420
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhF0P70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 11:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhF0P7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 11:59:23 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CE2C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 08:56:59 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id v3-20020a4ac9030000b029024c9d0bff49so120873ooq.0
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 08:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vJzpU7Kw4sOLmyq3V4zJjwoaRU/wLYyiYRfTmlbrCWI=;
        b=WSA0i8HTaAnR7BBd/UXQeQs1kf+hkq18B5/T1k5IgIuww74G7rBAcyodcM4CkQ0meI
         An5djIyNd6bX5jRMbMhZXpdPLD3+jaZXakVYfU2tdUaH8/cGaY+9t0/FYhNkCBCSinB1
         3it+Hf9gqe9uJmn/cX5nKjlFuLtzrq3mKQgrp7hQlOI35VXvsIjo7y+n/ZEIzJUVIERf
         WLZF89lWpGmLVG3M7LmId+eJbR8HOrR2YROjEtGtqOt0NhtyusRv7/d9I6cM71fziHrA
         KBd9LWtq+Boz2/BbQG7nV7QMp6AlusU9veKvO1IcEKdaN5NpSTJY7blotICf3LlolotL
         32yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vJzpU7Kw4sOLmyq3V4zJjwoaRU/wLYyiYRfTmlbrCWI=;
        b=mg6dlGcJ4TQZ678oK4CHsKnGc913f2ytfK46djW7KfLMPpnCi/Rqk3citFvXVE0e6r
         XjNnjPZxrXutc2kHI1+nDeA1AI5Ec2W3wzrqQgs19Wyo8DAyO7rZc61XO2RMwcNaCjtZ
         +OwDcR4oiRzrhnciUNuD12UDTs0qDv/FYXO5A7WUerF1NBcDzKCwFi+oPD8cX2OFUy2j
         N/Rw+8njLNG9rWIrmQ2acyZOLv64GMFxbai+0VKHOu4NcyyRP1SIbsn4S9jb/EUg4NtQ
         rZWau9xCayfNoKBK8ldsI6F7ecV5/2JkGNNDMmwW1dU3VZl5TebgW8UtMjEfSr3OGMA9
         YwWQ==
X-Gm-Message-State: AOAM531nvROaWInZWUvDqtWIrMvy0zir1R27j0UxXeYcxhi6MoMcg9zp
        7U0CgcBC9QHGV23JDU4Ef1zXWkoA4uX3GQ==
X-Google-Smtp-Source: ABdhPJxQX+G44QEEMY85cBorDWGFNdvrRBMTx2EgXJ4whf5O5GwEFj4DOovDgxeYEjQJgnS1ZZTlkA==
X-Received: by 2002:a4a:b481:: with SMTP id b1mr16310608ooo.79.1624809418676;
        Sun, 27 Jun 2021 08:56:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id z21sm187572otq.30.2021.06.27.08.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 08:56:57 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] net: reset MAC header consistently across L3
 virtual devices
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Benc <jbenc@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Andreas Schultz <aschultz@tpip.net>,
        Jonas Bonn <jonas@norrbonn.se>
References: <cover.1624572003.git.gnault@redhat.com>
 <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
 <20210626205323.GA7042@pc-32.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2547b53c-9c22-67ec-99fb-e7e2b403f9f1@gmail.com>
Date:   Sun, 27 Jun 2021 09:56:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210626205323.GA7042@pc-32.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/21 2:53 PM, Guillaume Nault wrote:
> On Sat, Jun 26, 2021 at 11:50:19AM -0600, David Ahern wrote:
>> On 6/25/21 7:32 AM, Guillaume Nault wrote:
>>> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
>>> reset the MAC header pointer after they parsed the outer headers. This
>>> accurately reflects the fact that the decapsulated packet is pure L3
>>> packet, as that makes the MAC header 0 bytes long (the MAC and network
>>> header pointers are equal).
>>>
>>> However, many L3 devices only adjust the network header after
>>> decapsulation and leave the MAC header pointer to its original value.
>>> This can confuse other parts of the networking stack, like TC, which
>>> then considers the outer headers as one big MAC header.
>>>
>>> This patch series makes the following L3 tunnels behave like VXLAN-GPE:
>>> bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
>>>
>>> The case of gre is a bit special. It already resets the MAC header
>>> pointer in collect_md mode, so only the classical mode needs to be
>>> adjusted. However, gre also has a special case that expects the MAC
>>> header pointer to keep pointing to the outer header even after
>>> decapsulation. Therefore, patch 4 keeps an exception for this case.
>>>
>>> Ideally, we'd centralise the call to skb_reset_mac_header() in
>>> ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
>>> sit (patch 3) and gre (patch 4). That's unfortunately not feasible
>>> currently, because of the gre special case discussed above that
>>> precludes us from resetting the MAC header unconditionally.
>>
>> What about adding a flag to ip_tunnel indicating if it can be done (or
>> should not be done since doing it is the most common)?
> 
> That's feasible. I didn't do it here because I wanted to keep the
> patch series focused on L3 tunnels. Modifying ip_tunnel_rcv()'s
> prototype would also require updating erspan_rcv(), which isn't L3
> (erspan carries Ethernet frames). I was feeling such consolidation
> would be best done in a follow up patch series.

I was thinking a flag in 'struct ip_tunnel'. It's the private data for
those netdevices, so a per-instance setting. I haven't walked through
the details to know if it would work.

> 
> I can repost if you feel strongly about it. Otherwise, I'll follow up
> with the ip_tunnel_rcv() consolidation in a later patch. Just let me
> know if you have any preference.
> 
>>> The original motivation is to redirect bareudp packets to Ethernet
>>> devices (as described in patch 1). The rest of this series aims at
>>> bringing consistency across all L3 devices (apart from gre's special
>>> case unfortunately).
>>
>> Can you add a selftests that covers the use cases you mention in the
>> commit logs?
> 
> I'm already having a selftests for most of the tunnels (and their
> different operating modes), gtp being the main exception. But it's not
> yet ready for upstream, as I'm trying to move the topology in its own
> .sh file, to keep the main selftests as simple as possible.
> I'll post it as soon as I get it in good shape.
> 

That works. Thanks,
