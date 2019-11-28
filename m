Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6D10C51B
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfK1I31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:29:27 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:9810 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726301AbfK1I30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:29:26 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAS8SZhd006919;
        Thu, 28 Nov 2019 00:29:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=CNSrwgIvrcrRIC1P2Nstq9jM1+vgfcbO9tC2EV45c3U=;
 b=Jtwbbb+SFkLcaO69eang8+YoGiZOM3G9R0rKbPtxDYhrlV/uKBy+k/geScmxqfY5Ex7q
 1cywosFCUbdtm/7XC0gfZYIiXTfhH7TeQ4S79tIZwrC9Gh2GMdxVdDza1T1tdbn14i1k
 FKoZzZxLCt2WGyE8wnBq4sWwVtPrpyQ+IU/NbgpG2qNOWSwmZ1Jp9Tt5pbwFqR4+xSZl
 QO81JYXDq88jKZ5B6iOPbYyo6bZfTsS6JR7UySgSvVuia+wEHhRUsiTumprIsBbj0Edm
 jLoFdCR1rzoqXmkYtvq1II8F+hUzmEIkHMCgFQfZnTCGgoffL6QKrcUpvlC9HSzfIEjy bg== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2whcyeyhtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 00:29:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpP+Nesj4LZ2pO6i1TmGzapHSlEQmNkPE0RUj1raHUD0Qc1tzXa4BZBRKEaUGHHYxQ8+YNp6aqs66q6fL7RRfKDZzOqOGs3QzRyCcBhMSjpPKSq80tpDKY1Q1tsuAAoRm/EIKtXvDdXolw056n1VIeRvcXtRA6A9INlSwavK6E0dab1qp16mik22WHks/LyGZz0Afo9zeyQeD6L1yDEO2AHrHXqsLUJhWD3KH3c/Ri5W6TKxF6/JlXBZjLFSC6MzEqCLbw7AneA0uMqAV524bGfci7lI3n8JOYoYFuDab/fx44aQoJNL9Z9Uo/vxWKKwJe/RdCgWrIn98Lpvucee8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNSrwgIvrcrRIC1P2Nstq9jM1+vgfcbO9tC2EV45c3U=;
 b=lxrJ9Nkeg+6fMkXD/Z2uXgu28cZmdEgtDJwYj7FLi/aamrNYsBNDyVaJmx6xYZ7dhpON548tMFabNWVZ6mgY5vAFtwVckvQ8Ub2MnFALt39p1WuZvj19/AUEg9aQ8GyFby6537fAGQz/Z8uz+nXKjQ8hfvP1P4nRUnl6KRqf49L6N3Cr40qwGQ43c8Z9cY/LP2Kv/po1b89VZ0avYA105FQj7yrEya6VVxQ5/QW4s5A0nqf01YjYbWMqd4wHrikTbbTuL/8j3jicOh+KeDJZIwL+ZrWgbIn9OPwVg1OFhjDBbkP95CcZV5zoAc7PS2RaPgql6O8JexJL1sFKp/rq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNSrwgIvrcrRIC1P2Nstq9jM1+vgfcbO9tC2EV45c3U=;
 b=R68V1UjhVIj6zaFZROLY0z1PtKtFZNRQRHn1vBllI9SQYJcbM8gkVZWGDOYYkSTWkweQpA6PNdBTB4EhO9Hi8Pgd7s+DtV8vUp8a3aQZkgI+M4xR0mUlf4tAwZXFEaAREbhqM07ys3iW+yj1Li7tFQ+8ap2DyJuP7MJPKEN/jz4=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6529.namprd07.prod.outlook.com (10.255.137.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 08:29:03 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768%7]) with mapi id 15.20.2495.014; Thu, 28 Nov 2019
 08:29:03 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>
CC:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Subject: RE: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Thread-Topic: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Thread-Index: AQHVpDlIbouhzt0t6EC8eA8NTGVfbqedhY2AgAHT4gCAAAV5gIAA4gUg
Date:   Thu, 28 Nov 2019 08:29:03 +0000
Message-ID: <BY5PR07MB65147759BC70B370E6834451D3470@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
 <20191126143717.GP6602@lunn.ch>
 <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
 <20191127185129.GU6602@lunn.ch>
In-Reply-To: <20191127185129.GU6602@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMjBiYzI1MTMtMTFiOS0xMWVhLWFlYzAtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDIwYmMyNTE0LTExYjktMTFlYS1hZWMwLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMjA2MyIgdD0iMTMyMTk0MDMzNDE0MzkzNDE0IiBoPSJ2blJGbDRZT3loRFVoTkRWcWpOQU4zQW5scFE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5679546e-eb76-478d-da18-08d773dd06ca
x-ms-traffictypediagnostic: BY5PR07MB6529:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB6529D75F3C446B9FAF5DFF08D3470@BY5PR07MB6529.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(36092001)(199004)(189003)(13464003)(74316002)(305945005)(7736002)(8676002)(81156014)(25786009)(99286004)(33656002)(81166006)(8936002)(54906003)(316002)(2906002)(6116002)(3846002)(2501003)(66066001)(186003)(26005)(53546011)(6506007)(6246003)(4326008)(55236004)(14444005)(102836004)(256004)(110136005)(11346002)(446003)(6436002)(14454004)(229853002)(7696005)(9686003)(478600001)(55016002)(86362001)(66946007)(76176011)(66556008)(64756008)(5660300002)(52536014)(71200400001)(71190400001)(66476007)(76116006)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6529;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y/k1KofZJH+1te/8kJ+114x7l2mp+2XWgp7lScqceW3On6LADKJmAhShaxWewueH59m/NLUTrkweRr6UydBci+t/uUmeiyP+NfXSeFtzsnRkeYtA2ieeM7lrucZjDA4NF72S2IMgsCguIRDAFndmb7+jSkoG6qnstTm2FvI0Tu3OTDwPfHJE/oFtbJYozzcsNx7W1vaNXJ9ZQUkc8ydt2CmtkwaUMNC+EhDUZfJlhwHc32aNwRKlcmhqDtf21HtfgMoA9CtVTdfu8SZb6THYpu/HAhdIvhveRBKFqg3t0fuh3Qfk5GwsBZECgozQgVZxd15iwFQNRpA1YycwUw+x7yvHf7tvOQvF1hglZZ86TAQq5m+UHvlko1l4cNzQNIxJ1c8LlVEGMk2xJt1lVkGeKYzQNS0ERV/WQkEQGmtmp0UyK/bkzF04HIXnlFRG5hnn9gbdTeox6AD64Lq/x6AzzA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5679546e-eb76-478d-da18-08d773dd06ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 08:29:03.3429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e9McxgzzAIb+PZ17QTmBXhTGPgV4kLfWWHuDDioJ6nz0/ZFooRjXk77oNNI5jCtwUhcNx5ARTn8EgPcQLNDGiDuTpyMPNwrqzUFlWYU076g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6529
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_01:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 spamscore=0 clxscore=1011 priorityscore=1501 impostorscore=0 phishscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Thursday, November 28, 2019 12:21 AM
>To: Nicolas.Ferre@microchip.com
>Cc: Milind Parab <mparab@cadence.com>; antoine.tenart@bootlin.com;
>davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
>hkallweit1@gmail.com; linux-kernel@vger.kernel.org; Dhananjay Vilasrao
>Kangude <dkangude@cadence.com>; Parshuram Raju Thombare
><pthombar@cadence.com>; rmk+kernel@arm.linux.org.uk
>Subject: Re: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
>
>EXTERNAL MAIL
>
>
>On Wed, Nov 27, 2019 at 06:31:54PM +0000, Nicolas.Ferre@microchip.com
>wrote:
>> On 26/11/2019 at 15:37, Andrew Lunn wrote:
>> > On Tue, Nov 26, 2019 at 09:09:49AM +0000, Milind Parab wrote:
>> >> This patch modify MDIO read/write functions to support
>> >> communication with C45 PHY.
>> >
>> > I think i've asked this before, at least once, but you have not
>> > added it to the commit messages. Do all generations of the macb suppor=
t
>C45?
>>
>> For what I can tell from the different IP revisions that we
>> implemented throughout the years in Atmel then Microchip products
>> (back to
>> at91rm9200 and at91sam9263), it seems yes.
>>
>> The "PHY Maintenance Register" "MACB_MAN_*" was always present with
>> the same bits 32-28 layout (with somehow different names).
>>
>> But definitively we would need to hear that from Cadence itself which
>> would be far better.
>
>Hi Nicolas
>
>Thanks, that is useful.
>
>I'm just trying to avoid backward compatibility issues, somebody issues a =
C45
>request on old silicon and it all goes horribly wrong.

This patch doesn't affect current C22 operation of the driver.=20
However if a user selects C45 on incompatible MAC (there are old MAC, prior=
 to Release1p10, released 10th April 2003) MDIO operations may fails.
Adding check will cover this corner case.

We will add this check in v2 of patch set.
>
>       Andrew
