Return-Path: <netdev+bounces-7882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48ECD721F6A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 983882811DC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA37AD26;
	Mon,  5 Jun 2023 07:21:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37ED194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:21:52 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897439F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:21:51 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 3628832004ED;
	Mon,  5 Jun 2023 03:21:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Jun 2023 03:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685949709; x=1686036109; bh=oWXfMO/nx5sa7
	BHXF40FB5mAXYjjrg+o5fWvA+OT6Gg=; b=tNuULxHLEVrU8IYVmM6NHPHbwZSZG
	t2Pg+kjPxudFX2ShQHcdGv2VIjR4lMMYNHuArbITUNSnAjjrJF+N4bAsojXR41I9
	v6G1ah9gpNhJCJ5HcEPU1nBqhu9wDIelIT4g6JAzK5a/EDIXtRI+atWtDIsao7Fo
	7aia4G8Ih7C47syVWzHf1pyIpbQv4B1RSz2Zfm2HJcOXHJufMmOXPHOQP69vnkGW
	lvFE6/PT5jpP4Y8plgVEscZCh0g8QKt9dcPHGjwIMHb6QYjrfjUPEsHu9r/dvGW+
	oSfPVGGSmuAVetFCpBewi49lGEUCe0aEiFK5BX6QPNQRSUG1NgfwePFWw==
X-ME-Sender: <xms:DY19ZL91U1FXScpav333fNXR2OtYy6aHKD5n3y1TBeMqQ9CjGV7gqg>
    <xme:DY19ZHvYXBJUEXNZH7xwIkpv4uRfp8LHebbF9MWpVPbfnAznXSh65K5Kc0JgpAfOI
    cj1VbHc9EI19x0>
X-ME-Received: <xmr:DY19ZJAGy24deWfae5PWHxG3inTE31ird3cbv3UD9sKRm6RfXm6_QPJWnMPJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelkedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:DY19ZHeX-sWAciCnKUbwrJGZGYMRaDj1oC9DZzTyqJpHWKzqMfNlaw>
    <xmx:DY19ZAMsv3-agXkGjmajBHe1CX9aGL3GnOxrnXVjfJRXmI2hZGZZCw>
    <xmx:DY19ZJkLm9Nv7oIzgt7qsNXnNl74Rwq1xsWuSE1mLHegHWHA_wWsLQ>
    <xmx:DY19ZBHFpI_qUDFkcn_tpiIVRJuSrNKOCqZ6Wmta9PzbQjS4i3VOCQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 03:21:48 -0400 (EDT)
Date: Mon, 5 Jun 2023 10:21:46 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com, simon.horman@corigine.com,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v5 1/3] net: flow_dissector: add support for cfm
 packets
Message-ID: <ZH2NCmmORVfhdpTl@shredder>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
 <20230604115825.2739031-2-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604115825.2739031-2-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:58:23PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support for dissecting cfm packets. The cfm packet header
> fields maintenance domain level and opcode can be dissected.
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

