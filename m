Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7CE4E33D4
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiCUXAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbiCUW66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:58:58 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339A52E52;
        Mon, 21 Mar 2022 15:46:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMqTq6cStz4xXV;
        Tue, 22 Mar 2022 09:46:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647902770;
        bh=H8PBqR3nVa0lXAbzk96iqy7WYNZPPnz2jeC1t20qCF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nv2gboPVn/xp89O61PpDCFVDLttqjE0/u4+agmberg9y//+EPDKRwHRdHVAx1AmOQ
         ++rsq/cFU5PPEToFobcS3s/N6XTvEsR8UtZ+9U8zwFV7vNKVjFfcedRLiu/7fuRduh
         vQaK3mxTYr3Rxs6nqmX3Qa71boFlV/N6klXxFCWpYNDjNyfCIKzkc/w5YxEpFfYtaj
         JsfEcWDlbpMdb5G6dBMhA6hR9hs7IzTA1IeqZIxp1zWen/LQ9JAQOfJYzR1lETUWht
         49XKzOxocHboQbdxTNrqxfETaOs9BbfZybA9Qymc8JSzl9Aix0AlZnhZW4gzSQR7BQ
         CZbv0zrLtbZZA==
Date:   Tue, 22 Mar 2022 09:46:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        linux-toolchains <linux-toolchains@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warnings after merge of the tip tree
Message-ID: <20220322094526.436ca4f7@elm.ozlabs.ibm.com>
In-Reply-To: <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
References: <20220321140327.777f9554@canb.auug.org.au>
        <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
        <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net>
        <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
        <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net>
        <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
        <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net>
        <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
        <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net>
        <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
        <20220322090541.7d06c8cb@canb.auug.org.au>
        <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Cu0BfOMHZbomI3JHSdJT/3a";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Cu0BfOMHZbomI3JHSdJT/3a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Mon, 21 Mar 2022 15:12:05 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> That makes little sense. It's not an unusual merge conflict.
> Peter's endbr series conflict with Masami's fprobe.
> Peter has a trivial patch that fixes objtool warning.
> The question is how to land that patch.
> I think the best is for Linus to apply it after bpf-next->net-next gets
> merged.

Peter has other concerns, please read the thread and consider them.

--=20
Cheers,
Stephen Rothwell

--Sig_/Cu0BfOMHZbomI3JHSdJT/3a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI5AC8ACgkQAVBC80lX
0GzcsAgAot0lRVnBEEWV9hhB+YPJDN1/HKUcKWm96ubGregiybHyYGuX5lmvbkyK
sF0/8tQFMMA6fK+PxkZytEtDQKbQn6/c5394HkEiJ/ISWMtFDJ8xCr3dPoU7rVG4
0BKLOkmcLGPuK7zRfBGe/xtAENj1g46CDMDKaGpJOqkABMzw9BFlQUZsGYhJDCXB
ZBMwXD88Gcz+5wVtiCJPnLHjGKj4jTxclAm7HYA0b13nb0TaxfRyIGCJekzHET34
IDMS0UjNT2JafuKj426Yqlx7Mk3sc85uwMYlkLA4pCaP+VYXyhbW1VDiaZZf/ry/
7sJceaOu3fF4RgzHXeFU7ZFbHajuJQ==
=/K55
-----END PGP SIGNATURE-----

--Sig_/Cu0BfOMHZbomI3JHSdJT/3a--
