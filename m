Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAB252990D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiEQF2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiEQF2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:28:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE1D2E0A9;
        Mon, 16 May 2022 22:28:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so16406564plh.1;
        Mon, 16 May 2022 22:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vP2k6p1hXL/OnkjVPsFTw8t7G/cPhv7l7SOpeW4rWUU=;
        b=I2rvfgNTS1KaPUcJiLVL4cAa81QPYVNiowH0MijXKJ3X2yCxIHPMOjoHCTL5rtnoQb
         KzT1PKy1phYNYWW6m/n8ZEpQzXm664fMOjfgNhNOO2BDLCl6h/KewlRCq3ZyQTWLLX9f
         3lyPBt02YPYR0trEEUTYl+iozOIyFQrxkyuMfk0tLWDjVXmgCKB8faQyS3o2QTyCWASY
         /w9qrfu5njUTS9/n26l/BqElecspO6m8OLnu/Y5K3XTACsmkGNdoEwhoiTQaC4CsmRE7
         Ty3ovD3oQFOAu5f1c54K/js3xjlZXUvGOjKXfUJ7Smvo/3ZZgAcfISkDIB+F52GBRk85
         U+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vP2k6p1hXL/OnkjVPsFTw8t7G/cPhv7l7SOpeW4rWUU=;
        b=lH2uZTSRF95tnR1fqrn7xsXJ+eEfZa3e2UBdWVXUVezLm7ed7m31uCOr0zClmLkHxl
         YhXdxCiCv6t4V36X+DHtlQKDUP4NqXheeb9zGaaxHShoOMgoDF/RK0jCapvb6wE56wpA
         oZYvbA5gdohqRjdl9XGlez0mAbaAV9oi1cQ4bGTC0b0HoyblggYV6oPldHVVi5wkXn+J
         JvhK7Eq7cc1piDzvgaMIYytYLk+r1m+/2Loir4Ut09bKRkyz4qS73vknbiLgCXtOekZy
         uPM0mM7tqNqmJRbBsD1NnLylTKzSK3YQ106+XmRvebergEI5zkw6vVNOxuDvhTt64W6C
         sk9Q==
X-Gm-Message-State: AOAM533/4TCv00rDHdfzfawYyU86BVlaU+ubPDr7oTOCVqmh1nE2A1uX
        QHEaKyabYFWx+9oYbunh/JESZt3sXq08G3/7XBP+AjkaeA4KzA==
X-Google-Smtp-Source: ABdhPJyTNzdqhLvBp4cczPPOplblciEaWtgUvU1QlaJW8AbyVmp7lQzCkJGJ+O+cbe9vDlmtBMHwieVsFtIDiW6vuzE=
X-Received: by 2002:a17:90b:384d:b0:1dc:a631:e356 with SMTP id
 nl13-20020a17090b384d00b001dca631e356mr34007202pjb.82.1652765311273; Mon, 16
 May 2022 22:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-4-mathew.j.martineau@linux.intel.com> <20220517011827.6pk2ao23tb4xjuap@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220517011827.6pk2ao23tb4xjuap@kafai-mbp.dhcp.thefacebook.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Tue, 17 May 2022 13:28:33 +0800
Message-ID: <CA+WQbwtnvGO+NpVwHHPxp+wQW5vZYHPHydGZ6cjNnNGhFw1zmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/7] selftests/bpf: add MPTCP test base
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=8C 09:18=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 13, 2022 at 03:48:23PM -0700, Mat Martineau wrote:
> [ ... ]
>
> > @@ -265,7 +282,7 @@ int connect_to_fd_opts(int server_fd, const struct =
network_helper_opts *opts)
> >       }
> >
> >       addr_in =3D (struct sockaddr_in *)&addr;
> > -     fd =3D socket(addr_in->sin_family, type, 0);
> > +     fd =3D socket(addr_in->sin_family, type, opts->protocol);
> ops->protocol is the same as the server_fd's protocol ?
>
> Can that be learned from getsockopt(server_fd, SOL_SOCKET, SO_PROTOCOL, .=
...) ?
> Then the ops->protocol additions and related changes are not needed.

Yes, I will update this in v5.

>
> connect_to_fd_opts() has already obtained the SO_TYPE in similar way.
>
> >       if (fd < 0) {
> >               log_err("Failed to create client socket");
> >               return -1;
> > @@ -298,6 +315,16 @@ int connect_to_fd(int server_fd, int timeout_ms)
> >       return connect_to_fd_opts(server_fd, &opts);
> >  }
> >
> > +int connect_to_mptcp_fd(int server_fd, int timeout_ms)
> > +{
> > +     struct network_helper_opts opts =3D {
> > +             .timeout_ms =3D timeout_ms,
> > +             .protocol =3D IPPROTO_MPTCP,
> > +     };
> > +
> > +     return connect_to_fd_opts(server_fd, &opts);
> > +}
> > +
> >  int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
> >  {
> >       struct sockaddr_storage addr;
> > diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/test=
ing/selftests/bpf/network_helpers.h
> > index a4b3b2f9877b..e0feb115b2ae 100644
> > --- a/tools/testing/selftests/bpf/network_helpers.h
> > +++ b/tools/testing/selftests/bpf/network_helpers.h
> > @@ -21,6 +21,7 @@ struct network_helper_opts {
> >       const char *cc;
> >       int timeout_ms;
> >       bool must_fail;
> > +     int protocol;
> >  };
> >
> >  /* ipv4 test vector */
> > @@ -42,11 +43,14 @@ extern struct ipv6_packet pkt_v6;
> >  int settimeo(int fd, int timeout_ms);
> >  int start_server(int family, int type, const char *addr, __u16 port,
> >                int timeout_ms);
> > +int start_mptcp_server(int family, const char *addr, __u16 port,
> > +                    int timeout_ms);
> >  int *start_reuseport_server(int family, int type, const char *addr_str=
,
> >                           __u16 port, int timeout_ms,
> >                           unsigned int nr_listens);
> >  void free_fds(int *fds, unsigned int nr_close_fds);
> >  int connect_to_fd(int server_fd, int timeout_ms);
> > +int connect_to_mptcp_fd(int server_fd, int timeout_ms);
> >  int connect_to_fd_opts(int server_fd, const struct network_helper_opts=
 *opts);
> >  int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
> >  int fastopen_connect(int server_fd, const char *data, unsigned int dat=
a_len,
>
