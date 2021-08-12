Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E743E9D0A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 05:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhHLDik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 23:38:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229729AbhHLDij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 23:38:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C3YwWX010968;
        Wed, 11 Aug 2021 20:38:05 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 3acrnp0gqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 20:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lP/6PNnttOn/CYi9yKmeNsjFwFXCgKYLJ54CVxJPyIAlqpao8k0WdbPlidc+bghB6EgKVocW3q89x7jcrKk+JExpXp7bFz1d+/eXsOOe66zw5Tf0gsk1ngpD5hi26giurQ+CgTcWz7rYzT6tu2JbP5YvAdl2V3wgvQGe1OwxxhytxFxS3nTClQn6i0cJXqg1aXsILE0FKEYkJVQyhgCkbjiU5z08xZXk5j/hdR9dlsJXwHa2juRPbc00pv3imh9QJfZeO+7ZFcClflsfVXkB1qFOYg3VBsXa8cjvtEBGBRWvyXXUtYToftIlgg3hTVi/nYdffTXSBwq8gVJMWHpDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4hy+qvdGOVH2Bd4OPBmhE+Lbgnj6KL3QTVd00F9eP8=;
 b=HBy1EjNUl4l8s2hIDUr3uPwaBRzr6NGCZfwuTagts47qDkLH4x7hEDxbyztn92vtVMy6V8E9ETBYgPWVtKY5B+QI1J3fHD9utGvMLgphAlnQl2JP8u4u4V9qSMH6K1OZ2eATQRaOFUHIF0EGeTYBj6FB+Bw2SP/pklIn5SXv1c8KmDGhqD3haxFIff0SyluqI4CA6MdzvjgDS2BEcdllmoOlbxtSHB53A3/gRF3qRfC6R8WM9OxNo/8T5Y/gKXi0ypQc+pe9COwU5ImbhR4D18harOdWHS/HD0CtxAGUxl8buU72d2kG5TjVsQDBeTjlDMGaDlSQ/OEHHMS/dRUk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4hy+qvdGOVH2Bd4OPBmhE+Lbgnj6KL3QTVd00F9eP8=;
 b=ApFaT17Dj6RokVGZos9vuaK0+Umgk1CWRKYnXj7xPn8Sfpi2rtnt4+dfICrxVjZya2jHbT6FVgBRJDyGHCK2PIxJ067Iz7f/lr/qyD4XkS11cqLEpbYPWgBQKS3tWMQLu5xpocKeHlU4OIrrJIjA61cR0D6mnYn1p031dDx0pz8=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BY5PR18MB3299.namprd18.prod.outlook.com (2603:10b6:a03:1ac::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Thu, 12 Aug
 2021 03:38:02 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%8]) with mapi id 15.20.4394.025; Thu, 12 Aug 2021
 03:38:02 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [EXT] Re: [PATCH] qed: qed ll2 race condition fixes
Thread-Topic: [EXT] Re: [PATCH] qed: qed ll2 race condition fixes
Thread-Index: AQHXjs4IRbuh20HD+E2nfcqQK7iQb6tu6UWAgABPFRA=
Date:   Thu, 12 Aug 2021 03:38:02 +0000
Message-ID: <SJ0PR18MB388284DF80D4609FC8DD9ADDCCF99@SJ0PR18MB3882.namprd18.prod.outlook.com>
References: <20210811162855.6746-1-smalin@marvell.com>
 <20210811155137.5ec90835@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811155137.5ec90835@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cce35ae-bc36-4276-c3c0-08d95d4296a6
x-ms-traffictypediagnostic: BY5PR18MB3299:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB329965576438D611B6736C42CCF99@BY5PR18MB3299.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GnQ5Wzh0WY1yzeEWAOWVQdWUzTlMZNP6i/B8yVaTDUP5Jmr/S6Eme7OLSAyr9r0gXTU/TN7N6MrLNZY8jOcDYQACs8PbsEnFI+2T0MBE8szzepBydLSClfW9nhf56KRW6sFPS8yGX5DUFr2HMRLtNdkF1uwrLoxdcTX+Dbr7qWAaLzZ+k/jPZ3yodkzaluffJvQLENxwDeCIGEslLTLtE9LqkFrh4Wb5aU3yt7PvNVyGJrYr++9hwG+POPkEg4a4HaW0fCLWyOGKWYbw2uBP95RbE6aJNXjEsKJDGCY9sMzqHoi/bKin7W9u57pJuqNKdIjFb5qVZg+OpZ7cch21RlN1s9R6dRmi0pe24fW1TNSy54527y0eFVUCKWgFk+HYYgpIai1VQuVSV44nPy21KgL5UxDRVWQMtjmjBuQG7K/u65dWpkjF6yC2LSSQwZ0VnUWRq2cIWu2pCA1gQOnRsUjh4v4Te6JEIxTQB+/b+pjV5Nc0mbYsmQzLgBGa3AKbsBWAD90Gv8m48PZSGWnkFziJoi8HMxCUlO24FeNNG/lt4mwQ06ra1S+wjrUQAIbU/H3r1mG2uBVGpH3SUVkGGvOsJKZ2o/BzvhVmrVNGZ9JxYfXU0flBMwbNmRSVTyGb/qyjoLneFft/j6RSIK4noFpvRVXARs5UH2r36pn4UDURZ+W6y7bRI3zvi/Vgpgzs/OnlFI6/iCXgPmylFS0oug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66476007)(66446008)(186003)(2906002)(66946007)(64756008)(76116006)(66556008)(52536014)(86362001)(4744005)(4326008)(8676002)(55016002)(38070700005)(6506007)(8936002)(122000001)(9686003)(508600001)(71200400001)(6916009)(7696005)(316002)(38100700002)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R2BqWlhgAUmF8YQWYd+K+NWuA2vwq9Ltcp0jpFbXeZ9sh4R3ibVcDZUI0WUX?=
 =?us-ascii?Q?bI32Rb3Xr6m0j1ZpSqWGhLoLtnG5uyPt2edQH1LL7Y3bu3ikHIVhVwYsI2wE?=
 =?us-ascii?Q?zlOoYmWmfLLYyN5lWwgvKYrya1+54tzgZ6WC7wqVB750TPn/k06a7KH9swzU?=
 =?us-ascii?Q?mdRUiDJKInLxZQ2ffHn1qXsWTfim127s0HinwnXqdOuytsmw5Q0iRvSwJ3ev?=
 =?us-ascii?Q?4qWfoaeQ3BqZLJ5TO3GK7YbswbcbbFrBzWvxvtgTNDKkzucdsdpwn7oms44k?=
 =?us-ascii?Q?uWwch6F5/vL5b7KmALVUJV/KDKMcb+cHxHZXQ5C8+LTPHOpK8/nkI8Je1nfv?=
 =?us-ascii?Q?RMJCJ942XJ0Dm5GullrhRmIxXImettDBBwXj8D+R6xKDhj7rqLfXSZSYGZH5?=
 =?us-ascii?Q?Qf4KZ+tW4S5U1o7wpJ8AXw/o9D4WUAqiLw098kOVAOd7Te9/zfhaY2sJsbFd?=
 =?us-ascii?Q?rcejjrxIvbWWziHEL1y5tRhO0y3MlMySc8ygTo4glNYkgmUtImNdwYQC65+l?=
 =?us-ascii?Q?vE6YIVqsPiRHsLiOgCSpI+K9viH+3vjnh+XXWgYvcBQQK5kxx1ZbNKiojpsk?=
 =?us-ascii?Q?X8+KmyGDQhtEKYgS4KAL53HngyZgvbD0wwx0MIu7s+ccbJfd1Q2kYWGZwWzj?=
 =?us-ascii?Q?Gpo8eMRd/E4amM6IMHnl61vH9DLcgYy1crymRaum0XXpOavs0+379iCW20n4?=
 =?us-ascii?Q?8oepcDQl0wxlULAy44HccBocgBPrVowR1JauHrXmiBEBHMjO/aOSP1LZuXlw?=
 =?us-ascii?Q?RdgcONtZu9o6g9MMMLogb4g0W3Yji+lz7E7cNVc5XHln1kVBVKPBoL7Tnb4t?=
 =?us-ascii?Q?Aox+INE0yhxdDQdD+aVhuVvnon/ukRzQbtPKrMIbZX4CAqxw+WKqA1drmaY6?=
 =?us-ascii?Q?UXuN06GkfFJ+PapQ91NCs0eXPWxThRMqdjPiZb240QuI/H1ORctB1HcBhQ6d?=
 =?us-ascii?Q?d3I+Qb7wvSBmM83KolS+XQdc5ocGIIPcW5KuJmWORShbBV8kQKN4hIdom5qi?=
 =?us-ascii?Q?x6c1OsHrVRi4wFSwx8uNwAlxoXXYOZpBBAjD7HDywTeX85YKM0c6Woh2tboO?=
 =?us-ascii?Q?Os+5DtXp/GZumAnw948kPaeeHU0VvLH4af/l0Goln9OvbrjciAraH8Lwnkry?=
 =?us-ascii?Q?6bqiodcLM9QMHq98SzloXPax6GLmgJmYQvEfaT92pNxvuTlX5MULs3WtYB0o?=
 =?us-ascii?Q?10OWYsIdXofqev3TJAJgxfPReznKHrNtS8B7lEO56L0Anv9xMYLYS/lLfegy?=
 =?us-ascii?Q?dPp/Bo4OlKrlgwa/T0rvxL0MrwPGz792+rRMqgIbmD44uNOv86oCf6bW9P1i?=
 =?us-ascii?Q?hqN5i8Vpq39eFKua35nwr/ofLy2pHaAlX/95MLHO9IygZJ0IlVdkUo5ZLVRO?=
 =?us-ascii?Q?vlqznJQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cce35ae-bc36-4276-c3c0-08d95d4296a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 03:38:02.4888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S99zUa5J2r//PmYLLHV4XU4bYZDfiopzwr29LxFOD/uucQ7EcUh/XSUxUDErWZI8Tc5tCDs4TNj5/J46G35heQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3299
X-Proofpoint-GUID: Gr5KcDqySfzzQyYHqvxZScSzCyoIFTK3
X-Proofpoint-ORIG-GUID: Gr5KcDqySfzzQyYHqvxZScSzCyoIFTK3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_01:2021-08-11,2021-08-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 at 01:51, Jakub Kicinski wrote:=20
> On Wed, 11 Aug 2021 19:28:55 +0300 Shai Malin wrote:
> > @@ -1728,6 +1746,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
> >  	if (!p_ll2_conn)
> >  		return -EINVAL;
> >  	p_rx =3D &p_ll2_conn->rx_queue;
> > +	if (p_rx->set_prod_addr =3D=3D NULL)
> > +		return -EIO;
>=20
> Please use !p_rx->set_prod_addr as suggested by checkpatch

Sure, will be fixed in V2.
