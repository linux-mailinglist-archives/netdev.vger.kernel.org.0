Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B452D698CA4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBPGKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjBPGKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF7B17151;
        Wed, 15 Feb 2023 22:10:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 761D2B825BC;
        Thu, 16 Feb 2023 06:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B40C433D2;
        Thu, 16 Feb 2023 06:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527804;
        bh=j2J9W4rzZwcQLbEsIJOPioIcassDMrR/FlkwwIOQNeI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=t9cu7vFQXBLThkz7Qf0ETh6RyZ5WXapx+N6CUr2ExiIHdTo6Q+YwOevuZiX0Cfdfm
         9MeVVlmNvNmemnrE9nlLUYib+C8JHiINX3bBhTiLHR9u7HgjKJVEwZlZgH1iG1GiLj
         6pEw0m0vIYsOrW4XuPbzyC5KBRRACEEWuEAVrmIMwgJ0AANQJEQY9JXUwIr1ynLNH5
         WmQIbtxNdMj4YmyqlHZvUgYuNGD7A/I1hNqKnqCqLZRrl7Wxcz3W7rce2ZRubeGQOq
         SPZfvoNIii4hTANaC1pmgzZwaKSuk+4Wql0qzxDtKkhfoEq42fG5sXngp2k6saMlKo
         3ghcpOuU0nsFw==
Message-ID: <95a5c1ba-10f3-13c3-3982-cee38b093227@kernel.org>
Date:   Wed, 15 Feb 2023 23:10:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [net-next 3/3] selftests: seg6: add selftest for PSP flavor in
 SRv6 End behavior
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
 <20230215134659.7613-4-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230215134659.7613-4-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 6:46 AM, Andrea Mayer wrote:
> This selftest is designed for testing the PSP flavor in SRv6 End behavior.
> It instantiates a virtual network composed of several nodes: hosts and
> SRv6 routers. Each node is realized using a network namespace that is
> properly interconnected to others through veth pairs.
> The test makes use of the SRv6 End behavior and of the PSP flavor needed
> for removing the SRH from the IPv6 header at the penultimate node.
> 
> The correct execution of the behavior is verified through reachability
> tests carried out between hosts.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/srv6_end_flavors_test.sh    | 869 ++++++++++++++++++
>  2 files changed, 870 insertions(+)
>  create mode 100755 tools/testing/selftests/net/srv6_end_flavors_test.sh
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 3364c548a23b..6cd8993454d7 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -38,6 +38,7 @@ TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
>  TEST_PROGS += srv6_hencap_red_l3vpn_test.sh
>  TEST_PROGS += srv6_hl2encap_red_l2vpn_test.sh
>  TEST_PROGS += srv6_end_next_csid_l3vpn_test.sh
> +TEST_PROGS += srv6_end_flavors_test.sh
>  TEST_PROGS += vrf_strict_mode_test.sh
>  TEST_PROGS += arp_ndisc_evict_nocarrier.sh
>  TEST_PROGS += ndisc_unsolicited_na_test.sh
> diff --git a/tools/testing/selftests/net/srv6_end_flavors_test.sh b/tools/testing/selftests/net/srv6_end_flavors_test.sh
> new file mode 100755
> index 000000000000..50563443a4ad
> --- /dev/null
> +++ b/tools/testing/selftests/net/srv6_end_flavors_test.sh
> @@ -0,0 +1,869 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# author: Andrea Mayer <andrea.mayer@uniroma2.it>
> +# author: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> +#
> +# This script is designed to test the support for "flavors" in the SRv6 End
> +# behavior.
> +#
> +# Flavors defined in RFC8986 [1] represent additional operations that can modify
> +# or extend the existing SRv6 End, End.X and End.T behaviors. For the sake of
> +# convenience, we report the list of flavors described in [1] hereafter:
> +#   - Penultimate Segment Pop (PSP);
> +#   - Ultimate Segment Pop (USP);
> +#   - Ultimate Segment Decapsulation (USD).
> +#
> +# The End, End.X, and End.T behaviors can support these flavors either
> +# individually or in combinations.
> +# Currently in this selftest we consider only the PSP flavor for the SRv6 End
> +# behavior. However, it is possible to extend the script as soon as other
> +# flavors will be supported in the kernel.
> +#
> +# The purpose of the PSP flavor consists in instructing the penultimate node
> +# listed in the SRv6 policy to remove (i.e. pop) the outermost SRH from the IPv6
> +# header.
> +# A PSP enabled SRv6 End behavior instance processes the SRH by:
> +#  - decrementing the Segment Left (SL) value from 1 to 0;
> +#  - copying the last SID from the SID List into the IPv6 Destination Address
> +#    (DA);
> +#  - removing the SRH from the extension headers following the IPv6 header.
> +#
> +# Once the SRH is removed, the IPv6 packet is forwarded to the destination using
> +# the IPv6 DA updated during the PSP operation (i.e. the IPv6 DA corresponding
> +# to the last SID carried by the removed SRH).
> +#
> +# Although the PSP flavor can be set for any SRv6 End behavior instance on any
> +# SR node, it will be active only on such behaviors bound to a penultimate SID
> +# for a given SRv6 policy.
> +#                                                SL=2 SL=1 SL=0
> +#                                                  |    |    |
> +# For example, given the SRv6 policy (SID List := <X,   Y,   Z>):
> +#  - a PSP enabled SRv6 End behavior bound to SID Y will apply the PSP operation
> +#    as Segment Left (SL) is 1, corresponding to the Penultimate Segment of the
> +#    SID List;
> +#  - a PSP enabled SRv6 End behavior bound to SID X will *NOT* apply the PSP
> +#    operation as the Segment Left is 2. This behavior instance will apply the
> +#    "standard" End packet processing, ignoring the configured PSP flavor at
> +#    all.
> +#
> +# [1] RFC8986: https://datatracker.ietf.org/doc/html/rfc8986
> +#
> +# Network topology
> +# ================
> +#
> +# The network topology used in this selftest is depicted hereafter, composed by
> +# two hosts (hs-1, hs-2) and four routers (rt-1, rt-2, rt-3, rt-4).
> +# Hosts hs-1 and hs-2 are connected to routers rt-1 and rt-2, respectively,
> +# allowing them to communicate with each other.
> +# Traffic exchanged between hs-1 and hs-2 can follow different network paths.
> +# The network operator, through specific SRv6 Policies can steer traffic to one
> +# path rather than another. In this selftest this is implemented as follows:
> +#
> +#   i) The SRv6 H.Insert behavior applies SRv6 Policies on traffic received by
> +#      connected hosts. It pushes the Segment Routing Header (SRH) after the
> +#      IPv6 header. The SRH contains the SID List (i.e. SRv6 Policy) needed for
> +#      steering traffic across the segments/waypoints specified in that list;
> +#
> +#  ii) The SRv6 End behavior advances the active SID in the SID List carried by
> +#      the SRH;
> +#
> +# iii) The PSP enabled SRv6 End behavior is used to remove the SRH when such
> +#      behavior is configured on a node bound to the Penultimate Segment carried
> +#      by the SID List.
> +#
> +#                cafe::1                      cafe::2
> +#              +--------+                   +--------+
> +#              |        |                   |        |
> +#              |  hs-1  |                   |  hs-2  |
> +#              |        |                   |        |
> +#              +---+----+                   +--- +---+
> +#     cafe::/64    |                             |      cafe::/64
> +#                  |                             |
> +#              +---+----+                   +----+---+
> +#              |        |  fcf0:0:1:2::/64  |        |
> +#              |  rt-1  +-------------------+  rt-2  |
> +#              |        |                   |        |
> +#              +---+----+                   +----+---+
> +#                  |      .               .      |
> +#                  |  fcf0:0:1:3::/64   .        |
> +#                  |          .       .          |
> +#                  |            .   .            |
> +#  fcf0:0:1:4::/64 |              .              | fcf0:0:2:3::/64
> +#                  |            .   .            |
> +#                  |          .       .          |
> +#                  |  fcf0:0:2:4::/64   .        |
> +#                  |      .               .      |
> +#              +---+----+                   +----+---+
> +#              |        |                   |        |
> +#              |  rt-4  +-------------------+  rt-3  |
> +#              |        |  fcf0:0:3:4::/64  |        |
> +#              +---+----+                   +----+---+
> +#
> +# Every fcf0:0:x:y::/64 network interconnects the SRv6 routers rt-x with rt-y in
> +# the IPv6 operator network.
> +#
> +#
> +# Local SID table
> +# ===============
> +#
> +# Each SRv6 router is configured with a Local SID table in which SIDs are
> +# stored. Considering the given SRv6 router rt-x, at least two SIDs are
> +# configured in the Local SID table:
> +#
> +#   Local SID table for SRv6 router rt-x
> +#   +---------------------------------------------------------------------+
> +#   |fcff:x::e is associated with the SRv6 End behavior                   |
> +#   |fcff:x::ef1 is associated with the SRv6 End behavior with PSP flavor |
> +#   +---------------------------------------------------------------------+
> +#
> +# The fcff::/16 prefix is reserved by the operator for the SIDs. Reachability of
> +# SIDs is ensured by proper configuration of the IPv6 operator's network and
> +# SRv6 routers.
> +#
> +#
> +# SRv6 Policies
> +# =============
> +#
> +# An SRv6 ingress router applies different SRv6 Policies to the traffic received
> +# from connected hosts on the basis of the destination addresses.
> +# In case of SRv6 H.Insert behavior, the SRv6 Policy enforcement consists of
> +# pushing the SRH (carrying a given SID List) after the existing IPv6 header.
> +# Note that in the inserting mode, there is no encapsulation at all.
> +#
> +#   Before applying an SRv6 Policy using the SRv6 H.Insert behavior
> +#   +------+---------+
> +#   | IPv6 | Payload |
> +#   +------+---------+
> +#
> +#   After applying an SRv6 Policy using the SRv6 H.Insert behavior
> +#   +------+-----+---------+
> +#   | IPv6 | SRH | Payload |
> +#   +------+-----+---------+
> +#
> +# Traffic from hs-1 to hs-2
> +# -------------------------
> +#
> +# Packets generated from hs-1 and directed towards hs-2 are
> +# handled by rt-1 which applies the following SRv6 Policy:
> +#
> +#   i.a) IPv6 traffic, SID List=fcff:3::e,fcff:4::ef1,fcff:2::ef1,cafe::2
> +#
> +# Router rt-1 is configured to enforce the Policy (i.a) through the SRv6
> +# H.Insert behavior which pushes the SRH after the existing IPv6 header. This
> +# Policy steers the traffic from hs-1 across rt-3, rt-4, rt-2 and finally to the
> +# destination hs-2.
> +#
> +# As the packet reaches the router rt-3, the SRv6 End behavior bound to SID
> +# fcff:3::e is triggered. The behavior updates the Segment Left (from SL=3 to
> +# SL=2) in the SRH, the IPv6 DA with fcff:4::ef1 and forwards the packet to the
> +# next router on the path, i.e. rt-4.
> +#
> +# When router rt-4 receives the packet, the PSP enabled SRv6 End behavior bound
> +# to SID fcff:4::ef1 is executed. Since the SL=2, the PSP operation is *NOT*
> +# kicked in and the behavior applies the default End processing: the Segment
> +# Left is decreased (from SL=2 to SL=1), the IPv6 DA is updated with the SID
> +# fcff:2::ef1 and the packet is forwarded to router rt-2.
> +#
> +# The PSP enabled SRv6 End behavior on rt-2 is associated with SID fcff:2::ef1
> +# and is executed as the packet is received. Because SL=1, the behavior applies
> +# the PSP processing on the packet as follows: i) SL is decreased, i.e. from
> +# SL=1 to SL=0; ii) last SID (cafe::2) is copied into the IPv6 DA; iii) the
> +# outermost SRH is removed from the extension headers following the IPv6 header.
> +# Once the PSP processing is completed, the packet is forwarded to the host hs-2
> +# (destination).
> +#
> +# Traffic from hs-2 to hs-1
> +# -------------------------
> +#
> +# Packets generated from hs-2 and directed to hs-1 are handled by rt-2 which
> +# applies the following SRv6 Policy:
> +#
> +#   i.b) IPv6 traffic, SID List=fcff:1::ef1,cafe::1
> +#
> +# Router rt-2 is configured to enforce the Policy (i.b) through the SRv6
> +# H.Insert behavior which pushes the SRH after the existing IPv6 header. This
> +# Policy steers the traffic from hs-2 across rt-1 and finally to the
> +# destination hs-1
> +#
> +#
> +# When the router rt-1 receives the packet, the PSP enabled SRv6 End behavior
> +# associated with the SID fcff:1::ef1 is triggered. Since the SL=1,
> +# the PSP operation takes place: i) the SL is decremented; ii) the IPv6 DA is
> +# set with the last SID; iii) the SRH is removed from the extension headers
> +# after the IPv6 header. At this point, the packet with IPv6 DA=cafe::1 is sent
> +# to the destination, i.e. hs-1.
> +

Once again, thank you for taking the time to write a detailed
description of the test and its setup. Documenting intent is such an
important part of the tests.

Reviewed-by: David Ahern <dsahern@kernel.org>


