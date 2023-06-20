Return-Path: <netdev+bounces-12120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 654517363E5
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 933D71C20832
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A313A1FDD;
	Tue, 20 Jun 2023 06:58:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DBE1FDC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:58:44 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A43115
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:58:43 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 8B9773200564;
	Tue, 20 Jun 2023 02:58:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 20 Jun 2023 02:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1687244320; x=1687330720; bh=CQxy3b2FgQkrS
	QvVrrkHnwn0wImRIghvLbfss956QyY=; b=MmcpL4nIbQqsaO/9UlFELv/CFUY0+
	flck9Yz4Az0v5G3kozW7npNGRcH0iFTcFAc9dW7/UyTjvzJrLMry8iaInIopEOTM
	jdkxergd6rrrM8yo6Eu2PAZG3NK0VMcFZL0ZgZZV0X85zSfqW/GKCsTkwOsh6eO6
	A0s54p2eeKUYdf3OmygZSADtMj45APllmLqBgOnWDR8EdRBIvR05QzkEzQK1eBUy
	9WsJDqTCnxF9eCEdMHaTooV6PtVaXhkVldGKvrV1fDCuVN8uEFmIU093x6kHE1IX
	OmBMe6DB/2SajR4WujH2eLyr+FPhkipdpUSEMzK4+HSRlHS3ZIfDDOU2w==
X-ME-Sender: <xms:H06RZHeWmXK7ENHcs1K2yFrm61CFUCgMv8SBZA1bKQwjU4zn68iugA>
    <xme:H06RZNMWPviczb2gIzDhnx1kLNLJ1n3CydZuTgNmDuyxwJ1bInmRgtxI_G1lnlU4m
    uAT9m4Pjq9OSkU>
X-ME-Received: <xmr:H06RZAii1XYgXowXYyWOdrs_vRXEb154ncFDEd6X0AzMvdhC0IGjHTG1cv4wEH_OLK3pkz-rADjE3WXo-0Z71lAY3WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefgedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:H06RZI-ZzBwCWIsDZr67Hf6PgNFOuvQf6osJ-UTBhZie4zBpHq8kLA>
    <xmx:H06RZDugK-OV9azHPnLlIaRhnoezot0CcmH_iIHK9bibA7SQ_z_uiQ>
    <xmx:H06RZHHX0kwEZ5CX1liIv7oWgDnMFdGD3rf3y6_CCUefFI0A78cQYw>
    <xmx:IE6RZJUFzZjYk1eJF7ifmUhG8vPdJs4uKQhXQqh5sAVqKgCKFZUZCw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jun 2023 02:58:39 -0400 (EDT)
Date: Tue, 20 Jun 2023 09:58:35 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, dsahern@gmail.com, stephen@networkplumber.org,
	hmehrtens@maxlinear.com, aleksander.lobakin@intel.com,
	simon.horman@corigine.com, Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH iproute2-next] f_flower: add cfm support
Message-ID: <ZJFOGws2EcmGxLHZ@shredder>
References: <20230619213523.520800-1-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619213523.520800-1-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 11:35:23PM +0200, Zahari Doychev wrote:
> +static int flower_parse_cfm(int *argc_p, char ***argv_p, __be16 eth_type,
> +			    struct nlmsghdr *n)
> +{
> +	struct rtattr *cfm_attr;
> +	char **argv = *argv_p;
> +	int argc = *argc_p;
> +	int ret;
> +
> +	if (eth_type != htons(ETH_P_CFM)) {
> +		fprintf(stderr,
> +			"Can't set attribute if ethertype isn't CFM\n");
> +		return -1;
> +	}
> +
> +	cfm_attr = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_CFM | NLA_F_NESTED);
> +
> +	while (argc > 0) {
> +		if (matches(*argv, "mdl") == 0) {

New code is expected to use strcmp() instead of matches(). Looks good
otherwise.

> +			__u8 val;
> +
> +			NEXT_ARG();
> +			ret = get_u8(&val, *argv, 10);
> +			if (ret < 0) {
> +				fprintf(stderr, "Illegal \"cfm md level\"\n");
> +				return -1;
> +			}
> +			addattr8(n, MAX_MSG, TCA_FLOWER_KEY_CFM_MD_LEVEL, val);
> +		} else if (matches(*argv, "op") == 0) {

Likewise.

> +			__u8 val;
> +
> +			NEXT_ARG();
> +			ret = get_u8(&val, *argv, 10);
> +			if (ret < 0) {
> +				fprintf(stderr, "Illegal \"cfm opcode\"\n");
> +				return -1;
> +			}
> +			addattr8(n, MAX_MSG, TCA_FLOWER_KEY_CFM_OPCODE, val);
> +		} else {
> +			break;
> +		}
> +		argc--; argv++;
> +	}
> +
> +	addattr_nest_end(n, cfm_attr);
> +
> +	*argc_p = argc;
> +	*argv_p = argv;
> +
> +	return 0;
> +}
> +
>  static int flower_parse_opt(struct filter_util *qu, char *handle,
>  			    int argc, char **argv, struct nlmsghdr *n)
>  {
> @@ -2065,6 +2118,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  				return -1;
>  			}
>  			continue;
> +		} else if (matches(*argv, "cfm") == 0) {

Likewise.

> +			NEXT_ARG();
> +			ret = flower_parse_cfm(&argc, &argv, eth_type, n);
> +			if (ret < 0)
> +				return -1;
> +			continue;
>  		} else {
>  			if (strcmp(*argv, "help") != 0)
>  				fprintf(stderr, "What is \"%s\"?\n", *argv);

