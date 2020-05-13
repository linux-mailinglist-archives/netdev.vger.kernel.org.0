Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FA51D0491
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgEMB6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:58:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgEMB6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589335125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=77+XXBt2gs34d+8MeL5SJyFeuKzL200Dyavb3OVXe7M=;
        b=CgbVF+QzM3f1O1gz1/bVmn7aXQZW7cjy3t9Fz3kLAlybG+C0G9Zzu0M8Ekx9MsvXfLRrUX
        sO2jvVza4RdqcPmY98oLgip2PI0Ckx5uV4yRo4firWHHi5pZPZcchB/VmbnoFMQDjfNTR3
        jrUTsRGYDU37WQe+13VSWz9LVpxm7t8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-I8rWLPs1Mo2r6DjiTgi2VA-1; Tue, 12 May 2020 21:58:40 -0400
X-MC-Unique: I8rWLPs1Mo2r6DjiTgi2VA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19DD11899528;
        Wed, 13 May 2020 01:58:39 +0000 (UTC)
Received: from astarta.redhat.com (ovpn-112-2.ams2.redhat.com [10.36.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D757A99D6;
        Wed, 13 May 2020 01:58:36 +0000 (UTC)
From:   Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and test_maps w/ general rule
References: <20191016060051.2024182-1-andriin@fb.com>
        <20191016060051.2024182-6-andriin@fb.com>
        <xunymu6chpt2.fsf@redhat.com>
        <CAEf4BzbE3UYw_rKAGNW9HQ5AVeebt=PDuRnEiijrwaKxNsdiYg@mail.gmail.com>
Date:   Wed, 13 May 2020 04:58:34 +0300
In-Reply-To: <CAEf4BzbE3UYw_rKAGNW9HQ5AVeebt=PDuRnEiijrwaKxNsdiYg@mail.gmail.com>
        (Andrii Nakryiko's message of "Tue, 12 May 2020 15:13:18 -0700")
Message-ID: <xunyimh0ppdh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrii!

>>>>> On Tue, 12 May 2020 15:13:18 -0700, Andrii Nakryiko  wrote:

 > On Tue, May 12, 2020 at 1:16 PM Yauheni Kaliuta
 > <yauheni.kaliuta@redhat.com> wrote:
 >> 
 >> Hi, Andrii!
 >> 
 >> The patch blanks TEST_GEN_FILES which was used by install target
 >> (lib.mk) to install test progs. How is it supposed to work?
 >> 

 > I actually never used install for selftests, just make and
 > then run individual test binaries, which explains why this
 > doesn't work :)

Ok :)  Thanks for the clarification.

 >> That fixes it for me btw:
 >> 
 >> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
 >> index 8f25966b500b..1f878dcd2bf6 100644
 >> --- a/tools/testing/selftests/bpf/Makefile
 >> +++ b/tools/testing/selftests/bpf/Makefile
 >> @@ -265,6 +265,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
 >> TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,      \
 >> $$(filter-out $(SKEL_BLACKLIST),       \
 >> $$(TRUNNER_BPF_SRCS)))
 >> +TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)

 > Yeah, this makes sense, these files will be copied over along
 > the compiled test_xxx binaries. Do you mind submitting a
 > patch?

No, sure, I'll do.


-- 
WBR,
Yauheni Kaliuta

