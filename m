Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C1D58E917
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiHJIy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiHJIyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:54:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5867F6E2FE
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:54:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso639518wmq.3
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=OxCbcCWGfon4bvlq9gWd6W8FYVADnZR0/olFVEKpB04=;
        b=lJGO5Vxidp/ZjUm/SaGCGiFCBGj5kSEZm8zQT0epBTT1vBvjDBVON472HQ2jlRB7P8
         zNzScp6uwd7StEBcbixPUFMEUFO42l0/k6u2FvdefI7AVw35XAIhWS2sD5FCeUJWXa6j
         rXO9E/TODHxyWj7urvnBizUcYcOoKtsdvRo9WSdoprqPF9ZPbdM7qA7y6a+ulHRkXN8S
         ykbhEZUkA+4O8yWNk8ZSDzE6Do7n+nYV0UnM7qvB8OFzw02CilTrMRZyadjOuRsSBBls
         P1ruKkNrHCbDezvKV7H1A+vHiJ46ioxYvvuZtqd/l3q9xXA9+7Tp7qgRdxPa+raz8X1g
         r9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OxCbcCWGfon4bvlq9gWd6W8FYVADnZR0/olFVEKpB04=;
        b=aSi2oRp6+P5RmFLuffRk/OYzYVLDGxKiW89JLWmCWyRF9QCpvM1pA0YpPI9pvO4BjO
         OGUfv2YTKCfObI9Gh7m4xsG3yTB84+R0QIc/36k/ixR4fT91pr7sRdlH11Mi/OXZi8l2
         EWTEUOFBqVBgDpIMD4E7FPOxeE2nvgyIqXpNkdZhFfgk1zcFL5GH/TOVZAZyVkN2Ec6U
         5tfMp3rYI+txLQ6X/zPXiEiA5QcN/M9Snd3ftTNOOCI0xa/dUbqABFtnFa4D6t1OHb2s
         e1RRCr5jTM2XYlCDtKA+GYfPlRdl+mfWEXvnPEcUxC3gqa6EwBPWIT01HF45EFmo8CTv
         jmWw==
X-Gm-Message-State: ACgBeo3UVgOtfY7AsO1mqYDdyQtht4DCCwro9tgGQ/kuWgzIo5QMT8mH
        qyzLIfPKpbDXlfjU21nrfNlCMuNrhmoTKXm4
X-Google-Smtp-Source: AA6agR57vle/oX1Qxyyj3wAZXXMuDCFMj1bScTi5b4IUuxVBxafpO7JkfdKPBQO+EFTHfxbAmzQLug==
X-Received: by 2002:a05:600c:4fcf:b0:3a3:40f6:4c4d with SMTP id o15-20020a05600c4fcf00b003a340f64c4dmr1587491wmq.60.1660121661833;
        Wed, 10 Aug 2022 01:54:21 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c358d00b003a4c6e67f01sm1607396wmq.6.2022.08.10.01.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 01:54:21 -0700 (PDT)
Message-ID: <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
Date:   Wed, 10 Aug 2022 11:54:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>, netdev@vger.kernel.org
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2022 06:11, Sevinj Aghayeva wrote:
> When bridge binding is enabled for a vlan interface, it is expected
> that the link state of the vlan interface will track the subset of the
> ports that are also members of the corresponding vlan, rather than
> that of all ports.
> 
> Currently, this feature works as expected when a vlan interface is
> created with bridge binding enabled:
> 
>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>         bridge_binding on
> 
> However, the feature does not work when a vlan interface is created
> with bridge binding disabled, and then enabled later:
> 
>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>         bridge_binding off
>   ip link set vlan10 type vlan bridge_binding on
> 
> After these two commands, the link state of the vlan interface
> continues to track that of all ports, which is inconsistent and
> confusing to users. This series fixes this bug and introduces two
> tests for the valid behavior.
> 
> Sevinj Aghayeva (3):
>   net: core: export call_netdevice_notifiers_info
>   net: 8021q: fix bridge binding behavior for vlan interfaces
>   selftests: net: tests for bridge binding behavior
> 
>  include/linux/netdevice.h                     |   2 +
>  net/8021q/vlan.h                              |   2 +-
>  net/8021q/vlan_dev.c                          |  25 ++-
>  net/core/dev.c                                |   7 +-
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>  6 files changed, 172 insertions(+), 8 deletions(-)
>  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> 

Hi,
NETDEV_CHANGE event is already propagated when the vlan changes flags, 
NETDEV_CHANGEUPPER is used when the devices' relationship changes not their flags.
The only problem you have to figure out is that the flag has changed. The fix itself
must be done within the bridge, not 8021q. You can figure it out based on current bridge
loose binding state and the vlan's changed state, again in the bridge's NETDEV_CHANGE
handler. Unfortunately the proper fix is much more involved and will need new
infra, you'll have to track the loose binding vlans in the bridge. To do that you should
add logic that reflects the current vlans' loose binding state *only* for vlans that also
exist in the bridge, the rest which are upper should be carrier off if they have the loose
binding flag set.

Alternatively you can add a new NETDEV_ notifier (using something similar to struct netdev_notifier_pre_changeaddr_info)
and add link type-specific space (e.g. union of link type-specific structs) in the struct which will contain
what changed for 8021q and will be properly interpreted by the bridge. The downside is that we'll generate
2 notifications when changing the loose binding flag, but on the bright side won't have to track anything
in the bridge, just handle the new notifier type. This might be the easiest path, the fix is still in
the bridge though, the 8021q module just needs to fill in the new struct and emit the notification on
any loose binding changes, the bridge must decide if it should process it (i.e. based on upper/lower
relationship). Such notifier can be also re-used by other link types to propagate link-type specific
changes.

Both of these avoid any direct dependencies between the bridge and 8021q. Any other suggestions that
are simpler, avoid direct dependencies and solve the issue in a generic way would be appreciated.

Just be careful about introducing too much unnecessary processing because we
can have lots of vlan devices in a system.

Cheers,
 Nik
