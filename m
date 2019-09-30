Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022F9C2A11
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfI3Wx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:53:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39992 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfI3Wx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:53:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id y144so9371677qkb.7;
        Mon, 30 Sep 2019 15:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ij9FhoJpV98i4H+2bq5OjOzY9TzpgiX4TlbivRz8Bxw=;
        b=NXMeX6nHO1wNdNGlFXPPAgn8EZ0KoXWH5UdHBbNfSKDiePAE2cNE0sAqLzsaWpe+3n
         OvTmuCzsLozWUSn+KRBEnGfdR9SGgVqyzDx95n/Yc5L5hDYfDUCJKDJvG8mZ7uIg/hu0
         qNUmnlSjZlZ6aoZCo8nWczbzsCO0P0DevbxObYAQUn6kQ5wwRoVjIX3ntWZKABjk/eBY
         xJj13dllTozWPVrzA4e0cl1O3M1D/sDvPClLjnIdon7p12lWhpG/bfDLmiOvmyt4qo8K
         //d/YpMw+zaDBcK1Sc1zczQs3Lw3nNUHAmQqWrmZuQlSTNfpr1PsQhfMPPvJqo1lHSBZ
         gpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ij9FhoJpV98i4H+2bq5OjOzY9TzpgiX4TlbivRz8Bxw=;
        b=ZC+Q0mwzMiImTaMkdfntOunxrVbJ54GEh1tlRLSEL7r52bIjjKkbe9Px3ge4mcM0ti
         3RKbPGN1trHnHwCKN+VYmaKqatD0u3iyfmRehWMdQ7Ofqmm9NCkvGBS2lPnLbTv8zdxS
         j0LGgqI9U9nZjQ6/NQbIGVWfWW7LUe7+QB8GQOsqYLZATKO9a/iNJtX7ihU18mhgN62A
         xbXj65RmDH6xtP1wKKaypHH1F/yhyd7LhwJgZGAufVVU03deLDGNzY66lEOZHZrTXCiN
         4sq4tIsIGhURF59Ttv8Imh5Hx72ItE6aT4qNhj+2yN0D3vKBzWBNSFS8OVgRCIz8u0By
         lMdQ==
X-Gm-Message-State: APjAAAU2BJcsWt8w83YWG5RiorK1CMmjUVa3M8eC9I9wCvI/uYeuwZUp
        wv5DnDfBnFG/fC2A+cXASV0YSArU7Fgz6AAehPs=
X-Google-Smtp-Source: APXvYqyd/jjvAV6BIScNTTPID2lwTfAWofDgXaKT83XJsMabaXWTMfZe5v9ynq0mmwmNrtegGWAR2SFeCtwPHPBpZuc=
X-Received: by 2002:a05:620a:113a:: with SMTP id p26mr2823467qkk.353.1569884007605;
 Mon, 30 Sep 2019 15:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-2-andriin@fb.com>
In-Reply-To: <20190930185855.4115372-2-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 30 Sep 2019 15:53:16 -0700
Message-ID: <CAPhsuW6dSs__fCw4C2HZ_jA7s=2mbW2L8cLCxyAcPLFQ3hsKHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] selftests/bpf: undo GCC-specific
 bpf_helpers.h changes
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 1:42 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Having GCC provide its own bpf-helper.h is not the right approach and is
> going to be changed. Undo bpf_helpers.h change before moving
> bpf_helpers.h into libbpf.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
