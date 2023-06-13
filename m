Return-Path: <netdev+bounces-10481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9208B72EB21
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C7F4281257
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9453D1ED35;
	Tue, 13 Jun 2023 18:40:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8611F1ED23
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:40:09 +0000 (UTC)
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C91B19BC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:40:08 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-559b0ddcd4aso3570563eaf.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686681608; x=1689273608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aN9wvhBg/dflxQZZTLTLOTUq/Sg9jPIj+bahgJp6Vro=;
        b=pcbxv7syXtYOqsnLMTD1iKx+z+Yv4EDCpXiswYoX9s78ApLfveXeYMyGuKg93K0eM9
         rlXU2eJlHOJ4L0Ti+HS/8NScAPVDFUCs3Pjp8mf+WVhoTzuKgyewtni7Ve+0UgFmsmBM
         8xDz636PmMCCqBNNvheRLZOXeeNWWHfIWJh+BkzUAjQeo3JEyJ2NiH2dfXcbBy52of13
         9j2174ctwse5xuIJVaZAUBt2nuptvmRH3jmKpXmnpCmndOVZfLts5fsh06sXtYEQW9UW
         ZsSxNIuHqoxlwIHAuF/VYtbSy11HxFs0xF7QPvoEmP9npqeiqraHDlHBIJhVNYBZfqqM
         0QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686681608; x=1689273608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aN9wvhBg/dflxQZZTLTLOTUq/Sg9jPIj+bahgJp6Vro=;
        b=lkq6/2j/F9TBjwBa31ZUqIeXq3LAPtJxH2iZQsRQljTw1bYP8YsRiKb8h972U+3Y33
         WmpWNN1WU2+ObVb6r5y/p4m6aaPOHGg+agPWVCLeYgk4YODhhwnQfcSp41Am5PmYPxHd
         g+GNNXFNKGUNsLcOYsHQ7nVFCYjc2FusHJCEU55VjrFDuzkhnnUokKR3u8upVzWA6Cbu
         yZ1c69gO8vCq4jWyCie9dsCSt1WRj4JrKVAeW0rgxVsdoVjH11s4dfAWsj4T4yFzsDlv
         kC+GASXH7vFxLHQIgCWTOBGlPNT/8cAdfr0giFDYMK6zXcnq2yPm+naLdUG7UKKWI1H0
         +IpA==
X-Gm-Message-State: AC+VfDxF/nn+m3fkNGciOJdPKUR1lgZe8Bb1UMTZwVPJclhz3fNwb43R
	kElGtNvkZ68hpBqZUA9oY01SC0niux/htXlczVedfw==
X-Google-Smtp-Source: ACHHUZ644VlXFBWDZ2TyS4hJDbAPL83pkfMQmXzzWQd7OOng9wgEfmc3RMDnH5oAbdTU27whQcuq9v/E5B7w2XFdPBM=
X-Received: by 2002:a05:6808:1389:b0:39c:a986:953a with SMTP id
 c9-20020a056808138900b0039ca986953amr10168596oiw.34.1686681607727; Tue, 13
 Jun 2023 11:40:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-5-sdf@google.com>
 <ZIiH1n1QeFFmHuux@corigine.com>
In-Reply-To: <ZIiH1n1QeFFmHuux@corigine.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 11:39:56 -0700
Message-ID: <CAKH8qBtjCB8CyR8Q+E7RXW_FYU1++H7rqQHhvz2sQYhMRChRvw@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/7] bpf: implement devtx timestamp kfunc
To: Simon Horman <simon.horman@corigine.com>
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

On Tue, Jun 13, 2023 at 8:14=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Jun 12, 2023 at 10:23:04AM -0700, Stanislav Fomichev wrote:
>
> ...
>
> > +/**
> > + * bpf_devtx_cp_timestamp - Read TX timestamp of the packet. Callable
> > + * only from the devtx-complete hook.
> > + * @ctx: devtx context pointer.
>
> Hi Stan,
>
> one minor nit: documentation of the timestamp parameter should go here.

Thanks, will add!

> > + *
> > + * Returns 0 on success or ``-errno`` on error.
> > + */
> > +__bpf_kfunc int bpf_devtx_cp_timestamp(const struct devtx_frame *ctx, =
__u64 *timestamp)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> >  __diag_pop();
>
> ...

