Return-Path: <netdev+bounces-6718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E10F7179AF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC3828141B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE86FBE46;
	Wed, 31 May 2023 08:12:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC296BA2B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:12:24 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2C793
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685520743; x=1717056743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EStCc4K5CMW55CwMmntC1CTqhM5BAhomMm6Fkqe5rU4=;
  b=uPRZYFz1s87Nplqo0zql5FeFYEO1KDZadIPOljXOcrrZ3PhFS/d7nCcD
   8cJ3OaHubYoq0xl3Dj8b/JlJsf2BITj9RytQktfiah29jd6wdnZU12PLr
   4KtnhESRMPBLGgCUbev6oiJmyIVYG/sHzFTqza2xMwOTHXxLfqx04biYg
   EQR+q2FCSJmSBwXTW5nmTUs8wBVhovUaB+M63+xxja83E1rmo+qkTbU2U
   /7Q3rFUBsqwC5meqeUUe8KRR4tJ8RqJm7nsPj97IWAA2OygtDXTlGa60B
   Zjg1hyNbz+e3ZPxNtgtlOhp3b1G+CAqW/TizxvGVkcomPfu54jVYPdPgy
   g==;
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="213884819"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2023 01:12:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 31 May 2023 01:12:19 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 31 May 2023 01:12:18 -0700
Date: Wed, 31 May 2023 08:12:17 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Petr Machata <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 4/8] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Message-ID: <20230531081217.jgcahyzgx2rnoyue@DEN-LT-70577>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-4-9f38e688117e@microchip.com>
 <874jnt618e.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <874jnt618e.fsf@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Daniel Machon <daniel.machon@microchip.com> writes:
> 
> > When parsing APP table entries, priority and protocol is assigned from
> > value and key, respectively. Rewrite requires it opposite.
> >
> > Adapt the existing dcb_app_parse_mapping_cb for this, by using callbacks
> > for pushing app or rewr entries to the table.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  dcb/dcb.h     | 12 ++++++++++++
> >  dcb/dcb_app.c | 23 ++++++++++++-----------
> >  2 files changed, 24 insertions(+), 11 deletions(-)
> >
> > diff --git a/dcb/dcb.h b/dcb/dcb.h
> > index 84ce95d5c1b2..b3bc30cd02c5 100644
> > --- a/dcb/dcb.h
> > +++ b/dcb/dcb.h
> > @@ -62,7 +62,16 @@ struct dcb_app_table {
> >       int attr;
> >  };
> >
> > +struct dcb_app_parse_mapping {
> > +     __u8 selector;
> > +     struct dcb_app_table *tab;
> > +     int (*push)(struct dcb_app_table *tab,
> > +                 __u8 selector, __u32 key, __u64 value);
> > +     int err;
> > +};
> > +
> >  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> > +
> >  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> >  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> >  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> > @@ -70,11 +79,14 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> >  bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> >  bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> >
> > +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
> >  void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> >                                  const struct dcb_app_table *b,
> >                                  bool (*key_eq)(const struct dcb_app *aa,
> >                                                 const struct dcb_app *ab));
> >
> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
> > +
> >  /* dcb_apptrust.c */
> >
> >  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> > diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> > index 4cd175a0623b..97cba658aa6b 100644
> > --- a/dcb/dcb_app.c
> > +++ b/dcb/dcb_app.c
> > @@ -105,7 +105,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
> >       free(tab->apps);
> >  }
> >
> > -static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
> > +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
> >  {
> >       struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
> >
> > @@ -231,25 +231,25 @@ static void dcb_app_table_sort(struct dcb_app_table *tab)
> >       qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
> >  }
> >
> > -struct dcb_app_parse_mapping {
> > -     __u8 selector;
> > -     struct dcb_app_table *tab;
> > -     int err;
> > -};
> > -
> > -static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> > +static int dcb_app_push(struct dcb_app_table *tab,
> > +                     __u8 selector, __u32 key, __u64 value)
> >  {
> > -     struct dcb_app_parse_mapping *pm = data;
> >       struct dcb_app app = {
> > -             .selector = pm->selector,
> > +             .selector = selector,
> >               .priority = value,
> >               .protocol = key,
> >       };
> > +     return dcb_app_table_push(tab, &app);
> > +}
> > +
> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> > +{
> > +     struct dcb_app_parse_mapping *pm = data;
> >
> >       if (pm->err)
> >               return;
> >
> > -     pm->err = dcb_app_table_push(pm->tab, &app);
> > +     pm->err = pm->push(pm->tab, pm->selector, key, value);
> >  }
> >
> >  static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
> > @@ -663,6 +663,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
> >  {
> >       struct dcb_app_parse_mapping pm = {
> >               .tab = tab,
> > +             .push = dcb_app_push,
> >       };
> >       int ret;
> 
> I think I misunderstood your code. Since you are adding new functions
> for parsing the PRIO-DSCP and PRIO-PCP mappings, which have their own
> dcb_parse_mapping() invocations, couldn't you just copy over the
> dcb_app_parse_mapping_cb() from APP and adapt it to do the right thing
> for REWR? Then the push callback is not even necessary
> dcb_app_parse_mapping_cb() does not need to be public.

It is always a balance of when to do what. So far, patches #2, #3 and #4
tries to modify the existing dcb-app functions for dcb-rewr reuse. They
all deal with the prio:pid, pid:prio problem (printing, pushing and
replacing entries). What you suggest now is to copy
dcb_app_parse_mapping_cb() entirely, just for changing that order. It
can be done, but then it could also be done for #2 and #3, which would
then result in more boilerplate code.

Whatever we choose, I think we should stay consistent?

