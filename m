Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0732779A19
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfG2Uhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:37:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40338 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfG2Uhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:37:46 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so60823179qtn.7;
        Mon, 29 Jul 2019 13:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0+qMs/DAzESeq9DchANEP4p5xDXagkeWxkgEMuPkCw=;
        b=Ill3DDk/Sj/8N0RRN76wOh4jqEx3NQuAYu+gD4AzIISCg/a356RaVHWTr0S5WwhFLP
         Z1cmKjhmq6YTET0GQKCA8lOZtqTUxcNqyLDF4fdL7I1EnyXGmT+BN4z714KuBd7qPtPj
         dWNjYCQtY9I94CF8bRpqJ1XHVHGfPQizQfgqcZ0j967JWgTd9MoMo16wX0n06pJYvBha
         oMralRKB3OQub3lNf/9n84VXLrh57Jq5g955BZ4dAe1M8enS8+7YN2xMmnfZANqYdLXm
         i1cYGVen4FO1iLa7qNFVIFtzuKGtX07qz1KtDUDHxH7mM69PszFkPLrFNKopfWlh3w1+
         JTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0+qMs/DAzESeq9DchANEP4p5xDXagkeWxkgEMuPkCw=;
        b=oe6kaXZ0RXrWVmdmM06exGd8fvNTK5Oscs9eevC8tH2iAlL8ttKQaU5WP924rKa+wq
         6xudcemeKYEMrY/c/dKXVcIpLo+nbEH3lnnHx4P47QqasvY1KliqI/yKFtMpqm502XD0
         G2FhCx7Kdrt7l1Zt+tDNO4N5b/JrEh+tpvRuKcXkdYxKw5ZvE7363uxHl+3CKBKBCIDP
         7TPwI3xdqAuwm8lrjFUkAPH3UU/q8NTHxne2CIq987ZnHxl0/SH/AyDoIiswhguEk6RN
         tMY4KFTD95vPERPMbjbQAaryXEZsBpttueW14Dv+lrFSrvaTraBO2NwgFmeTc2CBxRDG
         NHzg==
X-Gm-Message-State: APjAAAUuKhgWU31gCoGqM9XuJDlAFnJq5SuqdNQGEVRi5d39yXlKDqgQ
        MjqqSYUvhuoD42Efop5lvNoIf/eN6X1FiLeAWxw=
X-Google-Smtp-Source: APXvYqws9W0GmLfIvkNUkZ/VBYYxfh0pHjFSr51tcLfg4pdlFlsMH5U1saGY4PtcT2U8slUGDUVqxpcCifuH6Iqxb00=
X-Received: by 2002:ac8:152:: with SMTP id f18mr76661441qtg.84.1564432665017;
 Mon, 29 Jul 2019 13:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-5-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-5-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 13:37:34 -0700
Message-ID: <CAPhsuW7ryBms0KsRrcrmVX7QwCeAfxhpnx=xDoJwMtFjaPzt1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/10] selftests/bpf: add CO-RE relocs struct
 flavors tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add tests verifying that BPF program can use various struct/union
> "flavors" to extract data from the same target struct/union.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
