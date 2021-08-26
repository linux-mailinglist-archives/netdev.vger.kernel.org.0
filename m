Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ED23F8026
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhHZCCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:02:04 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39617 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235823AbhHZCCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:02:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B7188580CE0;
        Wed, 25 Aug 2021 22:01:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 25 Aug 2021 22:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9Lblrn2BT0Jd/icnrpR5neglPUt
        Iw7/fSLXohtJXh1g=; b=PI3hNXIvkeIqgigp6+UIPp142t1bolz3NgpIuYUchYk
        rU63wxKi6dvvtlvGGJsEwXT0uLVMOjb/QMnTKg5Km3zXvX4XH4MYCePbGdm4GXrJ
        dQjZMsxb6N1RJYZO8OKB4IcRR2emVEclmVf60o3DUUpgTPgabomyr7AibwwRdJPv
        PkEK9gLDmbcCwDpQIwp55vQ3O02sv+PSJdenzmAuToG6ahhVpv9zfGmA5rdeqhVg
        ArcHA1DoB5zegEfUtih23n5BqANqdEZB1Srb8HrwYrnU9gqQgzhvvX3VxMthJmQc
        H6zTIipJe/BJ0CMnnMn585+GQ7eEnqz+EqY5VoZWk9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9Lblrn
        2BT0Jd/icnrpR5neglPUtIw7/fSLXohtJXh1g=; b=rpVHmLPbA8uXLrib1Z2ogs
        fV+Ha9VYsk8AKRR2z6Xa3qP4T/RPY4EYcR9JKR417uhxMifwpeDdiRes9ImEwfCQ
        9tSlBA80+UuLSbJE7Um3niIG551qmy04r3Psi8dVLyERoY0OIf4t5+lMQu8QCAeM
        CaoytN8wPGSr0ijOO03W6TxBHQxJeRvPV/cbtPpklkwMxlrBoj3/FTr4CI7VWYg7
        i33yWfG1/7FXNiN09G4fJaqfvCDaW8+yGAlLyq0XNr3/O+xCYZVuiUG/geh8PWCW
        utmg6hCf8kA9uGovRnLqCIcY2iQ/fbdBKCsypTqCkE80hgphPm3HEyfaQVtP1thA
        ==
X-ME-Sender: <xms:6fUmYfHYe8-xDtMP4be3d5vczvNoAWYjW3yDjFYiB_RLIZn-OXuuXg>
    <xme:6fUmYcUAxuBPLrVngV15paqtOFS7PJSnjl1sS8jiEdJpCnyABMctH9cG1PIcwrfnx
    qYSJqLo2FzUUJwrQw>
X-ME-Received: <xmr:6fUmYRKq-xsPXjydqmt24Ffg_Wp_e3XWclRPgafcg64HbW3gjyXlOO8wan068lNUEzb1ZFB8Rxel_k8MLkXao32dYrfkuqaIC3IIuScRxu6LVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddutddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenogfvvgigthfqnhhlhidqqdgigeduledqvdekudculdef
    tddtmdenucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepff
    grnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhn
    peeutdduheffteejjeeuleeluddvfeetueelhfejgfehtdetvdevfeffgeektdejudenuc
    ffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:6vUmYdEBb64m4iWu6DuvL5cDhp7eRkOhdwz9eConPs2IVvU3ODAGmA>
    <xmx:6vUmYVVQ1SdUsAEkUHqLXihr3gIGpItpkJmbJSFbqSXlO0DGB98lWA>
    <xmx:6vUmYYMuQuHPnGGq0aB1T0vRbeslfZkPO5fqLrEq8ths3Io3u2_LKA>
    <xmx:6vUmYbycTNH5qnWD5b6P8TXva5jA95zQQGKSkR_3lXqPwsSgwg0AbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Aug 2021 22:01:13 -0400 (EDT)
Date:   Wed, 25 Aug 2021 19:01:11 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210826020111.l5v3dsr2onbz6zte@kashmir.localdomain>
References: <20210826115050.7612b9cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826115050.7612b9cc@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, Aug 26, 2021 at 11:50:50AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/trace/bpf_trace.c:717:47: error: expected ')' before 'struct'
>   717 | BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>       |                                               ^~~~~~~
>       |                                               )
> kernel/trace/bpf_trace.c: In function 'bpf_tracing_func_proto':
> kernel/trace/bpf_trace.c:1051:11: error: 'bpf_get_current_task_btf_proto' undeclared (first use in this function); did you mean 'bpf_get_current_task_proto'?
>  1051 |   return &bpf_get_current_task_btf_proto;
>       |           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |           bpf_get_current_task_proto
> 
> Caused by commit
> 
>   33c5cb36015a ("bpf: Consolidate task_struct BTF_ID declarations")
> 
> I have used the bpf-next tree from next-20210825 for today.

Sorry about the breakage. I've put up
https://lore.kernel.org/bpf/05d94748d9f4b3eecedc4fddd6875418a396e23c.1629942444.git.dxu@dxuuu.xyz/T/#u
which I think should fix it. Can you give that patch a try?

Thanks,
Daniel
