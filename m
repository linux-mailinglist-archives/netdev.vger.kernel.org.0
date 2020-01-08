Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F66133F09
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgAHKNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:13:46 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:43766 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAHKNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:13:46 -0500
Received: by mail-qv1-f66.google.com with SMTP id p2so1135848qvo.10;
        Wed, 08 Jan 2020 02:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AUINI16yK6pZHAU/xXt2qsWSZUyaKAoaO+uyiNHoP1I=;
        b=e/8iumBBd7Idf61d3znHNv0/2gp6gqhHLqKXb8D4XrpY6aCK8Ps1g6HI4sCEF1EkL3
         Xny00h/moxJQIfqcN0Lm2HifW4KOXu14M0c12DZGZOt2AmAAA5pSkBWzdEI3c1TZDQ3G
         pBWEeq8hwfpisXH9dF10jDLbA118b6QpMXh20PWuIpnJXPufjqlJ5JyIU6mwg92pOBM9
         fr+WvmzYaZegDy4lVw/1becGHj7YV4cgadM3OydiaNRtbFeBvF8/nbCzrfWFkT06+Yt9
         LrS3wa/FgUA+2sNgU5qiZWsUVykItR6RV9sQ4labxNMHUU1MZE6UmY0nr7S6Zz3OLZ58
         jGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AUINI16yK6pZHAU/xXt2qsWSZUyaKAoaO+uyiNHoP1I=;
        b=F7iuj/2c3giEjkYt4EJ2vuWaJReAmFZZJ6zyDEOpFYqhJEWA7K8iGxqiUDgTJLVhhW
         TtEwhAGn3JFZYQSsAgewlBdzW9mccuz2vPX5Onf7l5Isu3499tBgbrHEo9Nxs0vVsXCj
         JOfcIFcNB2Gm4tQmeB36fUZ5/S6NC8TQSCgKQ/UXwHJjnHzLJ9vCKXCKEq+SsOdfsU1G
         3Uy1FXukwcrg8VwbQhJ/fqmFFvqwUNNLmhfR2GHgthxBJCA3NINwnwbvhMg2XEkGNpaP
         Soo7B8sdiORoBa6WOKmmb5M1iFGX0vE3s5olmgqu2aVHpF3EcFOwWASrfSKBHFbZtbKa
         Vc8Q==
X-Gm-Message-State: APjAAAWaI4JpnSsR4QZw0xTIv/D27VkOtDiSjplpoVJo//RQuKhu1z3N
        IEqYTanKxwakynyw7GxJlecyo46PIiR8cSnCPKk=
X-Google-Smtp-Source: APXvYqwOviWQIIezPLyl++ERkZ4/MPAnPMIPwAi7IkXjU8cJMBvA+cLZSomC0AT6OKdxubCN13nY404Zx8Qol/aW+wg=
X-Received: by 2002:a0c:e2cf:: with SMTP id t15mr3449252qvl.127.1578478425415;
 Wed, 08 Jan 2020 02:13:45 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-5-bjorn.topel@gmail.com>
 <5e14c5d4c4959_67962afd051fc5c062@john-XPS-13-9370.notmuch>
In-Reply-To: <5e14c5d4c4959_67962afd051fc5c062@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Jan 2020 11:13:34 +0100
Message-ID: <CAJ+HfNiQOpAbHHT9V-gcp9u=vVDoP6uSoz2f-diEFrfX_88pMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] xsk: make xskmap flush_list common for
 all map instances
To:     John Fastabend <john.fastabend@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 18:54, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
> Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The xskmap flush list is used to track entries that need to flushed
> > from via the xdp_do_flush_map() function. This list used to be
> > per-map, but there is really no reason for that. Instead make the
> > flush list global for all xskmaps, which simplifies __xsk_map_flush()
> > and xsk_map_alloc().
> >
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
>
> Just to check. The reason this is OK is because xdp_do_flush_map()
> is called from NAPI context and is per CPU so the only entries on
> the list will be from the current cpu napi context?

Correct!

> Even in the case
> where multiple xskmaps exist we can't have entries from more than
> a single map on any list at the same time by my reading.
>

No, there can be entries from different (XSK) maps. Instead of
focusing on maps to flush, focus on *entries* to flush. At the end of
the poll function, all entries (regardless of map origin) will be
flushed. Makes sense?


Bj=C3=B6rn


> LGTM,
> Acked-by: John Fastabend <john.fastabend@gmail.com>
