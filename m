Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA0963870D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKYKHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKYKH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:07:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FFEB6D
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669370848; x=1700906848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=60zKRjwZL8tKev33+zIGXvcE8ZCD890PXw+1AoRbero=;
  b=qXKPFi52VbrCUgZs9DyYAkOuO/UP3weV2iBuhrAW836q4YngGKoIiDCg
   nsNwkTLbR+TTZWRNrziDzrpKZe85SPoFz87XxauWDNXEJT1B9GrFet75+
   CxgZqAK55Ckvq7GSOMUMGPe6MeHvUDslecc3IiyjNK8YEwL+GP2iSt0nA
   3x63LGWcdtpjg5GxQ7GH8L3nqsvHtbZHihFDzHgO74SJiCxylmKcVVLAl
   v4k1KaTLXCzwFRfuBsnBDJwbwh2QpQP7PSkJJ4E56if/SDY6sC9djRlfD
   4ssAw+h5wpw9PIgEuYder3ZXdnmyPVHbxyCjlE5UMvmwgJygtzjdhxmeP
   A==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="190497144"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 03:07:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 03:07:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 03:07:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXvcjwvhHl0LcGpKbXVjmnAYLIjqhVps9Zf6jX/RI/3e60JQV1a6e3bW2Gf4plN4kslfRLMYv34ZRadEW1X4peIhu+WZegHg2g6kb/TiKwmklxDrAPxWLZiCvnIfZ5douzuBI9I1tfibYO7TLhlTFpTD+wks9lsZNHuH+x+EbZHeV+OQtOwBlCiA8wpOuVlcqf7hd5hPasrVBwum8T1+UAxQe8FembUjlERAP/RShlDRFIs/mbhs8gMizuqgHE2UFbPK9JR5u+VUDpAon5LKueKuXT6US9Je4jAnSk/8+MJK3PGvXvJw3Jcl+O4/pX1gV21lh1pWOGkroh3YIzfvYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60zKRjwZL8tKev33+zIGXvcE8ZCD890PXw+1AoRbero=;
 b=kTvyGwsfBQEWzHFvBdbTqO4ad2hO/Ey+328/Qdq90xd/wwRhXau4NOcXad1ahFbfXUBuLjI8eKVAeXwaNA9mcGQXmE01lXtP0JLxLpImqo1wo5YbOOTR24pmE7fFGa/HXcWPe9xRBiEYmIbRsV6tx3YWrixegZJVCP7Xa6t6+rbfy6Y0bjjapN99PAHHKXCHXR7n3lF47ARivyBZn4pCXwOsm9r3hz67Bl7fLHz828jIrBQmSE4RZvQf0c0DwK45oduHrlihV7PyzCOfx+IyIeLP7F8KPsUcVYztIszfGdvtNwKUZLco4zAFKXE/yMO1CJRwPeu3fghnnbLyz+UCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60zKRjwZL8tKev33+zIGXvcE8ZCD890PXw+1AoRbero=;
 b=cBUblJkf3KYsgXFaWwayxixnv0R4b2Ere+VwaRZH/JyOHx7VA+tdI6mo2/1C8ApZNqpokNADq6HqzF0cYqDUf4MTlVYLGU+Dgf47W2P/wLrZAF80P5JSUAlEef7OcYlAPERaSziId8FLroSnM6C9JgS+OzTjjSihLuFFdnsz5Dk=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 10:07:25 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 10:07:25 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>, <g@den-lt-70577>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to dcb
 app
Thread-Topic: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to dcb
 app
Thread-Index: AQHY/l1/sI/sgDT7f0qP0X2yrKr0fa5ONrCAgAAXBwCAASQlgA==
Date:   Fri, 25 Nov 2022 10:07:24 +0000
Message-ID: <Y4CWg3or4zOMh/Ud@DEN-LT-70577>
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-2-daniel.machon@microchip.com>
 <87wn7kibn8.fsf@nvidia.com> <87k03ki8py.fsf@nvidia.com>
In-Reply-To: <87k03ki8py.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MN0PR11MB5986:EE_
x-ms-office365-filtering-correlation-id: 50243787-995c-482e-dc7d-08daceccd9da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t8LkDMb/kj3pWzysKDF4fjQ2sz1m2MrafT5XSRQH1cV7VZmZu7XEjqrHvgEkda/BftCA8G+87Tv64qmBl5o1+C1wkfZ/xhTRH6yzxgYoBCC61XpiEInRAoZrLyHHfIuIhVRBfHRIrnA+n4JZVJt1LK1aQ0vdG/gHjEXk8TcoBiFvZJRP4cUysXrI5oUduMT2IR6Ea+SqJ61d90jGguDtEyu0diRmGNA6ijzNrzw/sMHa5zw3C1L5snJOEwequKylIxzx7aBY2Z4sCXwURZ9H7VSpMDDdaP/xt2A3vb/3TFnEeZIpeDSKSjG6pmeglIcQOfB1WTMP0d8y5ilLXznPIXy6iDMzgqIdUUVntJ7+PcZPY18uNa1ATl4jCmqrnRPWOfdsOI6+RovOp5BN00ad2pmVDDML6f6XDU7xpAFK593EvpFvoHzsqHQ2apHi01+gWrNxw2C0IZuEV1tlyGcGHrTXghece2fGO7QwvHl2XKCiJjeeWcmjWmmwivYkobFiHp3ZnjqsPuyJqBHhPESwuLp7UMlSOD964t5vkTkPD28FSvJWn6jd2KBNLrQDOWJacFULJHylIH2upG9n3wYMO5tzXyRwy7Mgj0s9ydtzdbWG28qv/dGAxvmPA53ckPgHdb4WPX1f+atCbCyEgoqsTa/B/3xxiyu5/hGvhvABOsPwIEBUzsyhw47C8nkiCroyQXqVLHFuQbckeiDkyvtVFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(478600001)(71200400001)(107886003)(6486002)(66556008)(316002)(76116006)(66946007)(64756008)(8676002)(26005)(66476007)(9686003)(66446008)(91956017)(186003)(8936002)(54906003)(41300700001)(2906002)(6506007)(4326008)(5660300002)(6512007)(38070700005)(33716001)(86362001)(38100700002)(122000001)(781001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ScIjVZ2zLuXDqdMgo+dnho82Ryc2notw3J1/c8VrPTnCDzcJ72cR5CGmHVfb?=
 =?us-ascii?Q?Pp7bg1q9W2xhpO2JWwyr+nn1VkQRog0YFx7pHKJfMJmi6D88KDMHVJyAdenf?=
 =?us-ascii?Q?m4bwTU7GmhmB9HmGMBHu4AZDgYNvUZLH5pzdS6NgsIeAKsHzaPqhid17r+Sv?=
 =?us-ascii?Q?1jN8dgetgqOy2J5J8lbzDvElbWGQEsUSyZ0FtE6ClkcQaM1IRDrX8T8r3pj7?=
 =?us-ascii?Q?OBhXMfOyE8Al0APj0PotzgB2eWCaZFZq/zYWMV3R8n+xWkq5JEiomg0JZUk4?=
 =?us-ascii?Q?FvmK/U6XQCqXpHkp3/yejlk8x6KEeexZDigWc5KgZZypeHeg5dwDchY2lOAL?=
 =?us-ascii?Q?k2QVAhotZfYQmKyxyFFUBLSzlcE0xbFoiw9AWqqKlfOKsSeCuBliLZyILXju?=
 =?us-ascii?Q?hkibHDjaUg6oTMOGtE4xCR9GiMxyeGYp7d/kZ6J6gvG7k9IwYyCnh435Sng0?=
 =?us-ascii?Q?gX1Jrtrpaj3+PDl0bnqTunuNrAg6ByhtYCSWgx2qGjDoC5ufOwncT9RLspIP?=
 =?us-ascii?Q?zNN9Gp98R05bTUHIfA1C5S9If/8+gNu6mYz9HHTPOvOSNY9em/l4aWVbGQPC?=
 =?us-ascii?Q?ppfXJNs8UlfPtCGlUaS83wkV60PtRaoHIk3QOa9dlBiAIwb6x5ku+QKfRd4m?=
 =?us-ascii?Q?u6P8oWZ+nWjac+IdIxsEgEi2tDLJkIoqAlH4hqoz4ELmKCGgWlqo/syCB39s?=
 =?us-ascii?Q?eGWo/us9fAIASq6YzdlPdeHWwngM5JywbX8hIitQCPIYpHsN2fcmTk0aVjBh?=
 =?us-ascii?Q?3OVppuP6Y+v0/CJlGcFJd4KIPz/8/Kl7KZLBNEFrioBsYR4spMoHg9Q2K3mw?=
 =?us-ascii?Q?cvB9vGb5UaRy4rLOXTFPH/lHNX5/xK592GMv+qMvD47HNWTM2wZBBDQRC6UD?=
 =?us-ascii?Q?J8UFKK+VXCY3oFa+/sp9I2ggRw/vmFLggC7ZMAMKLnFCnNCRCtI8y0WJY6RB?=
 =?us-ascii?Q?iORJRrskTcRzWAHGedF9t5+dpjDRQdxOr+keVgeXsKu2gSz0Pi4mMiB3AyvT?=
 =?us-ascii?Q?27/rgK3+/5anzRinJ888QCBxm9RJuyNvzMgt9U+TzgIKMBnsECC0jvWhWRGQ?=
 =?us-ascii?Q?4wFjq/YHtqeY2RLZ8KkkxzrQs+sn4ivz49mcsr29CpSZlaol5vmfDWDDnyET?=
 =?us-ascii?Q?00lD/EhHTcXy3GqWygLiRhZ3YrbqWypjj/pGpKW9YyV60Hz/mohHBV3ZYqjS?=
 =?us-ascii?Q?8xoyo03QwqcPiRdReruLW5V6zFBhgMF6V9uv6lq+4QmT7n/tjBlvZ3nx7Y46?=
 =?us-ascii?Q?TKyfIz1cebmf3cx/FmoUM1rS1s7QqaT9K8AbogGz0Y/JT5tAdSWfFW2cyRDd?=
 =?us-ascii?Q?PDA0lTS+EAc/y+Ve2oE7nDDGIf2y11c85/v2nMFSqTggty5s+Aq6Zd7SVVGs?=
 =?us-ascii?Q?42s1It4wBd8YShgfoP5PJYJYWdhCHSckqIHIusmPFlQV0RHMtyexZ5Rmc7fk?=
 =?us-ascii?Q?cj/L2nvkQCMh3Pru2OFP4PfUNZ29Hc4ompIvBLYAbXXIusXMH+j5YEgLM8ty?=
 =?us-ascii?Q?xgk8vJBOe9B1FBbb+Kojc4O4Z9msjhCKblhyMZJSiWbSfbK7BEXQ70RSfYcX?=
 =?us-ascii?Q?4v9MJWKCGZlTYphSDnO397wOISQ8y1w+TlFWu/5IRVL1lh2EzaUiMCPdRUIR?=
 =?us-ascii?Q?nh6tAUkjmciC+XK8O3ZK/jg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C6B3FEC412B02B4CAD01100A09720D2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50243787-995c-482e-dc7d-08daceccd9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 10:07:24.9839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ULC0JKTO8Xcz0DcwXLMBC04oSM8qTS3wth46B1UoPjnIH/R+LaMAddC61qBWESSyVkn5AFRwGtyQtOMIQlQjP7V8miw/CDjhxyJQrIIXI0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Petr Machata <petrm@nvidia.com> writes:
>=20
> > This looks good to me overall, I just have a few nits.
>=20
> Actually, one more fairly fundamental thing that occurred to me. If a
> user doesn't care about DEI, they need to do this using two rules: say
> 1:1 and 1de:1.
>=20
> I wonder if it would make sense to assume that people are more likely to
> not care about DEI at all, and make the 1:1 mean that. Then 1:1 would be
> a shorthand for expressing two rules, one for DE=3D0, one for DE=3D1.
>=20
> If the user does care about DEI, they would either say 1de:1 or 1nd:1,
> depending on what they want the DEI to be.
>=20
> If you generally agree with this idea, but don't have spare cycles to
> code it up, would you please just make the PCP keys "${prio}de" and
> "${prio}nd"? (Or whatever, but have the syntax reflect the DEI state in
> both cases.) I think I'll be able to scrape a bit of a free time on some
> weekend to add the syntax sugar.

I think this could be useful and 'de', 'nd' (not-drop-eligible?) is fine
by me. However, it is perfectly useable for me in its current form so I
wont object if you can find the time to code this addition. Is there any
reason to add the '${prio}nd' keys upfront?

/ Daniel
