Return-Path: <netdev+bounces-10491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9C672EB6D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD481280D08
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C693D39E;
	Tue, 13 Jun 2023 19:00:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166C3D39B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:00:58 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72F9127
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3c5389fa2so18372955ad.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686682856; x=1689274856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nawJqB34tvioP0r7b5WQ5Z1lwcr0CcRjgAPd1MBFwKk=;
        b=vZ3SlXD7BWLNvrjiOEbvZd7XpVtSiwgQar5OiS8/s/Qna4WxjBoU5o4dmW/DoyTuqX
         B0SsiOWJUUhn7LOZY4ur9ULr9btTRiqQ1fZDxYWYYbIvr+XAzPUzsZFqliRmuVt21auZ
         X06dod6PEspiDHSoJ88h++wIGIib+eHPSRv2Qf/EzSqF0+EUY1pNAbIKqpUbOgy43dd8
         3xclGyMHXPVc7HYuUH9J5GcH/LkMKvHTOqVxIICbJjlZrjy2WpNK3mFaGcYkQC7eQTdy
         OLak0NMWsycsImhIswLC/gAz+ZtG+WPP60+QyBV6EYT7xJAM+be54aqWrtCPb5IOQT1j
         69Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686682856; x=1689274856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nawJqB34tvioP0r7b5WQ5Z1lwcr0CcRjgAPd1MBFwKk=;
        b=k1n5MF9SssvZ0Ezeha2fw6W8hGpaiHDsRLX/fj8ZfQKTTsY1LOTk5x+lyzdy2OXTuQ
         OkzIjLm+zueTqVPwA06AUHSEPxKcKQfXcl+RAAPhQWXCsmSIlNpngVVz6gz1u9MhyDyR
         nvWgbb+tpmvC6+B07HvZLM2Cnb/UZspDohW9eesrNJJHgQemzQzH7+Zp5DU/eKZ0fRdD
         0Wch3uP6/fLfXPozcz7jTUxWCvz07c49k52YHPFwIecJdwuTLkXJYEESBC6Lc5ks47dY
         OnTTAJTo46wva6zz+txvjgV2tFneEwwuxxThJYg0HczgXzPQj6IV0b4gN5SRF/LqbBhB
         azDg==
X-Gm-Message-State: AC+VfDyRiCv1TYgcE4WwmdWo3lPiv460a2X+o66lTgP/6aBBmYyk+4VC
	j9hs0At5XmuN7T4WubIkiXYSt0MUMFgqQU3Qm8k+1w==
X-Google-Smtp-Source: ACHHUZ5tEh1GZ+88GXZ9nNC9+6mto6ZI3JQbpFDLcEXxkyQpOpOHdrKaISAaQ69kb75Xemp1OVU/qPKIpb0VkQW8ff8=
X-Received: by 2002:a17:902:9343:b0:1b3:e3a4:1512 with SMTP id
 g3-20020a170902934300b001b3e3a41512mr2853223plp.10.1686682856047; Tue, 13 Jun
 2023 12:00:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-7-sdf@google.com>
 <CAF=yD-KFjcGq5DkCST1Cbx-bj4M7yE6LSz=uQWifZBba2HGFoA@mail.gmail.com>
In-Reply-To: <CAF=yD-KFjcGq5DkCST1Cbx-bj4M7yE6LSz=uQWifZBba2HGFoA@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 12:00:44 -0700
Message-ID: <CAKH8qBua39ahbLnBfc0DjvmnRPaVhY2CBO2ro4j_iNPU8S++2A@mail.gmail.com>
Subject: Re: [RFC bpf-next 6/7] selftests/bpf: extend xdp_metadata with devtx kfuncs
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 7:48=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Jun 12, 2023 at 7:26=E2=80=AFPM Stanislav Fomichev <sdf@google.co=
m> wrote:
> >
> > Attach kfuncs that request and report TX timestamp via ringbuf.
> > Confirm on the userspace side that the program has triggered
> > and the timestamp is non-zero.
> >
> > Also make sure devtx_frame has a sensible pointers and data.
> >
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> > +SEC("fentry/devtx_sb")
> > +int BPF_PROG(devtx_sb, const struct devtx_frame *frame)
> > +{
> > +       int ret;
> > +
> > +       ret =3D verify_frame(frame);
> > +       if (ret < 0)
> > +               __sync_add_and_fetch(&pkts_fail_tx, 1);
>
> intend to return in these error cases? in this and following patch

Yeah, let's do it.

> > +
> > +       ret =3D bpf_devtx_sb_request_timestamp(frame);
> > +       if (ret < 0)
> > +               __sync_add_and_fetch(&pkts_fail_tx, 1);
> > +
> > +       return 0;
> > +}
> > +
> > +SEC("fentry/devtx_cp")
> > +int BPF_PROG(devtx_cp, const struct devtx_frame *frame)
> > +{
> > +       struct devtx_sample *sample;
> > +       int ret;
> > +
> > +       ret =3D verify_frame(frame);
> > +       if (ret < 0)
> > +               __sync_add_and_fetch(&pkts_fail_tx, 1);
> > +
> > +       sample =3D bpf_ringbuf_reserve(&tx_compl_buf, sizeof(*sample), =
0);
> > +       if (!sample)
> > +               return 0;
>
> return non-zero?

Can't return non-zero from fentry :-( The userspace verifies that
pkts_fail_tx stays zero, so that should be enough.


> > +
> > +       sample->timestamp_retval =3D bpf_devtx_cp_timestamp(frame, &sam=
ple->timestamp);
> > +
> > +       bpf_ringbuf_submit(sample, 0);
> > +
> > +       return 0;
> > +}

