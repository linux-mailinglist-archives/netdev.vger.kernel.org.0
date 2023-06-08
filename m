Return-Path: <netdev+bounces-9149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 657977278F1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D2B281689
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB53748E;
	Thu,  8 Jun 2023 07:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EFB628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:39:54 +0000 (UTC)
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D96134;
	Thu,  8 Jun 2023 00:39:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailnew.nyi.internal (Postfix) with ESMTP id D5779580263;
	Thu,  8 Jun 2023 03:39:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 08 Jun 2023 03:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686209989; x=1686217189; bh=KLXdTmjiH6Xbw
	Q8H1+gxtl5yVppFjz4D4oQopIcKuzQ=; b=d9ZfRMzhwi/NYPwdIRTmXsfAeCzO/
	25b7Gw2Veda1kYwShYOWCeRLGfu4tuj/6aQA4ymGTwoUXlLzwqbIwSk6fu/XP8Pq
	LImvHWuv+65pDZclZ5u6b0WRJKcXEvTbUTZIDPEB3O88T/zswOe7xSm1ZD5Ht/Wx
	+KGv05xSeKgXzdq/9SMiFJsqXWsWKgTi5LVzJvkGVP2bDo/plaPg8rjbkRJbSUI1
	0mI5A26L5m9Tfv7HbaNb2iDzF1a5DWjv15aetlwE+cbNQF+nX7KO4bbtvcUgIaPK
	pgDtSZX/IXpuYT9kkCamdWlgwfXzovnwy0PrpT6OXAqpNdlEgyWPNdmdA==
X-ME-Sender: <xms:xIWBZJrtyY-4Z9GgMTwvhd4LsTUauiSiv5sEbPQwZmjb3pdL2PL0Mg>
    <xme:xIWBZLqiYIKBbWqwZCqjFTJ3tOVCCBVTu27oDFX4thmGlfeK_ELIxKhRnrtS7UjMl
    llOpc9eyFNAj0I>
X-ME-Received: <xmr:xIWBZGO9MJxFw56uSA8PmWRiQ_8YmG-MZmF2-px-qbhd2vkp2htIymLyAxs5Ei4TBuqiOfvReEgvAieRoKY7scUitqc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedthedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xIWBZE4BDwHugtCqKmaNVssvhlhtvUK3bUu1aphLIxdwId2pYx08_A>
    <xmx:xIWBZI5muwJiVQR_nOwRrWlMlY5skij_c7CHEykPlsoWcCX0YYRqmg>
    <xmx:xIWBZMjavLfOgAX6QFRsB8T8jPofVOs8P0yZmQjiAMJJ1oBmHlf4yQ>
    <xmx:xYWBZEHZkvORjtzrL4yQRcdCnAeiCuyJyc0OrxH0WYNDEK1yEtWdlA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 03:39:48 -0400 (EDT)
Date: Thu, 8 Jun 2023 10:39:45 +0300
From: Ido Schimmel <idosch@idosch.org>
To: David Ahern <dsahern@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,	Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk,	asml.silence@gmail.com,
 leit@fb.com,	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jason Xing <kernelxing@tencent.com>,
	Joanne Koong <joannelkoong@gmail.com>,	Hangyu Hua <hbh25y@gmail.com>,
 Guillaume Nault <gnault@redhat.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	"open list:DCCP PROTOCOL" <dccp@vger.kernel.org>,
	"open list:IEEE 802.15.4 SUBSYSTEM" <linux-wpan@vger.kernel.org>,
	"open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
	"open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZIGFwZQaW4gzNtGl@shredder>
References: <20230606180045.827659-1-leitao@debian.org>
 <ef90361e-15b2-7ce8-fcec-21fccebe727e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef90361e-15b2-7ce8-fcec-21fccebe727e@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:45:49AM -0600, David Ahern wrote:
> What kind of testing was done with the patch? Would be good to run
> through a NOS style of test suites to make sure the ipmr and ip6mr
> changes are correct. (cc'ed Ido since the mlxsw crew has a really good
> test up)

We don't have that many multicast routing tests, but I ran those that we
do have and they passed.

