Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0521277BA
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfLTJHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:07:00 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:3490 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727129AbfLTJHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 04:07:00 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBK95cwJ010597;
        Fri, 20 Dec 2019 01:05:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=vwu1+QAT7F0FB9mnOfF+8voHzKZrYCynHuyJimrLK94=;
 b=deDir/kbMob3mtTti4krPuB5ZA29O8cGo50BOqaalFUPeJfJV4tzrgX77vtleK1ZOOGs
 UyGK8IrKmnB4SArQomZxycQSQUsjKudtGIJ74ElbzNDYZvxZ1mpQQE5IEvWl5S8c84BD
 3dmoctSZE3ynLRqZyrOlPAoH17b5jKyWgs6wODpQ2CtkDYyDe4rwHX6rMuq4J/FcMm/I
 463p3sH5QUH5Ug2scYlZ9GlKE3PdupbT/mVSg7gCm/mgkSiVdvRPC5jUZ1+2XrYejRkV
 s4qEDvQUZdCr5u/frZM2ENR2UcJYA2HpnQsGLSEkSFpmYTVfeLLiT4/O+aDEjWeCdxw/ ew== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2057.outbound.protection.outlook.com [104.47.38.57])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wyr9p6xqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 01:05:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzqlGRlGbNOs7WrOSb0Nk+MrrDfdWDirzx0kr9HYOP2jiSVkWKcUjGcTMaDRy6siVK0e2xkawxDDznhou8ZbD7xJ42yMtZJLaJNreEEbHJMXnfE1LxKnyB4f/R+JouaC5VC/hdqJxdMjDQu3NmzXWYSbTrGuajyDlqRxmqS1HAHDhwus+JcLJmfavKpaZ53zn5ogGPfpqHbgOPjaU7fBg/5rp45DFw+sTF0CuZhVp+nvZhvtFx+oDvZwDl4Kbf6f2nFHBLfLUnY03GZQfDihDDyzUF8O+MI04yDoZ+oegQQbf1S3gHKBt227wpkmZ1eH5ixcxaoNWM0HxbSZnMyLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwu1+QAT7F0FB9mnOfF+8voHzKZrYCynHuyJimrLK94=;
 b=QPTP/5vCro8xw6uiY53iAVIXE9zz+LugNFx+CyPBkZ/nL7VvrkpIi21E3P2LRRK4KgUWz0G8G2lR8UMSV4/3vgSirjqX1D4/hKYeR8v8R2wOtyFaOlQ+bfkPYi6IRisMsAUcHPqRy15xpkfxRF5xEBnbclSES9GYOnMFbxIqazWiSKmtdh6ROnqHjZII/HqZjR8IfHLcJ442tGlinNz+EStLL+L1kqEUUW0leyS1WJcDtZhMTJ4ohkbS2ZvJibi5N1N/5YScHmsUESXRmqbI7HJiqHppXbURSYKq4ae44V1/ahrGEpy3rd5JiSmw/VNQCS96wuj9eMZc3mGldpPqZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwu1+QAT7F0FB9mnOfF+8voHzKZrYCynHuyJimrLK94=;
 b=7k+FbETcN38+kj8hX1e8balZ5C1cLwIzTgBvH9Le4a+M4Mwxh8D5om+5iMUr/D+3+e2Ed3Amoj1XzVLFm9qUERDLYjRRjojUqe/lHUPOA7v4UNC7tiKp1XCNh8zKyzE7mWk+XzplGm0MdBDaX+zHIj2WHE8eOG4ueEMFNJvioXA=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6531.namprd07.prod.outlook.com (10.255.138.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Fri, 20 Dec 2019 09:05:36 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2559.015; Fri, 20 Dec 2019
 09:05:35 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: RE: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Index: AQHVsZm5l82MVXLf60OyobQPmImAGae7UQaAgAACAgCAAWMWwIAACq4AgAYCPxA=
Date:   Fri, 20 Dec 2019 09:05:35 +0000
Message-ID: <BY5PR07MB65143BFFE9D08FBA2BD94669D32D0@BY5PR07MB6514.namprd07.prod.outlook.com>
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
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctZGYzNzZmNTAtMjMwNy0xMWVhLWFlY2YtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XGRmMzc2ZjUxLTIzMDctMTFlYS1hZWNmLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMjgxNCIgdD0iMTMyMjEzMDYzMzE1Mzg1NTUyIiBoPSJaUmcvV1lDdzRrc2V1MlRGZnZndlM0ZnFaSmM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b14a89f-9536-4e2b-9c47-08d7852bc6b2
x-ms-traffictypediagnostic: BY5PR07MB6531:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB653137B571405A169E7C7606D32D0@BY5PR07MB6531.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(199004)(189003)(36092001)(8676002)(55016002)(2906002)(86362001)(186003)(66946007)(66476007)(5660300002)(76116006)(55236004)(66446008)(66556008)(107886003)(64756008)(478600001)(71200400001)(6506007)(33656002)(7696005)(26005)(9686003)(6916009)(81156014)(7416002)(4326008)(52536014)(316002)(54906003)(8936002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6531;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gosJK1s7zKugrWqLYoct5mq9Oru+twW1L1vHSkAXBeXK4HoDMagHPFh7MSK/Mv2qWD02rTNkBEomtIGaYpDEEw7rgYPloALU+AhJGRqcJ56Xl2hGcs/aA4S/lTclFX4DYzRC1KG5CqCMAnoJroDIZ626r0b5rhXLQVoiVRuxwXV74M5ueeACOujzdTS5qiS6gG9B8Ne2YKpfEa8pb02Ck0tNOzkgSQVI0faFi8A4iAbkfD3v2uyiEihIYBHr8U//p/1YE2Y8x1b/sR6MI33VL3XXyO5RMDY+JluYWuvLP8RdGv9IpJvYvDDv8wucp7f+m/tAK5KzqKdJw6Ph6G8k0v2grOX3eolE6i625OJcMiSnkd6ZrKhvG05u41vzM3mJzAKaxN6WHUyZFKD8C74RNdbN7WBN3OMZ8Z9T7/R/McJuHwjay6X8XtsSXB7RxtOIYg/MhEplr1J2ZS1/w34vSsD72uPFNQP+62uRv8KcnWhZGhoN5LhXRVvd4r562pbY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b14a89f-9536-4e2b-9c47-08d7852bc6b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 09:05:35.8697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cFhMWg2EFIuHLLahgoEfGP1tXQggi0sx8gDbk5V3c45J47LHKMzDGIDx1QZt2z2m49qvM301ulypgFykKZtCrtwHIFB5dXCqsBUqOSqZJTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6531
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_08:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=878 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912200073
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
We would need more time to get back on the restructured implementation. Whi=
le we
work on that, is it okay to accept patch 1/3 and patch 2/3?

