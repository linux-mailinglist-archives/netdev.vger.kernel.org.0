Return-Path: <netdev+bounces-4127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 120D570AFDE
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 21:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E625280E5C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B238F7F;
	Sun, 21 May 2023 19:23:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6765C8F5D
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 19:23:36 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E263DE
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:23:34 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 3AF495C00CF;
	Sun, 21 May 2023 15:23:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 21 May 2023 15:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684697010; x=1684783410; bh=8TH+k4aVm2Ztb
	wVON65Qk3HKVkw8/CBtbW2FeKzw7Qg=; b=i+VQkhArMnwEB4jxi2BVl/X/KCZvc
	5r9XnyK0+Ovi/VUcJVbxloXKUjRV87c1jWleTyM2MMFWUMqVkR3saB/bqZIty8u9
	HpiIrXNzOpa0HaVp2PcsRawSAnTiboJSO6G6hpzVVRhJQIKGE574WZ5QJ4pbD7sM
	7YckqU8AmWIj6nlvvEuBwaMKO7TH41d23iEzikl+4d8ngOsZ5NgbrrRTFj9cyLMq
	0fM3ID5if9kIc6zCWDOPFXgtg3hVU52/WfhD1BcUVP879pZ3dZVpptjaupyLXHu0
	CxnbqXd3x13pUwH6+eXvcMMEKQLjxHOjJMYLxKgakDDXrga4PjkyOaupQ==
X-ME-Sender: <xms:sW9qZOUW_oWa3EgnMg_h0tA5lt45tkjRY3VKbg3Z0COaZBou6w2l-A>
    <xme:sW9qZKmZ0059kGahBbU6Xp494tLKTc-kAAagihkHpO7vtQQjAe9IZ3OXukqOQocRp
    5xsosFMYuJIScA>
X-ME-Received: <xmr:sW9qZCabUtn3baBhKie4YGgXfy6MZigpTapbINW2upofuoi98sm2cg62Z2T2Ic8hF9EJEhwaNanfEooIX6O_dY7F0jc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiledgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sW9qZFWfe_-23Y-h8zZIh41zARqmbffNOm5qRe-q2dgDcMkvqWQGUA>
    <xmx:sW9qZIn5aK1-W-lpHb1CPtdWSn6ZMJhT8Cr7XEjHJ1wFn-hc-3116w>
    <xmx:sW9qZKfxFX8972eCdDGNYeVsNsEZzU5mIP1Ts7piKiJmCGvG7a50nA>
    <xmx:sm9qZD-qBEbCAL4Ogh13YlycRDP7kiz5eWvGOojYE6aPvP3WMytMtA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 May 2023 15:23:29 -0400 (EDT)
Date: Sun, 21 May 2023 22:23:25 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>, stephen@networkplumber.org,
	dsahern@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGpvrV4FGjBvqVjg@shredder>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521054948.22753-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 01:49:48PM +0800, Vladimir Nikishkin wrote:
> +	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
> +	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
           ^ Unaligned 

> +		print_bool(PRINT_ANY, "localbypass", "localbypass", true);

Missing space after "localbypass":

# ip -d link show dev vxlan0
10: vxlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether ce:10:63:1d:f3:a8 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 10 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum localbypassnoudp6zerocsumtx [...]

Should be:

print_bool(PRINT_ANY, "localbypass", "localbypass ", true);

> +	}

Parenthesis are unnecessary in this case.

I disagree with Stephen's comment about "Use presence as a boolean in
JSON". I don't like the fact that we don't have JSON output when
"false":

 # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
 true
 # ip link set dev vxlan0 type vxlan nolocalbypass
 # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
 null

It's inconsistent with other iproute2 utilities such as "bridge" and
looks very much like an oversight in the initial JSON output
implementation.

IOW, I don't have a problem with the code in v4 or simply:

@@ -613,6 +622,10 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
                }
        }
 
+       if (tb[IFLA_VXLAN_LOCALBYPASS])
+               print_bool(PRINT_ANY, "localbypass", "localbypass ",
+                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]));
+
        if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
                __u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);

