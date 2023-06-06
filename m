Return-Path: <netdev+bounces-8268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E157236BF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7070A2814B5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 05:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768B264B;
	Tue,  6 Jun 2023 05:21:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673FF360
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:21:34 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4DF123
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:21:33 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 7004C5C00A3;
	Tue,  6 Jun 2023 01:21:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Jun 2023 01:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686028892; x=1686115292; bh=eeSXSsrG+NIzX
	7q0vq2QHJYRRnyKpcP4WawMeQMRvVI=; b=btUl0O7YsuRyXp4cIFphS0WJmAJZn
	wy9gL/lFfwe/uKuVGr9/JRrBwtmdK2+gpIC54+dgCJAr9kYkHH+Uu9n2WTkqgQgm
	z1ZNoVkRtddSkSvgkcBZycMXfJtYNkQni2UBYMyZUwwgu7PsmQZI5cdJoggXVPgO
	grPoAj965qCojLexHgxDonLq+oETqdE6pZoxb0uev4IT9aEtXGD1T5yKG53G7NRu
	Iz+OGhgYltbkd9z4WQTxHHLS+ykk9wKqwWZkgmMcRy0eQG6WvGsbo851bPEYq6bo
	tJbYn9wzDQ4TfT4XVqbNYiDbAa5Dk2fcahkH0Lk6WARxa0mDE4jWxNXUQ==
X-ME-Sender: <xms:XMJ-ZMGOkZtxQ4gwBIFNaozczL7QBo9f2MfyHLrw9JVSQZ-n6tO6dw>
    <xme:XMJ-ZFVKHUPwKHQNyqa1eQICenFIsCKUIB5tXwTgYwu1cegasWSrleMgUGTBbMbQU
    dh1n1K-L8OMksk>
X-ME-Received: <xmr:XMJ-ZGJc_Re4TiisAlKqxkRejWoX7NjWNE7C_YxKj8V0omU4OlI4ULJuFKc2fIa_Ch2V_jwehqLYli-kLn9RSqqOf9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedttddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstg
    hhrdhorhhgqeenucggtffrrghtthgvrhhnpedvudefveekheeugeeftddvveefgfduieef
    udeifefgleekheegleegjeejgeeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XMJ-ZOHNG0OxQw-9Ru9lRXPTqb0yp3NKRtr1pY1ThmGElHE0cWLBtw>
    <xmx:XMJ-ZCWTfrML3Ly5VSMJufoGDA3Uc_uNnkdbecxCFIj4Vwf3v-IX_w>
    <xmx:XMJ-ZBOBGmJDARJD6fEit-1QgYkbQIGZBXK-s5-WSzzO-d82pZfcWQ>
    <xmx:XMJ-ZJP-7vgzF-a5qPSVw1uV_PW66wsVo_HLFZwquEEwgNkujDIp_Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jun 2023 01:21:31 -0400 (EDT)
Date: Tue, 6 Jun 2023 08:21:28 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com,
	David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v8] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZH7CWGlnNMRUFrVo@shredder>
References: <20230606023202.22454-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606023202.22454-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:32:02AM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

