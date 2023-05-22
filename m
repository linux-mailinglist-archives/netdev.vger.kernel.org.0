Return-Path: <netdev+bounces-4142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 154D670B4CD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 451D3280E58
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 06:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39491110E;
	Mon, 22 May 2023 06:05:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286D9EC7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:05:17 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640B7CF
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 23:05:16 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 26F8D32009A2;
	Mon, 22 May 2023 02:05:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 22 May 2023 02:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1684735511; x=1684821911; bh=UC
	2hMXR4T9IiQFiBCSlnW3fjX+utMVA/M06hGxVUooI=; b=Kc9rxrSWFw8vR/CWxC
	ktYdzDE06NmL7KDBs11jCFgNbgx+p6xwGJ+yKE1AGWAJIDr8u5QvKZTP/jVR8/V2
	nq2cM2GrbJ5/heWmt7AHP1T/l7Atyayqc3FFUJ3GN5sS5PrT8T6GgHt3K8UT4MU3
	F5l6P9xMEvmfAAn2vb+AeFk7VNLN4p2h1LJ+/8uaHDddN/EmkPHI/jOB9ps8BgcJ
	J17oDhxjd5iSGh9se8UK6oYSBWrlkh5dLENmuF/5+AtyACdWt6OeQ6uUre5ZVW41
	F1Zm+pf9BfOyCkiHw2Z8IQ40ZMb1TvvB8o266B/7zEtkCrEW0mKd0Vqgr2+ob0o3
	fXtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684735511; x=1684821911; bh=UC2hMXR4T9IiQ
	FiBCSlnW3fjX+utMVA/M06hGxVUooI=; b=EXJrps3vVUlMWgAFxa8dUm5/l+EIn
	aWpgX+I9TI9Sr5Yn32BTBrlG4y579FDpGROrxJlMvCnnpGWS4evxuzy9xlcqjNy5
	cBQMG1GV1sDq0L5SzuXGjYu+zSPcysO82/KiIx0HArEj/6Hp8na5b3nTqm25I7Mr
	jLnXCh2CficqkDSmzTBLDAFD++s9kBws+VWL69zEEFA3bFHst9cx5Zahlf66Du7+
	UNxQviSmYBdU/rbRFms9nDUh7cUrcmkpBKuPjfZFNJdVMeWcFZFxQ7FFesnsofGs
	2sTMxcNupiCmqJ1vXmQFA6U7XOJ70yO/a1Z5XNcpWyQrdW8WdyfKMlTGQ==
X-ME-Sender: <xms:FwZrZBhkyILeKTy-K_EpotJQTbFxcLgJHmGLfzSAETx3DVNN4YkiiA>
    <xme:FwZrZGBKVhfJYeFlisTxRP4H-tW2376NSqd_Oy6icZew3CDPGWwtKbLrnzlndFWkI
    ewyOtOg3Qoyf0ZUx_A>
X-ME-Received: <xmr:FwZrZBFDcD5_gHQgXrfq_6t5Y-XTr_7LXEtz7PdAramG1NvyXqrTM-ysNlwmS9ei5K9K0D635l4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejtddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddutddmnecujfgurhepfhgfhffvvefuffgjkfggtgesthdtredt
    tdertdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhshhhkihhnuceovhhlrgguih
    hmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepiefgvdegieei
    leduheeuueeujeeiieehgeduvefhgfeggeduvdevudeuheeufeegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhk
    ihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:FwZrZGRAnUiGMTQQpkBt--TcGL6z-Jj-PFjpwdUJwG4szdeFT6nbKw>
    <xmx:FwZrZOwGQoOu0CRMplTV8mi2G6yGWAF-ga5YgNOYvreAcd5_sQD3AQ>
    <xmx:FwZrZM6Wy7_510fg1CkWfMzB33puznafMQkPb6l6vOocAGLlt7RwEQ>
    <xmx:FwZrZCiTHYb4ztAmYPREF6dYq0-p_R7edq90MNiMYdjfqiru1qECsw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 May 2023 02:05:06 -0400 (EDT)
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder>
User-agent: mu4e 1.8.14; emacs 30.0.50
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: Ido Schimmel <idosch@idosch.org>
Cc: stephen@networkplumber.org, dsahern@gmail.com, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Date: Mon, 22 May 2023 14:03:37 +0800
In-reply-to: <ZGpvrV4FGjBvqVjg@shredder>
Message-ID: <87lehgsxyn.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Ido Schimmel <idosch@idosch.org> writes:

> On Sun, May 21, 2023 at 01:49:48PM +0800, Vladimir Nikishkin wrote:
>> +	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
>> +	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
>            ^ Unaligned 
>
>> +		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
>
> Missing space after "localbypass":
>
> # ip -d link show dev vxlan0
> 10: vxlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/ether ce:10:63:1d:f3:a8 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan id 10 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum localbypassnoudp6zerocsumtx [...]
>
> Should be:
>
> print_bool(PRINT_ANY, "localbypass", "localbypass ", true);
>
>> +	}
>
> Parenthesis are unnecessary in this case.
>
> I disagree with Stephen's comment about "Use presence as a boolean in
> JSON". I don't like the fact that we don't have JSON output when
> "false":
>
>  # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
>  true
>  # ip link set dev vxlan0 type vxlan nolocalbypass
>  # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
>  null
>
> It's inconsistent with other iproute2 utilities such as "bridge" and
> looks very much like an oversight in the initial JSON output
> implementation.
>
> IOW, I don't have a problem with the code in v4 or simply:
>
> @@ -613,6 +622,10 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>                 }
>         }
>  
> +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]));
> +
>         if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>                 __u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);

If the two maintainers disagree, I am even more confused.

Shall I restore version 4? Use print_bool unconditionally, and add the
json context check back into the code?

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.


