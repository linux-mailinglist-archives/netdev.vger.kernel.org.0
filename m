Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF89E14BA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390618AbfJWIu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:50:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390607AbfJWIu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571820657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YI79mYRt92nE/8ezIrvSVBz+DsF7BXp0cmzQIdyUOA4=;
        b=A9JPW8X1gyhQlw1429QsJESpF/kqz0g/6vhvKdim+s6QBKYHMh60D4ZKvF+FlPTqpnj5Iy
        nIF6FCOYeh3gW+34+KKReYjri2cyUvCs85UBS4/IynnYF+bH2GlHA1ftp8ZZe8VFoieCmM
        OzbHvHxiFt84g/VoTIv0ZCvuQsdlac8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-U6V1Un5eMgiryiQC6QiOAw-1; Wed, 23 Oct 2019 04:50:53 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5BD0476;
        Wed, 23 Oct 2019 08:50:50 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9C56C1001DC2;
        Wed, 23 Oct 2019 08:50:46 +0000 (UTC)
Date:   Wed, 23 Oct 2019 10:50:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 3/9] perf tools: ensure config and str in terms are
 unique
Message-ID: <20191023085045.GE22919@krava>
References: <20191017170531.171244-1-irogers@google.com>
 <20191023005337.196160-1-irogers@google.com>
 <20191023005337.196160-4-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191023005337.196160-4-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: U6V1Un5eMgiryiQC6QiOAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:53:31PM -0700, Ian Rogers wrote:

SNIP

>  =09=09=09=09=09return -1;
> +=09=09=09=09}
>  =09=09=09=09list_add_tail(&term->list, head);
> =20
>  =09=09=09=09if (!parse_events_add_pmu(parse_state, list,
>  =09=09=09=09=09=09=09  pmu->name, head,
>  =09=09=09=09=09=09=09  true, true)) {
> -=09=09=09=09=09pr_debug("%s -> %s/%s/\n", str,
> +=09=09=09=09=09pr_debug("%s -> %s/%s/\n", config,
>  =09=09=09=09=09=09 pmu->name, alias->str);
>  =09=09=09=09=09ok++;
>  =09=09=09=09}
> @@ -1462,8 +1472,10 @@ int parse_events_multi_pmu_add(struct parse_events=
_state *parse_state,
>  =09=09=09}
>  =09=09}
>  =09}
> -=09if (!ok)
> +=09if (!ok) {
> +=09=09free(list);
>  =09=09return -1;
> +=09}
>  =09*listp =3D list;
>  =09return 0;
>  }
> @@ -2761,13 +2773,13 @@ int parse_events_term__sym_hw(struct parse_events=
_term **term,
>  =09struct parse_events_term temp =3D {
>  =09=09.type_val  =3D PARSE_EVENTS__TERM_TYPE_STR,
>  =09=09.type_term =3D PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09.config    =3D config ?: (char *) "event",
> +=09=09.config    =3D config ?: strdup("event"),

there's no check if this succeeds

>  =09};
> =20
>  =09BUG_ON(idx >=3D PERF_COUNT_HW_MAX);
>  =09sym =3D &event_symbols_hw[idx];
> =20
> -=09return new_term(term, &temp, (char *) sym->symbol, 0);
> +=09return new_term(term, &temp, strdup(sym->symbol), 0);
>  }
> =20
>  int parse_events_term__clone(struct parse_events_term **new,
> @@ -2776,12 +2788,15 @@ int parse_events_term__clone(struct parse_events_=
term **new,
>  =09struct parse_events_term temp =3D {
>  =09=09.type_val  =3D term->type_val,
>  =09=09.type_term =3D term->type_term,
> -=09=09.config    =3D term->config,
> +=09=09.config    =3D term->config ? strdup(term->config) : NULL,

ditto

also how is this released when term is freed?

thanks,
jirka

