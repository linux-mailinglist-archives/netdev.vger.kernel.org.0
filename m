Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C89631398
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEaRNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:13:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34755 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfEaRNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:13:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id h1so1798131qtp.1;
        Fri, 31 May 2019 10:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=544X13FkX9u2ekcWFzD5GzMImy25CpQbSx8OCXi0dEU=;
        b=Ag9LrYvGPgDs1xYGW1CTmER2FSXKw9hQqp4ZU7goGaMdLQmTcie6HV48OuQKVszW6M
         LYQ5q0sd+kNsj6jAPWD2lfvYZEpBnthEAUknzqQCmE78WzzBMtxU3XWvoJ+cP1VwYbmp
         30M1u8mLvpb+KSugRaVhQnFm2CjGQ1wFS4zVx17uQ5e9YqmR2YMbcS/6FuAI6NpegCb9
         aiAGnKXx0Q0PCb1xybI2e+gj2WJGUAvmgZt18F6FD1f+WmjF/peL+nY/swdmUKhHjQ3P
         HMyNEWeWV/oEphkaFJjxRkmMv/pgk/8gBbzkeVw3p5Cpd2XRK+F3v6wDfQ1F0e3lQ4ut
         nk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=544X13FkX9u2ekcWFzD5GzMImy25CpQbSx8OCXi0dEU=;
        b=c5So8od4xVfOJKdEAb8kwo/zxkHOTwQy135e02HO0UbjlZTk7m2kMwhyTKMqxLZ+ec
         hwS3U7wUGLW44hDKmFxUyfcFtl0gLrfW4fXT47YjogMcJpImLXBDgZNCZUD2wvHVeK3S
         yfMjewJnaFx+XJyE9AEQtt8IZzrwnE5wNLTprKfTs89LPDTQ3gSCHFfOgkOSKJ4CdT5F
         wDn2xvMfiRXWgPe6lSX13biVyk1lQFXmvKCRApa5++lOr3j5i2vbJ85FHpYd6vVqpvJy
         qMKcrNM9Lzr32JI+jv/PSqjNPs5Vi1ry2f1zIkPID8myv7BrRGNIgtTbYDIJ+4ZK+Cft
         Fy3g==
X-Gm-Message-State: APjAAAUjpqUHYITvlZNLGPpv4ni0yPYa1ESZ2YFIf58bVr1Buf7Ziw/R
        USpLmSrpsjUD21jXTZan0V78/n3CMiKHCJPegGc=
X-Google-Smtp-Source: APXvYqxBtUvkAQnP7rV42h1wMVSuHTLAKlWqsOgs2doRJTo/3699q9btWzvcdtfMAxazY0uLO/X7WN+fJdbqQc8yaK0=
X-Received: by 2002:ac8:27aa:: with SMTP id w39mr10577187qtw.359.1559322832230;
 Fri, 31 May 2019 10:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190530185709.1861867-1-jonathan.lemon@gmail.com>
 <5fde46e3-1967-d802-d1db-f02d15d11aa4@intel.com> <4AC230DE-6529-4798-BE32-C0AD873855CB@gmail.com>
In-Reply-To: <4AC230DE-6529-4798-BE32-C0AD873855CB@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 31 May 2019 19:13:40 +0200
Message-ID: <CAJ+HfNj0BQbTUV+EP8uVfo33NuxQhu=bm45amBRYq=HULn3t3Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 at 18:27, Jonathan Lemon <jonathan.lemon@gmail.com> wro=
te:
>
> On 31 May 2019, at 4:49, Bj=C3=B6rn T=C3=B6pel wrote:
>
> > On 2019-05-30 20:57, Jonathan Lemon wrote:
> >> Currently, the AF_XDP code uses a separate map in order to
> >> determine if an xsk is bound to a queue.  Instead of doing this,
> >> have bpf_map_lookup_elem() return the queue_id, as a way of
> >> indicating that there is a valid entry at the map index.
> >>
> >> Rearrange some xdp_sock members to eliminate structure holes.
> >>
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >> ---
> >>   include/net/xdp_sock.h                            |  6 +++---
> >>   kernel/bpf/verifier.c                             |  6 +++++-
> >>   kernel/bpf/xskmap.c                               |  4 +++-
> >>   .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 -------------=
--
> >>   4 files changed, 11 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> >> index d074b6d60f8a..7d84b1da43d2 100644
> >> --- a/include/net/xdp_sock.h
> >> +++ b/include/net/xdp_sock.h
> >> @@ -57,12 +57,12 @@ struct xdp_sock {
> >>      struct net_device *dev;
> >>      struct xdp_umem *umem;
> >>      struct list_head flush_node;
> >> -    u16 queue_id;
> >> -    struct xsk_queue *tx ____cacheline_aligned_in_smp;
> >> -    struct list_head list;
> >> +    u32 queue_id;
> >
> > Why the increase of size?
>
> Currently xskmaps are defined as size=3D4, so the returned pointer for
> bpf must have that many bytes.  I was kicking around the idea of using
> a union and returning { qid, zc }, but Alexei pointed out that doesn't
> make a good API.
>
> Besides, queue_index in struct xdp_rxq_info is already a u32.

(Resending w/o HTML from mobile client.)

Makes sense. Thanks for clarifying!


Bj=C3=B6rn

> --
> Jonathan
>
