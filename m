Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC002DAE8F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgLOOIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:08:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32684 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728806AbgLOOIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:08:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFE5Pes017878;
        Tue, 15 Dec 2020 06:07:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=oVsJs+BsOWGf/cnXayDSTzemfkvOw+8n7MyYSq0Rdv8=;
 b=QBDbQiWU3+O8RwWOYBH6MwHYzSxOBboAt2xD9QCr0ggM5KRct3Hn5pneHj3EL2TIj/Aa
 /yUFXbO/2cqoMCBMDk4eV+aXTIAkuRIDa94nNHTK2vLk60LuAJH5X35FVcq4u/qcPYbE
 FnQM6MfO1JNc68kNHPUpRlURfmuuvdhyqvVDqBoaIG9JYxMRvC3ISLxCk4C77U6v1bLa
 xNa3f2Vfv9E6kIesZ4tW1i6MprynsL/ivjVkRVl0ThGeZ/y9ViYwszLDW5VBxaChWutD
 2j8Yvs0vwtcsM/ivSUNv+B0EPmYbHIk2gptJ/z77G+oiR60RdqSisZLcqUaZXMJ31srZ hg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35cv3t036b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 06:07:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Dec
 2020 06:07:29 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Dec
 2020 06:07:28 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 15 Dec 2020 06:07:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVcGXRbOfm+RKZLS8+iMf9jWtfbR8whOPaAqnrS7iS1sjfCYPzNp3Cgs5Az6xdiGsjXiQqsq7Dbq3G+XEez+l1c5i1FH34ggsWTuFjPjNOOM3WcwDu5J7LqItCPF789r6rJTRMCRpJuaLK2m8o8uAZDzZyzo20ZIaylfquzkrb506ZuSrpv4TwZPKvk0LMGzH8VCmHe5+oPfHyYrPwpyk0fMdB3BDyxe22dQlpixWx1mBlMvAzhU/RIjk0FKxC0NDAYQfSaBG1/wSPkEViNhWlULBD3QmjpmPZ6jl7nNIy/GUB+LwvowXYm6rIjfCVse/DqHj6HI5UtXsngKg86zhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVsJs+BsOWGf/cnXayDSTzemfkvOw+8n7MyYSq0Rdv8=;
 b=Z6mbfcNk2ER6I5mfrm7nDkLFferyfRFDou4e2VKWgmCToEI0KrfFMWMpHbjLYuCrzcY0PzVKrwJ2qFS/7b2qGpnZPTqy6MVrBSKkUgaY8HUtCRChZPw0vZlZnlyr3xNnDoLYoo0H3H5KPINET+/p1ylYNUyHyvL7t40ZG4LE0Jzs9dYIyng9AZXHF+eG25UB1prCi3b8K7Q5AfdShFzkf4KDv7xV5Qt3p9+c4sUTyvqCNhH0xQQ8eF6BFsFrs8ksL3I5XV46G7OrpDUmPk760o+rlzbRvenFDCdSuxofCjgzKv1JgtJ81HJV2jiHWsTm1/VUi4IXdRA6cOa4yPQa9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVsJs+BsOWGf/cnXayDSTzemfkvOw+8n7MyYSq0Rdv8=;
 b=Q5TB7DPWioBbexI9y064I8rtLpwMhICB885mTU/olTO7XYTBk1xf4IexjMRLywUoV2Wl+wE8aPhhQAevjsrQXLY4FVrCCAPeaDZyIBVeGiKBDvTYkxfWbLxatFIX+PGVPj+8hehZnJ4v8/Mbn8yGKBCG/vq9Uux4kbDTIFkvu/I=
Received: from PH0PR18MB3845.namprd18.prod.outlook.com (2603:10b6:510:27::11)
 by PH0PR18MB4021.namprd18.prod.outlook.com (2603:10b6:510:2e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 14:07:27 +0000
Received: from PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::cd9b:85b8:cef5:e543]) by PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::cd9b:85b8:cef5:e543%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 14:07:27 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
CC:     Yoray Zack <yorayz@mellanox.com>,
        "yorayz@nvidia.com" <yorayz@nvidia.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "benishay@nvidia.com" <benishay@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "ogerlitz@nvidia.com" <ogerlitz@nvidia.com>
Subject: RE: [PATCH v1 net-next 07/15] nvme-tcp : Recalculate crc in the end
 of the capsule
Thread-Topic: [PATCH v1 net-next 07/15] nvme-tcp : Recalculate crc in the end
 of the capsule
Thread-Index: AQHWzN2HLXk+GuEMLUevzlHdst1Vp6n4OoYg
Date:   Tue, 15 Dec 2020 14:07:27 +0000
Message-ID: <PH0PR18MB3845EC64645DFFA3BA9BCD63CCC60@PH0PR18MB3845.namprd18.prod.outlook.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-8-borisp@mellanox.com>
In-Reply-To: <20201207210649.19194-8-borisp@mellanox.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [79.182.80.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97ee8f7a-8e5b-4a5d-e7cd-08d8a102c102
x-ms-traffictypediagnostic: PH0PR18MB4021:
x-microsoft-antispam-prvs: <PH0PR18MB4021812711E08BA71CB4BA4ECCC60@PH0PR18MB4021.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rLV28NEGRbzSGE4QuJYkeMSLOQe9XzWjUWRFv/Ij5XjEygzxyo54ygsN0TRF9Zw2oDatkBYMgTS2BzhD4B9JYwhObv8zKtnof7Ej1LN2em27mY8rk2gIAz8df8k1jmlhdHvm/kipC32V/QrL3rPhQFDsD2Eno5JngVLZ6Q34cyObbSfcN6STPVbjHkQEOkK6hvMfPDy9QL89EAzZ1EU1lpnks16z0F12RWnN6oMGkHxAnXRMLOGgyuQT7PefwnAtjBXbFjVh0HYKmEBzS4R2A/jvXnQ4Vn6IN1xbJq1p8Ju9CB2ab/hliNeM6fOazxKqTz6hAwtN9I/jh1q/43F+ZqvJiN+ZoDy08e+0NBOIXAXm/0ddaxfRoFe49vbuZ5cS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB3845.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(498600001)(66476007)(66946007)(64756008)(4326008)(76116006)(86362001)(52536014)(5660300002)(66446008)(55016002)(71200400001)(921005)(9686003)(2906002)(8676002)(26005)(54906003)(83380400001)(110136005)(8936002)(7696005)(186003)(6506007)(33656002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rHC/6BDGuZ+y5zqVAL4fW+PMVegExASDEpq8yLdU83kyjMS/jQRWGPJ14+9K?=
 =?us-ascii?Q?dIyV2CIEwyr1jbpOiDXCqNz+0fC+5lUau8GgYt+HAmt8T163yM7Jh7DQljpC?=
 =?us-ascii?Q?9D6Q2HKIhf8DYZm9805cnfttqa3XtLBozE0A8gqqsZOmUdRBylHFhtItL90p?=
 =?us-ascii?Q?2k/degKODckzqkqVX0kWtlz1ub32g/PSW1d6MPpQHiWxsh1QSlXPYqhi/Kh0?=
 =?us-ascii?Q?ySbon68j4LPuggRaBng8W0U2Hk10doD5Z6T8txfL9XV4/XGoPp2a9xaaZUxC?=
 =?us-ascii?Q?j/109MG4ugwn4nak53pJRBkcf9g1KBpNj+wWyTkuhXbr6jmAsQ6GivgTVTE3?=
 =?us-ascii?Q?gEj9J/F6RCh1xGs5+m+70uc/AFFEfgZGlI8wBqsJA9E9QH7lDP2LIVTSbs/w?=
 =?us-ascii?Q?W+gLcQXRLseuth1DNS5LFhVe1FtXl/diwFLC55Eyymg1LbH7PRhVrjLWOhxd?=
 =?us-ascii?Q?AP0NJXepCU98Ntb0K8cFrnMBe3A/FH4gH/gW2RWBWDeMYT0y7oU+YD2FdHFc?=
 =?us-ascii?Q?9HYZsh6pMWnPXOlLTLt9yK24aFKr9Vd5Sns2YpWmvEtuJvaje2MtV72lCLuh?=
 =?us-ascii?Q?1V9h0Jr3fJUj/uY9IXsvokLp84uQJoLhH6KjVYmgEctMF5LVAl3VwVGO1+SM?=
 =?us-ascii?Q?ijni9C1KIxnGiZpyGa8vIB9Ij5GOsVRjoFrDBWpIMCPQHndRmyswGaTv0LZq?=
 =?us-ascii?Q?H27X+x3zeZnC26S9zlOZWA+TJAhjLYcAAmrka6AdwyiP0ppQb/hfJMdKkUJh?=
 =?us-ascii?Q?YmRi0dkTSoQ2GW1a1Fv8EfMfKkuSlEdEs5vA91yCpe9d0LiMaQj6jloscQbT?=
 =?us-ascii?Q?h5EAE4qMJ4vzUbSBW0P65wnJ8bj+S1tKuaHj3ApGuIB5sm3u4kn59pU5nxee?=
 =?us-ascii?Q?sEKoTyDfrE5lMSvTz7T99t55rZ0D/iUEcoqygmnL1ntNXssA5pxHoTvqgbVZ?=
 =?us-ascii?Q?94Si7HZT5J0CWU3fLD8joK4HfhFl6D5dDBG1JD5Uj7o=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB3845.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ee8f7a-8e5b-4a5d-e7cd-08d8a102c102
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 14:07:27.1969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kMFGeUYCox16icV1HGhgo7yJ+xn11ccOwUb8LrOpob+JcFcfTgHHxEsjpFpCNiHHw5fGrY9NQBSr1lz+Dhji7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4021
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_10:2020-12-15,2020-12-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> crc offload of the nvme capsule. Check if all the skb bits are on, and if=
 not
> recalculate the crc in SW and check it.
>=20
> This patch reworks the receive-side crc calculation to always run at the =
end,
> so as to keep a single flow for both offload and non-offload. This change
> simplifies the code, but it may degrade performance for non-offload crc
> calculation.
>=20
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>  drivers/nvme/host/tcp.c | 111 ++++++++++++++++++++++++++++++++----
> ----
>  1 file changed, 91 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index
> 534fd5c00f33..3c10c8876036 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -69,6 +69,7 @@ enum nvme_tcp_queue_flags {
>  	NVME_TCP_Q_LIVE		=3D 1,
>  	NVME_TCP_Q_POLLING	=3D 2,
>  	NVME_TCP_Q_OFFLOADS     =3D 3,
> +	NVME_TCP_Q_OFF_CRC_RX   =3D 4,

Because only the data digest is offloaded, and not the header digest,=20
in order to avoid confusion, I suggest replacing the term=20
NVME_TCP_Q_OFF_CRC_RX with NVME_TCP_Q_OFF_DDGST_RX.

>  };

