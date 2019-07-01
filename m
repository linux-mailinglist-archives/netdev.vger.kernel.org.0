Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631895B676
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfGAIMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfGAIMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 04:12:44 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 403A7C01F278;
        Mon,  1 Jul 2019 08:12:44 +0000 (UTC)
Received: from localhost (unknown [10.40.205.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 976B61001B29;
        Mon,  1 Jul 2019 08:12:42 +0000 (UTC)
Date:   Mon, 1 Jul 2019 10:12:39 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix inlines in test_lwt_seg6local
Message-ID: <20190701101239.1ad534bd@redhat.com>
In-Reply-To: <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
References: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
        <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com>
        <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 01 Jul 2019 08:12:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 11:04:54 -0700, Song Liu wrote:
> > Maybe use "__always_inline" as most other tests do?  
> 
> I meant "static __always_inline".

Sure, I can do that. It doesn't seem to be as consistent as you
suggest, though.

There are three different forms used in selftests/bpf/progs:

static __always_inline
static inline __attribute__((__always_inline__))
static inline __attribute__((always_inline))

As this is a bug causing selftests to fail (at least for some clang/llvm
versions), how about applying this to bpf.git as a minimal fix and
unifying the progs in bpf-next?

Thanks,

 Jiri
