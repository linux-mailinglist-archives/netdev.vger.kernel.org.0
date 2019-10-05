Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2AFCCC746
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfJEBwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:52:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbfJEBv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:51:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x951oUxb029524;
        Fri, 4 Oct 2019 18:51:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=YQGfsH0shssQjKa2A9r/wSWebplsjsw02CKkIbDxKaE=;
 b=sZi9wHpbSS/eLsULcFxxrCTL6dZQCiNoRsGu+UZeextTKwoh/zC2wueLgP4N9nqiBUBB
 0JUYaUx1oKTPmoYyIk6zMSHW8XdOGqG17nCNUq3rEp0pGddWPVFH6U5nY4BXlFoqXj6R
 RlTw86G8vzO0cRCcn3ch0/s6jIOY2q2yWRZiXnDG7flbYC2suGbbFqx6d++8BqnGYwwD
 9hURVMRygUiUDV5S3Tnu/4H8VvmKGQkXCNLeTsOLeijbYelrfRocaHz8ktot3+73T2uw
 BRbByfv0bP/wA1WbQs41sqooCPkwruMU3l9ozNwx2Ce/8HulfSRFttCx0u0piIcNa6qF EQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vd0y7at74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 18:51:55 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 4 Oct
 2019 18:51:54 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.58) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 4 Oct 2019 18:51:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGHYu2kIT/LBI10LNmO0/1v+g86+04zYpa8MLxwsIa/avmPuu3A+MgcoTFVts+Y0bY3hgfiE1J09zkLM2wkUmiJkO1O1hY85jhhwC6yDvl8q8O4sOk3JUAWU22qefBQej0DEMSuBcC7k579w1zAMKiGh9Eh9OrKCO9ckwtD+IhqUMCbus8Bsn4u4kF3hD9MyPqHwMOmSzZER1/DQMG/dZqi4v8DRxMBGhHzVsLEwy/zHZKT6DpkuKbHYT3XbmnMdvw8bp6q6L/nG7DAhxCfyIhmY/POs9XNba8u8ubCXZaUPbneXsGj7YBYXDSeyN5g2Knqwb2rPK2bUuqs3nTvPvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQGfsH0shssQjKa2A9r/wSWebplsjsw02CKkIbDxKaE=;
 b=Ni3zHo7HdMER2cEjstbUkF9FQOcDWDffBKuwsWpeNZtXw9vhty1ZMAB0XWvfNE1skE43pbBJmhe0nYN/Zfb6Z53VC4C3/dcWDhIiclMI6Tc1vwdlZiGjM0dcfcK5zK5FLlfmaF4y94Dd/kk6VPj22CzInfCgKpkEvF8hwLQA8q2xdc+bqA7K9speccBxl2Kg9TFLI5kofG2vw2YccKPsndwjK1JkqsnUyogNhS2MAr79wyoTQx6HJZVe9MxWjRbbbh2+QtjE9e29pD9GZpGwHnU3sAlD6/ZsAVoz6nE8QH+oAb/r8WQGLLOtbjbmqzw4nXbzBFhMR9A1orHdx5/C8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQGfsH0shssQjKa2A9r/wSWebplsjsw02CKkIbDxKaE=;
 b=c+OtHLALv6iwXt/FjENSOHyN4Ieu6FJwyl+GUIHydUhtZMIzXwhpDV2cYwiZreh0NARddZOsQ5idnNaU0T3cKFiCD/vnN0lUxLLwb0SbPc03n9/DkwsigVQZ9dOdOMLkQiggBKaSlh3wQRDdSXMwv/KDzOMyn3dPbNHX01CTI9s=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB3085.namprd18.prod.outlook.com (20.179.21.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Sat, 5 Oct 2019 01:51:52 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828%7]) with mapi id 15.20.2305.023; Sat, 5 Oct 2019
 01:51:52 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_init_evt_ring
Thread-Topic: [EXT] [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_init_evt_ring
Thread-Index: AQHVevCvqZz3fSipjUm3Cukc3coKCqdLQXcA
Date:   Sat, 5 Oct 2019 01:51:51 +0000
Message-ID: <MN2PR18MB2637C5898C7F09F8C208439DA0990@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <20191004201649.25087-1-navid.emamdoost@gmail.com>
In-Reply-To: <20191004201649.25087-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.193.243.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7acb441c-cc51-4b3c-24f4-08d7493697d1
x-ms-traffictypediagnostic: MN2PR18MB3085:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB30856FA6735EA19E2FA7C622A0990@MN2PR18MB3085.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(51914003)(189003)(199004)(66476007)(86362001)(55016002)(229853002)(558084003)(9686003)(66946007)(4326008)(3846002)(6116002)(66066001)(66556008)(316002)(6436002)(81166006)(81156014)(54906003)(6246003)(8936002)(446003)(71190400001)(476003)(26005)(33656002)(7416002)(7736002)(478600001)(74316002)(2906002)(5660300002)(25786009)(52536014)(6916009)(305945005)(186003)(11346002)(71200400001)(7696005)(256004)(76176011)(99286004)(76116006)(6506007)(102836004)(64756008)(14454004)(66446008)(8676002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3085;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ztbXzWB5IRiryAQ2NegbdeiK3k6jaadVlwm4X8YXk5r845xyxiK/Fap9bR7NSA5ehYgeYhmfppGcqH6NTwj6UZJazIiy0EwYYhZYiu8vQFy5t9Db7bL719Qz8fBRnnznTtV4z3dYREV18DXWwFk7nYt/1NYOtPSo4+cyc6r7oWz7mK/LpD2VHHu1xj78/qNk0jOgZfYYIQY9Wd5UJSE+zTuQa+0V1hrjLU6u0yVInyIqfXQYHG0eJ37a8dEO9yOCRnfaWDviuv6RuZI0VZ3egB3fYOXJZzBe6C8Tf0GaEhVwD6LQ+ZfseA+viPdGLE+Lwy/FHT1ZJBnK6mMnaKWoV85fLHuYsrfMKC4rtVVEZaEVsFJTFNDlHxxEyJGqwoh3qR09elF7eKOHzBGCYU/2j86RRCjKFG9TtUf3vGd5Sxg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acb441c-cc51-4b3c-24f4-08d7493697d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 01:51:51.8543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NF2rTlDQ6GqopP9I4/mmjIx+ehU8GRBpRMOiLOcZimmDuIb2FqC71ICYarTiM5dXJCM7AgxQBrrS93eDueW5NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3085
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_15:2019-10-03,2019-10-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Navid,

> Fixes: 0732484b47b5 ("mwifiex: separate ring initialization and ring crea=
tion
> routines")

Thanks for the this change as well;

Acked-by: Ganapathi Bhat <gbhat@marvell.com>

Regards,
Ganapathi
