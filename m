Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE24D6797
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350758AbiCKR2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344114AbiCKR2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:28:19 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2272617B89F;
        Fri, 11 Mar 2022 09:27:16 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id u17so6216066pfk.11;
        Fri, 11 Mar 2022 09:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+4Pceae7iUnHdSO1F/PsruatLZhZauGTxh4uIca8fI=;
        b=EKRXKNPDUzWaq6vYBc50t0HzdJ5Bf8UoRhrXZSUuKLoR/UyJY0fMVXAn+GnAVi252k
         1kCshZhPV5db9EPUG4KCXWv7W3Eh246aqXzuOlkLBrUH8XeMyegZFqAqmKvAWDVvEKmF
         +Nu/s/GJhHMlykBd6OfTmAYKusl3hiG+FWhDYmKm/J9OldJj0cm/85CdbBwQXdPl6yLr
         saejr/zo48IYUpldw/z0SMZAzqKYe0jMTq4WVolHmjyxY2b3zGfMyMiu4a3mDs4lgmSB
         YWB51fRiY63NZAfM7CpNLqzGV2uOAV+9RX4WiVZexMb9M2e63E111cYD2f2K8gAax3uK
         fBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+4Pceae7iUnHdSO1F/PsruatLZhZauGTxh4uIca8fI=;
        b=4hhnUoOZ4G5sElMCEavsVSj+FDQHcIsuIW9rco0ii2JpKyZO+7inRa+E4Sa4ZN5jdK
         lefiQqWqRfMlTOobQ9c1gwn8PiPViAJ7i0X3npZuXkdw9HZGYJ0v3V5AGWbCCLjxeINr
         tRJhBZyuSu49wyUjkbR57hBNgL2gpHBAvfi3fLbrxHyKpOluCuvnTijq/oWzjH2BPnhH
         wMjcWEUCE01hp8gJO/Mdvk2luBkFZda6wBJgZKXtmqksvl3IP2nTsS+sd6ZMWsNFvYlL
         baUK4Jp5n32MxRBhVb61vNJVx9hNaRe7/ofMz5qjiHC6u0UbRmHzBQoWPQeEBgUerDcx
         ZZIQ==
X-Gm-Message-State: AOAM531H6feuDj1r0b0mfZLx5QPSwxkv0zpS5axwzCwWv70UwSbjurST
        nRIM+E1i50BrmXmhXuNVUadcLrd+PxQEWlrQQ7Y=
X-Google-Smtp-Source: ABdhPJznCrBODYkapCbJLWtzjrJd2uuQT4oHVpeI+FO945GtwSoewfKFEDUee1Vv3izscLuEbmvlY6uPM2lkiHeSZ6E=
X-Received: by 2002:a05:6a02:197:b0:381:15fb:52e2 with SMTP id
 bj23-20020a056a02019700b0038115fb52e2mr2176529pgb.543.1647019635483; Fri, 11
 Mar 2022 09:27:15 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com> <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion> <87lexky33s.fsf@toke.dk>
 <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com>
 <87bkydxu59.fsf@toke.dk> <CAADnVQJPOCzyF-hBVOxCwqNj-vAk5=Dt6UvPdGok1b6s=Zdd7g@mail.gmail.com>
 <20220311072545.deeifraq4u74dagb@apollo>
In-Reply-To: <20220311072545.deeifraq4u74dagb@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Mar 2022 09:27:04 -0800
Message-ID: <CAADnVQLJQ+amaUh12sZeFUbBLhS8iHDMc=1JcMWaMBY-ORnFvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 11:25 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
> >
> > Also I don't believe that this patch set and exposing
> > bpf_xdp_pointer as a helper actually gives measurable performance wins.
> > It looks quirky to me and hard to use.
>
> This is actually inspired from your idea to avoid memcpy when reading and
> writing to multi-buff XDP [0]. But instead of passing in the stack or mem
> pointer (as discussed in that thread), I let the user set it and detect it
> themselves, which makes the implementation simpler.
>
> I am sure accessing a few bytes directly is going to be faster than first
> memcpy'ing it to a local buffer, reading, and then possibly writing things
> back again using a memcpy, but I will be happy to come with some numbers when
> I respin this later, when Joanne posts the dynptr series.
>
> Ofcourse, we could just make return value PTR_TO_MEM even for the 'pass buf
> pointer' idea, but then we have to conservatively invalidate the pointer even if
> it points to stack buffer on clear_all_pkt_pointers. The current approach looked
> better to me.
>
>   [0]: https://lore.kernel.org/bpf/CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com

There is a big difference in what was proposed earlier
vs what you've implemented.
In that proposal bpf_packet_pointer would behave similar to
skb_header_pointer. The kernel developers are familiar with it
and the concept is tested by time.
While your bpf_packet_pointer is different.
It fails on frag boundaries, so the user has to open code
the checks and add explicit bpf_xdp_load_bytes.
I guess you're arguing that it's the same.
My point that it's a big conceptual difference in api.
This kind of difference should be discussed instead
of dumping a patch set. Especially without RFC tag.

Please focus on kptr patches. They were close enough and have
a chance of landing in this release.
This bpf_packet_pointer stuff is certainly not going to make it.
