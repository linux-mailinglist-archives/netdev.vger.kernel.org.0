Return-Path: <netdev+bounces-9699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D4E72A434
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFC64281A41
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161C02262B;
	Fri,  9 Jun 2023 20:15:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F7E408CF
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:15:54 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2BA30F1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:15:52 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F07393F15D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686341749;
	bh=j0obZYvF5npFEANWqiJVq0rgTcDAftz4pIbks69KDts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=en+t3j0FjcaG/ThIXW9UJpAFw4p1u3ICor5KBNW4IMwjTm83XllOrR+4exRUhfAgv
	 8FXQyRerittpJS4rrTmOloLr8/Weizq7rM4UqGO/xgDEdTpKKNLi8m5ILiczmyI1eX
	 T5Sldkw6rp5SKggJHtubRP3/d9Od+AGyJjv1YQWqMbvovUkMbx8yEMr6ogWeyA8HO/
	 TLNEXlwcZSdw1ghD24pwOqPKlasTMPf1+0s+AzAuoWCxygzdZsEcSQ/0341jRWR+yM
	 orxpETXdH+HChjfMPZGgws11bL1J2niYL0SETBIPv0wwmUM+xsONogVPoqK7+CJ5Ue
	 9LzrrzTZYN83g==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-96f4d917e06so372504566b.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686341749; x=1688933749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j0obZYvF5npFEANWqiJVq0rgTcDAftz4pIbks69KDts=;
        b=lI8KwqkSWMJaqySwyjuuuGdwe4RjbKBueUyHj0L/iGVhbv/+AVuMNiDUT9z06QGU6O
         nnOXtjiZ1P2kJT5RyVhM56b4zrLGbzAEnFQ9zAunO9D80Fc8HcsQETNWjG9i4YQI2UKj
         9LyvibjBpgetC3klCKHYE9HIZ4eKOFzodN8VOeEZk5DPFa8fPkq8U/SW8/vV9noVUzsF
         gZQ6ohhP7pIReStRcQFVPoH/d9BJAp4H3uibT7/2b2R6+BPdwNiixYo+YxQ8xfMTfSSN
         RP3owp/YbrkU7nshjiNPoKDUwEvfbgaAG6e4g0N++MGkJh8WvW1bDQqRic4Hbs6yNNks
         vnEg==
X-Gm-Message-State: AC+VfDz8Uup3KbfaEb5v+EAsavUSVEMQoe7yJs1vDn82NcZqr9frkM43
	s+eE9c1ru88e6xGSii3vFO4acitjMNMl7dSZwD4r/VSHHHA7v6aAGQcDwlCPCTlOl7GipoK9WJl
	pxB9YbW5eJMqVENtS9+xiQq/Zt2TV7SVvICfvFc4JxSypqH6qqg==
X-Received: by 2002:a17:907:2d25:b0:978:8685:71d5 with SMTP id gs37-20020a1709072d2500b00978868571d5mr3453879ejc.30.1686341749601;
        Fri, 09 Jun 2023 13:15:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7voUPKBcau3WbBBCC3ecETNfAN9X7oKja2XDW+v2aCad+ilWsGH2OpuP96F3DEC902VAO+n3N1GLBO5MWkRNE=
X-Received: by 2002:a17:907:2d25:b0:978:8685:71d5 with SMTP id
 gs37-20020a1709072d2500b00978868571d5mr3453861ejc.30.1686341749377; Fri, 09
 Jun 2023 13:15:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609164324.497813-1-magali.lemes@canonical.com>
 <20230609164324.497813-2-magali.lemes@canonical.com> <20230609105307.492cd1f2@kernel.org>
In-Reply-To: <20230609105307.492cd1f2@kernel.org>
From: Magali Lemes do Sacramento <magali.lemes@canonical.com>
Date: Fri, 9 Jun 2023 17:15:38 -0300
Message-ID: <CAO9q4O1SctX1323-8JDO0=ovsLfNpv4EjOSdP_PwYDJ76tAQiQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] selftests: net: tls: check if FIPS mode is enabled
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com, 
	andrei.gherzan@canonical.com, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi, Jakub.

On Fri, Jun 9, 2023 at 2:53=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Fri,  9 Jun 2023 13:43:22 -0300 Magali Lemes wrote:
> > diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftest=
s/net/tls.c
> > index e699548d4247..0725c60f227c 100644
> > --- a/tools/testing/selftests/net/tls.c
> > +++ b/tools/testing/selftests/net/tls.c
> > @@ -25,6 +25,8 @@
> >  #define TLS_PAYLOAD_MAX_LEN 16384
> >  #define SOL_TLS 282
> >
> > +static int fips_enabled =3D 0;
>
> No need to zero init static variables, but really instead of doing
> the main() hack you should init this to a return value of a function.
> And have that function read the value.
>
> >  struct tls_crypto_info_keys {
> >       union {
> >               struct tls12_crypto_info_aes_gcm_128 aes128;
>
> > @@ -311,6 +317,9 @@ FIXTURE_SETUP(tls)
> >       int one =3D 1;
> >       int ret;
> >
> > +     if (fips_enabled && variant->fips_non_compliant)
> > +             return;
>
> Eh, let me help you, this should really be part of the SETUP() function
> but SETUP() doesn't currently handle SKIP(). So you'll need to add this
> to your series:

May I add your Suggested-by tag to this upcoming patch in this patchset v3?

