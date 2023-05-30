Return-Path: <netdev+bounces-6279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 540717157DC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2CAF1C20B8F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF6912B65;
	Tue, 30 May 2023 08:03:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7238F125CA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:03:39 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9632A90
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685433814; x=1716969814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gINQpSNPcs0k4lAwBEBcqwZUNkZyTXpuc5We/EVoljM=;
  b=epM4ATtUSR6wP0ty5xExwhqkC5M7W20mdjTtj5YUsymbs1cwyVDHTdvG
   xvaUWv/ZYfScbAaI8bg4OmcW8pbIoAgb2gWJbIEZ2G76GAs+TaqVYUkII
   6aU+1BPK4tqeDOnJGmlE8MJiKVOSY6zjavxp6tt3BDKx8n/sXwypCx36Y
   qwhEzssuaj2TXhNmfoB1qXt7iZSCbpH6xR6RkbcAyoBcsZAbRmdQq5PEm
   +mwC005wpSw8CpcKGRRfWiXvRKPTaGi9xzSk1+zQvz5H+RayQUNWYVqjp
   68XRGROXV4R5i11UILvDOHKPr7ZFb94h4Hetmet/6TggyP7c4yO/kzuzs
   w==;
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="217903747"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 01:03:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 01:03:32 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 01:03:31 -0700
Date: Tue, 30 May 2023 08:03:30 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Petr Machata <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 3/8] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Message-ID: <ZHWt0geuzEfIU3Ck@DEN-LT-70577>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-3-9f38e688117e@microchip.com>
 <87pm6j5ako.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87pm6j5ako.fsf@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > When doing a replace command, entries are checked against selector and
> > protocol. Rewrite requires the check to be against selector and
> > priority.
> >
> > Adapt the existing dcb_app_table_remove_replace function for this, by
> > using callback functions for selector, pid and prio checks.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  dcb/dcb.h     | 14 ++++++++++++++
> >  dcb/dcb_app.c | 32 ++++++++++++++++++++------------
> >  2 files changed, 34 insertions(+), 12 deletions(-)
> >
> > diff --git a/dcb/dcb.h b/dcb/dcb.h
> > index d40664f29dad..84ce95d5c1b2 100644
> > --- a/dcb/dcb.h
> > +++ b/dcb/dcb.h
> > @@ -56,11 +56,25 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
> >
> >  /* dcb_app.c */
> >
> > +struct dcb_app_table {
> > +     struct dcb_app *apps;
> > +     size_t n_apps;
> > +     int attr;
> > +};
> > +
> >  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> >  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> >  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> >  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> >
> > +bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> > +bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> 
> This function isn't necessary until 5/8, that's when it should be added.
> 
> > +
> > +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b,
> > +                                bool (*key_eq)(const struct dcb_app *aa,
> > +                                               const struct dcb_app *ab));
> > +
> 
> This is conflating publication with prototype change. It would be best
> to separate. I think the publication could be done at the point when you
> actually need the function, i.e. 5/8 as well. I would keep here just the
> prototype change.
> 

Sounds OK to me. Will change in next v.
 

