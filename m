Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF62734DB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgIUVZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgIUVZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:25:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851AFC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 14:25:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k133so5387325pgc.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 14:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k+mmJxxaTZjM1e+APf039489nuEkn0MgS4OsSnhZPWU=;
        b=mEra+qynkitiE9TVVHxd635WlZ0V0yT+l7Nr6141sGgDqrFl8ZtBzagVFm7d3b1tf4
         eBIi6qCz27FFV1ulti8HcwgYQXJcfL65u98WUgnqmLSH2FNNBdaOI1gK6YslTP6toAS7
         lQaWKFCw65TUKVkMkKtuGrFOL5vUW3sIdCx1B6F61flASqB/FGpRqFCi1NfJZyBfdib0
         3J25dPdBv1sWpO9a7T/sRReljpOnAmqWZmbv3aBsqJ92DqxLN8jwuGOYsO5wZbgjtDxH
         erqZ5z/u+XI/AZehp0WbjINuN1EQZfBxwV7tagmdJjJZSIyKK+JxMl4R1MAPSYjV4clT
         M1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k+mmJxxaTZjM1e+APf039489nuEkn0MgS4OsSnhZPWU=;
        b=cgxBiy7NHN9k8j9tnXYIE1m8bt/8e9r4AFHmM+k8hZcenK1W4xmgVfe1MlPFnjaj1a
         17T8202wMceWBbcUUQrG6yrIvMLVI9F4oaxUBy+pNxxZDQQc5vPfW+ivSrzZAPKo98Jm
         6iF2Ye9gtVlamFbsmJDe/uBcb4vLvxZZQacU5HsGZVIdgJl1N8jYi+Gzh512xJFh8omv
         aPVtuXyHdSETneQThdBOxrLjWJHIfETc1Qk1Qc9udM3TlbzU01XTy7gvAfXqlwptWEXe
         1sK/RJ4323i6XfzGiCpdOZ0FIiVTKCc5hpNA79xMXz5BXXZ+jpmE8Tmm4B6KggTUrJYV
         jcPA==
X-Gm-Message-State: AOAM533kp2YCnU1bH7ZwMp6+g76x5yAq8M7+8J0XCOUzG8BkgNFx44zo
        hdoxfLHcEdzTCFRv6Q+db43bdHs4O47hAg==
X-Google-Smtp-Source: ABdhPJyIJniSnITBBaPWqvk1Pmep6DP07rSey8X6B6Ur/o7wQiFdT61YvCXMHDyNTfnDEjBosTqxRA==
X-Received: by 2002:a63:5825:: with SMTP id m37mr1207424pgb.64.1600723526570;
        Mon, 21 Sep 2020 14:25:26 -0700 (PDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com. [209.85.210.173])
        by smtp.gmail.com with ESMTPSA id c201sm13587943pfb.216.2020.09.21.14.25.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 14:25:26 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id w7so10424966pfi.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 14:25:26 -0700 (PDT)
X-Received: by 2002:a67:e83:: with SMTP id 125mr1561886vso.22.1600723073512;
 Mon, 21 Sep 2020 14:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200917143846.37ce43a0@carbon> <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon> <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
 <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
 <20200921144953.6456d47d@carbon> <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
 <CAG0p+LmqDXCJVygVtqvmsd2v4A=HRZdsGU3mSY0G=tGr2DoUvQ@mail.gmail.com>
In-Reply-To: <CAG0p+LmqDXCJVygVtqvmsd2v4A=HRZdsGU3mSY0G=tGr2DoUvQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 21 Sep 2020 23:17:16 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdx_a+DGG5dSFRB3wkowwNb1ZXHFed=qA3sj5y6U3VtiA@mail.gmail.com>
Message-ID: <CA+FuTSdx_a+DGG5dSFRB3wkowwNb1ZXHFed=qA3sj5y6U3VtiA@mail.gmail.com>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     Marek Zavodsky <marek.zavodsky@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 6:22 PM Marek Zavodsky <marek.zavodsky@gmail.com> wrote:
>
> Hi guys,
>
> My kernel knowledge is small, but I experienced this (similar) issue
> with packet encapsulation (not a redirect), therefore modifying the
> redirect branch would not help in my case.
>
> I'm working on a TC program to do GUE encap/decap (IP + UDP + GUE,
> outer header has extra 52B).
> There are no issues with small packets. But when I use curl to
> download big file HTTP server chunks data randomly. Some packets have
> MTU size, others are even bigger. Big packets are not an issue,
> however MTU sized packets fail on bpf_skb_adjust_room with -524
> (ENOTSUPP).

This is a related, but different, unresolved issue at the boundary of
GSO packets. Packets that are not GSO, but would exceed MTU once
encapsulated, will cause adjust room to fail:

            (!shrink && (skb->len + len_diff_abs > len_max &&
                         !skb_is_gso(skb))))
                return -ENOTSUPP;

As admin, this can be addressed by setting a lower route MTU on routes
that may be encapsulated. But that is not very obvious or transparent.
