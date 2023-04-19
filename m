Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70B46E79C7
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDSMak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjDSMaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:30:35 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A15E44
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:30:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sz19so24161812ejc.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1681907411; x=1684499411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avqNslnB4KohY2YwvfuPOO2n1lMtgBQmzRxlc74gZbM=;
        b=3yjuxArVmI5nyCoyJTDePB0cVEtEM++DI8nVuePKhdy1/WOQha+f+sFpnpHAgeA/cl
         alU672tyBuIVWDO7VkC++qB4zQcNYvwDdotIHoPO7I7zJe4+VWrS1n5etxbjS9DjqEc/
         q98DFJK2bD2GW+Rk8Kulf8uEU+prtBEnYhfcDe+zQ96RdhixRRwqbirj2rgpbAQ5tYsm
         OIJGGtKi8pdD20iqJ1oP9Xw9GTsikAY1BOC79SCxoisBGGP4iVzrP9Kav7tX+4KcinfA
         f70joN+3jGmdFemC3Ev2ZGfi1N5NjKUbQok6YGCIdiHMV5uxcf0WoV8BdMXib8uwBKKg
         +Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681907411; x=1684499411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avqNslnB4KohY2YwvfuPOO2n1lMtgBQmzRxlc74gZbM=;
        b=IuhRmn+4oc+zcFYfB0HenCKdz1WCoyK9/aIClgj8Pcsg8Ni5C4keFNkiXixmck3EbP
         LmcNRXGS4JkuF+7HQaip+g0coWyU4/R2dQOcVkvTNjaT9tdUKPWC2VU0FWfZbVZILXI1
         npuumk/56LhT5Yg2pOX4wk5kteXZMpzZgFmEFbDzdBCHQc5FTpi6gD02cXL3Cxmm4mgx
         3bGmvlnqz7XTr9iNr9RmlNdkU+ItGvSuRIGVNbAfeWhGlUdaIyypNDjF25ZgIXtHVFUS
         O/H8HYNlWhvnE9kob4sHa919nwBNCMMvIDI4Ff6THQYtq1IY/2JXD/StqVdmQBwn2d2I
         tOaA==
X-Gm-Message-State: AAQBX9d+4WTrvBnLmxJMWZjSdRtFtMdIo2yk+Vfz3fq84eVuIVT5hAGY
        QFYKGRvENeHMiHyxNZHyX2WZMw==
X-Google-Smtp-Source: AKy350bZNbwe0z00tAsXhj8W1ZPY/I+8QRfEW5wXUnH2LbVAQiU8ZADoB+3/Jhpx7yvVyN4hjlw9Lg==
X-Received: by 2002:a17:906:b197:b0:94f:788:6bc with SMTP id w23-20020a170906b19700b0094f078806bcmr14249974ejy.37.1681907410733;
        Wed, 19 Apr 2023 05:30:10 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id x2-20020a1709064a8200b0094f49f58019sm5200046eju.27.2023.04.19.05.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 05:30:09 -0700 (PDT)
Message-ID: <95a773f6-5f88-712e-c494-9414d7090144@blackwall.org>
Date:   Wed, 19 Apr 2023 15:30:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next 0/9] bridge: Add per-{Port, VLAN} neighbor
 suppression
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230413095830.2182382-1-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2023 12:58, Ido Schimmel wrote:
> Background
> ==========
> 
> In order to minimize the flooding of ARP and ND messages in the VXLAN
> network, EVPN includes provisions [1] that allow participating VTEPs to
> suppress such messages in case they know the MAC-IP binding and can
> reply on behalf of the remote host. In Linux, the above is implemented
> in the bridge driver using a per-port option called "neigh_suppress"
> that was added in kernel version 4.15 [2].
> 
> Motivation
> ==========
> 
> Some applications use ARP messages as keepalives between the application
> nodes in the network. This works perfectly well when two nodes are
> connected to the same VTEP. When a node goes down it will stop
> responding to ARP requests and the other node will notice it
> immediately.
> 
> However, when the two nodes are connected to different VTEPs and
> neighbor suppression is enabled, the local VTEP will reply to ARP
> requests even after the remote node went down, until certain timers
> expire and the EVPN control plane decides to withdraw the MAC/IP
> Advertisement route for the address. Therefore, some users would like to
> be able to disable neighbor suppression on VLANs where such applications
> reside and keep it enabled on the rest.
> 
> Implementation
> ==============
> 
> The proposed solution is to allow user space to control neighbor
> suppression on a per-{Port, VLAN} basis, in a similar fashion to other
> per-port options that gained per-{Port, VLAN} counterparts such as
> "mcast_router". This allows users to benefit from the operational
> simplicity and scalability associated with shared VXLAN devices (i.e.,
> external / collect-metadata mode), while still allowing for per-VLAN/VNI
> neighbor suppression control.
> 
> The user interface is extended with a new "neigh_vlan_suppress" bridge
> port option that allows user space to enable per-{Port, VLAN} neighbor
> suppression on the bridge port. When enabled, the existing
> "neigh_suppress" option has no effect and neighbor suppression is
> controlled using a new "neigh_suppress" VLAN option. Example usage:
> 
>  # bridge link set dev vxlan0 neigh_vlan_suppress on
>  # bridge vlan add vid 10 dev vxlan0
>  # bridge vlan set vid 10 dev vxlan0 neigh_suppress on
> 
> Testing
> =======
> 
> Tested using existing bridge selftests. Added a dedicated selftest in
> the last patch.
> 
> Patchset overview
> =================
> 
> Patches #1-#5 are preparations.
> 
> Patch #6 adds per-{Port, VLAN} neighbor suppression support to the
> bridge's data path.
> 
> Patches #7-#8 add the required netlink attributes to enable the feature.
> 
> Patch #9 adds a selftest.
> 
> iproute2 patches can be found here [3].
> 
> [1] https://www.rfc-editor.org/rfc/rfc7432#section-10
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a42317785c898c0ed46db45a33b0cc71b671bf29
> [3] https://github.com/idosch/iproute2/tree/submit/neigh_suppress_v1
> 
> Ido Schimmel (9):
>   bridge: Reorder neighbor suppression check when flooding
>   bridge: Pass VLAN ID to br_flood()
>   bridge: Add internal flags for per-{Port, VLAN} neighbor suppression
>   bridge: Take per-{Port, VLAN} neighbor suppression into account
>   bridge: Encapsulate data path neighbor suppression logic
>   bridge: Add per-{Port, VLAN} neighbor suppression data path support
>   bridge: vlan: Allow setting VLAN neighbor suppression state
>   bridge: Allow setting per-{Port, VLAN} neighbor suppression state
>   selftests: net: Add bridge neighbor suppression test
> 
>  include/linux/if_bridge.h                     |   1 +
>  include/uapi/linux/if_bridge.h                |   1 +
>  include/uapi/linux/if_link.h                  |   1 +
>  net/bridge/br_arp_nd_proxy.c                  |  33 +-
>  net/bridge/br_device.c                        |   8 +-
>  net/bridge/br_forward.c                       |   8 +-
>  net/bridge/br_if.c                            |   2 +-
>  net/bridge/br_input.c                         |   2 +-
>  net/bridge/br_netlink.c                       |   8 +-
>  net/bridge/br_private.h                       |   5 +-
>  net/bridge/br_vlan.c                          |   1 +
>  net/bridge/br_vlan_options.c                  |  20 +-
>  net/core/rtnetlink.c                          |   2 +-
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../net/test_bridge_neigh_suppress.sh         | 862 ++++++++++++++++++
>  15 files changed, 936 insertions(+), 19 deletions(-)
>  create mode 100755 tools/testing/selftests/net/test_bridge_neigh_suppress.sh
> 

The set looks good to me, nicely split and pretty straight-forward.
For the set:
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


