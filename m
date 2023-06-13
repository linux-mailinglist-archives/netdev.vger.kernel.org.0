Return-Path: <netdev+bounces-10489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E1372EB65
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325A51C20434
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC143732F;
	Tue, 13 Jun 2023 19:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB16322D50
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:00:43 +0000 (UTC)
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFFAE5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:42 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-39cd084ea62so1981513b6e.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686682841; x=1689274841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62TZ0EUVnU1gkMFdJEMFtDOdX8shKDQp23kbaQIDozQ=;
        b=2C0c7gGtkEgtzHNxPhMcDgl50zIKmH+vKkhdPX4Akai2pTK6aG+FmOpU3GH5iKvKV4
         Nn33srVCw29aqnT3rJzP9Bs0Ocm2BgYyZsZYjYqcAUCAH05v4/LzA0Sr4xzZ4GvGc5Ip
         7CKEe/eG5c4XuTbJ/nqmQTShmEkSPe0+SdL6yRb5/Kz26PRtMR5i6O3fT0pzPz55L0jo
         2dTxH6OUpxCV8xKICUgtCv8SSp5RjyG9kh7UWGQOhmfln/CLlC9nZsjfyQ/XHAzX/qPB
         O856NWAmQgHw9uS3doipK8hKDr6DSZzGQfUPztIQE+45UKgqWOXnB9+JT32U4A2ixe+o
         6vRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686682841; x=1689274841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62TZ0EUVnU1gkMFdJEMFtDOdX8shKDQp23kbaQIDozQ=;
        b=XW2VeLYK7PumNQwHlPXeY6MaV2jH574DUoahHdwMRFD3xtk72QJYLkTPiGySpXciu9
         wrL/Jv4S/H34jFFF+UDHCjFXZYfOuK6J489yGl7UbMoNhA+RHUDgiTNH+NlfPgRrph7f
         jTjV7cvdzQYdiYxl5sjMkpJ5SQgTTDOqJXb26ETIi5Eg429btAeStxwR2/ce/PeU8IF+
         NINBhNyKEVBrMRZrpbmsZYr0GJrnrDwoa/pmtP6c62jwdH2WFFzhA6zeTFmIY5pkMDdl
         RHZSoC67vJlV3q6g9QhuPqSq/bmv66O7uWb6R7AvZLpnTj4wB+XUgtGRtbOwVNcocNSF
         O1FQ==
X-Gm-Message-State: AC+VfDykRxGb89YYkgaiel6/KFU6fXP07SgA0fmGe9kFnXrhSb3gFyQ4
	PoTSw8vqwlQ2pCuiQ4ReH2r33QrCJl0iuX8sgi29Og==
X-Google-Smtp-Source: ACHHUZ6oTdUT+cfYIo6Am6JS92ikkV5AjcSDG1CQYrtH2eHsh5UMTSLpJcwKKZEglCqxtUiqdKHOIGX43VCmCJOJXYA=
X-Received: by 2002:a05:6808:f11:b0:398:43a7:e9fe with SMTP id
 m17-20020a0568080f1100b0039843a7e9femr9839696oiw.20.1686682841644; Tue, 13
 Jun 2023 12:00:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-4-sdf@google.com>
 <CAF=yD-LtxC8BeCyTWpqwziKto5DVjeg7maMjCkOZcWoihFHKzw@mail.gmail.com>
In-Reply-To: <CAF=yD-LtxC8BeCyTWpqwziKto5DVjeg7maMjCkOZcWoihFHKzw@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 12:00:30 -0700
Message-ID: <CAKH8qBvrTbY_jV-1qg2r9C3yXE3Rk4uN8B+fRm=XaZF5OAU-BA@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 7:55=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Jun 12, 2023 at 7:24=E2=80=AFPM Stanislav Fomichev <sdf@google.co=
m> wrote:
> >
> > devtx is a lightweight set of hooks before and after packet transmissio=
n.
> > The hook is supposed to work for both skb and xdp paths by exposing
> > a light-weight packet wrapper via devtx_frame (header portion + frags).
> >
> > devtx is implemented as a tracing program which has access to the
> > XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
> > in the next patch, but the idea is similar to XDP metadata:
> > the kfuncs have netdev-specific implementation, but common
> > interface. Upon loading, the kfuncs are resolved to direct
> > calls against per-netdev implementation. This can be achieved
> > by marking devtx-tracing programs as dev-bound (largely
> > reusing xdp-dev-bound program infrastructure).
> >
> > Attachment and detachment is implemented via syscall BPF program
> > by calling bpf_devtx_sb_attach (attach to tx-submission)
> > or bpf_devtx_cp_attach (attach to tx completion). Right now,
> > the attachment does not return a link and doesn't support
> > multiple programs. I plan to switch to Daniel's bpf_mprog infra
> > once it's available.
> >
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
>
> > @@ -2238,6 +2238,8 @@ struct net_device {
> >         unsigned int            real_num_rx_queues;
> >
> >         struct bpf_prog __rcu   *xdp_prog;
> > +       struct bpf_prog __rcu   *devtx_sb;
> > +       struct bpf_prog __rcu   *devtx_cp;
>
> nit/subjective: non-obvious two letter acronyms are nr. How about tx
> and txc (or txcomp)

devtx and devtxc? I was using devtxs vs devtxc initially, but that
seems confusing. I can probably spell them out here:
devtx_submit
devtx_complete

Should probably be better?

> > +static int __bpf_devtx_attach(struct net_device *netdev, int prog_fd,
> > +                             const char *attach_func_name, struct bpf_=
prog **pprog)
> > +{
> > +       struct bpf_prog *prog;
> > +       int ret =3D 0;
> > +
> > +       if (prog_fd < 0)
> > +               return __bpf_devtx_detach(netdev, pprog);
> > +
> > +       if (*pprog)
> > +               return -EBUSY;
> > +
> > +       prog =3D bpf_prog_get(prog_fd);
> > +       if (IS_ERR(prog))
> > +               return PTR_ERR(prog);
> > +
> > +       if (prog->type !=3D BPF_PROG_TYPE_TRACING ||
> > +           prog->expected_attach_type !=3D BPF_TRACE_FENTRY ||
> > +           !bpf_prog_is_dev_bound(prog->aux) ||
> > +           !bpf_offload_dev_match(prog, netdev) ||
> > +           strcmp(prog->aux->attach_func_name, attach_func_name)) {
> > +               bpf_prog_put(prog);
> > +               return -EINVAL;
> > +       }
> > +
> > +       *pprog =3D prog;
> > +       static_branch_inc(&devtx_enabled);
> > +
> > +       return ret;
>
> nit: just return 0, no variable needed

Ack.

> > +}
> > +
> > +__diag_push();
> > +__diag_ignore_all("-Wmissing-prototypes",
> > +                 "Global functions as their definitions will be in vml=
inux BTF");
> > +
> > +/**
> > + * bpf_devtx_sb_attach - Attach devtx 'packet submit' program
> > + * @ifindex: netdev interface index.
> > + * @prog_fd: BPF program file descriptor.
> > + *
> > + * Return:
> > + * * Returns 0 on success or ``-errno`` on error.
> > + */
> > +__bpf_kfunc int bpf_devtx_sb_attach(int ifindex, int prog_fd)
> > +{
> > +       struct net_device *netdev;
> > +       int ret;
> > +
> > +       netdev =3D dev_get_by_index(current->nsproxy->net_ns, ifindex);
> > +       if (!netdev)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&devtx_attach_lock);
> > +       ret =3D __bpf_devtx_attach(netdev, prog_fd, "devtx_sb", &netdev=
->devtx_sb);
> > +       mutex_unlock(&devtx_attach_lock);
> > +
> > +       dev_put(netdev);
> > +
> > +       return ret;
> > +}
> > +
> > +/**
> > + * bpf_devtx_cp_attach - Attach devtx 'packet complete' program
> > + * @ifindex: netdev interface index.
> > + * @prog_fd: BPF program file descriptor.
> > + *
> > + * Return:
> > + * * Returns 0 on success or ``-errno`` on error.
> > + */
> > +__bpf_kfunc int bpf_devtx_cp_attach(int ifindex, int prog_fd)
> > +{
> > +       struct net_device *netdev;
> > +       int ret;
> > +
> > +       netdev =3D dev_get_by_index(current->nsproxy->net_ns, ifindex);
> > +       if (!netdev)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&devtx_attach_lock);
> > +       ret =3D __bpf_devtx_attach(netdev, prog_fd, "devtx_cp", &netdev=
->devtx_cp);
> > +       mutex_unlock(&devtx_attach_lock);
> > +
> > +       dev_put(netdev);
> > +
> > +       return ret;
> > +}
>
> These two functions are near duplicates, aside from the arguments to
> their inner call to __bpf_devtx_attach. Can be dedup-ed further?

I've deduped most of the stuff via __bpf_devtx_attach; can probaby
dedup the rest with a bool argument, let me try...

