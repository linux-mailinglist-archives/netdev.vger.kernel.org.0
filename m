Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E3E1EFE69
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 19:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFERB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 13:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFERB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 13:01:27 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37DAC08C5C2;
        Fri,  5 Jun 2020 10:01:26 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w15so6194552lfe.11;
        Fri, 05 Jun 2020 10:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TQBeMAHegSU6vi1JW8GGxymtHU69nXgBZNJa0QtMlEs=;
        b=QHLdtp93iVhG6vnBckSNZprRpwY7oevhrSy68iljq8zxVmJSdBOdDvhsQeNMtOPOiy
         kdmEYW/ocvKn+wpAFj3EYN7+gGh+M2nYdMtx3oGIZYfggym2uCyfSBnqwLi8ASmdg7OA
         +uvyWJEKrhlouTp8MJz5fUKhZWjdtLbbiEjKBHtVa7qJiXmfTIYI2PBAVofbgDjo5lie
         yONoK31No44Ej5hvcIO8+bLe9Oepnb5Xh+4mG3cVv8+U651yLIeiw0wf2qerdC5Yd3Iu
         utypOWqxxhxKR/NbUs9Lt3MynmdQ6W3D3yqCfqD+ea7j8Z1nQsd2HLrLIfZXGmwr3nM3
         eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TQBeMAHegSU6vi1JW8GGxymtHU69nXgBZNJa0QtMlEs=;
        b=f4fi79fEQfDyVGmJWEieU/ST9UOGVuPLLlorsysfbAIilbKiOCRVr7aPNfZxwsShwZ
         iiDLF0f8Dh8ShPq4IHXXUIoBUZSwAQva1lO7xIp1o6V/7YJ+oZROxe+WnwXeg41rEzSn
         tJ2sqScmL6f2ToJ9ofeErEKioBXvbnxUPkctBbYCJxSjCBzlNi/ddJalov1mWrOyuGgK
         rHksyWM22xo1k8sLAgeZVKyYp7FZrr6snnOhzY5IyW1tz8J5GmbZSKkHME/AgMQQdxvy
         xorsZSpj38HYXth8qojQvlisAMUqaxG8lU96dhEOKPhO7Y/6ZWRJhC3g6Eb9qhYJHWJ+
         zYXA==
X-Gm-Message-State: AOAM530zyHt1ukLgRGwX4pfoLBOyK5G7V0+PASFuy/DAMC3dm2T1U8rf
        Rp2EoT7w2U0nyF3/ktTPcf2VmB7WiHtM0eL6WP4=
X-Google-Smtp-Source: ABdhPJwVtotXaFfxvU1mleN09KTtQFQP6Fjdh/nRRORtZoUvoIqBtmpxk/kvrZnmdetayQmMUXgMWGbATCv5rEUQlRQ=
X-Received: by 2002:ac2:544b:: with SMTP id d11mr5765407lfn.157.1591376485139;
 Fri, 05 Jun 2020 10:01:25 -0700 (PDT)
MIME-Version: 1.0
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
 <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
 <20200604174806.29130b81@carbon> <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
 <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com>
 <20200605102323.15c2c06c@carbon> <87y2p1dbf7.fsf@toke.dk>
In-Reply-To: <87y2p1dbf7.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 5 Jun 2020 10:01:12 -0700
Message-ID: <CAADnVQLzrWVfgSogXpOm3F1TZF5jxDoQD+VsS4mQVAkEkNjNwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 5, 2020 at 4:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>
> > On Thu, 4 Jun 2020 10:33:41 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> >> On Thu, Jun 04, 2020 at 10:40:06AM -0600, David Ahern wrote:
> >> > On 6/4/20 9:48 AM, Jesper Dangaard Brouer wrote:
> >> > > I will NOT send a patch that expose this in uapi/bpf.h.  As I expl=
ained
> >> > > before, this caused the issues for my userspace application, that
> >> > > automatically picked-up struct bpf_devmap_val, and started to fail
> >> > > (with no code changes), because it needed minus-1 as input.  I fea=
r
> >> > > that this will cause more work for me later, when I have to helpou=
t and
> >> > > support end-users on e.g. xdp-newbies list, as it will not be obvi=
ous
> >> > > to end-users why their programs map-insert start to fail.  I have =
given
> >> > > up, so I will not NACK anyone sending such a patch.
> >>
> >> Jesper,
> >>
> >> you gave wrong direction to David during development of the patches an=
d
> >> now the devmap uapi is suffering the consequences.
> >>
> >> > >
> >> > > Why is it we need to support file-descriptor zero as a valid
> >> > > file-descriptor for a bpf-prog?
> >> >
> >> > That was a nice property of using the id instead of fd. And the init=
 to
> >> > -1 is not unique to this; adopters of the bpf_set_link_xdp_fd_opts f=
or
> >> > example have to do the same.
> >>
> >> I think it's better to adopt "fd=3D=3D0 -> invalid" approach.
> >> It won't be unique here. We're already using it in other places in bpf=
 syscall.
> >> I agree with Jesper that requiring -1 init of 2nd field is quite ugly
> >> and inconvenient.
> >
> > Great. If we can remove this requirement of -1 init (and let zero mean
> > feature isn't used), then I'm all for exposing expose in uapi/bpf.h.
>
> If we're going to officially deprecate fd 0 as a valid BPF fd, we should
> at least make sure users don't end up with such an fd after opening a
> BPF object. Not sure how the fd number assignment works, but could we
> make sure that the kernel never returns fd 0 for a BPF program/map?
>
> Alternatively, we could add a check in libbpf and either reject the
> call, or just call dup() before passing the fd to the kernel.

Tweaking libbpf to do dup() was on our todo list for some time.
I think it would be good to do it both in the kernel and in the libbpf.
