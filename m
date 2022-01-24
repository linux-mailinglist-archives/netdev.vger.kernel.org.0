Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CAF499C1B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577286AbiAXV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:44 -0500
Received: from mail-eus2azon11020018.outbound.protection.outlook.com ([52.101.56.18]:41477
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379174AbiAXVrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 16:47:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwF1ynL1uy3tbXpK5af64c19f/8uFsOhq3q4Hzf2tWx+0EiljjW+7BgCi5IuwJQW0pYtiw7s5eGG75xu2eWLrkefbTYmufVfgxSlnDRaxP7TaB9JRBmmq1kNuqaqEmmweAR84Wp2scoqy2Q5CkyleGbJZTwmyJ0aI0to4BbQK3obAlz1zZkEvbR81ItpSNi0GcXMsxNe1gDpcEiN3BZ7T3GppduwW2l75G+lMcpASWF884wGOZthzkuOlmmLavwP86Jh/D3QYWv3SGQ1Awo/r8XC1f6PkecFlZQYMVofUGRl5pPBBnoQAE2XyX3AvrTtgolLok6Cx4ZaaJF0qbdwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKArL4SChQo66aEbu88jwdaLA1KVkt+dPisOwu6gSqg=;
 b=O9R6nPXUmUHX0JOITfFtMJjFqlLi27Ph8yIfzH6ARfRwzZZvvy2p0I5X9ji5Krs4R2vBAHTFt+SC/nJsZEveFitDVz+UyD+KRddGZv1A5SxTeXIQ47YVbN9kowwOVIP+ltoYSoP7CKB+pUZ1Srxfp6uBMj6OEkwGZEbONRbDp/5N+s0bp9crfhMwudjACVmcda66S5FdfiUxwbI60Rl8uqhJaXJVW29RHGEAxyjF0JL9M6PtoOWLdOXC4v+L+coHJMIm4MnYUVgti21WhH4XHd2WtS3mHm9hDZ90gDrfP1OKpkll3X2jfeOqZyylICvOs/NMHRiPFVoeDZzn0rZdPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKArL4SChQo66aEbu88jwdaLA1KVkt+dPisOwu6gSqg=;
 b=NvvBr01P+E4Jp9aOlBctR3fSJ/7y7yX+noc7N1bKRrE59K7wiu0gfoZFc/h0IfoxnEwMjpWMXc5f1M/Ni0E0o5XAEAEAYw1nlkvKd838DlLs65twljpyHZx5flpeZHU76hkjZEGNfhyKeKbriL7vMeqaEVGhVUVwfsjMNTfRIco=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BN8PR21MB1236.namprd21.prod.outlook.com (2603:10b6:408:77::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.3; Mon, 24 Jan
 2022 21:47:39 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::f57f:2d2:a927:e29f]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::f57f:2d2:a927:e29f%8]) with mapi id 15.20.4930.014; Mon, 24 Jan 2022
 21:47:39 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] net: mana: Use struct_size() helper in
 mana_gd_create_dma_region()
Thread-Topic: [PATCH][next] net: mana: Use struct_size() helper in
 mana_gd_create_dma_region()
Thread-Index: AQHYEWqL71kLbOSZDE6aQS+a1CI2iqxytI1A
Date:   Mon, 24 Jan 2022 21:47:38 +0000
Message-ID: <BYAPR21MB127022573CE9A4158B2317E9BF5E9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20220124214347.GA24709@embeddedor>
In-Reply-To: <20220124214347.GA24709@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1aa194d7-1894-48d0-95c7-f8cc96d67ea2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-01-24T21:45:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 769ac982-5253-496c-3eb4-08d9df832429
x-ms-traffictypediagnostic: BN8PR21MB1236:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BN8PR21MB1236F3A92E1C20A63771E203BF5E9@BN8PR21MB1236.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GSLXrxiS8dKVbC2rdTTToXlacbIv8WYZtdqKlmSH4p40cwpUUSduoqEpw039q9lgEtbq07z71sAAJ9CP9F1JWZ9DfbMfJE7C9fPgMRxKEMjQ8COXIjACq6Ze3/bx5KrQ6TQcRgV/yHqhY5dwG4JAHSDewV2nRJC5mREfilFV1EAQFDRs2dugox5q+aziwBry5vTQs4K0GWc+nb2Z2MZzlgvxM2BoSkUR4s0xMe1EyDyOtEvtKGR0mizKZSD0oWhsaVGzays83vKeLyhGnI4tz0KKiOY+JmpbLwh8K+hRBaJwbKa8UFiuuTRIyeZEgvOSAfIYIHUdpH+yHO6bzgkRQQ3F8GE06KtQuyfX8Or+44LHrtTpH9MnevP+6NA/PwnWb1g+TZE8NPSHBqKHFWRcavEp9Mugx0yW17pxw8lt+vSS7NXisEcH9O0Zmc28UGb2cvr9Q6e4KSzXUKqqieq9lkOP3njmIlr7LS3ZUZzwFhBa4kjPUddjhoPnGz2rQoUQ4KkbjznHt6TU+F0Ixh1WD/1gYcjNkuC7rYSGqCPizag8M4bva7pxbgOZrE42YjoiM/ILbV3FWRrXfiJbvxlLAo1RtVut71PACRD4LzXmMV/RVnhQfkKTDV35ACGjxWMRcYLAs8wHT0dH/CP+vJUQ+Z+NvdKCl0WwZZuo+oyWTc9EcZQNgzVpfSSvgK1qMlU66HY/ztoO3uQwBIYn2qjfcfL7NJX5fYBzXGw7sIML8d+3S26ZAMsSL6TCBCHq9rHA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(2906002)(64756008)(38070700005)(82950400001)(82960400001)(66556008)(66946007)(9686003)(6506007)(8990500004)(122000001)(38100700002)(66476007)(76116006)(66446008)(4326008)(10290500003)(5660300002)(186003)(26005)(33656002)(71200400001)(316002)(508600001)(52536014)(54906003)(110136005)(4744005)(7696005)(83380400001)(55016003)(86362001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qCFSfcYek/fZStgRL7hfNuvR+IVzuJXBdosFHcwRffSrbKn7weU0oP0WpshN?=
 =?us-ascii?Q?/slYi/mA0wWEP1OcFaGYwvDw1IkFm75XGkvda/HFmT9YoaFzd/I5flXaJ6/H?=
 =?us-ascii?Q?fgNmhpy0/BEwlCP3afqcqbKisu71J7Cm3gsKTdBXNzEwEzdr6Rgj9aADJox/?=
 =?us-ascii?Q?uggUkanA670h6JEqXc3nKU0vApt5dlWVxDjoO6KtaE/k4OwHDYxlNcFSHXuy?=
 =?us-ascii?Q?ufp8/tUdN/FWFQ1rUgdYA+U7c/AmeK+BgGVsrkeRNqI8DFbOCQ4dxyx4dcC1?=
 =?us-ascii?Q?hVVEhV8T3BXdhS+1sYbkonU5r/QV+kcWn9uPz3Y3fa8euc/6crY6ERFoeUbT?=
 =?us-ascii?Q?KyY/NsoWA1VfvPUOmpQFO8y7IoOgD/KT93SgS2m0u/f0LjqL7HVZ+yDtPh2i?=
 =?us-ascii?Q?OzQNnzmFTzMv7PWBVeslEJ7RPq0VNutZFDRKzXtciErhPt559+lu5VAT+B5W?=
 =?us-ascii?Q?fmziFMeY2oEtMYMH7FGBPdOp0ma8WPvcvKYBFcymLFsAwGaFZX7C/F+V+2yh?=
 =?us-ascii?Q?Zaq5yehSqMLfMGX+eEFqgBLZv7W9WzT5lORyljI2wo7N3gxpWT6Fhq/Etb8H?=
 =?us-ascii?Q?L8lyRnyAVqPp6Ng6WLZeInmTozUR1+xJnncqzeUI7RLNkPN1k3sg9ACVqJce?=
 =?us-ascii?Q?odLQW1oSslU0NSn+CF9PLSRJmve/nzfAYwxqYpuEEMfIAa6cQkW87TJoAcFo?=
 =?us-ascii?Q?KOzKBmxnEVCb7UlqwncNNvtJr0VAHbxnnNWxATbOh8tvbh3QZSBaWQ9rtVKe?=
 =?us-ascii?Q?ZMwKxWx8112F5fsTpZonH866xnfQC+ZwOjt7/eERPinaKORLGkaxYV7hM3QI?=
 =?us-ascii?Q?oZR/d7FJoj68YxSZxGNG4bLoN/JDBgVB9c2KFW1OB90i3ydAo+E2b+oicfCE?=
 =?us-ascii?Q?hJm8XyZwTDauyMpazxLxmhu6UclfquOK11M2glH+IPQAjcABXN8DQZv7N03r?=
 =?us-ascii?Q?LyVm/6epQak8thXBSVceT+/TjXM3Y17++o7+cuT8IQVg/MrCARVVGdDkIueO?=
 =?us-ascii?Q?RAMRePKoxr+0SCuZWf1kWCs9TbCHC+/oaVmRk6McJUee5NuO9JvDp+PPOdON?=
 =?us-ascii?Q?8wjVkl09ua/nLMNKiA8XNSRKoygZ7AhWU5WOnLlD9Y0012bFRnmM61Uosf4I?=
 =?us-ascii?Q?PW0e/WtUeKEWQFKFAISdpYpq1ddheXNdK7w/JNWMRrh3QBSQkZFhqV9idJto?=
 =?us-ascii?Q?QSbIi6CkyACqtvAe2MnXIQNoA0MmemkYjXuSC2Cn3ailSglIkdNyKiLi03S+?=
 =?us-ascii?Q?NxAorEx9VjRsv7yD3EL36t85mSVDEJZGsKveqb4qwYIkgiolZZAy0+VfzPkO?=
 =?us-ascii?Q?yeHWaUjZIKdJ1pKPW70iR8obcX7HnTtSxDEsrie+bOo6Dalmc++AOsLj62ZJ?=
 =?us-ascii?Q?12aeNrRtkHG8GZKIN/acD2rWrmSS0AOZ0S3kWQTshH2em45UQsXX/8bkJSxv?=
 =?us-ascii?Q?eus0cRaeSoB2PwvYPu5m2MsFNVvRYj/L3OhK5Odt8ha0J/GW5Yhys+Uv1eg6?=
 =?us-ascii?Q?t91V3vHM8A1wmVow/qysplb5MYuHfXtuWx9kbToxE/hwQCTS+hDt4FF2J4dn?=
 =?us-ascii?Q?AZn45z+xfPw1cPJaB7ZAUDWBX1bTgIqX958YyjeZIejRA8cS24nOyMZBM9Mo?=
 =?us-ascii?Q?iRYLUeL43+yviBaOzLqB1BM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769ac982-5253-496c-3eb4-08d9df832429
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 21:47:38.8228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKHhhhRnGWqf8idqA63L5PtCBsqTPKk0YnYUQ4UOGjNuYN+QyErfNzcNMQj4QKbfaPA4YX+dMEwt8lt3EKv9Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1236
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> Sent: Monday, January 24, 2022 1:44 PM
>  ...
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
>=20
> Also, address the following sparse warnings:
> drivers/net/ethernet/microsoft/mana/gdma_main.c:677:24: warning: using
> sizeof on a flexible structure
>  ...
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

