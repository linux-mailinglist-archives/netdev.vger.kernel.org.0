Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FBA4A779E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiBBSPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:15:04 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:35858 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbiBBSPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:15:03 -0500
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 212H41Ym031505;
        Wed, 2 Feb 2022 18:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pps0720;
 bh=CLRgkx6tS0unhcfLsbT1wYeVWshYsD96dXD1lD1cYAc=;
 b=SfTYP2fLgNYKqOJ5FiJQRepC1edmD9UCONAfv3zuNq+N9kotArdNhlCgksCfW32iIimJ
 6twGfg0I9y4h2nJ+EStNuNlwS/eIcHMsKqBTWvUcHnOBf7dY3cb7oYPjCeSz8Ogs08eo
 h8dpYnX9d3fpuo6g7cfWnLQ9EMNSbLA5mrw4sQ9yDq5aZta6aH4ATlz2FTwt/nAQW8a4
 iF/oz7ZjEkazfpILdoOM715d5nTWm9VbuXK14+zmXBWbu21ytCNfqvgiH80UW/bYJ4MN
 HzvCQLeJt15kA4jNlw3Qw29CfFYqYgWSXhSpVo4koz/GLex9D1MqIkf6KjwRO6rPQUpo eg== 
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3dyx1brn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 18:15:03 +0000
Received: from G9W8454.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.216.161.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 21DDD8F;
        Wed,  2 Feb 2022 18:14:59 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
 G9W8454.americas.hpqcorp.net (2002:10d8:a104::10d8:a104) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 2 Feb 2022 18:15:00 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.241.52.10) by
 G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Wed, 2 Feb 2022 18:14:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjwYKVQWJeKQS+8pIW7yu+ubl2orwH+ZVm/kcQQC3u0PzsWDvVNPE9hdhAky5FFQOgSZJntbh1BK5/7dhnh9bJBoeXYkyEs9l8LjrPMxSqqeJgGBguzRgaSqb55ERxoBeAKThP0RBfUbGqnA7AvKgdqpwB2T1TVO3cbAw33MFwPM6brGXYIzEcPbHbsk+2WIK0oSUEVxxSDM2EUrjOLZ0o4Xa08gAef7IoVYlGenVajctPH7W/koKNvQmG9nVYGPZWCyuzX4ccseNsmzi5ziyUWK8e/4walLMP3JHyZlU/6j2EAob3snxB5sPDqDGXv05T/FOm2aLZ7H0alcBB5/nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLRgkx6tS0unhcfLsbT1wYeVWshYsD96dXD1lD1cYAc=;
 b=OrwTfcJ5jQuEMRYjN4Nonb/zgKcP0g0OGA3TALTlO9sreFL2auD7Olk686Ghp2rq+2bOOy6hzGIq6svk0cE4oSO07ayFLwNq/Uy6j7L6g9qNskG0b9WGGCooJgBiC6Z+YK9wyTIewPI+5HRbQRgtR0j4Sn8lXsXvzaVC43ySKogkvYoYiMOp6rzdUyMdfoa2kFGlTEARE+I8BfiaaDARLgzdWB3r0uVdtfpprjGFzyjDUXxnaUPSehv0pSbCUuZlzPdYZ6KTwZJRtXsRnKDE1efet+1UwsnKqlmsfccZvPxyhkejI2tpUAsJOevZqIfJBvtD1sNXsifnbiEH0rvebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM4PR84MB1976.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4f::17) by
 PH7PR84MB1838.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:154::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 2 Feb 2022 18:14:57 +0000
Received: from DM4PR84MB1976.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::b84a:b07:81c9:881f]) by DM4PR84MB1976.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::b84a:b07:81c9:881f%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 18:14:57 +0000
From:   "Verdun, Jean-Marie" <verdun@hpe.com>
To:     "minyard@acm.org" <minyard@acm.org>,
        "Hawkins, Nick" <nick.hawkins@hpe.com>
CC:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        "Rob Herring" <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "Lee Jones" <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "soc@kernel.org" <soc@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "Stanislav Jakubek" <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] HPE BMC GXP SUPPORT
Thread-Topic: [PATCH] HPE BMC GXP SUPPORT
Thread-Index: AQHYGFWhalWR7e0Ubkq65+wBTOCNhayAi8SA//9/BAA=
Date:   Wed, 2 Feb 2022 18:14:57 +0000
Message-ID: <3E9905F2-1576-4826-ADC2-85796DE0F4DB@hpe.com>
References: <nick.hawkins@hpe.com>
 <20220202165315.18282-1-nick.hawkins@hpe.com>
 <20220202175635.GC2091156@minyard.net>
In-Reply-To: <20220202175635.GC2091156@minyard.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5affd52-18e3-4b94-5c28-08d9e677eb95
x-ms-traffictypediagnostic: PH7PR84MB1838:EE_
x-microsoft-antispam-prvs: <PH7PR84MB1838205F69B7A48EE5684AB0D6279@PH7PR84MB1838.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aI9tVZr34Qmti54EcvjZnv7p2LPOu+76Mb9H5IQEyCkYvushiiiqn/bIrPAT9ZhnvDJ6Vta3HuldZGnz3EBN75I0/zQahfkjY8dDyf4BU9WM1xnn/Sz/QDky4OuOjcY5ekUzU4QJmMI3Y2+HVXA11QDz6ylYF0q+pqFXixujQbC6RVI6TgN8W86zw3J7G7XGGV/H6g0q34DLf3n1H4DO+a0yoBrqz7jkwAr4+a57oIzeDa6cHR3/OGggzSsvZ50txYrhSSFOPUg1Dv8gh8jspn11/QMpLY38tYxHRbcigWPXFChQuMylfFTdQeamEg81719NublUGQFa8k2krmcrclZJdyit8DI2yMThWBhvoBIK2wu8z/RsLwJtNSsZAyGUFuOP27kmTWYptn5pp6+TyJm22HT5GxKE7NjI0j4p6AFwi/SWdI7F24L8W9j8B3xteOgx1ySLK9GTsotq0K8XXeLgrrfis0R30yeYcsnryQpQBryM67jz+TwNPRcziff248zQcXqSJMPUQdyXvQHZOjVqAmW+BlEwJyXN7ouEZcr1626rw7h1B/HCM0urzQcl+CK9GJPD4OT7543jpDRYkrwuN913+KjoWzUo/J4BDFBAzMcG03Z52upf1XYXeNmDt8shGvjecM/SVbZOfPGcth+Dg7Dx+y0mxRP4V6jPG/ia1cno9mEK9NbaCljuceH9ng56GKF2wquQa5NryVTcMUHmG1KnpSOzpu+HhSTo0i4AW7skUgaNTI3dsggmpS7Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB1976.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(2906002)(316002)(7416002)(508600001)(33656002)(6512007)(71200400001)(7366002)(7406005)(5660300002)(110136005)(6506007)(6636002)(54906003)(6486002)(36756003)(4326008)(38100700002)(86362001)(2616005)(38070700005)(64756008)(66946007)(76116006)(83380400001)(91956017)(82960400001)(66446008)(66476007)(186003)(8936002)(8676002)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUFsRnVhMXFEZnZIOWZaYXpGMmUzZ3VvRGFZZDRHRGR2eXI5K1czR1QzMDNW?=
 =?utf-8?B?amVldWIrWE9xLzZBSWZWVWtydStBY3B1cXU3WmdiV3hPS0ljalorcWhhSWYv?=
 =?utf-8?B?ZkJ5OE1VNVFPZFI0UklGN29CQUVIVnQxQmlHWGgraWN1cEZ3WmJJRCs0M2Vp?=
 =?utf-8?B?Z05tV3hodWNpRlloU2I2RmIvUldwRk4zbTRabUpyeGRRRCtzUU9rbnVkdERs?=
 =?utf-8?B?bi83UTVJWjBJd1lPUDJvRmE5MW5FN1hKdnV4ZFVlZzVpZ2lDYW54UjBabWpl?=
 =?utf-8?B?dkorQnNFd1RPOWVVSVZiaUx6TVNiTElORitBZ1BqVk9Za2hCeFU0UjIzSzl4?=
 =?utf-8?B?OFRiZ3dSdnozU0xFWlBMQ3RhTThCUXBNMGl3dmhMSlBSTFd1S3JyNEVqU3FP?=
 =?utf-8?B?UFVVcmlrZmpFbm9idldhclQ1V3dJTmJpNEduVkpIQU42QnZUcFk5M0tBSlJv?=
 =?utf-8?B?NWpXRnRzSUtNNEswTlpHaisxWFoweDgvRWpTdUZZSFlhWWhMc2ltY1BwYjkx?=
 =?utf-8?B?Ynk1cURLRVNpckMwaG9CYlRGYlFoclpWRzBFM09kWXkyTG5Ndk1BcFMyV3hi?=
 =?utf-8?B?L3VTM2dJMjVhNVg5bHR1R1N3a1JsVW5WSytTMHNkcGNMWHpMSXZLMUpRYS9y?=
 =?utf-8?B?Y2pEd3YyRXJVNHB5cDN2UEhuTjUxdG1IaVVGTldYUUZ0dFJVQ1NISEkrVlFt?=
 =?utf-8?B?UlpnS3ZnZUR1OUxnM24rZ2s4K2h5MmFsSFRwd3cyUUI2NkQyUm5iMlNIekZ3?=
 =?utf-8?B?MTEzWXRFeWNGUmllQW1ZZC9ZTWMydmlEM2JEbWZYU21TTHBJc2RDREo1eGdI?=
 =?utf-8?B?bExGNHV2RUw1NG5xekQwaXB0S1Q1L3NPMGJtdGl5SmR1b0hocmdpSHJKVmJG?=
 =?utf-8?B?VlMyYWNoaGQrUXlZRXVsczhoV2FJZlBJcGR0KzZaOFhvbU50eENpNWNkU2wy?=
 =?utf-8?B?MC9HWHpvY3pYSGdtcVQxN2hMNWNMdkx5cVBWa2hudDhSM0p6ckxZcURUNzFS?=
 =?utf-8?B?bk1NbjQvb0xHUkVldlNJcnlCRUFORlVKZll3dFlrMThEMlh1ZXlmczNTR2tU?=
 =?utf-8?B?ZytId2ZGMFBpVy9xK0tURExwSDEzdUxGNjNCZDNBNWpRaGlYbmRLT1J1aVpJ?=
 =?utf-8?B?ekNvc1NYV2tvQ0hrTWZDdnZhYWxkTU9jVUVEbGF0Mi8yM1cwUXNEa1MyaXJR?=
 =?utf-8?B?b1F2ZTB3bDVLTjBmdGVvMXNVNm9tUHNWRHVLQ3VKOWtuSmZFangvL3h6cjRr?=
 =?utf-8?B?K2xqaE8yeDFyeXRUR3ZtaUJ3aE41ZDAreWRURXFnVFJZdHhSMFlHZDFKd2R0?=
 =?utf-8?B?c01lT3JrOCtObXcyWkFnY0x4UkdlWVR6SzV6Q0xQR2R0YnFlakQ4VWh4eW5Y?=
 =?utf-8?B?VCtCNWpFOTU2bGF6Rml6U3cyT1FxdjRBWjFwbUFHUHQwNkh4UGlNdW9HdnF1?=
 =?utf-8?B?Z3VDL1NOcGpSWGpmaXl5UzYxclFpZGFWZnZPVEVmTkxSTE84NU05a3NKdjJy?=
 =?utf-8?B?K2Q5VGZOVFdtRDlNWC9xb2paMklVZnUrOFEzcGhWL0xHQ3h4OFZ1YVlHakNP?=
 =?utf-8?B?QXhZb2VJYkNnR2tKKzhpQjAzQ1dZeVlsUlpDcHMvUTZZN3RRbDkwNUpCNVIz?=
 =?utf-8?B?bWRHVmdPY01VWXRvNzhKNFd3VXRFT21kaUFPQlU2eHNVREhhZXNrMms0OXN1?=
 =?utf-8?B?WEtnd0UvQTNxOVdmeCtuK3JlVm1mclFWbnpkVlhDeFkrKy9sa2tiVzM4dmhr?=
 =?utf-8?B?OGh3dGlxVXNQN0FhK3JaMjA0Vk1CL3dHRWdsa2hYNlc4MUxjTDl3R1RrVUJw?=
 =?utf-8?B?ZC9Zd0V1aTVhS3JuN1ZmQldudWI3YzRNVmZRY2l3a2dRakhGdU9pK00vVjBv?=
 =?utf-8?B?TDhjOXNiUTdDcGRKUlhBMVBkeTdGODZsZE1pcEIwSEJGUkMrVElxYzIxLzFF?=
 =?utf-8?B?WDJVa2k4WURtdE1tcU9iN0xoVGUwYlN2VmtyaHFIYzVXdDdHSXU5dUVYbTIw?=
 =?utf-8?B?R1BtQklaUTYvMHVsYWtPYTNGajRTb1Q0Y05WcXA4ZCs5UVZJSGxKSTdwN2dv?=
 =?utf-8?B?YkpQTVlwUU5xRXFSSnUzNE15RWUxb2paWmRvWmkyQUZNdTI3R1pHcXRmOUlr?=
 =?utf-8?B?REUyMXV5cFRYY1R1dWx2K0tkZU9zYk9oNCt5ZFZLQVRKaUJPbytBMEVlc0ty?=
 =?utf-8?Q?6ZGR6snc05Kznf3b1ZtAy58=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBC89AE5DFE8BB49813143761EEE77DE@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB1976.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a5affd52-18e3-4b94-5c28-08d9e677eb95
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 18:14:57.6941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxZJ6aTk3DlhkIheggfv7I6wWLJiCv5ZU2htq1tM4EKT3nZr2I7tIJc2kWKNMeSu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1838
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: SofmSrxeNRPBGJnhLISvX2XpqUK4ZXCY
X-Proofpoint-ORIG-GUID: SofmSrxeNRPBGJnhLISvX2XpqUK4ZXCY
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202020102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUaGlzIGlzIGZhciB0b28gYmlnIGZvciBhIHNpbmdsZSBwYXRjaC4gIEl0IG5lZWRzIHRvIGJl
IGJyb2tlbiBpbnRvDQo+IGZ1bmN0aW9uYWwgY2h1bmtzIHRoYXQgY2FuIGJlIHJldmlld2VkIGlu
ZGl2aWR1YWxseS4gIEVhY2ggZHJpdmVyIGFuZA0KPiBlYWNoIGRldmljZSB0cmVlIGNoYW5nZSBh
bG9uZyB3aXRoIGl0J3MgYWNjb21wYW55aW5nIGNvZGUgbmVlZCB0byBiZQ0KPiBkb25lIGluIGlu
ZGl2aWR1YWwgcGF0Y2hlcy4gIFRoZSB3YXkgaXQgaXMgaXQgY2FuJ3QgYmUgcmV2aWV3ZWQgaW4g
YW55DQo+IHNhbmUgbWFubmVyLg0KDQo+IC1jb3JleQ0KDQpUaGFua3MgZm9yIHlvdXIgZmVlZGJh
Y2suIFdlIGFyZSBnZXR0aW5nIGEgbGl0dGxlIGJpdCBsb3N0IGhlcmUsIGFzIG91ciBwbGFuIHdh
cyB0byBzdWJtaXQgaW5pdGlhbA0KDQotIGJpbmRpbmdzDQotIGR0cyBmb3IgU29DIGFuZCAxIGJv
YXJkDQotIGluaXRpYWwgcGxhdGZvcm0gaW5pdCBjb2RlDQoNClRoZW4gZHJpdmVycyBjb2RlIGF2
b2lkaW5nIHRvIHNlbmQgbWFueSBkdHMgdXBkYXRlcyB3aGljaCBtaWdodCBjb21wbGV4aWZ5IHRo
ZSByZXZpZXcuIFdlIHdhbnRlZCB0byBzZW5kIGFsbCBkcml2ZXJzIGNvZGUgdG8gcmVsZXZhbnQg
cmV2aWV3ZXJzIGJ5IHRvbW9ycm93Lg0KDQpTbywgd2hhdCB5b3UgYXJlIGFza2luZyAoIGRvIG5v
dCB3b3JyeSBJIGFtIG5vdCB0cnlpbmcgdG8gbmVnb3RpYXRlLCBJIGp1c3Qgd2FudCB0byBhdm9p
ZCBFbmdsaXNoIG1pc3VuZGVyc3RhbmRpbmdzIGFzIEkgYW0gRnJlbmNoKSBpcyB0byBzZW5kIHBl
ciBkcml2ZXINCg0KLSBiaW5kaW5nDQotIGR0cyB1cGRhdGUNCi0gZHJpdmVyIGNvZGUNCg0KRm9y
IGVhY2ggZHJpdmVyIHRocm91Z2ggZGlmZmVyZW50IHN1Ym1pc3Npb24gKHdpdGggZWFjaCBvZiB0
aGVtIGNvbnRhaW5pbmcgdGhlIDMgYXNzb2NpYXRlZCBwYXJ0cykgPw0KDQpXaGF0IHNoYWxsIGJl
IHRoZSBpbml0aWFsIG9uZSBpbiBvdXIgY2FzZSBhcyB3ZSBhcmUgaW50cm9kdWNpbmcgYSBwbGF0
Zm9ybSA/IEFuIGVtcHR5IGR0cyBpbmZyYXN0cnVjdHVyZSBhbmQgdGhlbiB3ZSBtYWtlIGl0IGdy
b3cgb25lIHN0ZXAgYXQgYSB0aW1lID8NCg0KdmVqbWFyaWUNCg0K77u/DQogDQoNCg==
