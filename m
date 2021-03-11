Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D988337D08
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCKS60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCKS4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:56:54 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD6C061760;
        Thu, 11 Mar 2021 10:56:27 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id n195so22762282ybg.9;
        Thu, 11 Mar 2021 10:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=th5U7zFe0FU/O5O7Dd2Akwz7VzPCvkDhXRqRT58M53c=;
        b=DKlbjlr2WrjsMJ8TrWRPW/vmdQIB+AEpsChvJPDmxna4dBvvlbWBnB0c6v5KYG4iT9
         QZxJKxtHIQ3kvHFl2CiS/uIJWVnRvJR767xT9B5440kX8sQzPzndMOviSIxzQoTpokwc
         LLRtG5NeClKq/T2balBQdLEO35WyeXvBIG26dU+1uwE+DZPVWtkHhFocLcO3EtnVLMIq
         WgNjFVoGSCzDxc4HqIJ/CWg09hX3S5KhobUT0BDxe/yRwEjqaCLwcEHCI9/Ke7JPvaP1
         HZTdoBpMVh3VgsrWbovsCSL1O485eF3VaQ9zUAD9VSq9puXy7Wb6j+hG6w7c+S8TbGxB
         M58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=th5U7zFe0FU/O5O7Dd2Akwz7VzPCvkDhXRqRT58M53c=;
        b=XmVSZOBayq5u2+t7LEejsD8fFytVgCmewvsiBtV7b4JVkejOBXhEB91CLlk2KCGOz0
         st3zl4GKO8hbTWORBkVyLbb8LniX1JoMba0Pgt0khMlpVqY+d9mlmSVqSEBhDs2sloE+
         knVCaqS+ybB9A5cakaIQZdeqJKpWGRiU+IsoHuVS9huWODXnmqjUuSVxB8abSfUym/se
         D656CLE2knK5bO9IjNl6uwgHK5ctJY7Al7z8AuitIhWnNLVovR5zjTyaJN8TFakUVFkV
         Zy3fGkFrCZofDaF4n4RZvwBS7f+8To5dgSUrmMyb8uJ7qWToWPwe2P7ry4NW4z3lk8Lk
         pVyA==
X-Gm-Message-State: AOAM530WENt5BPib44q5eeUMAvVaiD+hM0lWRFQ6NNsy1qO0LdnHu/Us
        jaEjQmg/cvD6zpCGnaWUmBoGgTga36UIoTt0H6o=
X-Google-Smtp-Source: ABdhPJwj7WfnvuR3BlKipoL1l1LfQDGM7kVlljXj8cg9yovU3lrDzmTwRWs78ggavLNNBhiphPMcWpQXTFsadNPtj6g=
X-Received: by 2002:a25:874c:: with SMTP id e12mr12699919ybn.403.1615488987293;
 Thu, 11 Mar 2021 10:56:27 -0800 (PST)
MIME-Version: 1.0
References: <20210310080929.641212-1-bjorn.topel@gmail.com>
 <20210310080929.641212-3-bjorn.topel@gmail.com> <20210311000605.tuo7rg4b7keo76iy@bsd-mbp.dhcp.thefacebook.com>
 <0535ce9f-0db6-40f7-e512-e327f6f54c35@intel.com>
In-Reply-To: <0535ce9f-0db6-40f7-e512-e327f6f54c35@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Mar 2021 10:56:16 -0800
Message-ID: <CAEf4BzbuFzQKF2DBCUmGnLyP4WTPR7CLBxoT8W0_DRSrn_g4ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: xsk: move barriers from
 libbpf_util.h to xsk.h
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        maximmi@nvidia.com, ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:59 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.c=
om> wrote:
>
> On 2021-03-11 01:06, Jonathan Lemon wrote:
> > On Wed, Mar 10, 2021 at 09:09:29AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> The only user of libbpf_util.h is xsk.h. Move the barriers to xsk.h,
> >> and remove libbpf_util.h. The barriers are used as an implementation
> >> detail, and should not be considered part of the stable API.
> >
> > Does that mean that anything else which uses the same type of
> > shared rings (bpf ringbuffer, io_uring, zctap) have to implement
> > the same primitives that xsk.h has?
> >
>
> Jonathan, there's a longer explanation on back-/forward-compatibility in
> the commit message [1]. Again, this is for the XDP socket rings, so I
> wont comment on the other rings. I would not assume compatibility
> between different rings (e.g. the bpf ringbuffer and XDP sockets rings),
> not even prior the barrier change.
>
>

BPF ringbuf is using smp_store_release()/smp_load_acquire(), which are
coming from asm/barrier.h. But libbpf abstracts all the low-level
details, so users don't have to use such low-level primitives
directly.

> Bj=C3=B6rn
>
> [1]
> https://lore.kernel.org/bpf/20210305094113.413544-2-bjorn.topel@gmail.com=
/
>
