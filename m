Return-Path: <netdev+bounces-3211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D208705FB3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A1321C20D7E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAB85662;
	Wed, 17 May 2023 06:00:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC09440A
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 06:00:45 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156D126A1;
	Tue, 16 May 2023 23:00:44 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id C43D85C01C7;
	Wed, 17 May 2023 02:00:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 17 May 2023 02:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684303240; x=1684389640; bh=b+5PKyknPkYcK
	IktJykWfMQ2ZNruWkKZ/Da362HiLq4=; b=Jtvf/z12zJDb6on6nsKKmmBiKQYCU
	nNU9ppaj1CPOFF4USYlfmYG2VIyCjx9n9SPkDAsyvWdf3GuoZYlFd4ySoCdz5lSB
	aICT6PEKjh6dXBl+bneqo8pSd8ZRdp2f9x32vDzznGfMWRpLC3b9HhacFHIP9JRZ
	3md7AXmLUmFK1O5HQ+D6f9kGAeTLOHNIojTwWhX02X1jlnJDrNDLL4JOgzop27tw
	gJDSldHJdaQrbsM7D4bThzx42CHUeZmQk8Wupqy9FNXNqrGntcm0wroJ50g8basa
	TSrIn2cmHALT1tmeC3DDCWepN3PvgEeUXHwLk3oDCrrxBOeBHPcqjVNmQ==
X-ME-Sender: <xms:iG1kZH0Tnbe-77abz2dcGS08XOkF1iAQ_HE_DzPkk6gnd2oer3MAVw>
    <xme:iG1kZGG2lfIcuD4Mufj7JG37MUrej7Dyd4wZ0n_0vpYBO7CBoYunITJzoP999vLan
    VonVD5AqylvuHg>
X-ME-Received: <xmr:iG1kZH4lZgJVly8P1GOnoyW44UtDlk2vwqUhYaSVzyn7PstjCD0XYGywaGKPV_ux_7gME_fq98cwUFqbFX4b36j8M4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeitddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeehhfdtjedviefffeduuddvffegte
    eiieeguefgudffvdfftdefheeijedthfejkeenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iG1kZM2WOORpdKZxsXNPo9pfToo8xX2JNm4ctTnAs3I6sM2DxWd0YA>
    <xmx:iG1kZKEn1AoBp0yjNFts8kaiUUioIhJIfAShWugx_siDtJ540XscSw>
    <xmx:iG1kZN8hQt-ycQo4TwNFPdr4WPS5RWjC6DfVf7VXChki9YcERGPJ5g>
    <xmx:iG1kZN2azbljODst3GA4GACfvpbSRXSop0xNU-6sQeJk3USPMH5CPA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 May 2023 02:00:39 -0400 (EDT)
Date: Wed, 17 May 2023 09:00:37 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org, dsahern@gmail.com, shuah@kernel.org,
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net
Subject: Re: [PATCH] selftests: fib_tests: mute cleanup error message
Message-ID: <ZGRthdt5u88zs6xy@shredder>
References: <20230517041119.202072-1-po-hsu.lin@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517041119.202072-1-po-hsu.lin@canonical.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 12:11:19PM +0800, Po-Hsu Lin wrote:
> In the end of the test, there will be an error message induced by the
> `ip netns del ns1` command in cleanup()
> 
>   Tests passed: 201
>   Tests failed:   0
>   Cannot remove namespace file "/run/netns/ns1": No such file or directory
> 
> Redirect the error message to /dev/null to mute it.
> 
> Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")

I don't think this tag is correct. More likely that this is caused by
commit b60417a9f2b8 ("selftest: fib_tests: Always cleanup before exit").

You can even reproduce it with '-h':

# ./fib_tests.sh -h
usage: fib_tests.sh OPTS
[...]
Cannot remove namespace file "/var/run/netns/ns1": No such file or directory

Reverting the commit I mentioned makes it go away.

Also, please use "PATCH net" prefix:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#tl-dr

