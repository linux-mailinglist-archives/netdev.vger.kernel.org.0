Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C822F4757B8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbhLOLZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhLOLZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:25:37 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C729AC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:25:36 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f186so54210013ybg.2
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=he8lpC46ZHc1CWptJ+5SKK8l+XBUgWkWNvY/kjy3GBc=;
        b=fRn4CaZzejCMWg7VQpL88+0nbsOH0Kg+Wk7gCsIYrMhhkvrr2mJoa3a9P4msD6zgJp
         Tn4phKZhNV5P522/5Dbk8C3Q094rnMzcdZ7g3kfc8o45iXorVJiQ/q5HS5/M5FPE9Q+1
         4minpVTP28Ijt3iKil7ySfDXWYNpRXsf1WpLungR3aIrh17Ow8GbSFzQouuwgmqWCt5B
         /e0JmB+5RdPdvZwbccl3WldT5cKklaokkt54p+a80/YYxzsSAMMdd8mPje7c3SPQ4e2Q
         7mjGfi2bxDwDcIR28FA4DbAprwiJK6bDe3hJmDPj2c7TibgKAA6Db1josPfyo8+T1FgX
         uWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=he8lpC46ZHc1CWptJ+5SKK8l+XBUgWkWNvY/kjy3GBc=;
        b=FY0mnFXNnzEsjrGH5vt2gfGPBEIHALv2uFaXi0p7D3FHbkmOqoTmXh4rE14QQo+xwA
         wKJlu480bq+FpTYkpGYCy1ACvwPq7i9p8TkxxPlaiw13akrQhVKLoOi+ad5JT8/VvHX/
         X8Hy5tYlJcrrKM6ncNgbPQ+kZelWsMVNTHJJ4FNELX1nIue+9c/yvtfy83+sRQEL+pAm
         VPsqCRbB48YsWRxF+mKIsjOvaC6y3/N7woApBvQBXUAG/i6nFSf79PHJJHQNLGjCWEyi
         A+ee35y5NqYY1yfpEgMMhaJ4YXhndHm/vuxI8WCD/RI8B5qmP5j7wI4L7wqiC7vAybcK
         Vs0A==
X-Gm-Message-State: AOAM531xLEZG67XZifXXCP3tMUqlo/7d1kFiwL7FccQLnklg9n+1uACg
        VvPAgnzG9gXI17azlwmHLm/v1lXvqG1hF1Ulx5RAEw==
X-Google-Smtp-Source: ABdhPJwqW2mD4Pf3N8MVnjtlLppXBTvYfiLAerjtP22o9rV+pWLbxu5Ku+PK/Enf9twRSWt/0ALReUTikZ6fXLemkIY=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr5806021ybt.156.1639567535685;
 Wed, 15 Dec 2021 03:25:35 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com> <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
 <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
 <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com>
 <45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz> <CANn89iK+a5+Y=qCAERMBKAL8WRmZw3UOQiwoerse1cmxbTbFZw@mail.gmail.com>
 <14d361d8-c06d-e332-1a08-56eb727ded5c@gmail.com>
In-Reply-To: <14d361d8-c06d-e332-1a08-56eb727ded5c@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Dec 2021 03:25:24 -0800
Message-ID: <CANn89i+1V1_8dsFrF8ps=sc4ob1yzt1j6BGFKzsv+kiJ9b_1tQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking infrastructure
To:     Jiri Slaby <jirislaby@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 3:09 AM Jiri Slaby <jirislaby@gmail.com> wrote:
>
> On 15. 12. 21, 12:08, Eric Dumazet wrote:
> > Reported-by: Jiri Slab <jirislaby@gmail.com>
>
> (I am not the allocator :P.)

Ah, it took me a while to understand, sorry for the typo ;)
