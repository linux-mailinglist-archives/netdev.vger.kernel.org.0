Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB23E4FE5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440598AbfJYPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:14:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45996 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440582AbfJYPOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:14:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so2732400wrs.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T+Bv0KDvuw3zXjFcMykuhlzsgcG5x86hqhsyWGKJAKE=;
        b=HTlq9o3+YNDDGDD7TahgG8mRuxc519LbkOHeT37SfqoeCxp1TVY+RybOxdVyvvnFD3
         UlfwTQT9lRSgib/zZMqjXY6Dh1YMfC2BBQ+9VmdH11JOdx2ixMCs8UrkTrMittLhkBdU
         vnF5RZTMoazwhe6SitYQLTA+Bq9IqGOyxdMRD0lT4Fr8PgjQwiRKDYYIRYmZT9ktoQUr
         8X4wcAM7FkKCpeap5QKKDVJNi8ynsFVuAk311hylTVlYL3hIRZhnsOmfWU3+42WbBJj/
         q3SRMiu5ovgy6QsA+tbcy+GEk034dmyg3ZERS9eHUFr7MSGxE9j9l68Gae555PCAA6dw
         chmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T+Bv0KDvuw3zXjFcMykuhlzsgcG5x86hqhsyWGKJAKE=;
        b=c+CTeXLyXAuMa0lyAL9IxCyAFbGD9176bDkehiWPl+mB+VUSvDdwCoTwuaMS/Ra/Ti
         OCbkaiqBonCXQbS36rFvDoIshgDy2LEjO8WJaxDMZHTO+Fx1+PPhCLUGMD01Q71rp4BO
         WIY0ehp7pNZQ7yBkEtdeOKclWCcHXIt3O8UfDXUNcvlzBBN5emmnk1aq1i5B8zFhbIuh
         96qVFJDnTdG7cpxiVzcsBEd18LMtiXDs3BtDt8MiPxuwJ2IjMoZfpnhPA6ZU3iH8GvnS
         CkmsBGmNM6pm5lvXJKAe8xL2JNjlXKVYCE8jXtRiKBwQEMarP+PtChSPHqs1NOyBHjtU
         TAOw==
X-Gm-Message-State: APjAAAWIcB7MCR4IZ9d2PJ2ue9cu0swObznY7Yb7vbJTusA8SZhvwzXK
        wAhkXduxhVVF1Qhi6FEcrKcZts3z+PAsr0VHBp6sYg==
X-Google-Smtp-Source: APXvYqx0wabBX2GROOnLQ1/mF6u8ewFIkqx2Q1mzzWoRksLl6dpvRqEnq1q/YI9ndy00nOtpK5R5wOC30ELOYgKFF+o=
X-Received: by 2002:a5d:6785:: with SMTP id v5mr3524578wru.174.1572016487559;
 Fri, 25 Oct 2019 08:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com> <20191025075820.GE31679@krava>
In-Reply-To: <20191025075820.GE31679@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 25 Oct 2019 08:14:36 -0700
Message-ID: <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] perf tools: add parse events append error
To:     Jiri Olsa <jolsa@redhat.com>
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
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 12:58 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> > Parse event error handling may overwrite one error string with another
> > creating memory leaks and masking errors. Introduce a helper routine
> > that appends error messages and avoids the memory leak.
> >
> > A reproduction of this problem can be seen with:
> >   perf stat -e c/c/
> > After this change this produces:
> > event syntax error: 'c/c/'
> >                        \___ unknown term (previous error: unknown term =
(previous error: unknown term (previous error: unknown term (previous error=
: unknown term (previous error: unknown term (previous error: unknown term =
(previous error: unknown term (previous error: unknown term (previous error=
: unknown term (previous error: unknown term (previous error: unknown term =
(previous error: unknown term (previous error: unknown term (previous error=
: unknown term (previous error: unknown term (previous error: unknown term =
(previous error: unknown term (previous error: unknown term (previous error=
: unknown term (previous error: unknown term (previous error: Cannot find P=
MU `c'. Missing kernel support?)(help: valid terms: event,filter_rem,filter=
_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_opc=
1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config,c=
onfig1,config2,name,period,percore))(help: valid terms: event,filter_rem,fi=
lter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter=
_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,conf=
ig,config1,config2,name,period,percore))(help: valid terms: event,filter_re=
m,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,fi=
lter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,=
config,config1,config2,name,period,percore))(help: valid terms: event,filte=
r_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umas=
k,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter=
_nm,config,config1,config2,name,period,percore))(help: valid terms: event,f=
ilter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,=
umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fi=
lter_nm,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,=
inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_stat=
e,filter_nm,config,config1,config2,name,period,percore))(help: valid terms:=
 event,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,frontend,cmas=
k,config,config1,config2,name,period,percore))(help: valid terms: event,fil=
ter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,um=
ask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filt=
er_nm,config,config1,config2,name,period,percore))(help: valid terms: event=
,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,in=
v,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,=
filter_nm,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,config,config1,config2,name,period,percore))(help: valid terms: event,=
filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv=
,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,f=
ilter_nm,config,config1,config2,name,period,percore))(help: valid terms: ev=
ent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc=
,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_sta=
te,filter_nm,config,config1,config2,name,period,percore))(help: valid terms=
: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filte=
r_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter=
_state,filter_nm,config,config1,config2,name,period,percore))(help: valid t=
erms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,f=
ilter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fi=
lter_state,filter_nm,config,config1,config2,name,period,percore))(help: val=
id terms: event,config,config1,config2,name,period,percore))(help: valid te=
rms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fi=
lter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fil=
ter_state,filter_nm,config,config1,config2,name,period,percore))(help: vali=
d terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_lo=
c,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm=
,filter_state,filter_nm,config,config1,config2,name,period,percore))(help: =
valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filte=
r_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_no=
t_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(he=
lp: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,f=
ilter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filte=
r_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore)=
)(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_t=
id,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,f=
ilter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,perc=
ore))
>
>
> hum... I'd argue that the previous state was better:
>
> [jolsa@krava perf]$ ./perf stat -e c/c/
> event syntax error: 'c/c/'
>                        \___ unknown term
>
>
> jirka

I am agnostic. We can either have the previous state or the new state,
I'm keen to resolve the memory leak. Another alternative is to warn
that multiple errors have occurred before dropping or printing the
previous error. As the code is shared in memory places the approach
taken here was to try to not conceal anything that could potentially
be useful. Given this, is the preference to keep the status quo
without any warning?

Thanks,
Ian

> >
> > valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,f=
ilter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filte=
r_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore
> > Run 'perf list' for a list of valid events
> >
> >  Usage: perf stat [<options>] [<command>]
> >
> >     -e, --event <event>   event selector. use 'perf list' to list avail=
able events
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/parse-events.c | 100 +++++++++++++++++++++++----------
> >  tools/perf/util/parse-events.h |   2 +
> >  tools/perf/util/pmu.c          |  30 ++++++----
> >  3 files changed, 89 insertions(+), 43 deletions(-)
> >
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-eve=
nts.c
> > index db882f630f7e..edb3ae76777d 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -182,6 +182,38 @@ static int tp_event_has_id(const char *dir_path, s=
truct dirent *evt_dir)
> >
> >  #define MAX_EVENT_LENGTH 512
> >
> > +void parse_events__append_error(struct parse_events_error *err, int id=
x,
> > +                             char *str, char *help)
> > +{
> > +     char *new_str =3D NULL;
> > +
> > +     if (WARN(!str, "WARNING: failed to provide error string")) {
> > +             free(help);
> > +             return;
> > +     }
> > +     if (err->str) {
> > +             int ret;
> > +
> > +             if (err->help) {
> > +                     ret =3D asprintf(&new_str,
> > +                             "%s (previous error: %s(help: %s))",
> > +                             str, err->str, err->help);
> > +             } else {
> > +                     ret =3D asprintf(&new_str,
> > +                             "%s (previous error: %s)",
> > +                             str, err->str);
> > +             }
> > +             if (ret < 0)
> > +                     new_str =3D NULL;
> > +             else
> > +                     zfree(&str);
> > +     }
> > +     err->idx =3D idx;
> > +     free(err->str);
> > +     err->str =3D new_str ?: str;
> > +     free(err->help);
> > +     err->help =3D help;
> > +}
> >
> >  struct tracepoint_path *tracepoint_id_to_path(u64 config)
> >  {
> > @@ -932,11 +964,11 @@ static int check_type_val(struct parse_events_ter=
m *term,
> >               return 0;
> >
> >       if (err) {
> > -             err->idx =3D term->err_val;
> > -             if (type =3D=3D PARSE_EVENTS__TERM_TYPE_NUM)
> > -                     err->str =3D strdup("expected numeric value");
> > -             else
> > -                     err->str =3D strdup("expected string value");
> > +             parse_events__append_error(err, term->err_val,
> > +                                     type =3D=3D PARSE_EVENTS__TERM_TY=
PE_NUM
> > +                                     ? strdup("expected numeric value"=
)
> > +                                     : strdup("expected string value")=
,
> > +                                     NULL);
> >       }
> >       return -EINVAL;
> >  }
> > @@ -972,8 +1004,11 @@ static bool config_term_shrinked;
> >  static bool
> >  config_term_avail(int term_type, struct parse_events_error *err)
> >  {
> > +     char *err_str;
> > +
> >       if (term_type < 0 || term_type >=3D __PARSE_EVENTS__TERM_TYPE_NR)=
 {
> > -             err->str =3D strdup("Invalid term_type");
> > +             parse_events__append_error(err, -1,
> > +                                     strdup("Invalid term_type"), NULL=
);
> >               return false;
> >       }
> >       if (!config_term_shrinked)
> > @@ -992,9 +1027,9 @@ config_term_avail(int term_type, struct parse_even=
ts_error *err)
> >                       return false;
> >
> >               /* term_type is validated so indexing is safe */
> > -             if (asprintf(&err->str, "'%s' is not usable in 'perf stat=
'",
> > -                          config_term_names[term_type]) < 0)
> > -                     err->str =3D NULL;
> > +             if (asprintf(&err_str, "'%s' is not usable in 'perf stat'=
",
> > +                             config_term_names[term_type]) >=3D 0)
> > +                     parse_events__append_error(err, -1, err_str, NULL=
);
> >               return false;
> >       }
> >  }
> > @@ -1036,17 +1071,20 @@ do {                                           =
                          \
> >       case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
> >               CHECK_TYPE_VAL(STR);
> >               if (strcmp(term->val.str, "no") &&
> > -                 parse_branch_str(term->val.str, &attr->branch_sample_=
type)) {
> > -                     err->str =3D strdup("invalid branch sample type")=
;
> > -                     err->idx =3D term->err_val;
> > +                 parse_branch_str(term->val.str,
> > +                                 &attr->branch_sample_type)) {
> > +                     parse_events__append_error(err, term->err_val,
> > +                                     strdup("invalid branch sample typ=
e"),
> > +                                     NULL);
> >                       return -EINVAL;
> >               }
> >               break;
> >       case PARSE_EVENTS__TERM_TYPE_TIME:
> >               CHECK_TYPE_VAL(NUM);
> >               if (term->val.num > 1) {
> > -                     err->str =3D strdup("expected 0 or 1");
> > -                     err->idx =3D term->err_val;
> > +                     parse_events__append_error(err, term->err_val,
> > +                                             strdup("expected 0 or 1")=
,
> > +                                             NULL);
> >                       return -EINVAL;
> >               }
> >               break;
> > @@ -1080,8 +1118,9 @@ do {                                             =
                          \
> >       case PARSE_EVENTS__TERM_TYPE_PERCORE:
> >               CHECK_TYPE_VAL(NUM);
> >               if ((unsigned int)term->val.num > 1) {
> > -                     err->str =3D strdup("expected 0 or 1");
> > -                     err->idx =3D term->err_val;
> > +                     parse_events__append_error(err, term->err_val,
> > +                                             strdup("expected 0 or 1")=
,
> > +                                             NULL);
> >                       return -EINVAL;
> >               }
> >               break;
> > @@ -1089,9 +1128,9 @@ do {                                             =
                          \
> >               CHECK_TYPE_VAL(NUM);
> >               break;
> >       default:
> > -             err->str =3D strdup("unknown term");
> > -             err->idx =3D term->err_term;
> > -             err->help =3D parse_events_formats_error_string(NULL);
> > +             parse_events__append_error(err, term->err_term,
> > +                             strdup("unknown term"),
> > +                             parse_events_formats_error_string(NULL));
> >               return -EINVAL;
> >       }
> >
> > @@ -1142,9 +1181,9 @@ static int config_term_tracepoint(struct perf_eve=
nt_attr *attr,
> >               return config_term_common(attr, term, err);
> >       default:
> >               if (err) {
> > -                     err->idx =3D term->err_term;
> > -                     err->str =3D strdup("unknown term");
> > -                     err->help =3D strdup("valid terms: call-graph,sta=
ck-size\n");
> > +                     parse_events__append_error(err, term->err_term,
> > +                             strdup("unknown term"),
> > +                             strdup("valid terms: call-graph,stack-siz=
e\n"));
> >               }
> >               return -EINVAL;
> >       }
> > @@ -1323,10 +1362,12 @@ int parse_events_add_pmu(struct parse_events_st=
ate *parse_state,
> >
> >       pmu =3D perf_pmu__find(name);
> >       if (!pmu) {
> > -             if (asprintf(&err->str,
> > +             char *err_str;
> > +
> > +             if (asprintf(&err_str,
> >                               "Cannot find PMU `%s'. Missing kernel sup=
port?",
> > -                             name) < 0)
> > -                     err->str =3D NULL;
> > +                             name) >=3D 0)
> > +                     parse_events__append_error(err, -1, err_str, NULL=
);
> >               return -EINVAL;
> >       }
> >
> > @@ -2797,13 +2838,10 @@ void parse_events__clear_array(struct parse_eve=
nts_array *a)
> >  void parse_events_evlist_error(struct parse_events_state *parse_state,
> >                              int idx, const char *str)
> >  {
> > -     struct parse_events_error *err =3D parse_state->error;
> > -
> > -     if (!err)
> > +     if (!parse_state->error)
> >               return;
> > -     err->idx =3D idx;
> > -     err->str =3D strdup(str);
> > -     WARN_ONCE(!err->str, "WARNING: failed to allocate error string");
> > +
> > +     parse_events__append_error(parse_state->error, idx, strdup(str), =
NULL);
> >  }
> >
> >  static void config_terms_list(char *buf, size_t buf_sz)
> > diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-eve=
nts.h
> > index 769e07cddaa2..a7d42faeab0c 100644
> > --- a/tools/perf/util/parse-events.h
> > +++ b/tools/perf/util/parse-events.h
> > @@ -124,6 +124,8 @@ struct parse_events_state {
> >       struct list_head          *terms;
> >  };
> >
> > +void parse_events__append_error(struct parse_events_error *err, int id=
x,
> > +                             char *str, char *help);
> >  void parse_events__shrink_config_terms(void);
> >  int parse_events__is_hardcoded_term(struct parse_events_term *term);
> >  int parse_events_term__num(struct parse_events_term **term,
> > diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> > index adbe97e941dd..4015ec11944a 100644
> > --- a/tools/perf/util/pmu.c
> > +++ b/tools/perf/util/pmu.c
> > @@ -1050,9 +1050,9 @@ static int pmu_config_term(struct list_head *form=
ats,
> >               if (err) {
> >                       char *pmu_term =3D pmu_formats_string(formats);
> >
> > -                     err->idx  =3D term->err_term;
> > -                     err->str  =3D strdup("unknown term");
> > -                     err->help =3D parse_events_formats_error_string(p=
mu_term);
> > +                     parse_events__append_error(err, term->err_term,
> > +                             strdup("unknown term"),
> > +                             parse_events_formats_error_string(pmu_ter=
m));
> >                       free(pmu_term);
> >               }
> >               return -EINVAL;
> > @@ -1080,8 +1080,9 @@ static int pmu_config_term(struct list_head *form=
ats,
> >               if (term->no_value &&
> >                   bitmap_weight(format->bits, PERF_PMU_FORMAT_BITS) > 1=
) {
> >                       if (err) {
> > -                             err->idx =3D term->err_val;
> > -                             err->str =3D strdup("no value assigned fo=
r term");
> > +                             parse_events__append_error(err, term->err=
_val,
> > +                                        strdup("no value assigned for =
term"),
> > +                                        NULL);
> >                       }
> >                       return -EINVAL;
> >               }
> > @@ -1094,8 +1095,9 @@ static int pmu_config_term(struct list_head *form=
ats,
> >                                               term->config, term->val.s=
tr);
> >                       }
> >                       if (err) {
> > -                             err->idx =3D term->err_val;
> > -                             err->str =3D strdup("expected numeric val=
ue");
> > +                             parse_events__append_error(err, term->err=
_val,
> > +                                     strdup("expected numeric value"),
> > +                                     NULL);
> >                       }
> >                       return -EINVAL;
> >               }
> > @@ -1108,11 +1110,15 @@ static int pmu_config_term(struct list_head *fo=
rmats,
> >       max_val =3D pmu_format_max_value(format->bits);
> >       if (val > max_val) {
> >               if (err) {
> > -                     err->idx =3D term->err_val;
> > -                     if (asprintf(&err->str,
> > -                                  "value too big for format, maximum i=
s %llu",
> > -                                  (unsigned long long)max_val) < 0)
> > -                             err->str =3D strdup("value too big for fo=
rmat");
> > +                     char *err_str;
> > +
> > +                     parse_events__append_error(err, term->err_val,
> > +                             asprintf(&err_str,
> > +                                 "value too big for format, maximum is=
 %llu",
> > +                                 (unsigned long long)max_val) < 0
> > +                                 ? strdup("value too big for format")
> > +                                 : err_str,
> > +                                 NULL);
> >                       return -EINVAL;
> >               }
> >               /*
> > --
> > 2.23.0.866.gb869b98d4c-goog
> >
>
