Return-Path: <netdev+bounces-4866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D7270EE35
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA2AD280DB7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2202B187C;
	Wed, 24 May 2023 06:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19B15D5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:39:45 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01891172C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684910361; x=1716446361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fGKCWp4DtvOnjwwHQhCwkUg7JVL47LWQWlH+XZYMjQk=;
  b=PkkF1E7/u+VrdCFDYrAMEWuWjm+/mTwA/CKXQ+J8DGclpHGJzMRnElwA
   mnM2O6P8fK5uH6D05ymtU50/VJnNT2wI0IUsd5G5nVkl5rYXADv4/AgJB
   qsXdI+e2RL/t32NHZMyJnAo0qjV4kHOhxHd5394D6G6P89EMKpFy+ILIO
   UdYlt0heHiZiD/6iUvon+A4oQjsumafKguEaiWRgI/eNIHNu/7jtko8Ur
   +m6JLKS0KlNe9rxlSHDPnBEyZfV4+Cx9NaaBc4lPY6nARoMFsBCbd6M+8
   RJ6UScNm1IjZZHBioj2s7dpakCKCYGHeyc7SbSo/ouAE+ch6V2VVESE7h
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="216999072"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:39:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:39:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 23 May 2023 23:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgkiQbM93Zk7NScB0wEkrJIK/xlMkcFVJA1aDir6N2JszQ/CQbThvs6yvREOczM5SwSc8Flbxuo99HvW2eGvtkzltELep0D5n+XumqjRqEoFJ5P6Gb9W5bxooEn3Gr/HD5abmFRYzkY4/ja+mQL5aez52FDQvpfJii9AEAlSmmhtRf4EhOMZ1sXXi4/dapDhRFcLZEXv5dUeU3QCkQZGvw1LrIXhJJEZGxeybRTiTe1em5O/NdapJYgmbyWdYRFUBNgBDKpEgmN4sl8Ca19cJ++pQ5rL/xJMM92RWdRHj/vTqXaQb4DsGTeAgSO9GGfWgioUoeO3/at6TxLX1SieDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3G51G/LqyfrK23rzD9gG31n2Hhl2Bg2+awI6OK6+x0=;
 b=QuFoJnXDdFuHWxdyKUnaSZlGYwVSFg13M9DrH7mCppY0LG0yv7ENlMC3rQAh3mQJLn2pXCEl52kMQbCKmlZXA2ymPGZttJ3SR0XHuaXiuWdii10UPzBfbc9jvwsxFyVlfI6nVuSyYAYf+XQv17fNaYfHZb3FhSg/3OLrlrOEMsy2nWszbkvo7+W1PvCmfjSD/ONCObPM7dvFNnV4to436wxAjGxOL6TcfG95YXyhWSLQntslPp2mwYK0D2B4+WwF3y+80SnGz1K0BBSEHFa3IVRRIhGeAxiFJbzs8SeLgOPhIf0hhyZr5nQjmt9EiDZCgKDf72HIAjfjQzjdmKS8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3G51G/LqyfrK23rzD9gG31n2Hhl2Bg2+awI6OK6+x0=;
 b=a+li2vJActXSThTajn1FWG1GP2GYdjYisprU8ESKEZCO+gtmgnECfh7agemkeq9CBcLw7p4qFdNS3e3PvZvdrnl+tSQOz/gPJ6CrjJgD1kqf5hQUA3lPMbxsXqX7B8F1KbzWM/KUZwGCfmmCCI+Gpq0CAeQKqpRixiiMNOvtuMc=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA1PR11MB6664.namprd11.prod.outlook.com (2603:10b6:806:258::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 06:39:04 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:39:04 +0000
From: <Daniel.Machon@microchip.com>
To: <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/9] dcb: app: expose dcb-app functions in
 new header
Thread-Topic: [PATCH iproute2-next 1/9] dcb: app: expose dcb-app functions in
 new header
Thread-Index: AQHZjN0NuhMVVkH0Yky+xfKV8Y42DK9ntuwAgAFENAA=
Date: Wed, 24 May 2023 06:39:03 +0000
Message-ID: <ZG2xBsorejY7v5l1@DEN-LT-70577>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-1-83adc1f93356@microchip.com>
 <87lehf5gu1.fsf@nvidia.com>
In-Reply-To: <87lehf5gu1.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA1PR11MB6664:EE_
x-ms-office365-filtering-correlation-id: f4a349a0-e1bd-428e-03d7-08db5c2190d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QOG3UAy2LgO8k2KvfyftT4nJfSyvjjvEDYyd+qnapGx2gR7QulTsrsr9nuKMgHq1KzqmIOJtXYJuhG9u7trlg1kDlUtBdbqZGn78QPqKo6rJUtOkfp8lwrQEhMl4gUR/B0AZi+4iFdIu6LV1cRX7jG4pnXRsMkDj80J8CTZGdSLE11MTbi5if+4GAqdM9JNdMtcK8LLMv6wm34PiXg3zU18sb0QDwKDcH2/YTJm3maLMuWDdwulhDWfmmMiYOFqS8Lqppyybmw9nKI/PH9dnzKgGrYZlOjnr94TjOykC6ix/EvQ0ZWGFvZAhTQGyK9FjccAuzDcIbvq39kVv7UjSAPmSgTsE0xcqkkjJZaeDtlG3M+9Pbl/wcdOM7+donYIOvnM7Gr4dTMUzPvv95wI4ewYVbjshi98fRg0Ef9Le3huXdvi8ixGWaW4OjybpreNH85PyhDurXDkLkD9JsIRPkFGI5ka/hmvA4lNrq2S6Atmtd5nBhJNFKEvjskDdNQ67XWIQ3ZZjXGQ5pTfeMyvlz58SO0xjd0GjI/yXfoWHY/qICEPoTLjne0QD1w0Vjad/ryUCL9friTnDQRtOVGqv1h17ojOyIs4YwLR8s5GWYA5n0VlTxRGP0mwBy5rubq7n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(38100700002)(6486002)(54906003)(41300700001)(478600001)(71200400001)(316002)(91956017)(4326008)(6916009)(76116006)(86362001)(64756008)(66946007)(66556008)(66446008)(66476007)(5660300002)(38070700005)(33716001)(8936002)(8676002)(2906002)(107886003)(6506007)(26005)(6512007)(122000001)(30864003)(186003)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xzk0c9hsCaVDAxhyAUhNZ92ItyVgH67GmEzFqr117Sxoy8V4FZuB1unV2SLf?=
 =?us-ascii?Q?AYLXTK3U0BPBbKVGAhnM5rJxABd715ffexzAGZHml4LnPcrEhq7cOIXDNONw?=
 =?us-ascii?Q?0kO7FsS6ipCIV6kpybewRNYOObL9PS6jzDz/XOUOleebiJBqcu6n2m/lYK6m?=
 =?us-ascii?Q?QG58TH/3ZQqX6BrYsSloeKWTvKk0c8zT+4+jNtS4j9yKl9OOzCJqTQYvcDhc?=
 =?us-ascii?Q?rsyVZCCoXCEwJD+HB6UFaHochU1aa6RfVyhmix8dr23I3Ixj2JAj1x0k19w3?=
 =?us-ascii?Q?5+xhG06gZEXLUfG0e5FGe5B6InmHkTXYhMxtoyDDMxZJtCfL0WwtoFpui/CY?=
 =?us-ascii?Q?CVQk7ob0j+zAD7Bl2mziEkXu1ruJ1P0jIknHKVaWDtO/xNtpIh1IZCdNPMtP?=
 =?us-ascii?Q?tFdvGhsIFHbEyddfoHeEz8ie5cTEYGlXasnRc7qRiL4Bj/vyGkUjs5hvoTZ9?=
 =?us-ascii?Q?eyZr9cxvkceiJVCR04lOHpeuSLPewvGhpsLtxcimoYpNgdvfLAFsGkOPIdbE?=
 =?us-ascii?Q?DvJ268HfHPP/BTwOCmYiqkjH4aIyO24AJzVF85Xn4wAuAeKUpkBakbsAVvfF?=
 =?us-ascii?Q?jMiKQqeIwrlg5UD3v5det4Yjzw4HXj1STBUpRdMvUYCgrBa2LSVO91qw7I38?=
 =?us-ascii?Q?sE/BNBMo5mgVFJhQS0e+aZcMlzEXEa599DDD5muCX++N8Z3jLSZnn8SpA2lS?=
 =?us-ascii?Q?+M0murN2ScHahg/R5W5vg5YyHAW3SS24nV26vXIk31tI0V/WdRhlk2hdS+Ty?=
 =?us-ascii?Q?1oQl9lueS2SWSCCz5pTwHZlgZ47xYvCbqO2NGztbeXA+az+vz3R5OX2Y0kTc?=
 =?us-ascii?Q?KbJVUnVndiivLPVOlnJD8fZJ4u2nOcfPPK6P0RtJ2AaCNBcmWJ6tW8u3Jtjt?=
 =?us-ascii?Q?6hbPj7rMS1EyLPXOYYhVlouXSSUyoUEnkWNLRa5Z8xa1D7CzW6t6qBiWNVm4?=
 =?us-ascii?Q?YPx6JPhmdMmccIfiti5t4XvsBcw/UWaMhkj7h46X1AzCb3eXUE2BtfFIpJ+X?=
 =?us-ascii?Q?M6eeOifYiSfhkVL6NlOrJqMGpvphOrkCXK6/FnB5L6XTrNk1pPv3A2hEkWm1?=
 =?us-ascii?Q?BHtE3d10isoy6tRYWmsnr7t9DsBL1Jg64eajMLTq4DHVPpxx9Qg+riHw2Cvj?=
 =?us-ascii?Q?2yFYOqsNSXYxgYLkrgxWqDRluJvwyI1EBbPyMjVpFzLPGFKOYFQPLm81R4AP?=
 =?us-ascii?Q?Of36kBo/bZJX9JQtGzGX2t1fbIMzzvlqt3z5GgWfjZcQVbL9oe7ONArzuv4y?=
 =?us-ascii?Q?miE4Ps8H7u9G1tozzZ+0UgQA6fnq+TJWcafxORPOJkTpcrCZS4xtjPYsfzW+?=
 =?us-ascii?Q?Nw7xDhWZzNnyQJc1YFpN4UCxhZ/w0ossWkQDpJ1QfgSQj8Lnix5mm2dcBzDr?=
 =?us-ascii?Q?yDhQsGjisBgi8PFTRD4nkJZPBqVNBxn8VQNrYzGYC9Y0GJMXdVHYfzsq4Nmt?=
 =?us-ascii?Q?iopEPnwZi5bh+u1UrarV16uwOsUR//yTXuQ9alel2OcPKwlOIpBfNMQ5oO0j?=
 =?us-ascii?Q?DIberMBoI8FeDZcCghGCJ8e547n0aNyyfdUkIxvhoupJxb1QQxB9kbTZ+04t?=
 =?us-ascii?Q?ciMrVuMLbVCCSfWhGcJ72iYeGYvNJXhqTISiEBYZ6k8O7BUH40jW17WiCZE0?=
 =?us-ascii?Q?hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F47AEF501953440BB45C01C52598175@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a349a0-e1bd-428e-03d7-08db5c2190d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 06:39:03.6434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rDMSE3Y7ds3gFDlyX2bBohDpQI035mdB2h4/YLv7ze2DGX9S9UGJRHJrQoeg5O+8KNKoLmnU2EC2wZekYpxk++HClb+5S+1mgdte/841WNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6664
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Add new headerfile dcb-app.h that exposes the functions required later
> > by dcb-rewr. The new dcb-rewr implementation will reuse much of the
> > existing dcb-app code.
> >
> > I thought this called for a separate header file, instead of polluting
> > the existing dcb.h file.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  dcb/dcb.h     |  9 ++-------
> >  dcb/dcb_app.c | 54 ++++++++++++++++++---------------------------------=
---
> >  dcb/dcb_app.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
> >  3 files changed, 75 insertions(+), 43 deletions(-)
> >
> > diff --git a/dcb/dcb.h b/dcb/dcb.h
> > index d40664f29dad..4c8a4aa25e0c 100644
> > --- a/dcb/dcb.h
> > +++ b/dcb/dcb.h
> > @@ -6,6 +6,8 @@
> >  #include <stdbool.h>
> >  #include <stddef.h>
> >
> > +#include "dcb_app.h"
> > +
> >  /* dcb.c */
> >
> >  struct dcb {
> > @@ -54,13 +56,6 @@ void dcb_print_array_on_off(const __u8 *array, size_=
t size);
> >  void dcb_print_array_kw(const __u8 *array, size_t array_size,
> >                       const char *const kw[], size_t kw_size);
> >
> > -/* dcb_app.c */
> > -
> > -int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> > -enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> > -bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> > -bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector=
);
> > -
>=20
> Why the move to a dedicated header? dcb.h ends up being the only client
> and everybody consumes the prototypes through that file anyway. I don't
> fine it necessary.

I did try to rationalize that a bit in the commit description. I thought
the amount of exposed app functions ended up polutting the dcb header.
Maybe it is not that bad - can move them back in the next v.

>=20
> >  /* dcb_apptrust.c */
> >
> >  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> > diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> > index eeb78e70f63f..df339babd8e6 100644
> > --- a/dcb/dcb_app.c
> > +++ b/dcb/dcb_app.c
> > @@ -10,8 +10,6 @@
> >  #include "utils.h"
> >  #include "rt_names.h"
> >
> > -#define DCB_APP_PCP_MAX 15
> > -
> >  static const char *const pcp_names[DCB_APP_PCP_MAX + 1] =3D {
> >       "0nd", "1nd", "2nd", "3nd", "4nd", "5nd", "6nd", "7nd",
> >       "0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
> > @@ -22,6 +20,7 @@ static const char *const ieee_attrs_app_names[__DCB_A=
TTR_IEEE_APP_MAX] =3D {
> >       [DCB_ATTR_DCB_APP] =3D "DCB_ATTR_DCB_APP"
> >  };
> >
> > +
>=20
> This looks like a leftover.
>=20
> >  static void dcb_app_help_add(void)
> >  {
> >       fprintf(stderr,
> > @@ -68,11 +67,6 @@ static void dcb_app_help(void)
> >       dcb_app_help_add();
> >  }
> >
> > -struct dcb_app_table {
> > -     struct dcb_app *apps;
> > -     size_t n_apps;
> > -};
> > -
> >  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
> >  {
> >       switch (selector) {
> > @@ -105,7 +99,7 @@ bool dcb_app_selector_validate(enum ieee_attrs_app t=
ype, __u8 selector)
> >       return dcb_app_attr_type_get(selector) =3D=3D type;
> >  }
> >
> > -static void dcb_app_table_fini(struct dcb_app_table *tab)
> > +void dcb_app_table_fini(struct dcb_app_table *tab)
> >  {
> >       free(tab->apps);
> >  }
> > @@ -124,8 +118,8 @@ static int dcb_app_table_push(struct dcb_app_table =
*tab, struct dcb_app *app)
> >       return 0;
> >  }
> >
> > -static void dcb_app_table_remove_existing(struct dcb_app_table *a,
> > -                                       const struct dcb_app_table *b)
> > +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b)
> >  {
> >       size_t ia, ja;
> >       size_t ib;
> > @@ -152,8 +146,8 @@ static void dcb_app_table_remove_existing(struct dc=
b_app_table *a,
> >       a->n_apps =3D ja;
> >  }
> >
> > -static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> > -                                       const struct dcb_app_table *b)
> > +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b)
> >  {
> >       size_t ia, ja;
> >       size_t ib;
> > @@ -189,8 +183,7 @@ static void dcb_app_table_remove_replaced(struct dc=
b_app_table *a,
> >       a->n_apps =3D ja;
> >  }
> >
> > -static int dcb_app_table_copy(struct dcb_app_table *a,
> > -                           const struct dcb_app_table *b)
> > +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_t=
able *b)
> >  {
> >       size_t i;
> >       int ret;
> > @@ -217,18 +210,12 @@ static int dcb_app_cmp_cb(const void *a, const vo=
id *b)
> >       return dcb_app_cmp(a, b);
> >  }
> >
> > -static void dcb_app_table_sort(struct dcb_app_table *tab)
> > +void dcb_app_table_sort(struct dcb_app_table *tab)
> >  {
> >       qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb)=
;
> >  }
> >
> > -struct dcb_app_parse_mapping {
> > -     __u8 selector;
> > -     struct dcb_app_table *tab;
> > -     int err;
> > -};
> > -
> > -static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *dat=
a)
> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> >  {
> >       struct dcb_app_parse_mapping *pm =3D data;
> >       struct dcb_app app =3D {
> > @@ -260,7 +247,7 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32=
 key, char *value, void *data
> >                                dcb_app_parse_mapping_cb, data);
> >  }
> >
> > -static int dcb_app_parse_pcp(__u32 *key, const char *arg)
> > +int dcb_app_parse_pcp(__u32 *key, const char *arg)
> >  {
> >       int i;
> >
> > @@ -286,7 +273,7 @@ static int dcb_app_parse_mapping_pcp_prio(__u32 key=
, char *value, void *data)
> >                                dcb_app_parse_mapping_cb, data);
> >  }
> >
> > -static int dcb_app_parse_dscp(__u32 *key, const char *arg)
> > +int dcb_app_parse_dscp(__u32 *key, const char *arg)
> >  {
> >       if (parse_mapping_num_all(key, arg) =3D=3D 0)
> >               return 0;
> > @@ -377,12 +364,12 @@ static bool dcb_app_is_default(const struct dcb_a=
pp *app)
> >              app->protocol =3D=3D 0;
> >  }
> >
> > -static bool dcb_app_is_dscp(const struct dcb_app *app)
> > +bool dcb_app_is_dscp(const struct dcb_app *app)
> >  {
> >       return app->selector =3D=3D IEEE_8021QAZ_APP_SEL_DSCP;
> >  }
> >
> > -static bool dcb_app_is_pcp(const struct dcb_app *app)
> > +bool dcb_app_is_pcp(const struct dcb_app *app)
> >  {
> >       return app->selector =3D=3D DCB_APP_SEL_PCP;
> >  }
> > @@ -402,7 +389,7 @@ static bool dcb_app_is_port(const struct dcb_app *a=
pp)
> >       return app->selector =3D=3D IEEE_8021QAZ_APP_SEL_ANY;
> >  }
> >
> > -static int dcb_app_print_key_dec(__u16 protocol)
> > +int dcb_app_print_key_dec(__u16 protocol)
> >  {
> >       return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> >  }
> > @@ -412,7 +399,7 @@ static int dcb_app_print_key_hex(__u16 protocol)
> >       return print_uint(PRINT_ANY, NULL, "%x:", protocol);
> >  }
> >
> > -static int dcb_app_print_key_dscp(__u16 protocol)
> > +int dcb_app_print_key_dscp(__u16 protocol)
> >  {
> >       const char *name =3D rtnl_dsfield_get_name(protocol << 2);
> >
> > @@ -422,7 +409,7 @@ static int dcb_app_print_key_dscp(__u16 protocol)
> >       return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> >  }
> >
> > -static int dcb_app_print_key_pcp(__u16 protocol)
> > +int dcb_app_print_key_pcp(__u16 protocol)
> >  {
> >       /* Print in numerical form, if protocol value is out-of-range */
> >       if (protocol > DCB_APP_PCP_MAX)
> > @@ -577,7 +564,7 @@ static int dcb_app_get_table_attr_cb(const struct n=
lattr *attr, void *data)
> >       return MNL_CB_OK;
> >  }
> >
> > -static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_ap=
p_table *tab)
> > +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table=
 *tab)
> >  {
> >       uint16_t payload_len;
> >       void *payload;
> > @@ -594,11 +581,6 @@ static int dcb_app_get(struct dcb *dcb, const char=
 *dev, struct dcb_app_table *t
> >       return 0;
> >  }
> >
> > -struct dcb_app_add_del {
> > -     const struct dcb_app_table *tab;
> > -     bool (*filter)(const struct dcb_app *app);
> > -};
> > -
>=20
> This structure is a protocol between dcb_app_add_del() and
> dcb_app_add_del_cb(). I don't think your patchset uses it elsewhere, so
> it can be kept private.

Yep. You are right.

>=20
> >  static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, v=
oid *data)
> >  {
> >       struct dcb_app_add_del *add_del =3D data;
> > @@ -620,7 +602,7 @@ static int dcb_app_add_del_cb(struct dcb *dcb, stru=
ct nlmsghdr *nlh, void *data)
> >       return 0;
> >  }
> >
> > -static int dcb_app_add_del(struct dcb *dcb, const char *dev, int comma=
nd,
> > +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> >                          const struct dcb_app_table *tab,
> >                          bool (*filter)(const struct dcb_app *))
>=20
> This has wrong indentation.

Ouch. Will fix in next v.

>=20
> >  {
> > diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
> > new file mode 100644
> > index 000000000000..8e7b010dcf75
> > --- /dev/null
> > +++ b/dcb/dcb_app.h
> > @@ -0,0 +1,55 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __DCB_APP_H_
> > +#define __DCB_APP_H_
> > +
> > +struct dcb;
> > +
> > +struct dcb_app_table {
> > +     struct dcb_app *apps;
> > +     size_t n_apps;
> > +};
> > +
> > +struct dcb_app_add_del {
> > +     const struct dcb_app_table *tab;
> > +     bool (*filter)(const struct dcb_app *app);
> > +};
> > +
> > +struct dcb_app_parse_mapping {
> > +     __u8 selector;
> > +     struct dcb_app_table *tab;
> > +     int err;
> > +};
> > +
> > +#define DCB_APP_PCP_MAX 15
> > +
> > +int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> > +
> > +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table=
 *tab);
> > +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> > +                 const struct dcb_app_table *tab,
> > +                 bool (*filter)(const struct dcb_app *));
> > +
> > +void dcb_app_table_sort(struct dcb_app_table *tab);
> > +void dcb_app_table_fini(struct dcb_app_table *tab);
> > +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_t=
able *b);
> > +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b);
> > +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b);
> > +
> > +bool dcb_app_is_pcp(const struct dcb_app *app);
> > +bool dcb_app_is_dscp(const struct dcb_app *app);
> > +
> > +int dcb_app_print_key_dec(__u16 protocol);
> > +int dcb_app_print_key_dscp(__u16 protocol);
> > +int dcb_app_print_key_pcp(__u16 protocol);
> > +
> > +int dcb_app_parse_pcp(__u32 *key, const char *arg);
> > +int dcb_app_parse_dscp(__u32 *key, const char *arg);
> > +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
> > +
> > +bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector=
);
> > +bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> > +enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> > +
> > +#endif
> =

