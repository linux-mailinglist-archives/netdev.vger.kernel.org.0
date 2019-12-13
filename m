Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072FC11ECD0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLMVXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:23:35 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37721 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMVXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:23:35 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so210137lja.4;
        Fri, 13 Dec 2019 13:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f1slN2mkK8xs6G/MhtkTdmdutrXNzVbfJBL5Ni+GwHg=;
        b=VkQAsnbNVe11m7w6bTAK/efI+DUDQWBY68O3xL7vPuMaj+c2W66G7eiSudXWkGNpMd
         FJkJWesF2DwFGUTd5AfdmcWutVjW4hQZoS3rhll7EUcnGrPc8RlQJY4dZ0EAIKM/13Cr
         cEXtu5BJ9kVPGmI1YGjjUI7qFuEMjakpjtuPbyErUh7wgURKjUqn6ApkIuC7F1qSVC4S
         gl0Or1iGrCapsgwcX3Ac8lmCGS3fvczi/JKmZNDgeqd02y0MkDBifa0wBTXqWGvlzKPA
         9c6Jv+REQ+kG4/14ljUuKlKjEJhXj1FdbLtjG/FT3YkbExXKHFQHikSfna5ljJCyEUub
         sWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f1slN2mkK8xs6G/MhtkTdmdutrXNzVbfJBL5Ni+GwHg=;
        b=ImH9oyOK9mqgoTRkz00q6XAKkk1J7su5yRTsgdfzDIJK0NnZVrIpFrTqnKNIQluLwM
         62yOfg6JZYVqd+Usn6m+jC8MOdEoW8XDRPUYIl+9uy7yXeh0Ph6El1FMtkWfgnXGsYlx
         RuHjGJS6ktd+4H8PnbsJcnZLDlaizxOQRbS5UrvfUmHK9iotrzzYWNQeeQA2UMvqs9vF
         4C01mRFs916uLoCfw4Uh4x9zCbOKcRU2poz1IiQ9D6Y0430lyKZGFypg7RcfMcvZ6pNc
         Jirrx62tzt4UcQ0/OIj/DlmlHtSRcg+TKiy+ueN9nR3PP/KHCpbOQauPYbgy+7oT4EgX
         j/Bg==
X-Gm-Message-State: APjAAAXdnTjBtUtRyz2X8+lEqou9jMRC2vsIRyTcN3L9QSQEVHr8D86w
        EjWAxPbTme4GwiQ5wrpk2tTBDkG/XM04TOS6Uik=
X-Google-Smtp-Source: APXvYqyg+KeQgRXVJZDaUPbBmnIos7uPNGPm0OC3qfoP5mjou/q3men/6JEcxuvR2Oub8sziKTuimCywBRL3Bsfrp3o=
X-Received: by 2002:a2e:8e8d:: with SMTP id z13mr10963165ljk.10.1576272213118;
 Fri, 13 Dec 2019 13:23:33 -0800 (PST)
MIME-Version: 1.0
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
In-Reply-To: <20191213175112.30208-1-bjorn.topel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 13:23:21 -0800
Message-ID: <CAADnVQK5+z1n9xwkH0=W-8kwgqhp_LUPW=VfaMTTPAhKuNwxug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] Introduce the BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 9:51 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> This is the 6th iteration of the series that introduces the BPF
> dispatcher, which is a mechanism to avoid indirect calls.
...
> Revisions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> v4->v5: [1]

Applied. Thanks for all the hard work.
