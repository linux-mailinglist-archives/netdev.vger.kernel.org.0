Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4410D395
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 11:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfK2KCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 05:02:41 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:21228 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfK2KCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 05:02:40 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATA2OZe026257;
        Fri, 29 Nov 2019 02:02:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=D+pkfR0R1MFGBxlra7XVKqS+7WJ+d9z0Ebmq98YoHHE=;
 b=jeiB0VcP/bmKxQ2XD1XZY7II0wZ0j+1xoSc3vZ4Tg0oZJtxgRrDFu5C2fgcc+Z3iKL6J
 821OAYxFikIPpbQcfyrwLKHNDCeTLsLyXHFkM/HOi41HscSpJo/GeeucFx8yMn6Hxq5o
 FKU6h4f41ketaa3DHyLpJZ+oWmdJFwd7YTIk2dhRZhccvD/I7XhKxqnb8P6k/6vnMT2x
 NWypnb1XuVKfO+nqu2zFDeGNdD7oJB8vAFrqDaf2Ve/nwoIKvBYVzEsOmIhqsC3GPnVr
 kmabr+TB3OcvfbyaJkY0LaNbtJL+X6LIgYZeh/0dMNiyJ0vQ6yB0NmZMWVrC8Jko81SZ mg== 
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2whcxguh84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Nov 2019 02:02:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNaTM6Y65CoCdpQyXofQwkjIgcE1lSxxNOAcOhIo/ZW1KZePP4LjrIlVUlwQJ7Q0Wg94Oew0bChY1Gt2DJg4nE4GqeVpPR/6cE6qlA8uobf9TCsr3s5oT4vUsIa2HGprx++mSgJZlQpxjIpfjzfS3bqNaU7IoExu3aXRLncIi0wEiZIIgU4WNtQNqgJEiARrbKny73H+WlL0qQasq9esG79pW+cGqt9h0F+rLPjqii6yIYqudNFDKsC0U1+Hu0ccez3nmGqcxHq5SuoEk7NJj2Zgv9yw68BvQgt3I8JUpx2KbHwfDP+aBeBPj9H01XBLpRZBgzCtTg4TGYCUMp473A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+pkfR0R1MFGBxlra7XVKqS+7WJ+d9z0Ebmq98YoHHE=;
 b=T+Cw8+WVIpQpAtVjDbhBnZnp5PNFOqfCB+5v2SzpOQgDLgKSTkMsQmBhCgAKYItbyRzctr2z/XqpyJOllsWOcdttc+icfgcjCimjxPFqNjlrKkknObL4ha7swVGQ3oKYaz76aTgGumsmb7LTNapiBOMqs28psfGyq/6A8lbAomvfXXy2iI1TgXB0qZjPWpb1+MYe3zUQXNh0pzXL+zqjYqz3N4m/XDzVJX+UNS5CMjP9+XN0rEMpOumL+Ie+XzJFP5JCPpG+B0rmyON3+XIIfEqvEYnI2AW2rfrPnmWbuv6kw90w+5S7R8dCqweRLwoHDW4x0GCbnbIe9vBT6SOUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+pkfR0R1MFGBxlra7XVKqS+7WJ+d9z0Ebmq98YoHHE=;
 b=eJ1oW9GJIY88oy5yZVkrKeDR3bVtUAMfv/zFUzKY3TyDur2ZQwhJBk1Nr1wVqGpkNf15FWjGAYnD/XKn7rVbxaLRhCOWj45aWsb3RtuVziG0oh2lRlvv4yKwpx+jPexi87d16n0MeRLUQFS+Mr+iNyYc4dqfvKV+LyfswpomGVo=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6753.namprd07.prod.outlook.com (10.255.163.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Fri, 29 Nov 2019 10:02:18 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768%7]) with mapi id 15.20.2495.014; Fri, 29 Nov 2019
 10:02:18 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
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
Thread-Index: AQHVpDlIbouhzt0t6EC8eA8NTGVfbqedhY2AgAHT4gCAAAV5gIAA4gUggABtngCAATr40A==
Date:   Fri, 29 Nov 2019 10:02:18 +0000
Message-ID: <BY5PR07MB6514E3FB613AFD01FD8DEA70D3460@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
 <20191126143717.GP6602@lunn.ch>
 <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
 <20191127185129.GU6602@lunn.ch>
 <BY5PR07MB65147759BC70B370E6834451D3470@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191128145246.GD3420@lunn.ch>
In-Reply-To: <20191128145246.GD3420@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNTIyMmIyYjAtMTI4Zi0xMWVhLWFlYzAtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDUyMjJiMmIxLTEyOGYtMTFlYS1hZWMwLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMTg4NCIgdD0iMTMyMTk0OTUzMzY2MjY5MjkzIiBoPSJyVjRveHF2MTE4NFBZUStKREVKdG1FSzVOREU9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d7e2117-5888-4ef6-26dd-08d774b33832
x-ms-traffictypediagnostic: BY5PR07MB6753:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB6753674322DD2B1F81A57030D3460@BY5PR07MB6753.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(36092001)(199004)(189003)(478600001)(8936002)(26005)(71200400001)(14454004)(6506007)(71190400001)(55236004)(102836004)(256004)(7696005)(316002)(76176011)(54906003)(11346002)(186003)(6246003)(446003)(14444005)(25786009)(66946007)(4326008)(33656002)(6116002)(66556008)(66476007)(2906002)(66446008)(76116006)(229853002)(9686003)(6916009)(86362001)(6436002)(55016002)(74316002)(66066001)(5660300002)(7736002)(81166006)(81156014)(99286004)(8676002)(305945005)(64756008)(52536014)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6753;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Hg0jpQb7vbzj7XlsF9LLTnrLqi+XqVOLoj7oDvq9PF01hJQjpng+fmXmb4UAgN0gSv69jnDYlnrg3MPgdds3Ga5UKQuzCQVSNUKJwgHAggHK1LkTCfmSbUG2N0SoLFScb7AoL4e4GcwNC5KswaeXADIqiT6feybTRnDRfrg9jpMbghx2PnI2e9BG8GF/EFh2qpFMdFSqGDAD5bQFTp1fh08dG7YHU4SgiFeqpP83CVgUA2RCaYaU+JUcMine0r5gbfM7jRDfsc/WAoFv9aHkzJ4YX7SPFUUyNbNftv5DlyUArz1wPpCSdW2cbKtOVMWCaEX8j2hn8n24gCJnlsl9WJMIdLTlrAPIsMwZKJc8EYV0fcmzKsB+4JVSa26DmbwPH07wo1blgp7UlEjYftBoB6BS64taTDZNxhRcHfLFf2qEADhT4ui+o++wVVM/WJxEFzzMo8ylYr8g7nBYOogpg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7e2117-5888-4ef6-26dd-08d774b33832
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 10:02:18.5424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQoalA3ZcMTTZm/srRDQbBYJoNjUPdj9hOLq3b2R1U3TCTJixQUZnQcwwMV0yP77wjCACKWPRhxYMXrrGGl7RjPklcNfHKvUxB07VbUcWzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6753
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_02:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911290088
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>> This patch doesn't affect current C22 operation of the driver.
>> However if a user selects C45 on incompatible MAC (there are old MAC,
>prior to Release1p10, released 10th April 2003) MDIO operations may fails.
>
>How do they fail? Lockup the chip and require a cold boot? Timeout after
>10ms and return -ETIMEOUT?
>
No such catastrophic failure will happen. Failure will only on the possible=
 response from the PHY.
Hence, it is safe to assume all versions of the MAC (old and new) using the=
 GPL driver support both Clause 22 and Clause 45 operation.
Whether the access is in Clause 22 or Clause 45 format depends on the data =
pattern written to the PHY management register.

On response from PHY which would depend on the Start of Frame SOF
The relevant parts of the IEEE 802.3 standard are for identifying Clause 22=
 and Clause 45 operation is here:
22.2.4.5.3 ST (start of frame)=20
The start of frame is indicated by a <01> pattern. This pattern assures tra=
nsitions from the default logic one line state to zero and back to one.

45.3.3 ST (start of frame)
The start of frame for indirect access cycles is indicated by the <00> patt=
ern. This pattern assures a transition from the default one and identifies =
the frame as an indirect access. Frames that contain the ST=3D<01> pattern =
defined in Clause 22 shall be ignored by the devices specified in Clause 45=
.

>Currently, there is nothing stopping a C45 access to happen. There has bee=
n
>talk of making the probe for C45 PHYs the same as C22, scan the bus. I gue=
ss
>that would be implemented by adding a flag to each MDIO bus driver
>indicating it supports C45. All 32 addresses would then be probed using C4=
5 as
>well as C22. So we need to be sure it is safe to use C45 on these older de=
vices.
>
>      Andrew
