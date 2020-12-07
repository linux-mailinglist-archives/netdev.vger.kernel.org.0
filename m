Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21D12D156B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgLGQBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbgLGQBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:01:41 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B171C061793;
        Mon,  7 Dec 2020 08:01:01 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id f11so3622180ljn.2;
        Mon, 07 Dec 2020 08:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vYbfOYPjETzFJFJB48KuY9f+Uk2jjLJu+B88mllyQ70=;
        b=lRfQmiJ5Dq9ktExYA4P7tftcsRNiHk1wAgZyGRgJ9AfMIoOwOpIZZA070LDRxBPOWx
         YIDh4v1c8/eOBY7kKvrk9oqza8gz/X1LKr0Q6XFTbn2pRXHIWvsFHxwrKropNyynpS57
         B5ts5Yoka1ZQzIgP/YoISs6FFQCLRG8TFgTFZij5zF8imWVIf/xtGKa/G4nXaTmL25g0
         iz6Vd9d0RM7d4oLiSRsTA1MLIHemI6XJWQdN3T54qArSUiX2SrPEZN48KoUWrw8Ur6SP
         zpfN+JeHpu/B/1jff5WIWtp6x02Z/y/5B6W4usq6VCND1ftZ5DS+Ygj0tPChj6Oo1V1e
         Kn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vYbfOYPjETzFJFJB48KuY9f+Uk2jjLJu+B88mllyQ70=;
        b=ZhqayeDrs66w9rgy0wMUey/b5Q7EgiDlN5m9V0Mi5MifPxTVpOPyxYlOjBWPAe3Qd+
         HrF2EsfNBGXk/LULcV96uFKP7O6BdPD4Nq4tk0ZEUZ2URlQotrOWqOAo1UxcsA73Gv3o
         zS3NjxTw8x+pY7A+BwSNa3rmJ6oac669u7Fptveygs78I//sugLmUCGSJSjDJBhtnBHB
         DI18UTXXuLjyH61WBI7IDBrewa3+gI4tnWIKjZHrD+zUKkN7XidCJxLd//X7tExu+YL5
         BlDFWPyVws8HY+Wx4btG7OTNVAvLCo1Yq/C4JOHrbbUziKaLhuD5lLIO28glzkc9zjnN
         BvhA==
X-Gm-Message-State: AOAM5325HNJw7wRnSpY/HTPaWH+GGfaTUY7aWatKFj+yQmX0BXbe5PzY
        zsMPIdoU165NY/FuXWI6iz95bLbP/+65rUdd/5o=
X-Google-Smtp-Source: ABdhPJzaIY65XsJ71A+45wDE3Kbh7bzrzN9+9kAJfUHOTIZMo9zdZHClRgbC6BSumPN+c5V7ZQexiBuXeex3eSSQBdA=
X-Received: by 2002:a2e:6c14:: with SMTP id h20mr8905600ljc.450.1607356859901;
 Mon, 07 Dec 2020 08:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20201205030952.520743-1-andrii@kernel.org> <CAADnVQK25OLC+C7LLCvGY7kgr_F2vh5-s_4rnwCY7CqMEcfisw@mail.gmail.com>
 <87lfe9676n.fsf@toke.dk>
In-Reply-To: <87lfe9676n.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Dec 2020 08:00:48 -0800
Message-ID: <CAADnVQKxePN0wf0mTHfMXPPCBV3QArOyW_6FkHQEXctKnniGmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: return -EOPNOTSUPP when attaching to
 non-kernel BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 6:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Fri, Dec 4, 2020 at 7:11 PM Andrii Nakryiko <andrii@kernel.org> wrot=
e:
> >> +                               return -EOPNOTSUPP;
> >
> > $ cd kernel/bpf
> > $ git grep ENOTSUPP|wc -l
> > 46
> > $ git grep EOPNOTSUPP|wc -l
> > 11
>
> But also
>
> $ cd kernel/include/uapi
> $ git grep ENOTSUPP | wc -l
> 0
> $ git grep EOPNOTSUPP | wc -l
> 8
>
> (i.e., ENOTSUPP is not defined in userspace headers at all)

that's irrelevant. The kernel returns it already. It's a known constant
regardless of .h
