Return-Path: <netdev+bounces-11033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A90177312DC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D747B281706
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F222A53B9;
	Thu, 15 Jun 2023 08:59:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7953B6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:59:04 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635741720;
	Thu, 15 Jun 2023 01:59:03 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-bacf685150cso1421122276.3;
        Thu, 15 Jun 2023 01:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686819542; x=1689411542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdSnvh3wJYO93aum1TupVccOH96iznS0gaHyZrrVRjg=;
        b=fLj6HJ1FFh8tKrMhebE+8UxSgyHJFKfiz1q86xTWfSSty5XmfEjge8kpLIK+yGC3Tx
         qPBYxas8xqjGnABfAYiYvPsFy87OtVrLetsVP3cnvtIaZRdl+daX9U0ykqd2o8j32xEG
         zBIIa/vM5kAFKpNNXR6ikjSb63mjXHX4IMQqNbvxSs7I3Q/jDfBMvklWF/hgH49QkKCR
         4f9sOM4rC+7swIc5O0Oi1djJ+uO/ZgirlH9uyBSIVFiWtQ1yac0a5+mPtKzglVFBu9z7
         j2+0HGiiNdddheveUaOA309I/iCDtpNM4yB9K2IIH1vGFWQ7oWAFvmp4hqPK1Ok3IxPC
         kq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686819542; x=1689411542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdSnvh3wJYO93aum1TupVccOH96iznS0gaHyZrrVRjg=;
        b=cMFBDLFumrWnjWtbx+NLTSoqD48Y46dshAkgsGeceIxT2U8gO7fiZK91iQO+TWIEJf
         nshnriU4u0KKR9fbkM0k7tB/1TJUNFP6RCo6yfqM876GswC4md6B10bINPmW6AkunU/4
         O5qyUMPIhTIUcWP93mFW9ztDjy2FefGvVL7PtW877B/dxfw9NfjXQi9z60sxUW0/NCVR
         8VgB7aGzd2XmsUqytNr4JzjpboLvh66RTmJ7B74LkP1bxtuxSjjqwuZev9+CCM+aD/jT
         QcrcDXQWL+POa4I6paqCvJKukoWNHgYcg5mcaQBq7TyC72BleJyKZMTK5/SguNcLdBs9
         hwPQ==
X-Gm-Message-State: AC+VfDycJ3ZoRG0Am7PplydSOnkaOJPXXkrvz5cCIROmCvtnxSNry7aF
	dIgxwLBNXR3QMc/AsKQEJOpucvA5C8eGLyBG2Us=
X-Google-Smtp-Source: ACHHUZ7J91wPbuq8ZOPg9yeAHWI5DdfRloytxD81Ctso0rAHVhBPmG2tddd8LVVsE/ZL6AV06U660CrvS17orfITOe0=
X-Received: by 2002:a25:cb87:0:b0:bc4:5a65:1a4f with SMTP id
 b129-20020a25cb87000000b00bc45a651a4fmr4472624ybg.5.1686819542602; Thu, 15
 Jun 2023 01:59:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com> <20230614230128.199724bd@kernel.org>
In-Reply-To: <20230614230128.199724bd@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 10:58:50 +0200
Message-ID: <CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Jakub Kicinski <kuba@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 8:01=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> First things first, what are the current expectations for subsystems
> accepting rust code?

If you mean generally: it is up to each subsystem to decide whether to
accept (or not) Rust code. Though we ask maintainers to make an effort
to be flexible when things are so "core" that they could potentially
block all other work, in order to conduct the Rust experiment and to
try things out.

On our side, we have a few guidelines for contributors [1].

[1] https://rust-for-linux.com/contributing#the-rust-subsystem

> I was hoping someone from the Rust side is going to review this.
> We try to review stuff within 48h at netdev, and there's no review :S

I think the version number got reset, but Tomonori had a couple
versions on the rust-for-linux@vger list [2][3].

Andrew Lunn was taking a look, and there were some other comments going on,=
 too.

The email threading is broken in [2][3], though, so it may be easiest
to use a query like "f:lunn" [4] to find those.

[2] https://lore.kernel.org/rust-for-linux/01010188843258ec-552cca54-4849-4=
424-b671-7a5bf9b8651a-000000@us-west-2.amazonses.com/
[3] https://lore.kernel.org/rust-for-linux/01010188a42d5244-fffbd047-446b-4=
cbf-8a62-9c036d177276-000000@us-west-2.amazonses.com/
[4] https://lore.kernel.org/rust-for-linux/?q=3Df%3Alunn

> My immediate instinct is that I'd rather not merge toy implementations
> unless someone within the netdev community can vouch for the code.

Yes, in general, the goal is that maintainers actually understand what
is getting merged, get involved, etc. So patch submitters of Rust
code, at this time, should be expected/ready to explain Rust if
needed. We can also help from the Rust subsystem side on that.

But, yeah, knowledgeable people should review the code.

> You seem to create a rust/net/ directory without adding anything
> to MAINTAINERS. Are we building a parallel directory structure?
> Are the maintainers also different?

The plan is to split the `kernel` crate and move the files to their
proper subsystems if the experiment goes well.

But, indeed, it is best if a `F:` entry is added wherever you think it
is best. Some subsystems may just add it to their entry (e.g. KUnit
wants to do that). Others may decide to split the Rust part into
another entry, so that maintainers may be a subset (or a different set
-- sometimes this could be done, for instance, if a new maintainer
shows up that wants to take care of the Rust abstractions).

Cheers,
Miguel

