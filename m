Return-Path: <netdev+bounces-8208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E037231F9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9090281427
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB020261FB;
	Mon,  5 Jun 2023 21:11:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4031323E;
	Mon,  5 Jun 2023 21:11:43 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A404ED;
	Mon,  5 Jun 2023 14:11:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2565a9107d2so4561552a91.0;
        Mon, 05 Jun 2023 14:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685999501; x=1688591501;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zh4jJxTAKzbJ9SX27hDt/5kPD49tOPRL7suMPY4/khA=;
        b=HQ7E4KTQocAnFq6ymEbiyQe+71wz1QqkMTqstF6yByE1aQ/3L9xGlsoHE2ty/KmNGx
         kkEIZdBdUpFN5pBuGWGPof3JHvwTsAFbFOBh8LvcbfvZDQcWxan7GhR3qRzMUhCbsynv
         VMO/o8hLS0MUfiw6kmRJdp5TDSqJf1Z98tzNg0TBILGUxmterYeS+YBt+Dmye8jo/cGp
         xxgae6ukPX27OAi5ZxAJI04J0vRi0aYxFh2wrhremSn2C6an+j6jLOUDoZZnWpJAGoFM
         QcM8CesR+0JfQo9SpvdWxAM1li3oZzB0tJjW4MpOn6edHy3LBmjFeUMOqWOY59vgg4DJ
         JYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685999501; x=1688591501;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zh4jJxTAKzbJ9SX27hDt/5kPD49tOPRL7suMPY4/khA=;
        b=GW0+fjMMwHvn/EUwctN+yNljKAGIzWHs8mQ2TQ9xwKHzWXX8xA+25xqMgpX3ksUsLO
         dSUDEC4eHITWu2mX07+7MQHvOz7mDIY9acicwIk3jzAl5MfSUM9l1B1yNCzBXB6mxDMC
         B9drTk8qLxI1Nt/aEcw0mmlIIUKXqSi3gIs7iLdXYPr9MuFphU8/zwQsspmy040Dmnfh
         9gvD9aV608+UhTexp4yNDNavub2dhRIziYocETy2PCZ6wOk5CGIC+CiAiVHQlLRECwIl
         OD75x9nlKcgi5z+/fEEeped4MA9cPAW1VRe2//N99eR219ZFCQ/wPncb/jv2ylYcuN/B
         MY+w==
X-Gm-Message-State: AC+VfDxeOaomLjcMbmPj3aD2xU2svtNHmsaw6gyzCY236Q0/4+sAsyxy
	1AIZ9WY13/Hrkx9Hs3FVQg4=
X-Google-Smtp-Source: ACHHUZ7ezCBLFh/r5MtsTw99vS986tpwZwM/H7CRc906oLC1p2PgTYZQRvrDYW2mCxZli0+0MYt3BQ==
X-Received: by 2002:a17:90b:1c06:b0:258:9180:1999 with SMTP id oc6-20020a17090b1c0600b0025891801999mr8816659pjb.32.1685999500386;
        Mon, 05 Jun 2023 14:11:40 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id gz18-20020a17090b0ed200b00246f9725ffcsm6255974pjb.33.2023.06.05.14.11.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Jun 2023 14:11:39 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>
Date: Mon, 5 Jun 2023 14:11:26 -0700
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "rppt@kernel.org" <rppt@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "deller@gmx.de" <deller@gmx.de>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>,
 "christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
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
Message-Id: <B021EE82-9741-4B41-8FF7-91A9336EDD7C@gmail.com>
References: <20230601101257.530867-1-rppt@kernel.org>
 <20230601101257.530867-13-rppt@kernel.org>
 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
 <ZHjcr26YskTm+0EF@moria.home.lan>
 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
 <ZHjljJfQjhVV/jNS@moria.home.lan>
 <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
 <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
 <20230604225244.65be9103@rorschach.local.home>
 <20230605081143.GA3460@kernel.org>
 <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 5, 2023, at 9:10 AM, Edgecombe, Rick P =
<rick.p.edgecombe@intel.com> wrote:
>=20
> On Mon, 2023-06-05 at 11:11 +0300, Mike Rapoport wrote:
>> On Sun, Jun 04, 2023 at 10:52:44PM -0400, Steven Rostedt wrote:
>>> On Thu, 1 Jun 2023 16:54:36 -0700
>>> Nadav Amit <nadav.amit@gmail.com> wrote:
>>>=20
>>>>> The way text_poke() is used here, it is creating a new writable
>>>>> alias
>>>>> and flushing it for *each* write to the module (like for each
>>>>> write of
>>>>> an individual relocation, etc). I was just thinking it might
>>>>> warrant
>>>>> some batching or something. =20
>>=20
>>>> I am not advocating to do so, but if you want to have many
>>>> efficient
>>>> writes, perhaps you can just disable CR0.WP. Just saying that if
>>>> you
>>>> are about to write all over the memory, text_poke() does not
>>>> provide
>>>> too much security for the poking thread.
>>=20
>> Heh, this is definitely and easier hack to implement :)
>=20
> I don't know the details, but previously there was some strong dislike
> of CR0.WP toggling. And now there is also the problem of CET. Setting
> CR0.WP=3D0 will #GP if CR4.CET is 1 (as it currently is for kernel =
IBT).
> I guess you might get away with toggling them both in some controlled
> situation, but it might be a lot easier to hack up then to be made
> fully acceptable. It does sound much more efficient though.

Thanks for highlighting this issue. I understand the limitations of
CR0.WP. There is also always the concerns that without CET or other
control flow integrity mechanism, someone would abuse (using ROP/JOP)
functions that clear CR0.WP=E2=80=A6


