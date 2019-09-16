Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB90B3449
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 07:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfIPFJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 01:09:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45373 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbfIPFJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 01:09:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so2957903qtj.12;
        Sun, 15 Sep 2019 22:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8kEmIui+V45ORWT0/SoHUmGNe0Ir9S1igfDbRHAK2GI=;
        b=LHSqKAOenxXhnea96Ijkhfovd7rosMs372hVGTusS+smUTsNySGAdvJ0OVS3e7apW1
         ijYGaNg/DbVhAZwXpLnEgH8Fzt0KRZyYWLY9rLDP5O+AEAHGDeyrST423Ghy6Z3f7phc
         6iiNZGll/NGZQsEhXJvp9khBB00HtFm+WjqIyWGQCoDGr9iYxxCEqra0LZ7O9Yp8THm6
         KLaMJnwSCTQzVYJPAzgeVNXS/S4gGitN9ZRFvUXPWz8C+Dpi8lQv/5rqKDaMDWsgsLrN
         KIy0rvqVq2tbmb42AxSDvILY5xbWmW3HD/IxnXwR6FYopv840y4Sm19krLQAcKdAirvH
         pOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8kEmIui+V45ORWT0/SoHUmGNe0Ir9S1igfDbRHAK2GI=;
        b=pi18oEYjxIo/uzwUY6KuPhuOXvmtVf1nIpY3iRJ1KV93Q3R2axZk9ZzMkCR8lxYCiV
         66ESTeVR8DWE7rakeLCNC/9Cu+EvYq+42/bUi5z3fC1kkGBLoBbpPgmLgknHUAdkfe0l
         uhXdYjqgMiBWU/lZ9KvkTOrXVjzR734bSNQSuyI9ZNwtnFDZ4M8EoqK0DbgCveiQohwh
         DWpROn6RYmdjv+8xf/jf4dl2cYuhIiNwC/CrP2At5ESlj/y6jbhg+FWK0UaLDVAP39OF
         JrC78cBDlkhr604X+OhQaXqGlxyotO65l/qrJwbLosKEMsWXt77XKM0NjCba1J9vPV7U
         JfCg==
X-Gm-Message-State: APjAAAXXdeUOUa5KUGIjAZIUGjh2KPJiSgYndmuGog6CHW1Fa4sfyeSC
        tufOagXOKb6dGKC2Ao2Ae+dasl6+rkraRQIMKBg=
X-Google-Smtp-Source: APXvYqzwCSXIClc8HDmuXJhxznxFkQVHZb9kjcr90hjd5cPvxPTmi4bYzusioJK3WWhuvq7ci7zggrvwaLrX8o1rnlw=
X-Received: by 2002:ac8:5381:: with SMTP id x1mr15290589qtp.37.1568610557299;
 Sun, 15 Sep 2019 22:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190909174619.1735-1-toke@redhat.com> <8e909219-a225-b242-aaa5-bee1180aed48@fb.com>
 <87lfuxul2b.fsf@toke.dk> <60651b4b-c185-1e17-1664-88957537e3f1@fb.com>
In-Reply-To: <60651b4b-c185-1e17-1664-88957537e3f1@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 16 Sep 2019 07:09:06 +0200
Message-ID: <CAJ+HfNjNFJP2gi7Egm4gV__MzZKLipHwuebT9MG2bYb6o8MG8Q@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Don't error out if getsockopt() fails for XDP_OPTIONS
To:     Yonghong Song <yhs@fb.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Sep 2019 at 21:46, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/10/19 12:06 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Yonghong Song <yhs@fb.com> writes:
> >
> >> On 9/9/19 10:46 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>> The xsk_socket__create() function fails and returns an error if it ca=
nnot
> >>> get the XDP_OPTIONS through getsockopt(). However, support for XDP_OP=
TIONS
> >>> was not added until kernel 5.3, so this means that creating XSK socke=
ts
> >>> always fails on older kernels.
> >>>
> >>> Since the option is just used to set the zero-copy flag in the xsk st=
ruct,
> >>> there really is no need to error out if the getsockopt() call fails.
> >>>
> >>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> ---
> >>>    tools/lib/bpf/xsk.c | 8 ++------
> >>>    1 file changed, 2 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >>> index 680e63066cf3..598e487d9ce8 100644
> >>> --- a/tools/lib/bpf/xsk.c
> >>> +++ b/tools/lib/bpf/xsk.c
> >>> @@ -603,12 +603,8 @@ int xsk_socket__create(struct xsk_socket **xsk_p=
tr, const char *ifname,
> >>>
> >>>     optlen =3D sizeof(opts);
> >>>     err =3D getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen)=
;
> >>> -   if (err) {
> >>> -           err =3D -errno;
> >>> -           goto out_mmap_tx;
> >>> -   }
> >>> -
> >>> -   xsk->zc =3D opts.flags & XDP_OPTIONS_ZEROCOPY;
> >>> +   if (!err)
> >>> +           xsk->zc =3D opts.flags & XDP_OPTIONS_ZEROCOPY;
> >>>
> >>>     if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_L=
OAD)) {
> >>>             err =3D xsk_setup_xdp_prog(xsk);
> >>
> >> Since 'zc' is not used by anybody, maybe all codes 'zc' related can be
> >> removed? It can be added back back once there is an interface to use
> >> 'zc'?
> >
> > Fine with me; up to the maintainers what they prefer, I guess? :)
>
> Maxim,
>
> Your originally introduced `'zc' and getting XDP_OPTIONS.
> What is your opinion of how to deal with the unused xsk->zc?
>

This was previously discussed here [1]. The TL;DR version is "stay
tuned for a proper interface". :-)


Bj=C3=B6rn

[1] https://lore.kernel.org/bpf/CAJ8uoz1qhaHwebmjOOS9xfJe93Eq0v=3DSXhQUnjHv=
7imVL3ONsQ@mail.gmail.com/#t



> >
> > -Toke
> >
