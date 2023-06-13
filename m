Return-Path: <netdev+bounces-10424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 140BF72E620
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9808528101C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B007537B8B;
	Tue, 13 Jun 2023 14:48:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9C323DB;
	Tue, 13 Jun 2023 14:48:01 +0000 (UTC)
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC9A1738;
	Tue, 13 Jun 2023 07:48:00 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id ada2fe7eead31-43b3e2cce3eso750928137.0;
        Tue, 13 Jun 2023 07:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686667679; x=1689259679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qh4rpjMjxUEPX0APaZpw079tKHUl21iJYwAmZpwq6fg=;
        b=BAU2J/0RIP/40HtbEcEMmlOwWMCOkU8zc1JzQO3kVjIorwFenk2owpCmo3LckU7Imr
         8zEJw2rTGDCdUYjzXsE+dol7o6ks1U6RV1AabIsp6fU0aYccz8SGu0Eryb4hhkoxNrLA
         WOZ+iayuwJYo2AmOoclQziIVWLVcIq9us2PVYjiRZ06JCLTrfL/WwsYLo6Imb8WoArnt
         qH1L5VRD7ze+l7nFSIwFK0hg4ZRxA4RtDtP+CX9FqgKruN6LCHZlhH6QDx7uFOcugo7L
         N4fRikPEue/261Y3SVFqRNlcX5NIdYKW9b1FgFYod9ppeXl+sl2Msq8AOrFdQJ2RW5rj
         n7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667679; x=1689259679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qh4rpjMjxUEPX0APaZpw079tKHUl21iJYwAmZpwq6fg=;
        b=cHApASqtyCE9r7jMG7m8EVnYfAVuKV8FC7PY1NJV9CNNsV9yMOKw/llB/rTm/CWFF6
         9YteeDYE9tNEQy5BypY0Wz/8wMIIw4aR3JQSk4TqCyAd1K3r265NRpPmqbixsE1Ir2zL
         fKSA37+QwA3kt63GEV82xpi59YeoYgDQxb8XOsErvmP/W0bkV50b750zKSQriXlftkeN
         uYtIpknDGpfJL//iB3rUteBCKcO7KlHF42go8QCdk9JdWzOc6dVKH374Z5Fz+ZBnmzMs
         J/Aj374DGafdBx5ZUJKT2H/3PIf43Xzq9Yc7uBC/Q4i0xpUILdQkYazcawHYrfJDgzVk
         8qwQ==
X-Gm-Message-State: AC+VfDwg7EnZHTToDl97oe6ADx1TbbBcx4PqBbzDyqafG/aa9PPZhfgf
	6X0Lu5Sd/NjUFhOn6pu02Lbsyqz4y3/4LBFpmMU=
X-Google-Smtp-Source: ACHHUZ6dPqnuHgM1YvmANLNki8mjEPbtLnrbnsMrUeLMQLe6nHptT218epXaBBKyyhfzup+bNhr3kqOQgxjp5cKU92M=
X-Received: by 2002:a05:6102:1606:b0:434:c512:99d2 with SMTP id
 cu6-20020a056102160600b00434c51299d2mr6697023vsb.4.1686667679303; Tue, 13 Jun
 2023 07:47:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-7-sdf@google.com>
In-Reply-To: <20230612172307.3923165-7-sdf@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 13 Jun 2023 16:47:23 +0200
Message-ID: <CAF=yD-KFjcGq5DkCST1Cbx-bj4M7yE6LSz=uQWifZBba2HGFoA@mail.gmail.com>
Subject: Re: [RFC bpf-next 6/7] selftests/bpf: extend xdp_metadata with devtx kfuncs
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 7:26=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> Attach kfuncs that request and report TX timestamp via ringbuf.
> Confirm on the userspace side that the program has triggered
> and the timestamp is non-zero.
>
> Also make sure devtx_frame has a sensible pointers and data.
>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

> +SEC("fentry/devtx_sb")
> +int BPF_PROG(devtx_sb, const struct devtx_frame *frame)
> +{
> +       int ret;
> +
> +       ret =3D verify_frame(frame);
> +       if (ret < 0)
> +               __sync_add_and_fetch(&pkts_fail_tx, 1);

intend to return in these error cases? in this and following patch

> +
> +       ret =3D bpf_devtx_sb_request_timestamp(frame);
> +       if (ret < 0)
> +               __sync_add_and_fetch(&pkts_fail_tx, 1);
> +
> +       return 0;
> +}
> +
> +SEC("fentry/devtx_cp")
> +int BPF_PROG(devtx_cp, const struct devtx_frame *frame)
> +{
> +       struct devtx_sample *sample;
> +       int ret;
> +
> +       ret =3D verify_frame(frame);
> +       if (ret < 0)
> +               __sync_add_and_fetch(&pkts_fail_tx, 1);
> +
> +       sample =3D bpf_ringbuf_reserve(&tx_compl_buf, sizeof(*sample), 0)=
;
> +       if (!sample)
> +               return 0;

return non-zero?

> +
> +       sample->timestamp_retval =3D bpf_devtx_cp_timestamp(frame, &sampl=
e->timestamp);
> +
> +       bpf_ringbuf_submit(sample, 0);
> +
> +       return 0;
> +}

