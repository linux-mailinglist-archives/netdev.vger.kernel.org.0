Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0582E2321B3
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgG2Peo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:34:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30437 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbgG2Peo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596036882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTGQnYg0KcXp4LmK/hXI4Cd5e+3IE3LiYGTq9nImvGc=;
        b=P1nf6hTpN7KvGn2yc5a6naQRyxYie7BSA2hePozQFE8jPHkRMHcixJLV7vRwhl9wlrbKUR
        Xp9PiJJk5psyclX+4cXHoPJ+c5AiU/JLuO471wP9jypKg2jERSewXkeoCmrslZwfFoeb5J
        51yqAcaap20GgvIfImF+Qfu1NpdE/MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-g8oXH2zeNoOUf3OmdWP5RA-1; Wed, 29 Jul 2020 11:34:38 -0400
X-MC-Unique: g8oXH2zeNoOUf3OmdWP5RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80FA2100AA21;
        Wed, 29 Jul 2020 15:34:33 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id ED1F971906;
        Wed, 29 Jul 2020 15:34:28 +0000 (UTC)
Date:   Wed, 29 Jul 2020 17:34:28 +0200
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
Subject: Re: [PATCH v8 bpf-next 13/13] selftests/bpf: Add set test to
 resolve_btfids
Message-ID: <20200729153428.GJ1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-14-jolsa@kernel.org>
 <CAEf4BzbMNZdiD_hqReei2HKziTTNoWFymE5g7SzvSR7=QdWxrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbMNZdiD_hqReei2HKziTTNoWFymE5g7SzvSR7=QdWxrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:56:02PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 22, 2020 at 2:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding test to for sets resolve_btfids. We're checking that
> > testing set gets properly resolved and sorted.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/resolve_btfids.c | 33 +++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > index 101785b49f7e..cc90aa244285 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > @@ -48,6 +48,15 @@ BTF_ID(struct,  S)
> >  BTF_ID(union,   U)
> >  BTF_ID(func,    func)
> >
> > +BTF_SET_START(test_set)
> > +BTF_ID(typedef, S)
> > +BTF_ID(typedef, T)
> > +BTF_ID(typedef, U)
> > +BTF_ID(struct,  S)
> > +BTF_ID(union,   U)
> > +BTF_ID(func,    func)
> > +BTF_SET_END(test_set)
> > +
> >  static int
> >  __resolve_symbol(struct btf *btf, int type_id)
> >  {
> > @@ -126,5 +135,29 @@ int test_resolve_btfids(void)
> >                 }
> >         }
> >
> > +       /* Check BTF_SET_START(test_set) IDs */
> > +       for (i = 0; i < test_set.cnt && !ret; i++) {
> 
> nit: usual we just do `goto err_out;` instead of complicating exit
> condition in a for loop

ok

> 
> > +               bool found = false;
> > +
> > +               for (j = 0; j < ARRAY_SIZE(test_symbols); j++) {
> > +                       if (test_symbols[j].id != test_set.ids[i])
> > +                               continue;
> > +                       found = true;
> > +                       break;
> > +               }
> > +
> > +               ret = CHECK(!found, "id_check",
> > +                           "ID %d for %s not found in test_symbols\n",
> > +                           test_symbols[j].id, test_symbols[j].name);
> 
> j == ARRAY_SIZE(test_symbols), you probably meant to get
> test_set.ids[i] instead of test_symbol name/id?

oh yea.. test_set.ids[i] is not found in here

> 
> > +               if (ret)
> > +                       break;
> > +
> > +               if (i > 0) {
> > +                       ret = CHECK(test_set.ids[i - 1] > test_set.ids[i],
> 
> nit: >= would be the invalid condition

yes, we actualy allow for same IDs to appear in the set

thanks,
jirka

> 
> > +                                   "sort_check",
> > +                                   "test_set is not sorted\n");
> > +               }
> > +       }
> > +
> >         return ret;
> >  }
> > --
> > 2.25.4
> >
> 

