Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71279437155
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 07:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJVFah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 01:30:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229478AbhJVFah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 01:30:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M5LTFl016910;
        Thu, 21 Oct 2021 22:28:18 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bueuysvt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 22:28:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bum/i41NQmAx2xaKzBlQ1XXj+6M5+2QuY4ugWllI2Mvb6g6zq+1wFXoZVeyXwQ9hQGuWxKuCGu9xfr1K0h6zJksBgwazHPV87wjYq8tbqXNOTagEqazQktwiH4lXGUFBkstuwgxw1SxUOsYP+e1n5OeII3Ioewhn05xjTxO+5QS2bERP0Pha3JiHmOmxu85TGK7gQUwF3fA9V8ZfgSSmWBzCxZwlE8gI31wq3g+p7IGJZZcqiXw5FMW8eIBjxWRoXpZKGqLLHL4VHtZv3EsDTxuerlLWiYWxEBUflhsWrr7U9PscsxUUT76vLggyWWj9EaJmjNc0gnpJ/FWgXm6vBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWVBj3GrIn6mZxmIyKIrMUxnVOm9B8EQc/qurIZOwxs=;
 b=NuR/8jBKX0PxFx4sDjsYGK6f/eNXKUVR6ngbf02JuX6Iv+P6L8crs3wlUcC7V0SHeRCC9w8t5pfQytqNIK0zf6YCBt/9GxhK833DsRA13WXt9FKjy/OefBgYiu3LtJnXCOnjyTNCFJZQ5r9kQHLWixMnx0sPcP1c4XqgWnSLSBM8HjN/rA+CnrOcTn28fmpN+wHjF1hHNx7hJPBOubhxyc93Ihs54xUpMW/HERwSjoqCap3mMrRgD+U9wfLaC4O3c3+LuqG3TheUTzunbKNbAWYWRhd2iQZ2p7bCPQv5Y+91VRrwVGq1Gq4DTakcdciwnJc8BLt8JNppkoYKBIIqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWVBj3GrIn6mZxmIyKIrMUxnVOm9B8EQc/qurIZOwxs=;
 b=gWpye4TTji1pqEDUC1FE/pycLNmT5hAKQCHrP83EGxCwGatfuJiu+EmaP6gNt9ajhYslPH1FuTx/9NYDltLop+1ldQnIXEsSCq5Wzh2/CGp++abPP2HO0cP0QYjcQkCIW2e8D/lO/SMD/dlRh428PP4UIV7RXLIvznC3mygpWR0=
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com (2603:10b6:4:63::16)
 by DM6PR18MB3289.namprd18.prod.outlook.com (2603:10b6:5:1cf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 05:28:16 +0000
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::a8de:65b:4fe0:32e3]) by DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::a8de:65b:4fe0:32e3%4]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 05:28:16 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     =?iso-8859-7?Q?J=E5an_Sacren?= <sakiwit@gmail.com>,
        Ariel Elior <aelior@marvell.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: qed_dev: fix redundant check of rc
 and against -EINVAL
Thread-Topic: [PATCH net-next v2 2/2] net: qed_dev: fix redundant check of rc
 and against -EINVAL
Thread-Index: AdfHBZL5hIc1SX9rQWGpnSTiX/lnRw==
Date:   Fri, 22 Oct 2021 05:28:16 +0000
Message-ID: <DM5PR1801MB2057E3E4D174FDB87743BFF0B2809@DM5PR1801MB2057.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 574257f2-9ed3-43bc-4416-08d9951cc00d
x-ms-traffictypediagnostic: DM6PR18MB3289:
x-microsoft-antispam-prvs: <DM6PR18MB3289575F56E927476D3D5F95B2809@DM6PR18MB3289.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rZNJISw+NISad6nKchiwuZ3THjyZ4Omx3CyBQBVV13RZlc9KMDS4TeX/6Ap2xICTLHpvmp1/YcnT7ZrH6MKXG+1fUdbz2+o6Y1WzrW30lUk1HrqHJic8LQuX1c3eWXnv6B10n4enTMpkv85rdA1uZoHllWmpdSSX77UYcLxnEZEinNt+lB1HG689U0VUQxikOy6lKrlVyWhJUiSNV9wTHSbMy0Zllw84dGKs2k7GWTVCIdAkKT16+PGnIi0Lv7GBgBgFWzK47JdQdzLFKOJMxOWoNfX/mgKSy1oiu4oaBcIbceyfuRVQBDbT05RiCVTyWdfdtS5WBdMX1lWgZ33AawJHp+4+6iLKfCixvEoXzWeydvjjSl0Giz4Jc0AP8vc8lmAj347APGclcnXrkyQM3AX6HMd08LF5xFjQjjrX6YiTdSlkW0IkqQLANW0rVZU+gmpFjo/n4+NgkPOROmH8i4+1t5WVc5NsZXsvv/BaUwDXlJuF0l77oH7BDmqCSCbIx7xm/omHnzYlivq/eU2OGeZpgl1U6FjnnHII4sNRkpit+h5EWi7EtfwhA2ewbu1jOK145I2iQsY9qbQS/AfKQQUfOh+AL77/BdJCsBQw/1c3Ks8M+RarcmFqe6w0HgzO6UAOnR2jk7p8eWgoB6P6Jt5y5hWGR309VRrsDB5xchhEvC8l/pjbzlnsRPl8Uhel4GgTH76xcXq5MPYTP3vAjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1801MB2057.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(66946007)(8936002)(122000001)(7696005)(33656002)(110136005)(52536014)(54906003)(66476007)(508600001)(6636002)(38100700002)(86362001)(8676002)(66446008)(66556008)(64756008)(4744005)(2906002)(186003)(38070700005)(6506007)(4326008)(26005)(83380400001)(9686003)(55016002)(71200400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-7?Q?76bqeNdmuacohAoeoJiCVxtmbDLUNjqcTMgTFfZS19XeQMJcNEh2b+TsQ+?=
 =?iso-8859-7?Q?HiUtAhW142/dVIhGbAoEls7KJYUEJ75VBImaqtc3k+zD278owA6WGk2Ezf?=
 =?iso-8859-7?Q?Yrx4DdQftN2mvyHwgbYHE8tE0ZOgTLgyShyfQHRpQCj/kEZPzy2a/K0yi0?=
 =?iso-8859-7?Q?qHsPfLG0AEF8cTVchhA+pqr2sSexPna9bRPqC/UrdRkuaKVfMr5kvj0dWa?=
 =?iso-8859-7?Q?HOk1cQs1gU7Wh02+UdFLijW1bpSWZmOmCwYiert53LM5aO8qXPpz0iltqU?=
 =?iso-8859-7?Q?T+CrWI/sj4azLLKD0ZyPdU3b3NjWRdS1KbSQjjqFtE3aK13EjpRwhLxe5G?=
 =?iso-8859-7?Q?BSWEgzjk4GxvANVVBUoLiHLn5gEkmx8Zgyn/0+v6DRfKJeIHDz58UFJxRV?=
 =?iso-8859-7?Q?ds/aJmduWwH2BVO2Wdy6lB3RfD27hG1iqq0I6OXUGa7aKimHFRpHHZK2eu?=
 =?iso-8859-7?Q?zRFUEqg6QfEfTLE2jldvCyi6LcefZzFPoXtJoH+AEvlCB7tIYRns+HPjaJ?=
 =?iso-8859-7?Q?1jD4fh2usZ3GVrUrq/CMw9Yf3omeid+/hBQJUEr1lvnJNOVzDTSCbF2gVI?=
 =?iso-8859-7?Q?iyjzrCZ3g0PGz4Fa+qPYbXCBfKYp+8s2SVdc1yuiIwmxqd204msDK0RHl2?=
 =?iso-8859-7?Q?qAEK0691PRxqsSu98NLOzBFTUJXdeAquKXNNb/0dyxn59asZnbrxSX+zQj?=
 =?iso-8859-7?Q?CfdQJOBPkpUxp13xmfwPLKm0spNoQ2NY1MqeFBnG0Sy2naAcryqK1HmIGx?=
 =?iso-8859-7?Q?qi5caUJyI+ZhQNsGoye0pU/YM/jha7rGvL9/urKMGO4i0Mp52Gk/lXLmIF?=
 =?iso-8859-7?Q?oeaR6t0Phn6Dkwt9FCLf4duLrPQFjVzA9e8ttA34zJIez/iXHMGbiUDA71?=
 =?iso-8859-7?Q?IKqOrOvqBlY3yWcP+22nEqH4Ap2mdqkj8fOFZtaDgb0immw/PcVY8RB4yW?=
 =?iso-8859-7?Q?p1M3p/YCGq9PRu7THryq3Wc/OeYG2biCI8ma6UXqqy6G9aW+S9JYC6zmHF?=
 =?iso-8859-7?Q?+rH8usup1geJaitKnEun0hxXqtWt9ITZ62aqpbl+6zjauXisjw5gwxHyyn?=
 =?iso-8859-7?Q?er1bHfBdr7bYQacyKGsXL13oT3trB21zTjDW1roETIb65j8pEu99ajuf++?=
 =?iso-8859-7?Q?z8RU/bEz5yFCYccGbRNWEPQlvupSYc0xuWEG8aa13mpU4gxbntz5VyAo0f?=
 =?iso-8859-7?Q?Da4mXN9ato6i1Vd+RUWvkc/vLT0oTNjJvWroRaDcJOdln5KYOkQcTlihoL?=
 =?iso-8859-7?Q?Hkb6dxjjyLEeF5j+CrkmTrTfW1zot6+ZKtLEDTX4smu/t5QCeSNUeSN5JP?=
 =?iso-8859-7?Q?PW2HDlSflwWdMvz3JSG1t1c5Zc5ZWTdNGURkYMEjrakdCiL0MLfHKOmPmT?=
 =?iso-8859-7?Q?zrDbtmF3cRXzd+5CXpyuo5lxaP5tst48kIkt4nAbz2xJVrMcyaWZNtGrSI?=
 =?iso-8859-7?Q?S94dETGguLDA1H7DP5yhNvuCDmO3jMeqd0GVO55e1gJ7R8O8hkklWTdaQv?=
 =?iso-8859-7?Q?0=3D?=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1801MB2057.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574257f2-9ed3-43bc-4416-08d9951cc00d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 05:28:16.1994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkushwaha@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3289
X-Proofpoint-ORIG-GUID: NheeyWaW7_Fy9rfzD61IG-kHOTGzvZiT
X-Proofpoint-GUID: NheeyWaW7_Fy9rfzD61IG-kHOTGzvZiT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_01,2021-10-21_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jean Sacren <sakiwit@gmail.com>
>=20
> We should first check rc alone and then check it against -EINVAL to
> avoid repeating the same operation multiple times.
>=20
> We should also remove the check of !rc in this expression since it is
> always true:
>=20
> 	(!rc && !resc_lock_params.b_granted)
>=20
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
> v2:
> (1) Fix missing else branch. I'm very sorry.
> (2) Add text for !rc removal in the changelog.
> (3) Put two lines of qed_mcp_resc_unlock() call into one.
>     Thank you, Mr. Horman!
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 31 +++++++++++++----------

Acked-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
