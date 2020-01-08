Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0491346B9
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 16:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgAHPwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 10:52:20 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:40275 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbgAHPwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 10:52:20 -0500
Received: by mail-il1-f194.google.com with SMTP id c4so3049619ilo.7;
        Wed, 08 Jan 2020 07:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qIv1PnuERywBQG5WraXdtfKx72H7bbU6jM2vkfwtKqw=;
        b=uy1oZRS5TrmGZKEErVJqoegIz/SVOzAth33rJQoV278SxQRD+f2pFVJQGvUKcdeOC6
         x5dYKMVUMEb8aAloaXKlfwIKRTCL6l80D2ORbpu6JF2Pe3iPULgNYsF+MN9jKTotyfHN
         RCK8dtMsolQiU4N6/lL2GSuj6m+bam7JbAib5FukjE1JtIx3ONEf9chShKPxRoLDUpk7
         7JWShTMfLcXPxGCuredpsH6PTdNtdehL737lsHYBFGhn6C96PtwyqyfMjjMd5Ytle04e
         2E1Fyl13Vp7uCfdIh0pUDvN9VYkujrd81NmqXy+48KzmgVD03IbQr6r2qPwf3vWc24l+
         DiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qIv1PnuERywBQG5WraXdtfKx72H7bbU6jM2vkfwtKqw=;
        b=jZOETcNNZ7w27Pvh84qVeGvz3ePQk33/RyWDYPbQuVSN959GjF0h0cCqxHxGb7GI63
         ppCkQ+CBHphc6QBIgLrmOLWtZDTG8sYYia/25bcmhl5NojFQ++twStIW04k7EgHGO32z
         PwaUhmVM+SduvOmh7sHfl/13an+iuwYefZYBh1oT0kLXTf2ZMDxDdyiYx4NilxPyrZKG
         iSJm7Nj0lS7tmUjueBgxfqp/fsI/uRW3axAyZ2zSryGiqznIMDk5tyN/pUeIj7RO531N
         ioBuTaMuC2HYj/TERLJmCAGak5GClbvMHiui4viwwyGbWlXOknxp/1jBbKRHs2qxqGrt
         ZFlQ==
X-Gm-Message-State: APjAAAXmFSIA3EjAcgM9x52Y/EkCveb0vH1LcQ64+/OJgm2vOcUSQ+0M
        nImazcoihH+WBfyJUhpWgVe0S0rD
X-Google-Smtp-Source: APXvYqwnEDfyOOR8XPyZVs5H1AgXTfHEOvPLrMoH4xj4NN9ym1tXCm/jEr6RNRAxnUnH4Ik7oPq78g==
X-Received: by 2002:a92:d902:: with SMTP id s2mr4673986iln.223.1578498739507;
        Wed, 08 Jan 2020 07:52:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g12sm735539iom.5.2020.01.08.07.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:52:18 -0800 (PST)
Date:   Wed, 08 Jan 2020 07:52:10 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e15faaac42e7_67ea2afd262665bc44@john-XPS-13-9370.notmuch>
In-Reply-To: <CAJ+HfNiQOpAbHHT9V-gcp9u=vVDoP6uSoz2f-diEFrfX_88pMg@mail.gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-5-bjorn.topel@gmail.com>
 <5e14c5d4c4959_67962afd051fc5c062@john-XPS-13-9370.notmuch>
 <CAJ+HfNiQOpAbHHT9V-gcp9u=vVDoP6uSoz2f-diEFrfX_88pMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] xsk: make xskmap flush_list common for
 all map instances
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> On Tue, 7 Jan 2020 at 18:54, John Fastabend <john.fastabend@gmail.com> =
wrote:
> >
> > Bj=C3=B6rn T=C3=B6pel wrote:
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > The xskmap flush list is used to track entries that need to flushed=

> > > from via the xdp_do_flush_map() function. This list used to be
> > > per-map, but there is really no reason for that. Instead make the
> > > flush list global for all xskmaps, which simplifies __xsk_map_flush=
()
> > > and xsk_map_alloc().
> > >
> > > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > ---
> >
> > Just to check. The reason this is OK is because xdp_do_flush_map()
> > is called from NAPI context and is per CPU so the only entries on
> > the list will be from the current cpu napi context?
> =

> Correct!
> =

> > Even in the case
> > where multiple xskmaps exist we can't have entries from more than
> > a single map on any list at the same time by my reading.
> >
> =

> No, there can be entries from different (XSK) maps. Instead of
> focusing on maps to flush, focus on *entries* to flush. At the end of
> the poll function, all entries (regardless of map origin) will be
> flushed. Makes sense?

Ah OK. This would mean that a single program used multiple maps
though correct? Because we can only run a single BPF program per
NAPI context.

What I was after is checking that semantics haven't changed which
I believe is true, just checking.

> =

> =

> Bj=C3=B6rn
> =

> =

> > LGTM,
> > Acked-by: John Fastabend <john.fastabend@gmail.com>


