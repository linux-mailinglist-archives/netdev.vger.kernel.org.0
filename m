Return-Path: <netdev+bounces-9436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9A4728FF8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DB81281867
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 06:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C4815C6;
	Fri,  9 Jun 2023 06:31:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F9F1854
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:31:43 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA9271D;
	Thu,  8 Jun 2023 23:31:41 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 142875C0045;
	Fri,  9 Jun 2023 02:31:41 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 09 Jun 2023 02:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1686292301; x=1686378701; bh=d2
	x9IDXlPUYeZLqgaykZutUxT8s5eH1tQ1r8Y+8L+68=; b=S1IhnsGsOg4qXTaRCw
	Ez9D7ShEyqZdz2NoMsIBloAFlPs4XPzcVsgvvMntgO7x7z/ipzlseiMPaWg0EXb3
	P1q148lH/LMqXmtbCG7NN/f2+IVFX4QXGF33vGpL5GH4aY2cN46yeMHGeLPHZuLh
	M5xdwSBJixJp0ciIYFMGSIka2O+en09ndebA0l/VE3R+yry/ibnonpaPOv3IIzoh
	YympschJBbMtnh/9I1L/XCUrtF5L6BhkIdmoXvxL5O+LKkzy+fQMa+BXbiA11058
	FUEqHM5wGrKvhicf5hwZCEc5Z777veTcz6QBhrbrXRRfZvvUaUc6X+CPYsdXksR6
	jMHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686292301; x=1686378701; bh=d2x9IDXlPUYeZ
	LqgaykZutUxT8s5eH1tQ1r8Y+8L+68=; b=CzexGceKdkTjt/E9FFoyUErukUTFg
	d1eYVb+oFt06Lym/L6rOsMXMps+KOztRPWZvt1rGyxPzjqLe+XzX02ff8mYNmInC
	1gnqgo8vOs3kHDG5d6CoXp3rc8IpNX1/DLJE3rRyBJfZteHk5JhvV9EGMyw/Hwgq
	uyv6hKy8267g4jo85R9Ejx96epJe18q2xmwGarzNmLH4RpsW44j4HwxRhRE7wJsw
	GbW5iX8dDPB5vuseqJ5cDRPR5D4teLyKDL608MsigBBwWrRFbqEs5WhwYTsQ/N7T
	rcZITQ+JD6jkC7Sde/aJAMOBzz0PgiV7kJztD3Kt9DHOobds3LGAtR+MA==
X-ME-Sender: <xms:TMeCZFsgGxRdZYIBtNZiEuG7X1EqZZ-jl-xMkAShzbUKdYLpcQE9VQ>
    <xme:TMeCZOekePTuUpcwu9MrzX0CKoQEHVRxiZHjQ4ujA9TiKT-Mv8OLT0jVSyRy8k-2k
    wEI3FoDskrrd76B9Q4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtjedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:TMeCZIwY2slRXXTxQHr4Qk5M89tP05TFTN6VA8eGbtR6dDZwEtPsZw>
    <xmx:TMeCZMOn3TGnwvRNFkPniN0JCK8LGWwHY3xDxKJj_J3J3MOj0IivmQ>
    <xmx:TMeCZF9kIV695peYhJ1Bu_eVxkJ9pPeu7x3PmSs_XbbLoDE-D1HFIA>
    <xmx:TceCZIn9-vehwY_yRzCpIyi511V_D7-13ibo9GBSdYzJvCSUngUBJg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 57799B60086; Fri,  9 Jun 2023 02:31:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <7f77f31e-90ff-44ad-9646-9876f11eed13@app.fastmail.com>
In-Reply-To: <20230609104037.56648990@canb.auug.org.au>
References: <20230609104037.56648990@canb.auug.org.au>
Date: Fri, 09 Jun 2023 08:31:19 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Netdev <netdev@vger.kernel.org>, "David Howells" <dhowells@redhat.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-next <linux-next@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Subject: Re: linux-next: manual merge of the net-next tree with the asm-generic tree
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023, at 02:40, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   fs/netfs/iterator.c
>
> between commit:
>
>   ee5971613da3 ("netfs: Pass a pointer to virt_to_page()")
>
> from the asm-generic tree and commit:
>
>   f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")
>
> from the net-next tree.
>
> I fixed it up (I used the file from the former and applied the patch
> below) and can carry the fix as necessary. This is now fixed as far as
> linux-next is concerned, but any non trivial conflicts should be mentioned
> to your upstream maintainer when your tree is submitted for merging.
> You may also want to consider cooperating with the maintainer of the
> conflicting tree to minimise any particularly complex conflicts.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 9 Jun 2023 10:35:56 +1000
> Subject: [PATCH] fix up for "Move netfs_extract_iter_to_sg() to 
> lib/scatterlist.c"
>
> interacting with "netfs: Pass a pointer to virt_to_page()"
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  lib/scatterlist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index e97d7060329e..e86231a44c3d 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -1237,7 +1237,7 @@ static ssize_t extract_kvec_to_sg(struct iov_iter *iter,
>  			if (is_vmalloc_or_module_addr((void *)kaddr))
>  				page = vmalloc_to_page((void *)kaddr);
>  			else
> -				page = virt_to_page(kaddr);
> +				page = virt_to_page((void *)kaddr);
> 
>  			sg_set_page(sg, page, len, off);
>  			sgtable->nents++;

The fix is correct, but I think this should just get applied
in net-next directly, on top of the f5f82cd18732 commit, it
will have no effect there but avoid the conflict.

    Arnd

