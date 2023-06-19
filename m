Return-Path: <netdev+bounces-11940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A987355B2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB3281C20A7D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBF4C8FE;
	Mon, 19 Jun 2023 11:27:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5A7D50B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:27:10 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3054DB1;
	Mon, 19 Jun 2023 04:27:09 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 9CEA95C0226;
	Mon, 19 Jun 2023 07:27:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Jun 2023 07:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crisal.io; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1687174028; x=1687260428; bh=3sVGVSE5umY9tDjmVgyBReGwhLjic+x53BQ
	ZNOSbzwY=; b=L7x3MR20u2dIWRGgX7E5CmenYhU3ZxV6sESBgbnq08n3f1kWg2Q
	YauJiWVWqms5DKbWEf6PfXOuKEOCeVX56McVFsV3lxJbK5zdS8D1UqVmu8yCP4Dw
	rlSsKilVGTnJEoeNqi6sf10Izs7afz61b/eILm+AJ7KoF6h2tDaHf689ncZWAg+Z
	RTTX51HJOvrYD57OhkXEgig+T6BRi6WaX/he99cDTUozJhL1NgbYoNPyeZsP9+UA
	aanm5nPez0CoOoY8ZWd4az5MzgdXlWRNCjAB3bJaeR+u6ORON950y92vdLG7cOkP
	GQoX+tWa7yWJV0EVBae4YVeq5KoOmYjL6GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1687174028; x=1687260428; bh=3sVGVSE5umY9tDjmVgyBReGwhLjic+x53BQ
	ZNOSbzwY=; b=oSn55Y7MgyEJ76pymBr9QYRu2qdWeoJm9WT1SXgFu78nLtHWbiB
	DwXjOouWmJXdfAaGks9e4thjDBj4VuPSK+BPXGTNP36wQB3KnTnwZTXlv+UPDQk9
	D9+wpCDW+Dnn7xs8Y0wyidDpY/mKuTzpjLBQKi1yHQ7hnWS6o8ws4MOpD06kqEpp
	YcrRK0tjO7N9TYE4j9A6s8qBmkxWGfrZaELHwSloNxif5ofm9uxqHYMfOBlFCgog
	gitH9w1sCrrn0nLpjm+87Njf84mvEjSZ00gCW6twMck5JvdaH0dAZqRAkNHLs0SK
	7ARqHvepbY+ykgQLfVI5BSucn7q4iOxYPSQ==
X-ME-Sender: <xms:jDuQZBHlxu3jS8z1-wQwiIgOmW1qPX8IHODZik5GO_hh5LD5IaLZHw>
    <xme:jDuQZGXqHiGzz0HDXtZtD2dewul6bDW3mBpMk1L_NRXHU0kVGyyS1NrjXvpfOCoyO
    eFZDcBaLeCrVqTFLFk>
X-ME-Received: <xmr:jDuQZDLjPIMP60RvMKxEE3Ppg3NZgMce_4xt4mDGQT-49oKrP9EPb8RTeMvYaGF-0ONhkF6loHx7RVRskEFPoIaW_GQP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtudejnecuhfhrohhmpefgmhhi
    lhhiohcuvehosghoshculmhlvhgrrhgviicuoegvmhhilhhiohestghrihhsrghlrdhioh
    eqnecuggftrfgrthhtvghrnhepkeeggeeghfdtvdegueekueejvdekgffgtdeljeeuhedv
    tdeludekfeetleefheeinecuffhomhgrihhnpehllhhvmhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegvmhhilhhiohestghrihhs
    rghlrdhioh
X-ME-Proxy: <xmx:jDuQZHEUB6iNqenKsc_74jcFkzvzAAlnYOkGnoFRbvMuPGp9thUIzw>
    <xmx:jDuQZHX-0Pnl_PuDvR3znuTX00GPcVa9L9K69xMtCEpWPVbESu_Fuw>
    <xmx:jDuQZCMSXK2mW6_ow8Q9WzTXb49b4_NqnDG6xwjEtPzODa-BKAl_xw>
    <xmx:jDuQZNcqRhQDH-tahtqR6YuYByt74y0BPC4GYcc0t96zk0cGedVCZQ>
Feedback-ID: i2e3c46c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jun 2023 07:27:07 -0400 (EDT)
Message-ID: <48a98d0c-bfd1-68a9-5d1f-65c942b7c0ef@crisal.io>
Date: Mon, 19 Jun 2023 13:27:05 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Andrew Lunn <andrew@lunn.ch>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, kuba@kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, aliceryhl@google.com
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <f28d6403-d042-4ffb-9872-044388d0f9d9@lunn.ch>
 <CANiq72mMi=7P9OxSH0+ORYDEyxG3+n5uOv_ooxMJ72YRBRZ+PQ@mail.gmail.com>
 <a4bc8847-c668-4cff-9892-663516cf8127@lunn.ch>
Content-Language: en-US
From: =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Autocrypt: addr=emilio@crisal.io;
 keydata= xsFNBFwi9YIBEACpopLqSGTiSxX8LEnt2Ix6DMWhjMjNELwcAS8GrEbSx3kDWErdMq8AeQeO
 Lt0lPnY54Tyk0BtBdn80WqDWMcy3ssE7sNe7U+ed+E174g5q9Kgz5wjHEUv7oq5yhRzHrhpG
 Y/bRiBFaPoKVzAFXTka/Mdj3DCspF+EQ58ex+yt041GlzW4AAW9W+dMv42F70vhe6QdWEu93
 kn9P/WH3Oz18oiy44D2GFBoPIXz/yLPRyB7lqKBtmvD1lBXExr5iLbpDRe/Kj2Ey9iFu1cXu
 l3XMX9bUmNNkezI2DkxATUp5AKhPf0OcGNjCs7xzlJGjDB3uRjsBji7+g/m+PjH1K/mOuYI+
 /XrBHl7EHrkTuHyfFqYyZvID4sSIL6t4CJrYispt4aNoojanPEE2duvWA3oKWDMJK4nPfrYv
 AJ+MiRcxLAFIySfWy/nSo4zecx8YKMarXVdnxfQ4590OzCxgbPVbUpuctStdr13RUdmlrWZf
 N1hzR6sSzlNAsk6BtpxWBUVqSsVrrzHsZbW8N/TSxjQN1OLnNM6w5MBPlvHrXV9+AA7MVK5o
 rro31RiqRZBhIQv7sArOyd1WosYy0fyhw0sswY2+OxWvBhQt8/QeUNIAOQs3/2NyS44BFOpj
 jQWV/R1EC68eNAZJwNs7xhXruysfgzLW7Z4F1aAlXFPxroYrXQARAQABzShFbWlsaW8gQ29i
 b3Mgw4FsdmFyZXogPGVtaWxpb0BjcmlzYWwuaW8+wsGRBBMBCAA7AhsDBQsJCAcCBhUKCQgL
 AgQWAgMBAh4BAheAFiEE53alAzPAxlP8it4A4RUtCZTkv4oFAlwi+2cCGQEACgkQ4RUtCZTk
 v4p7DA/+NPmBXOkTcDBGYff1CZImIDB+5BWjn5JynMnez6e3YTw4NzHlPHcoYC6JGrhDyIgg
 Swb0GHXjCIxerESSSk4IqYLseLf3XS6g0ehNT5rjMz6adAZf5zbglfcQe1BmjqDcj3Cwr6X4
 opt+yC7Vc6cbBEBHQiOi365vhGWKwpFunK+ulNlJVyzETaWhKdWhvfcs19fRp44BCrqRQ4Q9
 TcwBJPSSHw57kLOOcJ3Qk1TJaRVtGynbeyemImT0LNxH344/EHsy3J8BvLhYetvdaD0N6h+A
 VKWwbbYVIPZbLWMO8FZyc6xavH4ozc8FVjDw8DzBnZ25eFZtC7pDPNrCNUqVa7+biCfNsLED
 aA8FCsLYjYcarmwlT0TSULd01+3J5GxrF5HOYSdensmW8AOII1IWXXmIAhMDVVU0M8VxRuIg
 MiB4KHHdF6ybDou7njcVd2ve0TB7gXNFVzuSid2HvTR/9PyeRQXDUB7f14yabD/StTqtWmji
 JI2m67xplaR+jDEFGevBtTr3hFM/EXrR7QeqLVCrdIkzNu+F0bi/vUGQ1Q6DUWDVZcFs2j/r
 wM+n1aUGMY7GJNsSVudKQseGPy3H9GzY4ahB9KNqVhnLbJZSlVR+sCuVOy6f+PA/9GNDeOhJ
 lTU3APsrprmMkZ+EQsnZ9+a3ZobQaB/2pWLt9MWTv6XOwU0EXCL1ggEQALdQ+tUKsidumpW5
 mUbuDv170ebs97klNP9iiOdsE4B8pYSnKW90fdEIla0k0FkvMrkaHC3/ZP8vlvWYIcBAzfmO
 mPGvix2sSxv828bu4FJeVmMu8KpTfAYg5wiXy1fH7N4Q5GcayKu0M4ohEVaggIxSXPzsybXQ
 78nYF7AATFj5kZ5u6ArqackRtvO812yAOtmH6dph2XI9wNE6t2mgCpNJX8WhoVSUcIQmLE68
 vlgz+O5L16Eh2ku6t3I1ti1za+Xf7whyrzJdfmh2ssF0fUJ6C679RmPS9ZeJzlMtmHZ/zNTr
 1fCjQ6RoCmB1opyklLx2RbeTXpszTuwR/XiA6ipO8iwIUK4LNmxMmwmVyeGBqC7bd51QqNOT
 IgW/JbvR+PD3f/4RCsks6ZLgwYdiVnxNfqllp3QJJW5knfTogX9jiqLOvpMUwGsK1zgupVFG
 Q7qn2auVE4r9kxIt/5nv4MFdDBqyfz0sZ3NLINrRYR8Dmfifihq/S9JjGT9D6efwI7qe+vmw
 4Iv/ALAbSivDtDlG/EKq5NX2YoF+yZl22U2yt2Alm+GX1aqaKITwMRqGzUMmiPcI0DlgtNLw
 r28WLEhokPRemgp0/s3QsJVikriKwk7X6r8KpBwl16jEo25zCMbHg2cA1/dD8IJEKJKSRh5g
 J35aJDm4EFa3aHn9bRhBABEBAAHCwXYEGAEIACAWIQTndqUDM8DGU/yK3gDhFS0JlOS/igUC
 XCL1ggIbDAAKCRDhFS0JlOS/ipHVD/9OKoei2DNsDzc6B9VzEdFn6hCtSPSsaaPk7Ki1ENEL
 DK8lWZ+o6YyBwDjpvLxe75kf7oDxEl4KXODoP7CNBWowKz5Q3BNEE7faqP+Kf5Jg4H2n2vZB
 89ZytKL9ZhNsn4m1SazycVQbQpwhyLDQVGhsGWhlaxws+F0hagRUM4d2guW7T9JTplD1PI2g
 463fPJCyAJ8iFgILq0EcTqYMrwhvr4rAwwEEdCb7xsVo825zIXhuKxLUwv8TaNQOCBdVVgE+
 ryqoVwD4UbdP0a70bQEIEyMiY7F4ZPK+3XBkv2ArS/myXgeUoKsM5GdXj8mzcpQiLf/w4Qn9
 4TzSbAOgpWn+0H+8AHT+p9k+GEOdv/D8A1eDYYZEpZhXVUOkvvXXyMRHh5a4TnIFCCWu2a1O
 DxVCmWwnHjwaJiE4mAFgSrDgUY+z7rv5qU6EuGR8Jad1BJUerujMMyEG1D3kwqUCOe5ziKtW
 UqVDQcGM4ColvMduocyqAMjZw4/risjbxC1mnrTOrrAHBh3HfgLy125N5ekv0NSSINXFBnpN
 PYi6AEsmafzef2x2/jF4sei/ZdjN0u0hbZCfpg5EB27wFm80Kr1jPp5FN2FQBwfGXnmi/6So
 5ixV9pxojbmHTwrPHLDQKq5PynyKIqIOCf+T/LUTcFZziSYWMadfYtkiHP8wk6zCQQ==
In-Reply-To: <a4bc8847-c668-4cff-9892-663516cf8127@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew, Miguel,

On 6/16/23 16:43, Andrew Lunn wrote:
> I said in another email, i don't want to suggest premature
> optimisation, before profiling is done. But in C, these functions are
> inline for a reason. We don't want the cost of a subroutine call. We
> want the compiler to be able to inline the code, and the optimiser to
> be able to see it and generate the best code it can.
> 
> Can the rust compile inline the binding including the FFI call?

This is possible, with cross-language LTO, see:

   https://blog.llvm.org/2019/09/closing-gap-cross-language-lto-between.html

There are some requirements that need to happen for that to work 
(mainly, I believe, that the LLVM version used by rustc and clang agree).

But in general it is possible. We use it extensively on Firefox. Of 
course the requirements of Firefox and the kernel might be different.

I think we rely heavily on PGO instrumentation to make the linker inline 
ffi functions, but there might be other ways of forcing the linker to 
inline particular calls that bindgen could generate or what not.

Cheers,

  -- Emilio

