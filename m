Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E781068EA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVJgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:36:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20340 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726563AbfKVJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 04:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574415368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aU1zVBlNkCLJysnB+cZtbLnWGPv5IyTK8c2mO5gdd2M=;
        b=d0FNyR7aZkBvUHsm4PQcurLkNyDN8C0rKR8qpHAqYg2e5yuEms5GH5KMy2NA/n7n4I5H28
        DS1s8RSVb74l+Lc2FWqofOPMGvdgOjSSAqqCLZXeUvYkxPfmJXW6ha4FoWz1Qhu4U87dDa
        //2H4gfx0Ct/pIFdcJVOdi8NNM+vz1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-6rWHyCpnOiizGqJSIl9-oQ-1; Fri, 22 Nov 2019 04:36:04 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40928DBE7;
        Fri, 22 Nov 2019 09:36:02 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 866E41036C8A;
        Fri, 22 Nov 2019 09:35:56 +0000 (UTC)
Date:   Fri, 22 Nov 2019 10:35:55 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191122093555.GC8287@krava>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 6rWHyCpnOiizGqJSIl9-oQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 06:41:31PM -0500, Paul Moore wrote:

SNIP

> a common requirement for new audit functionality (link below).  I'm
> also fairly certain we don't want this new BPF record to look like how
> you've coded it up in bpf_audit_prog(); duplicating the fields with
> audit_log_task() is wrong, you've either already got them via an
> associated record (which you get from passing non-NULL as the first
> parameter to audit_log_start()), or you don't because there is no
> associated syscall/task (which you get from passing NULL as the first

ok, I'll send change that reflects this.. together with the test

thanks,
jirka

> parameter).  Please revert, un-merge, etc. this patch from bpf-next;
> it should not go into Linus' tree as written.
>=20
> Audit userspace PR:
> * https://github.com/linux-audit/audit-userspace/pull/104
>=20
> Audit test suite:
> * https://github.com/linux-audit/audit-testsuite
>=20
> Audit folks, here is a link to the thread in the archives:
> * https://lore.kernel.org/bpf/20191120213816.8186-1-jolsa@kernel.org/T/#u
>=20
> --=20
> paul moore
> www.paul-moore.com
>=20

