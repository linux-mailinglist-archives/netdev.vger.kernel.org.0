Return-Path: <netdev+bounces-5929-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5ED71361F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F4031C20AD8
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 18:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0F92561;
	Sat, 27 May 2023 18:41:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B32116
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 18:41:42 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE1DD2;
	Sat, 27 May 2023 11:41:39 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 54C3C3200583;
	Sat, 27 May 2023 14:41:36 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sat, 27 May 2023 14:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm3; t=1685212895; x=1685299295; bh=j5
	5NMXH8a642LdPH7N9w+YS4Mx+JTc1eci8TwW82tHg=; b=Sa9QbqZlJDRS9iYg3E
	a86VcGsiu1C9n4hEk2qXvu0hhAznLOzXOLbuYEjC9cAHdVRTYoRZcui+0iBli+1S
	SeGr8K+LCivuDInBr1jsVHQVbEPlyMSftBdwoGBqQW4d/gaWMjKCktBv1kkOhrXj
	Eu8GGj+4yPf40XTsGjhK8HBbRdBnv25Hp4ee4fmZz66mp2ZY+Z09U07tAnX+d870
	TzaOMbZp2KL46HLNR4L2Rwgve0a1RxgeW8R4UrkoYoQJ+awGJYN04NWDFJc06TI6
	5fo8w74KChuRFPM1jkKFmEPJWD468548/Dsk2P4+ceuhjo4aUB/42VRqM5NJ2+0E
	Wq1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685212895; x=1685299295; bh=j55NMXH8a642L
	dPH7N9w+YS4Mx+JTc1eci8TwW82tHg=; b=o3A8iysZFzosnC9DTpUgVpPx+IkfR
	9wmqUAw/JTN/qaM9CVDbxNNpNlxRipzNKxtYJcRVaK24CNBDID248At+ZIwNoSkc
	iV4c+9ZubeVsngx9CAZIIHUXh+aVg0iwpum89b2liUY3XbLgD1gABfsCVk7fMw7E
	kRsBlChs+ZPzbsxdUToIFLowvJk8fraM09xKi3rlWmFymN8isk40U1vi+DVxEaQ4
	0+2o9yaRowLEwa5+z4BjGzbqilJLQAcrO3oZO7Veh3ueKtGvDHp+lIjDQrIcEM0X
	vUQ6rKfcmTv4ey4UvtUromsmfvzcytNjXrthEPgOlnUvajgarFuYd/I2Q==
X-ME-Sender: <xms:305yZDsvgJ0FI-apjfSU6In3isALCQckdOYj9h2acnQCeRWfD09hJw>
    <xme:305yZEc6XTZD__GtFknsRJf_j1XsiecT0uBcu8A8N6pUMTmbP0pdFgieAKBaOk2Kw
    sV42nPMuKvRDW6qz4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekuddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:305yZGzy4SoxmCu3J2mpl0OB_63_AHvL6bSVtZzD4ANsHZlwupU3jg>
    <xmx:305yZCOsdKo2sGJQI-qizwVqNDztSJ4Du5meXcTmx4a9J_Gh-fChZA>
    <xmx:305yZD-B3KwXhME2BSCy27el1SVG3YBRwGVhDFaYromeh-GyOglpuA>
    <xmx:305yZE3h8V0i-woKXZJO8k2HV9YJrK0MjEWVEPjJ82VRP2iBeLyKrg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 8D668B60086; Sat, 27 May 2023 14:41:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-441-ga3ab13cd6d-fm-20230517.001-ga3ab13cd
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <b66b1d4a-50c5-4e0e-98a9-a21a4eb6aab7@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYtzjP_EOjDFZYwTMjv5f3AK2pA_E6mk_mU5FQcZgo_qXQ@mail.gmail.com>
References: <20230526201607.54655398@kernel.org>
 <20230527034922.5542-1-kuniyu@amazon.com>
 <f0194cbe-eb5b-40ee-8723-1927ebddefc1@app.fastmail.com>
 <CA+G9fYtzjP_EOjDFZYwTMjv5f3AK2pA_E6mk_mU5FQcZgo_qXQ@mail.gmail.com>
Date: Sat, 27 May 2023 20:39:03 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc: "Kuniyuki Iwashima" <kuniyu@amazon.com>,
 "Jakub Kicinski" <kuba@kernel.org>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 lkft-triage@lists.linaro.org, "Xin Long" <lucien.xin@gmail.com>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, Netdev <netdev@vger.kernel.org>,
 stable@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: selftests: net: udpgso_bench.sh: RIP: 0010:lookup_reuseport
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023, at 20:02, Naresh Kamboju wrote:
> On Sat, 27 May 2023 at 15:03, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Sat, May 27, 2023, at 05:49, Kuniyuki Iwashima wrote:
>> The current theory right now is that this is a qemu bug when
>> dealing with self-modifying x86 code that has been fixed in
>> qemu-8.0 already, and my suggestion would be to ignore all bugs
>> found by lkft that involve an 'int3' trap, and instead change
>> the lkft setup to use either qemu-8.0 or run the test systems
>> in kvm (which would also be much faster and save resources).
>
>  I will send out an update to ignore the 'int3' trap email reports.

Just to clarify: what I meant was ignoring the old reports with
qemu-7.2 but not any new ones that come from qemu-8.0.

      Arnd

