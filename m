Return-Path: <netdev+bounces-1870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6114C6FF5F3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BF0828149A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471A963B;
	Thu, 11 May 2023 15:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAF4629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:28:44 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB11DC;
	Thu, 11 May 2023 08:28:39 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id DEF635C07D5;
	Thu, 11 May 2023 11:28:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 May 2023 11:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683818918; x=1683905318; bh=quNYwRNzmkoZS
	Kd3kh0dhOf0XxBlmCLuuu1FU1HWqW0=; b=CuNXaFdiCKt0vwBaW3M+mrFZWdkVE
	k+6C5jNHhtOjXulHziw4H0zIrd9f3bY9+OeBA9nh9UMF66k8WbEEYjNmooK9NmGL
	0swuxonaNSr8/oJhLSlOheN5xZi0H35/sFHG6PWiv0HscS5Pwmx8+Vu6A0POavnm
	/QWnz7u4EObEbW9WX/VMVgDY5ybMrOl1IlveyR23w58gKLCEEuOLlCQ+1LTEwNjX
	Mv+fg0Bj8K1eAAaaigiGN9JUFuDO3dVnaKz9Ti3flz38srYAWPvvBTGrAso1ZsAt
	N/E1LW0fZ7hFo9Fh09vK5l7zwja7Q5njMyo3U3AYblxqGQNmqP768DtbQ==
X-ME-Sender: <xms:pgldZCQ8kKcG1rwazxX0BusoNejuGMHrWFBpSkHxouWBZHj1fCnzRQ>
    <xme:pgldZHwPmN__-eaSRCJwnluno_YaUvkhzZ03PXQFbTcP6tvWrsmmX_kKuGKNq_xbr
    ydWf4SgKgHVoJI>
X-ME-Received: <xmr:pgldZP1XWJcephx3k0KxHeJJsEOpUFeWOEJIUnboFPTRw7v2rvf7ojft9pKzFpx9KmeBCdtkhLcwXCtcT5iqv6Z4tks>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegkedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstg
    hhrdhorhhgqeenucggtffrrghtthgvrhhnpedvudefveekheeugeeftddvveefgfduieef
    udeifefgleekheegleegjeejgeeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:pgldZOAwypcZGuwFRcZI6N5C-78fAzzUr7pQeeL23c_Kfx43A7aQjA>
    <xmx:pgldZLjTw9NmrMJQtlcvNqBzs_hcXnau1CFEc9pd1xDH2GTyQyF7PA>
    <xmx:pgldZKoRH1mP2Ix-9uBqLtdcjSYgScXb3C08Cd7cKDp_XSTy8d0vmQ>
    <xmx:pgldZEZdlfTzlJNYz9Fjji10mVG4-MTbS4M3vZNEvdbJnCSY3e06aw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 May 2023 11:28:38 -0400 (EDT)
Date: Thu, 11 May 2023 18:28:35 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v8 2/2] selftests: vxlan: Add tests for vxlan
 nolocalbypass option.
Message-ID: <ZF0JowMrc7Zk1Vje@shredder>
References: <20230511032210.9146-1-vladimir@nikishkin.pw>
 <20230511032210.9146-2-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511032210.9146-2-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 11:22:10AM +0800, Vladimir Nikishkin wrote:
> Add test to make sure that the localbypass option is on by default.
> 
> Add test to change vxlan localbypass to nolocalbypass and check
> that packets are delivered to userspace.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

