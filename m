Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF76E408636
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbhIMIPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:15:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33866 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235824AbhIMIPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 04:15:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18CNS50c030655;
        Mon, 13 Sep 2021 01:14:36 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b1ju4a1sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 01:14:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpIvDgXuzVvgMhxnzaSzJ4BEoUe1b/SBvvEaX1clfCoswE2vT69faZYhmTsQTjiqVsoL3RonaoDWS7+UkPTWil00Rx/YLwSZa1fZwq2bSOFL3zHO7WqdXGAKbFBWC4zQc7hZLei95C1Dwxlk5YwJoTZ3EOv+ibRnrjIbUlqBqiJORZfBv50dwrufFX3xBUQZcDJJT6t2LnFCKii8Z3CBHPsFx7/loJLWjUv6NVLFqEgZrHfGDjgg+bgSuWo9lWzbpV/oSfSQW65Uwq48Zxd9M/O9QMHg/CXeRI7JRniCT9uuR6kcoUwd/TfLn/0KRsaeLbKzatpNbL9uVNiT7fpljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j5rGG4RTsUbzr59ZWbcEu0BP6MqaS51XwfA5oVEXDBU=;
 b=AwfdIhzYAoHXUB7mXyuJqIIHizDkQu9ipJoCEK+1b5q+VHsxxRlzY7GbThpvvqnNQqy91SEZSdKDoRe2XPRn3RzVO5zyMSkb5SAwTDJcPOpkv2KdXycLImFJFronKm1gfzsxhf97wPBH06PHWGle/EFP+nZPIMcwCI0cTSPy87pcpgEvCJNzvipqn90dCzEAMsCaPI0KwvOGmPbH8fnzmuQ2nEN8MK8+SPva9cSfI24ZW8riNJUdbymmAcS4FUS6xoW9AozTUELmcNf7cmWrUYs9nG8XwKJYMDP7CyV9A1YVcQ0DwATbiHx/eNfSMixD3yW8KQ24iRnH/aeB/ZGl5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5rGG4RTsUbzr59ZWbcEu0BP6MqaS51XwfA5oVEXDBU=;
 b=U1XI2eNy2bol08js8yZrPtViH1HWE/U5KCD6r2/ANu6YjzXgkmPn97v8QhgmMDvQp8RypUVklY9TE7DlaqT+15IVTL4bMeVYplYiANZoQRxzvvAi7OD4iZpkReUkbnCK1I4ALprdZYTDOJAK0nGuFfPf0+bf2JfLdhroGShgNiE=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2391.namprd18.prod.outlook.com (2603:10b6:a03:12d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 08:14:33 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5%4]) with mapi id 15.20.4500.018; Mon, 13 Sep 2021
 08:14:33 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Adrian Bunk <bunk@kernel.org>, Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Thread-Topic: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Thread-Index: Adeodmr4RYh0k8HgSU6+CKbfKaKGGA==
Date:   Mon, 13 Sep 2021 08:14:33 +0000
Message-ID: <SJ0PR18MB38825BC9620238DE3327C64FCCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9740260-7047-4254-5649-08d9768e84b0
x-ms-traffictypediagnostic: BYAPR18MB2391:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB239157394BE560A64790A90BCCD99@BYAPR18MB2391.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6tDT8JfmXQ4xOXwek+b4IM3s3JAuva1Vnu00pyJhnPT0BeIitsl6GvstDxubUaRmhzGpCsyWPuatfjXywNScwIQcfEeeBpMCIcdjRTTcYX7ANQJuk1MSErP0f4Bltq4JzF1iz52o5/RdlGcq1tDvbGrt4FhBSauybVU4s1xyL2cEPlADVg5txGb59irdz+5j2gj2oNl7ESGXuj5A8BwO6SVJMobcnHIceEWLQPRTNtgFNkdiyWN5OqTh1JurtBcLfuAYsSYS1qlWSIq3Ke79wf/Yn53G2NJpbzbBjLJfxarlG91aahftUTTMIaS8wkN4BDycfUdoyu9oOy/U7gcq9yOEedVY7KyurjbSoTQXKxIK6DsxiBirvGTZGh3W/Wn3iTmwx6o7zuQDmLIVF0I9NDvE01ZDp1hqNx8TSlGChCpLp+95XI3WpUdP2yrgte+eopNCiMFz33K1kXcbGzXQQybuhEWpnbIs1AZSqzSGQww/CZ6+zraJdYnKOAXG315sukZvKbIr0vP5t6k+/uaBiIwTU0EwhiIVTbkB5s97uHK/bYOOZe9x4ZgYgMcQndwS4MXMDfqAA3oX0T3Ha1KVTIqP/z5tO3oklIpLh6GWvNWRLhu9/MLMjYr6DV8ZDCfxP0RzAvDoK/Z44j/bvipuq5moXCA3/lD6uvGNuEahW6Cj64YoyjwgU0yw9ZFcIk/jngGDL7Ox+ciI3OX4lMoIOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39850400004)(396003)(122000001)(76116006)(38100700002)(33656002)(110136005)(66476007)(186003)(478600001)(86362001)(71200400001)(8676002)(64756008)(66556008)(8936002)(66446008)(5660300002)(316002)(66946007)(52536014)(2906002)(26005)(9686003)(7696005)(38070700005)(6506007)(55016002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CyDCRtNHbynMs374wsA03/Ynlqfjk+a8voFMYBnPt7dMjOeYD6//Xi47hkiD?=
 =?us-ascii?Q?ZJR24sIQV8o4pVzgfOdKe+GIoVCMOYAUMTiKTNbc7v6Yjia/6VqwF/RvUZxZ?=
 =?us-ascii?Q?uXVMZ3P6F7BC4H8N0T/emuOWTRnoml6W9IqS6fIHRmNN/NWfl+B6z9qbILRW?=
 =?us-ascii?Q?fIj3QB9kRTMdj4XJSHcG5wKmsjrJ2t+/5aZXNhjm5RJaEiv3SOk6eFMJhy/y?=
 =?us-ascii?Q?M+1efzMk9Rc0c1x+pJWOXRsle+xnW5JMXEPQGimRlCGVcaVc+fhqVZ0mjgPW?=
 =?us-ascii?Q?y8Fyib+zH1wj/3qok3yVYM0EE61rUruz26177TppQCxHeVpWVKs9dgmuY3ks?=
 =?us-ascii?Q?0rkNzgfogVyguphk0FCBCGFDeGb/rZYsROJOVpUKJcdm3n4VPuJ48DmZqmHE?=
 =?us-ascii?Q?LnYbvrMG+Vq1dKT8iwVZK9Ui8fHEvaVTdEgbCsDiwOy5O2PNnTstgqd8Bh7j?=
 =?us-ascii?Q?PobCYAXjg15mSeL/eVrzj0JMhf2Z/Btj6Jn+nWEPesMj+D7VHl/5dhw3IAE/?=
 =?us-ascii?Q?i68h9F8Le9Dd3xBI2ZBVYyIfCjz5cloAJQSTXp8kz0wAhsUi/TyYKF6Mm4D1?=
 =?us-ascii?Q?wOPCp7GQc7tfPmvl2nhoE0ctZI6rXg1oq/lmOEuvx4ZIW/kxAgLnoYlJNWiy?=
 =?us-ascii?Q?xfMWZdlKUERWOWrY0717MffRfsT/8TUDKRmjorkJHEQbsc9FDok932dZwdXN?=
 =?us-ascii?Q?P2b3NuBdNOnROVtGvI4K8FSaUQ3vK3fdCVt+23GXHxrLmDCKLRav7eT+kH0j?=
 =?us-ascii?Q?9Rr8vVGmLWLc2mS1HtlKIuhWNHyw4gXo2c/9/CO+/+i2bKPzOkYbR5JOebHf?=
 =?us-ascii?Q?4FbuMCgazv9wpkakCA1HzXkL1tVy6SsI5Ruye5HEYEx3VxD16vbSSQBOY6IQ?=
 =?us-ascii?Q?ViZXzoarMYNE0VWuYj4k0pq61IkZ1CHdhpSDbyMN+i6ysOS7xGhUeV1biOE/?=
 =?us-ascii?Q?D3K8+a0nc3v+fVeQpIry+7wnLi68qIIa8RtrxPHTD417wFxbnmRPdKryOsWy?=
 =?us-ascii?Q?66efbH8S2D4Q1ZdPE0HkVmkc30NfueFnOqCUtpYXybdZwIgwNRsurnICvw42?=
 =?us-ascii?Q?sEvnHonjjks8iZC3xJjvA/dOEErM5/7Cbz6HvkuteU1XTYvYEirMosWZ/5ST?=
 =?us-ascii?Q?r36VqoGHDgwNJI/ERgHyOy//4sfSlk5nVJpXBXXD4/liU9yeNoNAxFByJ8Xr?=
 =?us-ascii?Q?T18Jm9nG4vkl5CciKfTlOhdyRqmEBStYr5pBINHlw0SLqn6jTyWiUYZqHQqE?=
 =?us-ascii?Q?tGDsTriOEm3PdhEeGX+FhhxMcgAoYyBnxQ/DmJMIjCv7DOgnHDDGLZEwWGX/?=
 =?us-ascii?Q?q3ultVH6AEgC/uvz6ZlS9Adl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9740260-7047-4254-5649-08d9768e84b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 08:14:33.2611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8rNSOpgbBbnkIsEBbEOZ5JBh8t8lWy/bFY7BI7M4CRMbzShMKnMnu3D9mu+GJ5LjMrY8qJgRRjMKNqf6ZUCW9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2391
X-Proofpoint-GUID: JpIaFQer2tQwXHq0DEyiWDDS_leLtXcA
X-Proofpoint-ORIG-GUID: JpIaFQer2tQwXHq0DEyiWDDS_leLtXcA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_03,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/2021 at 10:08PM, Adrian Bunk Wrote:
> This function is called to enable SR-IOV when available,
> not enabling interfaces without VFs was a regression.
>=20
> Fixes: 65161c35554f ("bnx2x: Fix missing error code in bnx2x_iov_init_one=
()")
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Reported-by: YunQiang Su <wzssyqa@gmail.com>
> Tested-by: YunQiang Su <wzssyqa@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index f255fd0b16db..6fbf735fca31 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -1224,7 +1224,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int
> int_mode_param,
>=20
>  	/* SR-IOV capability was enabled but there are no VFs*/
>  	if (iov->total =3D=3D 0) {
> -		err =3D -EINVAL;
> +		err =3D 0;
>  		goto failed;
>  	}

Thanks for reporting this issue!
But the complete fix should also not use "goto failed".
Instead, please create a new "goto skip_vfs" so it will skip=20
the log of "Failed err=3D".

>=20
> --
> 2.20.1

