Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77396F2954
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjD3PBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 11:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3PBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 11:01:30 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F0A1736
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 08:01:27 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E5675C0061;
        Sun, 30 Apr 2023 11:01:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 30 Apr 2023 11:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682866887; x=1682953287; bh=/AGb6zB1jF5CV
        14BtrvfVs9o9fy9kcVGzLoZlElDTfw=; b=gTjl0FK1jzUiDRDDpiLVYtlarut6p
        Ld7lxT/w3rKIu3SiBz5GF1qvs0aqm/oUjPh3CAWJhLfgWSEjFEi1XX3wCSuH8vhF
        joMslQTH8R6bzdh2XwwVvj05ilByzJV//ZbxLwUxLUFEX8G3lhM13yTvJggeEdVu
        luIy95NxqyaaZJAUtiETyFoYQFBRq/k/2g5dwQMb5LMg3geu88UNTCzbWwzmeWFO
        2n8X3R2IKQBBqe6Tj64MfzqRROsSAgLWuT6V93Tjj1mKmnwBvUQ/fETxgHYMyHYh
        aNUlcgwHIaV80scKWy3bq82Uui8dKnQc8VmOoCeZIdtWWVISRXc/CDNLw==
X-ME-Sender: <xms:xoJOZFOiKTn-7h-OqLD41HysfTnknirrkTo0yIbMvcXvqjObLLZsEA>
    <xme:xoJOZH_LCqWcAY5hgxc67B2HalIyQ1nIaCv7kFcISZ_UWbkWa7mHrnVlOhzXjPAw2
    Up-p9EeFTuzj-M>
X-ME-Received: <xmr:xoJOZEQX4aqz9kFEwagYQMYDp_RcGEKwPLyf053Dn-1BpO_VnjVogHkNy3O4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvvddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xoJOZBtsUaynDfxhKQXY6rhH-v8wkvu71Q-XDMexYbkmUkwX6VFkHg>
    <xmx:xoJOZNcN89SGMmMi5LGh2PTTJlz0qps3h14GtEdWexOzhr2e-PeypQ>
    <xmx:xoJOZN2qBr9iDJpOkSX0DaATpyAiOwTGl5iJoiC_xvt4M9kluazkjQ>
    <xmx:x4JOZOXDpG2c-s8Xl87-8pf8X7bMWxL7yS1CTRJAWZOzgDcj_R8dMA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Apr 2023 11:01:25 -0400 (EDT)
Date:   Sun, 30 Apr 2023 18:01:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 3/3] selftests: net: add tc flower cfm test
Message-ID: <ZE6Cw0XOU9L/STZj@shredder>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-4-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425211630.698373-4-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:16:30PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> New cfm flower test case is added to the net forwarding selfttests.
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> ---
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  .../selftests/net/forwarding/tc_flower_cfm.sh | 175 ++++++++++++++++++
>  2 files changed, 176 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
> 
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
> index a474c60fe348..11fb97a63646 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -83,6 +83,7 @@ TEST_PROGS = bridge_igmp.sh \
>  	tc_chains.sh \
>  	tc_flower_router.sh \
>  	tc_flower.sh \
> +	tc_flower_cfm.sh \
>  	tc_mpls_l2vpn.sh \
>  	tc_police.sh \
>  	tc_shblocks.sh \
> diff --git a/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
> new file mode 100755
> index 000000000000..0509bc3c9f75
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
> @@ -0,0 +1,175 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ALL_TESTS="match_cfm_opcode match_cfm_level match_cfm_level_and_opcode"
> +NUM_NETIFS=2
> +source tc_common.sh
> +source lib.sh
> +
> +tcflags="skip_hw"
> +
> +h1_create()
> +{
> +	simple_if_init $h1 192.0.2.1/24 198.51.100.1/24

The IP address are not used in the test. Can be omitted.

> +}
> +
> +h1_destroy()
> +{
> +	simple_if_fini $h1 192.0.2.1/24 198.51.100.1/24
> +}
> +
> +h2_create()
> +{
> +	simple_if_init $h2 192.0.2.2/24 198.51.100.2/24
> +	tc qdisc add dev $h2 clsact
> +}
> +
> +h2_destroy()
> +{
> +	tc qdisc del dev $h2 clsact
> +	simple_if_fini $h2 192.0.2.2/24 198.51.100.2/24
> +}
> +
> +cfm_mdl_opcode()
> +{
> +	local mdl=$1
> +	local op=$2
> +	local flags=$3
> +	local tlv_offset=$4

If you use something like:

local mdl=$1; shift
local op=$1; shift

Then minimal changes are required if the order changes

> +
> +	printf "%02x %02x %02x %02x"    \
> +		   $((mdl << 5))             \
> +		   $((op & 0xff))             \
> +		   $((flags & 0xff)) \
> +		   $tlv_offset
> +}

See mldv2_is_in_get() in tools/testing/selftests/net/forwarding/lib.sh
and related functions for a more readable way to achieve the above.

> +
> +match_cfm_opcode()
> +{
> +	local ethtype="89 02"; readonly ethtype
> +	RET=0
> +
> +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> +	   flower cfm op 47 action drop
> +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> +	   flower cfm op 43 action drop

Both filters can use the same preference since the same mask is used.

> +
> +	pkt="$ethtype $(cfm_mdl_opcode 7 47 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +	pkt="$ethtype $(cfm_mdl_opcode 6 5 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +
> +	tc_check_packets "dev $h2 ingress" 101 1
> +	check_err $? "Did not match on correct opcode"
> +
> +	tc_check_packets "dev $h2 ingress" 102 0
> +	check_err $? "Matched on the wrong opcode"

For good measures you can send a packet with opcode 43 and check that
only 102 is hit.

> +
> +	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
> +	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
> +
> +	log_test "CFM opcode match test"
> +}
> +
> +match_cfm_level()
> +{
> +	local ethtype="89 02"; readonly ethtype
> +	RET=0
> +
> +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> +	   flower cfm mdl 5 action drop
> +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> +	   flower cfm mdl 3 action drop
> +	tc filter add dev $h2 ingress protocol cfm pref 3 handle 103 \
> +	   flower cfm mdl 0 action drop

Same comment about the preference.

> +
> +	pkt="$ethtype $(cfm_mdl_opcode 5 42 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +	pkt="$ethtype $(cfm_mdl_opcode 6 1 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +	pkt="$ethtype $(cfm_mdl_opcode 0 1 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +
> +	tc_check_packets "dev $h2 ingress" 101 1
> +	check_err $? "Did not match on correct level"
> +
> +	tc_check_packets "dev $h2 ingress" 102 0
> +	check_err $? "Matched on the wrong level"
> +
> +	tc_check_packets "dev $h2 ingress" 103 1
> +	check_err $? "Did not match on correct level"
> +
> +	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
> +	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
> +	tc filter del dev $h2 ingress protocol cfm pref 3 handle 103 flower
> +
> +	log_test "CFM level match test"
> +}
> +
> +match_cfm_level_and_opcode()
> +{
> +	local ethtype="89 02"; readonly ethtype
> +	RET=0
> +
> +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> +	   flower cfm mdl 5 op 41 action drop
> +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> +	   flower cfm mdl 7 op 42 action drop

Likewise

> +
> +	pkt="$ethtype $(cfm_mdl_opcode 5 41 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +	pkt="$ethtype $(cfm_mdl_opcode 7 3 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +	pkt="$ethtype $(cfm_mdl_opcode 3 42 0 4)"
> +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> +
> +	tc_check_packets "dev $h2 ingress" 101 1
> +	check_err $? "Did not match on correct level and opcode"
> +	tc_check_packets "dev $h2 ingress" 102 0
> +	check_err $? "Matched on the wrong level and opcode"
> +
> +	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
> +	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
> +
> +	log_test "CFM opcode and level match test"
> +}
> +
> +setup_prepare()
> +{
> +	h1=${NETIFS[p1]}
> +	h2=${NETIFS[p2]}
> +	h1mac=$(mac_get $h1)
> +	h2mac=$(mac_get $h2)
> +
> +	vrf_prepare
> +
> +	h1_create
> +	h2_create
> +}
> +
> +cleanup()
> +{
> +	pre_cleanup
> +
> +	h2_destroy
> +	h1_destroy
> +
> +	vrf_cleanup
> +}
> +
> +trap cleanup EXIT
> +
> +setup_prepare
> +setup_wait
> +
> +tests_run
> +
> +tc_offload_check
> +if [[ $? -ne 0 ]]; then
> +	log_info "Could not test offloaded functionality"
> +else
> +	tcflags="skip_sw"
> +	tests_run
> +fi
> +
> +exit $EXIT_STATUS
> -- 
> 2.40.0
> 
