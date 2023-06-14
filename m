Return-Path: <netdev+bounces-10806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836E87305DF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B46381C20CEB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D232EC2D;
	Wed, 14 Jun 2023 17:18:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D511C7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:18:24 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B795A1BE8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:18:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-66673b0e352so340742b3a.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686763098; x=1689355098;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3wlx0kEJ/mSQEuKmaejBykCyqHV4BJ4CghHqcM48HmA=;
        b=IRz3cQJG37+66kUbR4t24zr5dMFla3ieFtNh08DQpuMMOKoeDMOHQIITZu7HvUra7O
         tNTlAMlEMedsKtcZrSLlkblGGNbPPLdQKCcAJX7vXtgAfZKIAOFaRaeLHNlkot9JxXwC
         SPgkMBvOGOWGq8g+2f1eXEL1hjUfBPS+rXrpt3KQ61m5I4J3QkSVjBrjA59GcUlhcn7c
         m5Llv7oTKnuwRvINw0u6tMyxHdjwsjfaEFwFTTKV0qesmcbgKUBL4o1RzTJwjOtmUPbp
         x9327IBwCdb3VMIRnnlkA90HgDykRWc/77N8uWsC/aqF/cAx+HAeGkpqF5HhJOyVpSlV
         i0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686763098; x=1689355098;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3wlx0kEJ/mSQEuKmaejBykCyqHV4BJ4CghHqcM48HmA=;
        b=d2JZuH9Fewr9NpEmqx9VG3JzOY7Wmgy1OTnWrAqSqW7GRVrcOpV0gvGQprkxjf95ed
         z19Jqr8CT380Da2pPGdbglx/kx9CK8TBjC7C6Z9bYrnH4RjCHgJQ1j5a2a6Np9/j0ZrK
         cMfa+oW39+J8ViujAtar66lutEgGPoAZ5d2S+E8A3zO5vAjM+ToCa6+x5YT9a8R72PhG
         yDEe+6IzFuqElkEfy/mj0lX3PkIk5nsRB1rAEcnVB6toSBh5Vvrzuxfp6Z20ZSqVpV16
         Sox2ikxNB3cK4F01fwiQ2czOGyAqFsanNo5LohSJLA1xxDZGLGw/bZ5pGtpCFYUa53Lz
         mEGw==
X-Gm-Message-State: AC+VfDzz8c9T9hlEUCDajI0J8E26AZ1aA3qpQ6NGFQQptkXfQpKLyuS+
	dxMZkrWlDGEUHpI8ftm0z169KVg=
X-Google-Smtp-Source: ACHHUZ5kluFSkPsXMVcgMrZeGXgY5E13fDgHHklQdQz0xmczAreGoUAXJw0Bdm9lSms4v/1as3hhkiY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1147:b0:666:6386:6e2 with SMTP id
 b7-20020a056a00114700b00666638606e2mr534573pfm.2.1686763098184; Wed, 14 Jun
 2023 10:18:18 -0700 (PDT)
Date: Wed, 14 Jun 2023 10:18:16 -0700
In-Reply-To: <ZIlmAB4OYUvfqQTr@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-4-sdf@google.com>
 <ZIiGVrHLKQRzMzGg@corigine.com> <CAKH8qBvfp7Do1tSD4YiiNVojG2gB9+mrNNLiVFz+ts4gU+pJrA@mail.gmail.com>
 <ZIlmAB4OYUvfqQTr@corigine.com>
Message-ID: <ZIn2WLenejMFik+O@google.com>
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
From: Stanislav Fomichev <sdf@google.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/14, Simon Horman wrote:
> On Tue, Jun 13, 2023 at 12:00:25PM -0700, Stanislav Fomichev wrote:
> > On Tue, Jun 13, 2023 at 8:08=E2=80=AFAM Simon Horman <simon.horman@cori=
gine.com> wrote:
> > > On Mon, Jun 12, 2023 at 10:23:03AM -0700, Stanislav Fomichev wrote:
>=20
> ...
>=20
> > > > +void devtx_complete(struct net_device *netdev, struct devtx_frame =
*ctx)
> > > > +{
> > > > +     rcu_read_lock();
> > > > +     devtx_run(netdev, ctx, &netdev->devtx_cp);
> > > > +     rcu_read_unlock();
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(devtx_complete);
> > > > +
> > > > +/**
> > > > + * devtx_sb - Called for every egress netdev packet
> > >
> > > As this is a kernel doc, it would be good to document the ctx paramet=
er here.
> >=20
> > I didn't really find a convincing way to add a comment, I've had the
> > following which I've removed prio to submission:
> > @ctx devtx_frame context
> >=20
> > But it doesn't seem like it brings anything useful? Or ok to keep it th=
at way?
>=20
> Thanks Stan,
>=20
> I see what you are saying wrt it not bringing much value.
> But I'm more thinking that something is better than nothing.
> Anyway, I'll drop this topic if you prefer.

Ack, thanks, I'll put it in for the consistency sake!

