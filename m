Return-Path: <netdev+bounces-3130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D510705AE1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37256281341
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBE5DF6F;
	Tue, 16 May 2023 23:01:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E8E101CE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:01:18 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8358187
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:01:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6439bbc93b6so37044b3a.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684278073; x=1686870073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bejVAoeOa0aCqPR6qHsLhlT3O+HtwpVeH88/QpSRfWw=;
        b=IE8I6qp8ydxRb5Oyw8nBKr2YaeKTfQSzvGYC5W9UvuLGKM5MWMfdY69qLEOV+iSEcY
         ZnvRz2kG9dC3mLdMf+yX6/vffirjxkRxM2lyev4mkHxPE3Fm7jhnRb4Tbvt+6MhLBBUF
         n0X42pxppJJzYB8sdP+IKhnpPbqBpPsFT/IRPl7ShSiLYC6FuCIkKjVqmwx7dnSexAa6
         EuoPRjjaQKcNqLGmM0BEv9Ge7Z/CA1zeV8Bj48g9bCU3oV9Y8fmOTr3ylVXEho8Fj5Az
         JoBe6QMJuMpkK3Pmi1SeRF0snoRQesyYGOE9f+cjUYrLgbXaNJdDHOBYi8H4ZVKv+nww
         QIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684278073; x=1686870073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bejVAoeOa0aCqPR6qHsLhlT3O+HtwpVeH88/QpSRfWw=;
        b=YLNJfJwk5m5wqia9+cOV6e1YEpUmR5HMv9vjVJGYsH4XOI8K0lyxp9BbiTGBV2Skuq
         1odRqWRVxuxelNt9+FJBLVTYgmvp/pJtuIZLel5eJRKTZCvL3eQPsSFMkMpr6PLPPDET
         +alpdbsMKfp3tHb4pO1Sp+Nowdd1G0ElqYpfH5pr/65+bykQmtT30qwLcVyqeKoChQUg
         JGk0Qd2K7MrNCWeWDd8R9z6kueFsphz4jUMT3dsRcGkwwKo6XLE16uicXTt5LhaVjl5A
         tc/IbLCN/izCIE/mhLd9G8XJrDdExSwnOjpNaHomnzORGhNHd9We08eRreshRBLO/44J
         OS1g==
X-Gm-Message-State: AC+VfDzf+ZowJukJuSMvYwb0ih3JbsD2rJDqfvA8pCXz5mudPUg9PRac
	5Hz1mhHafsL4lKlugz0EViFcJA==
X-Google-Smtp-Source: ACHHUZ42oQuvAAxuuPVNdd2BbnMCxFfNsV/HdlHPAZnmghE2A/YHv7L9asGbF+ZQbzKCHDeNpyGJMw==
X-Received: by 2002:a05:6a20:a10c:b0:107:6f3:707 with SMTP id q12-20020a056a20a10c00b0010706f30707mr4144632pzk.29.1684278073336;
        Tue, 16 May 2023 16:01:13 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c1-20020a63da01000000b00528e0b1dd0bsm14121835pgh.82.2023.05.16.16.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:01:13 -0700 (PDT)
Date: Tue, 16 May 2023 16:01:11 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc: Thorsten Glaser <t.glaser@tarent.de>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
Message-ID: <20230516160111.56b2c345@hermes.local>
In-Reply-To: <87y1loapvt.fsf@toke.dk>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
	<20230427132126.48b0ed6a@kernel.org>
	<20230427163715.285e709f@hermes.local>
	<998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
	<877ct8cc83.fsf@toke.dk>
	<b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
	<87y1loapvt.fsf@toke.dk>
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

On Wed, 17 May 2023 00:11:02 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:

> Thorsten Glaser <t.glaser@tarent.de> writes:
>=20
> > On Tue, 16 May 2023, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > =20
> >>Pushing stuff into a
> >>qdisc so it can be ECN-marked is also nonsensical for locally generated
> >>traffic; you don't need the ECN roundtrip, you can just directly tell
> >>the local TCP sender to slow down (which is exactly what TSQ does). =20
> >
> > Yes, but the point of this exercise is to develop algorithms which
> > react to ECN marking; in production, the RAN BTS will do the marking
> > so the sender will not be at the place where congestion happens, so
> > adding that kind of insight is not needed.
> >
> > Some people have asked for the ability to make Linux behave as if
> > the sender was remote to ease the test setup (i.e. require one less
> > machine), nothing more. =20
>=20
> Well, if it's a custom qdisc you could just call skb_orphan() on the
> skbs when enqueueing them?
>=20
> -Toke

If your qdisc was upstream, others could collaborate to resolve the issue.
As it stands, the kernel development process is intentionally hostile
to out of tree developer changes like this.

