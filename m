Return-Path: <netdev+bounces-9216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF23727FF6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 730391C20FA9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E3F125D2;
	Thu,  8 Jun 2023 12:27:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352831119D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:27:35 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD7E43
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:27:33 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id D381B5C0152;
	Thu,  8 Jun 2023 08:27:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 08 Jun 2023 08:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686227249; x=1686313649; bh=sUrVuEMqL3m7h
	NUcB0AjHH5Yv8pwfFymlUHRWBNram0=; b=Zs7cc2Ar8KBOS5RrSHDWCDbaBvtG3
	DAIGEiKCsYK4Oro/ja8kirGrpUBFBsNNUuBvEC2fvPEw3ff2rravXcmeVfnGz/hz
	yRFdd8G91BhxqzACeX5ougxYyeawOEaIDDUbL+o8TqvJKz14gtOffgR1Ea97iUku
	x4fdFite/uRoR5HoBECYK83wJilEp64s7Tv6LGs5w1AhiL5SL8rQdjf0rXrPuC63
	6CMkLnlYV94Qk/J7//DUnohSvpw7sYyniG78KePV7SzKJTxETfP4OA/2jxpUwNVz
	0fg/oyw8sXXaLxQ7K75yGc5TGjGvuNpH65gTd57ex6qcVeoq0ZcbQDKCg==
X-ME-Sender: <xms:McmBZGOcBmo4p-DA2g-ApWfoG-DjVz_zd8e5xt9PyiWKRJDLNQYbvg>
    <xme:McmBZE-ki2ITrh-jBU55OJXJ2AJU2mALV_TyXrA8X3e8uuFaze6Y_t8153w5ZuiOd
    M_9Zp8YJOkObF4>
X-ME-Received: <xmr:McmBZNRHSF0r57Eog3V0-AAsvsQ7GaoDD3nd1Ju5RkIwq87cfRYf2d5umnp1qFshcWQbi1bv5nuQD5vIooMo5s_7YNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtiedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:McmBZGt5ovzDdcJW-awC7_pdKpoLJZ9XzYQkE42z_N6asjuItlfSMA>
    <xmx:McmBZOeYK38dzMXmoVryYUPC_a9fgGov_w2rCWq3316rVBstlUK7vg>
    <xmx:McmBZK1Ayhi1n7eWufSSikTppRvp35NdA4TusGOLFY4MyD7zp_kqAQ>
    <xmx:McmBZPUyVhqLTzwNKgxyZL6NMLv1yBHQmyvQTqGbPb91S6H7Ou5bCg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 08:27:28 -0400 (EDT)
Date: Thu, 8 Jun 2023 15:27:25 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com, simon.horman@corigine.com,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v7 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZIHJLW71NjbuPbkF@shredder>
References: <20230608105648.266575-1-zahari.doychev@linux.com>
 <20230608105648.266575-3-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608105648.266575-3-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 12:56:47PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

