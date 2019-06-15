Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0600947239
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfFOVdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:33:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44802 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:32:59 -0400
Received: by mail-qk1-f193.google.com with SMTP id p144so3957081qke.11;
        Sat, 15 Jun 2019 14:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjG8ZsImg3X3Oer8t/aL738eUoq+KPyb1iO8dk+C3Rg=;
        b=GgFku/Z1CJaSZNe7XIV26r+p0H1oZNj2j/BhAwFEtUqnzFQZ1pMoHDeBbDWKfS9v08
         /NmBoc3Al9xcCCESbDbzQI8Lxx2RFon1bRKXGGd37194CCTSsLxCSxM7xoC2ieCfc2iA
         o1yXHg0tRMwvLdnzMFNE7/eEoOBrjhXVZi9oIVqmfd8EL5LbFOaHnki40OLCC+ovNV79
         1K2SeaZR68mGjxVZfOVBMvtTZc3vIhESJH6HptlTUjs2FLtG2VOh2nsiSzbyLtK4fBh8
         W3r/hUebUK0ETQqyC14uafW6F9OrxoafFFnTvxB3xBDWU0hI822C41edy2BZNXRbIilL
         s68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjG8ZsImg3X3Oer8t/aL738eUoq+KPyb1iO8dk+C3Rg=;
        b=KUE5zT1XiiGMiFx0vnTI+GGrIH1RHmCVu1bAUZEsJqFWVIMj9o+6/62o8H4sAQmoZG
         ReUERTbQr6qUSEGYwyUsnfNHRtZyVNdL+YSc/7Aub5DW1x6QwmUxed0B7qzEFZ599NAO
         ax8+kbfqmLiGVzACB94+QU6ysT7oNkyxygPfdx7KKJHUJyv4rlCUfYFHhOhdLSBo4lIE
         Vuna09PVS5ZvJoE1cE+SYN7xcNnahfz7hFap1YBR56UgP/r3uSDdl8fDuiwLJHqaFNvy
         lPdslDnVrt/HniOqiZZV1eGLz+jrJTBusohOG+ebW2ogOj6ViYao02pLb1939C0iRMDA
         6GtA==
X-Gm-Message-State: APjAAAVjvWZAu8yxG303MQ0NBaDCYnPIv2H2MSIDMmSg4gv9TD9U/Czv
        tgcvAjhSxwqgZls1l53uStPbVIikFCnII0Em6Z8=
X-Google-Smtp-Source: APXvYqwuODxOnfpMvIyBJ3+lG4pcZ3PSrlH0WHXTIi5R9G3Nn51t+yh3c0sqMyNwhcXwB3HqNlIH2y1ypGUupvjgUyU=
X-Received: by 2002:a37:4e92:: with SMTP id c140mr82706029qkb.48.1560634378615;
 Sat, 15 Jun 2019 14:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190611043505.14664-1-andriin@fb.com> <20190611043505.14664-4-andriin@fb.com>
 <CAPhsuW7bowxNMr22UkCvTkq8VHYrNiEJtQSdZjausj_8d4oYUQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7bowxNMr22UkCvTkq8VHYrNiEJtQSdZjausj_8d4oYUQ@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 14:32:47 -0700
Message-ID: <CAPhsuW5iSzZ1BQFd4dUmc4gtR_DY1D7pjwsc+uyrOHSdLZtb=w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/8] libbpf: refactor map initialization
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 2:02 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 9:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > User and global data maps initialization has gotten pretty complicated
> > and unnecessarily convoluted. This patch splits out the logic for global
> > data map and user-defined map initialization. It also removes the
> > restriction of pre-calculating how many maps will be initialized,
> > instead allowing to keep adding new maps as they are discovered, which
> > will be used later for BTF-defined map definitions.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Ooops, wrong thread...
