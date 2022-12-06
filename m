Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8646449B2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiLFQtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiLFQsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:48:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F8DC18;
        Tue,  6 Dec 2022 08:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670345296; x=1701881296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7H/QTwy8ir6BiMarto8ov00HuhlEA27MM4+Kgz6E6tQ=;
  b=MYf4jGhJG7HfQWMYxfTavR+SZkHyJY8Oaqn/JlGD9ROKTTTqFIXkz3S5
   OJNyS9u3j9YMTPzdqMEnHBr+XYswjIof24nRr9+hEZ7/MHIOMqxQOJd4J
   oKv5BrwRSYJtROGHfXbzwQQOth86mk5v5TzR+QppRFwDkk2DD37lUWc+u
   RVmN12sO/U/yeJnYa7LlYgiE26OPqe9HY4deXw5YWBzsCLj+FXwUaquBw
   n+S/J3Z0Jv9vFZTFeTDs/0V+SxKYJn46AR6Hx3nPx1HUQT6PR0PO/Q731
   h0VFpNCitCuMDqQhFqvxV4/Pls9zHvcLuT2/a4lSV25ljn3cj57HqFJ1M
   w==;
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="191947333"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 09:48:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 09:48:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Dec 2022 09:48:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPFhsj+eUBcIyfl18/63d+knXM3hsdycY92LuKrPupqkWieusGm3k240cg/tKxnQ7OScN0j23sprCzKr4NS0DTncwon0Hst/jgyyl/i45Psvfg7CUQvR+/rCAD8W/oSAPGVevwfa+95LSRqBsLekHr9keS/zj1YkHumJexv2P/GFF94wxKz8ngE1bGPmRRFSkBDwdCnRMyjDHto7HevaGzbvsSbeJ80HF0qDbh/nGBFU+X787/jla+EL1DZrK31/2o8Lc6czOgfkhJZLc6XijWoiHUQQ/zzvxQ7LEafBA3FrvYIJrFk98YxUaH4pWZ/iEVntx254Ojft5O8EXYFKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bxAlXvg6SqxPG+Ej4TBOX7B9XCxGWE8wMGUNCA1af0=;
 b=fSr+KzCQcI+ZOpHDrLkeMahOYIz//QeryRIOLtmU/6LJ5hsX7hLt+gXTGhQv6h7Ceqgad656TOCPx2PlJUSzHmze6O/O8jhppUkqgKLagPEfkb7O3N40jz2ZQttmDAFRKqrLnYqUbkSsrsiuZSq/KVKzl1nXttSVbXjbplKTliinSlWxbCSvHm4fMbBBh/bbMO9YRSoPefsIxJBCwDM/4w8SSzrhqWiTtB3xgsOcZjRnQgChkuaknEYapfatWxOqY9J/l2SsJED5NRyCTDEBeeY9Bd+QVuiNhG1wiNZ3z7ftqyo+7woeIz63Xk9O0QRUWodyY7awBw/VqlnTFMv4Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bxAlXvg6SqxPG+Ej4TBOX7B9XCxGWE8wMGUNCA1af0=;
 b=e+BLSQgLqD0g3g087Oe1Kag1m4YbQNaH4JEZjgSD6tetlxPICoV+LJqhL9qTp/TUK/o63hfKvEoSeLEpVaMj5kaIlNioO63kSxQQYv2XzfarFB1zlLiKz80QVa+SdaXI58CdCbMbrePLOZQef5q9NoFVa1ELWF6KHeNo7so5mMQ=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by BL1PR11MB5493.namprd11.prod.outlook.com (2603:10b6:208:31f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 16:48:12 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 16:48:12 +0000
From:   <Jerry.Ray@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] dsa: lan9303: Move to PHYLINK
Thread-Topic: [PATCH net-next v2 2/2] dsa: lan9303: Move to PHYLINK
Thread-Index: AQHZBoLNizWF/vluhkC5EP67e3Seoa5bAs2AgAYVDfA=
Date:   Tue, 6 Dec 2022 16:48:11 +0000
Message-ID: <MWHPR11MB16936F7BBE2130CA9821B8FAEF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221202191749.27437-1-jerry.ray@microchip.com>
 <20221202191749.27437-3-jerry.ray@microchip.com>
 <Y4pX//cG2Hq8NvbM@shell.armlinux.org.uk>
In-Reply-To: <Y4pX//cG2Hq8NvbM@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|BL1PR11MB5493:EE_
x-ms-office365-filtering-correlation-id: d819e2a6-4ab8-4b1e-a41a-08dad7a9a984
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uqc3s/xMgRsiE88CZJJe0C2QjKyCtKuqH8sPAb4Pt5SLVQTez/1fkG6wvnu1T72OPL8zWqtTzAO8y4bEcY+zuktElpeFqLR1Mk8aVmSo9yNpa4/08d9RAMDszo0CioneicpZOxrPsmLx9JWH/h2Po5t5SOFTnzEgeEGtOVOW5xcNMFqxRzuYfRPHRPPmfqPvhrdswxHXVASImgJdekPpbB9thvHXkmTYejzgMcqtExRli4+p4vCS9a6Gfw8CeMIRxW5oCeMaf2MX8mbFCuCQmAMl2OS8PI4Wae7jRJTQHm8Cck2NwTYuKuN+MfA0rW5TElIhMXaVtaGNPfCMXmlC7L2NgH+R5EkGGiwgk0YIjy5pqgp0AmbN8ZOb1cK+XclyMj0OoLDrcW0lLwqzrzcZHuRi3dNZZz6OoGtrXs0xaY8BOb1gh4wpKXrqsXP2Y2+Roxy0aYF2Yn707Yo5nlfrCBpgaKXPHKq/FMcTKiNuQ/yM6x9j35abHU2uoecwPR0fU+ZnmxE78Q3A0sRHiwi5Ad4Ewnui8ps1fTGSr7cw9wgJ2rzXCf9HdiKrT8l86mJWmma6Iwo/QZiH7ovoiqfnUyaVJ7V8hstO7EkQ3mudNQJtKtQlBkCQhqIr8saeym/RR4gM9pVgaPBWHe7+cxPFqBqDPquMAHW3GEn5Fn9aqgwrcZl7Oea0uFutTnz2Sp5H/md2KujT/dycTUBiIohRJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199015)(83380400001)(122000001)(86362001)(8936002)(5660300002)(33656002)(38070700005)(7416002)(41300700001)(4326008)(2906002)(52536014)(478600001)(8676002)(55016003)(186003)(26005)(7696005)(64756008)(9686003)(6506007)(6916009)(66556008)(66946007)(54906003)(66446008)(66476007)(316002)(76116006)(38100700002)(71200400001)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vNC9Rs1BN4i529br/YdqUjl2RgSCsIf9jAbXmnQrGWqqrP6moOge0O1i2Ieb?=
 =?us-ascii?Q?lxS9gdeO7M6L7S8LQEWMg4qjrb6XYhMCNFx3z1rCJ773mrL3G6WhMFr1Xyg/?=
 =?us-ascii?Q?D0hlPWD3cFZCQyMpB7ftHNDNWWhowiFG2xJPeLCyyJfluIkd9fXMcZuVnTvf?=
 =?us-ascii?Q?Fq40HkKIXOPP8pnGO1OUb2T9pG4qMaFDctP1ndWUzqdQI2n6xQz6kUouIa9X?=
 =?us-ascii?Q?Iot3zLBrBKsJOaZpujoEcKjmVRXumtHEq6zZKLoJDOYERU2opqC28FJ5eoLu?=
 =?us-ascii?Q?ogNU3MaxDkMYEt2MkCw6RPXib8XK1Gudr8gCN3kAEXaNoe0Zm9Mvzyk94BSo?=
 =?us-ascii?Q?gGV3DojPI/qLtEFbCBDoDYuLiu38gQSE4ce7pdl7zV3fHaZyO0GAP7XZXOou?=
 =?us-ascii?Q?Of97TE2IN9kbDZpVVKL4CziXR8F6fjxOY1dwc0DZofLp1xaFAlS/TssuNocl?=
 =?us-ascii?Q?/k2djEngrTs9ThP6jGvnUIEQ4CEuVM58KdzoqltpffKyHXQ8VT3JGeO+JMZu?=
 =?us-ascii?Q?+SWr0Pf3WTvdijZIhmGM2s4ObRMQ8Ns75qtXdWNdg1Qm7LCtMTo1D5RcsGvj?=
 =?us-ascii?Q?sFxaGpUj0+u3rpouhgqbZjZ1AIqDfBOrH9IiJEgWcD+K8cvEfJpLH3ineEAV?=
 =?us-ascii?Q?9mesljczk4xR8J3W3f9HwE4AcmPi0CLBvH4YU+9FWWeuWQO+ADAQz18RfsGa?=
 =?us-ascii?Q?KugPfUIwbSUww/Fcj5ZH3gFDZ68IDIGhvlosMEeM7oevQ8MwvHwQaAVbgvqx?=
 =?us-ascii?Q?l2KoYlK3GNhzZiY9OYmdh9MWu2Meo9k5Ab1m93VvFxCohLfWtwzw6WoDxy9a?=
 =?us-ascii?Q?LPTaTiRC4yEk8yajRowmEtZcMdGAGOsA6g7ABQn+OW5z9DVZ2qt8bemCgNov?=
 =?us-ascii?Q?ADqe77Al7twm/DCtYGoCC8q3loWvxMCZG65zg8Rvi0HeT8rMnhKMvTgl9bzY?=
 =?us-ascii?Q?E54gGVs6JwXRP+ZY3z+TOjzdJuFt0CgQx1Qu8n2BU6tVL1Tn0ZcljXaIM9tx?=
 =?us-ascii?Q?ZtLvrQLNj6ZgEb2FtxADButJ3LscIm5rCsdoWPz6VaT/p4Ir15I/jRu0jQFu?=
 =?us-ascii?Q?R+NJ/VsseLABHhO6epCMVq2i51It/l0PtTGAu8zHets+lG5u6cuFNa35Uazx?=
 =?us-ascii?Q?8tE5wwVdM3EPC7RlB7+10Xe0Wb4O8nEBGunSwZJy7pIjcjm7E0Me4rkCkxyj?=
 =?us-ascii?Q?0Ha75ZigRjuoBRAkxPhc8xHBvz3VmlTMhPZk3/qv4+t4zuqyx29AyvUuwaQk?=
 =?us-ascii?Q?+nzaB5DxNlkpxhq5proSfpLoIlfOiCYEhPbQJcbmXfeeohKk429nii3Wpp0P?=
 =?us-ascii?Q?WVNjlo4lpf8myF9VCs+RXpA2ck3Ka55sEr5TzLE7VLDTLDOcA4L7bpCdlHif?=
 =?us-ascii?Q?BkuDztvB3tkUMJXAPwUOt3U4WUoqGqhKfrvvK7EUu+cAD96vrZQGJXU9grgR?=
 =?us-ascii?Q?/wnwf/bfFrRbhRnENIrirKzmXzp1G/88I8k64PunnVJJxDpEiNg+sQaOv3gI?=
 =?us-ascii?Q?WI81ledqUnTovBcxVf8k3QQ00XJdCpNWPV+mcyWMkM56o2N79YtpdubYMV+K?=
 =?us-ascii?Q?xXMINjF40cQWKdzDKMi143olgEzsLrIvlCtyPq/O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d819e2a6-4ab8-4b1e-a41a-08dad7a9a984
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 16:48:11.9364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/6YV5AZaKgblYBbKHt8LzCZ3ZNvB1VZNe9mp4RwwePozvvUcdpjivyxjDq4PIvmCz7au+MsW5WdHYu5WKsYLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5493
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>> -                             struct phy_device *phydev)
>> -{
>> -     struct lan9303 *chip =3D ds->priv;
>> -     int ctl;
>> -
>> -     if (!phy_is_pseudo_fixed_link(phydev))
>> -             return;
>> -
>> -     ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
>> -
>> -     ctl &=3D ~BMCR_ANENABLE;
>> -
>> -     if (phydev->speed =3D=3D SPEED_100)
>> -             ctl |=3D BMCR_SPEED100;
>> -     else if (phydev->speed =3D=3D SPEED_10)
>> -             ctl &=3D ~BMCR_SPEED100;
>> -     else
>> -             dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed)=
;
>> -
>> -     if (phydev->duplex =3D=3D DUPLEX_FULL)
>> -             ctl |=3D BMCR_FULLDPLX;
>> -     else
>> -             ctl &=3D ~BMCR_FULLDPLX;
>> -
>> -     lan9303_phy_write(ds, port, MII_BMCR, ctl);
>> -
>> -     if (port =3D=3D chip->phy_addr_base) {
>> -             /* Virtual Phy: Remove Turbo 200Mbit mode */
>> -             lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl=
);
>> -
>> -             ctl &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
>> -             regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl)=
;
>> -     }
>> -}
>
>Is this functionality no longer necessary? For example, I don't see
>anywhere else in the driver that this turbo mode is disabled.
>
>I'm guessing the above code writing MII_BMCR is to force the
>configuration of integrated PHYs to be the fixed-link settings?
>How is that dealt with after the removal of the above code?
>

While it should be disabled by the HW config strap settings, I'll add
disabling Turbo Mode into the initialization sequence to keep the driver
operation consistent.

>> -
>>  static int lan9303_port_enable(struct dsa_switch *ds, int port,
>>                              struct phy_device *phy)
>>  {
>> @@ -1279,6 +1243,41 @@ static int lan9303_port_mdb_del(struct dsa_switch=
 *ds, int port,
>>       return 0;
>>  }
>>
>> +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
>> +                                  struct phylink_config *config)
>> +{
>> +     struct lan9303 *chip =3D ds->priv;
>> +
>> +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
>> +
>> +     config->mac_capabilities =3D MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
>> +                                MAC_SYM_PAUSE;
>> +
>> +     if (dsa_port_is_cpu(dsa_to_port(ds, port))) {
>> +             /* cpu port */
>> +             phy_interface_empty(config->supported_interfaces);
>
>This should not be necessary - the supported_interfaces member should
>already be zero.
>
>Thanks.
>

Yes, I agree.  I'll remove it.

Regards,
J.
