Return-Path: <netdev+bounces-10548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D79372EFB6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88159280EDF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D59F2A9C4;
	Tue, 13 Jun 2023 22:55:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6F1361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 22:55:18 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7393698;
	Tue, 13 Jun 2023 15:55:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-977c89c47bdso13597966b.2;
        Tue, 13 Jun 2023 15:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686696915; x=1689288915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANEXcWjrRTe+RbBc7gwOrDGNXmOQrXArQ6Sp/mtywzs=;
        b=YL3YERGon/SIzeeTtOmvAE/PrjlURwrDL8eGxn/wCB+JCYZclaPqTNDMw0n0U4QJ6/
         qjgKwRewC2bbg0VnMYvbCS9St2U29LArgw582NXTskNv2wdcOTPYW4X0TwpgGb6NO9BY
         vewxZwr6Y1GgRNmFG1OBcRMimQJAFsimI4IADBZN1GDttt7RIqCvvWwAcYOB1DVHR29C
         OLTUM9AkM9zCMReF4i+CMU7BKJo5dYl4va4neQ0+NDz08GWe3lQYpRAL2Ri9C79wapzd
         cdzZpdrGZWSV15GB+ZuidX/2B/6hy/ZpURqxyDV5FJF8jQKwClAz4vk2TjxMk0iemqsx
         7dmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686696915; x=1689288915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANEXcWjrRTe+RbBc7gwOrDGNXmOQrXArQ6Sp/mtywzs=;
        b=hKhcREfDLsXoMt7ZSuA4jcGWcd5/e8mCHr6mCxtmFw9m5ANJkZhGFLm4ZeoJZfYzj5
         sHUBLKf3ofkK4ZM8DiiWByMW9M9fsdZnxdjqebYW6YaRuVaZOD22x+vl9vG54mAuFSmX
         q41ywB7J+4gxTv2v2JlIy/6G2ktLZ9L5y6coKVVcitg+SgPuf0Zx6uzRoKG/6y08dv2R
         Eje7DMmRjnogemRxex9WDDhOs4ChlzLaYu46HMFcNXgbODSfTj3v1WCkro+35rjGi9eY
         pHxLaQFu2LYambU9PHgNrwH8oYK2Xfj+phBGD2qkEJM1MrKWsZF0f563jvUANdwOkK+z
         0YuA==
X-Gm-Message-State: AC+VfDw1ZW7aTSPJshI0Rt60TlQoEsQTXBOpBmGuMAls4agPY3c9ZNr6
	Sc83/5UVKEPRTMQNliEO1MeR8RLLI3B7+oMX6Z0IlzAHJ/NrwQ==
X-Google-Smtp-Source: ACHHUZ6lR5K/a5/7fvggUfZbZYvhUOfZqArLMLrVsSDH6rsX80Ja7nKdSfdlQfLbfopavfm8gHcFgETbVdKqWeUO2ho=
X-Received: by 2002:a17:907:7202:b0:96f:cb13:8715 with SMTP id
 dr2-20020a170907720200b0096fcb138715mr13782006ejc.69.1686696914632; Tue, 13
 Jun 2023 15:55:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
 <01E2FCED-7EB6-4D06-8BB0-FB0D141B546E@oracle.com> <202306131238.92CBED5@keescook>
 <B3AC0B67-1629-44AC-8015-B28F020B018C@oracle.com>
In-Reply-To: <B3AC0B67-1629-44AC-8015-B28F020B018C@oracle.com>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Tue, 13 Jun 2023 18:55:03 -0400
Message-ID: <CADmuW3VF6HhptF5p7PLJpcNNMCTfwRP=Rm=be=MaaFF_i2rr9g@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Replace strlcpy with strscpy
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, Jeff Layton <jlayton@kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, Neil Brown <neilb@suse.de>, 
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <dai.ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 3:43=E2=80=AFPM Chuck Lever III <chuck.lever@oracle=
.com> wrote:
>
> > On Jun 13, 2023, at 3:42 PM, Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, Jun 13, 2023 at 02:18:06PM +0000, Chuck Lever III wrote:
> >>
> >>
> >>> On Jun 12, 2023, at 8:40 PM, Azeem Shaikh <azeemshaikh38@gmail.com> w=
rote:
> >>>
> >>> strlcpy() reads the entire source buffer first.
> >>> This read may exceed the destination size limit.
> >>> This is both inefficient and can lead to linear read
> >>> overflows if a source string is not NUL-terminated [1].
> >>> In an effort to remove strlcpy() completely [2], replace
> >>> strlcpy() here with strscpy().
> >>
> >> Using sprintf() seems cleaner to me: it would get rid of
> >> the undocumented naked integer. Would that work for you?
> >
> > This is changing the "get" routine for reporting module parameters out
> > of /sys. I think the right choice here is sysfs_emit(), as it performs
> > the size tracking correctly. (Even the "default" sprintf() call should
> > be replaced too, IMO.)
>
> Agreed, that's even better.
>

Thanks folks. Will send over a v2 which replaces strlcpy with sysfs_emit.

