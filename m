Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65C5800D3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiGYOe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiGYOe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:34:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DB17A94;
        Mon, 25 Jul 2022 07:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVflTlb/wDuN7y9JpEkV004b1gLWiSTDlUXRyrjEHdTQ8WI/2wQXHAc2D0OkR7ijIlseyxKsnpHdnZzk3vl7VccXCSDWsE25TYAw0p5c55caquEhgEyq1MyW0IuTI8mMnleEk5quTqg/zR30WurLG34gmKT5wHIDgBV/Uc5NKot5uTnQdFygNBsCAcgPkIdTJyWe6W5+f1my9/BmJjnkOzzgUO6wLJdgfX3nR0R8e7mFV0+8DtNBwiamPKN7S5VISw4E5+CzRAaAo1BCt5cTOPfBpjr2YNp9xMBdYMH5QX+CF7ZogCM8iavl/Wem7LS+XVEwfaNtn6JBn5ePR0l/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9hsDNf2o1MO86YdmcTCZVmmx0JRa8GKJ18OaSuawXE=;
 b=WJwyceEmVrowbEGl3o8/9qz8jvoIBvnybutG3Ckp+5E2eL7pHugXLVeq3SfHvFUiywSXuvf0foca3XPVRchcRFMDcI5XJn+mPI3Ha9ZcJ8b70dKkzSure93WECRNVI4Nhq/RNy+yQI4KzdHKFQBdSGvbGXjaDKZaqURv3inGipPs2ymbFhJOdE8nQz794cH5zG54yNvEVTGqVLCgGGY8/dWC1RvJXi+g/yCa7ZaxJpdfBVOQQF+xzvcmlDGGJcbDUTqsjYkqLuIjbbpAZDC7PhmGZK32D24EABhTUQz4hcIKRTMiX6GUSB4b3Vj/mfEOP++fyl8JnjMkFwjvi+g5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9hsDNf2o1MO86YdmcTCZVmmx0JRa8GKJ18OaSuawXE=;
 b=06bOYoXzy1XQXcJP+bImb/B0VGxoilrUGk5n8GzN5m7rbK91H+NTVo3zJgIU8sGkm++ZS3ydXZmroP9dbSZaIF6tDjQDSRre/eVVqzlmPHF3NepVgALaLAZPO7DqVr2Q4QpGZR671h/ldF1XPIqn9xW82BcLSmkAVyKuu8dPYws=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by MWHPR12MB1566.namprd12.prod.outlook.com (2603:10b6:301:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Mon, 25 Jul
 2022 14:34:51 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5438.014; Mon, 25 Jul 2022
 14:34:51 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYnaLjy2AcewErSEyspw5q+NWPga2NwKqAgAFZDXA=
Date:   Mon, 25 Jul 2022 14:34:51 +0000
Message-ID: <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <Yt15J6fO5j9jxFxp@lunn.ch>
In-Reply-To: <Yt15J6fO5j9jxFxp@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cbc5803-0018-4874-5cd7-08da6e4ad578
x-ms-traffictypediagnostic: MWHPR12MB1566:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rnmWPBjPfGwrsgaFYOljmVcdCr1euQpVtQu/9lejH5ii8IV5RKClKqACQQs1nlwbZsC9DRBqIeBDxZ8uB2dpI2RQ5krBYH6012lo6M3tW++DtxEPJ17FhDKcIK9nYrRsFFkPr8M054Q7QgV2YEt5kbtvvGNGi75CGY27fXXfulUVT/QSUV+7MmhZEbxC7NlClXWhsreRhjTVGeeA6V/tWn0OlinljsaJXLX5zF1LcmXFg57iC+nlvobFW+9UUmebrkFc5OdN4ueawqWWn6V7m6fvPDE7Y9ttPYIDDSJ3c9P/krd+MM7lX6PrB+OEGlY9IZ8lazF2zPRpWhabNENsw+cwOayqUQUN7csgMRBrdgdBfzCCMCRPCWLUtYBFHq+wAcky11hENedRPr6lb/+hhSAGSSQ/WVfODnz6L4PWxmRxfMiOQ+r5IcqWxU7VuKwjAvBKg/EeRSsfFEdWskJlUD7SyjdUHwLuC9IjEZdemEQI1Nbp9RFNpx6/O6MCw41hI+G7w3yHNPrtwrreHKjYZNZXaCZgO64p0ngzZwmKK3dae674lJ0ofNKBYSqKQGw39oVTjZphdI8EEUrvh4QXBBfU/BTFfnkGDHIFnNEioddzzkuGspGgEXDlMlkqJeooBEIN1gEHQ26aOuJEX/circzk5zL/BMDjCIheOImIcEruVzG3liOM8IkmWfDyG0x43wcXLDg6u6B85PZKHXn12Cgqs8OB+x1H7WRWAKO99KvAMzNOU9GD3DEJxIQf0xwV5m4YG2pGU9/jLzGWJXHhYjgVdH5GhNmi0Zxi/kewqqE8yQhSl7vFKsy8w9prpMSs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(38100700002)(6916009)(122000001)(41300700001)(54906003)(316002)(2906002)(4326008)(66946007)(66556008)(66446008)(64756008)(8676002)(66476007)(76116006)(38070700005)(478600001)(5660300002)(55016003)(7416002)(53546011)(71200400001)(8936002)(33656002)(83380400001)(86362001)(6506007)(7696005)(186003)(52536014)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eadGt6pSUOPwaLhFCZIR1ZWOtH9ApdWAtS1GkXyjLoFdaicQVLee1ZVIhXjH?=
 =?us-ascii?Q?bhk4XQ4mhMgfyJChi6sI5qcSlsaj0ULwIkh2kTBY/Bi7KZ6bnYtXoqs54ljV?=
 =?us-ascii?Q?9XrRropSB/tCz6XTBO3Y38rMuvxIA+zsTAfuhzi4IvHmvOao7bCRaHjYzyct?=
 =?us-ascii?Q?IHD2wbUuFjHxhIHer7WoknsM/Y/DYvVuEUtHnMO3pIWXN3Zmij4SnmexI5LZ?=
 =?us-ascii?Q?2ZFQuaInkStH+6CWc6QT0jqRwXAw1j2PHiVa0KQmxNMQhmRVtnc80IvUMKNk?=
 =?us-ascii?Q?I/Yfx0WU/vu9eCVV0rTPQ3/0F40pIxAzWKoDineFjkArVOEbMmHr3qgc8bRz?=
 =?us-ascii?Q?iQYHjfkfpwYAXTPozW5IYG1+djnDcX4cna05PzILlfPeDw03Lwq8CP/c8Hw9?=
 =?us-ascii?Q?pPUs9koWI+mlHFenu1a8Wu+GG/ptFrANek1HJtgzFXgYXzU07iGmCeKdomQD?=
 =?us-ascii?Q?XUs0B5GCPLeAAyS4xqMpG1NrbSOsCrf2iSrzVcZoark55gP4RkG/AngWTie4?=
 =?us-ascii?Q?yfX+cPa0och23BpoVDkEagZp4cf3IfOR5N1sXvSWd4GEDkIxBEePBm21YkyI?=
 =?us-ascii?Q?xhUX1D8KCR+kiIXg3KHVLSt6qimBwiY2Pstys2psleNDv0a7uH+6NJ9qYOQT?=
 =?us-ascii?Q?yC9RxQR1mBVZ7DC9x344Okn94oOKPk307rvC1LSsP/LjYmw8JeNMVoKbMeeT?=
 =?us-ascii?Q?g9KQTw75IYFGmt4LqFCh+OWG48tEoFAGbsCRqA36tmo7pD7aujM+VDV3Tv5b?=
 =?us-ascii?Q?ru4JPOZaW2FJGT5Swm3kcRlTvljS3nYqSocqoq1WuQOh8YssQjTOTjs/Upj6?=
 =?us-ascii?Q?AoFKJUHjRhM79x9vQF/2ik8zsyj5fuwgvRZ9IvccYpLusbYFVGwasWuQtEPH?=
 =?us-ascii?Q?526apppQWYLtYmLsn/4fBf/ygagICf6vSe2g3/hcdfh5QncZmoTj7rOKQBmT?=
 =?us-ascii?Q?l26zpdoNElgMG5qUzRa0VlkfoizEKag+aIsDbm1+lNbjpH4X87xpKoXsddqh?=
 =?us-ascii?Q?n+hIYPM7whHG5w2PikqW7ZZGHemmpYi+4rHZQS4jsMXtT5V3EWtIk94GN49+?=
 =?us-ascii?Q?7HHk4JwPaXjs5xGwP+v7LjIGEjEepnQAqiqy+ALZl8268vaRxa51h9fQvhj0?=
 =?us-ascii?Q?c5EbV1sU1KxWNXr1MMGGSdIvNFi0Av3OzH92ehOeRqYmjXUfiLbE9Gy83DHU?=
 =?us-ascii?Q?yg0F+Lhs5vqj4nZWoR6GM+2FoU/5tSsMv6XMxHc0ZDw4Jq8UhVP083tgA0zA?=
 =?us-ascii?Q?tLVtWzaPEkReJDoIaEw8nDDJliA/UTzi97N5DvHKRQh+XaYdUAokvhIQ6n61?=
 =?us-ascii?Q?fT+7LCdeyr7makRAdsqXghg2qT3pKs/1vc8BtwdFgnUJ8Zi1AmvbYeMSOGlm?=
 =?us-ascii?Q?8f1hzaD94zF7xEOvJ/vC+iPLJuRw1HDchHk5zfamvkgRO2yzWttQLaQc1bho?=
 =?us-ascii?Q?p5Qvd48R/ZtlbY6XjeZ+J06IEwc6VrxWC3YPOcbYfeLpOUrQEf6hjgk0W/r3?=
 =?us-ascii?Q?KrdoOk3ZkkM2dicCZWRvHSuLhCvk7SiUSa1lfWUasaHq/G28GLae1HQmHSc3?=
 =?us-ascii?Q?Z0lDsvnw2cPM5AwJpaGUUfHzgoodITXgAnPKAVPwa9u3IXViyULUK8fqA/Bf?=
 =?us-ascii?Q?1rr5iBK8VtyKR1SdVGhFjJk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbc5803-0018-4874-5cd7-08da6e4ad578
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 14:34:51.3791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oXv1AOUNCTtNFR7azit/T645EW3xx1aN3fOFWluhq4WDWEoWkfjDhbZ7bD9MfvAc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1566
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, July 24, 2022 10:24 PM
> To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> claudiu.beznea@microchip.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
> configuration support
>=20
> > +		ret =3D of_property_read_u32_array(pdev->dev.of_node,
> "power-domains",
> > +						 pm_info,
> ARRAY_SIZE(pm_info));
> > +		if (ret < 0) {
> > +			dev_err(&pdev->dev, "Failed to read power
> management information\n");
> > +			return ret;
> > +		}
> > +		ret =3D zynqmp_pm_set_gem_config(pm_info[1],
> GEM_CONFIG_FIXED, 0);
> > +		if (ret < 0)
> > +			return ret;
> > +
>=20
> Documentation/devicetree/bindings/net/cdns,macb.yaml says:
>=20
>   power-domains:
>     maxItems: 1
>=20
> Yet you are using pm_info[1]?

From power-domain description - It's a phandle and PM domain=20
specifier as defined by bindings of the power controller specified
by phandle.

I assume the numbers of cells is specified by "#power-domain-cells":
Power-domain-cell is set to 1 in this case.

arch/arm64/boot/dts/xilinx/zynqmp.dtsi
#power-domain-cells =3D <1>;
power-domains =3D <&zynqmp_firmware PD_ETH_0>;

Please let me know your thoughts.

>=20
>     Andrew
