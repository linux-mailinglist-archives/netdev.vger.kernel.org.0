Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A143C64C773
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiLNKxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbiLNKxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:53:20 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9A1E4;
        Wed, 14 Dec 2022 02:53:18 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qk9so43584641ejc.3;
        Wed, 14 Dec 2022 02:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P6YzrO2wIL4AH2kHMtaJUZU8nfPtHVRLrQy98AuLk1s=;
        b=TLa2bMtbsQRjIXRQ5f+UtQ1Kbo5p6AT05/10PGTimHCz+R72Dwv2AtNYW0jvH+5scH
         whEAeyuvAa/YwtKRL3f0JNctYn9kxWjZLa7KuhyErU2W2Q1afAehBGvVwN+8aWmXyKOv
         HXvybm995hLqrugTCxKfgJ2Uu8u8dPL1uPyEIHhp4uXzYBquWGxdyL61Z6rW0HLPMk6g
         nbNjTZjvdsiO4LMkWh+lctCGRno5r03f9xJ3135FtamAIUS7rdDqqmYK6iqpYzM/5bur
         H119KfCBmpfoYq0EkmaOkeo4CAWfYaTS6HOiDWo8m0yHvejg19QyuTHsA3tI6Y+o+G82
         rybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P6YzrO2wIL4AH2kHMtaJUZU8nfPtHVRLrQy98AuLk1s=;
        b=hXTjCmYKwEzWKpk7EpZHkeeHNC/5WeisIs219bF/AhMor6/QbE/rloFOt1I7+I3m3r
         ilVqw8KmW70FXBfApjodPPWhymwj+aC78+/bqIqEx8B4QOBD3+XUR0qJZYcqJi4EqnVO
         1g2efy8iJ170TFpQuVnGod7vyiUqtVO6eKt7JnqEpmtL74Y7DDY3X6E0JacJXWeWf7QQ
         LjvOqSxVK9wXIkFrXPIBP0A5WmnGbLUdiUBU51IYfQYpiA856LJ5Z4ZyxNYABVfDs7Bi
         wXCg2SkwGkkLeQ+Y1zxc+OKNfvHLBk+7Cp6P3hsSQ7cy1YuX9LMfVlIazS0g/7iIb9xN
         OzLw==
X-Gm-Message-State: ANoB5pmyqkLZNOYqM3Fyy59eN5eBMvtQmO1FN9rEu2ClDOTfsDTWhbqo
        FgeYYSUUJyWzJk868IHWTIkbe8cSvmzUueuFnCI=
X-Google-Smtp-Source: AA0mqf7Z+cvu3vvf7xAwC0VnSR37fwG2iPusF6ofWWHPKos8QON9FT0nI8/4DuklZKpfvcvFb75Jvdg2J3F0VxRwi6s=
X-Received: by 2002:a17:907:7784:b0:7ad:9ad7:e882 with SMTP id
 ky4-20020a170907778400b007ad9ad7e882mr68368410ejc.520.1671015197359; Wed, 14
 Dec 2022 02:53:17 -0800 (PST)
MIME-Version: 1.0
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-13-magnus.karlsson@gmail.com> <Y5dFImCN9B6bR3yG@boxer>
In-Reply-To: <Y5dFImCN9B6bR3yG@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Dec 2022 11:53:04 +0100
Message-ID: <CAJ8uoz0HcfG-mkmEEPifmq9_4puBymbk=Yw6jU6XUrRgGrWPXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/15] selftests/xsk: add test when some packets
 are XDP_DROPed
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 4:14 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Dec 06, 2022 at 10:08:23AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Add a new test where some of the packets are not passed to the AF_XDP
> > socket and instead get a XDP_DROP verdict. This is important as it
> > tests the recycling mechanism of the buffer pool. If a packet is not
> > sent to the AF_XDP socket, the buffer the packet resides in is instead
> > recycled so it can be used again without the round-trip to user
> > space. The test introduces a new XDP program that drops every other
> > packet.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  2 +-
> >  .../selftests/bpf/progs/xsk_xdp_drop.c        | 25 ++++++++++
> >  tools/testing/selftests/bpf/xskxceiver.c      | 48 +++++++++++++++++--
> >  tools/testing/selftests/bpf/xskxceiver.h      |  3 ++
> >  4 files changed, 72 insertions(+), 6 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 42e15b5a34a7..77ef8a8e6db4 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
> >  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> >  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> >  $(OUTPUT)/xsk.o: $(BPFOBJ)
> > -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h
> > +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h $(OUTPUT)/xsk_xdp_drop.skel.h
> >
> >  BPFTOOL ?= $(DEFAULT_BPFTOOL)
> >  $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
> > diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> > new file mode 100644
> > index 000000000000..12a12b0d9fc1
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2022 Intel */
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_XSKMAP);
> > +     __uint(max_entries, 1);
> > +     __uint(key_size, sizeof(int));
> > +     __uint(value_size, sizeof(int));
> > +} xsk SEC(".maps");
> > +
> > +static unsigned int idx;
> > +
> > +SEC("xdp") int xsk_xdp_drop(struct xdp_md *xdp)
> > +{
> > +     /* Drop every other packet */
> > +     if (idx++ % 2)
> > +             return XDP_DROP;
> > +
> > +     return bpf_redirect_map(&xsk, 0, XDP_DROP);
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index 0cda4e3f1871..522dc1d69c17 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -1654,18 +1654,53 @@ static void testapp_invalid_desc(struct test_spec *test)
> >       pkt_stream_restore_default(test);
> >  }
> >
> > -static int xsk_load_xdp_program(struct ifobject *ifobj)
> > +static void testapp_xdp_drop(struct test_spec *test)
> > +{
> > +     struct ifobject *ifobj = test->ifobj_rx;
> > +     int err;
> > +
> > +     test_spec_set_name(test, "XDP_CONSUMES_SOME_PACKETS");
>
> XDP_DROP_ODD_PACKETS ?

Ha! What is an ODD packet?!?! I will think of a better name than these two.

> > +     xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> > +     err = xsk_attach_xdp_program(ifobj->xdp_drop->progs.xsk_xdp_drop, ifobj->ifindex,
> > +                                  ifobj->xdp_flags);
> > +     if (err) {
> > +             printf("Error attaching XDP_DROP program\n");
> > +             test->fail = true;
> > +             return;
> > +     }
> > +     ifobj->xskmap = ifobj->xdp_drop->maps.xsk;
> > +
> > +     pkt_stream_receive_half(test);
> > +     testapp_validate_traffic(test);
> > +
> > +     pkt_stream_restore_default(test);
> > +     xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> > +     err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
> > +                                  ifobj->xdp_flags);
> > +     if (err) {
> > +             printf("Error restoring default XDP program\n");
> > +             exit_with_error(-err);
> > +     }
> > +     ifobj->xskmap = ifobj->def_prog->maps.xsk;
> > +}
> > +
> > +static int xsk_load_xdp_programs(struct ifobject *ifobj)
> >  {
> >       ifobj->def_prog = xsk_def_prog__open_and_load();
> >       if (libbpf_get_error(ifobj->def_prog))
> >               return libbpf_get_error(ifobj->def_prog);
> >
> > +     ifobj->xdp_drop = xsk_xdp_drop__open_and_load();
> > +     if (libbpf_get_error(ifobj->xdp_drop))
> > +             return libbpf_get_error(ifobj->xdp_drop);
> > +
> >       return 0;
> >  }
> >
> > -static void xsk_unload_xdp_program(struct ifobject *ifobj)
> > +static void xsk_unload_xdp_programs(struct ifobject *ifobj)
> >  {
> >       xsk_def_prog__destroy(ifobj->def_prog);
> > +     xsk_xdp_drop__destroy(ifobj->xdp_drop);
> >  }
> >
> >  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
> > @@ -1692,7 +1727,7 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
> >       if (!load_xdp)
> >               return;
> >
> > -     err = xsk_load_xdp_program(ifobj);
> > +     err = xsk_load_xdp_programs(ifobj);
> >       if (err) {
> >               printf("Error loading XDP program\n");
> >               exit_with_error(err);
> > @@ -1804,6 +1839,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
> >       case TEST_TYPE_HEADROOM:
> >               testapp_headroom(test);
> >               break;
> > +     case TEST_TYPE_XDP_CONSUMES_PACKETS:
> > +             testapp_xdp_drop(test);
> > +             break;
> >       default:
> >               break;
> >       }
> > @@ -1971,8 +2009,8 @@ int main(int argc, char **argv)
> >
> >       pkt_stream_delete(tx_pkt_stream_default);
> >       pkt_stream_delete(rx_pkt_stream_default);
> > -     xsk_unload_xdp_program(ifobj_tx);
> > -     xsk_unload_xdp_program(ifobj_rx);
> > +     xsk_unload_xdp_programs(ifobj_tx);
> > +     xsk_unload_xdp_programs(ifobj_rx);
> >       ifobject_delete(ifobj_tx);
> >       ifobject_delete(ifobj_rx);
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> > index eb6355bcc143..3483ac240b2e 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > @@ -6,6 +6,7 @@
> >  #define XSKXCEIVER_H_
> >
> >  #include "xsk_def_prog.skel.h"
> > +#include "xsk_xdp_drop.skel.h"
> >
> >  #ifndef SOL_XDP
> >  #define SOL_XDP 283
> > @@ -87,6 +88,7 @@ enum test_type {
> >       TEST_TYPE_STATS_RX_FULL,
> >       TEST_TYPE_STATS_FILL_EMPTY,
> >       TEST_TYPE_BPF_RES,
> > +     TEST_TYPE_XDP_CONSUMES_PACKETS,
> >       TEST_TYPE_MAX
> >  };
> >
> > @@ -141,6 +143,7 @@ struct ifobject {
> >       validation_func_t validation_func;
> >       struct pkt_stream *pkt_stream;
> >       struct xsk_def_prog *def_prog;
> > +     struct xsk_xdp_drop *xdp_drop;
>
> Is this going to scale if we add plenty of XDP progs for testing?

Good point. No. I will put the programs in the same source file and
see if that makes it better.

> >       struct bpf_map *xskmap;
> >       int ifindex;
> >       u32 dst_ip;
> > --
> > 2.34.1
> >
