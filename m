Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FBE12A312
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 16:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfLXPtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 10:49:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbfLXPtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 10:49:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577202562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ym5Rj89pLJN6P8a7v9msWZpoU2JaL1iBGr+uuDCwvGg=;
        b=Lov7OXwOT2DwQrjbER+aa6Hf3x0APdDkgc4w9mQ+9SCondNkIFxzCErpqeMhHge+w5JU3y
        jbFXSvumt0eYNJj9Zjrp2xp56oGVeDKSlAP7ymJlrNca/isULKj0yhA09TdShiTrqOBTC/
        BNC24vFSfYavdv448gD7nvSF8VJe/70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-V2JwHFw5O1a2P9AM01dlsQ-1; Tue, 24 Dec 2019 10:49:18 -0500
X-MC-Unique: V2JwHFw5O1a2P9AM01dlsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FB081005502;
        Tue, 24 Dec 2019 15:49:17 +0000 (UTC)
Received: from [10.36.116.145] (ovpn-116-145.ams2.redhat.com [10.36.116.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46C2E1036D00;
        Tue, 24 Dec 2019 15:49:16 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
Date:   Tue, 24 Dec 2019 16:49:14 +0100
Message-ID: <D7D7916C-CE3A-4047-B392-02BE97B4B4F1@redhat.com>
In-Reply-To: <CAEf4BzYppnG--OnEo0Ft9+pcvJ6+mY47XzY5F+r+2p3+FeUQcA@mail.gmail.com>
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
 <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
 <FE4A1C64-70CF-4831-922C-F3992C40E57B@redhat.com>
 <CAEf4BzYppnG--OnEo0Ft9+pcvJ6+mY47XzY5F+r+2p3+FeUQcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Dec 2019, at 18:57, Andrii Nakryiko wrote:

> On Mon, Dec 23, 2019 at 4:54 AM Eelco Chaudron <echaudro@redhat.com> wrote:
<SNIP<
>>
>> Thanks for the review, updated my kernel to the latest bfp-next, but now
>> I get the following build issue for the test suite:
>>
>>     GEN-SKEL [test_progs] loop3.skel.h
>>     GEN-SKEL [test_progs] test_skeleton.skel.h
>> libbpf: failed to find BTF for extern 'CONFIG_BPF_SYSCALL': -2
>
> This looks like you have Clang without BTF types for extern. Can you
> try pull the very latest Clang/LLVM and try again? The latest commit
> you should have is e3d8ee35e4ad ("reland "[DebugInfo] Support to emit
> debugInfo for extern variables"").
>

Thanks, rebuilding the latest master LLVM fixed the problem!

//Eelco

