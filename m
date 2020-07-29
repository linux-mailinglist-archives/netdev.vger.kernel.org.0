Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78432325D9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgG2UHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:07:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726644AbgG2UHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596053229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TetWfEfY/6XryPkTZ6kYeEY9wBFtpZgH4Dbq4eezLjs=;
        b=ISrlF6khWgCWca3SNU8tJqGnSZ111DKLiwAjFYF4a6yJ0TwZzVhMitxEXdXkF0Jq69tg3y
        2mJQLZycwhsIS6twY3a7rqH6MdmEKUoaK0qElSx6hEC1q8ZMSPsabzaluyiKN7RFhHHXFQ
        f63+ctwGaRfXoUJQdNol1vNoINf+xIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-GBofMUcCPTy2b52YpO_dSA-1; Wed, 29 Jul 2020 16:07:04 -0400
X-MC-Unique: GBofMUcCPTy2b52YpO_dSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29E27102C7F1;
        Wed, 29 Jul 2020 20:07:02 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id BF13519C71;
        Wed, 29 Jul 2020 20:06:58 +0000 (UTC)
Date:   Wed, 29 Jul 2020 22:06:57 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 bpf-next 01/13] selftests/bpf: Fix resolve_btfids test
Message-ID: <20200729200657.GP1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-2-jolsa@kernel.org>
 <CAEf4Bzba08D8-zPBq3RpsG3fcRt8Q31VKd-_fV2LuJVwHGaY=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzba08D8-zPBq3RpsG3fcRt8Q31VKd-_fV2LuJVwHGaY=w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:27:49PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The linux/btf_ids.h header is now using CONFIG_DEBUG_INFO_BTF
> > config, so we need to have it defined when it's available.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> sure, why not

actually after rebase I realized Yonghong added
CONFIG_DEBUG_INFO_BTF define in:
  d8dfe5bfe856 ("tools/bpf: Sync btf_ids.h to tools")

I think including 'autoconf.h' is more clean,
on the other hand I don't think we'd get clean
selftest compile without CONFIG_DEBUG_INFO_BTF

should we keep the #define instead?

thanks,
jirka

> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > index 3b127cab4864..101785b49f7e 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > @@ -1,5 +1,6 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >
> > +#include "autoconf.h"
> >  #include <linux/err.h>
> >  #include <string.h>
> >  #include <bpf/btf.h>
> > --
> > 2.25.4
> >
> 

