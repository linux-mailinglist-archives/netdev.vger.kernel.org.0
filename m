Return-Path: <netdev+bounces-1797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8226FF2C4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 515601C20EFF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8991773E;
	Thu, 11 May 2023 13:27:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B719BDA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:27:55 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB31D100FC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:27:32 -0700 (PDT)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 54A033F4E7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683811604;
	bh=+QWvTZLqx3wPEiv2RyOeDyceRNHlm4uLw1mA+o8yT0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=bqIJ7VFScqNAk21IX650pYOqcveJpInirHkqwUsbvPjOhaxe1KcVIEhYmV1iRapG0
	 fHC1W0+HARSADMpP/TgYiMDgxQlrd6OyZ7hPK9I+7iCs+ht69P1bK3lWisqh2WR8b+
	 uzLTo5dDaxQ1TRi0dRCvo+RR0Td5itppBbNKzBrnzRuH/1YjKX1KQ/JE5/p6uLlNf2
	 bnkeNdEblL+CanjCXt0B/Gqm45Y38ZVI1eAgsL+vtirMnURHoHUnSoTfDKN7J5+X1b
	 vEMITeo+HwTgW+sJfS4xDg4TknR/+L+H+BlNpRkPXbzkzzvmnWEI9UlXmwVGme0KnU
	 m1pvzKlW8ie4w==
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-ba5fd33fdacso5883209276.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683811602; x=1686403602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QWvTZLqx3wPEiv2RyOeDyceRNHlm4uLw1mA+o8yT0I=;
        b=RH7Gck1qkZF1O2bzWVq05i95J87ldSJx3hKBILqEpwrtyO8csRdJWf3gmOHqpJVX99
         qGQZNEMQB1pZrhjseooL8YfrzZYiySX51Q3ugS5F5ClYP1cUqIY4MU6NZHJW2s1FkJM1
         Sm5+bHd3h3u/C6mWwIbtOCkjPe2QDAtVD96lty0ZakPFnTzcLWcyFmxndW53lWE+5KWR
         L8MQI4S03Ug9i2DNjNYER2187/jMt4K9WwKtZjJgxusHohVpVwHr8HbHo65BEFWcyL91
         woTITMi97KuWcUr+6xTIsoA41p+M480TNqRcMv8Pj5ykLdSS00FMH65BKb3YQan1v1qp
         YH7A==
X-Gm-Message-State: AC+VfDxgnMN7+/2pefkOIYSaTLkHRo0HvGIc/077cZOow2NmmysI7YE8
	VGPSgMH+2TmOFFX2r3RESBty+qamit0sCktvfSl3PDiXqR6qJEtN73Kt4fRhoiu8DXOesjz2qk/
	fGoFBuw8r4sYXpGUCIsX+ZY4pi1XmACcv5iQrdpxJo6yXcfz2m7KSwcvlhQ==
X-Received: by 2002:a25:d308:0:b0:b92:3ed2:1cae with SMTP id e8-20020a25d308000000b00b923ed21caemr22265688ybf.12.1683811602511;
        Thu, 11 May 2023 06:26:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7MlsPe2a7i7uETNPCN+ZsxkelWtDDFvni4jKj1/sYBswsm3loHNcWtNWXcLvhTbkxs9cc/EFQ9lzuN8U97e38=
X-Received: by 2002:a25:d308:0:b0:b92:3ed2:1cae with SMTP id
 e8-20020a25d308000000b00b923ed21caemr22265681ybf.12.1683811602311; Thu, 11
 May 2023 06:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511123148.332043-1-aleksandr.mikhalitsyn@canonical.com> <ZFzpqZCV6V+hwKjI@t14s.localdomain>
In-Reply-To: <ZFzpqZCV6V+hwKjI@t14s.localdomain>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Thu, 11 May 2023 15:26:31 +0200
Message-ID: <CAEivzxennLfeh=pbMBA2Qj_DQXLMijGKVcRiKuraacCxc=9mgA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] sctp: add bpf_bypass_getsockopt proto callback
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 3:12=E2=80=AFPM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Hi,

Hi Marcelo,

thanks! Fixed in -v3.

Kind regards,
Alex

>
> Two things:
>
> On Thu, May 11, 2023 at 02:31:48PM +0200, Alexander Mikhalitsyn wrote:
> > Add bpf_bypass_getsockopt proto callback and filter out
> > SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
> > from running eBPF hook on them.
> >
> > These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> > hook returns an error after success of the original handler
> > sctp_getsockopt(...), userspace will receive an error from getsockopt
> > syscall and will be not aware that fd was successfully installed into f=
dtable.
> >
> > This patch was born as a result of discussion around a new SCM_PIDFD in=
terface:
> > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalits=
yn@canonical.com/
>
> Cool, but the description is mentioning the CONNECTX3 sockopt.
>
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
> > ---
> >  net/sctp/socket.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index cda8c2874691..a211a203003c 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -8281,6 +8281,35 @@ static int sctp_getsockopt(struct sock *sk, int =
level, int optname,
> >       return retval;
> >  }
> >
> > +static bool sctp_bpf_bypass_getsockopt(int level, int optname)
> > +{
> > +     if (level =3D=3D SOL_SCTP) {
> > +             switch (optname) {
> > +             /*
> > +              * These options do fd_install(), and if BPF_CGROUP_RUN_P=
ROG_GETSOCKOPT
> > +              * hook returns an error after success of the original ha=
ndler
> > +              * sctp_getsockopt(...), userspace will receive an error =
from getsockopt
> > +              * syscall and will be not aware that fd was successfully=
 installed into fdtable.
> > +              *
> > +              * Let's prevent bpf cgroup hook from running on them.
> > +              */
>
> This and..
>
> > +             case SCTP_SOCKOPT_PEELOFF:
> > +             case SCTP_SOCKOPT_PEELOFF_FLAGS:
> > +             /*
> > +              * As pointed by Marcelo Ricardo Leitner it seems reasona=
ble to skip
> > +              * bpf getsockopt hook for this sockopt too. Because inte=
rnaly, it
> > +              * triggers connect() and if error will be masked userspa=
ce can be confused.
> > +              */
>
> ..this comments can be removed, as they are easily visible on the
> description later on for who is interested on why such lines were
> added.
>
> Thanks,
> Marcelo
>
> > +             case SCTP_SOCKOPT_CONNECTX3:
> > +                     return true;
> > +             default:
> > +                     return false;
> > +             }
> > +     }
> > +
> > +     return false;
> > +}
> > +
> >  static int sctp_hash(struct sock *sk)
> >  {
> >       /* STUB */
> > @@ -9650,6 +9679,7 @@ struct proto sctp_prot =3D {
> >       .shutdown    =3D  sctp_shutdown,
> >       .setsockopt  =3D  sctp_setsockopt,
> >       .getsockopt  =3D  sctp_getsockopt,
> > +     .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
> >       .sendmsg     =3D  sctp_sendmsg,
> >       .recvmsg     =3D  sctp_recvmsg,
> >       .bind        =3D  sctp_bind,
> > @@ -9705,6 +9735,7 @@ struct proto sctpv6_prot =3D {
> >       .shutdown       =3D sctp_shutdown,
> >       .setsockopt     =3D sctp_setsockopt,
> >       .getsockopt     =3D sctp_getsockopt,
> > +     .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
> >       .sendmsg        =3D sctp_sendmsg,
> >       .recvmsg        =3D sctp_recvmsg,
> >       .bind           =3D sctp_bind,
> > --
> > 2.34.1
> >

