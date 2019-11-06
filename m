Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D53F1870
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbfKFOYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:24:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731907AbfKFOYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573050283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N2XxDjFDA9UptvX+jORI71qobLiI/obRRQh0sftH/IU=;
        b=DsgHtvhZYFRTklE9ouTmMYNhut3hqmVxJ2iuetn5qtMbyjT9lbCSrM2zMeeuP5mPaERdzR
        IT1Giw/tRl4HqMUX7yDdtN8fybHwTCiLA9GmCPLE9p+C+G2qL2BQnsgUCrT1ueRdqomf2U
        qx4JizNcIqr7HdBI5aBt+VjPihzsU40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-wJB3O13zMCqib-iADYVcww-1; Wed, 06 Nov 2019 09:24:41 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEA4F2A3;
        Wed,  6 Nov 2019 14:24:38 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F20C6600C4;
        Wed,  6 Nov 2019 14:24:34 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:24:34 +0100
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
Subject: Re: [PATCH v5 10/10] perf tools: report initial event parsing error
Message-ID: <20191106142434.GH30214@krava>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-11-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191030223448.12930-11-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: wJB3O13zMCqib-iADYVcww-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:34:48PM -0700, Ian Rogers wrote:

SNIP

> +
> +void parse_events_print_error(struct parse_events_error *err,
> +=09=09=09      const char *event)
> +{
> +=09if (!err->num_errors)
> +=09=09return;
> +
> +=09__parse_events_print_error(err->idx, err->str, err->help, event);
> +=09zfree(&err->str);
> +=09zfree(&err->help);
> +
> +=09if (err->num_errors > 1) {
> +=09=09fputs("\nInitial error:\n", stderr);
> +=09=09__parse_events_print_error(err->first_idx, err->first_str,
> +=09=09=09=09=09err->first_help, event);
> +=09=09zfree(&err->first_str);
> +=09=09zfree(&err->first_help);
>  =09}
>  }
> =20
> @@ -2071,7 +2104,9 @@ int parse_events_option(const struct option *opt, c=
onst char *str,
>  =09=09=09int unset __maybe_unused)
>  {
>  =09struct evlist *evlist =3D *(struct evlist **)opt->value;
> -=09struct parse_events_error err =3D { .idx =3D 0, };
> +=09struct parse_events_error err;
> +
> +=09bzero(&err, sizeof(err));
>  =09int ret =3D parse_events(evlist, str, &err);

this breaks compilation:

make[3]: Nothing to be done for 'plugins/libtraceevent-dynamic-list'.
util/parse-events.c: In function =E2=80=98parse_events_option=E2=80=99:
util/parse-events.c:2110:2: error: ISO C90 forbids mixed declarations and c=
ode [-Werror=3Ddeclaration-after-statement]
 2110 |  int ret =3D parse_events(evlist, str, &err);
      |  ^~~

thanks,
jirka

