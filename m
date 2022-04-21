Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10C8509FEB
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385465AbiDUMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241750AbiDUMtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:49:00 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A275C31DF8;
        Thu, 21 Apr 2022 05:46:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 454FD5C018F;
        Thu, 21 Apr 2022 08:46:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 21 Apr 2022 08:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650545168; x=
        1650631568; bh=EF79PcQ0MfsAEfNLabjI/AemFrjtcYYPaqHYxL/eq64=; b=W
        6c359dwSyENwETz81qLRTB+g80cgYrKhSQaRHYo/3BB++4gIKnm9UU1yEj8odT5b
        oVzQNvkoz3fRUip+EysuW/Y3dFeYVzC9S0BHUZDIhP2qDNfeS/LoqYzK0RjPu1vC
        UjRNn24wlNroHQkMXIR95BDm7ezMJHYFuAmLepV5ZTuOUHOOS4RPD0xyvnIefiQe
        VLUeigMYt9xV6wUuDvS2Ybjin6lncjywzKGu8eANiApJTx6qD/SK4JzoQPsTaIld
        LK5ZM71wO72Vd7ll/oR6lMnhqV24vCsCRcjFA7NPKOAsLEfLuHL4Y/3qfpMPqLrK
        CibUCG6MDpJ2h72MvgJgw==
X-ME-Sender: <xms:D1JhYlbYfP5dYypUDbjqNuixwx-YemR40IyjR-PJQgRJsaCJuogy-Q>
    <xme:D1JhYsZ8w9DWjFdxLm8Vv_OEkThiMD6WY3i4Z2Hr5I5VGUujrmW3gocFeT-hf0Ifv
    3o2bE_CrGUgt_c>
X-ME-Received: <xmr:D1JhYn9cPjc0S9Vd2Pxa1CY9-hBDv023GQmKWeUAul_A_WBx-hXJHcaTsKDcj_47GiXfCAf7lLIK7JBdVRggI181Lq5idA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtddvgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejkefgieehvdfgieeufedtleekkeevueetfeelffeuvdelkeelfeeuledvgeeu
    teenucffohhmrghinhepghhithhlrggsrdgtohhmpdhtuhigsghuihhlugdrtghomhdpkh
    gvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:D1JhYjronjhA2r-aKcAKwYSmOqMPS_PWzqpWuK7g_a-Nrfdi3lMnAw>
    <xmx:D1JhYgrBCH5irM4hF0JFKQZ9_OH4KUYnGcUDYvPVpQK-Z-uLsGtdYQ>
    <xmx:D1JhYpTJR6klHoS_vxc4i798NsHbE5gjaMqJjxm_8Fo8JY71Qb3aYQ>
    <xmx:EFJhYtipqdrgSDpYgSi0qvmo6WObrQJW1ntKN2CxEMldFnNsjWVVYA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Apr 2022 08:46:06 -0400 (EDT)
Date:   Thu, 21 Apr 2022 15:46:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     LTP List <ltp@lists.linux.it>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>, idosch@nvidia.com,
        Raju.Lakkaraju@microchip.com, jiri@nvidia.com
Subject: Re: [next] LTP: netns_breakns: Command \"add\" is unknown, try \"ip
 link help\".
Message-ID: <YmFSCp2Bufy39GBD@shredder>
References: <CA+G9fYvO5OERA0k-r=Q8gbGdUKm0VppL2KPJ9e-R0NreBESo_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvO5OERA0k-r=Q8gbGdUKm0VppL2KPJ9e-R0NreBESo_g@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 06:12:54PM +0530, Naresh Kamboju wrote:
> Regressions found on all devices LTP containers test cases failed on
> Linux next-20220420. [1]
> 
>   - ltp-containers-tests/netns_comm_ns_exec_ipv6_ioctl
>   - ltp-containers-tests/netns_breakns_ns_exec_ipv6_netlink
>   - ltp-containers-tests/netns_breakns_ip_ipv6_netlink
>   - ltp-containers-tests/netns_breakns_ns_exec_ipv4_ioctl
>   - ltp-containers-tests/netns_breakns_ip_ipv4_netlink
>   - ltp-containers-tests/netns_comm_ip_ipv6_ioctl
>   - ltp-containers-tests/netns_comm_ip_ipv4_netlink
>   - ltp-containers-tests/netns_comm_ns_exec_ipv4_netlink
>   - ltp-containers-tests/netns_breakns_ns_exec_ipv6_ioctl
>   - ltp-containers-tests/netns_comm_ip_ipv6_netlink
>   - ltp-containers-tests/netns_comm_ns_exec_ipv4_ioctl
>   - ltp-containers-tests/netns_breakns_ns_exec_ipv4_netlink
>   - ltp-containers-tests/netns_breakns_ip_ipv4_ioctl
>   - ltp-containers-tests/netns_comm_ip_ipv4_ioctl
>   - ltp-containers-tests/netns_breakns_ip_ipv6_ioctl
>   - ltp-containers-tests/netns_comm_ns_exec_ipv6_netlink
> 
> 
> Test log:
> ---------
> netns_breakns 1 TINFO: timeout per run is 0h 15m 0s
> Command \"add\" is unknown, try \"ip link help\".
> netns_breakns 1 TBROK: unable to create veth pair devices
> Command \"delete\" is unknown, try \"ip link help\".
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> metadata:
>   git_ref: master
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>   git_sha: f1244c81da13009dbf61cb807f45881501c44789
>   git_describe: next-20220420
>   kernel_version: 5.18.0-rc3
>   kernel-config: https://builds.tuxbuild.com/283Ot2o4P4hh7rNSH56BnbPbNba/config
>   build-url: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next/-/pipelines/520334286
>   artifact-location: https://builds.tuxbuild.com/283Ot2o4P4hh7rNSH56BnbPbNba
> 
> I will bisect these failures.

Should be fixed by:

https://patchwork.kernel.org/project/netdevbpf/patch/20220419125151.15589-1-florent.fourcot@wifirst.fr/
