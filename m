Return-Path: <netdev+bounces-528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 234586F7F65
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 400481C217A5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E32539B;
	Fri,  5 May 2023 08:52:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD07185F
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:52:24 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706FC150FF;
	Fri,  5 May 2023 01:52:23 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 807015C02B1;
	Fri,  5 May 2023 04:52:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 05 May 2023 04:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683276740; x=1683363140; bh=/odw60j8NGuNu
	7+bqhMBLW/jcT0Vzi8cXDLz8dx3NDQ=; b=QyYs3Wkne7yGJV3pWHLcWjOkfW9J6
	Kb9b5CF2j2xDWhPb7bEulW4rFMX+vjD9RhuuQe7//K7VQYOJX3vtwDhRtW46TfBW
	GmJ+hescNf+2XeBxV8NRbn6fRecJCZq82yr3tiFTDNUm3MyJ5ng26+6mvXWRHCBy
	nsVGNqC4n1XrheofzsKUGOd4eQLl/59nr6p6DYlAa+3TQRDfkPf/ktkdv/TnXwkE
	KWSeqqWdRAvVZX709Gg/442il3ZKfDgCwC0YjcXwZMwnl5baofer1kMBgpBzf3QH
	InkZ1h3POOW2rpGiakQnHe0GOtu4mUeIvRLVvkF9/3C1e/0LRXn3HXCvA==
X-ME-Sender: <xms:xMNUZLm3eCn8J7PgnXRaZ68yYtKJBJ15fCnnrfWTp_vkAT-LuZuPlg>
    <xme:xMNUZO2L-DEz-Hqttf9qh2G-ANbwfNmD_v4Ddhqfm8_Rr4sYE7iJIih7csNba7aDN
    qNZLydEG4LL-3o>
X-ME-Received: <xmr:xMNUZBraZhCOcwLVN9VZSqTKH0ciKCKTQ_kgicGfTcOzONPl3r3jf-kBEJh8pxzEE4Ai_tmDQz4ODiNbtcbGMSfL9kM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeefvddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xMNUZDmlmUQueR8OVSdQCJy3LC34FXgjWdz0ds5IvxZK3Hft86w1bg>
    <xmx:xMNUZJ1TrDqAGBvrDry5j-LosOKqtbZ29FEFN7dRDTGOJKftgYvkfQ>
    <xmx:xMNUZCtEIYoz35lzx0ZDhOnOecsamjZTDHe6GlSGeD7bUdxhO7dxjQ>
    <xmx:xMNUZHNZ3EF_9PvmCC45FA96Y6pTBnu6H_R181XkwbpV1Ax7b9ByJw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 May 2023 04:52:19 -0400 (EDT)
Date: Fri, 5 May 2023 11:52:15 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v7 2/2] Add tests for vxlan nolocalbypass option.
Message-ID: <ZFTDv1+DgmOBG7WY@shredder>
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
 <20230501162530.26414-2-vladimir@nikishkin.pw>
 <ZFPWNXtV7sTmH/aQ@shredder>
 <87sfcb8sej.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfcb8sej.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 09:33:03AM +0800, Vladimir Nikishkin wrote:
> 
> Ido Schimmel <idosch@idosch.org> writes:
> 
> > On Tue, May 02, 2023 at 12:25:30AM +0800, Vladimir Nikishkin wrote:
> >> Add test to make sure that the localbypass option is on by default.
> >> 
> >> Add test to change vxlan localbypass to nolocalbypass and check
> >> that packets are delivered to userspace.
> >
> > What do you think about this version [1]?
> 
> I think that your idea of making "nolocalbypass" applicable universally
> is more clear and more straightforward than doing an exception to a
> special case, as the original patch does. I had actually considered such
> a change myself, and only decided against it because I wanted a patch
> that changes the existing behaviour in a minimal way.
> 
> If you are happy with a more radical behaviour for "nolocalbypass", I am
> all for it.

I'm fine with it. We are not changing the default behavior, but instead
gating the new functionality behind a new option whose name fits the
implementation and also - I believe - users' expectations.

> 
> I can even imagine a line in the documentation, something along the
> lines of "The use of the nolocalbypass flag makes debugging easier,
> because the packets are seen on widely available userspace network
> debugging tools, such as tcpdump. You might want to debug and tweak your
> system using this flag, and when you are convinced that the system is
> working as expected, turn it off for a performance gain."
> 
> I will re-submit this series of patches on after the 8th of May 2023.

Cool. Keep in mind that net-next does not automatically open when rc1 is
released. You can monitor the list for the "net-next is OPEN" mail or
follow the suggestions mentioned here:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html?highlight=netdev#git-trees-and-patch-flow

