Return-Path: <netdev+bounces-7895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 853FF721FD8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34A952811E6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5438711CA1;
	Mon,  5 Jun 2023 07:42:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461A88BEA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:42:42 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BD4A1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:42:40 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id DDE2532008FB;
	Mon,  5 Jun 2023 03:42:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 05 Jun 2023 03:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685950957; x=1686037357; bh=zi2D9JrpHXmW0
	OAUCsEMhY0UzOb7JudXH9v0HHaBQZQ=; b=G34tjvBSZf/NP0dDT7ClRB+aFKUSf
	CTiuJvjNMlEM+H1NqXuST7RApsaXVBtdGwn3kpeKwY7k0M32107ZqHg5rOVYK8UC
	8YSoOv8AkmRd6ybtarnWLjcoh+RPzJ1hceD9OdVLrUNw5fbiW9MSQdx3JiFf0QZh
	RJDdyRUoPiAjgRaEvnpFETsGnV9eZQA81W7mj3vw7AWcELlm4lzq+4IEehDWZFkP
	TqfVbf4uJZg0j6ADNTbqMSIR2RBTQo+FWaqyJPTDrZa7suAGx/6nmjsdnxT7PJ3L
	wZGojaEi/ijJMPS0NRP9GwPalprPu9d7OyqxHB+upXIWOXWbYvsGGvSuA==
X-ME-Sender: <xms:7ZF9ZNfl2YH1TeOlIuGdz-dpwd08UZZPy8HMJxf9a-z_SBANcMdLYg>
    <xme:7ZF9ZLMicKpywSAQEpdLyYPFl1PBrDTOjIP6Qz6QHpTAO7T7IKQW4UTKnJd0yL2cg
    j3n9kmF74ZGREA>
X-ME-Received: <xmr:7ZF9ZGjwT393rvN53g0kfEX0efECUes79AsEg2Y5WIh_dq5AbYi9nD2BM0Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelkedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7ZF9ZG84yhvujXk1qNx1gaUSA2fb067v6PLIS0OXzuBdi0kCNrlg4Q>
    <xmx:7ZF9ZJuFZQh9a7FPRunYsaYJnW_p0kEB7N_BaK_FOM7Wk6eq04QunA>
    <xmx:7ZF9ZFHBDd8nEmbFoNSolLoX2lfUIN-AUPEje8RINxdGm3q5SBlZDA>
    <xmx:7ZF9ZKm0dCdqHkW1oeaB1TZdURVdmu7H8_ucR34YHLn0i339z4OrTg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 03:42:36 -0400 (EDT)
Date: Mon, 5 Jun 2023 10:42:34 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com, simon.horman@corigine.com,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v5 3/3] selftests: net: add tc flower cfm test
Message-ID: <ZH2R6oAN68OSQ5pz@shredder>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
 <20230604115825.2739031-4-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604115825.2739031-4-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:58:25PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> New cfm flower test case is added to the net forwarding selfttests.
> 
> Example output:
> 
>  # ./tc_flower_cfm.sh p1 p2
>  TEST: CFM opcode match test                                         [ OK ]
>  TEST: CFM level match test                                          [ OK ]
>  TEST: CFM opcode and level match test                               [ OK ]
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>

FWIW:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

