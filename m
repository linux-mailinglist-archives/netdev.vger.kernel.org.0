Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D01B6155
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgDWQxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729673AbgDWQxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:53:10 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D34CC09B041
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:53:09 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id g10so5282106lfj.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qaev5q2HIUXhJonAyL1v+72X1yZns3D4gwqucz0nVto=;
        b=G7o8HWDehXz73yxY5Iwco9Qo0OqVBA4AWMwzy8WVO7AWIAIiePmtfNc3n3tY4SJNGC
         CbwrS/BsXRWy/GLlpP4iZcneX/AeSY7V3nwhYqHBHXQeL3F5S6ewMSeBmYxpjm30LJho
         jeZd9ROllrz27LrvXzSv8fHccTUbkp7UNb5DY5+ZywKRiWCR0qxSlIfuwdQx/4S3xR4Q
         nsZUlkdYP9H6A1Dgr4QUHUG39GvoNVMEtKbO0EoLVa9ChmdJPlAlRNLVNU2HfHxWwn1M
         WlcCP9+pA38scXKaxNwiM+zuR3ozb5eZWslJC4dos5lO/2LRzPai7ZXYqQmrU5ver/P8
         dGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qaev5q2HIUXhJonAyL1v+72X1yZns3D4gwqucz0nVto=;
        b=iki8LnhlJuY/qU8kWHbQ4VimsJ/QQ6e0Atp7G29OmJPzUMA0kc3+QnbVvEeXx2Be2n
         J08Uf+LI5W1urrx8QI6iTV7cj2Nor7xaRM+DWJFsv1Ij/he1zjOqCAZNUws0VLhrvy6m
         cxOKBpbr6dcwQBQWHfSp5jYhlom1dliZbSmt0r3HdAeGCPBJrDT93QT/0LaDFX8dC4nE
         iUwHaxxuhChGfqxl7r6WDKIivQQVf5JVnqEz6A2dRgAuDvh8Cc72foiivRjc21NLPuv3
         jfETM+gxMwOwtpN/tP8fL1Nk6S9G48ShOC97qDJuEKARukmWm63py/UI8hUMsfmxpsNJ
         Vlrg==
X-Gm-Message-State: AGi0PubpyicQTgRaUL4OM3PjAYbfBkQANuMmwY39k1Lh3u1BeMvq0d4+
        oPqRu20xB2gGCvgGOfYJyzbJC8/d0IYfLPe6PNQ=
X-Google-Smtp-Source: APiQypKuyAmVHowIW/k4HG16PJ5RgCQ181i2/kudpEZlo+DW1E3z9Y6Q1zqhvWGLY6SMpHewN7ude2BcB6gu39FO5rE=
X-Received: by 2002:ac2:4a76:: with SMTP id q22mr2984769lfp.157.1587660787388;
 Thu, 23 Apr 2020 09:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk>
 <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk>
 <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk>
 <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk>
 <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk>
 <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com> <878sim6tqj.fsf@toke.dk>
In-Reply-To: <878sim6tqj.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Apr 2020 09:52:55 -0700
Message-ID: <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dahern@digitalocean.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 9:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Wed, Apr 22, 2020 at 05:51:36PM +0200, Toke H=C3=83=C2=B8iland-J=C3=
=83=C2=B8rgensen wrote:
> >> David Ahern <dsahern@gmail.com> writes:
> >>
> >> > On 4/22/20 9:27 AM, Toke H=C3=83=C2=B8iland-J=C3=83=C2=B8rgensen wro=
te:
> >> >> And as I said in the beginning, I'm perfectly happy to be told why =
I'm
> >> >> wrong; but so far you have just been arguing that I'm out of scope =
;)
> >> >
> >> > you are arguing about a suspected bug with existing code that is no =
way
> >> > touched or modified by this patch set, so yes it is out of scope.
> >>
> >> Your patch is relying on the (potentially buggy) behaviour, so I don't
> >> think it's out of scope to mention it in this context.
> >
> > Sorry for slow reply.
> > I'm swamped with other things atm.
> >
> > Looks like there is indeed a bug in prog_type_ext handling code that
> > is doing
> > env->ops =3D bpf_verifier_ops[tgt_prog->type];
> > I'm not sure whether the verifier can simply add:
> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
> > and be done with it.
> > Likely yes, since expected_attach_type must be zero at that point
> > that is enforced by bpf_prog_load_check_attach().
> > So I suspect it's a single line fix.
>
> Not quite: the check in bpf_tracing_prog_attach() that enforces
> prog->expected_attach_type=3D=3D0 also needs to go. So 5 lines :)

prog_ext's expected_attach_type needs to stay zero.
It needs to be inherited from tgt prog. Hence one line:
prog->expected_attach_type =3D tgt_prog->expected_attach_type;
