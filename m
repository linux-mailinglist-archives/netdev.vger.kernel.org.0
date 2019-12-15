Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0F111F70F
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 10:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfLOJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 04:50:30 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:63236 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbfLOJu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 04:50:29 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBF9jcLW021162;
        Sun, 15 Dec 2019 01:50:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=m518Z+GxBKzEwzopJnMZlse7aUH0nxjrrgXOQ1G1n8Y=;
 b=lrJSeeCfEECMOTrOz+AKXYvbjFGGYFyKIy5RsNMC4a6weRMUsBKkMyB9ZeJfH7zlDGzG
 JiZcFLO7pSAw/HVvej0JrdPRyPkECspQuoAQS8AQRpr92behoeZ+rPtql92uDG3B7Ate
 rB8l9iESifPeQbQTXFQmq8MQBWsmsrwlcjxmrv2Mh8pjhMK6FaOEIi5Ool39gmhDP6BP
 ty0bTDazM7Xaylx++6hxRjIEBfv3SD337yFdRlPurv7c0FID6yi+OWJ34IyCnCq+JdOj
 ZcrlmPYjvWJ7VNzReKnDnartJ4vCjJSJN7qeVGjuDATvYDVcJXf6cWtscKu3XgCxncKZ RQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2ww1b89y09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 01:50:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd/KOu8/CmOK8B9u0ozWXV+duqzTH279iXFDmu+xZ9puXv5A9D2wYyalab9LsUttEGN21P2ysuekKXOOPRDEpxYH5hG0AN2zb3AZ4m+PbYPft9k2FZ7qI76MdoE44bzUPaeLdzobiDMdBOcHudG9BE8NzEiOYRbdqe0QQSchtlcP+hgT6qxpLs0rYUlho3zDU7V9jDcZOAEE0baDSdT4aAoS69CzprM2y7FRNBonJ5T+VrtDtez14tlPZucyVYIdQQDQv6zxkhSYimbCnPsJoFFNBsv+ShdOkevuYM8wVxODFxN5/CcJelbxNrR+xHrctzPxUouAV/UeiPfrqvtx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m518Z+GxBKzEwzopJnMZlse7aUH0nxjrrgXOQ1G1n8Y=;
 b=gwCVx3KtgTPWqT1KlQxAiS5vX1ESciRPljcVKqe7goDziNnlKFuyD7BKiu4xQsG10cSxDEeHyGmuAVCSNIZRSzVzNvsuDfBQPS2yJekgWxlsSkIPkIEcIU3R1tiwadxmfTax4IHItjrv7AlJrTSka3nDZhTHcAYIWFCt1OngusQF9ccIoKBo544ZYc62Hcwuqw+8bIwi085uTVb0AhmF8wBL6Rm6auifh1KC2l8BT4kaDFEkTFNZ67iOqG4k8UXOHbK7CuNhJQf3oslJ4v+XFX7QfHWAzrr1Jeb4HC20FLhHqa+p8p1dlM4wuSRSo1VGDXjQRHntFLMh5hZGkN6Cbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m518Z+GxBKzEwzopJnMZlse7aUH0nxjrrgXOQ1G1n8Y=;
 b=n6rGo28NESoVRcLcMjYEZJfqG8uhepC3AF79+PXWyhu2tNQvEYog/1V+ShR1Vwku/xubyMwaNPbwW7iGlZOzVs+EV4r7zlj2Cn9W068Tu9eQcFcevt0kdt4eaQHKPEn6H5P1YT2uTwkNVE92HLbmg/gteg0ZevPNYhDKmghnBqk=
Received: from MN2PR07MB6109.namprd07.prod.outlook.com (20.179.81.139) by
 MN2PR07MB6253.namprd07.prod.outlook.com (20.179.86.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Sun, 15 Dec 2019 09:49:57 +0000
Received: from MN2PR07MB6109.namprd07.prod.outlook.com
 ([fe80::8862:f331:9627:c58b]) by MN2PR07MB6109.namprd07.prod.outlook.com
 ([fe80::8862:f331:9627:c58b%6]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 09:49:56 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Milind Parab <mparab@cadence.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v2 0/3] net: macb: fix for fixed link, support for c45
 mdio and 10G
Thread-Topic: [PATCH v2 0/3] net: macb: fix for fixed link, support for c45
 mdio and 10G
Thread-Index: AQHVsZlcdCgFqYRv00uGGFHo+Zw2xqe69nlg
Date:   Sun, 15 Dec 2019 09:49:56 +0000
Message-ID: <MN2PR07MB6109D2EFF293F38D763D22F8C1560@MN2PR07MB6109.namprd07.prod.outlook.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
In-Reply-To: <1576230007-11181-1-git-send-email-mparab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0zY2Q2ZGMxZC0xZjIwLTExZWEtODUyMS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcM2NkNmRjMWYtMWYyMC0xMWVhLTg1MjEtMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIyNDEzIiB0PSIxMzIyMDg3Njk5MTg2Mzc5MzQiIGg9Ik1SemFCeUU2WUFlU2JXNStuV0t1bW9PU0lCMD0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2f84e08-b992-4e45-1a1e-08d7814424a6
x-ms-traffictypediagnostic: MN2PR07MB6253:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR07MB625326AC533623488D888D04C1560@MN2PR07MB6253.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(36092001)(189003)(199004)(13464003)(186003)(8936002)(26005)(9686003)(316002)(107886003)(52536014)(71200400001)(81156014)(76116006)(8676002)(6506007)(81166006)(7696005)(55016002)(33656002)(66476007)(66556008)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(86362001)(7416002)(4326008)(5660300002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6253;H:MN2PR07MB6109.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N5nshRSv1jgUsHH5dbd4D2H71ZycNQaN5RTIVpG5XUeSkWQdY3gUbs5jb1B4prIN2r3M190vXeJmfX4j2LYrbBYzb14uA6UthQhXDhoxHBG+JAsAF6+P2PIhh4tGlyudJvidlx+RakTUoHlM/Z99R0rVyVubhx15VQ6ymZ+woAFgkESfXlyDAOT+loHAi0BMs3B3YwsM4w0yOW9a4m+SgHczG22D7slsksKUnGUmccD+0kzULPZ2tudu2myRRZ7tkfzeGxPeKbZ/WZTCTK4E28bStEzJ2GN6bBN7dVpEYBDEBAFDotH8xi8nytBPtMxIf9lc8rqG2IAModnfjX8hzmtQophQTHWqeBbR2MBTM/roH/L6zK0eqmLQhKt6eg04fQ4yK4t2K1jWqpijeNH6FUv8TQ5RgFOWZ45yJsyKdl6Pq6bGJ961T/0FzdYZi/fXtopWJ46D3PI/Ekkv09FhIXCO0DjWMMxueqZuKBUvMaUAtfF841yOxCw8Rz51cMR1izGtbSbGn115v87hEaBzRw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f84e08-b992-4e45-1a1e-08d7814424a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 09:49:56.4351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLpnrzVGOYPMQ/NGX0LBTijGCzTGkWQo9gBB+thoOQkkB0JDRxlDntjMa0iztUbU+sStlu5OD6JvTtX/slCfg75Q+TWYB4UdmFfDgwZQ0Ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6253
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_02:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 impostorscore=0 spamscore=0
 mlxlogscore=882 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corrected typo in email id of Nicolas Ferre.

>-----Original Message-----
>From: Milind Parab <mparab@cadence.com>
>Sent: Friday, December 13, 2019 3:10 PM
>To: nicolas.nerre@microchip.com; andrew@lunn.ch;
>antoine.tenart@bootlin.com; f.fainelli@gmail.com; rmk+kernel@armlinux.org.=
uk
>Cc: davem@davemloft.net; netdev@vger.kernel.org; hkallweit1@gmail.com;
>linux-kernel@vger.kernel.org; Dhananjay Vilasrao Kangude
><dkangude@cadence.com>; a.fatoum@pengutronix.de; brad.mouring@ni.com;
>Parshuram Raju Thombare <pthombar@cadence.com>; Milind Parab
><mparab@cadence.com>
>Subject: [PATCH v2 0/3] net: macb: fix for fixed link, support for c45 mdi=
o and
>10G
>
>This patch series applies to Cadence Ethernet MAC Controller.
>The first patch in this series is related to the patch that converts the
>driver to phylink interface in net-next "net: macb: convert to phylink".
>Next patch is for adding support for C45 interface and the final patch
>adds 10G MAC support.
>
>The patch sequences are detailed as below
>
>1. 0001-net-macb-fix-for-fixed-link-mode
>This patch fix the issue with fixed-link mode in macb phylink interface.
>In fixed-link we don't need to parse phandle because it's better handled
>by phylink_of_phy_connect()
>
>2. 0002-net-macb-add-support-for-C45-MDIO-read-write
>This patch is to support C45 interface to PHY. This upgrade is downward
>compatible.
>All versions of the MAC (old and new) using the GPL driver support both Cl=
ause 22
>and
>Clause 45 operation. Whether the access is in Clause 22 or Clause 45 forma=
t
>depends
>on the data pattern written to the PHY management register.
>
>3. 0003-net-macb-add-support-for-high-speed-interface
>This patch add support for 10G fixed mode.
>
>Changes since v1:
>1. phy_node reference count handling in patch 0001-net-macb-fix-for-fixed-=
link-
>mode
>2. Using fixed value for HS_MAC_SPEED_x
>
>Thanks,
>Milind Parab
>
>
>Milind Parab (3):
>  net: macb: fix for fixed-link mode
>  net: macb: add support for C45 MDIO read/write
>  net: macb: add support for high speed interface
>
> drivers/net/ethernet/cadence/macb.h      |  65 ++++++-
> drivers/net/ethernet/cadence/macb_main.c | 224 +++++++++++++++++++----
> 2 files changed, 247 insertions(+), 42 deletions(-)
>
>--
>2.17.1

