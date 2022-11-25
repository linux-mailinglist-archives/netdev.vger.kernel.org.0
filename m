Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7276385E7
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiKYJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYJLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:11:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3F32A72D
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669367479; x=1700903479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3U9kCQKc+VPjZAltcH9kQL3FNpOROpU5Xuk1Lj20r6I=;
  b=UU0XWOLxmEOdXcgXQkOgmP7R2yi69b7zeVjPm660VWvRDAw3MLEpDtx/
   JaXJwTqPDFwSa5I83mjnP4jZ/oJW++3xQn6QhK6Qzb4c4S3YZFmOOnkZi
   EhcdsbEzEwMI+3HCx+kSY+ex/b+r6JxYSlf1xApeUS91kr8befHYXn/Ck
   Guv4kKdeYvjK2PLvf8+R1eGmBy9676Lyc11KEJbjCUmoKYiDXiMa8csiJ
   xWTr2vtRCk9hRP7y397od4D6hwJS2kkCgePDfr0UvopmXvSaZIbCxe9Qz
   OH/jAD8e7K4wxkd2wP4L1oCkWxdvy/W+r+IUDHfVX3tTXji6/vBfvJa9I
   A==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="190490616"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:11:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:11:17 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 25 Nov 2022 02:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLJX/g4rvKTFrg3DJ8pt3fmBlB8oXPp3nRWSYGQhuWJQ5Arj8OP2U/CL1j9j0Cj7T5jL2eeAnxLNTLcDdJFWsULyxIZsa+GWPqpQt76UGityYSD5n+M/nyVqgiscFTJOCBNRqyTlnXdXt5SOJ/3WJ8shcYuKmVGUBC4jqgXfOP7pVdBRkqMENr1QesWjlgL0XSv4V6p2RqAnuDnt8Hm4y5SZCR875YqI5pOwdmCSVMPC/HiipWiFa6KYar8QCPkTO41bjJAnybTnxZlNk0D7ovelZfIaPSug9yOTzLDxeqR7KGsl+rEqIX9y4loJ6KDL/hPh7KVd+YVjyS+B9RpOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnLEJt9BAWLeFzqISp/WtyK9z3z7TJXOzLDSd/BMczA=;
 b=XAskcyXDcn3ULi4mHenR1LASpL65GKQv6rDdFzMGVAZCpzqef+7Mt/ucyE2Fuax0oytVroQqUpH5Vj6IdjtAZXe53oEmHqyueDfwNZ8iSk/c5fNvGNloKopg1vioYyT+gtFZAfzzaAIDv+mXj4KVQxRwNFuQ/vPiE+7rj6GfVcQbiuE0ChbGgmSz+alADqNQVT6C5ypxi6kwFv6uBZujb/hbLCVG64ZQuuJHpNcL5cFod3QgZ3S/5Q2NL4rrJ+rWR9E7gQTzwURkZADnfyTxUDP9E1/yC8W785vBEMvnbO548JfqbCQqgZKzXJW3UvmDSh9hhIEm5IcneByAD1CsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnLEJt9BAWLeFzqISp/WtyK9z3z7TJXOzLDSd/BMczA=;
 b=o0mFOUSUmia4leyCwnq+N74a5siPOu99lGUEKvUVw+Tl5EPVWx4Z9RfMe6q0Mc5CfxdOxUXwKqM/WG9wqWIpeaqWopaiPsYTY7OcYWLm1sFicMXpfwsNjjETlV6R8BwEMq7dtGMPIJKBFJOr+83OvP/3tzjUHBEnHSl7Tdctsuo=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DM6PR11MB4708.namprd11.prod.outlook.com (2603:10b6:5:28f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Fri, 25 Nov
 2022 09:11:14 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 09:11:14 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 2/2] dcb: add new subcommand for apptrust
Thread-Topic: [PATCH iproute2-next 2/2] dcb: add new subcommand for apptrust
Thread-Index: AQHY/l2BquWuyhngw0Gbhq/qFYdQ+65OQ4QAgAEepoA=
Date:   Fri, 25 Nov 2022 09:11:14 +0000
Message-ID: <Y4CJWeNMMacAwHiL@DEN-LT-70577>
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-3-daniel.machon@microchip.com>
 <87o7swi9ay.fsf@nvidia.com>
In-Reply-To: <87o7swi9ay.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DM6PR11MB4708:EE_
x-ms-office365-filtering-correlation-id: 54f4da65-c8a1-4416-1e5d-08dacec500f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pvk6sTHjPl3CBukAdAZ3ZVzcpBHkJMbwMRFwuvZzB1KLn009Dt1ows6r7bJIP2U1Y2iBlukL2n2U7ymnlPB0HphNdxJNnqgLiYo9hIXYwhTFhaoROIs2BMA9y9Vw9J7yaXbOyWEmQfzRaey6A/lLn0fl9Pd+EeYZcUCkVn9RonTqB8d1eQqVZZyZkD6hnnJTynZsnOZe+MW7dbx2dnreMvYO292a1QAEKmejd9EFL47dLDZUDJqs3hJROluoBFM4d4LJvK8bIXz3ZuA0P5p9HfbqXXpCOYYWDgDYualMJLh9gAPVPZu0NASGEYAISuFCwycWtGgElHV99CTXc0T01AGbp73yVjTbO1dsjXtPmIbxpyIUaZaG3IuxdJSXDL7LSyijsYZ7BF9DkRQ9Zb5PEWbQULYPpulXuV59mWgZAVMx4/LQuIpilG0jcWZIQSmz9+E76aodcHKQAOocy704VVHwxUzH6FtiHeR5OpEO7O4DF6R+VpxFLVh3l5XxsM8/UVyiwul3FHjWPldXTarTbj5pTsK+MaoN0EvMK+SCfMl03F5MYux06XD7QG6gGPFZYke1k7J6681cVslAIJml0hdZIU2Sqd8FVTXc4sT5qOTyro6DeusIhAO7jKx+VhKwt9W0DrxgfEKgSIGGVMWeBH/+3+JEXrtwdY9dQRuzx5ZD88zyzfCPATEHXVWjFnNQHtib6PpaSM3/t5VzFUgQuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(33716001)(83380400001)(6916009)(107886003)(54906003)(6506007)(71200400001)(6486002)(86362001)(38070700005)(6512007)(9686003)(38100700002)(122000001)(186003)(30864003)(41300700001)(8936002)(5660300002)(26005)(478600001)(66556008)(4326008)(8676002)(91956017)(64756008)(66946007)(66476007)(2906002)(76116006)(66446008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?19y79Y7UcSkvA0PwLd0J7FyCTMD/9DinEWPuD6jfAaejJmPlHJ25Baq0KHq6?=
 =?us-ascii?Q?KyM/WcVkx2rcZWQ2N80QF1/fuA14dUQPqTQSZDQF8wI4NSV9Q+FHZzNi6NJz?=
 =?us-ascii?Q?VWFt0TZcfwpAldP7l5qHA1L+eh+SkZZwhrH6aXoBuMYOSLPlIJKbAxdZ4cnW?=
 =?us-ascii?Q?tDRWpee1lLuSvWGqHjUsgAodoRNCpo74vLxYtE3MwcyD3cYAGYzpq4yevxi3?=
 =?us-ascii?Q?zyDocaCl87lm0oXO/P/Ybl5TiWlnks+9cYJ4Jp6GM/IwAOUVDCLM0M0OoslK?=
 =?us-ascii?Q?qTbI6VFpADsFeDnPChkFpjfdYWdJsR4XanH8wR1YwxWXOzOtM1qT2l0M9s2F?=
 =?us-ascii?Q?m+0npQT0sUvlXNwgmu66vcetSWZT5aK1M2p2penY57ZTsz7s8c9g2VQEHBje?=
 =?us-ascii?Q?r0Ux9OXJWgSfv4MRzlWU69hQU371t1cCLNmddIKPkiM3bKtjBB1kcAINadua?=
 =?us-ascii?Q?yWfdRTKSLwjlFuXXQAPBER6ateBE8wQlkwwrO1csYSJJ3LuQHr6st/T21cxn?=
 =?us-ascii?Q?m7OruVRbs9Q0nDd62V9Yea5vGDwwrCX6e8f3z02BlTa9oZABMfPOo+rzZ3kj?=
 =?us-ascii?Q?yreMJNrR6TbhiSMUzb18EwdjfbCojRzmmwBVbQiDW9XHk6AhpEydRLMp245k?=
 =?us-ascii?Q?r1rXXsB3eCiOoXGwIbpIVk951mkGT2eMgvdHMYDNSU79jMebqLhpodbHFIOz?=
 =?us-ascii?Q?OpNBF4aY/9z6Gy5Vizppif1CJB5dTp8rHBso9MC6fJZa8kulfkCCgNhixCSt?=
 =?us-ascii?Q?tfEjOChnxhEMvARJMpm93vFalEU7L/GKCnRymjdQKhXeHa9I6qDsg5oIO/mL?=
 =?us-ascii?Q?7oceRIAXvRjoFG1YUps6mlcuqBspDspIWoMYNH1fLDC47LWbaZAZHr/0CyuP?=
 =?us-ascii?Q?iJq+XlkhAbf4oWp4EFP3zHWRn+lxaKMxRmAOmYHnOZdz2EBk83jeJ2uL5mdX?=
 =?us-ascii?Q?rhrVEHdKFHhhZwXjj5xUFZ9PclbdbyNVnqo3SZQ0dPrGSLAeP2vDfox5SHpn?=
 =?us-ascii?Q?+boF/oscnh62j4U8VgerbMQjwHD/L3HnFLec2XKJbeAqhpWjH9OpHsBKDdDs?=
 =?us-ascii?Q?cLcMbH5hSlAZabjv6pc+pYuZ0kJVF8QAEKplaLAnZ2v07QAJPDT7mpiGB8vR?=
 =?us-ascii?Q?Xwekuw6eA10JYIM1wpRUKw4rk2n2QyRMzResKn3WQecD0N0calpP+ZSH/A0R?=
 =?us-ascii?Q?v26LeYbcqV/29Xl/0WDHYcROweCu3jHoGA9uCQy+Q9zCJFi8rDbBgXQD09DB?=
 =?us-ascii?Q?YFjljv7Lkco2P7SIoOmy6e5jCyL5eOBkgLDfqaFWcsGgvk8i9oCjqHlDpOht?=
 =?us-ascii?Q?GKHqmBxxmPyb9YJVYjexExFv1vljgemHN4C3BgvXv5LmfsZzbrsOIP6/Cv1u?=
 =?us-ascii?Q?pJ4U5vhLYMW/df45kbC5/nCfDDW/TBjTYae7HqHW2fUjtJk9C5ayIH9JjQ5w?=
 =?us-ascii?Q?NY5LQ6ITmXhNx8Q3spiDrd5DVJDPUct/CcFon8N5tasNcRh0UJ86N6/Duac+?=
 =?us-ascii?Q?wT4FNKnjoCT/8Bz5OJgL1DDN9M64KhBaG2O9KuVGgElkqaFNcTUG4eQ/2cb0?=
 =?us-ascii?Q?Brk25Yn+UYnT1dZgFvjvmDmt69y4ZIqZKn6pIbq1F4hh7VOoVx63WhKfSMbQ?=
 =?us-ascii?Q?pchLZBPfVYnJm4/QsP3EZis=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8E5727E600B7C4C8FE7BCF8453984A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f4da65-c8a1-4416-1e5d-08dacec500f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 09:11:14.6068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMhG21V/uESqsriW7o8VIi08g6ztC6c8q9xZJOUnrDuqjQggK7z9tiqhrwZ8UXuZAqOEE4dkfBTW+4V05evje+odDGm3yuErZO188reVR8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4708
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As always, thank you for the feedback - much appreciated!

> > diff --git a/dcb/dcb_apptrust.c b/dcb/dcb_apptrust.c
> > new file mode 100644
> > index 000000000000..14d18dcb7f83
> > --- /dev/null
> > +++ b/dcb/dcb_apptrust.c
> > @@ -0,0 +1,291 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include <errno.h>
> > +#include <linux/dcbnl.h>
> > +
> > +#include "dcb.h"
> > +#include "utils.h"
> > +
> > +static void dcb_apptrust_help_set(void)
> > +{
> > +     fprintf(stderr,
> > +             "Usage: dcb apptrust set dev STRING\n"
> > +             "       [ order [ eth | stream | dgram | any | dscp | pcp=
 ] ]\n"
> > +             "\n");
> > +}
> > +
> > +static void dcb_apptrust_help_show(void)
> > +{
> > +     fprintf(stderr, "Usage: dcb [ -i ] apptrust show dev STRING\n"
> > +                     "           [ order ]\n"
> > +                     "\n");
> > +}
> > +
> > +static void dcb_apptrust_help(void)
> > +{
> > +     fprintf(stderr, "Usage: dcb apptrust help\n"
> > +                     "\n");
> > +     dcb_apptrust_help_show();
> > +     dcb_apptrust_help_set();
> > +}
> > +
> > +static const char *const selector_names[] =3D {
> > +     [IEEE_8021QAZ_APP_SEL_ETHERTYPE] =3D "eth",
> > +     [IEEE_8021QAZ_APP_SEL_STREAM]    =3D "stream",
> > +     [IEEE_8021QAZ_APP_SEL_DGRAM]     =3D "dgram",
> > +     [IEEE_8021QAZ_APP_SEL_ANY]       =3D "any",
> > +     [IEEE_8021QAZ_APP_SEL_DSCP]      =3D "dscp",
> > +     [DCB_APP_SEL_PCP]                =3D "pcp",
> > +};
>=20
> These names should match how dcb-app names them. So ethtype,
> stream-port, dgram-port, port, dscp, pcp.

My intention was to match the selector names from the uapi header, and
not the dcb-app names (except "eth" should actually have been
"ethertype"). Afterall, we are specifying selector trust. But then
again, the user does not know about selector names, only what is visible
through dcb-app help() and the dcb-app man page. I guess you are right :)

>=20
> > +
> > +struct dcb_apptrust_table {
> > +     __u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1];
> > +     int nselectors;
> > +};
> > +
> > +static bool dcb_apptrust_contains(const struct dcb_apptrust_table *tab=
le,
> > +                               __u8 selector)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < table->nselectors; i++)
> > +             if (table->selectors[i] =3D=3D selector)
> > +                     return true;
> > +
> > +     return false;
> > +}
> > +
> > +static void dcb_apptrust_print(const struct dcb_apptrust_table *table)
> > +{
> > +     const char *str;
> > +     __u8 selector;
> > +     int i;
> > +
> > +     open_json_array(PRINT_JSON, "order");
> > +     print_string(PRINT_FP, NULL, "order: ", NULL);
> > +
> > +     for (i =3D 0; i < table->nselectors; i++) {
> > +             selector =3D table->selectors[i];
> > +             str =3D selector_names[selector];
> > +             print_string(PRINT_ANY, NULL, "%s ", str);
> > +     }
> > +     print_nl();
> > +
> > +     close_json_array(PRINT_JSON, "order");
> > +}
> > +
> > +static int dcb_apptrust_get_cb(const struct nlattr *attr, void *data)
> > +{
> > +     struct dcb_apptrust_table *table =3D data;
> > +     uint16_t type;
> > +     __u8 selector;
> > +
> > +     type =3D mnl_attr_get_type(attr);
> > +
> > +     if (!dcb_app_attr_type_validate(type)) {
> > +             fprintf(stderr,
> > +                     "Unknown attribute in DCB_ATTR_IEEE_APP_TRUST_TAB=
LE: %d\n",
> > +                     type);
> > +             return MNL_CB_OK;
> > +     }
> > +
> > +     if (mnl_attr_get_payload_len(attr) < 1) {
> > +             fprintf(stderr,
> > +                     "DCB_ATTR_IEEE_APP_TRUST payload expected to have=
 size %zd, not %d\n",
> > +                     sizeof(struct dcb_app), mnl_attr_get_payload_len(=
attr));
> > +             return MNL_CB_OK;
> > +     }
> > +
> > +     selector =3D mnl_attr_get_u8(attr);
> > +
> > +     /* Check that selector is encapsulated in the right attribute */
> > +     if (!dcb_app_selector_validate(type, selector)) {
> > +             fprintf(stderr, "Wrong type for selector: %s\n",
> > +                     selector_names[selector]);
> > +             return MNL_CB_OK;
> > +     }
> > +
> > +     table->selectors[table->nselectors++] =3D selector;
> > +
> > +     return MNL_CB_OK;
> > +}
> > +
> > +static int dcb_apptrust_get(struct dcb *dcb, const char *dev,
> > +                         struct dcb_apptrust_table *table)
> > +{
> > +     uint16_t payload_len;
> > +     void *payload;
> > +     int ret;
> > +
> > +     ret =3D dcb_get_attribute_va(dcb, dev, DCB_ATTR_DCB_APP_TRUST_TAB=
LE,
> > +                                &payload, &payload_len);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     ret =3D mnl_attr_parse_payload(payload, payload_len, dcb_apptrust=
_get_cb,
> > +                                  table);
> > +     if (ret !=3D MNL_CB_OK)
> > +             return -EINVAL;
> > +
> > +     return 0;
> > +}
> > +
> > +static int dcb_apptrust_set_cb(struct dcb *dcb, struct nlmsghdr *nlh,
> > +                            void *data)
> > +{
> > +     const struct dcb_apptrust_table *table =3D data;
> > +     enum ieee_attrs_app type;
> > +     struct nlattr *nest;
> > +     int i;
> > +
> > +     nest =3D mnl_attr_nest_start(nlh, DCB_ATTR_DCB_APP_TRUST_TABLE);
> > +
> > +     for (i =3D 0; i < table->nselectors; i++) {
> > +             type =3D dcb_app_attr_type_get(table->selectors[i]);
> > +             mnl_attr_put_u8(nlh, type, table->selectors[i]);
> > +     }
> > +
> > +     mnl_attr_nest_end(nlh, nest);
> > +
> > +     return 0;
> > +}
> > +
> > +static int dcb_apptrust_set(struct dcb *dcb, const char *dev,
> > +                         const struct dcb_apptrust_table *table)
> > +{
> > +     return dcb_set_attribute_va(dcb, DCB_CMD_IEEE_SET, dev,
> > +                                 &dcb_apptrust_set_cb, (void *)table);
> > +}
> > +
> > +static int dcb_apptrust_parse_selector_list(int *argcp, char ***argvp,
> > +                                         struct dcb_apptrust_table *ta=
ble)
> > +{
> > +     char **argv =3D *argvp;
> > +     int argc =3D *argcp;
> > +     __u8 selector;
> > +     int ret;
> > +
> > +     NEXT_ARG_FWD();
> > +
> > +     /* No trusted selectors ? */
> > +     if (argc =3D=3D 0)
> > +             goto out;
> > +
> > +     while (argc > 0) {
> > +             selector =3D parse_one_of("order", *argv, selector_names,
> > +                                     ARRAY_SIZE(selector_names), &ret)=
;
> > +             if (ret < 0)
> > +                     return -EINVAL;
>=20
> I think this should legitimately conclude the parsing, because it could
> be one of the higher-level keywords. Currently there's only one,
> "order", but nonetheless. I think it should goto out, and be plonked by
> the caller with "what is X?". Similar to how the first argument that
> doesn't parse as e.g. DSCP:PRIO bails out and is attempted as a keyword
> higher up, and either parsed, or plonked with "what is X".

I dont quite follow you on this one. We are parsing the selector list
here. Any offending selector is printed, as well as the entire list of
valid ones. How could it be one of the higher-level keywords? Am I
missing something here? :-)

>=20
> > +
> > +             if (table->nselectors > IEEE_8021QAZ_APP_SEL_MAX)
>=20
> Yeah, this is purely theoretical, so no need for a message.
>=20
> > +                     return -ERANGE;
> > +
> > +             if (dcb_apptrust_contains(table, selector)) {
> > +                     fprintf(stderr, "Duplicate selector: %s\n",
> > +                             selector_names[selector]);
> > +                     return -EINVAL;
> > +             }
> > +
> > +             table->selectors[table->nselectors++] =3D selector;
> > +
> > +             NEXT_ARG_FWD();
> > +     }
> > +
> > +out:
> > +     *argcp =3D argc;
> > +     *argvp =3D argv;
> > +
> > +     return 0;
> > +}
> > +
> > +static int dcb_cmd_apptrust_set(struct dcb *dcb, const char *dev, int =
argc,
> > +                             char **argv)
> > +{
> > +     struct dcb_apptrust_table table =3D { 0 };
> > +     int ret;
> > +
> > +     if (!argc) {
> > +             dcb_apptrust_help_set();
> > +             return 0;
> > +     }
> > +
> > +     do {
> > +             if (strcmp(*argv, "help") =3D=3D 0) {
> > +                     dcb_apptrust_help_set();
> > +                     return 0;
> > +             } else if (strcmp(*argv, "order") =3D=3D 0) {
> > +                     ret =3D dcb_apptrust_parse_selector_list(&argc, &=
argv,
> > +                                                            &table);
> > +                     if (ret < 0) {
> > +                             fprintf(stderr, "Invalid list of selector=
s\n");
> > +                             return -EINVAL;
> > +                     }
> > +                     continue;
> > +             } else {
> > +                     fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +                     dcb_apptrust_help_set();
> > +                     return -EINVAL;
> > +             }
> > +
> > +             NEXT_ARG_FWD();
> > +     } while (argc > 0);
> > +
> > +     return dcb_apptrust_set(dcb, dev, &table);
> > +}
> > +
> > +static int dcb_cmd_apptrust_show(struct dcb *dcb, const char *dev, int=
 argc,
> > +                              char **argv)
> > +{
> > +     struct dcb_apptrust_table table =3D { 0 };
> > +     int ret;
> > +
> > +     ret =3D dcb_apptrust_get(dcb, dev, &table);
> > +     if (ret)
> > +             return ret;
> > +
> > +     open_json_object(NULL);
> > +
> > +     if (!argc) {
> > +             dcb_apptrust_help();
>=20
> Given no arguments to show, the tool should show everything, not help.

Ahh. Yes. Will fix that.

>=20
> > +             goto out;
> > +     }
> > +
> > +     do {
> > +             if (strcmp(*argv, "help") =3D=3D 0) {
> > +                     dcb_apptrust_help_show();
> > +                     return 0;
> > +             } else if (strcmp(*argv, "order") =3D=3D 0) {
> > +                     dcb_apptrust_print(&table);
>=20
> This should probably be dcb_apptrust_print_order, so that more stuff can
> be added cleanly.
>=20
> > +             } else {
> > +                     fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +                     dcb_apptrust_help_show();
> > +                     return -EINVAL;
> > +             }
> > +
> > +             NEXT_ARG_FWD();
> > +     } while (argc > 0);
> > +
> > +out:
> > +     close_json_object();
> > +     return 0;
> > +}
> > +
> > +int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv)
> > +{
> > +     if (!argc || strcmp(*argv, "help") =3D=3D 0) {
> > +             dcb_apptrust_help();
> > +             return 0;
> > +     } else if (strcmp(*argv, "show") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrus=
t_show,
> > +                                      dcb_apptrust_help_show);
> > +     } else if (strcmp(*argv, "set") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrus=
t_set,
> > +                                      dcb_apptrust_help_set);
> > +     } else {
> > +             fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +             dcb_apptrust_help();
> > +             return -EINVAL;
> > +     }
> > +}
> > diff --git a/man/man8/dcb-apptrust.8 b/man/man8/dcb-apptrust.8
> > new file mode 100644
> > index 000000000000..9ebe7c17292c
> > --- /dev/null
> > +++ b/man/man8/dcb-apptrust.8
> > @@ -0,0 +1,118 @@
> > +.TH DCB-APPTRUST 8 "22 November 2022" "iproute2" "Linux"
> > +.SH NAME
> > +dcb-apptrust \- show / manipulate per-selector trust and trust order o=
f the application
> > +priority table of the DCB (Data Center Bridging) subsystem.
> > +.SH SYNOPSIS
> > +.sp
> > +.ad l
> > +.in +8
> > +
> > +.ti -8
> > +.B dcb
> > +.RI "[ " OPTIONS " ] "
> > +.B apptrust
> > +.RI "{ " COMMAND " | " help " }"
> > +.sp
> > +
> > +.ti -8
> > +.B dcb apptrust show dev order
> > +.RI DEV
> > +
> > +.ti -8
> > +.B dcb apptrust set dev order
> > +.RI DEV
> > +.RB "[ " eth " ]"
> > +.RB "[ " stream " ]"
> > +.RB "[ " dgram " ]"
> > +.RB "[ " any " ]"
> > +.RB "[ " dscp " ]"
> > +.RB "[ " pcp " ]"
>=20
> Taken literally, this prescribes the order, just allows omitting some of
> the selectors. I think you'll need to circumscribe like this:
>=20
>     dcb apptrust set dev order [ SEL-LIST ]
>     SEL-LIST :=3D [ SEL-LIST ] SEL
>     SEL :=3D { ethtype | stream-port | etc. etc. }
>=20

Ack. Will be fixed.

> > +.SH DESCRIPTION
> > +
> > +.B dcb apptrust
> > +is used to configure and manipulate per-selector trust and trust order=
 of the
> > +Application Priority Table, see
> > +.BR dcb-app (8)
> > +for details on how to configure app table entries.
> > +
> > +Selector trust can be used by the
> > +software stack, or drivers (most likely the latter), when querying the=
 APP
> > +table, to determine if an APP entry should take effect, or not. Additi=
onaly, the
> > +order of the trusted selectors will dictate which selector should take
> > +precedence, in the case of multiple different APP selectors being pres=
ent in the
> > +APP table.
> > +
> > +.SH COMMANDS
> > +
> > +.TP
> > +.B show
> > +Display all trusted selectors.
> > +
> > +.TP
> > +.B set
> > +Set new list of trusted selectors. Empty list is effectively the same =
as
> > +removing trust entirely.
> > +
> > +.SH PARAMETERS
> > +
> > +The following describes only the write direction, i.e. as used with th=
e
> > +\fBset\fR command. For the \fBshow\fR command, the parameter name is t=
o be used
> > +as a simple keyword without further arguments. This instructs the tool=
 to show
> > +the values of a given parameter.
> > +
> > +.TP
> > +.B order \fISELECTOR-NAMES
> > +\fISELECTOR-NAMES\fR is a space-separated list of selector names:\fR
> > +
> > +.B eth
> > +Trust EtherType.
> > +
> > +.B stream
> > +Trust TCP, or Stream Control Transmission Protocol (SCTP).
> > +
> > +.B dgram
> > +Trust UDP, or Datagram Congestion Control Protocol (DCCP).
> > +
> > +.B any
> > +Trust TCP, SCTP, UDP, or DCCP.
> > +
> > +.B dscp
> > +Trust Differentiated Services Code Point (DSCP) values.
> > +
> > +.B pcp
> > +Trust Priority Code Point/Drop Eligible Indicator (PCP/DEI).
>=20
> These names need to be updated as well.

Ack. Will be fixed.

/ Daniel =
