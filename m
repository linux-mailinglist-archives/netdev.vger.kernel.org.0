Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C835A1F85
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiHZDux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiHZDuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:50:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91631C920;
        Thu, 25 Aug 2022 20:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661485848; x=1693021848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=td98zNr5wsFT7O7jHwhkz4+tNVzJ0adxmJ4nSNfZPV0=;
  b=ZNlGwmd8apzWgOefMxRLP+UQBf4xXCRYHdru0qZqbzNkxGCfjEN+hRyV
   Y6aJhX8zoQdVc+N13jyYvxED2BfcnGwXW+ouaUDTRTs6PSIY3IZDvyNjX
   B4vlSbBi4mw/0JXmkX5eM4jPFPGRzjrXfRboij2NrGpU9ZrJfJtmkx1TF
   YhPhDJOwsSFNWWefFw2uWXnwWXYmPuP1m+8htknBytsx2rbgVl/OLD67/
   FreXe/b3/F4ce1gNFRHhhPqfywIi7TzEbsW3agCIvAgy6jxovb5zya61r
   WHPYE9XqdmhL++iin/nhxMPqyWb4HdVJ7v0WeHQDqAfeZWx7zPFcsT7Sw
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="110831710"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2022 20:50:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 25 Aug 2022 20:50:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 25 Aug 2022 20:50:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUPw5Vc6cshx8jflVzLYffxsqyVTY3DG94y+w2gK3FXiXrxKkKxEZ3pSdTc7EHxclQIwF6uegJ1ZDu5eXrpfYu4hYp7toillrS/sPRu5btDmTavIGFOJvZ7EU07++4OhwPo/woOSIF0phlnKZiSZSNAIxXmuM5Ks3UEco9moZBbcRbSKXgwn1vVyhbpFEWm/VnjRQ5aQ0uktHANnMWrn32Zpl4FZx2iJK2fHoR/lc9pSL6qHTXqHevQZCJggjOGuuAxjtyMwV+0aOLMU1ErHS9D8AHyeoOpbOzBjtZkg4WIbfSk1F/M1zSTAhR/G0J2IN+uu68ogZH42fqHFfFYWsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rB0pklRPqb8S1B+S8KxbbNgpvYSahx7kiIK6pxRAb2s=;
 b=hwAt+KrH0eaOp4EVnjwgWCeULrta4PP1s7VmDpbHWtDwyDBOnad2TZ9y0Xx4LpiCoFCKB0h5NIFTK3lIi6jFUmCL8r9cTR4Hu92/5f6OPDLxmmTSyqzzRHhlqiwpWHNFsV+aaFDhMkprgIAeZVOahhPZkNlYF0UUB1RuCW5EEhbDStb1XS9Oqr6dYvNlFSGG9F7qIWJpCv3s3yh4BR3vrbTdLfCij20gdXhDNY72vrl3U0r32HjGkrYleSkwf87D0h0yQMXms5t+M9ianSSncVTcrCngOps6F8krGPWY6xBHT7wp/4mglTnIgvox4yY+47fCcR8oUkFTSYHBkirz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB0pklRPqb8S1B+S8KxbbNgpvYSahx7kiIK6pxRAb2s=;
 b=m2/doeoVon7gcfAPFGjWfFM0UnJnkdbpZ5LSSqKVB3pBtHmWWYW6llv6V+rReIt14f6Vi9JwJtiS1yxKljrecCdgCRZAXXtxLA3/OBcI98iMKIS6muMjOkp/cdt/W5IPmC15meJxdQVF8ZG3WUP7SuFS65x1HCngnc5zq0Sgmi0=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by SA1PR11MB7088.namprd11.prod.outlook.com (2603:10b6:806:2b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 03:50:44 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc%9]) with mapi id 15.20.5546.024; Fri, 26 Aug 2022
 03:50:44 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
Thread-Topic: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYuFmMgzj2knw/J0+AGHw88JSECa3AKZiAgABiu9A=
Date:   Fri, 26 Aug 2022 03:50:44 +0000
Message-ID: <CO1PR11MB4771E1680E841F91411AE6DFE2759@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <YwfvaSFejdtPtZgK@lunn.ch>
In-Reply-To: <YwfvaSFejdtPtZgK@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba62f2c4-9786-40fe-6efe-08da8716276f
x-ms-traffictypediagnostic: SA1PR11MB7088:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zk2fzvQDqWMRmkFLKbUYOmGA81Ur5pRMHbk0SsKA3FpUhpxhPOPgZ0cZuMAw6IstXG+xzO3zhM8AdyIXFeYxdVj7U/FI6R3//dgGpb+zcana3mhF1FsbZ/nLZhCD2OsxjVmMsdqBodnUM4iSzqpVq1Vl0Bi3T+fQ/4yr2/kLp7rMqkgFg+GsQF1fOEXkmTd1q3NR+ArPnDToxnSG7G8dBIHSvBw0L922V/wdwPxP+ik5peO8ujiediwFDwK2AkYJgwwAn/mIBE5Cueu0jOb7RAkjyDQCH1mCovv6NN1d7+LU0uQpjhKJOqSLW3Bk6FhI5sWmtqd6OOm2XdQ4btOZLK+MMnp/eSwlvICkfRi+zDSuRGd7kIHe7PrIjI5jGpzrJ/GC43KpEBuYypw0nIim5x6IeFCM6FO6uYW1qOo65ZNwOitJeElFaX4zvJIydnld3/xCICKtcW9iuAU/69HhTqGtD6SdpkDibV9C/QOqk42Sk/0uitChV2aXoegkSI9mwFhos8q14sEis+NzWea9y3SZpMpZbj+TdHgiyy4rBOCq4EVGZXPWay1kcmON+m6uFowURCUU5c656FbGwV8MmekdBqYi9uWHPXoMLkeNMOVmy3fLeEDHxhkudD3hqi6gbcSgbIJmwDqfegkcaxeQAsBAx6o2sepUUPeWt6QD1ilAH5btmUrTGYqZsy3rMs2V4KYOqOvu4AUNrgHlLsijL03dRSgph6EAMDq/zi0VGmIUzdJlcMSz/QJr1giix6Mv24HCjPFXQazr5SqWKrJRxajzgFprpY8B4ttljiokVWk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(366004)(136003)(346002)(54906003)(38070700005)(2906002)(71200400001)(52536014)(41300700001)(8936002)(186003)(6916009)(316002)(478600001)(86362001)(83380400001)(64756008)(8676002)(66946007)(66556008)(5660300002)(4326008)(76116006)(66476007)(33656002)(55016003)(53546011)(107886003)(6506007)(122000001)(7696005)(66446008)(26005)(9686003)(38100700002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a+ZEBUrwXU0G9uS6omWejopOaJ7bL10QIe4ft7HDucnY0CsL+Wzo0ifUuRk/?=
 =?us-ascii?Q?YDZ4KPV2ykhlLI1ev2sAXVT8jg2+4z+J8LdrX0WofGhYYkLtHMZ4UcYfPYPx?=
 =?us-ascii?Q?gQvLnDU9dajKUVvEmxOXZsnWQbIaoVvHlPIR5di05KUsSc6V4aI3YXdGcr2X?=
 =?us-ascii?Q?v0qBh6pTvNYjMOzLQ7KrPf0qWRWVUN01LmvfdEY5BtGqItNFYzVzqIzAm55q?=
 =?us-ascii?Q?8UKqJggBThRQr9y6iyNMXGADg9wRd9EMM0B5qVP/YGq9vCxcdBQhW9mlBbXm?=
 =?us-ascii?Q?6iTQlHLc9rDjI1ddJo4fUzgmkQ3ag/xZUhC/iXrHkXRyZsss8JLOJRVmROT3?=
 =?us-ascii?Q?3Nz3GX0+HZQxgx3nLthrV/UZ0RaDkUv2WSqcFptDWzy/xjgQvH0AvPkDpHxU?=
 =?us-ascii?Q?9Mjv6m70kK3hZtYhn15gPUrtPzMCkzGO1S84cXK0kabgDH+udIfF5OYexsW4?=
 =?us-ascii?Q?14B0LYUA3qNeSPAd3OGJ112pouWzDgoeMvRcY0min/thpMr0CDj+GnH9PR1q?=
 =?us-ascii?Q?FSqX7WIqVo5Bq87DpCAJeffQ2RuyfbA5Or7iTcDP6TUpkmqbHx5G8S6jMIVE?=
 =?us-ascii?Q?EN4HEYyZ8+RLPIyqWcSRaG/9K/pXaGJlW7NApP760JqAaVos6MgVW3oq0++8?=
 =?us-ascii?Q?HCxhvPYiJSuRs/On/x/9mxWQoQNoDwjmQxZqjp33whltkiKxfIEfxjcDu3GJ?=
 =?us-ascii?Q?SFYcUy0ImvfUAWC1/yC/tOlfMEopfq6cVaRDNp8/Tddyv7A154WcI1Fn2VMS?=
 =?us-ascii?Q?0izgPIQMhNI7aB66JzvQHce6G8QyeGokTZJh8zgzeNRTWxDFvguQKyrvDEa1?=
 =?us-ascii?Q?62A7cMZYiuftacZQkdc0IAhkMB72RXvNhk4LsmFYDo2lBa1VmTB4Fd2ds+Dj?=
 =?us-ascii?Q?/UpiFrJrkPl69PFMJRmG8pWlF6ZDoy9B9TafI1Zg49/h2vuwHvCo3sLnDu2g?=
 =?us-ascii?Q?P6DvljJEdxU7TUdegJMtXVvgOkzxlye6Vu9mZtapGnBJDOuIoppXz08SUY78?=
 =?us-ascii?Q?2XZazl3GuHTosHv+/JYwOaiJZQih2lkDkDgob5qPpW9nK6htQ7TzI2bC8eNR?=
 =?us-ascii?Q?zlQD5aZspZ7H4+d2JcLzekbs1h3QolMVKlqWPlNQ0+rUE/3GBQVqrrCs2IQp?=
 =?us-ascii?Q?jndvzl3yabkXrVkoJ4VguNKqwymr7/viY3e/IiJeGAGT//RAyJOEaHjtLJzy?=
 =?us-ascii?Q?DfW7LxNdfRdBzwZ9TINug930q7TqFvZzLB29Wa7K3T1Sx8V0nyvvRCFHkY4A?=
 =?us-ascii?Q?k+VPcJuhQKE+WePpnHv2NzIGxwfHK6r4ct4NS7Jx0YuUZRi68E5XUsbq95Bl?=
 =?us-ascii?Q?tIzDeFYvI83M8MXS0+EiUI96MyX2RKoe0gd9e7u6WYgnJaIWjzZ4x77Tq0ru?=
 =?us-ascii?Q?TEwlTaUR0hFL33giBl/X7Rr31dvr47WI0h7Z4z1noO1NZyYeyvD+nCl3NfTV?=
 =?us-ascii?Q?eGcM7pgxabzLBS+/4Duh3yuisYQwNf8B7Xidb/PItbHVE0TpCdDTCp/U+4b9?=
 =?us-ascii?Q?CwkvjC3n2mDykQqzbixHJ/IPpYclQOpi9wYzNJgkUBHpktWihGYRrgi5aQ0r?=
 =?us-ascii?Q?DPcxcwJn1fpHR9Wz3xauF/e28/d9Zy2ZvU5NqtdqKh+Qo7e5oH2QoBcGuQWk?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba62f2c4-9786-40fe-6efe-08da8716276f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 03:50:44.6366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wo4+G7YCyGxHfUyB0W7onhza4G8TfnJTFrUoCxaiox1TEQVii1scHJ2ehgrf8yT3jp6qHilipeC6c9VG+npoeClvTiL7OoCCIXiIWUSjX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7088
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, August 26, 2022 3:24 AM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > +#define LAN8814_DCQ_CTRL                             0xe6
> > +#define LAN8814_DCQ_CTRL_READ_CAPTURE_                       BIT(15)
> > +#define LAN8814_DCQ_CTRL_CHANNEL_MASK                        GENMASK(1=
,
> 0)
> > +#define LAN8814_DCQ_SQI                                      0xe4
> > +#define LAN8814_DCQ_SQI_MAX                          7
> > +#define LAN8814_DCQ_SQI_VAL_MASK                     GENMASK(3, 1)
> > +
> >  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
> > u32 addr)  {
> >       int data;
> > @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device
> *phydev)
> >       return 0;
> >  }
> >
> > +static int lan8814_get_sqi(struct phy_device *phydev) {
> > +     int rc, val;
> > +
> > +     val =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> > +     if (val < 0)
> > +             return val;
>=20
> I just took a quick look at the datasheet. It says:
>=20

I'm not sure the datasheet you looked into is the right one. Could you plea=
se crosscheck if its lan8814 or lan8841.
Lan8814 is quad port phy where register access are of extended page. Lan884=
1 is 1 port phy where register access are mmd access.

> All registers references in this section are in MMD Device Address 1
>=20
> So you should be using phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> xxx) to read/write these registers. The datasheet i have however is missi=
ng
> the register map, so i've no idea if it is still 0xe6.
>=20

I hope above explanation gives answer.

>     Andrew
