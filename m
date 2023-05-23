Return-Path: <netdev+bounces-4746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 419A770E177
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B84411C20BE5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86972200D0;
	Tue, 23 May 2023 16:11:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632D1F954
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:11:48 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED668E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:11:46 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 886BA32005B5;
	Tue, 23 May 2023 12:11:45 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute2.internal (MEProxy); Tue, 23 May 2023 12:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1684858305; x=1684944705; bh=uX
	2gKKHfgdWuzdVfzoFZaXjkPBhT8PmbCGcHSKBRlS0=; b=efk5ia5Q5qONcCeQwb
	RZTnAuEYD3/i27j+L4jD73SNl7LPhXHd3CPbwt+/7V+qqAmenik16iJR2BO2JNZM
	Ox7BsWXuIKQjORuG2RK9/aLrtIF3qFIzwo5PG9p78Y7K9RI76uN5aRfSbaLLtsuM
	UQocdBssNr3WfqirzBvo0e4/4dtmBcCqFuf6SBqjUEiTiAaPQDVjNrgeBq0n4QlZ
	HEktPkcz7gDlmTCAr66SGxT11VnvCwp/loyyqA0xlrta9TzCyT+K2FeKEFWD3YiE
	+oFZjGZBLSsfL0k3clb7RbtloIkhFeNs4aoQ3tEn96cuUQhZbRaz5079U2V/qnGV
	uEPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684858305; x=1684944705; bh=uX2gKKHfgdWuz
	dVfzoFZaXjkPBhT8PmbCGcHSKBRlS0=; b=H3LLbxywRskAQpMVK3NZkZ4hRdhPa
	Xg7OOM6jnRR8UbQJQDc718WDQl8/Ljad2u5WUrlHiRBuBP7sPeci3HqOUOadA4c4
	2MLTmG1u/D1AvG5po3mma1HcdxhYQbGTlePi7fDnWMuI4br4c9AGhdKqXvKGpDot
	VTdb8wfFRYE1EYPhjCatux+dMZGWSwvm4lipyxRKc5dUWOiRwYZysWo/6kkN5J0L
	m17nH9knMpZ+EyXY7qw6Z22mqXFJjwy364Jb1C35/3ohykpqTHMRTfu27Wl1D8s7
	HUePRfTsPz05OcBEUzHxt8kfSWj41pOJagMogHpB2PJdUaRwe6T7nsGuA==
X-ME-Sender: <xms:wOVsZDbFOn7dwPRd9_XUKoaDJnGoT4X81e8a978-CtD4ubXOQzz4Iw>
    <xme:wOVsZCaY8nXGcdL4djm-lQFohmuP341l0m8oX4KuZrUP-9k5gsWD86cbg4LsECXfM
    WOgGXu0MDdTwBVujR8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejfedgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefofgggkfgjfhffhffvvefutgesthdtredt
    reertdenucfhrhhomhepfdgglhgrughimhhirhcupfhikhhishhhkhhinhdfuceovhhlrg
    guihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepteelvddv
    udetveelvdffhfehueekueeuffefhfehjeevteehkefgheevgeeiudfhnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehn
    ihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:wOVsZF9EZVuN8nHYyWZJT9xzMMBrwPzuX-KvJBpDNMxUB47EdFu-Ww>
    <xmx:wOVsZJriApT-D6QTF0WYu1nTHGEiPRg-EaP0p6NLQ4BnePJFg1uxgA>
    <xmx:wOVsZOqbDEs4fOXjUA2p-A2ydwHYCESosorBa2ZC851OuiIOhLLQiQ>
    <xmx:weVsZLj82R1xTx9zDr7VokhVm2y7TDtcVEntrX3CO78Jm4-9VGL2zQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 68CA1272007A; Tue, 23 May 2023 12:11:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-441-ga3ab13cd6d-fm-20230517.001-ga3ab13cd
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <68f22fdf-8157-4eb9-a658-9962befab54c@app.fastmail.com>
In-Reply-To: <20230523090441.5a68d0db@hermes.local>
References: <20230523044805.22211-1-vladimir@nikishkin.pw>
 <20230523090441.5a68d0db@hermes.local>
Date: Wed, 24 May 2023 00:11:22 +0800
From: "Vladimir Nikishkin" <vladimir@nikishkin.pw>
To: "Stephen Hemminger" <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass in vxlan
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On Wed, May 24, 2023, at 00:04, Stephen Hemminger wrote:
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

localbypass is (or should) be the default, because it is how everything used to work in the past. nolocalbypass is the new feature.

--
Fastmail.


