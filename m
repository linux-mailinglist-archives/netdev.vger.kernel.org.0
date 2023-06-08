Return-Path: <netdev+bounces-9152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7E4727948
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F7391C20FE3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42630883B;
	Thu,  8 Jun 2023 07:56:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CF863C0
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:56:12 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F0D128;
	Thu,  8 Jun 2023 00:56:10 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 179285C0136;
	Thu,  8 Jun 2023 03:56:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Jun 2023 03:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686210970; x=1686297370; bh=7t04AIhh/pS1e
	+ueskNPZXfDnk3Wa3OlgTR7h7Cm1VA=; b=U8BsFTqXIOWM/rn8ZPJVYxv7IBQXc
	EmmbrUQ2nS6bR3ovzwEcSlVL/rGzJmpWq9f6VBFsxTuov/OxcJ1rNrh+nsvFHAyt
	2kSase0IPO3snBgny0oXoJyPOlwHauLaSX43FKc3QL/CU6V0QZTWA94I5xBtAtZG
	HI1s2/o8FDYWexTcwrVGjX5lDfFpTC2mUPMee1o6RMVm5xaCepM3QnAeTmMH36F+
	ZbZR+9inlxPZhaRAXlK5blLEL75VYadoLgDwUpC+rphY915ooKWd7q5eZQySoUSc
	3oaar/99BSM43EMoWi/JBkowsZomludNBFLlZOyFP5vPEnyQeWK3nCNIw==
X-ME-Sender: <xms:mYmBZIhu5o2Xx-hubTUqJ03r9WjLjl58ifBDKLqIhv9Ur0_6C4MRuw>
    <xme:mYmBZBBcwY-R8DyvUG90w65Y_ev4scMy3bPJWpZJ-QV-H_W5hgsqDWo9rOTHMOk72
    1ErGCHRbrs_-c0>
X-ME-Received: <xmr:mYmBZAHrKqSnNE8N5jHXzs1LdJtB8lPx82yPxj-8lEP_RlB7HeFAgnOHkXxUHT7DU_W9cV1mOyv93rjRvhP8zMXSVXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedthedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddutddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughosh
    gthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfefgudei
    feduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mYmBZJRhOD2iKmZTZJpRCsYLfJZ5WBdUMlN36WU4yEYmgp5ny17JWg>
    <xmx:mYmBZFxIYEECxU61HRgDI5AzHGoPuoPLUsqDnpNbZxfkVMavtR-SYw>
    <xmx:mYmBZH4TuFREc_DJzxS1OOi307LMgmFBrpjTC19uxYLzHguGNKHftQ>
    <xmx:momBZFgDRfPyWnblGAk848deRnhfZVVibpGIata3_C51g2zaRI7BCA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 03:56:09 -0400 (EDT)
Date: Thu, 8 Jun 2023 10:56:07 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] selftests: net: vxlan: Fix selftest
 regression after changes in iproute2.
Message-ID: <ZIGJl+R7FgmWc6A6@shredder>
References: <20230608064448.2437-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608064448.2437-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 02:44:48PM +0800, Vladimir Nikishkin wrote:
> The iproute2 output that eventually landed upstream is different than
> the one used in this test, resulting in failures. Fix by adjusting the
> test to use iproute2's JSON output, which is more stable than regular
> output.
> 
> Fixes: 305c04189997 ("selftests: net: vxlan: Add tests for vxlan nolocalbypass option.")
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

