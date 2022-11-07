Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0DC61ECB3
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKGIPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKGIPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:15:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1893C1F;
        Mon,  7 Nov 2022 00:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667808926; x=1699344926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=thaLiJ7vi0x7G6GW+2OrPIJYhFekx8VvI4EYszG1wtU=;
  b=CPR6uZUXsxzw/R0spRsjKqIclht71qLJ6aa7+IrAiyFKMLbVmbP5qM1c
   9cUJkBZBSMmxfx1Tssc4iV9umAe4Q6LGxjqu2RvhoEXhILKgspbz1E4m+
   OIRcxszC2IDxIbU9Irn0f5tBbwxgmBgqtXaKw1Uv3frp6woNHYjvkOxnd
   ELfGTVbozhqryNrj8SyuK9DRLulFvmodp9pzpHBxJdlm6vv/HQeobUssZ
   TEkiboBtd5Xa/wVv7abqLOxbTI+K1Sv78CupOU1LMvr2kAwWPO9XDyUcr
   6ZTKKrvKuwDOh/HfXGXQx4GzBf5+9sVVU4T68KNIUNXU1A9tFP7xEU4/H
   g==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="122102484"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 01:15:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 01:15:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 01:15:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIbth+Onb/w7KKXoLgTNPNAgt3L67yBK6IaFLGUsxsYE2VhmP75mWyMAp4w16sNYz0/W1Mh347QfnMrkaLY/hNfC4qgBlbmDly0sTocyxuaWrMYEghLkmMuErnLDdaz8MnABGvlZ7Tdo3SGiONpEUqncSWng5d4Q86T3jWp7OwSmbSG4RInDQ1sSSytWHAknpavXqK07bayUVq5fIV1ZrnISE2eUEdgmQnZlh2LBRtP4oVFKGm0WFBhKCgtbQiA9GBy0FWA69LWikrVrJc80albZHE4rnFRlZABNJn+vUhcro7zqnOqDNzpaA6FdpHTjQ49w8tCrEq7CRZMb1Qva3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjkYRzPrdHk/eys/Of4Z3OpHG4HMeUXj99e2rh+jRpo=;
 b=hcNtT2BMSanUTsi6yMTFrIYT23ChiQXHKH+4BNuwDDLI3Wldsi4uFsw8we0I5NSfPh0SezbKdLChO0I7WT+vAF8IYdetGRDwELFv8nojdhqf0DhrTiaQPD9dU5W1Kp2N7us3g1mwY8zpXhKQLbPkyhCL9heXGJQInW2vySvkCa5fMyvYnR7nIsMjVt+aM/91enNnNzC7NlP7HWWdVA2xmjfo6xFoUj6ptzZmp6tTL0cm3htV4qMYQYsk7JCqaZoOBqFxsC/IiIEH7aEkEDGErTlwTVhK1Iaee7eIK7ewsfFeLtlrF1UskWc0E4IVcEW9AdzGwsBeschNeroSFCzgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjkYRzPrdHk/eys/Of4Z3OpHG4HMeUXj99e2rh+jRpo=;
 b=JA4bR8vRpqYn+z2AvL+CMfCW8aLIf8F1S4cbD2Txk0+RxCznmE+KXzOd+DPs22HkNBtGwMrhrFQsL3TbQIIMYbZeSFCyAGEHSdSAlFMuI2UyDcHWug9c6Pv/spQwx/ZwNA9dn4MDaubBujvzYtgAqalcz36Vn9KSXqdCHadF9Uw=
Received: from SN6PR11MB3374.namprd11.prod.outlook.com (2603:10b6:805:c5::21)
 by SJ2PR11MB7646.namprd11.prod.outlook.com (2603:10b6:a03:4c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 08:15:18 +0000
Received: from SN6PR11MB3374.namprd11.prod.outlook.com
 ([fe80::770f:718e:91f3:a045]) by SN6PR11MB3374.namprd11.prod.outlook.com
 ([fe80::770f:718e:91f3:a045%6]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 08:15:17 +0000
From:   <Raju.Lakkaraju@microchip.com>
To:     <Raju.Lakkaraju@microchip.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: RE: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414 devices
 Enhancements 
Thread-Topic: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414
 devices Enhancements 
Thread-Index: AQHY8ni2zP7tvbRhVU2L2nQge6Byu64zHGtQ
Date:   Mon, 7 Nov 2022 08:15:17 +0000
Message-ID: <SN6PR11MB3374392D06EB21F6390FFA309F3C9@SN6PR11MB3374.namprd11.prod.outlook.com>
References: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR11MB3374:EE_|SJ2PR11MB7646:EE_
x-ms-office365-filtering-correlation-id: 82ca99f2-10b2-4526-eb7d-08dac0983491
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QzwpEJEGzOefrgUtXhUG0VwUxIjbFkmhaeNtgsT3I5vKHG/WWTvMiJdOyIAU8ZQIwipD8dSxcRSKVXYLYtb20B4R9M430CIhoKT8/lR+XToWG33q7mgqqvWSzdMy0vpsJmAa2ao/Vq6cMb8HI4q7v4yIe4EPWA6/ZelvJ5E6Va3f3zVRDOIBIKskMVMSD6O0cIQ0qoTGm772kxC/OsTQ0+kRg/SfIn7WUs3rBQnFGXllEkb2zYBvS9ePd08zEI9ZGMzSQ7JtUOHj9MoNCoGA69MXQ7MDe1jsgDx8t2mIoudsmDAIFLdAJwPz08z8CY+G3zaJ9bLwKuDYEVsB0mL0YVenb+HW4y3zCI3ank6/I++YUK7xCRjCjm06ZUoJ8uKiReYdAPSvNI4ZmZXfZ18oB1dr5sp7u2xebrrtFndFFJ8wHtqShsF8QQkUrVx5n/nzT4sG6pUwQO7env4H0Rz5dmrTOuNILI34rr/NDt+buzfr/N+vz06XuK9hviNl4n44wQOSuHUP6OP/K5MAc/VLHhgKq6FCfsiKRtbFtFg2uIHyHU+U2Q59gU3i93oDXtIVCWubaOlDNDNhIvp9Q4kk9aNxgA1U/hy16QSpWXa9gV0OgdXzCKnW+QIh1VCZIZDIeFhIjQckp9nx9NmLkHCYuCla/vv4ZLXWSTNXOElUASpmIQZR2POsGf/mYLvqCYQfImA+8B4BsLMiwbtTdZdkdqbBBKQESX8z420HUrKZcW/ewqQTGi5U0MfWawHiDGuzFjzZ1xG9mtiQn7uXchpPyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3374.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(7696005)(38070700005)(186003)(83380400001)(26005)(8676002)(122000001)(38100700002)(2906002)(52536014)(55016003)(41300700001)(9686003)(107886003)(5660300002)(8936002)(66476007)(66446008)(66556008)(53546011)(6506007)(4326008)(76116006)(64756008)(316002)(86362001)(66946007)(110136005)(478600001)(71200400001)(4743002)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A8sdo/T/W5rOUBjm7wJnvwSLj3+DZD6W/nqU88ejkG6s9FPa0VGAsJshUML1?=
 =?us-ascii?Q?UZHV7vuk4X2gQZuLaoERtl7AV6Y0r8lPiW8oMzxM3CglL0FZGBA6tLfnoXKg?=
 =?us-ascii?Q?8uvb4GbLyCcUgjnG33bUhf0zGI8kes2oIUzR0rwp0IfkqdQGwSV5JHMDnZA3?=
 =?us-ascii?Q?A2NDiyuRACxYh2uO83Xvvfa5seZnxSwcME/88JoGjbaWjM6YXB3dobJ5vdKH?=
 =?us-ascii?Q?//dmZi0FfuvjrnjGhRknz3Vaq2Y9NVrjDFuSQUzNZB2/pheshtrj5b430wbA?=
 =?us-ascii?Q?GiIh9efAeVwcGkHgvpKZtIvW3U5QhSnGctH2TyNW3hsidbQpznnDyi3JJTZM?=
 =?us-ascii?Q?d+l269r4EGO9mXZcqaEPFcANOWFZ6hAyOcOAbVubbkFT7ziXTldTdPbWh7Qq?=
 =?us-ascii?Q?Td2tXbd8EL7Hti5/4jfArEHZMPDYMouofzUVRDyHROtlbaasu8BN7zGoeZu+?=
 =?us-ascii?Q?Pv2mWEvRJGcNKK6wJBY70zxD96uBuwv91QYobwGOLzq4LZgfj/jasLRt7m9Y?=
 =?us-ascii?Q?mjPbo8yzoe78xDybDS7Urg0prSauYqv3rccqpCkyjcLZHpyC/okjqT/tLl5D?=
 =?us-ascii?Q?wAgyEEgnTabUuULgAzqodmiCksfi1QXX2PTn0RpLMvLuCiF/c72uSzhwsJk6?=
 =?us-ascii?Q?aEJmBvo9CWJyjA3c4L9UGdYDCKRpNwyWcgKUhZPy4Y+ueUR9vwCENLmZEvF/?=
 =?us-ascii?Q?JoeyvPTYAutaX39FSN04QduxxemtpwuQaqUiu65rQkx4n0cEqt9Hi/0Qamev?=
 =?us-ascii?Q?zhCpfbe2X07kg9wccH8MxLj+EbffNMs/tPvBc0FwYFEqmBH1+NurPjzQhqwT?=
 =?us-ascii?Q?a78N8Qgy1cqgbfxhc7U3LZYGpfaCl0eaXQ0Mfb4veodo2v0Si0FQfNpCLQCY?=
 =?us-ascii?Q?49bKSkw1VsnAhaJrD3BJ5ycqyoO5nll+7JFtLmL86T3wtrUsVBvVsp6Pxzm8?=
 =?us-ascii?Q?HDvs8L1jEIfY2jAGjglcPNZuFLtwMOAmOA4doO5LCom/NdDB86M6wPrPmxue?=
 =?us-ascii?Q?sUJCsBOdIWrxiKcOr/bAn+D64iOnMURxJLP5m+NTfiYyM3vTbVkXw+WPAtTV?=
 =?us-ascii?Q?Hl89BVuMww8WzvAzUePqdQmRnIdGAOAydWIM5WCmVIq96iBtWI9DDUCvnTGM?=
 =?us-ascii?Q?Vlz0BtvyisrE2FULz0x3W1Qz8W3duM6YP7ynV7w2+7E6dbPPAgK0A2IkvMvF?=
 =?us-ascii?Q?qKREQn33FJjpGFitXeWVLBGwgYBJuwV/AaHb5AEKgDYkGYn/gnw9lcEOZ/4R?=
 =?us-ascii?Q?/rklwzBfD2SGtNT+TU6Ygg35wjoeKy8nQOaiX/Nv/bzjSYjQNIOK1FIjMsOf?=
 =?us-ascii?Q?lb1GgGjpRIHxAB+4IIBpKx5zpRRUU0+ZaSiIwFZnFbP24e5YHR2RiUgAe2up?=
 =?us-ascii?Q?fFShUdekRWJzcQiFHTzqnX0iMjKOK6+B7Z58l6f39MkRHjmR8xS+bZCj2TVi?=
 =?us-ascii?Q?FDCF7Dp3lqqP5iXdU1N1kDuQTQ/EG3OjGj77qUE6qDr2aX/q1j5loCpAF6EG?=
 =?us-ascii?Q?gbHlU8bwlj7jWP62cB1HAn/pm6JvvrBhU9HJTzC3NW3Clfn7rvdwPp+Q8jfO?=
 =?us-ascii?Q?6OPmVnMxqpQsAQ8ZAB5n+f4zWit6yqNG1ZvU140NlAX16h+YKWNJc4posNGL?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3374.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ca99f2-10b2-4526-eb7d-08dac0983491
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 08:15:17.5574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MGpkHcx5km+W+qjB0RVsdZnI88yPmlPlTGDb5Tpqk6c7Fs70GE+JCWoGaf3Il/+ZP0V+Aw7Sa4eW0QakqtjxYifwWW3kqMNibhtYHPh8+O4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7646
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch.


-----Original Message-----
From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>=20
Sent: 07 November 2022 12:45 PM
To: netdev@vger.kernel.org
Cc: davem@davemloft.net; kuba@kernel.org; linux-kernel@vger.kernel.org; Bry=
an Whitehead - C21958 <Bryan.Whitehead@microchip.com>; pabeni@redhat.com; e=
dumazet@google.com; olteanv@gmail.com; linux@armlinux.org.uk; UNGLinuxDrive=
r <UNGLinuxDriver@microchip.com>; andrew@lunn.ch; Ian Saturley - M21209 <Ia=
n.Saturley@microchip.com>
Subject: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414 devices =
Enhancements=20

This patch series continues with the addition of supported features for the=
 Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver=
.

Raju Lakkaraju (2):
  net: lan743x: Remove unused argument in lan743x_common_regs( )
  net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
    chips

 .../net/ethernet/microchip/lan743x_ethtool.c  | 111 +++++++++++++++++-  ..=
./net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.h |   1 +
 4 files changed, 178 insertions(+), 7 deletions(-)

--
2.25.1

