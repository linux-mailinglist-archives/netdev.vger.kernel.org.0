Return-Path: <netdev+bounces-4143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEE370B4E8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EBC61C2097F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 06:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A3F1114;
	Mon, 22 May 2023 06:15:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6CC1104
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:15:40 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E165BDB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 23:15:38 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 218F55C0107;
	Mon, 22 May 2023 02:15:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 May 2023 02:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684736138; x=1684822538; bh=j58et/6arIXmd
	MIMRs6z67vcKXIbo5DusbD1LzAPWEM=; b=ZgQKhcjYbsQWEbCgVBFlc5fxviA0v
	zFUuyLnsjwcUiMme4Eww9ci1wO9vz+4l4sPZLBwuzeOy6dq6oomyUUWzbU7AbTLm
	1q4hWRb3GTt+WP3B3VdMS8ZMf7YnexzSdnXcE/m1EkQZxv9SDcalQsg4LNmWha6L
	eXybDCig8DmocoZjhD7thqF/OqwYoMX9kveUbe4WtcfXLD5bS73AEiRrJnAJEgXs
	Q8so8CVLcAQiu4Yk7CZuqNMt1y8+x3qmcNsEpGDDuWyT4qwtAsq/G8LjGC9ridSM
	aPNUhyfLaOigp/50gd6c4Q1BV+8p2yleH6gtCSHpDe1ojV4aj+VD3zYpA==
X-ME-Sender: <xms:iQhrZGgfH3pHEwanlbyO_SxbDSQyEBh53YX0XkKFbhlaafsn03SXSQ>
    <xme:iQhrZHDrTWHQ1pDZFgweVw_nPhPfjQ1Vm-Or-ck1XdFqsHfjsBogk7e2hGKp_4Qi6
    egebPRyTMy13OY>
X-ME-Received: <xmr:iQhrZOE2VJI_4bN5owlkTB_efCc2DgmSzNLR6rpEtyU2WZuJt_YPg3OnaYsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejtddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iQhrZPTvePEKb4rIbeXZubj2EvZJm8T-Rv-U19xxOm4MQG92K6xcrQ>
    <xmx:iQhrZDwnR4HQ1Tnn9OCeGuUA_spfYtZT1-VbQKiMxqQFQ5mzJtB-4w>
    <xmx:iQhrZN44wqzrix5L94CCfEOgFuXpptXZlFd-5DlQhZTKmExdEujJzg>
    <xmx:ighrZGpXci9xk1L2u1cNtzN2b6yiNEC7upJOtqkwB3g1Masl9fYI8w>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 May 2023 02:15:37 -0400 (EDT)
Date: Mon, 22 May 2023 09:15:34 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, dsahern@gmail.com,
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGsIhkGT4RBUTS+F@shredder>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder>
 <20230521124741.3bb2904c@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521124741.3bb2904c@hermes.local>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
> On Sun, 21 May 2023 22:23:25 +0300
> Ido Schimmel <idosch@idosch.org> wrote:
> 
> > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))
> 
> That will not work for non json case.  It will print localbypass whether it is set or not.
> The third argument is a format string used in the print routine.

Yea, replied too late...

Anyway, my main problem is with the JSON output. Looking at other
boolean VXLAN options, we have at least 3 different formats:

1. Only print when "true" for both JSON and non-JSON output. Used for
"external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
"remcsum_tx", "remcsum_rx".

2. Print when both "true" and "false" for both JSON and non-JSON output.
Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".

3. Print JSON when both "true" and "false" and non-JSON only when
"false". Used for "learning".

I don't think we should be adding another format. We need to decide:

1. What is the canonical format going forward?

2. Do we change the format of existing options?

My preference is:

1. Format 2. Can be implemented in a common helper used for all VXLAN
options.

2. Yes. It makes all the boolean options consistent and avoids future
discussions such as this where a random option is used for a new option.

