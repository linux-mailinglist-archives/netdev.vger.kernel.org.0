Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F134C63E68D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLAAdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLAAdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:33:00 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9008537C0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:32:58 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id q186so404285oia.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lN9JwId4tiOiae0xE/P7QQ4kvD0YngnrPqvp/M5Dfwg=;
        b=LVy0wqAJnY3VNQt12119+LCZMGKEGZ4EZUpcDF8EAoT4pmN0KnCQU55BD8KghUPtIz
         ZsT8L+j+0sUolshFFwaUdBMQt4DGYv65Q49zXJCc3UdtV//RlNncelI034mQRlVKY+83
         Usk1Kn7mUIVEENTh0Bydb+XC96fHUi61pBOK2wk/LJhu9lQXZHwG1PpmBFGFDGMLHnwW
         fDm17V+un9o+gaMu8s7TnWPKJuBYkZ4LXTezcYWwysJKVnrBDc/kdlV3cmRU9fJWU5BG
         AaBNCGUQ1GBrxhyAtgvrZopjh3Oz8lEyV/GjE4qNPyxq7vY7hBSkcL3FeA36SbLRaHHv
         XT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lN9JwId4tiOiae0xE/P7QQ4kvD0YngnrPqvp/M5Dfwg=;
        b=NNXOgCQkXQ0pfUr2nsqgJc6anBSrcYsezXG5Gr2QRnyWlteXuk8MiSxlZTbE2GlqYw
         Lth15ZVIeHu9TZuV0nPRz7CojbES1D5/MUJ8TQ+rzJ8SWnAf3uz800wMzfpJbu4fI6rv
         ycBooAjMQ8pivaKNqKgTQ9UaNyPV7Kjz3FLjaQNYCKirjJeoD0uxYYpqtEJN04aRKzhe
         9SFqm6SpNFUyZ/fiKxyWDngI91ZCEKs0UEQLnXjx7IxAqsvzdGi95jX9ck4/AwDCKmNR
         YAnyt5dfl82DfpWADDHNtCgVcxCHsXRZJethQC3hq6HNSMXjjkVxF60MhJlgoCxk+nCj
         E6MA==
X-Gm-Message-State: ANoB5pnUgDB7bpV7zXPOYQMn10b3wl1NJBGOMr0OikiXDopXoB8aXHTl
        BbsM9hd0RTvItkEkn73GmU7aADItr5qdUgGlZHOApg==
X-Google-Smtp-Source: AA0mqf530DwVXRBjyS1VDdG0iUR9zIZ+cLsrFMslgltcHCQTdc4+KU6TyFgLBaQ7cGl5k9xwLyZmJYMAb7AgD0mCR/o=
X-Received: by 2002:aca:d01:0:b0:35b:d6f7:c569 with SMTP id
 1-20020aca0d01000000b0035bd6f7c569mr1985835oin.125.1669854778144; Wed, 30 Nov
 2022 16:32:58 -0800 (PST)
MIME-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com> <8735a1zdrt.fsf@toke.dk>
 <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
 <87o7soxd1v.fsf@toke.dk> <07db58dd-0752-e148-8d89-e22b8d7769f0@linux.dev>
In-Reply-To: <07db58dd-0752-e148-8d89-e22b8d7769f0@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 30 Nov 2022 16:32:47 -0800
Message-ID: <CAKH8qBtw-xpEm_5srzCP9FoJYeE5M-yEVMBOrXufxB4iVEV3Vw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 4:16 PM Martin KaFai Lau <martin.lau@linux.dev> wro=
te:
>
> On 11/30/22 3:01 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> It feels like beyond that extra dev_put, we'd need to reset our
> >> aux->xdp_netdev and/or add some flag or something else to indicate
> >> that this bpf program is "orphaned" and can't be attached anywhere
> >> anymore (since the device is gone; netdev_run_todo should free the
> >> netdev it seems).
>
> imo, orphan the prog and not able to attach again is ok.  Finding the nex=
t
> compatible netdev would be nice but not a must to begin with.  Regardless=
, it
> needs a bpf_prog<->netdev decoupling approach which allows to unregister =
netdev
> gracefully instead of getting the "unregister_netdevice: waiting for xyz =
to
> become free...".
>
> fwiw, offload.c has solved a similar problem and it keeps its own list of=
 prog
> depending on a particular netdev.  Whatever approach makes more sense her=
e.
> Ideally, other non-NIC HW kfunc can reuse a similar approach in the futur=
e.

Makes sense. Let me take a closer look. I glanced at it last week and
decided that maybe it's easier to not hold the device at all..

Maybe we should have something like this:

- bpf_prog_is_dev_bound() - prog is dev bound but not offloaded
(currently bpf_prog_is_dev_bound =3D=3D fully offloaded)
- bpf_prog_is_offloaded() - prog is dev bound and offloaded

So hopefully I can leverage some/most existing bpf_prog_is_dev_bound
call sites (+ add some more to reject prog_run/etc).
