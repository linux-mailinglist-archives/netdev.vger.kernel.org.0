Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1117585B4E
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiG3QsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiG3QsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:48:24 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8401114029;
        Sat, 30 Jul 2022 09:48:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p22so8132457lji.10;
        Sat, 30 Jul 2022 09:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lx39+48xs+QrEXdefGJWcbwB1k+hspd/NoATXGR9qyI=;
        b=fQs7W0idr3E+3WnRUded1LPamtZKuryRCbirEjzF53u4oNcwPnOdogFKZgwQ7qg6NG
         08QY1rjL0vxaz8VFy8CE02TvEcivR5iGGhpmWfSbsMaMbn0tHA0r/I0vRBPD7xbtpOeD
         m5vnXXrVFqdh2PhurvMneZKfdWKmpWQOzyj1WyHsKTW0sD2J418llMShs9bed0+AAKDY
         +UvBwo8knJjVWV37oijcua2rUkNyn2oH1yPaQ71142PJFx1gxdi6isXJ39btgaZNmalb
         ukdU/sqkwznO5Z6rYrXmFFYFqQgMxPxXI4ROSU7T1bogsUAWtIzQeEAJk5pciUyWs9po
         P2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lx39+48xs+QrEXdefGJWcbwB1k+hspd/NoATXGR9qyI=;
        b=r1MoKKQrduKCcC8LkeQdouTs+WcqV6wZ3iw7AiuYJPim6rT8WrOSbhs1w/M4vK95oX
         eKp2Z4+6RN1sLM1BQ1g59M77eX3QecB4cUMShbgx4dGnjmCjz51Qr53aJ6xoczn0dWUg
         df+zl2NRN5cOywvzn8xQ//WNc3HJu0b/guK99jcnNaIic6FOgEi+ssnGsj9BqbsDO4At
         MLc9NrlyNEiooUBRSIfWRNRHy8m46gtXR2sMwgA1/BXmoKXnj+K6iJeZceP2UHSMe/ih
         dBhe5j6SsJI7WDD+UibGtDfqu8S+eInC1a3qMSau7/FsOC5k2h5SPRTNFVTjR6ApAx6s
         PlJw==
X-Gm-Message-State: AJIora+3BZVZmjOicNz/t2Uc+g96LxasR8m0NeW6gUhryU3tRdavuZ6j
        95zkmV+5+BTcj0sQJFPYZABpVxd0tm3Wozq/fNs=
X-Google-Smtp-Source: AGRyM1uxJfWKpElfwIL6riCm9sX5RNmGf0gGkj8UNsfyjTrNaQPaLedh+OzCpZA1RpZyiMSWISzNy0MexrEgDqGW3FM=
X-Received: by 2002:a05:651c:b23:b0:25e:e2d:9e40 with SMTP id
 b35-20020a05651c0b2300b0025e0e2d9e40mr2917219ljr.38.1659199700406; Sat, 30
 Jul 2022 09:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
 <f7ede054-f0b3-558a-091f-04b4f7139564@blackwall.org> <CAMWRUK5j4UAwjw4UGN=SVbbDbut0zWg5e03wupAXCPwT8K8zzQ@mail.gmail.com>
In-Reply-To: <CAMWRUK5j4UAwjw4UGN=SVbbDbut0zWg5e03wupAXCPwT8K8zzQ@mail.gmail.com>
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Date:   Sat, 30 Jul 2022 12:48:08 -0400
Message-ID: <CAMWRUK5TZ5iZWZJO7Bbn-b43ZbT7mRzUDr4LdseLCne8qvG6pw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: vlan: fix bridge binding behavior and
 add selftests
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Resending this because the first email was rejected due to being in HTML.)


On Sat, Jul 30, 2022 at 12:46 PM Sevinj Aghayeva
<sevinj.aghayeva@gmail.com> wrote:
>
>
>
> On Sat, Jul 30, 2022 at 12:22 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>> On 7/30/22 19:03, Sevinj Aghayeva wrote:
>> > When bridge binding is enabled for a vlan interface, it is expected
>> > that the link state of the vlan interface will track the subset of the
>> > ports that are also members of the corresponding vlan, rather than
>> > that of all ports.
>> >
>> > Currently, this feature works as expected when a vlan interface is
>> > created with bridge binding enabled:
>> >
>> >    ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>> >          bridge_binding on
>> >
>> > However, the feature does not work when a vlan interface is created
>> > with bridge binding disabled, and then enabled later:
>> >
>> >    ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>> >          bridge_binding off
>> >    ip link set vlan10 type vlan bridge_binding on
>> >
>> > After these two commands, the link state of the vlan interface
>> > continues to track that of all ports, which is inconsistent and
>> > confusing to users. This series fixes this bug and introduces two
>> > tests for the valid behavior.
>> >
>> > Sevinj Aghayeva (3):
>> >    net: bridge: export br_vlan_upper_change
>> >    net: 8021q: fix bridge binding behavior for vlan interfaces
>> >    selftests: net: tests for bridge binding behavior
>> >
>> >   include/linux/if_bridge.h                     |   9 ++
>> >   net/8021q/vlan.h                              |   2 +-
>> >   net/8021q/vlan_dev.c                          |  21 ++-
>> >   net/bridge/br_vlan.c                          |   7 +-
>> >   tools/testing/selftests/net/Makefile          |   1 +
>> >   .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>> >   6 files changed, 176 insertions(+), 7 deletions(-)
>> >   create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
>> >
>>
>> Hmm.. I don't like this and don't think this bridge function should be
>> exported at all.
>>
>> Calling bridge state changing functions from 8021q module is not the
>> proper way to solve this. The problem is that the bridge doesn't know
>> that the state has changed, so you can process NETDEV_CHANGE events and
>> check for the bridge vlan which got its state changed and react based on
>> it. I haven't checked in detail, but I think it should be doable. So all
>> the logic is kept inside the bridge.
>
>
> Hi Nik,
>
> Can please elaborate on where I should process NETDEV_CHANGE events? I'm doing this as part of outreachy project and this is my first kernel task, so I don't know the bridging code that well.
>
> Thanks!
>
>>
>>
>> Cheers,
>>   Nik
>
>
>
> --
>
> Sevinj.Aghayeva



-- 

Sevinj.Aghayeva
