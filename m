Return-Path: <netdev+bounces-3137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17821705B74
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACBC22811FF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB821095C;
	Tue, 16 May 2023 23:44:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F3E29119
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:44:27 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102F55580
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:44:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aaf21bb42bso1745045ad.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684280665; x=1686872665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAyBObAKQCsW2bNof9apeF0ebKn9WsBOpPNVGFm4nXE=;
        b=nDVeFb5TN5PXuONfOCeOhexEFSFRQ0hvoEz3jdoDUHtlRyZqNstrKDv5mvhAIuiUEv
         reEeTf/zsJsb9BHa39kJb9gsjsVf4BoOmjgvHY7Zwm6OWR4HSx9M1Uu2dyRBWZ0yCQUx
         adpNldNXd6An2KVxXAMJtrsJWb1b7H1cOMLi6Ca8s0EB3Pbx+jaPGk8623F00FOhcvKJ
         GMqr1gn3xQonTQ+x33W8sZAwn7pWH6BrjAEvStNxsiQDKDm5gdmyw9JcHqGfHFbzPMp6
         KtZ8v0o+wPWYR68qjo/Uenqu0jgao0fjQyS6FWjQu0HN1iOq8xFQucQgvsR7Izf7TZ/p
         YZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684280665; x=1686872665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAyBObAKQCsW2bNof9apeF0ebKn9WsBOpPNVGFm4nXE=;
        b=OaKYDicq3vFGGU65TkzALMEzgecwB2OEK2tPi7gVhKIJR7m5g9hNs+u/aPnOO6cyLR
         EA7PHRBbdSu+4t5JN8yXcAAqe/zUzWjZ2RFnAxX/iB0t0icFHjatji8CuAj77weWaZc0
         fpcbPN2F5ccOpiMl7SNktZOz4fEWA33eIpD3p2icHUrXC8jpDYL4ZtH8C0dUh+eHC1vN
         kjyU0MRDg+De8zx2s2yq1IGV3q31zxdDx2T9kZ+M2LGMB7oCnhtUJw92EqG7M8S7oORU
         A+AGKyr6cL75VlzWtOrmpB3//YJ0gcmVuHHyqYVPrQbFCFRwpxXyLptQLAw1eCpv2qBD
         Rv6g==
X-Gm-Message-State: AC+VfDz0W/A7BADFM52nBVJhhKrCyGHTTnLTqwtvtC1TT/8ReS9Pft0z
	KqumHooUWbsCs8XSb4hpfAnFiQ0AyEEAdSHu4fSrrw==
X-Google-Smtp-Source: ACHHUZ5Ohhx83ysYdikJu2mg2rDZyEdGgGFCNUKbkoyBV7NoW8wzF/+Uqk3kXWOz8Zh+n/4/BBh4QA==
X-Received: by 2002:a17:903:44b:b0:1ab:f74:a111 with SMTP id iw11-20020a170903044b00b001ab0f74a111mr39028455plb.63.1684280665446;
        Tue, 16 May 2023 16:44:25 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090311cc00b001ae1a35eb35sm4916110plh.178.2023.05.16.16.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:44:25 -0700 (PDT)
Date: Tue, 16 May 2023 16:44:23 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Thorsten Glaser <t.glaser@tarent.de>
Cc: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
Message-ID: <20230516164423.3e5b45e9@hermes.local>
In-Reply-To: <d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
	<20230427132126.48b0ed6a@kernel.org>
	<20230427163715.285e709f@hermes.local>
	<998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
	<877ct8cc83.fsf@toke.dk>
	<b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
	<87y1loapvt.fsf@toke.dk>
	<20230516160111.56b2c345@hermes.local>
	<d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 17 May 2023 01:40:23 +0200 (CEST)
Thorsten Glaser <t.glaser@tarent.de> wrote:

> On Tue, 16 May 2023, Stephen Hemminger wrote:
>=20
> >If your qdisc was upstream, others could collaborate to resolve the issu=
e.
> >As it stands, the kernel development process is intentionally hostile
> >to out of tree developer changes like this. =20
>=20
> The qdisc is a simulation for the network connection of one
> 5G UE. It=E2=80=99s not suitable as general router qdisc. I doubt
> it would even be considered for acceptance. The kernel
> upstreaming process is not the least hostile either=E2=80=A6


Sounds like it could be extension or part of existing netem.

