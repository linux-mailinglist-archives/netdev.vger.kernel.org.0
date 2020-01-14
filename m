Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CECA13A31E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 09:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgANIlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 03:41:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbgANIlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 03:41:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00E8ZKlJ016209;
        Tue, 14 Jan 2020 00:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=AW/RN+dqgx/HfjPJivWB+Yoo4UgIuNFuJWdSqR9RY1M=;
 b=WKoMwj6xwxhjRJwtxJnGSY+TiOhjs/aHleVLjH6IKIL2w1YM80YKdbAevLakxpa9KjSg
 HtarfJwOENWpEs7vj0ANVwszxF6fM1ji3ZjwnFiHBKQ8MUPAHqis4Z57vgbLyUIcCblK
 Fh/bQr6J00EWCIIcmo/c/TYUeK6VzQRUr2/G01L9ZmayAowfYgW0sd01FNB+pQZk3tXu
 +w6ro/VLgBpLWhDcv0wSkdELeC+TIbp+4+ymP79qNrkLQuu0+OpsnMY1CNUhpP7bQd1f
 5BOILbCgtWgQVZjYYTEFTtdOEoJP7Ir+ZenTVbGXd2l7kxK5cDe+UtPU9E4Jy9Xp2g7w lw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xgng4uvc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 14 Jan 2020 00:41:10 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jan
 2020 00:41:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 14 Jan 2020 00:41:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atyxc/WWZRkBRrnDGH5KS4cDiwccGWBZXk8AtKuTHYr/McneOlqk3bov9MoPWN2bzN5JRAsZsSipquKftF/rTigP+BNkxkRZh/oI7VDV02uKUKt2tfihM/MJKdvSxNjM/rv8u4H65y+boi9IOXcKSEfC5iYySUV9VvEgt666n3BAZnQXyOHm8O+kZiQBcR2tpDezMHrvqJOS7k1cVAm88WvQ75JUbtgkvND7cPa5GcFd+9nd8UMU5sXmIVcrVoojlfuANmf36jUCNG/w2h0n/GNWuEXuVzQB6e5Efv8k2cFeX/sJ4j/45TZFhrjsLbRtQ0MWLwvEsaZwQUfE5I15Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AW/RN+dqgx/HfjPJivWB+Yoo4UgIuNFuJWdSqR9RY1M=;
 b=TfENLWtOgaHgK+RlTZhuRu3EwsVoZ7bH63sA2zfQv03AWV6u0+pP9qB6tHwfF3AVu6eopqZxZiHIOu652h57rIRF6ucQH1CK0y6K8gyePUHbppIC2kAURd+JAyplkp82eLUpCcLXywfTaN1nFLXsV4/Xhkt5pXDa3qr+gdca3SoxZv1ccY00w7dF4PARD/BrvjnCFy5bSG+UyrSgkMyJZG3b7+2Ls1uSfU3BBalYKDl7xwKO7WEFiotf+/aha0/Ejx9EvkSvUpXWpzdWw7E5HQ7JY7sBxyKeSlwCcKjFbhitI60b1FQcUPG5OxGawJd7waNbNFLxjG/kVGVPFnTqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AW/RN+dqgx/HfjPJivWB+Yoo4UgIuNFuJWdSqR9RY1M=;
 b=pHkKZQ7tpOfTUqCY5QHbDbncgxj/sAFpXL0ULQ7iXjc92StAe9ohQuSKi5yDXNUfXW6/P4kS/eeU/dFLfkzAeZn8CeYzI923N6ba6ZUDX8Z6CxPC5Q9sEW/GkNwz1UwZ+dw9+NXqaP0eLBEi4jNsfAH2k7r/BxbGO94+trojUuU=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2813.namprd18.prod.outlook.com (20.179.22.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 14 Jan 2020 08:41:07 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::1546:5c8a:6790:4071]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::1546:5c8a:6790:4071%5]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 08:41:07 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] [PATCH 11/17] devlink: add a driver-specific file for the
 qed driver
Thread-Topic: [EXT] [PATCH 11/17] devlink: add a driver-specific file for the
 qed driver
Thread-Index: AQHVxz61dcK7ygVea0aSoRLOfgIMB6fp3c2w
Date:   Tue, 14 Jan 2020 08:41:06 +0000
Message-ID: <MN2PR18MB3182A8390BC9D7883ED5A18BA1340@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
 <20200109224625.1470433-12-jacob.e.keller@intel.com>
In-Reply-To: <20200109224625.1470433-12-jacob.e.keller@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.178.97.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f54434a-786a-412e-3999-08d798cd7f79
x-ms-traffictypediagnostic: MN2PR18MB2813:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB28137735BC2976B723743A44A1340@MN2PR18MB2813.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(86362001)(8936002)(52536014)(55016002)(5660300002)(107886003)(9686003)(110136005)(8676002)(81166006)(316002)(478600001)(54906003)(4326008)(81156014)(7696005)(6506007)(66476007)(66446008)(2906002)(186003)(26005)(71200400001)(66946007)(76116006)(64756008)(66556008)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2813;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHQ2dmblLWjDbk8GwlibXDlkHtAt84ti2G9Pt+K9nJ9kNbBrq/OWRc4rtkYunwnxl/NpX0oKg9XYS6GqcWvzD4Ij9YiBTGvCPFvenDi85T6rnJYoFCTtGzKaX2q08G+BfINvKCU13NVNO+guD/0sFYwcVlfc5pFDqbJr3mYS+wCLk9KEzs+HQ9Wy/NYUGUXFqeOlcAjPzBmpoRW6qKRC0e8F0q8ptepcOXiCqbxeXnDCx9ho096uTrUSngoSeOYuU9qGu5fPQYpp2/oiIfcV12q5sLj4SWG32dv8wP/i5dU1ZwpALzT8wn1t+9Zkt0/1qO7rmWNPvll+g+hQ6gee03Z1hUMRsuJQsKuDSo+e43HSmtl7fKRn6NWKGsCywJTW0y6mdhRI09+w5Gwa/7l+fJr4Ka2t1vMiU9RCaVOHCQiDYTUn5cekIvNHxl0wxxB+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f54434a-786a-412e-3999-08d798cd7f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 08:41:06.9004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBUoW+7UziUzfhMdx28D7wSaA6IJ/OgpHxPPT30I3qR1tIQNz8xXU7gQ3VDN8IcuejMnRwCVHNNvR/+UzejMWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2813
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_02:2020-01-13,2020-01-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jacob Keller <jacob.e.keller@intel.com>
> Sent: Friday, January 10, 2020 12:46 AM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The qed driver recently added devlink support with a single devlink
> parameter. Add a driver-specific file to document the devlink features th=
at
> the qed driver supports.
>=20
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> ---
>  Documentation/networking/devlink/index.rst |  1 +
>  Documentation/networking/devlink/qed.rst   | 26
> ++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>  create mode 100644 Documentation/networking/devlink/qed.rst
>=20
> diff --git a/Documentation/networking/devlink/index.rst
> b/Documentation/networking/devlink/index.rst
> index 0cbafef607d8..2007e257fd8a 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -34,4 +34,5 @@ parameters, info versions, and other features it
> supports.
>     mlxsw
>     mv88e6xxx
>     nfp
> +   qed
>     ti-cpsw-switch
> diff --git a/Documentation/networking/devlink/qed.rst
> b/Documentation/networking/devlink/qed.rst
> new file mode 100644
> index 000000000000..e7e17acf1eca
> --- /dev/null
> +++ b/Documentation/networking/devlink/qed.rst
> @@ -0,0 +1,26 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +qed devlink support
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This document describes the devlink features implemented by the ``qed``
> +core device driver.
> +
> +Parameters
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``qed`` driver implements the following driver-specific parameters.
> +
> +.. list-table:: Driver-specific parameters implemented
> +   :widths: 5 5 5 85
> +
> +   * - Name
> +     - Type
> +     - Mode
> +     - Description
> +   * - ``iwarp_cmt``
> +     - Boolean
> +     - runtime
> +     - Enable iWARP functionality for 100g devices. Notee that this impa=
cts
> +       L2 performance, and is therefor not enabled by default.
Small typos: Note instead of Notee and therefore instead of therefor
Other than that looks great, thanks a lot for adding this.=20

Michal
> --
> 2.25.0.rc1

