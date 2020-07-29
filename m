Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E9231D53
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG2LZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:25:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21637 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgG2LZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596021931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=agULd+iNaamozlyp0IIId3EUPs3ltJ7uHXJPbleqiKE=;
        b=HGaBNHkZQ457ACjLgYlgzMAK2wwlzCmRlwWSQRsgmCkMsyzZxOWu2mHu8aHdvrl3CBH88a
        h9txLV02fiOipX72T9cZp6t8vRVUBJMxtHMxQX8gtjCRgPgiludzxE6k64go/MmhXnKbeJ
        aU4+FKyYTlsJkvjqTS7NKmlYc6JEGko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-79PhX5N1P3CTHqiUpDcTxw-1; Wed, 29 Jul 2020 07:25:27 -0400
X-MC-Unique: 79PhX5N1P3CTHqiUpDcTxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 034D280046A;
        Wed, 29 Jul 2020 11:25:24 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id C2FFA61100;
        Wed, 29 Jul 2020 11:25:19 +0000 (UTC)
Date:   Wed, 29 Jul 2020 13:25:18 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 bpf-next 12/13] selftests/bpf: Add test for d_path
 helper
Message-ID: <20200729112518.GH1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-13-jolsa@kernel.org>
 <CAEf4BzYTT23knreKpxPDLeWcLzTVQhtBrRPjrZ+MBpL4ajeavw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYTT23knreKpxPDLeWcLzTVQhtBrRPjrZ+MBpL4ajeavw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:53:00PM -0700, Andrii Nakryiko wrote:

SNIP

> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret = set_pathname(procfd, pid);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret = set_pathname(devfd, pid);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret = set_pathname(localfd, pid);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret = set_pathname(indicatorfd, pid);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> 
> Please use CHECK instead of CHECK_FAIL. Thanks.

ok

> > diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> > new file mode 100644
> > index 000000000000..e02dce614256
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> > @@ -0,0 +1,64 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +#define MAX_PATH_LEN           128
> > +#define MAX_EVENT_NUM          16
> > +
> > +pid_t my_pid;
> > +__u32 cnt_stat;
> > +__u32 cnt_close;
> > +char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +int rets_stat[MAX_EVENT_NUM];
> > +int rets_close[MAX_EVENT_NUM];
> > +
> 
> please zero-initialize all of these, it causes issues on some Clang versions

ook

jirka

