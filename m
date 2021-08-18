Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9CE3F03FF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhHRMur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhHRMuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:50:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D061C061764;
        Wed, 18 Aug 2021 05:50:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso2224701pjy.5;
        Wed, 18 Aug 2021 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b4fBx089jmasN56gf48RyD+HPwaSHlVArEZB5msBo4s=;
        b=ZgDLIDbeclN1MOme9DLoncA8qq9x7NWNvw2kl4PI2J0YHTslHSHaO6n2wJVsO0bvVy
         pDBS8LLBHSg9HKTZz8Sue0iihIQiZ7gPJkj/qakiZjcLjt999xErbg91p6S3vXC9fHw5
         ZiXgXOUntzXWvLES0BRDiGRZG7mnP8vGCL8zAfiVQnAMqbUaVtVV7ITITrVs7CfuvpVD
         WaJ4uF0XCBruwRKuywtipLpczZjW+JaFJfTfadl+Jf1+b/Kd93Uh0GfoJBzBkZjaCWX2
         NQu2FwDxCxpPBx3mdwgXxY252L6OyxQuXjLHip7OaOQ7S6SamJt55m2tjImS/btWtENP
         GJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b4fBx089jmasN56gf48RyD+HPwaSHlVArEZB5msBo4s=;
        b=sva5Q2SBNpMkF/g6/VARaPY3AR5jFU3XWrDgyVyNVctAC/HlqFBOd/ekrQT61sSvXh
         sVIbtWgNzvDsaG5IQsvxIEByfAKeNed1Qj/s/sEsDILdGgWDN5mohPbYzYSBjE3MAMfz
         gf4vD3sWiZsUb8rxUfZkKAoGW6TfQd6GFKioaUU+p0F/gDWfSwZ6w/Bik4wS9ikh6OZ5
         C5busdLhRlxyGnqUvVqhVZxVajpEKCw5+3xcR1+30Ds4KSVmLIZL0TnIYi2RJTgOHGX/
         4tKr0oqCuaJiIoAk+0945QNEJ+DcA7o2rReeToPm9zUKGM9/7e/V/FJS2UXbQsCoE351
         ZZ4g==
X-Gm-Message-State: AOAM5325C5vY8PqkBRkbGRAO1OJt/ezRABjZdq6jk0ORrsGOuxd9n5x1
        HPIuTj5DmjnPVPEWtyyKp036oqJcL6elXYvy2Nk=
X-Google-Smtp-Source: ABdhPJxkdIJ0iRwF9xc5GGrBTMubhYP1oHfzQVcq0cEZ6MeNafiAKlWegTX+RRrtcM3jkvvaT2H5PprG6U7KeFLdH0g=
X-Received: by 2002:a17:90b:370d:: with SMTP id mg13mr7896373pjb.117.1629291011631;
 Wed, 18 Aug 2021 05:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <811eb35f-5c8b-1591-1e68-8856420b4578@redhat.com>
In-Reply-To: <811eb35f-5c8b-1591-1e68-8856420b4578@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 18 Aug 2021 14:50:01 +0200
Message-ID: <CAJ8uoz3dnxWuw8yuk2FtWo78sL7-9+Z6mFk_2MCRki4YAAmhew@mail.gmail.com>
Subject: Re: AF_XDP finding descriptor room for XDP-hints metadata size
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 1:55 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> In previous discussions with AF_XDP maintainers (Magnus+Bj=C3=B8rn), I
> understood we have two challenges with metadata and BTF id.
>
>   (1) AF_XDP doesn't know size of metadata area.
>   (2) No room in xdp_desc to store the BTF-id.
>
> Below I propose new idea to solve (1) metadata size.
>
> To follow the discussion this is struct xdp_desc:
>
>   /* Rx/Tx descriptor */
>   struct xdp_desc {
>         __u64 addr;
>         __u32 len;
>         __u32 options;
>   };
>
> One option (that was rejected) was to store the BTF-id in 'options' and
> deduct the metadata size from BTF-id, but it was rejected as it blocks
> future usages of 'options'.
>
> The proposal by Magnus was to use a single bit in 'options' to say this
> descriptor contains metadata described via BTF info. And Bj=C3=B8rn propo=
sed
> to store the BTF-id as the last member in metadata, as it would be
> accessible via minus-4 byte offset from packet start 'addr'. And again
> via BTF-id code can know the size of metadata area.

This is basically what Kishen had in his RFC.

> My idea is that we could store the metadata size in top-bits of 'len'
> member when we have set the 'options' bit for BTF-metadata.

What are the main advantages with this proposal compared to the former
one when we can get the length of the metadata section from the
BTF-id? When do we actually want to use the length of the metadata
section for something in user-space instead of just accessing the
members directly? Just trying to understand.

Thanks: Magnus

> -Jesper
>
