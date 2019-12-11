Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A4011AA54
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 12:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfLKL4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 06:56:19 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:37970 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbfLKL4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 06:56:19 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBBrXHf030528;
        Wed, 11 Dec 2019 03:55:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=NLD/qbUjbq3pw4Y7fRvfOroX9REzrABLsVPyyrpU9Bo=;
 b=BJDn34wQYy9ZRrqKi76lcfKX8m4xdhEhyddGMIrcYq6pTI0Ul+bqY1zcAAggi6cZRZ4Q
 OqozwhOH17/n1JtC2D3Utt9fuZCMK+sxObajVAZMAYhEcmrvIRjjNzyaCFCDNspf0xNq
 /zdbd0G+v04t6EPGKtE6KN8N9b0USsJlKpmMJQWXPUhz0HCNv1Vy6AvuBXsSrO/P+ait
 wZzapU61mC3AWR5DKK45KHhdLvINKoWktBAADVgl1c3m3GYpTf7KIXLwpGY3gB/rp0Q6
 p+4J5tewQm33zV8eWqStggHo62poxMQp//36+rFbEnZZ0XU1SuXtKCss3broDQyLdsZH dg== 
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2052.outbound.protection.outlook.com [104.47.44.52])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra70dwbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 03:55:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQ2AD62hAZ3IOUO/+sAkEIFW1d6mwoJND5x1+XMU3Oxu+CI4S7XOCEea5ZWxUDOqf5c06linwZyIjTSyTXEbPX6FkFE7f+UsIo4bpF13H3/kICOm0UNqOY6PjwUo7qQZXHvGKlJSb4jejQF0wwnOR7ZbMp3ZKWGGRJkGZbet2xKb1PuT2aoY5uTUfJcZpop/5378F5lMrkdKm4eCksH1qCAbQjryf9dfQ9ci4rez50N+A6OxSsmnx75/zJWx4Phw1ZyIyUGA5DnWkyoynH7TM5fqnlqXDrbhSSZDbkkOorpTQXnlsyuRpgB2OQV/9tZCz15UFo6f+8dNDKkdgraT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLD/qbUjbq3pw4Y7fRvfOroX9REzrABLsVPyyrpU9Bo=;
 b=en/XZd7O4xqatHnPdp9BDMa2KcKnQD30OHtBD+D8kRM4fhdXaD2PcsRwz03T/CiKw4h4YLYUnsnif2VPEX9TayP6cqMSLDpsQrpvBEcMMGxwbGsTKyyhphUMKzljbIMiDcGwHLf5qvh7hyfz0sJNeHjVrbCGOwK2lWnudmzsJvR6wv4teKol4Dnfg2rAG/0rn3/L0bzXtHhgLB072sfJ5qPSge4o3j7jtGMLYbfhW2qHjXlo1q9DdJSKHrBs+Tq87/Fjwc9TwI1XeclaKQ8jA8h0bhEP1g9BN7v5ymCek+Z+bwDdwoZDYqX/U/QRZMkpFFlwBCnRpAo5gHUGkO5Rdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLD/qbUjbq3pw4Y7fRvfOroX9REzrABLsVPyyrpU9Bo=;
 b=6qUMvxHIGKsJ2IE+7vE+C6JrEFPnUvitj69a4Z99jheO4GS+YAmF60kdW/JiOh4VRMzJUJ9D3qoL+rNsV4xaIkjcVsDRvrWLTcnThGBgVthJeyW9PDJc+kwxrE/IuAjamzsn3rPDK/XwAYBVwLrjBiYjAAYomkLg4DG0EOXTtiY=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6769.namprd07.prod.outlook.com (10.255.137.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 11:55:54 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 11:55:54 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
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
Thread-Index: AQHVroIXac2qRLU0l0+QWTJxCA7dLKexrKsAgAF+vXCAABTugIABWthggAAU6gCAAB8r4A==
Date:   Wed, 11 Dec 2019 11:55:54 +0000
Message-ID: <BY5PR07MB6514D56F0D9ED9D9A67108D4D35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
 <20191209113606.GF25745@shell.armlinux.org.uk>
 <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191210114053.GU25745@shell.armlinux.org.uk>
 <BY5PR07MB65147AEF32345E351E920188D35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191211093708.GZ25745@shell.armlinux.org.uk>
In-Reply-To: <20191211093708.GZ25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMmRkNDc5ZDAtMWMwZC0xMWVhLWFlY2EtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDJkZDQ3OWQxLTFjMGQtMTFlYS1hZWNhLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iNTQwOSIgdD0iMTMyMjA1Mzg5NTI3NjcyNDkzIiBoPSI5R29xVHBFWlZoZnhtQk1Ob0w4a2haczZBb2s9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23cba1d1-838b-470a-ef90-08d77e3113ad
x-ms-traffictypediagnostic: BY5PR07MB6769:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB67697A160ABD151D4B8EB78FD35A0@BY5PR07MB6769.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(36092001)(186003)(7416002)(7696005)(26005)(55236004)(6506007)(52536014)(2906002)(316002)(966005)(5660300002)(478600001)(6916009)(55016002)(9686003)(107886003)(33656002)(66556008)(86362001)(66446008)(8936002)(81166006)(81156014)(8676002)(71200400001)(4326008)(66946007)(54906003)(76116006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6769;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iibS2sLZGFLm0D7WwlgrH/PeTPNUZ4aeOuU5AlQSMGGPMx0p1TXr2iMoXcIdJqWL0+eDdboa0t9DGoOYkGGjn+XE4IoKVwNMmSe87sdCEgZ9NKCbzMmXe/UrQG6zKhnGSOBh2wKEP6rVFJUYUC4ljxJP1LJudjrSuPvxJ3yC+68MV8IN2C7Jq+E8e4nhJtf4d5a5ZvFAunvxf1N9jbXidgJueUqD6UsAc7jqZbqvi3MGeUEQOReVSs8ZszsforgyYbehFzirSt/2nI+pISaF3SAxcQ/tfCcVX8aWCWHury1vL6Dc+A+IZjKGpHk8P7r+d0u1jhZHMr/9aZZsI4etYG0IlHrSgA2zKojEXj3v8RR3oYQQxnHI7zCB+X92hPUpf28pe5BM22hLbbR7c5jjB7/WsAKK+ZPHqqC8ZCZZff4Wm4p5MMIKpRGIrR9WE7jbbQ5CFo2Qq+1sjrHERMCq9PfJCjpMPMG/BjK6D6t7go+2dXLWxvJ0oZYRDSwPKph4zY+zKrNvleGp0WfmN5BgUYpyduG16bAFI7RTp70+pDk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cba1d1-838b-470a-ef90-08d77e3113ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 11:55:54.4418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+HQCAgCidH5IGDYcgM0XsOkQHXP6gbPLHOXTlj1yMvbCu7cG0caVBLbtIYV6lCGJP8Y/lGlR32VnNN4jJAnFyXgDqZ3LSmTE/VzyA/F42E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6769
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_02:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>I'm still not getting a good enough view of what you are doing and
>how my understanding of your hardware fits with what you're doing
>with the software.
>
>My understanding is it's something like:
>
>	----+
>        SOC |             PCS
>	MAC --(USXGMII)-- PHY ----- PHY or SFP
>	    |
>	----+
>
>And you are just modelling the MAC part in phylink, where as phylink
>has so far been used on systems which have this model - where phylink
>knows about both the MAC and the PCS PHY:
>
>	---------------+
>	         PCS   |
>	MAC ---- PHY ----- PHY or SFP
>	     SOC       |
>      	---------------+
>

Here, I am describing the GEM component followed by the test setup.=20
Please see, if the below explanation is depicting the correct picture

The Cadence MAC, referred to as GEM is a hardware module which implements 1=
0/100/1000Mbps Ethernet MAC=20
with the following interface types:=20
MII, RMII, GMII, RGMII which can operate in either half or full duplex mode=
;=20
and also as a separate instance a full duplex 10G MAC with an XGMII interfa=
ce.
GEM comprises the following constituent components:
- MAC controlling transmit, receive, address checking and loopback
- Configuration registers (REG_TOP) providing control and status registers,=
 statistics registers and synchronization logic
- Two Physical Coding Sublayer (PCS) components; one comprising 8B/10B enco=
de/decode, PCS transmit, PCS
receive, and PCS auto-negotiation and another implementing USXGMII function=
ality.

As our ethernet controller (GEM) have MAC as well as USXGMII PCS, we progra=
m both appropriately based on the values passed from Phylink.=20
And for fixed-link,  Phylink correctly read out these values from device tr=
ee node and relay it to mac_config.
Also note that we are not setting "sfp" node in device tree.

We are modelling MAC + USXGMII PCS.=20
The test configuration is as below

                                    +-------------------------+
                                    |              GEM        |
Host PC1   < ------------------->   | MAC ---- USXGMII PCS    |----- SerDes=
 ------ SFP+ <------ Direct attach cable ------->  Chelsio 10G Card   <--->=
   Host PC2
                                    |        PCI based NIC    |=20
                                    +-------------------------+


The setup has a 10G fixed link between PCS and SFP+.
Our test setup is emulated on Xilinx Virtex VCU118 FPGA base board placed i=
n a PCIe slot of a PC running Ubuntu.=20
The FPGA base board contained an image implementing a NIC using Cadence PCI=
e and Ethernet IP cores.=20
We had a separate PC also running Ubuntu containing  a Chelsio 10G NIC.=20
We connected these with an SFP+ direct attach passive twinx-ax copper cable=
. Testing of the link was done with ping and iperf3
Also note that there is no PHY in the SFP+ cage.=20
As I understand it everything regarding SFP+ in our setup is passive so the=
re is nothing for PHYLINK to talk to.=20
We do not have a module in the SFP+ cage, just a direct connection to a cop=
per cable

>This is why I recently renamed mac_link_state() to mac_pcs_get_state()
>to make it clearer that it reads from the PCS not from the current
>settings of the MAC.  So far, all such setups do not implement the PCS
>PHY as an 802.3 register set; they implement it as part of the MAC
>register set.
>
>In the former case, if phylink is used to manage the connection between
>the MAC and the PCS PHY, phylink has nothing to do with the SFP at all.
>
>In the latter case, phylink is used to manage the connection between the
>PCS PHY and external device, controlling the MAC as appropriate.
>
>My problem is I believe your hardware is the former case, but you are
>trying to implement the latter case by ignoring in-band mode.  As SFPs
>rely on in-band mode, that isn't going to work.
>
>The options for the former case are:
>
>1) implement phylink covering both the MAC and the external PCS PHY
>2) implement phylink just for the MAC to PCS PHY connection but not
>   SFPs, and implement SFP support separately in the PCS PHY driver.
>
>Maybe phylink needs to split mac_pcs_get_state() so it can be supplied
>by a separate driver, or by the MAC driver as appropriate - but that
>brings with it other problems; phylink with a directly attached SFP
>considers the state of the link between the PCS PHY and the external
>device - not only speed but also interface mode for that part of the
>link.  What you'd see in the mac_config() callback are interface modes
>for that part of the link, not between the MAC and the PCS PHY.
>
>To change that would require reworking almost every driver that has
>already converted over to somehow remodel the built-in PCS and
>COMPHY as a separate PCS PHY for phylink. I'm not entirely clear
>whether that would work though.
>
>--
>RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DaUq983L2pue
>2FqKFoP6PGHMJQyoJ7kl3s3GZ-
>_haXqY&r=3DBDdk1JtITE_JJ0519WwqU7IKF80Cw1i55lZOGqv2su8&m=3Dei26OYsu0
>JYGaBZjJMg7WhXT8l_kdzu_QwlOu3RTUhY&s=3DYHxF2EUKwhleTZ-
>fO9lorELZWnn9kArzxliO1KM0uMc&e=3D
>
>FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps
>up
>
>According to speedtest.net: 11.9Mbps down 500kbps up

