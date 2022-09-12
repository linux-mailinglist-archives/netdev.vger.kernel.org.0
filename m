Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4780C5B54F7
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiILHDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiILHDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:03:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5875D24BF4
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662966210; x=1694502210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3dJFCP5ae5/LrtaZWyRJbggSMz4Wf9LBSmwXUrjmUEA=;
  b=cFLWTcn23573Kn1xf76gkHrB3V6cbJKmOaoJxhyYMajdpMsbCdfy4XAf
   dNaH9cIhaKDnG8yKDyPSkPBvwKXrSh9xv81b9hiMoT2YbSH1QcpahmJy2
   4fYKuE8iVZSVP8SKSddI2PTY+7/FzatZaBpiySp87uJQ14dYbU/OqbNZ2
   yTY99e6DHZ2hzNm2jsTNFMVKPkeG4tmMbVPoFhAakCn8yUDm+iRUUUCfw
   soCDPbG3innI10XBFNIMxXjeJEvsERMdhTc/hEbmSUsJKjYGR+H5mhGv+
   5lbTxRBtnrepYudk+hn7LCiX4VyEmHCct46pGhXso5ebiXqKvvmVIBtsc
   g==;
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="176654742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Sep 2022 00:03:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 12 Sep 2022 00:03:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 12 Sep 2022 00:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7lUVQjPL8orwGNaelhJ/ZDA7+/pY9Xtgau/2PEERUFx00ltRItZGdMcFYNnE5LIq0/DFMTc8lKeuEpeiAECEFIhBM6fHkcMWmmd6iKfOcEW4dXbw3rKgBxbXRBlDlWeoXFbOSIGv5lfIrHz2BS2zl0iSG37dJJmRlmVGo/2OFpk/vLLTN99FJ/WtCmIPetykKGKDAJTYobGT+eO0TugxQNTW33THLT4Ss26i8c5s/oMNdehj73vA6eD+Zs52QPs8q/VVhFGX/xW8v34o/YcQXUbC5kluNPvVzO1+bew0jgaKU4NKP41qCMhllfudXa4rK7V2mzPZ+yU8kgQGwZL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dJFCP5ae5/LrtaZWyRJbggSMz4Wf9LBSmwXUrjmUEA=;
 b=dPYXzS+uQ9dGs42tMHwKp/lJoSRXalsr0XgOaGfBhhaf+Qhc9j1um1RNMmovUO5SB9joeYyE7WSPxd0trO9Frt5qF/mEPD/2k4wN+c7cbeLTqkkK0wwInsXvKZk9NbW9I5H++/FPdYTF9B+T35jDYEAUrhaBehjbUo6i+9y10y487iimuhw+hMdCDPMX79yi/U85ivkh8fiPOoeTSwvh8WxC2S/xiyYmATj5DD1tD6PQj7x4OzmHW9S9m1ZR4w4FB7HY81f1yHTNxV6hpW3+9iTr+7sHvKgYOpD/yYWcKqil6087S23tBMY160CRk+OPQns8F1uXFhNd4Sj2u8lkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dJFCP5ae5/LrtaZWyRJbggSMz4Wf9LBSmwXUrjmUEA=;
 b=RWNUZFX4oIDFtMPVd1K23GB9OVsEaFugg23ceZqOf8o1Wj9gUizqjSEncJlBRXDYS9WBz8y7HrC9kgoecWgAIwYFEujDMlmTJBaA3IsQCYE6hBMhQBrzNOMLBkwojTbatvT7B68HxSi/DwBTVMFMZE9ZWNb+OtMay8oGIu1Wq0U=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 07:03:24 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 07:03:24 +0000
From:   <Daniel.Machon@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYw3oNia0DwoNaEEmN7eTvM5DvRa3XCMEAgAReXAA=
Date:   Mon, 12 Sep 2022 07:03:24 +0000
Message-ID: <Yx7b5Jg051jFhLea@DEN-LT-70577>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <20220909122950.vbratqfgefm2qlhz@skbuf>
In-Reply-To: <20220909122950.vbratqfgefm2qlhz@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SJ0PR11MB5815:EE_
x-ms-office365-filtering-correlation-id: a9f0e481-7b2d-4a20-9a1b-08da948ce26c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dkF1dI8T6CgwFB7U6mpy1l42oG6haKUOn8JAKMBdiGa+u/nTieTUw9mRT+84W2lvx0MKLLgOeX94cTZ9Ad6Ci3nbhOp+DaBem3iYChAw7yZouxZbqjqLbtM0mq9lmqffEU5qBW8uVaCUgukN9ho2/2Yn6XvGUs8Y6XnI4ph+/56FHSU0KicJES6hnfeRdRMd/hsQTSfKc+BVr+1y8TBlh/WHaW7DKPQAvcuXPDurDoruUSXkLAFwLuh3BKgjoImSwP38HLYHYuiCNuOk4NPNNsQN+ACrsMnZsT3wzefYswt6TcJNcnMOl/jplH5Xu8inZmGTTmaLoj/S2dy4vKcdxTEyhHQn4fwWeKt2ywoGYBSvBkx311IZfj5T5+fMPTrcsjFVDRKBm8m8qNHguvEmAp+UzDWrBCOz1WH/hbFKPlbIHDttz9kafuFFB23CIWow4AnYT5ZlnRG9Sa87Fxm3P8OTaHy3YSY5DLUViru7L/Q/1RkX4jnltXAD6ldQgNcP6vzDowNpyvJuy1swdKJDU1Kxw6vErBeufxshmqyUidWBlh1acYJ2UTRLfB6nU5BDaMxZ+N6iQe8GaD8cU2KPk/9v86jpvjTFgaV4cWCwV4Tj+dGEIU2wUmMMLqEtaC6qzfXO5CQTdjuntt0PQFvpKXQi4lQwRTG0JM434tp6eLxHBnDMMMqQCou6pWQapqVxOQHikf1SFo90FBXlEaqIppQlqyqs6hd1ly3oH4q5alUyH2X06QHzWSEtjw0hsWtprlyRG4ydn2zyStqdvPAvTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(396003)(376002)(366004)(136003)(6512007)(186003)(26005)(41300700001)(71200400001)(6506007)(83380400001)(6486002)(9686003)(478600001)(316002)(6916009)(76116006)(4326008)(8936002)(8676002)(91956017)(2906002)(5660300002)(38100700002)(86362001)(54906003)(64756008)(66476007)(38070700005)(66946007)(66556008)(122000001)(66446008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PvFOuaO+HOirIOwgGtdlpOgj+Jmsy5BakaTRfUV1dc9+BM0tjXHt1ZQlR/+A?=
 =?us-ascii?Q?ByiEKzNNwLX3/hevCQzJK5YXzQ0oLshBj13fbcLq95aXlKDa9ny0nGEwqcf5?=
 =?us-ascii?Q?k9nbIG1xJqq1118JEy1KQnYQCcVFvTCUaH7FBuU4hIByEI+O5E+O8310xgW4?=
 =?us-ascii?Q?J5KnOoVlWh0m5Ieekc6wDKik/+7/8oGchmyWzPOKsXvESkcnAkRDpaqUQlbk?=
 =?us-ascii?Q?jfKHc4ws3hdydcnpNzh7saINSKU1fi9X13IWTtHAHktaYZWXbGbv7dy7mOIr?=
 =?us-ascii?Q?91OV95udvuvvnJZJYj7b26OvZCdAm6guG2TWD5DtgXgWKE6dmNcbNE9mWkPV?=
 =?us-ascii?Q?WnvhThl7++jsrDV6dRxtLszR9ahVAymTgtWFqGR0we/Sn60UmfH6XRivqZ1k?=
 =?us-ascii?Q?a6xX98N/4dVxHv5NJ1U15PcXH9jWXwzFa34zcVAVIJ0j4tgNl+HZcXH1rnU8?=
 =?us-ascii?Q?vkff77fmPi9ejlVPBwfTrETyIks74inv8jgBAaGzvcqqvqsagp4cARM65m4o?=
 =?us-ascii?Q?rgxkdk0kO/mfFsBnXvKpE+mYpTf29XPihqAqxoZuvJWczX1zREuLfM6SlJB5?=
 =?us-ascii?Q?re9BKts0dIEzAzca/0tXpAoVix+BB/fERPWC76GqjNQAZYCnoMII2UL7eFBv?=
 =?us-ascii?Q?serlACtBOezGsA3T5081oZ65umSGO4GTTU/eLDPMaycGbFSlEncAqfNUUQuv?=
 =?us-ascii?Q?FjuXGdZjGYskAfwrWoKwvizo8WvLXJXZIJH47+D+IBD4BTPTsnxoirVZpdqb?=
 =?us-ascii?Q?1ISSeZ3CkeclEbGC/AokDqfWWnOUkT6U7g6SP6KzXebsQjFHmUmOcs3mLDFt?=
 =?us-ascii?Q?epzigwY8r4BmjVGOsl678Pqz2+iVV5rPwvToPCgwyx7uZmUAOfh8TXOlOr5G?=
 =?us-ascii?Q?rdUf9K3OX6WDk+xXC+xipIP5iiZYQDXFWQ2aoGj29KTza09WqTjHrr3VphYO?=
 =?us-ascii?Q?u0ZhxJ03ZO6mKINgq2R7TeT2wKZozoXvG/8uN/T0lRWrOGkYFTtIeSnmr2my?=
 =?us-ascii?Q?R697e+EA0KU1eGLFk+fKd17ipIghK4OkkpUd2D/HICZ10hTenrdC7A4X4bDV?=
 =?us-ascii?Q?6rcAelhojEoNuJ5uQD5bhWwsOIsYuaStwhWF6/B3+uF8/hqcuYXFRBUXOM5l?=
 =?us-ascii?Q?BxbJnTq1KaGuMxXkWX1aZknayl85VujE0iNBniVLbiCtJm/A17fqjM1z9VZ4?=
 =?us-ascii?Q?pElTzHpbIB3Re5wqJDKs6/v5VtQRhpTeqwOHTGQWdDou5HVpODIJ2wi5yjCU?=
 =?us-ascii?Q?J5Q3F5JP6Vlk/EkSjXLE7BEbyaDyCjnabBhTO8S9oHJuTY8T0S/ssQ2D+NUP?=
 =?us-ascii?Q?w6GL3KHS9n4jB6d3yyfhS+gOqw5ZKe203fUKYxlbap/oOCzLsf7W5Ho6nBwz?=
 =?us-ascii?Q?Qwb8fUbsyJFG6VznujVJXIVBDFsUsSaXtPTwMt7JOu7qb3S+/T9VzswQnCaG?=
 =?us-ascii?Q?y/WBJvqGcMn2BXB1/DJeCdaHPl0v7M+2P5s+7/zoix4qJ7B00KpKEuDg2Slt?=
 =?us-ascii?Q?K+fao/5FkqwgwEL6jn1PmKMc63vyv5qyckU/ogzJGRvIA3KErwYTiQlcecdC?=
 =?us-ascii?Q?kVYbkv2GD0uO5X2zxRqng3fjrKxb68JYCKuLdxHWPAvJgNQSkxuovTOebN9R?=
 =?us-ascii?Q?dOCEDsSD+6pM3GD7OlTBIfI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8E8959EECE7A54A881329CA23029537@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f0e481-7b2d-4a20-9a1b-08da948ce26c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 07:03:24.1134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0s02LZ3Ju9CBrnO/trlHtIpHVEvoQsc3YKAurw2xqgSVunijynD8TBjhLpY6rEpgL2ZFoI5QekjpqF5tdgatpvasIPJzxXOVqyEhLEl9YkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5815
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Fri, Sep 09, 2022 at 12:29:50PM +0000 skrev Vladimir Oltean:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Hi Daniel,
>=20
> On Thu, Sep 08, 2022 at 02:04:42PM +0200, Daniel Machon wrote:
> > Add a new apptrust extension attribute to the 8021Qaz APP managed
> > object.
> >
> > The new attribute is meant to allow drivers, whose hw supports the
> > notion of trust, to be able to set whether a particular app selector is
> > to be trusted - and also the order of precedence of selectors.
> >
> > A new structure ieee_apptrust has been created, which contains an array
> > of selectors, where lower indexes has higher precedence.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
>=20
> Let's say I have a switch which only looks at VLAN PCP/DEI if the bridge
> vlan_filtering setting is enabled (otherwise, the switch is completely
> VLAN unaware, including for QoS purposes).
>=20
> Would it be ok to report through ieee_getapptrust() that the PCP
> selector is trusted when under a vlan_filtering bridge, not trusted when
> not under a vlan_filtering bridge, and deny changes to ieee_setapptrust()
> for the PCP selector? I see the return value is not cached anywhere
> within the kernel, just passed to the user.

There *might* be a distinction between enabled and trusted, disabled and no=
t-trusted.
For instance, sparx5 switch has this distinction (at least for dscp) - but =
really that is=20
hw dependent. Therefore, in your particular case, with the vlan_filtering o=
n/off,=20
yes that would be OK IMO. Any concerns?

This patch merely provides the means for drivers to implement a user-specif=
ied trust
order and report it back to the user, just like with many of the other dcb =
attributes=20
(maxrate, buffer etc.).=
