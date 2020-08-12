Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC001242F16
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 21:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHLTVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 15:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 15:21:35 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E45C061384
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 12:21:34 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id o22so2378392qtt.13
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 12:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EX2g5+euAQRCB4RYYAUj/dWVDZn6Q8OxAlsFAO5U+nE=;
        b=dlYt6aUaZ8b+DgWKUGi6IbBDO63y+c49vfv3P9J+JOF7sjHRYKbXNUhnnt8cwRaugG
         x/lCJ9Y0BuZWTeExKUnM2YwFn57lFgaAl2ZtwJaSgOy0Ypj19Phxvstfb4XB+hEFWO5e
         QGZfOnHdgWXkIi1j3yEBl55ztlH7+ESfXGJOhDHA87cRKlqBtqREaf0gpEgCmfgT9hOm
         LFyrpAE7ipwYVquJjPwMIFqgc25WW386N7wbb3HPTpvXZlWH9MY+ViAuRcqGe3+7KD3A
         I1Z/zNoxCxMBZ5v1j7F4XLCgVTw8MD3TX+ha4orzbXyqwuE7Jje0fxY7zFNma3vSXvN9
         VXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EX2g5+euAQRCB4RYYAUj/dWVDZn6Q8OxAlsFAO5U+nE=;
        b=NF6NAehgXmXKWIza3O6WI0FAb6r8K1vVHcwe29j3pbVpnlh2zgKM5qEll6djOnCTEA
         ErE9UvQNUd9bwwr+ktrGe4xchmtmJCqFy9ge64/uM9fKX3/1sXTTWyJzJJmvsjB35EVf
         cvqwnIM2T9lda0tkfuajfNHp7Mpb9SnbW9nMYIms8OldljCS9gSoK8Ak+6hPzZ/cSWqE
         hCmoWdM6PEtzRKzjIxl6YuABQ8d310nVFK01Xysgom4Ldo85CaNwc0DV/FKwimTRKYbi
         Suo3qEMkSqXpH6lW8TaVPbRUUdk1CelJ8IRT9QOYJmoyH7zuwKoLx464E7KmnoNSUYzK
         gvgg==
X-Gm-Message-State: AOAM532ruvpEKVfHG3n8jS/NrruMKNtrqwvK5hYml5I4GtgAJke+wVzg
        AmSdKtECF1tYpL0/9kfGOH1xtEc0
X-Google-Smtp-Source: ABdhPJyxAp06xHUeok3GNyQX1mkUsDiqAUSpx46gnm+osgMbN1Vj8V7v5Xqu247z77T6InPncNMb7Q==
X-Received: by 2002:ac8:6bc2:: with SMTP id b2mr1302140qtt.115.1597260093603;
        Wed, 12 Aug 2020 12:21:33 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d42b:3b9:bea9:809f? ([2601:282:803:7700:d42b:3b9:bea9:809f])
        by smtp.googlemail.com with ESMTPSA id w32sm3230997qtw.66.2020.08.12.12.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 12:21:32 -0700 (PDT)
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     mastertheknife <mastertheknife@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
 <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
 <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com>
 <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com>
Date:   Wed, 12 Aug 2020 13:21:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/20 6:37 AM, mastertheknife wrote:
> Hello David,
> 
> I tried and it seems i can reproduce it:
> 
> # Create test NS
> root@host:~# ip netns add testns
> # Create veth pair, veth0 in host, veth1 in NS
> root@host:~# ip link add veth0 type veth peer name veth1
> root@host:~# ip link set veth1 netns testns
> # Configure veth1 (NS)
> root@host:~# ip netns exec testns ip addr add 192.168.252.209/24 dev veth1
> root@host:~# ip netns exec testns ip link set dev veth1 up
> root@host:~# ip netns exec testns ip route add default via 192.168.252.100
> root@host:~# ip netns exec testns ip route add 192.168.249.0/24
> nexthop via 192.168.252.250 nexthop via 192.168.252.252
> # Configure veth0 (host)
> root@host:~# brctl addif vmbr2 veth0

vmbr2's config is not defined.

ip li add vmbr2 type bridge
ip li set veth0 master vmbr2
ip link set veth0 up

anything else? e.g., address for vmbr2? What holds 192.168.252.250 and
192.168.252.252
