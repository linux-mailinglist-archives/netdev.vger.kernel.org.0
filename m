Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B6A6D712C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbjDEARZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbjDEARY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:17:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D044A8;
        Tue,  4 Apr 2023 17:17:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h8so137014070ede.8;
        Tue, 04 Apr 2023 17:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680653842; x=1683245842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBQuZ6cO4NqY3NwYWWJVtGbrQabyGh82co3p2xzwZi0=;
        b=JS0d3mSkT+PTeY8hdM8VYfm38Z3pU3M+ONW09aFWXqiYZ89KXTRUDJqTxzdCTDn2l/
         3Rdt/9zF+oHXj4Mos1sZZBY5aXLUWi5bc8Y5rNT+RXgW23Jj8wED1yVren2xSN2vGXqk
         3TLa3vR3p5Ox2byh+gUWT2f3/39X+jt4Yg1UfWi+1Obt0Qn/lwfDbfbWqk/VTawGNkXF
         1pbqzDoXb/N8LLoH2llPPlMdTcXyVvpq+HSjsfKB+Xrif6bMhG7v25GiWdezfGXLrotZ
         ompQmFIKGUdsVQ45YNOnqDLYdkoynWKhCWGO+XlsSg7mxs4V2jXFATJgtUHEM2Gn+Tb9
         nujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653842; x=1683245842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBQuZ6cO4NqY3NwYWWJVtGbrQabyGh82co3p2xzwZi0=;
        b=jzsvjrNIgiiWk/KmJ6+qTbWUkgxibW8JxOgR4XLqPszoyGcpoiNJNOsep7rBwPM0fR
         HSsfMzHVwQOpGOuO1Jk2AX75UEpQxmllSRfPdEdr448AAC7ed//yNgLYcBdsizQCDhhj
         kBK03oOEUCeAgi+NFhqzH/r3cTdx88msU+gz4EFkWMaxRQCnp7JJ7O9wPO19X45b6hm8
         py/5Gls1GNRBk2rA/AhyeiTY6Xv5fP963RYQoKjPrmRBQHbPu5/Jf2JmkrC2TLFsFv/E
         GnYV/FAsdyY9/Lu7HAjYh260rkqcEmnyHsONnpis5HIg+3dSvZpH2pk189B4OPicfhMP
         o5ng==
X-Gm-Message-State: AAQBX9dFe8yFJpUFkzS5+xyPZyoaocTKJiO+7ijOIMzM2IRLIpthgSZD
        j+z8kqkmyXYtEumXX7FvO/4ZQm7eK4mwSFG3ATc=
X-Google-Smtp-Source: AKy350avomeUafV60ijc8SGUwOyEkPbz/jsL6d3G/T6tWKQ8iFlL9zCEJNZJie8BSTsK/yPIX2dskG4Sp6Yp449OOEE=
X-Received: by 2002:a17:906:3716:b0:93e:739f:b0b8 with SMTP id
 d22-20020a170906371600b0093e739fb0b8mr691617ejc.3.1680653841499; Tue, 04 Apr
 2023 17:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404045029.82870-5-alexei.starovoitov@gmail.com> <eb07aa5a-e44c-67b7-e9c9-bd65602680ae@linux.dev>
In-Reply-To: <eb07aa5a-e44c-67b7-e9c9-bd65602680ae@linux.dev>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Apr 2023 17:17:10 -0700
Message-ID: <CAADnVQ+z0ZLwo=rCSa=TrS-NFkgHy8r=nK38wgA5vmz4u2iyUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers
 accept NULL pointer.
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 5:10=E2=80=AFPM Martin KaFai Lau <martin.lau@linux.d=
ev> wrote:
>
> On 4/3/23 9:50 PM, Alexei Starovoitov wrote:
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 1f2abf0f60e6..727c5269867d 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4998,7 +4998,7 @@ const struct bpf_func_proto bpf_get_socket_ptr_co=
okie_proto =3D {
> >       .func           =3D bpf_get_socket_ptr_cookie,
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_INTEGER,
> > -     .arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> > +     .arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON | PTR_MAYBE_NUL=
L,
>
> I think the bpf_skc_to_* helpers (eg. bpf_skc_to_tcp_sock) also need simi=
lar
> change. They are available to tracing also. It can be a follow-up. The pa=
tch set
> lgtm.

Ok. I'll take a look.
