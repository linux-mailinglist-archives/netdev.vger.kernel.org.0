Return-Path: <netdev+bounces-6779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2410F717EDD
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B311C20CDF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF2B14270;
	Wed, 31 May 2023 11:50:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F40C8ED
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:50:36 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0BE101
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBELCDL8fCy+azyX7udqnQ53Q/M3wf53R30vW6T8l+98cDFvYYs1hJSh7svO15gV1HZbsk6DG2tEK7qxYNuoWYZLG6Yj5COIMeCkk6rre49FwD6vdtSFslYXTuOPFs8u8pyZxt563ALWlUDlyLkVGCvD9OmuN78qkOVx4zGM3365RdL4ub9ANLgc7O2B5jL6gUdF70bMZNZTMejzqbYclF6xh9zbKFiSu0IAQwtG2opYavL3S3WKKHcZBgYifNO94tGgqnaIcbkuArGorF2fTmfmgyfZlQ7cLA/yq9dpqmbfcDQaCD6MgN6uNM7evTtcQR/8OkILuMSW8V/xi6OsYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZjBDpqTxciPVZJ25y4fZjJoZ0i3ZYys3S6Xwxo5NQc=;
 b=Ok+c0ITkEL7IdzSOci8lZeF/bO78cdMUkftMlV1FmuRyo3+ie6vd6kF3D3A79qR68UNNG2MtyehLhlKc9ln3rieKdDSvSMridmE4Vpo8UW+lLzlIY63QTQqVH7FI2epEF0vtByvW/8MSpLtSJkZouq3CO9zFuPhSq9DWrEmqpgUxJSooT+xyXA1sgDFixN5d07O+Kf4WpbOB4dS9YXSdWnU90nH4qu0iYrv5r2U97M0Tg25/7zlXdm5fRmovaIcyCFIONi8G4pbZGhuUJrwly9RCEelTpdKbLJQhlMpcmAWwO2N0VhZNNDoJJ5uOt9Jv0LAGRrteIjZzWD9uEaC10g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZjBDpqTxciPVZJ25y4fZjJoZ0i3ZYys3S6Xwxo5NQc=;
 b=gFaaoPaGYPREK7WwQxrih2lqNIH6zzRDrB/f/PT9KePoGTR6aMzYdmDgYYVOWPnwMU2ULR3JD4E/kZDAXsF2AzYE0dOfiSldBWT0G22Bc5tbxoBxN28Sg3Bf5xTTgE/9ywSqokjZvZP8UbKwOsQhWkV0njAO3VIG5lRdFAbrcq005RE39M+yDWSZIlD1OqsWiLK5m/8JWxo5J4ZS67+69R8nI+VW9Y6+WQsp/kALv2wuKZYCbQs17o+8/9s6okOBx5UEQ7MM55WXD+bxkIg59zPp+crmK4onpNGAcAxsZvY5xfYhN77V0k+s6XvlOWluZFkqYSUViLHn42qgUZuvnw==
Received: from BN9PR03CA0848.namprd03.prod.outlook.com (2603:10b6:408:13d::13)
 by IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 11:50:31 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::92) by BN9PR03CA0848.outlook.office365.com
 (2603:10b6:408:13d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23 via Frontend
 Transport; Wed, 31 May 2023 11:50:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.23 via Frontend Transport; Wed, 31 May 2023 11:50:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 31 May 2023
 04:50:16 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 31 May
 2023 04:50:15 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-4-9f38e688117e@microchip.com>
 <874jnt618e.fsf@nvidia.com> <20230531081217.jgcahyzgx2rnoyue@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
	<dsahern@kernel.org>, <stephen@networkplumber.org>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 4/8] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Date: Wed, 31 May 2023 13:05:25 +0200
In-Reply-To: <20230531081217.jgcahyzgx2rnoyue@DEN-LT-70577>
Message-ID: <87jzwo4t57.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT012:EE_|IA0PR12MB8301:EE_
X-MS-Office365-Filtering-Correlation-Id: 54305108-1ad9-473e-e660-08db61cd3c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GNzi4mGWL5aSEfZCRXq/Cqfdf7nBPPWdYgaaXLIx3I9pZRnPp7EoxBZr7Q33w+C/FBUn69FUICAZJDiei1En7ziWpsODcKwT8U6Jn7fZi2JuRFbbM6KBA63Ap9LwRQ1LDQzz8/f90PZBixgtWcmatIJFZEMpou/8ETYlgokA4Z9vGRgt7CoGZAv0IeSukszTnM1KxAte6eEgGoZyGGhKQf1PkXWtImLLS8/2bPSQtxKrxCL8RMnBa3gbAtVOTQ5M/ODOHF/uT7Al1qpWn8wAy0yHFdEUto4kgOX2t6oTn7efg5C72BnwN9PCyfPrEZQqzEN7dbEuqOofM8TZkWPpC61NzKnbxY9UzwYToDA+MDXm1asbGxmq8RyPZkCNHZZXOj24EqxSBv0Y0IlXYjWAHIBlRaFTbhl3X4qxDVO8Tio10Naz5fbh7C64mZXbLEqH/ZExAbQLk/jYroOM63+mFaMF+9e4+HwgBE8Az/Hc3bQNZIQtlbIiVgyPlITKFGnCXx8cK4+I0DZ6ukSXDMFCQUTOoMcriD5oTc1pWgacAN0VhOhNdVG/sqeNEPKzr+VPNOfttzWgaCNzSemMKADK5yIDUK0tR4UvovUaI8tWSDsDMMA9Ygo+Qa9yyhKTi951/ejgqhS/j7jOQk64B3NSjL0PinXwNJsbb862w4BdpWd5Tb7tV/wLjH9KeUALx3edEK1ciKvkHJ+pbLGenAGKgyhlw+R83g19UQWu2/UgaFserknTWNKU+gdMQ9Wffbf+
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(2906002)(8936002)(66899021)(82740400003)(8676002)(26005)(356005)(5660300002)(7636003)(40460700003)(40480700001)(47076005)(478600001)(83380400001)(41300700001)(36756003)(54906003)(86362001)(6666004)(36860700001)(186003)(16526019)(426003)(336012)(70206006)(2616005)(6916009)(70586007)(4326008)(82310400005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 11:50:30.8298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54305108-1ad9-473e-e660-08db61cd3c43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8301
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

>> Daniel Machon <daniel.machon@microchip.com> writes:
>> 
>> > When parsing APP table entries, priority and protocol is assigned from
>> > value and key, respectively. Rewrite requires it opposite.
>> >
>> > Adapt the existing dcb_app_parse_mapping_cb for this, by using callbacks
>> > for pushing app or rewr entries to the table.
>> >
>> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>> > ---
>> >  dcb/dcb.h     | 12 ++++++++++++
>> >  dcb/dcb_app.c | 23 ++++++++++++-----------
>> >  2 files changed, 24 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/dcb/dcb.h b/dcb/dcb.h
>> > index 84ce95d5c1b2..b3bc30cd02c5 100644
>> > --- a/dcb/dcb.h
>> > +++ b/dcb/dcb.h
>> > @@ -62,7 +62,16 @@ struct dcb_app_table {
>> >       int attr;
>> >  };
>> >
>> > +struct dcb_app_parse_mapping {
>> > +     __u8 selector;
>> > +     struct dcb_app_table *tab;
>> > +     int (*push)(struct dcb_app_table *tab,
>> > +                 __u8 selector, __u32 key, __u64 value);
>> > +     int err;
>> > +};
>> > +
>> >  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>> > +
>> >  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>> >  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>> >  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>> > @@ -70,11 +79,14 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>> >  bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>> >  bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>> >
>> > +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
>> >  void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>> >                                  const struct dcb_app_table *b,
>> >                                  bool (*key_eq)(const struct dcb_app *aa,
>> >                                                 const struct dcb_app *ab));
>> >
>> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
>> > +
>> >  /* dcb_apptrust.c */
>> >
>> >  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
>> > diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
>> > index 4cd175a0623b..97cba658aa6b 100644
>> > --- a/dcb/dcb_app.c
>> > +++ b/dcb/dcb_app.c
>> > @@ -105,7 +105,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
>> >       free(tab->apps);
>> >  }
>> >
>> > -static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>> > +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>> >  {
>> >       struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
>> >
>> > @@ -231,25 +231,25 @@ static void dcb_app_table_sort(struct dcb_app_table *tab)
>> >       qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
>> >  }
>> >
>> > -struct dcb_app_parse_mapping {
>> > -     __u8 selector;
>> > -     struct dcb_app_table *tab;
>> > -     int err;
>> > -};
>> > -
>> > -static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
>> > +static int dcb_app_push(struct dcb_app_table *tab,
>> > +                     __u8 selector, __u32 key, __u64 value)
>> >  {
>> > -     struct dcb_app_parse_mapping *pm = data;
>> >       struct dcb_app app = {
>> > -             .selector = pm->selector,
>> > +             .selector = selector,
>> >               .priority = value,
>> >               .protocol = key,
>> >       };
>> > +     return dcb_app_table_push(tab, &app);
>> > +}
>> > +
>> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
>> > +{
>> > +     struct dcb_app_parse_mapping *pm = data;
>> >
>> >       if (pm->err)
>> >               return;
>> >
>> > -     pm->err = dcb_app_table_push(pm->tab, &app);
>> > +     pm->err = pm->push(pm->tab, pm->selector, key, value);
>> >  }
>> >
>> >  static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
>> > @@ -663,6 +663,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
>> >  {
>> >       struct dcb_app_parse_mapping pm = {
>> >               .tab = tab,
>> > +             .push = dcb_app_push,
>> >       };
>> >       int ret;
>> 
>> I think I misunderstood your code. Since you are adding new functions
>> for parsing the PRIO-DSCP and PRIO-PCP mappings, which have their own
>> dcb_parse_mapping() invocations, couldn't you just copy over the
>> dcb_app_parse_mapping_cb() from APP and adapt it to do the right thing
>> for REWR? Then the push callback is not even necessary
>> dcb_app_parse_mapping_cb() does not need to be public.
>
> It is always a balance of when to do what. So far, patches #2, #3 and #4
> tries to modify the existing dcb-app functions for dcb-rewr reuse. They
> all deal with the prio:pid, pid:prio problem (printing, pushing and
> replacing entries). What you suggest now is to copy
> dcb_app_parse_mapping_cb() entirely, just for changing that order. It
> can be done, but then it could also be done for #2 and #3, which would
> then result in more boilerplate code.
>
> Whatever we choose, I think we should stay consistent?

I mean, where do you put the threshold? Because what currently gets
reused is this:

void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
{
	struct dcb_app_parse_mapping *pm = data;

	if (pm->err)
		return;

	pm->err = pm->push(pm->tab, pm->selector, key, value);
}

(OK, that, and the helper data structure)

IMHO the ceremony around the declaration, it not being near where it's
used, the extra callback to make it generic, etc., is more expensive
than what the reuse saves us.

Like, similarly we could talk about reusing dcb_cmd_app() for
dcb_rewr_app() or whatever. But we shamelessly duplicate, because
making it reusable is more expensive than what it brings.

If anything, I would reuse the data structure, and copy the callback.

