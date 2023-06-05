Return-Path: <netdev+bounces-7911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 632207220F8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CD94281213
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BFB134B3;
	Mon,  5 Jun 2023 08:27:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E66134B2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:27:04 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596EAB8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:27:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id EA7D932001FC;
	Mon,  5 Jun 2023 04:27:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 05 Jun 2023 04:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685953620; x=1686040020; bh=c/+VL+qSrHZtu
	eldk/u1H01JASeHNbyg9m2tytL7B7Y=; b=aZkVCphQOJmmRgTmeV5cX6YbnQlIw
	m8nAZ/R0tWAjvpRkXq0/oXA4SE1zRYl00akfBq1VMpnG0rPEy7hYOElDU3fvcjo2
	XUOuiD/xr6GdDXahyisDFDgBMiz0NX/41pkCRvR+flaKKBGEbo8utlRUGJS/NFy8
	h8phRthQD0lsrnadpWJ24UYPEjOb1m40FoeL2jUc6LBBP7ncoYit1rVPKFLjghJj
	CnbdPC4e7p4+jOqcLBHzq/rszblmHS5a+rbxdcCbeorQ+sBBc7hzSTNl2A3DJCrw
	E4I9hPMGOcgKQXFrifpYiAQ4B8oPdIrwonvTW5VXbhoSpWQmvCDFz4EBg==
X-ME-Sender: <xms:VJx9ZIb9IB4ejShUolBTm_0QTabsHu6AvUlDMAUV2iZE8illX136nA>
    <xme:VJx9ZDZyUKskZBbmUlOjdxWZvYhOWxb21Ke4GqHQSo1lrLdq5bZ42Yjqiu-fZB4eP
    AJZlu03Fpl8egg>
X-ME-Received: <xmr:VJx9ZC99BU2AatGDvSIvAAwrlOi0IxtxbnBH8MzWcwYn5FIiqG0JAua7Djfq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstg
    hhrdhorhhgqeenucggtffrrghtthgvrhhnpeehhfdtjedviefffeduuddvffegteeiieeg
    uefgudffvdfftdefheeijedthfejkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhs
    tghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VJx9ZCrzBSj_Oyc3ECHhJb4NAkLoKESlaSQ0eh_mflFDpP5IUiIJBw>
    <xmx:VJx9ZDoJ_DWqZxOTWPOddpbUKLbbcS14CAhelpE7KOWZd03TpH3MLg>
    <xmx:VJx9ZASm-LrddcQONbcC9cIj1a9ictGnMsKhecCO-wAw2TuRUMSwKA>
    <xmx:VJx9ZAhevyuoQuTcwteczkppGI9ZUlrhHKpbA5N8Iu5r2IDsWhkwrg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 04:26:59 -0400 (EDT)
Date: Mon, 5 Jun 2023 11:26:56 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZH2cUO7pFnU/tcXL@shredder>
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
 <ZH2CeAWH7uMLkFcj@shredder>
 <87sfb6pfqh.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfb6pfqh.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:47:12PM +0800, Vladimir Nikishkin wrote:
> 
> Ido Schimmel <idosch@idosch.org> writes:
> 
> > On Sun, Jun 04, 2023 at 10:00:51PM +0800, Vladimir Nikishkin wrote:
> >> Add userspace support for the [no]localbypass vxlan netlink
> >> attribute. With localbypass on (default), the vxlan driver processes
> >> the packets destined to the local machine by itself, bypassing the
> >> userspace nework stack. With nolocalbypass the packets are always
> >> forwarded to the userspace network stack, so userspace programs,
> >> such as tcpdump have a chance to process them.
> >> 
> >> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> >> ---
> >> v6=>v7:
> >> Use the new vxlan_opts data structure. Rely on the printing loop
> >> in vxlan_print_opt when printing the value of [no] localbypass.
> >
> > Stephen's changes are still not present in the next branch so this patch
> > does not apply
> 
> Sorry for the confusion, I thought that the tree to develop against is
> git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

iproute2-next is developed at
git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

See the README file.

Anyway, patch looks fine, but indentation is a bit off. Please fold this
in:

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 70f38a866c3b..7781d60bbb52 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -36,7 +36,7 @@ static const struct vxlan_bool_opt {
        { "udp_zero_csum6_rx", IFLA_VXLAN_UDP_ZERO_CSUM6_RX, false },
        { "remcsum_tx", IFLA_VXLAN_REMCSUM_TX,          false },
        { "remcsum_rx", IFLA_VXLAN_REMCSUM_RX,          false },
-       { "localbypass", IFLA_VXLAN_LOCALBYPASS,                true },
+       { "localbypass", IFLA_VXLAN_LOCALBYPASS,        true },
 };

And the kernel selftest would need to be modified to use the JSON output
(it fails with this version). Something like this:

diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
index 46067db53068..f75212bf142c 100755
--- a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -130,7 +130,7 @@ nolocalbypass()
        run_cmd "tc -n ns1 qdisc add dev lo clsact"
        run_cmd "tc -n ns1 filter add dev lo ingress pref 1 handle 101 proto ip flower ip_proto udp dst_port 4790 action drop"
 
-       run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+       run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
        log_test $? 0 "localbypass enabled"
 
        run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
@@ -140,7 +140,7 @@ nolocalbypass()
 
        run_cmd "ip -n ns1 link set dev vx0 type vxlan nolocalbypass"
 
-       run_cmd "ip -n ns1 -d link show dev vx0 | grep 'nolocalbypass'"
+       run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == false'"
        log_test $? 0 "localbypass disabled"
 
        run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
@@ -150,7 +150,7 @@ nolocalbypass()
 
        run_cmd "ip -n ns1 link set dev vx0 type vxlan localbypass"
 
-       run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+       run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
        log_test $? 0 "localbypass enabled"
 
        run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"

Please submit it after the iproute2 changes are accepted.

Thanks

