Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690CEF1881
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfKFOY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:24:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39239 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731940AbfKFOY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573050295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RhHobyYh9ijzE4wvXVCIndEt3fY4MLi6qpg7E+Jssrw=;
        b=f3ZDQ0ynR5UUJ0gOo62XmW4AAJOAkfv7jddWOiF1ADznUKpI0VDhxxI99QXxosegsqtiMM
        aGfhw/UwLjTAjBlVWBJW5pXBmnfTkJpPwGzcMCcC9tl+i6XruTR65rH7FZdtUILt+JIv4z
        ZVH13u6jKHAXEsENPNe7fRWxh7HJHfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-5yIztn3xMxCHo9k_wo72PQ-1; Wed, 06 Nov 2019 09:24:51 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B6E31800D63;
        Wed,  6 Nov 2019 14:24:49 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 83D0919488;
        Wed,  6 Nov 2019 14:24:45 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:24:44 +0100
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
Subject: Re: [PATCH v5 09/10] perf tools: add a deep delete for parse event
 terms
Message-ID: <20191106142444.GI30214@krava>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-10-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191030223448.12930-10-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 5yIztn3xMxCHo9k_wo72PQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:34:47PM -0700, Ian Rogers wrote:
> Add a parse_events_term deep delete function so that owned strings and
> arrays are freed.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/perf/util/parse-events.c | 16 +++++++++++++---
>  tools/perf/util/parse-events.h |  1 +
>  tools/perf/util/parse-events.y | 12 ++----------
>  tools/perf/util/pmu.c          |  2 +-
>  4 files changed, 17 insertions(+), 14 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index a0a80f4e7038..6d18ff9bce49 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -2812,6 +2812,18 @@ int parse_events_term__clone(struct parse_events_t=
erm **new,
>  =09return new_term(new, &temp, str, 0);
>  }
> =20
> +void parse_events_term__delete(struct parse_events_term *term)
> +{
> +=09if (term->array.nr_ranges)
> +=09=09zfree(&term->array.ranges);
> +
> +=09if (term->type_val !=3D PARSE_EVENTS__TERM_TYPE_NUM)
> +=09=09zfree(&term->val.str);
> +
> +=09zfree(&term->config);
> +=09free(term);
> +}
> +
>  int parse_events_copy_term_list(struct list_head *old,
>  =09=09=09=09 struct list_head **new)
>  {
> @@ -2842,10 +2854,8 @@ void parse_events_terms__purge(struct list_head *t=
erms)
>  =09struct parse_events_term *term, *h;
> =20
>  =09list_for_each_entry_safe(term, h, terms, list) {
> -=09=09if (term->array.nr_ranges)
> -=09=09=09zfree(&term->array.ranges);
>  =09=09list_del_init(&term->list);
> -=09=09free(term);
> +=09=09parse_events_term__delete(term);
>  =09}
>  }
> =20
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-event=
s.h
> index 34f58d24a06a..5ee8ac93840c 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -139,6 +139,7 @@ int parse_events_term__sym_hw(struct parse_events_ter=
m **term,
>  =09=09=09      char *config, unsigned idx);
>  int parse_events_term__clone(struct parse_events_term **new,
>  =09=09=09     struct parse_events_term *term);
> +void parse_events_term__delete(struct parse_events_term *term);
>  void parse_events_terms__delete(struct list_head *terms);
>  void parse_events_terms__purge(struct list_head *terms);
>  void parse_events__clear_array(struct parse_events_array *a);
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-event=
s.y
> index 376b19855470..4cac830015be 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -49,14 +49,6 @@ static void free_list_evsel(struct list_head* list_evs=
el)
>  =09free(list_evsel);
>  }
> =20
> -static void free_term(struct parse_events_term *term)
> -{
> -=09if (term->type_val =3D=3D PARSE_EVENTS__TERM_TYPE_STR)
> -=09=09free(term->val.str);
> -=09zfree(&term->array.ranges);
> -=09free(term);
> -}
> -
>  static void inc_group_count(struct list_head *list,
>  =09=09       struct parse_events_state *parse_state)
>  {
> @@ -99,7 +91,7 @@ static void inc_group_count(struct list_head *list,
>  %type <str> PE_DRV_CFG_TERM
>  %destructor { free ($$); } <str>
>  %type <term> event_term
> -%destructor { free_term ($$); } <term>
> +%destructor { parse_events_term__delete ($$); } <term>
>  %type <list_terms> event_config
>  %type <list_terms> opt_event_config
>  %type <list_terms> opt_pmu_config
> @@ -694,7 +686,7 @@ event_config ',' event_term
>  =09struct parse_events_term *term =3D $3;
> =20
>  =09if (!head) {
> -=09=09free_term(term);
> +=09=09parse_events_term__delete(term);
>  =09=09YYABORT;
>  =09}
>  =09list_add_tail(&term->list, head);
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index f9f427d4c313..db1e57113f4b 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -1260,7 +1260,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, str=
uct list_head *head_terms,
>  =09=09info->metric_name =3D alias->metric_name;
> =20
>  =09=09list_del_init(&term->list);
> -=09=09free(term);
> +=09=09parse_events_term__delete(term);
>  =09}
> =20
>  =09/*
> --=20
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20

