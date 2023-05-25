Return-Path: <netdev+bounces-5254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D70107106E7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8805E281480
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1E1C13A;
	Thu, 25 May 2023 08:11:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5F51FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:11:00 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B0A186
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:10:58 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 7E6AE5C0068;
	Thu, 25 May 2023 04:10:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 25 May 2023 04:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685002255; x=1685088655; bh=7E
	S4Nut8b33fEHfPBa/Aj9NxsXpNp27WRrVr4a+sE4Y=; b=Iu9GY1qwrqil9lziPL
	MudKDgumJUnEgvbNYqy6MrtgwmMJIvHHfpwfVMeAe41dg6lzfcpuZS719E685HKt
	WrvxBaupDPnT6caV47LE8/kBxSWWxrYCLWbKmX62jrdflCbAeV4E0F8Nu8ONJKEj
	SnUaIjkUu5gdJ60YWkHsI4JFou4yqjUStT33jeBHc1IDsONZGimvdmuoLTb0MwDu
	/YfIjtrmVhn7mEeS8MeacIjEojjynE0qdlBr+Im7zWEX36SBLLSklPg1H+atNLPc
	ogICnslo/pRF/ReHALfQ6yM3HMCjQKhrNALjOy3q7xSe8y20xuGUeESIXC0mQGlN
	WzYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685002255; x=1685088655; bh=7ES4Nut8b33fE
	HfPBa/Aj9NxsXpNp27WRrVr4a+sE4Y=; b=kfpXQOrp2QsRiAnPuIf990eOSJlkX
	DcI+anxqOrHLxOACWxPo+/TsX/lAGgYRtJD1XfJ5cTg/BnmlZ8ymlSa2oNbC9mEa
	lBIx8iQX8NROJ1jah70JLzW923DGV/60e/hdQrWkspBdzDiiQju5Yn40TDcqkFVk
	sXMRi4FW3yyQHu9w7inCZp0RLBTOtDpuzVhV95b2F7O9hsg4BsUHxKWqIZrCD9EY
	ED1SPaflRFd2y+172Wm0l9vUqybWIFgJvmO2uoEAa7fU7cMRrNHiQBQDdaqBSwbg
	OekJUZ/Yb8+nm9HZXat+xBrLoh4s/O3qsLs0QVwq5FXzxqHXDDqSdhX1A==
X-ME-Sender: <xms:DxhvZBHBkXpz8TA7W66R1ETcWpf58amhnn3Dfs9Wd7M9ztq5jJAAfA>
    <xme:DxhvZGWWJiXSJFRaAw-hjZ7wranN_UfooHqW4DI26sGq9ANCdBz_PgXdMIsppqcG7
    HlnHm-fSYWIFolt3DU>
X-ME-Received: <xmr:DxhvZDIfCa9NQ0YWUU2tujYQ1Z7HxM-OFmWu-H2D7ZoMCl3G7v6AHd0PwGA_iR7Zw7LGPbAoaGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejiedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddutddmnecujfgurhepfhgfhffvvefuffgjkfggtgesthdtredt
    tdertdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhshhhkihhnuceovhhlrgguih
    hmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepiefgvdegieei
    leduheeuueeujeeiieehgeduvefhgfeggeduvdevudeuheeufeegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhk
    ihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:DxhvZHGg5BvgeYCNkahwTGIuSO8gci9nG-DXoSBzPmrMOuQqQO_aGw>
    <xmx:DxhvZHWa7WpOp1-iUmJ-JoVMXhFzShajt0cu9bXdwi52ILOh_S4RXA>
    <xmx:DxhvZCN-slrzfuiMMC-3lCFMw_iV6EQhGI2zy-WgntLGwCmXEtDN1w>
    <xmx:DxhvZKNfwPI12_eNlkF71T8EMVJ5EReHA9GmEl5FGKP0HsCjjH1V3w>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 May 2023 04:10:51 -0400 (EDT)
References: <20230523044805.22211-1-vladimir@nikishkin.pw>
 <20230523090441.5a68d0db@hermes.local>
User-agent: mu4e 1.8.14; emacs 30.0.50
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass
 in vxlan
Date: Thu, 25 May 2023 16:08:46 +0800
In-reply-to: <20230523090441.5a68d0db@hermes.local>
Message-ID: <87bki8de5z.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Tue, 23 May 2023 12:48:05 +0800
> Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
>
>> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
>> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
>> +
>> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
>> +		if (!localbypass)
>> +			print_bool(PRINT_FP, NULL, "nolocalbypass ", true);
>> +	}
>
> This is backwards since nolocalbypass is the default.

Could you, please, look at the proposed changes again? I do not think
that the default is "nolocalbypass". The default is "localbypass", as
this is how the kernel behaved without commit
69474a8a5837be63f13c6f60a7d622b98ed5c539.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.


