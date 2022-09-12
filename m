Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDDE5B53C1
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 08:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiILGJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 02:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiILGJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 02:09:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BCBB7ED
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662962986; x=1694498986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8AGiXzPumV+f3r7jjQWm+LdwCtwaYqZjRVM96lsXD48=;
  b=2DS0Q1JTSkLfhsHpx9HUvD8cmEH+B12wjkalzmpgCJUYS86ZaRuKsCx1
   DMdKokwtn8qDk6EyNEmeaEvoL8MUlqrEbSgCOHxqx1JkxI2m4FIn2/NLE
   92RrXutU388Fsw1yCGsAV1NFnlikCZOJtEvkxld2Nv7lxOL0nSijtpQIz
   YpsqcKrQwuB5DPAA+y9RQ5PgKfxEcdRliHS7Upi3dyfsxMqaVkwFqQa7R
   R5v7PFw2RhhHNdjUJm7vFD5wwii8c3Xld0U3pohDqCFBGqU7XfOtd3p2p
   OE+hKTaLcTv5HWVGMffXjQ5NYMZfbOQy8ZaAqfiOxEBNTvkJmls5SWgy1
   A==;
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="176646845"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Sep 2022 23:09:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 11 Sep 2022 23:09:44 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Sun, 11 Sep 2022 23:09:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqvS0r4x7Oiq5EtZys+KROtmb1nw3PgB2T93lFNEBAVZr6Px46i5KkX7TP919HqsUmNQypg02/6imeG2snebVY/iKk6jo4+/nhD4L0rLZcSJ/3C6kh/a9jCbeCrTF2mn+XQFPozNEqUD1Rjt4FEJY+ft/ytq2r+JHLXkEDCRzek8dc039pddafPa+nJebu8AE14lCaHvbrbCVZ+gDFK/N9lQaqCwOUxLjKWnEgtdXvdzUdvRWsAojZ5Id+TcLY2yhVYKhkc1uG+i1GEQ1/yg3myIU7tKCv52nEXM1BOhNNhA7Pk6cyQ6LIWzZroaMTqT/eTfX5xy9q/7TMZWKfCojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8Nhm4w21Hs2DvjFHQSE/jHe8BgCwv9DCvldM3meQTg=;
 b=UWnGMqTQIgeHpyH17FHKO6iA0qJjobd1pAA7xkLho2JDXb3wXRauwPrIkcHS3a3I+xqZsgDz56jpjvPSFHkLAET6CL1x3BWsBXlZ3scuR8NyiClLYPCW2ltQyKoPstC0aIVgMKe88+iOnrEospp+wv2jPl9YW+ntqpSU7EJYQ8tPZ7JP5yQt9/KpvGon+Bed8fu0wOXzjzzEwO/pEejzGoJ/duuwbPxVVDYDuQdPaqDMLi9emTTYuFXX/kffgFchYqwECHl2zHwrQgr1anVlR5DKZM/2hdJxFKKL8WI1kQGk/FYWjB/vl3dvVmf+z/rBgKtDYyDEVu8yXfs4QoYG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8Nhm4w21Hs2DvjFHQSE/jHe8BgCwv9DCvldM3meQTg=;
 b=WV847sXZ6wNTxcY5665wiQew6Rj9+n9jBrmMOx74UmbbJFLbqrRrC34s5l9LgeUINlA/t7TSxlvKRwBv8Tk6ElhACkmAa677WiLVubRm61P2VqHzgwlqIcFGyZrm9EyZewAdbS7jk0cG+nDq8cHpXrwUNW/qc/UtMVbvpOMQm38=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by PH7PR11MB6556.namprd11.prod.outlook.com (2603:10b6:510:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Mon, 12 Sep
 2022 06:09:34 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 06:09:34 +0000
From:   <Daniel.Machon@microchip.com>
To:     <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH iproute2-next 2/2] dcb: add new subcommand for
 apptrust object
Thread-Topic: [RFC PATCH iproute2-next 2/2] dcb: add new subcommand for
 apptrust object
Thread-Index: AQHYxDbzBxQGvrbZAEycOZ5BFXTTta3XMw6AgAQjiwA=
Date:   Mon, 12 Sep 2022 06:09:33 +0000
Message-ID: <Yx7PRgPKy0ruMDSE@DEN-LT-70577>
References: <20220909103701.468717-1-daniel.machon@microchip.com>
 <20220909103701.468717-3-daniel.machon@microchip.com>
 <20220909080631.6941a770@hermes.local>
In-Reply-To: <20220909080631.6941a770@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|PH7PR11MB6556:EE_
x-ms-office365-filtering-correlation-id: 9af12a85-af29-4dc1-ab4e-08da94855d1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EoHkcoOGcHWKEsSzWf9rY50cJoe0cFf1sKkIPwAvFXga1goiZH3Mv0h5Y0rvpRZTYJTkzbtX275ri/MTQN9mbPgocQ7nhpOKsaaJRCv2pvq83FFNJi/EbdAjZbRMlqPzPgB+z0paKs23TC0YDSvCT3yOzQCEP3gp8f+TPAm05Fh6aLJGfc86BF0PnNH4l4YNCkKn/t937omsslQ7XgmdebBMGYZlvmBHr6P59nOO3nuHda5y2XJA37xBND+EPZTEgGMctn/uwvODpGqL7SiNMCApyn8IO+CyOHlNoUVhNzNvYD5kBmQ5fjhonqwNrob2bUSAPz0EDB4WRi32yNF147Yq+MUQU7WlPBzgBFnYOPiSB1AwGcP6Hn0X5QevBUPoIC/UXBeiVd2A7espWEFbBr/KgWHv8CVlZ+oCRR1SdNmt5G5cxxFH1sE6Szdo2NNDyqDIedgfeqGbdujMtMQzUrKTF9hjw5/9gSKQAAQmYt26pIQS3yNsT6VJTuIAAIooXGZUwbu3iDOlFU6/g1CfQjnEQqoo1UmVDNNPetnXxHh39H4zU8bwPf2zAg5NMwodJ0YFWc5OnQLfHQdx/Y3Cuw2Sip1kzdAZrfHJxm5jeq64DKPSoxehM+JNmeeJCGw9coOfuna1uzw3rxAjIWDe9wdUFudTIH6l7MQeOTDl0DwfzCTrt7FAZBlMTMpzxveUHwk9pio+CoxBFth6DU9tsK9ZHrBihFkLnmkVOnz1o9kTBsjOID4eYtQPILPe+gpQdCv0L5QonhdsXs3BlQPAVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(346002)(376002)(396003)(366004)(26005)(9686003)(186003)(38100700002)(122000001)(38070700005)(6512007)(33716001)(8936002)(64756008)(66946007)(2906002)(76116006)(4326008)(8676002)(66446008)(6486002)(4744005)(66556008)(54906003)(966005)(316002)(71200400001)(66476007)(478600001)(5660300002)(41300700001)(86362001)(6916009)(91956017)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HUnZsJcrdYDooFc4wG39CS3FbsrzHhklXt6kSM6h0Vxcfw3x43qmB6/yn/3Q?=
 =?us-ascii?Q?mcKA+t6C6ky7rWqB8Z0etrBptCwP+MxEIy6wCW9gdHjFFKzxOfntJ6/RXPKU?=
 =?us-ascii?Q?cbCRT+1/mJeXC6XgdVsn7Ln8gsx1yyqij5WcaAHUxECfdOToNeE0wiO3VB0X?=
 =?us-ascii?Q?8ASDhlbBSQ8iWnM+V2/GvvXKTuQrWv+aFmZoeSY5UmdWInIzDS5pG3pkRnsT?=
 =?us-ascii?Q?qhoGVdNr4ubWx2nZahyevg0BIW8VKS4BYQCkdG7h3R1Jc55GuczHkQKTy1g5?=
 =?us-ascii?Q?pQSmBuhGRD1blBfYsBlZMlnH0gsG5wzz/JTfljH9Yp2+zh/xG4AmCiIQRyIp?=
 =?us-ascii?Q?L4zzRzysDg/yNRx+lDqhALio5oyG4VMy3LZEAeSgBXDHsvR5SFOoyCpgZrle?=
 =?us-ascii?Q?+4hjUnX7bjRhpdoJyLsu4aP/feblXj29X/x/kvsXRVLMjW1zU4Cwzt3Zg3nc?=
 =?us-ascii?Q?uY0Bn/iT5vcD4CHeDIq2UUwqycfhbZVdA2ZcnwM3teZIgMwWp19Pm62EBrdB?=
 =?us-ascii?Q?5AGaz34mGkK9idEBOZ+ZVh8lD5+N8qxmk8Xu8nYE5iXx25tZMWftuXqUrM9m?=
 =?us-ascii?Q?Ug4+M34AUzaLOyZvPcNUN/c7qnBdsDAB8WJsXg6Zne7ndJ5lKJ7Oi7Svltvs?=
 =?us-ascii?Q?cBip2Fw4q1dUl8QZwOR6LWkoOeS+zFkUk0VNAumlHM23C+p8gnIHwFzouD2i?=
 =?us-ascii?Q?hnLxtz+YZVwRVhk9uQUjc0yYzrIhuTvmlgLAMXfQcAaLm/TkuOUXWIr5JGFP?=
 =?us-ascii?Q?ncJ8+d2MiwuVVPdRFppxzRu9723LA1oPUv7maJWqscS1dafs4wKlvg/pZQGF?=
 =?us-ascii?Q?onvGnAdvJrVGmcGfWBbRpi97RLQ1PmwZl/UGWF1TNkuysI7DZIQp4SECdLI/?=
 =?us-ascii?Q?DlV5LlBR3gsoHMP1KAHBYzAAZx76xQqMQe05ADgvktVn0lyH0tdL7DFOAK6/?=
 =?us-ascii?Q?LvZ8hTB8suZEZodFBLBTZz6epHczSss1z9TK6OG6t9ixbaax11K5z7CCOKcG?=
 =?us-ascii?Q?oQk/Nr4vED0PFfBbuqlh7S8MNX0CQiP9LjL3o9lih3utGofzwqrYrQc+2jKk?=
 =?us-ascii?Q?bb8ofOwZRUILRbvSP8MD4i1gvtVa+WfrXjpmCOkWGKgCJfO55/EaJPkhVr5W?=
 =?us-ascii?Q?dC34eQx01/aVHxm2S1s51Gw9FtRWK1D4c0nyIMOr16l/OEaEvPok8HNlIwMZ?=
 =?us-ascii?Q?SY/oPiQm1lH7+ZuCGYdPxtoK/rKpA5rhUVcyNY0yqwrR0tE9+CDCJS81lnXA?=
 =?us-ascii?Q?yAOv0ena2qHZXDUKcsGsH+oa4lEHDM+UuXt4bZC2REgmU01viiypU/lNh5R6?=
 =?us-ascii?Q?WHdEH3XOt8IosA15gKVrvH0cVlAqgWXetNnmFO7H2DMXdoOUjER3ebNPHwxg?=
 =?us-ascii?Q?O/Zvl+aoyMEzpASgUk5avA24p8g27aOH20krkIUS29m8tGSr1KjJ6IFyUaW7?=
 =?us-ascii?Q?DQvaPr43JiQ3rqxEC7dMs6Jfwjmk9mwBDVZktEtadmP7ISNMBpU08rL5tuHS?=
 =?us-ascii?Q?qEXFYWqIUfPEVXZOoHE/HmOSgrGWzJNVUCIg0GuEHJH4roXn+W7rffw3JL06?=
 =?us-ascii?Q?lqdZUhQuVZL+ZuoIvTvD8xQx12ds31MD/1GfvoodzZZ74fXVrYJaNddx3+Y1?=
 =?us-ascii?Q?+BCtP7Zmlgo4YGRTB62Q/Ho=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <247D85BE0EECAA4FA05F552D2DDBF785@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af12a85-af29-4dc1-ab4e-08da94855d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 06:09:33.9910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i++DyKlkjmLR81MYRRyjcwtrDnvqOOgFdbSCIC8Z3NQV0lPEgnkJJSyB2DfBXjyYNA+4UiqnSoGYmDdT1AV6FQvHXiXVlAF5nqtNGMMv75U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6556
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Fri, Sep 09, 2022 at 08:06:31AM -0700 skrev Stephen Hemminger:
> [You don't often get email from stephen@networkplumber.org. Learn why thi=
s is important at https://aka.ms/LearnAboutSenderIdentification ]
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> On Fri, 9 Sep 2022 12:37:01 +0200
> Daniel Machon <daniel.machon@microchip.com> wrote:
>=20
> >       } else if (matches(*argv, "app") =3D=3D 0) {
> >               return dcb_cmd_app(dcb, argc - 1, argv + 1);
> > +     } else if (matches(*argv, "apptrust") =3D=3D 0) {
> > +             return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
> >       } else if (matches(*argv, "buffer") =3D=3D 0) {
>=20
> Yet another example of why matches() is bad.
>=20
> Perhaps this should be named trust instead of apptrust.

Hah, that slipped my mind.

Obviously this wont do. Will have to come up with some different naming=20
in an eventual non-RFC patch.=
