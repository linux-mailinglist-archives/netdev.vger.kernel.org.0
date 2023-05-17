Return-Path: <netdev+bounces-3166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE749705DAC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7EE01C20D5E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CFC17D0;
	Wed, 17 May 2023 03:03:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D58E29105
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:03:03 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A12524D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:02:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae3c204e0aso2860505ad.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684292573; x=1686884573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CU/7LK5pMpPYhPcZWGpb4hnh1/ZMcRTvvD4DfFq0OUA=;
        b=KFu85lh3FJzUeyVN9Yfp/zt3kWp/H4gpUuf/jMkBxN2sFZZ9Rn3xM6elzm0Sgq3rdj
         NolGuRqQowjQWHJK44hfoZdBEGduu84FSBWb+hguc25s5EJgOCeoAwZwYCH23Dmdp0z9
         kncEmlDW+5dsNmf8++sVekbnbFrs/7oOparHcMfveMkRAR79vV1nxQBd7dXI8/NaaM/w
         9NuvrYHsXIuC1RQqTG3ceEdfsvK2LzSP6Jb3mAN9731nL5u9234/9BZ/4r2u9j0LmnY9
         +zWFxvoHCYGCdIEyAKJfSDcbrvU+N+nu07KtTss5VnSAbHmJPbjoTuS3oOiGUMkhjmky
         pWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684292573; x=1686884573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CU/7LK5pMpPYhPcZWGpb4hnh1/ZMcRTvvD4DfFq0OUA=;
        b=SvgYALOIS6pie+XAlqREkNp1lsz6M47olm2wQOc8/s+Z6mVuI1fLFrvKSZqvDqo0HZ
         yq+brwv4vCIwhyhx9k8STgc2GIYqsCWH2dR8uJON3WvMEP+Bu292zaUlLGyrlOMw5+Eu
         MHjDvi82VpmV9w2Z8m0ddlzFdk8yQJC7eaEuLbBSlILFQs5Qd6VcmSklfK6DRGvTjlf6
         kNdSC6LfQsWqO9g9PpjUuQZp6Kr0xquDfwiths9Hz1QNlLPU8jBfQSpEaHnRJoTw3S1L
         Ni8c8SvkzfrdZVojyfePEXAlI2vqhPKy0JOQDNF4Yr3bP1CaWF40CwpzcMngtJCTyEhD
         56wg==
X-Gm-Message-State: AC+VfDykzuZjEGbC5aLY4nSYRrPerGtbzcLTqI9/7BI99NB9ChEoYOhX
	j/ml2I7E1KXWH9IIjLHsP4C1wEvV2LR5gaZz8EAIbQ==
X-Google-Smtp-Source: ACHHUZ7om7tzR0cpRiHGWgNb0L0P4P7iky3H8jP5r1noN3EGXMZ5juSvO+vkz3Bkrxd/zYyq9XQsUg==
X-Received: by 2002:a17:902:d488:b0:1aa:e5cd:6478 with SMTP id c8-20020a170902d48800b001aae5cd6478mr53049674plg.58.1684292573569;
        Tue, 16 May 2023 20:02:53 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001a68d45e52dsm16224047plb.249.2023.05.16.20.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 20:02:53 -0700 (PDT)
Date: Tue, 16 May 2023 20:02:51 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Thorsten Glaser <t.glaser@tarent.de>
Cc: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
Message-ID: <20230516200251.444f633f@hermes.local>
In-Reply-To: <3a4b33a1-5dc5-ac66-c5ee-679ff560fd8@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
	<20230427132126.48b0ed6a@kernel.org>
	<20230427163715.285e709f@hermes.local>
	<998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
	<877ct8cc83.fsf@toke.dk>
	<b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
	<87y1loapvt.fsf@toke.dk>
	<20230516160111.56b2c345@hermes.local>
	<d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de>
	<20230516164423.3e5b45e9@hermes.local>
	<3a4b33a1-5dc5-ac66-c5ee-679ff560fd8@tarent.de>
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

On Wed, 17 May 2023 01:47:10 +0200 (CEST)
Thorsten Glaser <t.glaser@tarent.de> wrote:

> On Tue, 16 May 2023, Stephen Hemminger wrote:
>=20
> >Sounds like it could be extension or part of existing netem. =20
>=20
> No, it does so much more=E2=80=A6 very extensive reporting to userspace
> using debugfs/relayfs, for example, and very specific extra
> behaviour. We did look at netem, but it caused trouble.
>=20
> bye,
> //mirabilos

The bottom line is the upstream kernel is very unlikely to accept
an knob that is only useful with a non upstream kernel component.

