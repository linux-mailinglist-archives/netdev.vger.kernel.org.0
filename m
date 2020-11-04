Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A482A658F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgKDNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:53:57 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:25408 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726527AbgKDNx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:53:56 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4Dj0tN029151;
        Wed, 4 Nov 2020 05:53:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=vL9KrAm6gZfFJxg3EmdJWOt7gIQCVEYSrig7HyanXUM=;
 b=DUS5+tl9hSVtHe6t1VxuJpBubikWV7lJ4jEdzL/4/E4YERAHA39O0BdCS0V71npmWCZa
 QUGv4iYMbJPoeKYtXWY3eTfrkuWSTJCS76q989D7gBcGZViqKXnFFWJewwu1hD9e9yV4
 nRLo30cJwKOK4b3MWS+pk4w68zmopTP8cZO9jII5k9pnT46U1pL2nDgn9E32Bk+OHHUV
 PodFV6HpNjkz6AragtXNh9gtvjP+c+gFIKZmYlCIQDxM50hr6ZqHlZr3flNI35oSlkn7
 lILsPSGQ91IY/PHvY5Nq/3V2RrsgE+VqXM8l9rYH0UDdbIBFZ2FBp/AzLlA22AuDtUdx 9Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0014ca01.pphosted.com with ESMTP id 34h3gx0ew7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 05:53:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heX+l08AT+0TqQxPzh+HNFBrXX66DRD7Dis8rhtySvUtYXc49QTj6qwitYWWxR2MofKccc4CWyJjuqoQxX1B7O6ZQwhcK6SAFk9UIpszE/NLLBb1j9ZurBWhbrGkm8JiE9ul/ly0+dwOBpxTSKddT/xVl+raZ/19CU9fcwTKwB5AkRwh8o5qwmgZHKKU829TuUvvcjxgle5dSW/nJCIfTCD64HMuAS73yz1diWnD7qqQCS5qgpUv3yOa8spHEMphJPNk/BZS/B9Oo3CmJp9KkPLKberz24IJoR4ZZG44Ku9tu8XH0EsKBbFXdFRP+4bTlOhO+SzNPYFUmeXg1OzYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL9KrAm6gZfFJxg3EmdJWOt7gIQCVEYSrig7HyanXUM=;
 b=mEPA1+65NaX50IV6hkxejouxg3Z/PeGcLIn3BsaPeaWag9nsJRNfWHQG8ZqNEUM/tRIKMzgGEXAbqXaVt06VsJvdkiIPd7bhv4wPrpNiQuMPkqaqFByCY3FwKtNc2hlMBJ28Ee4YH9DQN5IJXALnhi6G4xSpO4Ri5L3CjOUgY+dz86+VL6ms0okKrbufw9jRltzPw/B08U/jNTdlND9tizsTMvv3IjvxdZ/gEsityXZDALdnMkspnOKAvTmHEwnsVFSo82yzQgcNHz9iZr98wpbg8AQ3eWi587YBvxUZ57M+eXskst0KatkcvCqqPqQx1eKZ2cOPmx7tb1GTeuj9Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL9KrAm6gZfFJxg3EmdJWOt7gIQCVEYSrig7HyanXUM=;
 b=LAbMoyB6CT5M0d6gvYgNXdXJ2wyUSVGqzYT2St7M89hivdop4S+E8eBGTL/4y3COmqLzJvKph1cUMo2NcLLORRXlpUqcE/kMuiFuEr+A6X3Jnxo6U7Yiw0SDb8d02iDmuTLLBwN5/nF4hy24pS1YQ8QHC8JaEK2G1my/knfAh6c=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DS7PR07MB7718.namprd07.prod.outlook.com (2603:10b6:5:2c9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.19; Wed, 4 Nov 2020 13:53:27 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 13:53:27 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "Santiago.Esteban@microchip.com" <Santiago.Esteban@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>
Subject: RE: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Topic: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Index: AQHWsq6BvPM9dPOV2Uq2LXB0FhVdIqm3+1ww
Date:   Wed, 4 Nov 2020 13:53:27 +0000
Message-ID: <DM5PR07MB31962607B69631EC5F742A54C1EF0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <2db854c7-9ffb-328a-f346-f68982723d29@microchip.com>
In-Reply-To: <2db854c7-9ffb-328a-f346-f68982723d29@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0xOWQwMzA1MC0xZWE1LTExZWItODYxMS0wNGQzYjAyNzc0NDdcYW1lLXRlc3RcMTlkMDMwNTEtMWVhNS0xMWViLTg2MTEtMDRkM2IwMjc3NDQ3Ym9keS50eHQiIHN6PSIxMDY2MCIgdD0iMTMyNDg5NzE2MDI3MjkyOTcwIiBoPSJKaGNaaUh4Y3gxK1VoZ1dHNGl2bFpXd3lWMFk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [64.207.220.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddf03edb-0383-495b-5d62-08d880c90177
x-ms-traffictypediagnostic: DS7PR07MB7718:
x-microsoft-antispam-prvs: <DS7PR07MB77180063E1E4F5ECC6EEC384C1EF0@DS7PR07MB7718.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FsqFUuHl7hXl/f1eCC2chA4U+foHez7R6glqYumjjP/NbAvHTsgauWvARzvbPkB+BRAtjFrNIy0CxCIrq3sGKyqB9Kl/oosqSdqQzELd3hxYRBIx3mK8vjqvWnAWtxYMaEumGJTCU0Rh8QV+xl/cKECom74Ehj3+cS2KMvCwKu6S3tj4ueNLvw0Q3d6yyxxe3W+Rufhx20XjffAf2opnvW/eQYlMIqUpc39wz/Gd2xhdy3KhKdXxqUnRLtQVetAfX1XojqhqhszJ5xDP4ewFs3MorXEeOdx2c54wrg9vYrWGBKQy/4auHu6qe5gt34h0rKWzEBoUwejaAal77sKc8pL63M7bVBJs6TTN5zYTR3M9nYlPwyAv11L4AtSqh9556WQ3ArzLZ132T9+60oCUZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39850400004)(396003)(36092001)(83380400001)(71200400001)(76116006)(66446008)(66556008)(8936002)(8676002)(9686003)(66476007)(66946007)(64756008)(5660300002)(33656002)(52536014)(186003)(2906002)(7416002)(26005)(55016002)(478600001)(4326008)(45080400002)(7696005)(6506007)(316002)(110136005)(54906003)(86362001)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 677syWdJ9267V789rm09caUnktemj/0R4CPfKFdmiOG7qYHTzRE8v9ticORQdYp7pe9aStkaGqWCN57cJMiZcyxvUy9H0BSKDoPzgtGiNqurYaTRUn0nt2rgjEJj5fYfTM5usxWg7NVQ/PTw8Mh3tGzsljB7gYplU70zD35y+VjGeS24Uh1o/J9geEZ8EhASNdVUrJsho2cVIm5Vc9RLN3fplfPFPB3lcFN4Xvg+iV+netiR3VmMEdJy5N8bUBa/AAHiq0zFZ7QD4UKNZpuflby2Ca4isQEVxNtvG/lrbhIG7ckWnDGxs15M3QchJtb1KCaaLdfC0yfwQlbxFn+mgAaQHD4eKfzu11jfE8e4nruw9FAzMdUHi03JpdgvEKm24azoMBFUvKb/A8TqZKVcj4YG7pIGYIhXc4dzm7r8V1j1ofKx19Iu24bkTU2PGsvuHEsPR5fZAdioOBm9TP98nH7fuuFe/+OFbyIvudfrfvnTH4jWm6uZcm0Exd4agh/bW95dGp/QCyzRxy4YB51a0WugYLKTU59P3MPr1oVrq+aR9XEpKe4urJL3wCX2nKV0TODEDl+p9liLjpdGlv9ww0VpD7daj/lTqnzTz+n1851D4pId9ly5ukJFCrmHPZ36oDpK2hkDeNcBBefDXetluA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf03edb-0383-495b-5d62-08d880c90177
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 13:53:27.1948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPaFmdr6Xtx58Es7xrxuO9HCqPEfHu2Bn9Jn6vCUOpdRM4v9+F9b0ru+vKi9DiAgZQ2WtwrGT6+8zZR/crKiIxzaRPwND8uNxY5KSJivwyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR07MB7718
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_08:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011040103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

Thanks for reporting this.
It seems NULL pointer dereference is happening in following line.

 437 static void phylink_major_config(struct phylink *pl, bool restart,
 438                                   const struct phylink_link_state *sta=
te)
 439 {
 ......
 457                 err =3D pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_=
an_mode,
 458                                               state->interface,
 459                                               state->advertising,
 460                                               !!(pl->link_config.pause=
 &
 461                                                  MLO_PAUSE_AN));

Because of pcs_config =3D NULL in pcs_ops registered for non 10GBASE-R mode=
s here.

777         if (interface =3D=3D PHY_INTERFACE_MODE_10GBASER)
 778                 bp->phylink_pcs.ops =3D &macb_phylink_usx_pcs_ops;
 779         else
 780                 bp->phylink_pcs.ops =3D &macb_phylink_pcs_ops;
 781
 782         phylink_set_pcs(bp->phylink, &bp->phylink_pcs);

This should have been something
                 if (interface =3D=3D PHY_INTERFACE_MODE_10GBASER)
                         bp->phylink_pcs.ops =3D &macb_phylink_usx_pcs_ops;
                 else if (interface =3D=3D PHY_INTERFACE_MODE_SGMII) =20
                         bp->phylink_pcs.ops =3D &macb_phylink_pcs_ops;
	  else
	          bp->phylink_pcs.ops =3D NULL;
=20
                 if (bp->phylink_pcs.ops)
 	         phylink_set_pcs(bp->phylink, &bp->phylink_pcs);


Regards,
Parshuram Thombare

>-----Original Message-----
>From: Nicolas.Ferre@microchip.com <Nicolas.Ferre@microchip.com>
>Sent: Wednesday, November 4, 2020 6:59 PM
>To: Parshuram Raju Thombare <pthombar@cadence.com>; kuba@kernel.org;
>linux-arm-kernel@lists.infradead.org; netdev@vger.kernel.org
>Cc: Claudiu.Beznea@microchip.com; Santiago.Esteban@microchip.com;
>andrew@lunn.ch; davem@davemloft.net; linux-kernel@vger.kernel.org;
>linux@armlinux.org.uk; harini.katakam@xilinx.com; michal.simek@xilinx.com
>Subject: net: macb: linux-next: null pointer dereference in phylink_major_=
config()
>
>EXTERNAL MAIL
>
>
>Hi,
>
>Heads-up on this kernel Oops that happened and has been observed on
>linux-next since 20201103 and was not existing in 20201030.
>
>I didn't went further until now but wanted to report it
>as soon as possible.
>Could it be related to newly included patch
>e4e143e26ce8 ("net: macb: add support for high speed interface")?
>
>Tell us if you saw it on other platforms or if you couldn't reproduce it.
>
>[..]
>Linux version 5.10.0-rc2-next-20201104 (root@linux-ci-43h78-cjbps) (arm-li=
nux-
>gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (a=
rm-
>rel-8.36)) 8.3.0, GNU ld (GNU Toolchain for the A-profile Architecture 8.3=
-
>2019.03 (arm-rel-8.36)) 2.32.0.20190321) #2 Wed Nov 4 07:31:39 UTC 2020
>
>[..]
>OF: fdt: Machine model: Atmel SAMA5D4 Xplained
>
>[..]
>libphy: Fixed MDIO Bus: probed
>libphy: MACB_mii_bus: probed
>macb f8020000.ethernet eth0: Cadence GEM rev 0x00020120 at 0xf8020000 irq
>27 (fc:c2:3d:0d:eb:27)
>
>[..]
>
>Configuring network interfaces...
>macb f8020000.ethernet eth0: PHY [f8020000.ethernet-ffffffff:01] driver [M=
icrel
>KSZ8081 or KSZ8091] (irq=3D46)
>macb f8020000.ethernet eth0: configuring for phy/rmii link mode
>8<--- cut here ---
>Unable to handle kernel NULL pointer dereference at virtual address 000000=
00
>pgd =3D 8fd7a220
>[00000000] *pgd=3D00000000
>Internal error: Oops: 80000005 [#1] ARM
>Modules linked in:
>CPU: 0 PID: 250 Comm: ip Not tainted 5.10.0-rc2-next-20201104 #2
>Hardware name: Atmel SAMA5
>PC is at 0x0
>LR is at phylink_major_config+0x84/0x1a8
>pc : [<00000000>]    lr : [<c0509ebc>]    psr: a0050013
>sp : c1cdb8f0  ip : c09530c4  fp : c09530d4
>r10: c12204e0  r9 : 00000000  r8 : 00000001
>r7 : 00000001  r6 : 00000000  r5 : c1cdb918  r4 : c1266800
>r3 : c1cdb918  r2 : 00000007  r1 : 00000000  r0 : c1221100
>Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>Control: 10c53c7d  Table: 21d60059  DAC: 00000051
>Process ip (pid: 250, stack limit =3D 0x362b1cfa)
>Stack: (0xc1cdb8f0 to 0xc1cdc000)
>b8e0:                                     00000001 c0a58564 c1cdb8f0 c1266=
800
>b900: c0d03208 c1cdb918 c1220000 c050b3c8 c0a4bc38 00000000 00000000
>00000000
>b920: 00000000 00000000 00000000 00000000 00000007 ffffffff 000000ff
>00000000
>b940: 00000000 a0250c4f c12204e0 00000000 dfbf0318 c051c450 c12206a4
>c1220000
>b960: c1221000 c1220668 00000001 c051fbac 00000000 fffffff1 c1220000
>c0d03208
>b980: c09530d4 c1cdbd48 00001002 c1cdbd48 c1cdbd48 c064af9c 00000000
>00000000
>b9a0: 00000000 c1220000 c1cdbd48 a0250c4f 00000000 c1220000 00000001
>00001003
>b9c0: c0d03208 c064b368 00000000 00000000 00000000 00000000 00000000
>a0250c4f
>b9e0: 00000000 c1220000 00001002 00000000 c1220138 c1cdbc68 c1082810
>c064b3e0
>ba00: c0d03208 c1cdbb88 c1220000 c1d29900 c1cdbc68 c0656f20 00000000
>00000000
>ba20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>ba40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>ba60: 00000000 a0250c4f 00000000 c1082820 c1d29900 c1082800 c1cdbd48
>a0250c4f
>ba80: c1cdbd48 c1082800 c1220000 00000000 c1cdbd48 00000000 00000000
>00000000
>baa0: c097c1dc c065d2c4 c1cdbb88 c1cdbc68 00000000 c1220000 c0d3cce0
>c1082810
>bac0: 00000000 c0d03208 c1d44a00 c1d29900 00000009 c070df20 c1d29900
>00000000
>bae0: 00000000 00000000 00000000 00000000 00000000 00000000 c1bd0000
>c0d3d72c
>bb00: 00000180 c03a6a70 c1d29900 c1bd03c0 c1d29900 c03a6ab4 c1d29900
>c065c0d0
>bb20: 00000003 a0250c4f c0656170 c1cdbb54 c0d03208 c068a824 f601f5ae
>c101e000
>bb40: c1cdbb38 00040000 02940000 00000000 00010000 00000000 c068a2c8
>c0688238
>bb60: c1cc7c00 c0d03208 a0250c4f c1cc7c00 c1d29900 000003bc c1087400
>c1087564
>bb80: f601f5ae c0d03208 00000000 00000000 00000000 00000000 00000000
>00000000
>bba0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bbc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bbe0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bc00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bc20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bc40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bc60: 00000000 00000000 c1082800 00000000 00000000 00000000 00000000
>00000000
>bc80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>00000000
>bca0: 00000000 00000000 c0d03208 c064ce3c 00000000 a0250c4f 00000000
>c1d44a00
>bcc0: c1d29900 c1082800 c1cdbd48 c1d29900 c1cdbd48 c1082800 c0d5fb34
>c065d548
>bce0: 00000000 00000000 c0d03208 c0d5fb34 c1d29900 c0657e90 c1d09ac0
>c10800c0
>bd00: c0d03208 c1cdbf60 000003bc c0d03208 c1d41bbc c1cdbd3c c0d03208
>a0250c4f
>bd20: 00000000 c1d29900 c0d03208 c0657c48 c1082800 00000020 00000000
>c0d03208
>bd40: 00000000 c068cb10 00000000 00000000 00000000 00000000 00000000
>00000000
>bd60: 00000000 00000000 00000000 a0250c4f c1087400 00000020 c1d29900
>c1cc7400
>bd80: c1cc7564 c068c270 7fffffff a0250c4f 00000008 c1cdbf58 c0d03208
>c1cc7400
>bda0: c1d29900 00000020 00000000 c068c4d8 00000001 c035ca40 00000000
>c1cdbe64
>bdc0: 00000000 c1cdbe64 c1024780 00000000 000000fa 00000000 00000000
>a0250c4f
>bde0: 00000000 c1cdbf58 c068c318 00000000 c0d03208 c15b9a80 c1cdbe0c
>00000000
>be00: 00000020 c0628408 00000000 00000000 c0d03208 c0629af8 c1cdbe60
>c1cdbf60
>be20: 00000000 c101e000 bea7176c a0250c4f 00000000 c0d03208 c1cdbf58
>00000000
>be40: c15b9a80 00000000 00000000 00000128 00546cc0 c0629b84 00000000
>02940000
>be60: 00000000 bea7179c 00000020 c068a2c8 c0688238 00040000 02940000
>00000000
>be80: 00010000 00000000 c068a2c8 a0250c4f 00000007 ffffffff c15b9c70
>c097b500
>bea0: c0d03208 00000010 00000000 00000000 5ac3c35a a0050013 00000000
>c1cdbebc
>bec0: c1cdbebc a0250c4f fffffe30 c1c76300 002e0003 c15b9c70 c15e4110
>c101b490
>bee0: fffffe30 c0d03208 5ac3c35a c01cdc68 00000000 c15b9c70 00000000
>00000000
>bf00: c1d0aaa8 00000000 c1c804c4 c1c80180 00000000 c1c804c4 5ac3c35a
>c012ed04
>bf20: ffffe000 a0250c4f c0100264 c0d03208 bea71718 00000000 c15b9a80
>c0100264
>bf40: c1cda000 c0629f7c 00000000 00000000 00000000 fffffff7 c1cdbea4
>0000000c
>bf60: 00000005 00000000 00000000 c1cdbe6c 00000000 c1cdbfb0 00000000
>c1c76301
>bf80: 00000000 00000000 00000000 a0250c4f b6f644d0 00000000 00000010
>b6f644d0
>bfa0: 00000128 c0100060 00000000 00000010 00000003 bea71718 00000000
>00000000
>bfc0: 00000000 00000010 b6f644d0 00000128 00547008 5aa2f689 00000000
>00546cc0
>bfe0: 00000128 bea716b8 b6e8cd7f b6e0eba6 60050030 00000003 00000000
>00000000
>[<c0509ebc>] (phylink_major_config) from [<c050b3c8>]
>(phylink_start+0x190/0x33c)
>[<c050b3c8>] (phylink_start) from [<c051c450>]
>(macb_phylink_connect+0x40/0xb4)
>[<c051c450>] (macb_phylink_connect) from [<c051fbac>]
>(macb_open+0x1e0/0x2a0)
>[<c051fbac>] (macb_open) from [<c064af9c>] (__dev_open+0xfc/0x180)
>[<c064af9c>] (__dev_open) from [<c064b368>]
>(__dev_change_flags+0x16c/0x1cc)
>[<c064b368>] (__dev_change_flags) from [<c064b3e0>]
>(dev_change_flags+0x18/0x48)
>[<c064b3e0>] (dev_change_flags) from [<c0656f20>] (do_setlink+0x2d8/0xbdc)
>[<c0656f20>] (do_setlink) from [<c065d2c4>] (__rtnl_newlink+0x4e8/0x72c)
>[<c065d2c4>] (__rtnl_newlink) from [<c065d548>] (rtnl_newlink+0x40/0x5c)
>[<c065d548>] (rtnl_newlink) from [<c0657e90>]
>(rtnetlink_rcv_msg+0x248/0x2c0)
>[<c0657e90>] (rtnetlink_rcv_msg) from [<c068cb10>]
>(netlink_rcv_skb+0xb8/0x110)
>[<c068cb10>] (netlink_rcv_skb) from [<c068c270>]
>(netlink_unicast+0x188/0x230)
>[<c068c270>] (netlink_unicast) from [<c068c4d8>]
>(netlink_sendmsg+0x1c0/0x408)
>[<c068c4d8>] (netlink_sendmsg) from [<c0628408>]
>(____sys_sendmsg+0x1a4/0x238)
>[<c0628408>] (____sys_sendmsg) from [<c0629b84>]
>(___sys_sendmsg+0x6c/0x98)
>[<c0629b84>] (___sys_sendmsg) from [<c0629f7c>] (__sys_sendmsg+0x50/0x8c)
>[<c0629f7c>] (__sys_sendmsg) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
>Exception stack(0xc1cdbfa8 to 0xc1cdbff0)
>bfa0:                   00000000 00000010 00000003 bea71718 00000000 00000=
000
>bfc0: 00000000 00000010 b6f644d0 00000128 00547008 5aa2f689 00000000
>00546cc0
>bfe0: 00000128 bea716b8 b6e8cd7f b6e0eba6
>Code: bad PC value
>---[ end trace f10e0fdf87618077 ]---
>
>Best regards,
>--
>Nicolas Ferre
