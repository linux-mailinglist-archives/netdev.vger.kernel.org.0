Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650064259F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiLEJTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiLEJTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:19:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC3113D4D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670231956; x=1701767956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=02DzCcD45zDpFkQo+18EFs9gmC3EpKCe08gBIeW1JQw=;
  b=S/aMD/iCRwoUnjJtgmiJEolw2WWYb8YDOGwxLWkbPEEhvqFsXzvvpOYt
   0xFKfOYe5DIClrO0t1V5SsVKvb8jAiv9V93Nv0xM2NmpcKve/HQVCyPZ9
   /Hkcid08ZyfoL45Txb8HvaY8YDGsPH/zYveSqG+BjL0Qcad855Y4YLs8l
   5BGhGmcNl5OizGEGtRdeR8SxjmN2nFyUZJ2DDBRPgHqTuWLOEvbmkFsAb
   5y4LIfYw4vOAw2gjpiEiyaFVeB5h4JQIA/tw87OL2BYPq3HOROW2ofVRV
   kKvVkWWFQNRMux5GwCfRm5k1oYhK3qkO5pRj4tsUeJlQ9BRrytJ1U/OJM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="202600522"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 02:19:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 02:19:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 5 Dec 2022 02:19:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EshJUvjrOU79ao2GCDHJs1cEhNbYS2iOpSQg+L+SpsMJAS6nv1IuSpaqPyQBgcrMKmD02n//8EpM0S/eeBbL/26TftnEAOnmO1N1XCaWrHMQtcRbhhDA7TLkRDxwAQdjfWqesXBI1B5pyKSsOcSt1UQ4lqbiKDXKXIARkcPEXndMJ/bBYa9xorgRJQ6yl5yQ3Ae5kLYh1SR9AYVimRuHBlVyREEZe3kPtHvs3XmntTu6htr/W2zHIVrXSJi33iivuMYyU+0lGbKDPIxDrNPfcjVrfFzsHCM1Le0Y069T4WRGCfLx35RpZf9s7wuZ/O15l4EOhK52Wp/j0qLbS4Kcvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2qLfjE6F42FVTBmSPOqqr/3Rz4pnQp3nZ296wMPsGc=;
 b=QXm+u9lOX3PM/QDz1tKRbMXOCenvj10/g3Zj+lnnLQ5rFTOGVWJoIwZdC2UhfuLuCWEQRpabzI5i5qv4XzKdjQuTEEHirRN/wEj5aVkZoWRmwkGyCPRldgTsK/qK9Ggc7jF/WCS/GeW0W1Uh0JaOOeu+b2UHolIZ6Npg0HhQYD4v2eVlGM9fQHuWIVL1sRnXBF9uxlNYL53euScyudgoG0koZMKz9edE0Dbbeb8DW5LUbr8ezoazDAyeqcD86QPLwpQ+zKxW4N8gPfnX/Uo11MFF+zisD8oey9dEF+O0sMAZOteks6YB27cyr8QwibHtwOZXZ6394/XpvDk/xim86Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2qLfjE6F42FVTBmSPOqqr/3Rz4pnQp3nZ296wMPsGc=;
 b=As0csATX22apglkZ7gY4Gsiu3ZkMWG7gMONmJcXkFZlETWvRcCZVX0wdpbLTWxEASrmmA6jykFtfEX4Zh7MitNtxKTc1ivaphLwLY+S87F0ptTRqHkTqe8FqOLVO4hDa3E34MxrpS7MjWgAbH6AapYtWVc/2Y2zK2ypgCCOFEdE=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DS0PR11MB7406.namprd11.prod.outlook.com (2603:10b6:8:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 09:19:06 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 09:19:06 +0000
From:   <Daniel.Machon@microchip.com>
To:     <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Topic: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Index: AQHZBi4aQTbgRosZIUWfrfvxERABnq5cZT0AgAHw1wCAADYngIAAf+KA
Date:   Mon, 5 Dec 2022 09:19:06 +0000
Message-ID: <Y426Pzdw5341RbCP@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
 <20221202092235.224022-2-daniel.machon@microchip.com>
 <20221203090052.65ff3bf1@hermes.local> <Y40hjAoN4VcUCatp@DEN-LT-70577>
 <20221204175257.75e09ff1@hermes.local>
In-Reply-To: <20221204175257.75e09ff1@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DS0PR11MB7406:EE_
x-ms-office365-filtering-correlation-id: 491f6c7c-8a64-4444-5592-08dad6a1c254
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uEQnDjjiwTohiY4i8KAh4ti4cu8f+LVf+4qDpkkGND8iRfeJT7hvGJtfA59LsYgkhhDy4Im3tiUUGqczdcUb5uisabKRKlxKQvhayv+aIIpE13l6PK6SUbXZjQfvKufBFzy4RN5UCiW4ds1xDTk+AWn1oDMTOMrG8vrFkvGCcycwnKu0Sccgz81IUZQ2pZWBDIYtOoj7aGEh2MTiE8eyjImdUEI63qgQAe0ADWOL0Enh0pzbJZkCzrbwmn5Sfu+/V2jbEisjFPho3teo5NpRLgte3tq5gANMifYLu1+opiVP1Dwa7IH7seCgemYgGSYwzWJhe51xi+nylI/kaDWl/v0xx6/s3YSdxIbMd1rmGQM/5noe2FkATy66/YBCQeKa/5Sl70SNY3BqnwS93IwMicKy2vfSVCdXerd8Uh0DaR+uDPAqk3jV1j4QAZ6GPul13yjhe/Bz+m6VQfOq65mfOfqJyc3xuHaqksCTn+nVWfoNkz7KZls+4FdXqHN6OnK53G0WQOPwfczaaJnHqzSeZpUwllNsNuyrdHS6dn1w59IASD8xZEOcBad/sPy7B+DHhy69PGbdC7FASxy8sizKgrgQkG7zm8YncWGmhDe5iO0vWm0+STk1Z7ZB5htMBwCoXM3lasgEaRc+FpFW9eRNDSLYdM32MMd6vsXCbeOum5hkP6sBJjoxncChOqIvG6PdiIgHe89Ood8cxql/Y2uJdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(33716001)(6486002)(86362001)(478600001)(71200400001)(38070700005)(38100700002)(122000001)(4326008)(8676002)(5660300002)(6506007)(107886003)(186003)(26005)(2906002)(6916009)(9686003)(66946007)(6512007)(64756008)(91956017)(76116006)(66446008)(66476007)(66556008)(54906003)(41300700001)(8936002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J5HpXyNrzeI1MSgh69ysBLp7rS/73KqMWY2wNMVTzJIFVI4k4o814gR9qyU9?=
 =?us-ascii?Q?5f8d2PCotQwzl8Dy6e9WpAmWpawHzi7p8KVNT/KgUT465UMnfQ0HAYmbG1if?=
 =?us-ascii?Q?YhtWnXuLfU102GYmZ61jd4n+ITuWYduxOBCClOLPsAre8PihwWdgzrJCvz/G?=
 =?us-ascii?Q?n20NfkLmuz1LX66jiAkf2Odc6yMGrVMveCWSdyIsfkHT5Wzg6lF3eDE5G64f?=
 =?us-ascii?Q?r4Afw5Nc/T8l6EZNcSvX9c4+GLrjK3Xfv7rThrtr38xHIOuXyFC3ygTXNcPk?=
 =?us-ascii?Q?PiBNIY3AnybY222Hm3FIlbqc81CzpUmji6isjtIgMRADCtZWODX0IjKbdJVm?=
 =?us-ascii?Q?/qqHGLOvpAMvymnF/qOeeOvmIN1p+msNor5WzLu6x6BHH/FkbUr5MRGGRUSv?=
 =?us-ascii?Q?BA/bV5Hqyg0jC0IX5e1lKJNx6kng6vXDpr2YJxg2TAHohTLx/jhcm32sVR4W?=
 =?us-ascii?Q?gh0VLMPV+C17+peEVRQd4Jo6Y2bsf6fT5TNCtM1T5s3pWvM3ITgFrgBx8hvZ?=
 =?us-ascii?Q?yuZJVY43QJJao4sm8CfXJdbyKnrF/tpkLFZMUcvOIWy/YRoAIgdvY27APNq9?=
 =?us-ascii?Q?4SWWMdCmxyguFAX8UGs1i2HkDDbkjQmbrYEk3V9e9vKTCEprx6LHwYyPu7m/?=
 =?us-ascii?Q?GZWoE8jmRQqghPF5SHWNtij/nfc05Jzgqs7dbJnrEJaXawHOaBO+YG+JBKbv?=
 =?us-ascii?Q?qhQjtyrPMfwbBFw6C5w87x+RfVlc/+KA7JyLk5rtQMZjgp2oMDlNdgrQgD6q?=
 =?us-ascii?Q?i5EmTqFAYf4NwsRUUMh8cthRCSJ1lo9Qxza3ME7SON8B5yI+G4ux8w81jzF1?=
 =?us-ascii?Q?ZiEZVWD9nZcCYoj5IhJMKfJEbyRY6riG3dFoQzKBAuke73jrLNVE1zIjs7gH?=
 =?us-ascii?Q?6pSQdpAqsb4i3gmd2ArGu0srGIUqZFHxhNEVKQyTaEn9+aK74JlhEc5qgCjp?=
 =?us-ascii?Q?1brVyZZnZH7cbBn1bAkjCvJ5XCYqdsc7ZimITK7g7rV1CBsjPWhjUl93Mfdn?=
 =?us-ascii?Q?rENYxBO68MrDW+uDOineOiQIySgGRJBJd1BmldiAaUg/48v4vT3h7X/ZnSyX?=
 =?us-ascii?Q?XCEGYVUoZVZkwMjnWsPJWN/KQ5RNrdhi8agLG9ncszUSWMxRdW6ENLU1bMk+?=
 =?us-ascii?Q?2imoE0EaxX5YGy6q+08uAqR4H8s+HSFLJIsuise8HktkMoop/maKPkonDnf6?=
 =?us-ascii?Q?1fLMNUx0BfnTjdBCxX4NUSJravY0nxs+pY5rsFZb2drzntZb4mKrUJw4tm5T?=
 =?us-ascii?Q?MoqkZPp8L4aOcQk9jE9+xjqc5RpVD5RmBA0HDt77II97KyYkXs8+OkAXMfnz?=
 =?us-ascii?Q?79oCKaaj7bKLdYHzZ0sqeMjOI1hBHoANbPfZ/rrvbMSuVsOY6QFtFeAaONND?=
 =?us-ascii?Q?Bl4LlZOvq9cNv4dQuG9v99Xkk+EXIr/3wgFKXNwssTqgW2lgaV0bl2Q1wlak?=
 =?us-ascii?Q?u7PO3HBE0X5IuFbfhLX9muhugMX3nrHzYTJ13gvCJQlmvU+a459IpuiF2bPn?=
 =?us-ascii?Q?hccF2gtzJsaHtcrjduml8O/a4QBWLAqANACtppOhwGPaeQEqWGM3lDktXhq2?=
 =?us-ascii?Q?Kz5yc9gnS9g4p6Sn2WC0VKxW5WS4ceQZw2xORAPIZ6uCgF/eIFqzaL1cH3Xx?=
 =?us-ascii?Q?IlsBOxMwYKbJqm91X2Mn7xs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28394A4BA0C8C44384B1EEE2E4ED1F15@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491f6c7c-8a64-4444-5592-08dad6a1c254
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 09:19:06.4419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: reAUS3khTXUe1igIVnWT5Qo57wkSb5qw9At20iWcd7LwH6y8fZHF8JAxwfml9bRn1DQ3lRxxObiupv6ryoHms73OIMXPK38gXMtDuu1o6qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7406
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > On Fri, 2 Dec 2022 10:22:34 +0100
> > > Daniel Machon <daniel.machon@microchip.com> wrote:
> > >
> > > > +static int dcb_app_print_key_pcp(__u16 protocol)
> > > > +{
> > > > +     /* Print in numerical form, if protocol value is out-of-range=
 */
> > > > +     if (protocol > DCB_APP_PCP_MAX) {
> > > > +             fprintf(stderr, "Unknown PCP key: %d\n", protocol);
> > > > +             return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> > > > +     }
> > > > +
> > > > +     return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protoco=
l]);
> > > > +}
> > >
> > > This is not an application friendly way to produce JSON output.
> > > You need to put a key on each one, and value should not contain colon=
.
> >
> > Hi Stephen,
> >
> > Trying to understand your comment.
> >
> > Are you talking about not producing any JSON output with the symbolic
> > PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
> > in case of printing in JSON context?
> >
> > /Daniel
>=20
> What does output look like in json and non-json versions?

non-JSON: pcp-prio 1de:1
JSON    : {"pcp_prio":[["1de",1]]}

> My concern that the json version would be awkward and have colons in it, =
but looks
> like it won't.

Yeah, the "%s:" format is only used in non-JSON context, so we are good
here.

>=20
> For the unknown key type is printing error necessary? Maybe just show it =
in numeric form.

No not necessary, I'll get rid of it.

/ Daniel=
