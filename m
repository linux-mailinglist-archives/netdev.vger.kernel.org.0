Return-Path: <netdev+bounces-1498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC786FE057
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 515652814F2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6198BE7;
	Wed, 10 May 2023 14:32:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAA620B34
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:32:08 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3C819AD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:32:06 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aaea3909d1so68583405ad.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683729126; x=1686321126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDPoO9iS4YMdxTYw/7S57ZbKNNVUGyiS2mNuYLdO99Q=;
        b=WVOQZQj/jIEeoLxcpBmdx2rS3teY4rZ5OcD/qBDLQdUd/szQ3BOq2Qmx+FMS0GjWFu
         b5w5sES/fpll4EmbKNsz9KEY6JFIf9cTz4IH9vjBJp5LMwYK93Bnvw1oFDsCeBLWSFtx
         vaC8yJkbMthAbDhM0JuQDFGbDqjduMx/rBUPRODtb8DFdrYky8S3w6Pk26QErLGiPn2E
         YMwAEIFW67muE+9mNAOCHcoax/0DaGTEYFul9mNEq0J/9OFPyLgkfirLlqx+Gmsbka+G
         x+ir9BM4j8Jm4FqAZWPNnonNiTc54pKMtcIsjqwu/T8q653CsCOZd5JcTGxFiFDb2LvB
         cnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729126; x=1686321126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NDPoO9iS4YMdxTYw/7S57ZbKNNVUGyiS2mNuYLdO99Q=;
        b=dzJk6NYGorPmajT42QABqxHc/Zl1VAftmtZl+vICbxFVpDdmaNTDFH2M9PV106ASVW
         eT6f125QaYr4PiTC9ZvD6Hw9oKiQ5MES25Vz3peex/MelylbVDKyO8TFVAKhnj/AMu6h
         6331pM8oqNC6/xvrk1L65qSiTpFRm03ZZSOKgjTggpKkHjYrY2/DsN6qF4kTPOn5/L0/
         9UyWdHTWojegBjUfx8Pv7HBQ9KT5HaGsCGYNAiQ6kAuHAU55JVQlrV4uwNG7StAWaMLX
         r5BldF93Or7s+1O7QHjwP+P71p8+nAEyRRrcBd4sDCjSUQ5qWy2lEFGgMGPm+Ih5DRfE
         UR/Q==
X-Gm-Message-State: AC+VfDwCZCtdt0Shm33G4iGMiqDc7QuQfMdfDP3OebrwOT0duObQ7DQL
	VZcTlS3A1sZ+VEJMbFNryQG8P44H9PWwa6IMIqa1lA==
X-Google-Smtp-Source: ACHHUZ6bpmGB1LJLUBKPjVe2AFdOvxthT3r8P2+tSxk4Sig/VgtKri4YqrLDhzXGEweblHOTvaxSctXPtlAIFgBJx5Q=
X-Received: by 2002:a17:90b:1d87:b0:24d:fb82:71ab with SMTP id
 pf7-20020a17090b1d8700b0024dfb8271abmr18213899pjb.26.1683729126170; Wed, 10
 May 2023 07:32:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Wed, 10 May 2023 07:31:55 -0700
Message-ID: <CAKH8qBuzWHoEiABvTgM2qnx5Av127VMHnncGtU5EZq+ffT9eGg@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 6:15=E2=80=AFAM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Add bpf_bypass_getsockopt proto callback and filter out
> SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
> from running eBPF hook on them.
>
> These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> hook returns an error after success of the original handler
> sctp_getsockopt(...), userspace will receive an error from getsockopt
> syscall and will be not aware that fd was successfully installed into fdt=
able.
>
> This patch was born as a result of discussion around a new SCM_PIDFD inte=
rface:
> https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn=
@canonical.com/
>
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: linux-sctp@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com=
>

Acked-by: Stanislav Fomichev <sdf@google.com>

with a small nit below

> ---
>  net/sctp/socket.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index cda8c2874691..a9a0ababea90 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -8281,6 +8281,29 @@ static int sctp_getsockopt(struct sock *sk, int le=
vel, int optname,
>         return retval;
>  }
>

[...]

> +bool sctp_bpf_bypass_getsockopt(int level, int optname)

static bool ... ? You're not making it indirect-callable, so seems
fine to keep private to this compilation unit?

> +{
> +       /*
> +        * These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETS=
OCKOPT
> +        * hook returns an error after success of the original handler
> +        * sctp_getsockopt(...), userspace will receive an error from get=
sockopt
> +        * syscall and will be not aware that fd was successfully install=
ed into fdtable.
> +        *
> +        * Let's prevent bpf cgroup hook from running on them.
> +        */
> +       if (level =3D=3D SOL_SCTP) {
> +               switch (optname) {
> +               case SCTP_SOCKOPT_PEELOFF:
> +               case SCTP_SOCKOPT_PEELOFF_FLAGS:
> +                       return true;
> +               default:
> +                       return false;
> +               }
> +       }
> +
> +       return false;
> +}
> +
>  static int sctp_hash(struct sock *sk)
>  {
>         /* STUB */
> @@ -9650,6 +9673,7 @@ struct proto sctp_prot =3D {
>         .shutdown    =3D  sctp_shutdown,
>         .setsockopt  =3D  sctp_setsockopt,
>         .getsockopt  =3D  sctp_getsockopt,
> +       .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
>         .sendmsg     =3D  sctp_sendmsg,
>         .recvmsg     =3D  sctp_recvmsg,
>         .bind        =3D  sctp_bind,
> @@ -9705,6 +9729,7 @@ struct proto sctpv6_prot =3D {
>         .shutdown       =3D sctp_shutdown,
>         .setsockopt     =3D sctp_setsockopt,
>         .getsockopt     =3D sctp_getsockopt,
> +       .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
>         .sendmsg        =3D sctp_sendmsg,
>         .recvmsg        =3D sctp_recvmsg,
>         .bind           =3D sctp_bind,
> --
> 2.34.1
>

