Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9E11A6B1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfLKJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:21:02 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:56710 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbfLKJVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 04:21:02 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBB9DVOY014094;
        Wed, 11 Dec 2019 01:20:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=9Wqnj2O7KVIT9n9DodKm0GhT7PmFwDT38TJNTaonqb0=;
 b=Qb247e9S4TxVvcpTGZ8qv87o+S8ef6bLoq23Q0SG+Sd2kfPeeS0M709CNNJR56sOPQuv
 t5pTjYXTxCRzRDmbd94ZKW3DtPwXcc8vgyHXPfMVyH8/Zzox42CZ5OhKeC/03KV+SsQ7
 9kUuwxCQlVu6OWwo2cQZgAywN+l3pMU0ZeTJ8QbYMY2+TKyGTOt9Xnl3nKq9vQNuJHG1
 8yQybEfkS1QwodW2uDiluC/2uHOUHFNSU5fIAIvnHB+2Oz2dULCGHgvF5AxDq6ItsdB/
 uHGp2zv4/OuiRwWIwd69su2w7/7PLTd8Kbxnkxb07nS+LlPrnBpWdl/ykkWwQJWz+83n 1w== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra70dg46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 01:20:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=et1cblu3TjZ5HrgWTTujptc9pcQkZw30tNJIC/5q67ULwzcJPcdXJ13Y96TMe329aELdDxxis8EuZFLjjzIBdwqvqJduvTxDP34mjL+KBO8ZM4HEhF1FMeDC64pZicRTVbFfwT7imPxSdDA8rLGV8pRu9C4D8nG0RQ9UXMkkx5HBEvdurmR5DcXwg6tEAFYrRtBKjKJW14TvdYXBwlOzAAfkqO8j95wqSEJach1UdcSKVhWx7vSAhaRi79HwxApuilxeAlcwV6X1VPU10QyXOX9OVGJhNTHcFx+yod7QwuxvvsaSjiXFAhL0IdMstY14h7goeNf7z3+B9MnYIAW4BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Wqnj2O7KVIT9n9DodKm0GhT7PmFwDT38TJNTaonqb0=;
 b=EC3FJnvrnjlYFulAC2REPMHoLfTsGlB3FyAQXFOIO/KmnEHD7rVlcaR/HkMBXmoIzdHWuWQPXfanZsAHaUs+N/KamdxrAJ4JLGSrZRzLSVEW1MLiAe+KaOqj90hhPnBCYm5E5cBxWxUfSSqmjarnz2FN+TKq/0xXr3Y684qRIG/wJPSorDkyDESzFjBdPVj+Wro6WgvkH+mGet6lLgl7SNtrTS0RlENqIPM/AvPtm9GrKPoIaf5E9lXjN1Z1KMwz/5iv6jhbYjE/SLemIygmeoYEDhH7hscs3F/NTv8oZC3UJZEAqfCeHVMWC8tRGz63LkFrDNlLwnDmc5uCG8dUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Wqnj2O7KVIT9n9DodKm0GhT7PmFwDT38TJNTaonqb0=;
 b=YXW8JvVO5xD2ohsME6MEaKWBWL5NN5sNycznk/evqpmc/D4AVxvqlpbL15xWA6nZCcZs/lZm3FgtmN+/6UiQWuRCgjkWtsfXPw09oXJSuEI8Mx/CXnc0/pfNXD9ubCLt2skQ1k0DR3MzKoXcA8EzV4gl6O+Aa7lsmQs5SSahutQ=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6886.namprd07.prod.outlook.com (52.133.249.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 11 Dec 2019 09:20:37 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 09:20:37 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
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
Subject: RE: [PATCH 3/3] net: macb: add support for high speed interface
Thread-Topic: [PATCH 3/3] net: macb: add support for high speed interface
Thread-Index: AQHVroIXac2qRLU0l0+QWTJxCA7dLKexrKsAgAF+vXCAADRqAIABQssw
Date:   Wed, 11 Dec 2019 09:20:37 +0000
Message-ID: <BY5PR07MB6514A9B0EBD033A91000F2FED35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
 <20191209113606.GF25745@shell.armlinux.org.uk>
 <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191210133334.GA16369@lunn.ch>
In-Reply-To: <20191210133334.GA16369@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctN2JmMjJmNzMtMWJmNy0xMWVhLWFlY2EtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDdiZjIyZjc0LTFiZjctMTFlYS1hZWNhLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iNzE0IiB0PSIxMzIyMDUyOTYzNDg5NjE4NjEiIGg9IldFVHZONTkxK05mbk1LV3dmZVZFS3BEVFk5ST0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 766f7bcc-1bbb-4233-eacc-08d77e1b6254
x-ms-traffictypediagnostic: BY5PR07MB6886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB688678A88469D310B8A05A14D35A0@BY5PR07MB6886.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(36092001)(199004)(189003)(33656002)(66476007)(66556008)(64756008)(66946007)(7416002)(66446008)(52536014)(76116006)(2906002)(6916009)(54906003)(8936002)(316002)(81156014)(81166006)(55016002)(9686003)(86362001)(26005)(5660300002)(4744005)(186003)(71200400001)(478600001)(55236004)(6506007)(4326008)(8676002)(7696005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6886;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y/GOyEwX+mMuzooMEW9ZuvzUVNN/ZIu8QPewwE7UUVgk1AVGY2+jMljYbzqb++PI4rb4b6E/FVFgW1O4Z2dV4X3Li6+X3FNhga8LknG/rrNyC+1cE5R5IIn2ZO8YirKjyHcJ3mJUudJOx1q9a9sjah4B6xYO1e8u7/jrNvqIX+DdUpFokY6kzblGlPOiW8IIV8ynzuegn1Gb0B8+QIv0yPFh2UhE9DAzTbbi4bhxOvkrvXH8nviu9pt7l+weASeosrgL3OLyi+v6ApCK7gUif3B81BF533mhkD3hI8i2WZlavU6wJOcJEEfi/3CJFEXUDXkFtZvznSPIj2GUYiCTWJSKR9YtRQlbciBINm9nGTQmI2CRnzkKeemclPw2gJ8x2RMGuDe74ZPPpbnVWE1ajsw+AgtzjKO3sw2Hfijm5i1FtsTkkG5AkILtbea6MrMoT1ZuOkebHhFlIN8K0xB9t1dHCOJznCl8RKGcmZIQg3DV0LzhGehh33JIf/+lgQ04
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766f7bcc-1bbb-4233-eacc-08d77e1b6254
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 09:20:37.4024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4WHyvhf6ULtxOWum1Z/AIIbEFmPW7qVuRwPU98cHhfYgECYAAaCi1IdGbu3S0LvrDuXZQMFT12Gm2EEYJMc8v8ELgWdpG297Ctb86FX2a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6886
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_01:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=763
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >How has this been tested?
>> >
>>
>> This patch is tested in 10G fixed mode on SFP+ module.
>>
>> In our own lab, we have various hardware test platforms supporting SGMII
>(through a TI PHY and another build that connects to a Marvell 1G PHY), GM=
II
>(through a Marvell PHY), 10GBASE-R (direct connection to SFP+), USXGMII
>(currently we can emulate this using an SFP+ connection from/to our own
>hardware)
>
>Are any of these PHY using C45?

No, none of these PHYs use C45.=20
For C45 testing we had a simulated PHY. The simulated PHY implemented a Cla=
use 45 slave interface.

>
>    Thanks
>	Andrew
