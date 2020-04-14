Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5601A7262
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405231AbgDNETJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:19:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405223AbgDNETE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:19:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03E4H1ST029808;
        Mon, 13 Apr 2020 21:19:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=3eVFwvgcUVFJE0pIJe3IG2bqzjhzNkwfWQX9Zh2zhKo=;
 b=cZTDq31rI14ZWi40DarEamYaPEe9C+JRnUyuroAdF+1KNc/5xKd2SLBtwpvgGp+fzl0v
 fH3RzCegFpDGOT3eSPaBLZNKpoGs8wW6Q6gQOLJgqXW7gZYqM1f/9jZyhaJ4Albvgx0Z
 knfpMRnsAsGKk9QRjxZzRhsQ7DUD2LKZG38oBYECWncJL5kCxa0ozIcOtFfHif9vT4XC
 MtYgqoojNGfCj6apKdD8bS8e+zA6nLzgmZpdjO1sXOXhg3SEE0obudmjnx7UvJN8S83q
 8/ENWE39JB4Eyx54MFNtsC6W+M+OqvmDC98N22XRCzJet2IJGoKPBq70+uttMlK9qnRt QQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30bb8qhawk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:19:02 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Apr
 2020 21:19:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Apr 2020 21:19:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyBaANXkEyP2OoyZIMFfDv4Ovn87ZDzL9YEIPMkAbFbJ3ijptvGo3nx1bAOanae8SVex5xEH3TMtNwcegGNaT4sUF20/Ma6Z2sqmKcESKNDrX+7BKFqSD4K/+PHknNo1sCjtUTH6cXjJmqUhU10KsF5FfJPHHQhaoL24fCcV5XhKr3m8oXXuxRTvsDmxjRiKCv7DRnAAprrXKt4ImoQNra2atxWughPI6jhB0kVKXh4FfTGXGgV/FqoBIb05BTXqPJGujAMZdHpG05kjTEuQhy47p6QHpQgZwtkO1bht+4C2RxGFXxwGb2pynQCOL+txj74B6KF2lk/hLfwQF2GkHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eVFwvgcUVFJE0pIJe3IG2bqzjhzNkwfWQX9Zh2zhKo=;
 b=UunsbMzxsYQgKulO5+PdPo+nc3FMm1Zb6r+tyj0zofbBsLW6WB4yT+YxgZ4szWyiPg5BeVnIdQG5IJmUeyLjnK42LvRMhsbkvlVZ8w6U9NfuEbQUd3lZ+aE9pBede44I8L5CJBPi4ob8JmpFtkt57CDpPWT9HwsWVSrVd8WgodvE/HQnHAwUvgYK+NoK958hdu7gHNjcwf7kGuIHmV1y37r1+11bdqkG9G+kub9Fx6HZFN7z9eYJL1mmQpqdp+6tRtb517/9GwNsch3LBnGDiSfnTjn8vOiMNq1pcMAzpVcXniz1XLAvUOPIrpc5X1IUBxnBVKLhTk7XCUxTfOKnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eVFwvgcUVFJE0pIJe3IG2bqzjhzNkwfWQX9Zh2zhKo=;
 b=LjkgXV4i8406iPQIsgXox35BooaRBe/D0zt9B9Jst3L6YPC8IvE7vGHmEmEs3C4GTFU7dgQ7bO0HRr3ArKLxWrfdzpzXizRkoudARZNm6W9Fc/nHUReGM72dQ0G+3g5vQcGlf5z+CU/NCAaW2T1/cP+LTfm7w+P5MyC4iCUs7bU=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3151.namprd18.prod.outlook.com (2603:10b6:208:16b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23; Tue, 14 Apr
 2020 04:18:59 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 04:18:59 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 4/7] qedf: Implement callback for bw_update.
Thread-Topic: [EXT] Re: [PATCH v3 4/7] qedf: Implement callback for bw_update.
Thread-Index: AQHWCbDXr/Hro23P1USmJehpd1Hh/Kh346VugAAvhLA=
Date:   Tue, 14 Apr 2020 04:18:59 +0000
Message-ID: <MN2PR18MB252761DE97FBD42265FB4A28D2DA0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-5-skashyap@marvell.com> <yq1v9m2uae7.fsf@oracle.com>
In-Reply-To: <yq1v9m2uae7.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [45.127.44.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c786e68-e1da-4678-5752-08d7e02af4e7
x-ms-traffictypediagnostic: MN2PR18MB3151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB315177B689EA27132B8D01EED2DA0@MN2PR18MB3151.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(33656002)(186003)(76116006)(66476007)(4326008)(9686003)(55016002)(54906003)(478600001)(316002)(81156014)(8676002)(7696005)(2906002)(66556008)(64756008)(5660300002)(66946007)(8936002)(6506007)(66446008)(26005)(52536014)(71200400001)(86362001)(53546011)(4744005)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XZK8HuWgbi/xmqeqK11ARToxEDAx6lergpomlGKOBzl+1n5KqiU1mG0LHdhXWqaksgmMsB+SdjYC1OrX1j3HMx4sYz7HMkLOiiKGwHhaH8XCksVD1sifTmdX43EI3Jb4aR0tbuuOdu0afBYyQ7KmGxpKuUSoofP+73e7H5uP2JUgrYmQM3/LjHewhh34LugQivyp0ZidizWdWIHIZZINuJSKGJVkQz9xjzZhv6V1DDUwsDWzMCl4dqf1/k94SpLA6C8Y9xLZrVX0GfmSWEjrmtL8ty1fzVZtQ26qyNYlR3WQ4MttnQAyMAxaheT8h77TQZkrY1wGEclcNsKXxg4Rtz7F5QoNE4B+HDpxQaXZTcgdBDpSVal4pfzqi9BBXHs5EdGZ+48/JOTvviGKtUnjh2RvpTqPMXUBvu8YzlB10bDx7XBQS4AsFl9m7FSyfPKI
x-ms-exchange-antispam-messagedata: 6RBy3yQtR0wDcX+kP2dZig0ZMJ9J1YO34jWwRjwJUHEdNzkK7zHManBnZPv1CJ2CdPr7TFPcc/SC1iaAcSN6BxHiCQ8Ots6XSu84uTdanq8I2V/E0MTmRPuJiSKBAaMCtsDhRx6QdJ58LkvFZmFNFQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c786e68-e1da-4678-5752-08d7e02af4e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 04:18:59.6955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ta0sGBHvYe6xxt0mWp/s9q8vQ93AqfYPwPtt0gcEpvcMl3QfVcMlDO17TdjY74g0Jh7zIX15hdO4zIOBIpviw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3151
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_11:2020-04-13,2020-04-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, April 14, 2020 6:55 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v3 4/7] qedf: Implement callback for bw_update.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> > This is extension of bw common callback provided by qed.
> > This is called whenever there is a change in the BW.
>=20
>     Add support for the common qed bw_update callback to qedf.  This
>     function is called whenever there is a reported change in the
>     bandwidth. It is required because...

<SK> We have OEMs that have software to manage SAN. Using those
tools bandwidth can be updated and notified to the driver. The driver will
update the sysfs nodes accordingly.

Thanks,
~Saurav
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
