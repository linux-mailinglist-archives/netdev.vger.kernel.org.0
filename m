Return-Path: <netdev+bounces-1831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3BA6FF3EC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B74A1C20F3F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FA71B8FA;
	Thu, 11 May 2023 14:21:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE61F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:21:53 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC5106E6;
	Thu, 11 May 2023 07:21:24 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-55a79671a4dso133641607b3.2;
        Thu, 11 May 2023 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683814883; x=1686406883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKY9YekxY/iBJ1MUypVNqcAKnynmeC9XzGISSlKZ2W4=;
        b=fTLFIpGf0OGsdXXfGZXW1PWWd7njzgCkMMAm4N9WZJmZcnRxOwZfcWLAF49ZoLufUQ
         yKEmXE/Z+V3OzA83l/pymwNSwz35LXpG6gy6ShOKQF75Ia3BcCNBY7O5UQcPwj14ktBK
         U2BR3i5/M5zN4xlzpP01urtLoR4YaMkceH6xBFilkHpkxDA3Ddf0uWgZ0qdo/lOtNuZ3
         DJj07N3VRSBYSPq8GDJb70Q+ml2e8n4ejNYxvkMyOs9dyNHAS36oJaskOVJ+1onqNg0z
         imLKXyPb3cGuwgIbqHjCeaswPqu8UDu3OHqYIYGACRWO4Unyb6YIjyeeGRfURaKDEHew
         Acfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683814883; x=1686406883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKY9YekxY/iBJ1MUypVNqcAKnynmeC9XzGISSlKZ2W4=;
        b=dSjpsz3ACemVtXRxQ8mqfY7PrkY4+YcpRmPpCZJMlBUKXuVLLoczwVFxaVI5zw455L
         qX73IHW8nfbV0Lx0HBq7mdOWaE/uJ4FepBncBcggHyv1RZKEvvgAN8Iw4o2iDglZYEO3
         Otob+wRX9wbxY31rb1Fox/rS9XFsZ1ZlC8cobbi5bN8RL6Q7CoamWQ1e2rFjdwevUnL2
         lvNpvuCbbG2s6a2dbPq8ULavIyUfFIbno/sfXichodcHPVdKxwPM6moBzXR1JMxrwA6P
         egcuoem6o8Mb/T3xX6JTejyZ68zUuFMVuY9QWlPP7NIVk6ZcCabMBpbLPh64CUlkCf9U
         tTqQ==
X-Gm-Message-State: AC+VfDz/rY/47gWYKtUJG4NujudH9fh+j0uXWcIs3ahVQ5Aps9cMGNjG
	W/LM1D9l5Xy3be7efJBDh2vGSZN2UiB7DPpaAy4=
X-Google-Smtp-Source: ACHHUZ7MBWeGw3jJ0y9+DfmYA3GCIYPUczX8P8+fTCvN7A/Qa8qQfa39EIrUuaS2Zwf2pIVKJwwyPkTidqvpF7cblto=
X-Received: by 2002:a0d:db47:0:b0:55a:1cb0:b255 with SMTP id
 d68-20020a0ddb47000000b0055a1cb0b255mr22195556ywe.37.1683814883262; Thu, 11
 May 2023 07:21:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com> <ZFzuvDopKWB9wmQf@t14s.localdomain>
In-Reply-To: <ZFzuvDopKWB9wmQf@t14s.localdomain>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 11 May 2023 10:20:57 -0400
Message-ID: <CADvbK_daDKfwDimJ=uovyO86i4KJZM32305fG70pSWw3Qe89Pg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] sctp: add bpf_bypass_getsockopt proto callback
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>, nhorman@tuxdriver.com, 
	davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>, 
	Christian Brauner <brauner@kernel.org>, Stanislav Fomichev <sdf@google.com>, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 9:33=E2=80=AFAM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, May 11, 2023 at 03:25:06PM +0200, Alexander Mikhalitsyn wrote:
> > Implement ->bpf_bypass_getsockopt proto callback and filter out
> > SCTP_SOCKOPT_PEELOFF, SCTP_SOCKOPT_PEELOFF_FLAGS and SCTP_SOCKOPT_CONNE=
CTX3
> > socket options from running eBPF hook on them.
> >
> > SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS options do fd_insta=
ll(),
> > and if BPF_CGROUP_RUN_PROG_GETSOCKOPT hook returns an error after succe=
ss of
> > the original handler sctp_getsockopt(...), userspace will receive an er=
ror
> > from getsockopt syscall and will be not aware that fd was successfully
> > installed into a fdtable.
> >
> > As pointed by Marcelo Ricardo Leitner it seems reasonable to skip
> > bpf getsockopt hook for SCTP_SOCKOPT_CONNECTX3 sockopt too.
> > Because internaly, it triggers connect() and if error is masked
> > then userspace will be confused.
> >
> > This patch was born as a result of discussion around a new SCM_PIDFD in=
terface:
> > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalits=
yn@canonical.com/
> >
> > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Cc: Neil Horman <nhorman@tuxdriver.com>
> > Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Cc: Xin Long <lucien.xin@gmail.com>
> > Cc: linux-sctp@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > Acked-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
>
> Thx!
>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>

