Return-Path: <netdev+bounces-2899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2DD8704782
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78317281482
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84296200BA;
	Tue, 16 May 2023 08:12:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7651A168CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:12:50 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C4B40C1;
	Tue, 16 May 2023 01:12:48 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 9C68D5C0199;
	Tue, 16 May 2023 04:12:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 May 2023 04:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684224766; x=1684311166; bh=zJFhqzNVhoR5l
	m67xTo7+8wzlRuT2gv3QZpUUtl4vAk=; b=kL9k898xjep0Tp0/oJBfkJH/wHpG2
	mykreL0o7AnLiO1vuWsemCE7FvmFA2tMFUxkE0RWC10d/9EqRzoVruXM1JqQqMT4
	UTZu0p4soAC2RdwYeUbwHBhJcDHIVJlC+oHLlgCld00SVhKZBwBPsZyZEXy28380
	NATyCxCz+CwXg8WQ8Hkt2omSPpoJmmHWb9x3Eh9BurgmNRD4aXPB3DF0xhg/m1nz
	FEIP73RpeFmM0XP/i6YPTKh+/Uh0JWquLj6gDacubRJca4Z/La2bdyryU+SfHVs2
	ESZJAXCTJUW01+D+iw8FVUBz4Topz4W/38aTA9ZMQzj3WEv1Ssf6HRfYQ==
X-ME-Sender: <xms:_jpjZC5LirHSlK2kKkJi8AaxKjDfs75zwQ7aO3-fa1zVFq-Ki6akWA>
    <xme:_jpjZL5yy1FcoRN_kRoswaw6-zRlkreaqqhqL5_ISCEbuxh2SGZBkTwrtKaoXr9IO
    O1qltp27cxg3TQ>
X-ME-Received: <xmr:_jpjZBfnPh_auZCM6Em6XtbbMEMxkuQXtPmj0tePBcFPOLyYM8gnkD3ZM7-DfwrJu3sw2XVKCSKbRV0uR3tXADhKOvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_jpjZPJ6fhEbsnWPazme88GnEzfa_kTTodoc5_VGXShe1hSnK0k32w>
    <xmx:_jpjZGKJq4TS4Ps4rwbcf4-1UJT0UfGVidTlltRKLWuLwl5RhNKMdQ>
    <xmx:_jpjZAwntr38fpIHjxwqmeSMQR2t9Vs6oydib71ayWgTiLDRTW4bwA>
    <xmx:_jpjZIiZoeviI0qQuL35POudnpiE44l151vcJ6fvIMarFu0rrm4vzg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 May 2023 04:12:45 -0400 (EDT)
Date: Tue, 16 May 2023 11:12:42 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Angus Chen <angus.chen@jaguarmicro.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"dsahern@kernel.org" <dsahern@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: Remove low_thresh in ip defrag
Message-ID: <ZGM6+oaSOXNlf8u2@shredder>
References: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
 <ZGIRWjNcfqI8yY8W@shredder>
 <TY2PR06MB34243E08982541B8371E913085789@TY2PR06MB3424.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY2PR06MB34243E08982541B8371E913085789@TY2PR06MB3424.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 12:06:45PM +0000, Angus Chen wrote:
> > -----Original Message-----
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Monday, May 15, 2023 7:03 PM
> > To: Angus Chen <angus.chen@jaguarmicro.com>
> > Cc: davem@davemloft.net; dsahern@kernel.org; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v2] net: Remove low_thresh in ip defrag
> > 
> > On Fri, May 12, 2023 at 09:01:52AM +0800, Angus Chen wrote:
> > > As low_thresh has no work in fragment reassembles,del it.
> > > And Mark it deprecated in sysctl Document.
> > >
> > > Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
> > 
> > Getting the following traces with this patch when creating a netns:
> Sorry for test miss because I tested it in card and didn't test it with multi net.
> Should I create a pernet struct for it?
> It may looks too complicated.

Sorry but I don't understand the motivation behind this patch. IIUC, the
sysctl is deprecated and has no use in the kernel, yet it cannot be
removed because user space may rely on it being present. If so, what is
the significance of the code changes in this patch? Why not just update
the documentation?

