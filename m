Return-Path: <netdev+bounces-7864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EC1721E39
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A1202811DB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EB9631;
	Mon,  5 Jun 2023 06:36:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D0C194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:36:54 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82EA12A
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:36:47 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id 8528D3200910;
	Mon,  5 Jun 2023 02:36:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 05 Jun 2023 02:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685947004; x=1686033404; bh=8VnmnWENWxbup
	hLQsR+INZlmd2ju9IbUCb6MxWWhJgc=; b=JoH6SGPbqUwuUS3onXinpI76VwT9D
	0T7a+KtENHrs/Ssjc4ardqK8Xh38YGYan+dgbnd/NldVP1y4tzDi1jO5gbEPMN5s
	3GFZmOFzAvIJ5RbCnHox2WhUCTp+wtzX/2WA0SjR2U2zAAZVpkTyRSDr+psNwWra
	ynrn4PXF8dl3H73eS0jzJjy+43u0603A3StlM/vL2HzSDWDLsa1SpsUJYa+aAl/u
	STeypzDbjDHez7K8LxHbIlK/fIWWwW98LXL+OMu1+aEeaxbR8L/nr01r16bEoUBd
	+XEL+17p6ipfUHQwVPS5WKU9Z/lTTOA+NKN5Y5voQIbZc+D1PfzahWgYA==
X-ME-Sender: <xms:e4J9ZOvA2DZ4PKHsFWg3XU-q5mBWBh-XhZzhMyjfmyzw3vZdzXkJhw>
    <xme:e4J9ZDdiNwKQv7PN2uF0qygUqBFlNuNS-YeO-n74ARaJIDfX8yKv8zASSfGR2g9Gh
    FQoxXYCZEI-SZ4>
X-ME-Received: <xmr:e4J9ZJyT5ucx_fvNPAISnB2a9FKJglrJplAELPCj2sUD1yKGFh5B7s3KVJmM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelkedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdduhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughosh
    gthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfefgudei
    feduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:e4J9ZJNtfoZTsylj4SM20IvX68_ofNy9lZr9YBTOONrI-WvQtkiRxQ>
    <xmx:e4J9ZO99DpQzllMYKmB9ZH0NQARxj-yfgjfwxzYUzfQWnw9D1r7rgg>
    <xmx:e4J9ZBX1iup3IQcng50NCCXOyTCQj1Pq6DdtEbDSrmeqI2Oj9RzWww>
    <xmx:fIJ9ZP1pXPWrJi9NVQCRm5yHV81bXjbQLdjq9OW6VFvtQNTWGv-nFA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 02:36:42 -0400 (EDT)
Date: Mon, 5 Jun 2023 09:36:40 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZH2CeAWH7uMLkFcj@shredder>
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604140051.4523-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 10:00:51PM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
> v6=>v7:
> Use the new vxlan_opts data structure. Rely on the printing loop
> in vxlan_print_opt when printing the value of [no] localbypass.

Stephen's changes are still not present in the next branch so this patch
does not apply

