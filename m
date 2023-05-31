Return-Path: <netdev+bounces-6775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BFE717DC9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7614D2810C3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC78D12B74;
	Wed, 31 May 2023 11:12:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EB4C8E5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:12:55 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359CAD9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:12:54 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id A02165C00FE;
	Wed, 31 May 2023 07:12:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 31 May 2023 07:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685531573; x=1685617973; bh=jVrRU/M2eicoB
	yQ04xSptFGbOkjCqW4f7DCLm0yJnOU=; b=GR9+RWEIFraUNy7+w8rk82aH82Www
	pzqE9Np360jBdofoaN1jSNTe/RO77E4G+niDIyzTl4u+JXJoUcDpgLHvPIWRwU2Y
	4ngb927dhwTT4RU30IULX02Le2YLrMTKyfCV6oAlQNd5t/2KkmlSGUEbxn+otB4U
	lvH25s1Y7YbUwPtqKJptAHvEi2f7jWSV+HBguOPvhZZ/88im3O4OuM2WiC/2aoPO
	M3ZAIqj96F2sI2qbfFIswt2fmJ5SBE3pKrurkqgCdYCAntR2n5iXoYzqMGzAiZg7
	6kRiyY/XEEX9K7oc55MdUoSSLyf0pwnAnhkSz7maQYnDAL88hUByu1ZIQ==
X-ME-Sender: <xms:tSt3ZA87yFGEloVd3vjcWmaV23sYHbr8XSQBKFNZMAkRsSP7ai06Xg>
    <xme:tSt3ZIu7GnO__yfO6OjAGllOYM3czE4kLjrDaZX3vxgw0IfHdpt92sW5fttFVK-iK
    BFE6jst-BDNYDg>
X-ME-Received: <xmr:tSt3ZGAUZWwd6_2CstgOk03XDhjnr_KzJtrVKgRxfgzRrnjt2dIGdEQMpogvNmP4_yYmPDqs0BqRENa6f6KdFJjqiVE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tSt3ZAdZu0TJ0ob5hTKOUvlLgaqLrK5dZEa1A9yUr4W7f3LGfY8GmA>
    <xmx:tSt3ZFP2ePblZrirLMwWbAaJl58pmzCcP6Ks733gK9QA2DFI4llrzA>
    <xmx:tSt3ZKkPOi55R_iC11lM-qC-PHA_lwWHAfSMyUq2KBCz3yU0bLBzwg>
    <xmx:tSt3ZOZaX8rqLrllEP8pKVGFVr3Y6O7DMLBCCf9f72HlTTAaAi7GpA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 May 2023 07:12:52 -0400 (EDT)
Date: Wed, 31 May 2023 14:12:49 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
	leon@kernel.org
Subject: Re: [PATCH iproute2-next v2] treewide: fix indentation
Message-ID: <ZHcrsQKIrGeS/OYF@shredder>
References: <7a8a4109889c4937ad7ddc196865e94354828045.1685529196.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a8a4109889c4937ad7ddc196865e94354828045.1685529196.git.aclaudi@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:35:56PM +0200, Andrea Claudi wrote:
> Replace multiple whitespaces with tab where appropriate.
> While at it, fix tc flower help message and remove some double
> whitespaces.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks

