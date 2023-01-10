Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200A8664008
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbjAJMNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjAJMMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:12:39 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8286CC1;
        Tue, 10 Jan 2023 04:10:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i9so17244889edj.4;
        Tue, 10 Jan 2023 04:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSnJUfK+YfevattZUHyZLIV0WfO26dXCK39XSwI3U+I=;
        b=Z70AJLk68rrVwlFC73+7yam4zo7IZqkTt10W+SE6hXEoqYttHkHcaQdu1CyppjAaBv
         g/EkbV5GEX1VR9pEYPZ36pAyH3chhO/rNS+HpVHAXPmVKibJyN3yZ9uj8H2vYLe1F9NM
         au3bv7cKH/JCox6iyKQ4oTb+YWyVUjActhluZi2JWCBpGCIb2ZtiCIhHD+HJj3QPMYk+
         iHCK6n4+SF1rLu89v6jOqlFGMkIjcl7A/bHUFIEKPEdLdm9qHF+HE6Gbhpxddxnbt2/m
         OYN6FdTlrvQZtElKaJypqG/K5p41N84sk5YF1n1Z47lZgfA0AxrisQNZt9wIUJ2+sLQf
         BmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSnJUfK+YfevattZUHyZLIV0WfO26dXCK39XSwI3U+I=;
        b=BuJnOIRSOlUxKSI+PXmq60qXoA5xxdxkQ+AsCU8FudFqOWrBeVKYoTCFt7umD3oBI3
         Glnjta1zOd3BYHjKMVwFjFZiLP9zWafLuB3fQjigDQvFX0s/p8UFdsQsjelnS09wNzoA
         RO0SRqjLm/xgOHMNe9cF+ZXg+Drwqe9wObxs79Oc8BYPDDvzXXISL/DESJY3Gj2RmUMd
         7XoeR9A7TUedPg8dl0dxpJ5kWI+F22u1fLY4gmfRVDvpNpu+KzdMtVxUnDfzApO9TX23
         YMD8+/9mO7qFZ6RFo8KBY2YAzmvzb+swU/CoGRBOM/w7soWg3sLRlWg6jh9tiyAlMr0r
         hx4w==
X-Gm-Message-State: AFqh2ko2QfhFGJ3I1CQVyNnmZGfzqpaa9Q9uF6GPA6pGEDx4CJxN/SL5
        Mi/V/DwmQSm2eciBOAsH8FbD+9TvYe5G4l0oLFk=
X-Google-Smtp-Source: AMrXdXumQkY57Zfa8ZJ28YBMz1quiZuLKE3dURofiHa9oklTBrWJVyCIkKWXhP/uDSGq9sL/snwD64GBB4BMmQz/7Pk=
X-Received: by 2002:a05:6402:371a:b0:499:c424:e893 with SMTP id
 ek26-20020a056402371a00b00499c424e893mr263491edb.156.1673352655207; Tue, 10
 Jan 2023 04:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com> <Y71TRPNezv9woeEr@boxer>
In-Reply-To: <Y71TRPNezv9woeEr@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 10 Jan 2023 13:10:43 +0100
Message-ID: <CAJ8uoz0TG8T4aTKW=B3ZLv-KvKTiD3Rfa2rwqoJJELvNRjbowg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/15] selftests/xsk: speed-ups, fixes, and
 new XDP programs
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        tirthendu.sarkar@intel.com, jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 1:00 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Jan 04, 2023 at 01:17:29PM +0100, Magnus Karlsson wrote:
> > This is a patch set of various performance improvements, fixes and the
> > introduction of more than one XDP program to the xsk selftests
> > framework so we can test more things in the future such as upcoming
> > multi-buffer and metadata support for AF_XDP. The new programs just
> > reuses the framework that all the other eBPF selftests use. The new
> > feature is used to implement one new test that does XDP_DROP on every
> > other packet. More tests using this will be added in future commits.
> >
> > Contents:
> >
> > * The run-time of the test suite is cut by 10x when executing the
> >   tests on a real NIC, by only attaching the XDP program once per mode
> >   tested, instead of once per test program.
> >
> > * Over 700 lines of code have been removed. The xsk.c control file was
> >   moved straight over from libbpf when the xsk support was deprecated
> >   there. As it is now not used as library code that has to work with
> >   all kinds of versions of Linux, a lot of code could be dropped or
> >   simplified.
> >
> > * Add a new command line option "-d" that can be used when a test
> >   fails and you want to debug it with gdb or some other debugger. The
> >   option creates the two veth netdevs and prints them to the screen
> >   without deleting them afterwards. This way these veth netdevs can be
> >   used when running xskxceiver in a debugger.
> >
> > * Implemented the possibility to load external XDP programs so we can
> >   have more than the default one. This feature is used to implement a
> >   test where every other packet is dropped. Good exercise for the
> >   recycling mechanism of the xsk buffer pool used in zero-copy mode.
> >
> > * Various clean-ups and small fixes in patches 1 to 5. None of these
> >   fixes has any impact on the correct execution of the tests when they
> >   pass, though they can be irritating when a test fails. IMHO, they do
> >   not need to go to bpf as they will not fix anything there. The first
> >   version of patches 1, 2, and 4 where previously sent to bpf, but has
> >   now been included here.
> >
> > v1 -> v2:
> > * Fixed spelling error in commit message of patch #6 [Bj=C3=B6rn]
> > * Added explanation on why it is safe to use C11 atomics in patch #7
> >   [Daniel]
> > * Put all XDP programs in the same file so that adding more XDP
> >   programs to xskxceiver.c becomes more scalable in patches #11 and
> >   #12 [Maciej]
> > * Removed more dead code in patch #8 [Maciej]
> > * Removed stale %s specifier in error print, patch #9 [Maciej]
> > * Changed name of XDP_CONSUMES_SOME_PACKETS to XDP_DROP_HALF to
> >   hopefully make it clearer [Maciej]
> > * ifobj_rx and ifobj_tx name changes in patch #13 [Maciej]
> > * Simplified XDP attachment code in patch #15 [Maciej]
>
> I had minor comments on last patch which you can take or not.
> From my side it is an ack for whole series:
>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> However you probably would like to ping Daniel against patch 7.
> Also, usage of printf vs ksft_print_msg seems sort of random throughout
> this series but it's not a big deal.

Yep, it has been more or less random from day one, unfortunately. I
will look into it for the next patch set of fixes.

> Thanks!
>
> >
> > Patches:
> > 1-5:   Small fixes and clean-ups
> > 6:     New convenient debug option when using a debugger such as gdb
> > 7-8:   Removal of unnecessary code
> > 9:     Add the ability to load external XDP programs
> > 10-11: Removal of more unnecessary code
> > 12:    Implement a new test where every other packet is XDP_DROP:ed
> > 13:    Unify the thread dispatching code
> > 14-15: Simplify the way tests are written when using custom packet_stre=
ams
> >        or custom XDP programs
> >
> > Thanks: Magnus
> >
> > Magnus Karlsson (15):
> >   selftests/xsk: print correct payload for packet dump
> >   selftests/xsk: do not close unused file descriptors
> >   selftests/xsk: submit correct number of frames in populate_fill_ring
> >   selftests/xsk: print correct error codes when exiting
> >   selftests/xsk: remove unused variable outstanding_tx
> >   selftests/xsk: add debug option for creating netdevs
> >   selftests/xsk: replace asm acquire/release implementations
> >   selftests/xsk: remove namespaces
> >   selftests/xsk: load and attach XDP program only once per mode
> >   selftests/xsk: remove unnecessary code in control path
> >   selftests/xsk: get rid of built-in XDP program
> >   selftests/xsk: add test when some packets are XDP_DROPed
> >   selftests/xsk: merge dual and single thread dispatchers
> >   selftests/xsk: automatically restore packet stream
> >   selftests/xsk: automatically switch XDP programs
> >
> >  tools/testing/selftests/bpf/Makefile          |   2 +-
> >  .../selftests/bpf/progs/xsk_xdp_progs.c       |  30 +
> >  tools/testing/selftests/bpf/test_xsk.sh       |  42 +-
> >  tools/testing/selftests/bpf/xsk.c             | 674 +-----------------
> >  tools/testing/selftests/bpf/xsk.h             |  97 +--
> >  tools/testing/selftests/bpf/xsk_prereqs.sh    |  12 +-
> >  tools/testing/selftests/bpf/xskxceiver.c      | 382 +++++-----
> >  tools/testing/selftests/bpf/xskxceiver.h      |  17 +-
> >  8 files changed, 308 insertions(+), 948 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> >
> >
> > base-commit: bb5747cfbc4b7fe29621ca6cd4a695d2723bf2e8
> > --
> > 2.34.1
