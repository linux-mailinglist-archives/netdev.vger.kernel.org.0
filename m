Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDEF2D4D05
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388328AbgLIVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:39:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55862 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388151AbgLIVjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 16:39:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9LUVD5005111;
        Wed, 9 Dec 2020 13:38:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=izfymyWcsZOH3Y9nDlf5e7f09A0DgndtpBpTv7JLuG4=;
 b=gVYzPCUrj6lMBaSVdVdqjT5VCWePMkgJQ4KyJlgXIsI0c4O9UpZcFfG3OvNuUP2eiG8W
 OE/o6/1fW2vg46R+n6YjLH4bu9W2sztUOh1YqKViPMEwaCg0QFVeMpw7AVk+Xl/yJB/W
 a+6TP7Uiq7RCeZ7S1lig9uJbDtFYwEnrIWJdXT4F4PKiNPXnQ2TKHTpxFVC9gx8CwUoe
 w8i7VHITCcbN/TiPILxr0CMC3nyJctLIb0rnMjQPPbRGPO4E5VV+UQ7fno46OjpGTlNh
 MszuUcicUU78ZJTaBh5CtoQ9DOxkHWKnnszBzivacs5eZr1YYWjR8FGtcdLlli8Dp1g9 KQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3588etdgfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 13:38:54 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 13:38:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 9 Dec 2020 13:38:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8E8Lnnirt76KWiZd30ndfutqTLg+iYSa4ePn0ddQmukHR8dM9rFyzV1nCQmS8QDmECjXZoj7BWNSCiiEUrSG/KPEcK8mw4W8LizhuIUV6Ko5su9lXd6RrJjcQLYwfVLm2VF+FkcaCGWcK610WsS/kaKhUQmDhu88GxxQuWD6uWaDd10w1igDvGWegNdUvRQJ6fhATl7XgvghZe9/T9Cja6jSyhvk5knR7h2f9UA2xtRVsIukjdTRAMAwK2rH6wCPXsQCvnT6kKzxrmPNmtyG4wICaMbpYCvngBMrovw8Haa16DJeEcb2rvpzmtkSteXN4Dgk1PN4PDadp3ZtpHkOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izfymyWcsZOH3Y9nDlf5e7f09A0DgndtpBpTv7JLuG4=;
 b=dRZSyaD2sTHyxmm49Rsz0og8/17h4tUm101cpzjX7QNUiunKmhE7LHFsodW9khb3dAaQ9HYCBfHmx70hzRGoQG7nf0zL0MQpKwhGH9hbY+EGJUwtTEbnu/hX85ddw8psw93JeH7DD0bYLglM//hJNAUd7LIq3QMMafB2bZXvFJQ828gPgxBWe65HA9r7k7fdrZel+3UhbcLm+x62d8vuYihubO/d7tjwbG2q80vfWtY8MkmJGVd/nmUSOSj1vZj78iFodtFiVCcBBF/F9iED0swyAuWSOpHP5t8MQ4lUzrd/1MFLbxv6AHYAcVxiEcbBGCBKVwPZJhjsA2mrT94kTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izfymyWcsZOH3Y9nDlf5e7f09A0DgndtpBpTv7JLuG4=;
 b=KAZ2h0hS28EETFq6QMZvfqoxhviS3fTY42B9PRCYnr0NdUq/0bqsNbobatcxlvXyDgGy4mbMO6FTVasvdh6Gc6lY/JSz18DVHQSoJpqxoKSwPzTy2MWMPKcm2/RLa3W21KYhAZwWhBECEHvGYcVPe5qXCMsHUS8NhluduXgKMUs=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN6PR1801MB1938.namprd18.prod.outlook.com (2603:10b6:405:63::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 9 Dec
 2020 21:38:52 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9%10]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 21:38:52 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyyYV4P4pQ1rY10yROtXpmQsQsqnsWDCAgACYJDCAAHq2gIAAJoqAgAEdnzCAAEonAIAAVEkQ
Date:   Wed, 9 Dec 2020 21:38:52 +0000
Message-ID: <BN6PR18MB15873CD07E1B6BB1B6C21DE8BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
 <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <BN6PR18MB158771FD8335348CB75D4D92BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20201209162454.GD2602479@lunn.ch>
In-Reply-To: <20201209162454.GD2602479@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.111.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a68ad106-702e-4449-2330-08d89c8ad2c6
x-ms-traffictypediagnostic: BN6PR1801MB1938:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1801MB19384133DEBDD7664507920CBACC0@BN6PR1801MB1938.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LkCyy+lYbZHRvXZ1fe47AcpVyZbxp0FFOMG9LkX3X0zyMvmdTQ21rtYI2lo5vAiOXAdH+h1a+RK9f6pNWRRNh4nzSO2vEBfDs4HAI90tY/824D/pfW0YlehHzj9xG7PEitnBUJ2mR2JxyLjwFQGSLbddhmbxaFaPWsH4yKNmI2fkW1GiQQvZRcxU0k2OhR/udTiiCrj5NytrpIxFaV8DZod8jHYqC1pWQT0z75Vu5XQmFffW6WTfrVi86IXpUGX8+JCmwcD2gBQEM3CWjvs+7NDwFTPPNMjtOIexiYF49J9h7y2fVQEzEfPX6nBubo7q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(55016002)(107886003)(508600001)(33656002)(9686003)(76116006)(52536014)(6916009)(5660300002)(186003)(8936002)(2906002)(64756008)(71200400001)(7696005)(8676002)(26005)(66946007)(86362001)(6506007)(66476007)(66446008)(66556008)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m8rKkvmGD7mR4eo5fsOlUKW6fXekrtBJXxorSsrp/1phQOs0C/L9j0G6746Y?=
 =?us-ascii?Q?WsJTQs/a02Q5hgYIFgaufXMkqmBNLKjlh9EG7+0mu1Xvdh6Olgdnj0VWr5H+?=
 =?us-ascii?Q?OGq8iebrOrPCq+pgerhkPZ/NOZkfPY0i4FdVGloAjheifiGD2b0MsBoNARlx?=
 =?us-ascii?Q?4U7Z6M+CGmm7lLj4zQU739j7vy9Up7m9WG4MiSS0BgYfX0fXuA2YsWsV1M/F?=
 =?us-ascii?Q?mCDugm9iff6ONMGYfBVc5fVSMYkRzDq/3EkzcUUfIU5KG+Mg2BboFYXRDmlt?=
 =?us-ascii?Q?EeJvtPA7GimL4CiGc88dh+KPeH9RxDrHHMdj10hbNexmwTVEuDokUjosjJx6?=
 =?us-ascii?Q?XCMW1y5GTHv4r+f5gW1H1NyWqIsbqkHwNEvuFov/qD+onLDquyFUXKAGv0S9?=
 =?us-ascii?Q?BuOBl0D7tW6uUacBM9O3aXcXstMjTM3mP1GZLTZ+XH57EZPiMNbAEbV18Rvg?=
 =?us-ascii?Q?xhRwrutfRAVbl6KZuRw3x24gn+FjYlJirv5EM2KIxg8BPsorsWVjaro/K9VY?=
 =?us-ascii?Q?OLaq0mh9OHdAo3NlmDtwDzOHu7Y8kdHuvoWMrfs60OZn8dmVhikZL/gOOsK6?=
 =?us-ascii?Q?Ny269ly17XwNR5RAPOhqJT/gjnbzPBO/KtbxuzLpO9QJ2pCHHgwSkfv47Y8F?=
 =?us-ascii?Q?zbVXPy4Hju/CTgzxFUAV8tQCjMPquxGA0/jnU8Ttt2+bAokTmkzjUkA7kJfT?=
 =?us-ascii?Q?K6xVoMDEM7Q9pN1hLiXDzJAsMCk30ZfIf/F0M3KMBmAtpkA60Kx/Vv/w5dpV?=
 =?us-ascii?Q?atoRr5/btTBu/yN/uZoxMtr1sUuXOmSne3BjEoa6ampGFgaFJG8ZxbX0lRse?=
 =?us-ascii?Q?hAiofEci200UX+ALRtNeeDfX8TQLlmJgwZD3YK+jPo7yFrkbNHmZ9sESnYGN?=
 =?us-ascii?Q?/wlSp0fhFEy/Ba+PqPwb+uMqk4t0B1v4FZfi4j7RJdFtATP8lueEQJTKZyXV?=
 =?us-ascii?Q?85RfUtKd6Txfp8eG6hnRgfhsEH7rbT2wufuFsnA2uC0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68ad106-702e-4449-2330-08d89c8ad2c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 21:38:52.6856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kQMluJ/0tetc2DUDYodUmZsISOHF5oV58Ox3WwNd2z4zgA4bwb7yzlhN883djeLpnremha2Uxt9Mkq0ygFxQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1938
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_18:2020-12-09,2020-12-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=20

> > You can see that only yesterday (Dec 8th) we had the first official=20
> > merge on this repo - this is the reason for the lack of commits.
> > Marvell Switching group took strategic decision to open some aspects=20
> > of the Prestera family devices with the Open Source community and this=
=20
> > is the first step.
>=20
> > As you realized - it will be used as a queue for all the features=20
> > targeted to be upstreamed.  New features are expected to be sent to=20
> > net-next very soon. (Like ACL/LAG/LLDP etc...)
>=20
> Hi Mickey
>=20
> I would actually expect this repo to hold a linux tree, probably based on=
 net-next, and with a number of patches on top adding Prestera features, on=
e by one.

A Buildroot based repo that includes specific platform patches will became =
public in the upcoming days. (As part of Marvell-Switching GitHub)
>=20
> Given your current structure, i don't see a direct path for this code int=
o mainline.
>=20

Assuming the discussion is still on the 'W:' line;
I went over tens of 'W:' lines in the ./MAINTAINERS file and unfortunately =
I couldn't see the above standard is really fulfilled.
> 	Andrew
>=20
Mickey.
