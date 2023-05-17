Return-Path: <netdev+bounces-3227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E747061E6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 608291C20E59
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DA0AD2E;
	Wed, 17 May 2023 07:58:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762A2AD22
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:58:20 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6684EEE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:58:11 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id E29415C01C6;
	Wed, 17 May 2023 03:58:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 17 May 2023 03:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684310288; x=1684396688; bh=AGw78R+iudMSa
	oGEk2T/X8qSQ60KzTunUxGPZ6kwbm8=; b=CqgGxak66sW/cxAj+KUXpObKL+58W
	sx15ea9vq5V+Ll2JaU8lM1aWvYqE5ab9A5p8zu36x2Phdbejqxt5qvtJkQM5gKlD
	IzNRhAQlVw8wT9t9EQN8TVqxKLZbWwqA+7ossxLSn++ZO/qLx7RISt/6mUmrYyA3
	cG3UPoz27W+QBGVoRW03oHnKwg5FCd6TNWxrcLVf6TOkJ0baGwBY6HJoRzmKrEyg
	3pKC4LoK2xbbcKb+7fHrfj5zIvMuvP28euGX/GLFT13oR6/rE8hNPR8UtpwVJO3n
	pO2xCcdH7K3jbBfQNj8rPkSCiRb2O0XfeMyG5ZMc2lulwwD6WgrbBtKvw==
X-ME-Sender: <xms:EIlkZJxtgV0S4wC05GT2BjzoYTmgqTIgkSz5NaFB6JM4vEWE0h4yxA>
    <xme:EIlkZJTvW7T1oYoRVlyFpxNU_Atz-eBGy6Xacu_m16CjUL-TmJO7VC5IdgByx_Nnk
    uS5SZC3i8vqH-4>
X-ME-Received: <xmr:EIlkZDVSNJDpMGxKNu3hjDDDhbpjeLNChSJxaIRTogF-LY6WGT3ymAjVzvbAhsJpui96Ai7YRM7cQoXmH2HzPLteI7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeitddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdduhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughosh
    gthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfefgudei
    feduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EIlkZLgK4mswa0iIsCd84rkX6r6WtkN3CXgMaFq3MoQ4RHdVOC6r6w>
    <xmx:EIlkZLCkw7LgCAUTqC2UiZOWo_8nVGRnU0--zsTWVykXBHAWfJMqMg>
    <xmx:EIlkZELbadYG2CTICEY8J0yxePPsDPIC91PqUCTpJMNkr7RewyiwGg>
    <xmx:EIlkZP7CHBux8qiw4gVLrSBPAx7waKlUarqy906GLp4ZJQIkv_Zevg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 May 2023 03:58:07 -0400 (EDT)
Date: Wed, 17 May 2023 10:58:03 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v2] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGSJCy+dlGG/Z/wX@shredder>
References: <20230516140457.22366-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516140457.22366-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:04:57PM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> nework stack. With nolocalbypass the packets are always forwarded to
> the userspace network stack, so usepspace programs, such as tcpdump

s/usepspace/userspace/

> have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
> v2: this patch matches commit 69474a8a5837be63f13c6f60a7d622b98ed5c539
> in the main tree.
> 
>  ip/iplink_vxlan.c     | 19 +++++++++++++++++++
>  man/man8/ip-link.8.in | 10 ++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> index c7e0e1c4..98fbc65c 100644
> --- a/ip/iplink_vxlan.c
> +++ b/ip/iplink_vxlan.c
> @@ -45,6 +45,7 @@ static void print_explain(FILE *f)
>  		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
>  		"		[ [no]external ] [ gbp ] [ gpe ]\n"
>  		"		[ [no]vnifilter ]\n"
> +		"		[ [no]localbypass ]\n"
>  		"\n"
>  		"Where:	VNI	:= 0-16777215\n"
>  		"	ADDR	:= { IP_ADDRESS | any }\n"
> @@ -276,6 +277,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  		} else if (!matches(*argv, "noudpcsum")) {
>  			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
>  			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
> +		} else if (0 == strcmp(*argv, "localbypass")) {

To be consistent with other strcmp() instances in this file, please
either use '!strcmp()' or 'strcmp() == 0'

> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);

Make this fit in 80 chars like other options

> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
> +		} else if (0 == strcmp(*argv, "nolocalbypass")) {
> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);

Likewise

> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
>  		} else if (!matches(*argv, "udp6zerocsumtx")) {
>  			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
>  				     *argv, *argv);
> @@ -613,6 +620,18 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  		}
>  	}
>  
> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> +
> +		if (is_json_context()) {
> +			print_bool(PRINT_ANY, "localbypass", NULL, localbypass);
> +		} else {
> +			if (!localbypass)
> +				fputs("no", f);
> +			fputs("localbypass ", f);
> +		}
> +	}
> +
>  	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
>  
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index bf3605a9..e53efc45 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -630,6 +630,8 @@ the following additional arguments are supported:
>  ] [
>  .RB [ no ] udpcsum
>  ] [
> +.RB [ no ] localbypass
> +] [
>  .RB [ no ] udp6zerocsumtx
>  ] [
>  .RB [ no ] udp6zerocsumrx
> @@ -734,6 +736,14 @@ are entered into the VXLAN device forwarding database.
>  .RB [ no ] udpcsum
>  - specifies if UDP checksum is calculated for transmitted packets over IPv4.
>  
> +.sp
> +.RB [ no ] localbypass
> +- if fdb destination is local, with nolocalbypass set, forward packets

s/fdb/FDB/

forward encapsulated packets

> +to the userspace network stack. If there is a userspace process
> +listening for these packets, it will have a chance to process them.
> +If localbypass is active (default), bypass the network stack and

bypass the kernel network stack (since you mentioned "userspace network
stack" earlier)

> +inject the packet into the driver directly.

inject the packets to the target VXLAN device, assuming one exists.


> +
>  .sp
>  .RB [ no ] udp6zerocsumtx
>  - skip UDP checksum calculation for transmitted packets over IPv6.
> -- 
> 2.35.8
> 
> --
> Fastmail.
> 
> 

