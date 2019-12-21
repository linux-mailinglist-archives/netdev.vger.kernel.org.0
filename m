Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90A1288D0
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 12:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLULIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 06:08:48 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:3322 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbfLULIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 06:08:48 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBLB7Jxl016477;
        Sat, 21 Dec 2019 03:08:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=E0Ta8bHasfvg2rb1AaMUg3Jtni97tE+dAkQmjKy2ZU4=;
 b=bJgPzxv4tWGQDnQnlO8drIUQHECDcSFw5eGh8Xz3TlsavmNXGuHfr2WDbS49TKON4zE+
 7J4xx3jzMazW6BjY8CX5pFBSIu3kr/xhGU+V2Iwl/vKlm0+lMHGAFfAGlb4XH4EqZ444
 ABLM73GqyxVqSg5/XRHKHz/H3W58bLNPRf8Drq9WgY72+2fXia9Oh20h7N6fTjbmlLwm
 hL8DUsIB36Gv+cKLkkCrD5vegN9b1CAmEKPj6mkYZAt9EzNRd6V+6aTvH919tYwBskYy
 FC8eSGbn+Io9WuAVhjA7xjcEP5EjnU24ALuLWCilUx67KV62VcP0G+I/saEC2fswbXv7 1w== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2x1gu4r4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 Dec 2019 03:08:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ms/Il6JHul69jAnMQJwD+ypf/YuHu41FFbW6K3nrWYLmN6iI8UMKRVc9SjjLDTYP3JK+PR/BP/0R7DhtJyhd26fctwyoI7KV3pExjOyI/OmhmLh+jD+ofWq/9G1RUHaFApJeNLo65u+Bo3qR9ujyzSSU4Q3QM7gAx5ko+BTJXGZao/2lnfTorCuhJnGn+XR83sdhU9w9VAvgUK2lBicPUMnwb+gourCr/LEUo59LgFPW4GmSsvufULNIy11i4unPH+vDESIje5Up6CKaDGTi9xDFB9A2RwSCj6ge8w5elL3IrTU8CT+hSA+/ZdlV3QH0mZkUTBDW/7Alr/ugjSWMrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Ta8bHasfvg2rb1AaMUg3Jtni97tE+dAkQmjKy2ZU4=;
 b=YfNzbYcaH4qt3jV3eYZ85QOINZDdokagTGJ2baqNTlq0qU27EGCEJSPvTx4iZsTyh6AC6ByJTMFkCsSEkQlxcQjTEn2W/L0kDLwItc7+g5O0ZwHmwjnJK5NP5Zlthh+tYRzMXuObS/T423Mnniodt0n+s4qgDaHftQj1dRuAnqhGarG4BJmFZYoAnT1I8iDgPOKb+zAy80/58SaaDzK1OMcaYNYYjPY8k/aZDMlRVNhaf/ah/I9WjvkKLZ5z5StS6X3/qbazsl8QitznQUSt8+qoTBcaRcHHo7bA/dvO++0J7lUMLn2T9BoaLb0d/KDdxUIbQ0nE5bPf84OUnPJEJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Ta8bHasfvg2rb1AaMUg3Jtni97tE+dAkQmjKy2ZU4=;
 b=44FbBEQa/kg6DhKhIshI4jyTdb9MiRQBCE8HwfNplsp9P3LpsKVuV0rYlvbJbNLhBBUIhXrdsiUcXrrzR0ttp1U5ThOAk3bAaPrqKgFzOBhes+k+PwwLswEL43rBecspGLx5cGgaU+QfRQ0GPnbi5LXi3Vv5W5cNWdpWLfZsxlc=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB7202.namprd07.prod.outlook.com (52.135.54.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Sat, 21 Dec 2019 11:08:18 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2559.017; Sat, 21 Dec 2019
 11:08:18 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>
Subject: RE: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Index: AQHVsZm5l82MVXLf60OyobQPmImAGae7UQaAgAACAgCAAWMWwIAACq4AgAe4FfA=
Date:   Sat, 21 Dec 2019 11:08:18 +0000
Message-ID: <BY5PR07MB6514F3B5E2A1B910218F7EFBD32C0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
 <1576230177-11404-1-git-send-email-mparab@cadence.com>
 <20191215151249.GA25745@shell.armlinux.org.uk>
 <20191215152000.GW1344@shell.armlinux.org.uk>
 <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191216130908.GI25745@shell.armlinux.org.uk>
In-Reply-To: <20191216130908.GI25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMWViMTJjY2ItMjNlMi0xMWVhLWFlY2YtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDFlYjEyY2NkLTIzZTItMTFlYS1hZWNmLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMjgxNyIgdD0iMTMyMjE0MDAwNjgyOTg3MDAzIiBoPSJnSzN3Vi90c1RNYkFTa1EzanRhNVpuUVdnODA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.142.6.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcba9aa4-7f33-4678-6cb4-08d786061594
x-ms-traffictypediagnostic: BY5PR07MB7202:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB720248C72E9F71EA7DA35E5DD32C0@BY5PR07MB7202.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0258E7CCD4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(36092001)(189003)(199004)(26005)(6506007)(55236004)(6916009)(55016002)(52536014)(71200400001)(33656002)(7416002)(478600001)(86362001)(9686003)(66476007)(64756008)(2906002)(54906003)(5660300002)(8936002)(66446008)(66556008)(81166006)(66946007)(4326008)(8676002)(316002)(81156014)(7696005)(186003)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB7202;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yz+JkUOMTSkBM3xWiTqhFQLCLXhGUTPLC0bvhE2K2PFwVCbxIA5YJLSEdY2rzsiA7V0XlnytIQUdiyZy4xOZbUueRnUXvHkeVBuJf6j02kWmTEUTXx2/a+xlsUquwySSU0L9no3kGh/k9rldRv2bsd9+2/M2CFLJ4GfWsxOWteAmuHSZ8do6zOkE0GHDgALOicpkpUMUbA3wm5KAMWLmDCsr1d0ohDPtxeAa9PsZhOEbbbtZ3Tf/H+Bv2DycxvjAQeFbZlfZZJdZvRdRzsjsWbOEEibiSU/Eqeg7nJ2oz0P8o+JcQhCs/Ax8RWQvN6Sk0q6K8HpN8BPkYz6bp/O8D3TE0x3L4v4a9VcMNIajtFNj0h+dlLug5hkRMHCNEuoTNLEewBnyp2L+RaC/65Vi0Tf4wI4qgj33AC4w9QSC3Egr9UXGOLldUoaN1NyrwoNkbXT5Qa45Ld5wwF4VhpF5+toyCXnnjTX6UwnuoHgMHZufGDPdtIQcKTVeJey4KTbr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcba9aa4-7f33-4678-6cb4-08d786061594
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2019 11:08:18.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZIuMK6MS+VBfsvlOytH2HPJIf9j4mqtB9vKb/luH998YvuABw9ZHx9pJ0BCGtRPg1vcbygQ5WkLCU1s2/Vyh9o5FGwPHzoSGFrpqR2tApn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB7202
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_02:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxlogscore=791
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912210097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>> Additional 3rd party I2C IP required (not part of GEM) for module
>> interrogation (MDIO to I2C handled by SW
>>  +--------------+                                  +-----------+
>>  |              |       |        |                 |  SFP+     |
>>  | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | Optical   |
>>  |   USX PCS|   |       | (PMA)  |                 | Module    |
>>  +--------------+                                  +-----------+
>>                                                          ^
>>         +--------+                                       |
>>         | I2C    |                                       |
>>         | Master | <-------------------------------------|
>>         +--------+
>The kernel supports this through the sfp and phylink support. SFI is
>more commonly known as 10GBASE-R. Note that this is *not* USXGMII.
>Link status needs to come from the MAC side, so macb_mac_pcs_get_state()
>is required.
>
>> Rate determined by 10GBASE-T PHY capability through auto-negotiation.
>> I2C IP required
>>  +--------------+                                  +-----------+
>>  |              |       |        |                 |  SFP+ to  |
>>  | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | 10GBASE-T |
>>  |   USX PCS|   |       | (PMA)  |                 |           |
>>  +--------------+                                  +-----------+
>>                                                          ^
>>         +--------+                                       |
>>         | I2C    |                                       |
>>         | Master | <-------------------------------------|
>>         +--------+
>
>The 10G copper module I have uses 10GBASE-R, 5000BASE-X, 2500BASE-X,
>and SGMII (without in-band status), dynamically switching between
>these depending on the results of the copper side negotiation.
>
>> USXGMII PHY. Uses MDIO or equivalent for status xfer
>>  +-------------+                                    +--------+
>>  |             |       |        |                   |        |
>>  | GEM MAC/DMA | <---> | SerDes | <--- USXGMII ---> |  PHY   |
>>  |  USX PCS    |       | (PMA)  |                   |        |
>>  +-------------+                                    +--------+
>>        ^                                                 ^
>>        |_____________________ MDIO ______________________|
>
>Overall, please implement phylink properly for your MAC, rather than
>the current half-hearted approach that *will* break in various
>circumstances.
>

We would need more time to get back on the restructured implementation.=20
While we work on that, is it okay to accept patch 1/3 and patch 2/3?

