Return-Path: <netdev+bounces-7269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D712671F6E4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E75B1281952
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F43451805;
	Thu,  1 Jun 2023 23:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18E710FA;
	Thu,  1 Jun 2023 23:54:56 +0000 (UTC)
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA27619D;
	Thu,  1 Jun 2023 16:54:50 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-38dec65ab50so1235082b6e.2;
        Thu, 01 Jun 2023 16:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685663690; x=1688255690;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uq+xoVGoOBMASX6Qo6F/Chq5PaVghrBgpVyIfFrv3Do=;
        b=hQ0RCKA9jRCKnGCyO2kN3QTLC3yb+Mdefo52tmuodc7Rt84YU9NlyduoNwqz+Q967d
         V7uBGj6VWFgr8YM6btVxO0XdtNVoooAp04klqJfE2ZmBUTlaUrv5ESo1tluojxtb/P0b
         IXsvFxgfg/85GYZ9MIdxPzQ2yHr/de4bqkKek71QIfTGQZKS+sL+6FNopqB/1pl5gZdM
         9SlKfIAzGLZNhvxUgWL+XEi7FhwDSsySWQZgNcWM1R6l7k6VA58bq3RnIGKXMDknOFde
         ITMFH1EZ3IUbIVWsPaSYfWLIZRF8wgeqkPJHfjZqlj6I94YsQOh8SKgp5f7sF92n6NGq
         pQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685663690; x=1688255690;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uq+xoVGoOBMASX6Qo6F/Chq5PaVghrBgpVyIfFrv3Do=;
        b=h8K8gbXAuc497NQrYS2pUsgrjZzBw5+DvHajipsD80jUM54A4FoCGd9er2lc+g4eMq
         MW4onVaM+C60RIrfrt9KDZ2Xva/mULB+hrZ9zV4Y2HmboEycRxijjl/D3+/HBhNpLobz
         lK7xEkPbf8tUbuY+ebaq7T8TkOw0jED8R/iZmDuUAdfrn3oO/O9HNhFUOup7a6PXOpHY
         UHJl7YPsY0x/HGibyleFTQ1Y1Xn6eeKFHG52GRTLQnnmgk03lfmZtdJHus3SgKWkBuAV
         RoIkN/+U2Eqv+QdJ9VwEtIZk9xiEz2VLx2S5+hpbaOHJWBvTPxiIdCjlf74VdbDWkchs
         osnQ==
X-Gm-Message-State: AC+VfDy2RojbhTUi04oxIrKYNZVepTNpnva2DThhR974fLGwGTf0dUpl
	6OjMnM45qBjIaA1PP/yUn7M=
X-Google-Smtp-Source: ACHHUZ6FGoT9AAhqdl4GKiokh7jtAU2ufEnyUr4RvYWwArHNvXyiDuy+wWqdSoxg1oPDBs7mS6RMxw==
X-Received: by 2002:a54:4604:0:b0:399:55c9:6f20 with SMTP id p4-20020a544604000000b0039955c96f20mr610729oip.52.1685663689890;
        Thu, 01 Jun 2023 16:54:49 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902d38200b001aafa2e212esm4074977pld.52.2023.06.01.16.54.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jun 2023 16:54:49 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
Date: Thu, 1 Jun 2023 16:54:36 -0700
Cc: "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
 Thomas Gleixner <tglx@linutronix.de>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "deller@gmx.de" <deller@gmx.de>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "x86@kernel.org" <x86@kernel.org>,
 "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
 "christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 Will Deacon <will@kernel.org>,
 "dinguyen@kernel.org" <dinguyen@kernel.org>,
 "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
 "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
 "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "song@kernel.org" <song@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
References: <20230601101257.530867-1-rppt@kernel.org>
 <20230601101257.530867-13-rppt@kernel.org>
 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
 <ZHjcr26YskTm+0EF@moria.home.lan>
 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
 <ZHjljJfQjhVV/jNS@moria.home.lan>
 <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 1:50 PM, Edgecombe, Rick P =
<rick.p.edgecombe@intel.com> wrote:
>=20
> On Thu, 2023-06-01 at 14:38 -0400, Kent Overstreet wrote:
>> On Thu, Jun 01, 2023 at 06:13:44PM +0000, Edgecombe, Rick P wrote:
>>>> text_poke() _does_ create a separate RW mapping.
>>>=20
>>> Sorry, I meant a separate RW allocation.
>>=20
>> Ah yes, that makes sense
>>=20
>>=20
>>>=20
>>>>=20
>>>> The thing that sucks about text_poke() is that it always does a
>>>> full
>>>> TLB
>>>> flush, and AFAICT that's not remotely needed. What it really
>>>> wants to
>>>> be
>>>> doing is conceptually just
>>>>=20
>>>> kmap_local()
>>>> mempcy()
>>>> kunmap_loca()
>>>> flush_icache();
>>>>=20
>>>> ...except that kmap_local() won't actually create a new mapping
>>>> on
>>>> non-highmem architectures, so text_poke() open codes it.
>>>=20
>>> Text poke creates only a local CPU RW mapping. It's more secure
>>> because
>>> other threads can't write to it.
>>=20
>> *nod*, same as kmap_local
>=20
> It's only used and flushed locally, but it is accessible to all CPU's,
> right?
>=20
>>=20
>>> It also only needs to flush the local core when it's done since
>>> it's
>>> not using a shared MM.
>> =20
>> Ahh! Thanks for that; perhaps the comment in text_poke() about IPIs
>> could be a bit clearer.
>>=20
>> What is it (if anything) you don't like about text_poke() then? It
>> looks
>> like it's doing broadly similar things to kmap_local(), so should be
>> in the same ballpark from a performance POV?
>=20
> The way text_poke() is used here, it is creating a new writable alias
> and flushing it for *each* write to the module (like for each write of
> an individual relocation, etc). I was just thinking it might warrant
> some batching or something.

I am not advocating to do so, but if you want to have many efficient
writes, perhaps you can just disable CR0.WP. Just saying that if you
are about to write all over the memory, text_poke() does not provide
too much security for the poking thread.


