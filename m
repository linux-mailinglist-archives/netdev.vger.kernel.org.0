Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838EF2E31D7
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 17:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgL0QfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 11:35:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgL0QfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 11:35:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609086817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7NSx/3I+63skcNBEbrq++StMxm8p1E3C84lTyY7MYF8=;
        b=bsR1ujXOVQigVcm8ZK9Oll14DZqJ4KiEpxScb4Q5vTiJnP6Ib/rX4e67G5JAwKIeIdALnF
        LNGTeemYC/P/u2CEoxETgD6V/boYa3PJieY+XZ6IxVfGOUHXSN8wD+04Cy1dYYr0P4FwI+
        YMOxGSvXwhql1HMXHTmKHArxFi9uDRo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-439jmsQLMf2dyLNMXrHS0w-1; Sun, 27 Dec 2020 11:33:35 -0500
X-MC-Unique: 439jmsQLMf2dyLNMXrHS0w-1
Received: by mail-wm1-f70.google.com with SMTP id s130so5740347wme.0
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 08:33:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7NSx/3I+63skcNBEbrq++StMxm8p1E3C84lTyY7MYF8=;
        b=rfB5r8JOwqh6arR+yPp/gchlFH6hxybziea0P2e7GqsTyoIyfAkhP33GxmoIbo0p2J
         zpJClABDyumsdwNNaIaHx4vSlcPC5M2cgvitPnN0d6MVB9BQsbzujfBOH7cHtAbv+5pO
         Yk6Ji+jGMFjNxoqjmK8aeqwF7WGotPFyYtrm/FbfWTIjCZVozy02UP5yZIgZZZG4VZqr
         fcg/gKifTSV1hBbrXpUp3FhyoKC2DGL0aOMYKYqjXCi2rny7jDFpHdKJHTBhcdF3cxJE
         yq2GdoOSEeiJVRTAvdo7oBW7+r9Lqo6EMsP9Vpmu9whFL/2m26S+iJxPkQglD1Mm2PwP
         NJsw==
X-Gm-Message-State: AOAM532jCtKOXKmlHaKGZ/KgLvv/XMNq/U5n9KyMuEJnKMFTZsNmUHDj
        xseQRTHKDXTD3qKUWBhqd6i1Hl6THPAjAljV/xTO5oeadZ3PPEnayA5RQ4NO5rxGXirbasgBWhk
        lVn7W9cD7RHOotOK5
X-Received: by 2002:a7b:c1d7:: with SMTP id a23mr16812398wmj.62.1609086814649;
        Sun, 27 Dec 2020 08:33:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwX0U9cP4RE6AD3npmjcBr2SyJUC3ixGHs3vBfj0MgoRLht7lL9TU6qpaATKjFhEcxOc8fWsQ==
X-Received: by 2002:a7b:c1d7:: with SMTP id a23mr16812388wmj.62.1609086814534;
        Sun, 27 Dec 2020 08:33:34 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z6sm15120686wmi.15.2020.12.27.08.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 08:33:33 -0800 (PST)
Date:   Sun, 27 Dec 2020 17:33:31 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Subject: Re: [PATCH net 2/2] bareudp: Fix use of incorrect min_headroom size
Message-ID: <20201227163331.GB27369@linux.home>
References: <20201226171308.4226-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201226171308.4226-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 26, 2020 at 05:13:08PM +0000, Taehee Yoo wrote:
> In the bareudp6_xmit_skb(), it calculates min_headroom.
> At that point, it uses struct iphdr, but it's not correct.
> So panic could occur.
> The struct ipv6hdr should be used.
> 
> Test commands:
>     ip netns add A
>     ip netns add B
>     ip link add veth0 type veth peer name veth1
>     ip link set veth0 netns A

Missing "ip link set veth1 netns B", so the reproducer unfortunately
doesn't work.

BTW, you can also simplify the script by creating the veth devices
directly in the right netns:
  ip link add name veth0 netns A type veth peer name veth1 netns B

Apart from that,
Acked-by: Guillaume Nault <gnault@redhat.com>

And thanks a lot for the reproducers!

>     ip netns exec A ip link set veth0 up
>     ip netns exec A ip a a 2001:db8:0::1/64 dev veth0
>     ip netns exec B ip link set veth1 up
>     ip netns exec B ip a a 2001:db8:0::2/64 dev veth1
> 
>     for i in {10..1}
>     do
>             let A=$i-1
>             ip netns exec A ip link add bareudp$i type bareudp dstport $i \
> 		    ethertype 0x86dd
>             ip netns exec A ip link set bareudp$i up
>             ip netns exec A ip -6 a a 2001:db8:$i::1/64 dev bareudp$i
>             ip netns exec A ip -6 r a 2001:db8:$i::2 encap ip6 src \
> 		    2001:db8:$A::1 dst 2001:db8:$A::2 via 2001:db8:$i::2 \
> 		    dev bareudp$i
> 
>             ip netns exec B ip link add bareudp$i type bareudp dstport $i \
> 		    ethertype 0x86dd
>             ip netns exec B ip link set bareudp$i up
>             ip netns exec B ip -6 a a 2001:db8:$i::2/64 dev bareudp$i
>             ip netns exec B ip -6 r a 2001:db8:$i::1 encap ip6 src \
> 		    2001:db8:$A::2 dst 2001:db8:$A::1 via 2001:db8:$i::1 \
> 		    dev bareudp$i
>     done
>     ip netns exec A ping 2001:db8:7::2

