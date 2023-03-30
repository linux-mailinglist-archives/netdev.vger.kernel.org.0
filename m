Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851956D0DA3
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjC3SVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjC3SVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:21:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573E5E3BD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:21:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r7-20020a17090b050700b002404be7920aso18855023pjz.5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680200489; x=1682792489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EmhR4anghqZGoCOevF8yuxVNULblji1dtiyg7861Vnk=;
        b=dZUSCV6o1r/jOdXT11zreXGp8BeeaUq70jyTWMFkF3rjAL7EhI7drsEGDHcqXQ8DZt
         PwezLvlZ379leau4cd1ZJRJFcdI1JxuJVBOW7QQQ7ojEOwPsRV3CF5CXbsQ01UZbcK8Z
         Yc83GLR9/KzO6gL0kJ7ae6rmp5Qr/6p+ewv07JnHTbMURpgucpKxnEyZZYRyWwe+5yOm
         aYkUuVBmhCy97zzpJWocLrw0hBcW9Bq4AwiejtlnMKAFFuOJuFOqVLHKwvqcc3nuJzDL
         jvIIjWeBqjMOaiZu2qbcmK7oPwf6KZl+ejq8jAgyBODMiYekMmH3wwjigvwY+9Jg7qh3
         Rm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200489; x=1682792489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EmhR4anghqZGoCOevF8yuxVNULblji1dtiyg7861Vnk=;
        b=PHwJJO0pn6Ppdnj5XkunxH5D7ghdOYUz5sirg8jU6AdZlEkQJ0NfW5wz/MLI0AHayJ
         yaNUNAhmvXozyDb7U2qUfS5mMNw4UZNw6adNXL7GoLeDhuxvH2gax0mlVB5zIXOgQYzw
         14AN+N73u26ntSnWhaZXduCmG+A5UmwewyMfGe1b+/kXpTzkUy77RM0fBzdGj0yc8pjv
         HtIQw6VaFtt5RHlMFX5C8nmpzAyA1duqLnVwGhhEvMY80mtwIlSmjx+LhLFG9htiDjRt
         shfS02G84l+gXR6ToCJAW6T79NrTLqxSjvJX3EVsIiQQSqCI2ztoWMX27UlL0/twvKCm
         LNqw==
X-Gm-Message-State: AAQBX9db7alNHnLzBA80RO2QLhccX064sHkfDIy8U/LXu3ywgbJMjVSM
        VJshgos3MagI6lAQo0c989o=
X-Google-Smtp-Source: AKy350Za5aucRym6E13R0+i5Dkjz6klPKXGmY3Lmi0qbHf7UQlC9bOIv+b0O8ii8v1aGERKnXIwrJw==
X-Received: by 2002:a17:902:db05:b0:19f:2dff:21a2 with SMTP id m5-20020a170902db0500b0019f2dff21a2mr27958405plx.64.1680200488680;
        Thu, 30 Mar 2023 11:21:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g15-20020a170902868f00b0019b0afc24e8sm20529plo.250.2023.03.30.11.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 11:21:28 -0700 (PDT)
Message-ID: <322b52f6-3f01-a924-d2dd-2003ed13989e@gmail.com>
Date:   Thu, 30 Mar 2023 11:21:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: dsa: sync unicast and multicast addresses for
 VLAN filters too
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Ido Schimmel <idosch@nvidia.com>
References: <20230329151821.745752-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230329151821.745752-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 08:18, Vladimir Oltean wrote:
> If certain conditions are met, DSA can install all necessary MAC
> addresses on the CPU ports as FDB entries and disable flooding towards
> the CPU (we call this RX filtering).
> 
> There is one corner case where this does not work.
> 
> ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> ip link set swp0 master br0 && ip link set swp0 up
> ip link add link swp0 name swp0.100 type vlan id 100
> ip link set swp0.100 up && ip addr add 192.168.100.1/24 dev swp0.100
> 
> Traffic through swp0.100 is broken, because the bridge turns on VLAN
> filtering in the swp0 port (causing RX packets to be classified to the
> FDB database corresponding to the VID from their 802.1Q header), and
> although the 8021q module does call dev_uc_add() towards the real
> device, that API is VLAN-unaware, so it only contains the MAC address,
> not the VID; and DSA's current implementation of ndo_set_rx_mode() is
> only for VID 0 (corresponding to FDB entries which are installed in an
> FDB database which is only hit when the port is VLAN-unaware).
> 
> It's interesting to understand why the bridge does not turn on
> IFF_PROMISC for its swp0 bridge port, and it may appear at first glance
> that this is a regression caused by the logic in commit 2796d0c648c9
> ("bridge: Automatically manage port promiscuous mode."). After all,
> a bridge port needs to have IFF_PROMISC by its very nature - it needs to
> receive and forward frames with a MAC DA different from the bridge
> ports' MAC addresses.
> 
> While that may be true, when the bridge is VLAN-aware *and* it has a
> single port, there is no real reason to enable promiscuity even if that
> is an automatic port, with flooding and learning (there is nowhere for
> packets to go except to the BR_FDB_LOCAL entries), and this is how the
> corner case appears. Adding a second automatic interface to the bridge
> would make swp0 promisc as well, and would mask the corner case.
> 
> Given the dev_uc_add() / ndo_set_rx_mode() API is what it is (it doesn't
> pass a VLAN ID), the only way to address that problem is to install host
> FDB entries for the cartesian product of RX filtering MAC addresses and
> VLAN RX filters.
> 
> Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

