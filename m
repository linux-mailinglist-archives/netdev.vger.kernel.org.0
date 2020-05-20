Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22991DBB03
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgETRTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETRTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:19:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623A6C061A0E;
        Wed, 20 May 2020 10:19:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e1so3969168wrt.5;
        Wed, 20 May 2020 10:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WjoBWssVHBqyFxbEQ95THjA8DwdaA15bcQxmRjylmZg=;
        b=smVMN+odCBqaMwnw8ELsWxRi0g2b8Dea1GDPoSNlGKc9bqV9kiVDTqHpCLmee2h6vA
         9az6vKmyX1eDQzNIhrFuWAR1UyCLsDArmdY/yFdhxYG3t7Q6KVr/6/tXHdx4S27rDljv
         wwWgvXYvsWTuGsSrWivIGnPH4Cd8uts5/8xBpQWzDBVN+fo66BHwu9onOVvevV80/SMk
         J7NU8rUTSGM+ckuNCagujX8hsbFGvGD09cbXyOAqzrZYJDppzhY/QIlhjrU1NHAykaKa
         pmQVTsZFVkCv8mTsRcPyTmBcTvDhiMD0iIG9eRxEMGD1J3AL5QeCQh8DDrfJ5Lu5S7kJ
         tTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WjoBWssVHBqyFxbEQ95THjA8DwdaA15bcQxmRjylmZg=;
        b=aIJHLJRa+qbCjh7zgOlgcKOL5U0AH5Bf0mO0Yp+9Wd2wKN31vqO/rLjMf0t/WTBBaD
         4hK1/TzwsWpVm6/B7TaWI8TLdRm/Dn03YeKHB6TQk3q11NrwcnKn89dzhto/qImkSAPV
         K9ka1MH3ZH0Ui1FeNDE3S3abokA51YItfL0/cypiW/0KrhuTsDCKL4fzrdXAKL+F0mT/
         NgXXK7rgzE+02SRBZlGc8M21DRN0nQqtPJhz9Bs282sF3RC/p9wFD5veE+LqHiahJe/e
         4S/HgGO7/HzEptPvYzp4kOtlvEQTPHzXeaVgcnFEICR02wmJnWLhkV9n9XL0GXdv4t50
         +Meg==
X-Gm-Message-State: AOAM530dRl4EAV6QOfimF7/tVOoCEVnqH6ZKdL8MFNsSn2TcyqK72C2G
        w2x0LXmDpCRXi5K5sSdFdGVR8eRub9YkC0Tf2SQ=
X-Google-Smtp-Source: ABdhPJyZBIZqLYSG4g785vCGsXo0DwKM/I7MoLWiEIcWCbvk0lXAiMYbJ38VU2g5O3IRznEAv7e7WWgWLGb51/knXQ4=
X-Received: by 2002:a5d:5642:: with SMTP id j2mr4942061wrw.52.1589995141127;
 Wed, 20 May 2020 10:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-4-bjorn.topel@gmail.com> <20200520095743.0d6dda04@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520095743.0d6dda04@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 20 May 2020 19:18:49 +0200
Message-ID: <CAJ+HfNgxH0xLUvm=MPpF-VhoGLPYF2=gJMAw3VkmduO2SJhy=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/15] xsk: move driver interface to xdp_sock_drv.h
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 at 18:57, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 May 2020 11:47:30 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Move the AF_XDP zero-copy driver interface to its own include file
> > called xdp_sock_drv.h. This, hopefully, will make it more clear for
> > NIC driver implementors to know what functions to use for zero-copy
> > support.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> With W=3D1:
>
> net/xdp/xsk_queue.c:67:26: warning: symbol 'xsk_reuseq_prepare' was not d=
eclared. Should it be static?
> net/xdp/xsk_queue.c:86:26: warning: symbol 'xsk_reuseq_swap' was not decl=
ared. Should it be static?
> net/xdp/xsk_queue.c:108:6: warning: symbol 'xsk_reuseq_free' was not decl=
ared. Should it be static?
> net/xdp/xsk_queue.c:67:27: warning: no previous prototype for xsk_reuseq_=
prepare [-Wmissing-prototypes]
>   67 | struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
>      |                           ^~~~~~~~~~~~~~~~~~
> net/xdp/xsk_queue.c:86:27: warning: no previous prototype for xsk_reuseq_=
swap [-Wmissing-prototypes]
>   86 | struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
>      |                           ^~~~~~~~~~~~~~~
> net/xdp/xsk_queue.c:108:6: warning: no previous prototype for xsk_reuseq_=
free [-Wmissing-prototypes]
>  108 | void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
>      |      ^~~~~~~~~~~~~~~

Yes, missing include there. After the series these functions are
removed, but still good to get rid of the (bisect) noise.

I'll fix this in a v5. Thanks, Jakub!


Bj=C3=B6rn
