Return-Path: <netdev+bounces-11452-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0226B73327F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7191281761
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A4E18C0C;
	Fri, 16 Jun 2023 13:49:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC715484
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:48:59 +0000 (UTC)
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FF03A9B;
	Fri, 16 Jun 2023 06:48:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-bcde2b13fe2so618762276.3;
        Fri, 16 Jun 2023 06:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686923322; x=1689515322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+ALjwuIjo81w/4R8KsLZNNUfz2uY+fiGHuf00nHwyU=;
        b=BQFAGexgSmdiEBrT4QToXIp1FpWh0ZX2IGSf1djtIgsTawpZnPpGIqEsur3P4TqNpI
         38ZWsWJU+++BrkOJZ9xRzWyk++gIrIuKRk5lM+RzkRbU9jreLEy/HisidnPVPRNGIH3E
         ISURMlyJHajQZpZshhXpiYENxTgI7HsLxxKH8vDMhGEyBH+baRUMtUMI0LWA1t+00oKb
         PUNyd2mktnr5Npf8wEQgNEx/Oyc9nErsmfZ9rXO8AJMpLEfJ1yrqdjL1JBvg07oLM7OE
         cv4Y3GbdzgsII0zgdnD3Gt2wGeMwh8R7oGd3hG/Rm5ox/lKDvvKVuCZXlrjdbIEp9Yi6
         fcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686923322; x=1689515322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+ALjwuIjo81w/4R8KsLZNNUfz2uY+fiGHuf00nHwyU=;
        b=JO9XwRnldeNsdp61YGH+yDaZycE0V43IevZMFqzwJVzBqZ0zGBsdVR2VnAUvRH9rdj
         uiiuAx5/2FnZwGvIsT9Q4yrqCywv5pPhoBdEuWK9d93Z4N9gluY+d9DJF64v2050l5PC
         RlruGPvqlDM3cOLNmTBXSPLxqBLF5yp0Bomepw3Br0bpGXx9Hy2K4pEr1t4fUppCeuRO
         SQRwBVORq5acG5/yUb8PHkg4Ogl7T3OZs/+j7IsWDH2ZGIYU4NCykYhApZzdtZwPYxNl
         FsuhAeiPOz0xTwQjv/6nMPcDDg5wqRAXPndubCVPSsxUZ02YMXhq09uEiKEk7kBVfCUu
         Dt4g==
X-Gm-Message-State: AC+VfDw8reulkbPz0G/oCFLs9nLSxKMFLNqILOkxg/49mhw0IEVAUdpr
	8lqHhHLMTS69PkTDq/RUeinzXuetauKnDq2T174=
X-Google-Smtp-Source: ACHHUZ4CuhqrfyjDMjscbW1ryFfDrlUXI4bGf+PKJtM2HH5FwvQedZFj+T4/i9ibmaSgNW7yygcWngJKvntq1K4e2K4=
X-Received: by 2002:a25:fb0b:0:b0:bca:c5d4:6b5e with SMTP id
 j11-20020a25fb0b000000b00bcac5d46b5emr1740668ybe.34.1686923322087; Fri, 16
 Jun 2023 06:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614230128.199724bd@kernel.org> <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org> <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <f28d6403-d042-4ffb-9872-044388d0f9d9@lunn.ch>
In-Reply-To: <f28d6403-d042-4ffb-9872-044388d0f9d9@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Jun 2023 15:48:31 +0200
Message-ID: <CANiq72mMi=7P9OxSH0+ORYDEyxG3+n5uOv_ooxMJ72YRBRZ+PQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Andrew Lunn <andrew@lunn.ch>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, kuba@kernel.org, netdev@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, aliceryhl@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 3:14=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> I think this is something you need to get addressed at a language
> level very soon. Lots of netdev API calls will be to macros. The API
> to manipulate skbs is pretty much always used on the hot path, so i
> expect that it will have a large number of macros. It is unclear to me
> how well it will scale if you need to warp them all?
>
> ~/linux/include/linux$ grep inline skbuff.h  | wc
>     349    2487   23010
>
> Do you really want to write 300+ wrappers?

It would be very nice if at least `bindgen` (or even the Rust
compiler... :) could cover many of these one-liners. We have discussed
and asked for this in the past, and messages like this reinforce the
need/request for this clearly, so thanks for this.

Since `bindgen` 0.64.0 earlier this year [1] there is an experimental
feature for this (`--wrap-static-fns`), so that is nice -- though we
need to see how well it works. We are upgrading `bindgen` to the
latest version after the merge window, so we can play with this soon.

In particular, given:

    static inline int foo(int a, int b) {
        return a + b;
    }

It generates a C file with e.g.:

    #include "a.h"

    // Static wrappers

    int foo__extern(int a, int b) { return foo(a, b); }

And then in the usual Rust bindings:

    extern "C" {
        #[link_name =3D "foo__extern"]
        pub fn foo(a: ::std::os::raw::c_int, b: ::std::os::raw::c_int)
-> ::std::os::raw::c_int;
    }

Cheers,
Miguel

