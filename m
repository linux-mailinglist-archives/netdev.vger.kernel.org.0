Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFA86760C0
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjATWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjATWuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:50:07 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBF2CA2C
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:49:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so10434828pjm.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eObadKArSgHkepFrKBedeZ5xyeKR3KRJqKeEFPEYgXw=;
        b=pxXQriX7a1w5N5lVDMxWBmB2cm0i/lDxSVo1MNqVC5EnzDZbXdFjDSk5ehcuSArsFL
         YeCxPwZrHhckOqadcBQvADP3FPaE/2YEEZiXiBTTFTOPgp6nBI1fyeiLShNxweaHqpVb
         rPFWs4lLa+p4Fxvqh22RdOrBpvqRw1HGrd294gLX6HNe6yZHjtEyuWPudPe3MtrR0h1P
         Tw2HccuMtZh2qzxHRTchSZH6FFw1vuCfErVrIMyfvLNnfWm8dCcxtGpxafZS0DHtQ6F+
         TrTsaROGlcOP4PX9I9X9nH/6a0jgDIx7Gno2VsufuuEEYgmpQw6ZaR7teoABICaDXtNG
         me5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eObadKArSgHkepFrKBedeZ5xyeKR3KRJqKeEFPEYgXw=;
        b=qOr0+o3yY56FNFEoN7VNCNJd6wi+6uumxm4I9o5MbLNRYMckYlJ8//UFVnVm6daDtd
         S4b1MASrGaklCVZrfcohoKGJZSabZQ5wsqsGkLzpKQnOhhPvu6NH3Ciaw+bYwwb+V9y3
         AHb8QXDKrqIHJzC9OAjAfjy9d1EVDkoFxYmY0/ZeFY1LRB9qodwcktRii99n0AK2a9tL
         Mi7LApr4R605DUpWy8f++Scd+BsXiCXdxpaGQFZjnywNgNHR3+swysqJp0tpEEUkTuFy
         lliLQf9bCOwrPrpndrMvky/8BXuurOXEUtuxme04MAYo2OTeQRPYu2c10Ga98SgOtEW6
         xFbA==
X-Gm-Message-State: AFqh2kq6yoJTcG5S88DAyxr94rqaUMu5hvsJrYEyfWcdWJ+1D6a4IdYz
        VWlWFPd9YJV386fxd5QYUNPUI20H8SJDQqvJHrBO4Q==
X-Google-Smtp-Source: AMrXdXtao8z/kHlIVvd0cymJJDtEe0u2uVNNtlff2acD17VdLohukAXmnkI3YBg5bmyZqBXdzzfKawd4u6xMfGYPIqo=
X-Received: by 2002:a17:90b:3741:b0:219:fbc:a088 with SMTP id
 ne1-20020a17090b374100b002190fbca088mr2184826pjb.162.1674254926970; Fri, 20
 Jan 2023 14:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <20230119221536.3349901-18-sdf@google.com>
 <dfa5590d-17a6-a1bc-62ef-235f0190f037@linux.dev>
In-Reply-To: <dfa5590d-17a6-a1bc-62ef-235f0190f037@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 20 Jan 2023 14:48:35 -0800
Message-ID: <CAKH8qBvgcA9e3S6vn61Qa3x36O69P0AWWt4YQobpE2hinUVrpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 2:30 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index e09bef2b7502..9c961d2d868e 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> >       test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> > -     xskxceiver xdp_redirect_multi xdp_synproxy veristat
> > +     xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
> >
> >   TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
> >   TEST_GEN_FILES += liburandom_read.so
> > @@ -383,6 +383,7 @@ test_subskeleton.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib
> >   test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o
> >   test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
> >   xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
> > +xdp_hw_metadata.skel.h-deps := xdp_hw_metadata.bpf.o
> >
> >   LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
> >
> > @@ -580,6 +581,10 @@ $(OUTPUT)/xskxceiver: xskxceiver.c $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.
> >       $(call msg,BINARY,,$@)
> >       $(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
> >
> > +$(OUTPUT)/xdp_hw_metadata: xdp_hw_metadata.c $(OUTPUT)/network_helpers.o $(OUTPUT)/xsk.o $(OUTPUT)/xdp_hw_metadata.skel.h | $(OUTPUT)
> > +     $(call msg,BINARY,,$@)
> > +     $(Q)$(CC) $(CFLAGS) -static $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
>
> My dev machine fails on '-static' :(. A few machines that I got also don't have
> those static libraries, so likely the default environment that I got here.
>
> It seems to be the only binary using '-static' in this Makefile. Can it be
> removed or at least not the default?

Sure, I can leave it out. It's mostly here due to G's environment
where it is easier to work with static binaries.
