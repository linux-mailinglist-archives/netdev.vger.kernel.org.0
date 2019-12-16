Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C712065A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfLPMuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:50:37 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:22728 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727553AbfLPMug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:50:36 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGCn1S5003619;
        Mon, 16 Dec 2019 04:50:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=tEI7QE7nDju/ykHEg0QFS8COrGZi/cqo97a+Zg/Tmw4=;
 b=Geex0bV5ac3GMj0BZaRYScLBQ2O5rta3TF7EFih5eAGiAG3ZlYdDnKbcPJWUqm61TJTT
 faXW8moYTFI3tNToY6Lq2eOh8MHgF11P+WMDUOO5Ha4aJ8qO7HroBqaMxIzcXakYBge/
 3etphG4aBirUytcqTqTf12HRU2cdhOTCx4JXSgamUPZcc11ph4TV+rVL4JIbmKx3AtnF
 yYMDAkxFl27aDUgxiy4U3zjvMnCakurbxGyROlByrUtN8dPmSspor1xTrEmSDSnb13AN
 3RIHB0cHd6cAP/ZjH9L5ENn7XrFtRwVqSMxkHMF73lSFSS07y9sIoE5qW2iTs9/pZzDn oQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2052.outbound.protection.outlook.com [104.47.36.52])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2ww1b8dbcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 04:50:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpGRPUoQ1JI7N+zniDlWpifdAkfCTaBkq5whAK2vFqfBn9oYelXWHese/ABFfuhiJWEgRb6FVSDOD+JhztN0DVyhTlS3cisEPYGdf9b94c8s2nX8N9P/RxT9O9LA1lrr0iCUfI9dAsMG208SY5Gjy/Di3tN/BXWUbV6gvueH/A28z5SNtw97rAE6HZ6xBA4tVRN2jf7LF4GnzVX5PhyMoEwQbFWZjaTbt5GKkQkZ1r7HoBrI/M+PFXuL00bam/qAA1DZoScu364m30oG7vx0d6IJZF1ljQLGzjJIcMzdtcleDIMfMJg/u9o50iBWj+1zsRydL9Al7kBDoVx4RM5h/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEI7QE7nDju/ykHEg0QFS8COrGZi/cqo97a+Zg/Tmw4=;
 b=c/+9LI7XZCV0b+SbZ5GmXTy1XLnT5AtZR+j5htjbME/FDdwUV8EIcGT112OD1sISEE9LDbPlfA0jzG+h3FjElA0U60sA052eAKZwMhkLil1tgh2iUKaJ3TWbxWkwI1gUIex1WcDb/vDQZ8Cq1w4fy/SS7g5nZ3P7rDnKMxY+X27PRXszqAQ1GWopY1rFUJPGl8cBZDWuiq2tlpiWBGVMi3HNE+7eyMPBVuwaID5Ctv/9To7HpveJgtIZxqMCpnBsGmubENmN8eHZqT/HJjZ8a19EHXKeRhhAs0UVd/PP7tv2kIQPlGibOo3zXQCOgPU2VM8DhGb06NcLGjBZkQhwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEI7QE7nDju/ykHEg0QFS8COrGZi/cqo97a+Zg/Tmw4=;
 b=5ngRq96tOBmb+OyovB+lB4f0tiZOeBtmJnmWNXa9auEUqfBKoWK6SG/RZ2YfcIFQR15YunWAWAyRuAa+7uSUbUZ4VHxiOR7b/yXA7WMXe0jVjMuIUt4X0u4LySb4HFJLHWpor163D+DTQBeTBzrlq+4oHbW1V0ixy7LZtnfaGS0=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6625.namprd07.prod.outlook.com (10.255.137.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Mon, 16 Dec 2019 12:50:00 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 12:50:00 +0000
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
Thread-Index: AQHVsZm5l82MVXLf60OyobQPmImAGae7UQaAgAACAgCAAWMWwA==
Date:   Mon, 16 Dec 2019 12:49:59 +0000
Message-ID: <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
 <1576230177-11404-1-git-send-email-mparab@cadence.com>
 <20191215151249.GA25745@shell.armlinux.org.uk>
 <20191215152000.GW1344@shell.armlinux.org.uk>
In-Reply-To: <20191215152000.GW1344@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOGZlODM1MzEtMjAwMi0xMWVhLWFlY2QtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDhmZTgzNTMyLTIwMDItMTFlYS1hZWNkLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iNzA5NSIgdD0iMTMyMjA5NzQxOTc0OTIzODYwIiBoPSJ2SWhSaEpCNHo4dTErRi9YUDkyS2hUdEJhRDA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1adbcf5c-5a05-4320-c6ff-08d78226765c
x-ms-traffictypediagnostic: BY5PR07MB6625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB6625EB7FB608F40E24496BFFD3510@BY5PR07MB6625.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(36092001)(9686003)(64756008)(66446008)(66946007)(66556008)(6916009)(66476007)(76116006)(7416002)(55016002)(316002)(54906003)(71200400001)(33656002)(8676002)(81166006)(7696005)(6506007)(86362001)(55236004)(5660300002)(52536014)(186003)(107886003)(478600001)(4326008)(26005)(8936002)(81156014)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6625;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QLpRb8+V+2qx6yNKyd/PcAwObNemDM7B2/UNUnvpNhpXYhKt+m1MzCS4wK0cBmDg6qakNTVqbJ60OBNpbQRZVJCxVSMgtdrRjdmL+Nmk9r7bzceF2fcbrNY5kccem1Alj0fHjaGiizXuXxSbbprxSmYmxhWMVoWdCy1uOf5zyOhkJi5/ZHInG8mOzfn0PLCqcIw5o+QR2Ov1GgHf6cnPMpdHcpE76QhHMrpCrEIejtLS/0KKjuKs3pFkt5N6D+s3TTeu9J0kfLMX5petpUq+ASlaZLL/Qa3rUnP8j7SDUv+XWTfVuZLWfnbJzwN26fo9O+EDDqNsmofGtTcrqu9R3+sz6xr9qNBqaMU52SBaDqvoQuxVACwe/pCMQylGR5xw6VVxM/tlLxpATNL37oOiBjQRVz8f/noPZjeuHvReqNe4SSC04jkojYj6FZR/ufu06S++AZm7eZLobteUMbP0T+losWHSrFNpV1foDSnTUFHNTNz7jKCTfTZ2wjhv2YZU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1adbcf5c-5a05-4320-c6ff-08d78226765c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 12:49:59.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 73k+GEdWRz0nsFhdYFgW9xSuBUwDxunW5mDIxbk2BadQiNzIkR9OAPxTA/5lnBHX9oaX4q82Clu6+XeudlgJvh8QzpXUJ6UPEWRXp2eJgs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6625
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_04:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> > +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_USXGMII) {
>>
>> Why bp->phy_interface and not state->interface?

okay, this needs to change to state->interface

>>
>> If you don't support selecting between USXGMII and other modes at
>> runtime, should macb_validate() be allowing ethtool link modes for
>> it when it's different from the configured setting?

We have separate SGMII and USXGMII PCS, which are enabled and programmed=20
by MAC driver. Also, there are separate low speed (up to 1G) and high=20
speed MAC which can be programmed though MAC driver.=20
As long as, PHY (PMA, external to Cadence MAC controller) can handle=20
this change, GEM can work with interface changes at a runtime.

>>
>> > +		if (gem_mac_usx_configure(bp, state) < 0) {
>> > +			spin_unlock_irqrestore(&bp->lock, flags);
>> > +			phylink_mac_change(bp->phylink, false);
>>
>> I guess this is the reason you're waiting for the USXGMII block
>> to lock - do you not have any way to raise an interrupt when
>> something changes with the USXGMII (or for that matter SGMII)
>> blocks?  Without that, you're fixed to a single speed.

Yes, we need to wait (poll) until USXGMII block lock is set.
Interrupt for USXGMII block lock set event is not supported.

>
>BTW, if you don't have an macb_mac_pcs_get_state() implementation,
>and from what you described last time around, I don't see how SGMII
>nor this new addition of USXGMII can work for you. Both these
>protocols use in-band control words, which should be read and
>interpreted in macb_mac_pcs_get_state().
>
>What I think you're trying to do is to use your PCS PHY as a normal
>PHY, or maybe you're ignoring the PCS PHY completely and relying on
>an external PHY (and hence always using MLO_AN_PHY or MLO_AN_FIXED
>mode.)

We are limiting our functionality to 10G fixed link using PCS and SFP+
Though the Cadence MAC is a full functional ethernet MAC controller,=20
we are not sure what PHY or PCS be used in the end system.
Hence we are using PCS PHY as a normal PHY and not dependent on=20
macb_mac_pcs_get_state(). Also it should be noted that we are=20
not doing any change in SGMII. Status available in PCS is=20
just a "status transferred" from PHY. So in case of SGMII, whether=20
we read from PCS or from PHY, it is the same information.=20

Below are listed all the possible use cases of Cadence GEM 10G controller

Basic MII MAC/PHY interconnect using MDIO for link status xfer.
 +-------------+                                    +--------+
 |             |                                    |        |
 | GEM MAC/DMA | <------ GMII/RGMII/RMII/MII -----> |  PHY   |
 |             |                                    |        |
 +-------------+                                    +--------+
       ^                                                 ^
       |_____________________ MDIO ______________________|

No PHY. No status xfer required. GEM PCS responsible for auto-negotiation
across link. Driver must interrogate PCS registers within GEM.
 +-------------+                                    +--------+
 |             |       |        |                   |        |
 | GEM MAC/DMA | <---> | SerDes | <- 1000BASE-X ->  |  SFP   |
 |    PCS      |       | (PMA)  |                   |        |
 +-------------+                                    +--------+     =20

SGMII MAC/PHY interconnect using MDIO for link status xfer.
 +-------------+                                    +--------+
 |             |       |        |                   |        |
 | GEM MAC/DMA | <---> | SerDes | <--- SGMII --->   |  PHY   |
 |  SGMII PCS  |       | (PMA)  |                   |        |
 +-------------+                                    +--------+
       ^                                                 ^
       |_____________________ MDIO ______________________|

SGMII MAC/PHY interconnect using inline status xfer. Multi-rate.
Driver must interrogate PCS registers within GEM.
 +-------------+                                    +--------+
 |             |       |        |                   |        |
 | GEM MAC/DMA | <---> | SerDes | <--- SGMII --->   |  PHY   |
 |  SGMII PCS  |       | (PMA)  |                   |        |
 +-------------+                                    +--------+

Up to 2.5G. MAC/PHY interconnect. Rate determined by 2.5GBASE-T PHY capabil=
ity.
 +--------------+                                  +-----------+
 |              |       |        |                 |           |
 | GEM MAC/DMA  | <---> | SerDes | <-2500BASE-X->  |2.5GBASE-T |
 |2.5GBASE-X PCS|       | (PMA)  |                 |   PHY     |
 +--------------+                                  +-----------+

No ability for host to interrogate Optical.
 +--------------+                                  +-----------+
 |              |       |        |                 |  SFP+     |
 | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | Optical   |
 |   USX PCS|   |       | (PMA)  |                 | Module    |
 +--------------+                                  +-----------+

Additional 3rd party I2C IP required (not part of GEM) for module
interrogation (MDIO to I2C handled by SW
 +--------------+                                  +-----------+
 |              |       |        |                 |  SFP+     |
 | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | Optical   |
 |   USX PCS|   |       | (PMA)  |                 | Module    |
 +--------------+                                  +-----------+
                                                         ^
        +--------+                                       |
        | I2C    |                                       |
        | Master | <-------------------------------------|
        +--------+

Rate determined by 10GBASE-T PHY capability through auto-negotiation.=20
I2C IP required
 +--------------+                                  +-----------+
 |              |       |        |                 |  SFP+ to  |
 | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | 10GBASE-T |
 |   USX PCS|   |       | (PMA)  |                 |           |
 +--------------+                                  +-----------+
                                                         ^
        +--------+                                       |
        | I2C    |                                       |
        | Master | <-------------------------------------|
        +--------+

USXGMII PHY. Uses MDIO or equivalent for status xfer
 +-------------+                                    +--------+
 |             |       |        |                   |        |
 | GEM MAC/DMA | <---> | SerDes | <--- USXGMII ---> |  PHY   |
 |  USX PCS    |       | (PMA)  |                   |        |
 +-------------+                                    +--------+
       ^                                                 ^
       |_____________________ MDIO ______________________|


>
>
>
>--
