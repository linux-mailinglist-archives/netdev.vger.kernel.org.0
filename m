Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0853D1DD5A3
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgEUSG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgEUSG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:06:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5794C061A0F;
        Thu, 21 May 2020 11:06:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f13so6317723wmc.5;
        Thu, 21 May 2020 11:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2oKUs5QZClEMAOsEaZjzQhSXF7x/4a/f2Jwzz6UyoJE=;
        b=c7uwnRnETaPj+j3tsQN+VhjZMRlQvmblbe5WlZO3TTxgdkj/GYjRvkTaYDxgD19VOW
         dtN/JQQFfl835TYX+JMpNqx5z384Ew7jIlcKbMMWv1O8+eXbmRuX7MoltgMvtO0Jc1hz
         pVjiaMxUkSkmJwr80wPP93FiIZ8G2uW7f+gJ2jft/fd92Gc4zRqEABNQQ2W9trxIhjyS
         TPtdJCHt8D/6+hV9fgBQejDKhk29o/uS06xk6mhvIAsm32DcX0oIsCqQpBwyAj30dcw/
         dCxH0zl5s5NYCSEt8M5jXdbBdOLO6GC917jPY/cU4MymIh8wXV/bmYckTgIdBBP0u+YJ
         OSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2oKUs5QZClEMAOsEaZjzQhSXF7x/4a/f2Jwzz6UyoJE=;
        b=JMaGCaaLwiyd6r5DFRSOLqwJTdAlFdm3AcwL6gfXRXtQ7HkIKL1rXeyl4XCvgDFB5N
         hLc62h+9ngGzPRWASZUZCQp2LTq8rPYppvqdFIQxUS+7Okuj/JCvurOIAR21ZY+h+O4y
         BoGN9uEqWDGM+/ERZjjr9HzxcpJNTwtWT38J8uHX+0U0nGqcF08liL56d1J/U2H5vkQV
         otfJPOguUKW1N/3EURUcMKVQiVGdUYuCDbo5payVQgHSPy6Uxk0DXWARW5Ym8pCHgk+a
         f9lurr7Y5WiBQJ3TxaMb0nyIGmard3n4hANyBmfcUykIbDoS2pEZI2GRUShlaFF1FoQ7
         jWzA==
X-Gm-Message-State: AOAM532saMqc7kTfXxNv62ptvCGfmLD+KytmCN/sBD1dgtbMKKkGB8LZ
        F3AYZ3of1UjEnk2Wsnldl4Wo6c3eZLvQJxk2Ixw=
X-Google-Smtp-Source: ABdhPJyXyvJuEWEVpqcB8w9P2gPQ6qGAnGbCZMax01jRj/a8Hqq4AhTNrBwc+18BeHatA31LptZyrkSVLJArrbVCquI=
X-Received: by 2002:a1c:2d0c:: with SMTP id t12mr3915030wmt.165.1590084386639;
 Thu, 21 May 2020 11:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-2-bjorn.topel@gmail.com> <20200520151819.1d2254b7@carbon>
 <17701885-c91d-5bfc-b96d-29263a0d08ab@intel.com> <20200521062947.71d9cddd@carbon>
In-Reply-To: <20200521062947.71d9cddd@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 21 May 2020 20:06:15 +0200
Message-ID: <CAJ+HfNg73Wfq0ODX4kY396yyNQ-zAn1szssqqQNu4+DLbdSb2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 01/15] xsk: fix xsk_umem_xdp_frame_sz()
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 at 06:30, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
>
> On Wed, 20 May 2020 16:34:05 +0200
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:
>
> > On 2020-05-20 15:18, Jesper Dangaard Brouer wrote:
> > > On Wed, 20 May 2020 11:47:28 +0200
> > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > >
> > >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >>
> > >> Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
> > >> zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
> > >> to "data_hard_start".
> > >>
> > >> Currently, the chunk size of the UMEM is returned by
> > >> xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
> > >> headroom is non-zero. Fix this by returning the chunk_size without t=
he
> > >> UMEM headroom.
> > >>
> > >> Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz=
")
> > >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >> ---
> > >>   include/net/xdp_sock.h | 2 +-
> > >>   1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > >> index abd72de25fa4..6b1137ce1692 100644
> > >> --- a/include/net/xdp_sock.h
> > >> +++ b/include/net/xdp_sock.h
> > >> @@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct =
xdp_umem *umem, u64 address,
> > >>
> > >>   static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
> > >>   {
> > >> -  return umem->chunk_size_nohr + umem->headroom;
> > >> +  return umem->chunk_size_nohr;
> > >
> > > Hmm, is this correct?
> > >
> > > As you write "xdp_data_hard_end" is calculated as an offset from
> > > xdp->data_hard_start pointer based on the frame_sz.  Will your
> > > xdp->data_hard_start + frame_sz point to packet end?
> > >
> >
> > Yes, I believe this is correct.
> >
> > Say that a user uses a chunk size of 2k, and a umem headroom of, say,
> > 64. This means that the kernel should (at least) leave 64B which the
> > kernel shouldn't touch.
> >
> > umem->headroom | XDP_PACKET_HEADROOM | packet |          |
> >                 ^                     ^        ^      ^   ^
> >                 a                     b        c      d   e
> >
> > a: data_hard_start
> > b: data
> > c: data_end
> > d: data_hard_end, (e - 320)
> > e: hardlimit of chunk, a + umem->chunk_size_nohr
> >
> > Prior this fix the umem->headroom was *included* in frame_sz.
>
> Thanks for the nice ascii art description. I can now see that you are
> right.   We should add this kind of documentation, perhaps as a comment
> in the code?
>

Definitely! I'd say both in code, and af_xdp.rst! I'll make a patch.
Thanks for the suggestion!

Cheers,
Bj=C3=B6rn
