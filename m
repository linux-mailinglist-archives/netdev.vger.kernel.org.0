Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455FA2C0EC5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389363AbgKWP02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:26:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732106AbgKWP02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:26:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANFB9NM020406;
        Mon, 23 Nov 2020 07:26:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=yomWDd84E+BAzzWxd1/pLGoLbbG3DETcZanaKytljhY=;
 b=WcWu2AW1O6u3dRhR7+gTVsG8e3xEkLL1qb1Vz+bvA2Hp57dGGEfuNMZcZlViYzOdg2A1
 YqmpLuge4ur10p1xRg1Mdy5O1H7HcxyZBw1BqQ2kOcpdy2FVTc+2+Vzzm1gpNDJj0Fmn
 z15UFjyYVr6otKu6jZ5xFR23BWJ2n/TF5iB4JJpNeTIVUZSBNfZ/frkHlvokv5PRHF/Z
 yVx541/Xdzh9dQ0BPLgpgx78IxYyBg5z3UDUYHXqu2K3wt3+FcccGbvLog+PW1nvf24U
 IVJIFlm3uYR9gVbX+yhONk/FOw99v4gFq1Sdy1hRI7JXp9ERjfXOj/8o/mgDomT6iOns ug== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r5t92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 07:26:16 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 07:26:14 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 07:26:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 07:26:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esGh19B+yzbrqBb3n751V3dPbInjoOhpcekAnBaWizTGiUfQIJ31TKhdHWQFBGwjPqZDFsF3XmwaD0r9GB0u4qA8B51HwacT7PiopmZRwpEXb5F/2QihOw85yiuPj1bV8E3f4FlZbmufa7DB0uNCJbkdZHoUMkmMYe00nCP6rpbU4Ad9gUc+IYcH5RsO1RfiKMWat1L1v1AsKg8gmyooCg4VzVHDMSpscLTGNm7ukRHyYbN2S7Y5LnF9Ca6FYEGzAq6jb9R5QBNBbE3lyudwfXKBMLxrhmr3dZUDu6Cn3bS3CK0wL5HE+QQ69dII81FYnJrqirNwhFS0ccBLFsQnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yomWDd84E+BAzzWxd1/pLGoLbbG3DETcZanaKytljhY=;
 b=P16d9psaQjdwealXgulFdR3OVFK7d/V3uJoFdvcRDzPrI58tt2U97RIyyJ9hpzzYiZtZA9hMtBU7hX07lOg25bucuoqSswxMXlngbfTxIDO4ZEFKK1bmzhIqIbPsDAAS2Ns7xpLRH2KSAnid2NseNI+nWyDmoBEftG+EunW/uT2rhwieAeEi5X9ZeLk6pO2nHxMW8+1BUlXxf1LobelAzVYIabDH0ZAuHQhjVRHLADI40yhsmRifRwLYG4TMzecUR0l139emQrb+FWOtpE2g1+qNHbfy96kvWflIwHBvnyFdAJlWRgwjDMKgKSoWliYRNPvkqC/UNFoIzz4iX3CBag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yomWDd84E+BAzzWxd1/pLGoLbbG3DETcZanaKytljhY=;
 b=u2P6TSx5PiYsKOj1EOnzuKZl2Zhtpm+LcX9RFLv7jw1kGIQNt9vFFkyRgUPZ9yLsWJ7ajfSkXTaQG5jN78DKe7XEfgaoLjaG69tkwaJWU0Q3eniyEUkc9FTG5GABrcBMERPoAWyPk4Rp+IHG3v4B1WjaFzXgo9LphvWv+o9uqJ4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1567.namprd18.prod.outlook.com (2603:10b6:300:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.28; Mon, 23 Nov
 2020 15:26:11 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%6]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 15:26:11 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports
 only
Thread-Topic: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Thread-Index: AQHWwahlp9Sv9guVI0awfVNHHhZxM6nV0laAgAAAoWA=
Date:   Mon, 23 Nov 2020 15:26:11 +0000
Message-ID: <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
In-Reply-To: <20201123151049.GV1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.66.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39776665-44a9-432c-ca09-08d88fc41bfb
x-ms-traffictypediagnostic: MWHPR18MB1567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1567B3F0E23FA609DA98FC6DB0FC0@MWHPR18MB1567.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2tMT4ayFEs8IQOmD86RmPoDRRhLLNz8Qpq+NEHRanRfB7Ld+RRgPvuxZR+Wl9f8+0Nr2t4H8t2xLH6IoudcNOq88d0MT6UtIO0seYxQ5eeMkHBWoWiXgKRhQ4x+XEJ7elQkPb2nAtf3izhJacHc96t6VYiKVOaVZgOhJghWoGSrAbjW1mNerjH087tO4sEXx2bx7HSMRd0KOCNeeRClnMUCB3390XgFlGMx6361J85PG00PJh62KVWwwRr58ZPXoAWA9G8nf5u8YWlVAGRub2FTx0PkNxumKO9dlO4ygu/Zcsbji/l/4Kg9R/LSD37D2uS60rScXwkG0LPqoAjMtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39850400004)(8936002)(86362001)(52536014)(66476007)(6916009)(54906003)(26005)(66556008)(66946007)(64756008)(66446008)(316002)(478600001)(33656002)(2906002)(71200400001)(8676002)(186003)(4326008)(76116006)(83380400001)(7696005)(9686003)(6506007)(53546011)(55016002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DrdexsrmwKm3nKkmrvSzah6T/Veq3QcMoGnosdTKlAtm5RftwCLQKFy0Q0XQ?=
 =?us-ascii?Q?xuoWDolh+ieelgahdzGd1hM6L0B2ZBx3XbelKJuGrJjik7GBLfXGYncTbnXK?=
 =?us-ascii?Q?5nDoWzt2pi0gYmI1NRwPDgoOKOUyKHNhzRLrZlHQxQ8nvtE+V3Q+PsciXHrr?=
 =?us-ascii?Q?cimTTTlkUtg2n2j8i6XCTxvPFOGOS8OZAEa/6zRm+vePvfybFXoDFzlyGfHG?=
 =?us-ascii?Q?XvQCNFjo/14TanG9hmPUye7sO+9iYXFAE+6T5PjWBPi2u1K1yZDUkAk6S9NO?=
 =?us-ascii?Q?ESLt3BhBvJi4LbwARZQoHDKZQ1fq/2bMSW3iWiPPVcQ5Lt/IKkEBURtdUoXH?=
 =?us-ascii?Q?hks/KfkAifqaGJw38LtPkDQkZpVMJiyHX8hxrKUQDi75ZOrJUKfCKGcIWCUm?=
 =?us-ascii?Q?JYSxCFcRpu2WmVVfLlAHFVyBd0K+M67d2jMZzMRtdw5yFw/JtSxeBDG86KtT?=
 =?us-ascii?Q?21QzU9lcagEoiZvEPD+h4/C8+FjXs0s+atupseB0zrLzLZhCcpO19Mo+z57Y?=
 =?us-ascii?Q?eUfB6mrMJYZzzucblDKkJbLDNZWEp6RrWusa62tHjpJ9ttKOO2x8N2yDcLMG?=
 =?us-ascii?Q?/NJ+7XOJGfZi6rW95Jgex8+6TebUHiYBadMGdtSIiLcR/2UKzzzatlBGCB7R?=
 =?us-ascii?Q?Hm2SuUM9U2aheAYmRKujenlyfFAwMhDWZ8C0oNl8imGthWYbDnCCw4uc9W1L?=
 =?us-ascii?Q?btD5zu4Mb/AnzAYFDrfG9wW7VP+0aY5aAFZAOJD9a3c53+AL9u9Cq7lTDOIg?=
 =?us-ascii?Q?zq8wPzmDqzZ3YQWCcFpyLCJl6Y2fWjzlE8rKWgx33wsLypBArPAaF4zo02Aj?=
 =?us-ascii?Q?ubZ4dAr2EHy8bHt2rFjw0PHFs9Vh5EuLqxfAei4cfsfXlhQ9r3n/Oj30Uc53?=
 =?us-ascii?Q?SAE2yH8CGMmo4ldxMOxYeaC6oOCkMHCu+q1ZjMtIqKNdanUMkjA5qpbHDWt4?=
 =?us-ascii?Q?3aU7vQS34+4l4ix6Kl5UbPo0GwBbRUhVHjgulLWtis0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39776665-44a9-432c-ca09-08d88fc41bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 15:26:11.7658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TpVbxgH7cLpE0qxNdtWZfWk5QK+sfs+JaGHAX8szY4A4BuQAa86EmUOFJwvAFHXUgNQwO9Deu2OGOHvZeWXHOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1567
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_11:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Monday, November 23, 2020 5:11 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> <ymarkman@marvell.com>; linux-kernel@vger.kernel.org; kuba@kernel.org;
> mw@semihalf.com; antoine.tenart@bootlin.com; andrew@lunn.ch
> Subject: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active port=
s only
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi,
>=20
> On Mon, Nov 23, 2020 at 04:52:40PM +0200, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > Tx/Rx FIFO is a HW resource limited by total size, but shared by all
> > ports of same CP110 and impacting port-performance.
> > Do not divide the FIFO for ports which are not enabled in DTS, so
> > active ports could have more FIFO.
> >
> > The active port mapping should be done in probe before FIFO-init.
>=20
> It would be nice to know what the effect is from this - is it a small or =
large
> boost in performance?

I didn't saw any significant improvement with LINUX bridge or forwarding, b=
ut
this reduced PPv2 overruns drops, reduced CRC sent errors with DPDK user sp=
ace application.
So this improved zero loss throughput. Probably with XDP we would see a sim=
ilar effect.

> What is the effect when the ports on a CP110 are configured for 10G, 1G, =
and
> 2.5G in that order, as is the case on the Macchiatobin board?

Macchiatobin has two CP's.  CP1 has 3 ports, so the distribution of FIFO wo=
uld be the same as before.
On CP0 which has a single port, all FIFO would be allocated for 10G port.

Regards.

