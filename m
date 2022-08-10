Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A42058EF01
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiHJPKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiHJPKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:10:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35D9F5A3
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 08:10:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb36so28220676ejc.10
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 08:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=QvWgi4bapgJrNQFkQQ/ZI8kSbG7GnXbksaof+b0rmLc=;
        b=kDqaOrUd0p917w2v+d7X2KGqQbhozVosVzex2g0KecOPP4HWnCyfpVycR36/m83PkC
         r/hVZZMqfEpfB7mKxkEPtcyPiqS1KgwmZdOduWmZgbmbXoFP0xMdRxrP2+IRLOL+gj+G
         a/bob2EBbCfku/BjYYbmzh4nD1gUsYEhfM6st88Co6+JheB1J5myX7YsP+kxmieOtbH0
         uXjeJ34pA12v4Ap3fRnc/M+VHnE8FQTkIIw+3vQwguJFVxBiSvfTZpJFZ3r48T8VlXhr
         UxMW5Kw+ZDGmbp9LSMUOBGDLTLxf/D6w/gHE1XFb728KVwkDCNQ2f5LasZ+e5dPa9vZi
         acow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QvWgi4bapgJrNQFkQQ/ZI8kSbG7GnXbksaof+b0rmLc=;
        b=zWyqgzAR2e5SCriCzR/ojQlHQP6R7WKnM6ScASmU3xZFr6c93VkfYaIE8R3mlmsCYM
         mukDcX6+gpRZ8TRdXLQk5vi/DDei5Qmre+s7xG9FaGb+0VCxQwoeb7Pa0BptxFiBBCEU
         2p7XjLv0zgJ/A5Yp+t8Klw01HVXv9WyLdr4tvdYtOMuQDOMTzEw+qklpW+AA0OTC0tuR
         hr7ybMw3DuXPTgNDpg/lVcxrZrgLPnJ/xenxKe0d/kUqVOhU6ONotZv5/eai0NnkUgRR
         9yuJnNtbtemAGvMy8Sk4ywkiSuTJtup79cWfkk0Y/PRdkWUpzOBWADZa865hDqE3Dhy+
         A2Yw==
X-Gm-Message-State: ACgBeo3+vbHTxwFX/gItWMRJrepSyEEzWNZ5xNft656+aQKMU/IjlOUZ
        bkn18S9Qupg5VLOfYuzOWr+H8A==
X-Google-Smtp-Source: AA6agR6Aze/QbsmhHuigbbQINd3adGnoFr4Q79ghohdECe7s8FeuljsSPzsyr2Iapj6rrFDG5/vvkA==
X-Received: by 2002:a17:907:8687:b0:730:7c7b:b9ce with SMTP id qa7-20020a170907868700b007307c7bb9cemr20093525ejc.656.1660144242092;
        Wed, 10 Aug 2022 08:10:42 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ku19-20020a170907789300b00730b5a35288sm2368814ejc.214.2022.08.10.08.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 08:10:41 -0700 (PDT)
Message-ID: <74b69521-0d40-5e2f-4d1b-76e9697d7471@blackwall.org>
Date:   Wed, 10 Aug 2022 18:10:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Cc:     netdev@vger.kernel.org, aroulin@nvidia.com, sbrivio@redhat.com,
        roopa@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
 <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
 <CAMWRUK45nbZS3PeSLR1X=Ko6oavrjKj2AWeh2F1wckMPrz_dEg@mail.gmail.com>
 <49f933c3-7430-a133-9add-ed76c395023b@blackwall.org>
 <CAMWRUK4J6Dp7Cff=pN9iw6OwDN8g61dd4S=OVKQ75vBch-PxXQ@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAMWRUK4J6Dp7Cff=pN9iw6OwDN8g61dd4S=OVKQ75vBch-PxXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2022 18:00, Sevinj Aghayeva wrote:
> On Wed, Aug 10, 2022 at 10:50 AM Nikolay Aleksandrov
> <razor@blackwall.org> wrote:
>>
>> On 10/08/2022 17:42, Sevinj Aghayeva wrote:
>>>
>>>
>>> On Wed, Aug 10, 2022 at 4:54 AM Nikolay Aleksandrov <razor@blackwall.org <mailto:razor@blackwall.org>> wrote:
>>>
>>>     On 10/08/2022 06:11, Sevinj Aghayeva wrote:
>>>     > When bridge binding is enabled for a vlan interface, it is expected
>>>     > that the link state of the vlan interface will track the subset of the
>>>     > ports that are also members of the corresponding vlan, rather than
>>>     > that of all ports.
>>>     >
>>>     > Currently, this feature works as expected when a vlan interface is
>>>     > created with bridge binding enabled:
>>>     >
>>>     >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>>>     >         bridge_binding on
>>>     >
>>>     > However, the feature does not work when a vlan interface is created
>>>     > with bridge binding disabled, and then enabled later:
>>>     >
>>>     >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>>>     >         bridge_binding off
>>>     >   ip link set vlan10 type vlan bridge_binding on
>>>     >
>>>     > After these two commands, the link state of the vlan interface
>>>     > continues to track that of all ports, which is inconsistent and
>>>     > confusing to users. This series fixes this bug and introduces two
>>>     > tests for the valid behavior.
>>>     >
>>>     > Sevinj Aghayeva (3):
>>>     >   net: core: export call_netdevice_notifiers_info
>>>     >   net: 8021q: fix bridge binding behavior for vlan interfaces
>>>     >   selftests: net: tests for bridge binding behavior
>>>     >
>>>     >  include/linux/netdevice.h                     |   2 +
>>>     >  net/8021q/vlan.h                              |   2 +-
>>>     >  net/8021q/vlan_dev.c                          |  25 ++-
>>>     >  net/core/dev.c                                |   7 +-
>>>     >  tools/testing/selftests/net/Makefile          |   1 +
>>>     >  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>>>     >  6 files changed, 172 insertions(+), 8 deletions(-)
>>>     >  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
>>>     >
>>>
>>>     Hi,
>>>     NETDEV_CHANGE event is already propagated when the vlan changes flags,
>>>
>>>
>>> I'm not sure if NETDEV_CHANGE is actually propagated when the vlan changes flags. The two functions in the bridge module that handle NETDEV_CHANGE are br_vlan_port_event  and br_vlan_bridge_event. I've installed probes for both, and when I'm changing flags using "sudo ip link set vlan10 type vlan bridge_binding on", I don't see any of those functions getting called, although I do see vlan_dev_change_flags getting called. I think there may be a bug in core/dev.c:__dev_notify_flags.
>>
>> are both vlan and bridge interfaces up?
>> what exactly are you probing for?
> 
> 
> I first run the attached pre.sh script that sets up the environment
> and creates a vlan interface with bridge binding off. I then start
> recording with perf, and here's the list of probes:
> 
> $ sudo ./k/linux/tools/perf/perf probe -l
>   probe:br_vlan_bridge_event (on br_vlan_bridge_event in bridge with event dev)
>   probe:br_vlan_port_event (on br_vlan_port_event in bridge with event)
>   probe:br_vlan_set_vlan_dev_state (on br_vlan_set_vlan_dev_state in
> bridge with br vlan_dev)
>   probe:register_vlan_dev (on register_vlan_dev in 8021q with dev)
>   probe:vlan_changelink (on vlan_changelink in 8021q with dev)
>   probe:vlan_dev_change_flags (on vlan_dev_change_flags in 8021q with dev)
>   probe:vlan_dev_fix_features (on vlan_dev_fix_features in 8021q with dev)
>   probe:vlan_dev_init  (on vlan_dev_init in 8021q with dev)
>   probe:vlan_dev_ioctl (on vlan_dev_ioctl in 8021q with dev)
>   probe:vlan_dev_open  (on vlan_dev_open in 8021q with dev)
>   probe:vlan_dev_stop  (on vlan_dev_stop in 8021q with dev)
>   probe:vlan_dev_uninit (on vlan_dev_uninit in 8021q with dev)
>   probe:vlan_newlink   (on vlan_newlink in 8021q with dev)
> 
> I then run the following command to turn the bridge binding flag on:
> 
> $ sudo ip link set vlan10 type vlan bridge_binding on
> 
> Then I stop the recording and print out the events, and I see this. I
> don't see br_vlan_port_event or br_vlan_bridge_event getting called.
> 
>               ip  5933 [003]  2204.722470:
> probe:vlan_changelink: (ffffffffc1042b50) dev="vlan10"
>               ip  5933 [003]  2204.722476:
> probe:vlan_dev_change_flags: (ffffffffc1042600) dev="vlan10"
> 
> Am I doing something wrong?
> 
> Thanks
> 
> 

You can't expect to see br_vlan_bridge_event() called because the notification
target device is vlan10 and not the bridge. See br_device_event():
...
        if (netif_is_bridge_master(dev)) {
                err = br_vlan_bridge_event(dev, event, ptr);
                if (err)
                        return notifier_from_errno(err);
...


Try probing for br_device_event(), you'll see it gets called every time you change the flag.

