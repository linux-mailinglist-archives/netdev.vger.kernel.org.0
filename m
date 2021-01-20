Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2152FDC4A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbhATWRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbhATVQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:16:42 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847CFC0613D3;
        Wed, 20 Jan 2021 13:16:01 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m25so36054520lfc.11;
        Wed, 20 Jan 2021 13:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9xqprKmIF+4hdxWjhTmv8hWIdDfZ4cVF6MaI4G6iU6o=;
        b=rdpAmL4Bo3FJW4yTLuyknU0s8T2jZ6rOzXrGWbZYHNhr1wE32GcEmI1fYF1NHyvrdb
         Dy3Emjr4Wx2LjW/xq+x3shCaUiuh5RR+i8guyXycbGjLE6RCkZL9H5/PoqWLT7Z/7UBD
         tAA9A3eZIMK5odW53BXdB5xJcIcNDIqu5nrTMWBI0tyA5xhifTHQGVxfZG3I/8xOXrn/
         wfJMwHagRn8SZQCxHKpERK46xHIN9kzcFM1DxQ3Rcat8MRyl96zHU0cwrzPjhuIc5Z43
         naRGZwSpi5NlYEGw3i0UqRIDItoeZCKiFD5I04y7/K4IU2bHWFpHJneJ5s+mR2SOFJCI
         GyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9xqprKmIF+4hdxWjhTmv8hWIdDfZ4cVF6MaI4G6iU6o=;
        b=QBC3ie7E/ApjP1AOOcaOWjGe7r0iSKCCYLJkZHBFAnZDlQ5ru3XMdZfOtOBmPRj14M
         7Xz4E8oI5gtuxSrLv67oYvlj/CHTYGUXmFlIIbSTtJtWCDpBN/wv0zQ+pW7bC0jlhMoZ
         JqBWCiEaoyEoLZ9bUm9zwBL5TfnZzNB4Ecg0eVU7c+2/bZILDDxrh1idnQLZmKVYCfGN
         ENzKsMmwvxKH+RsW1IxtVMMC3cn8rV5nrIXnLYBppJwJrLrwGvIXH7u4snirF488WmZk
         SVtuupb4FHpX+L/pAylxpiqUPR9gMAxgAMI5ncnHkabdnPkx1VmBe7d+QkW5nhStT/JQ
         xGtA==
X-Gm-Message-State: AOAM532aDDleGV2iIZJtSbqYZnTzGSgr1QCmVGrSDoqPZD+yELhdaeKY
        yV2q6r1Oq7fblhewURnyTi1bCV4KaUV8OxdMbak=
X-Google-Smtp-Source: ABdhPJyWpKQsdsemvpFnX2V5xepWtCSL2KgXs1BkC67NXEBPh3PyQFg/G5pHCoCVmg/btAKFkVwRr3PNhFRTR4ZxEHY=
X-Received: by 2002:ac2:5b1e:: with SMTP id v30mr5448503lfn.540.1611177360030;
 Wed, 20 Jan 2021 13:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com> <87k0s74q1a.fsf@toke.dk>
 <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com> <8735yv4iv1.fsf@toke.dk>
 <ca8cbe21-f020-e5c0-5f09-19260e95839f@intel.com> <87pn1z2w38.fsf@toke.dk>
In-Reply-To: <87pn1z2w38.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 13:15:48 -0800
Message-ID: <CAADnVQ+R5JHhqUFnB_o3nJkkkcEtvO_Vk+xSDFiqP9dZ9H6vxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        weqaar.a.janjua@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 12:26 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> This argument, however, I buy: bpf_redirect() is the single-purpose
> helper for redirecting to an ifindex, bpf_redirect_xsk() is the
> single-purpose helper for redirecting to an XSK, and bpf_redirect_map()
> is the generic one that does both of those and more. Fair enough,
> consider me convinced :)
>
> > A lot of back-and-forth for *one* if-statement, but it's kind of a
> > design thing for me. ;-)
>
> Surely you don't mean to imply that you have *better* things to do with
> your time than have a 10-emails-long argument over a single if
> statement? ;)

After reading this thread I think I have to pour cold water on the design.

The performance blip comes from hard coded assumptions:
+ queue_id =3D xdp->rxq->queue_index;
+ xs =3D READ_ONCE(dev->_rx[queue_id].xsk);

bpf can have specialized helpers, but imo this is beyond what's reasonable.
Please move such things into the program and try to make
bpf_redirect_map faster.

Making af_xdp non-root is orthogonal. If there is actual need for that
it has to be designed thoroughly and not presented as "this helper may
help to do that".
I don't think "may" will materialize unless people actually work
toward the goal of non-root.
