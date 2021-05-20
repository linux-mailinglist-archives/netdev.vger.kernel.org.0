Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E2638B25C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhETPCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:02:01 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:46241
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231298AbhETPB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ry1FJBMZzdcfmWYRsGY4mK2IWhYqaXC3Ir8DGSjd+cnbGCw0hugfHcr0h+UwlI5yoGFrlIDeG+1RGr+NsGZXTaGvXQZml/kHDSCpDsH4wCr1rlI/m1Ja7GiHGBjNuj7c5sh2e+fQ5xAK5E4Pw6FuGEkLtRiQkoyUB/cAs2jRiXUMiJi2IxugVyjB7r35ctPFT0D2Gue6/yRTR7LAk0tq+xR6O2pug3BckaCDFxR5pOpZAZpnoDYo7efB+X3xjUeKVCw/gFx7mogCZQmYNfuPT713LLqilP1gPopXxhv2IJ7jgogp0Nz43q9H03OG5k6kuXhqoR8S5ITQ8CBceKScjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwkJFsh8TihdlwD0F+TMeFXO8ryjZjUJTuW5sQfhtLE=;
 b=R9lSX9DIMOrdXg+EslbPoHT92ZoCI+5JZASMaOUpZ9DDHiqtdlcn3PV1Dk7O06lykt5hZl0Y0EjNSOwO0+QDAQZnwMoFuZHV5LDmlsFZhcHK65PamHoSuFlULrvGFE3xHgqfBVd6A/uMIfw1NyFBZN+WrCLqezrmBjy26ACPqV/VQIbplq156B982WNKkcAHkS4V5dVir5EarPumrKNoK3rMVxMFXFnND+NnVuVixDMjaL+CGpp93EY9SHvQTXGB2NSBBJNR/tDNnTsi+kRFLlYhdRlMyCLF/yK0bVSCJA0KQBPbRi9rhJU8yMSuZMZUHSZP5GSClzhpTCpm+SjMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwkJFsh8TihdlwD0F+TMeFXO8ryjZjUJTuW5sQfhtLE=;
 b=gEP3PTLFdVVeow4BOghwdlv8vVVvmh7mqwBd53QZRUp8zEYezAJ+QrJoKYIGnxEe1ilqJqG63Ywi1T8XgDwxwbEyLRArsATAlMXg85DbB3YUimdAYacurgORSredxSTBi21Yp7ozjmARFfpeMdrufEagNQgA+0XC+tRY7UXdERpsrP/mZwzfYqYN57Cfkx0zZnTU3+gtpXiy7VYEx4z9dLhPJ6HycZtBhspa+u1XUeqNS4m7237Hf+K5LJelrtJ/j7uEGYpPUdwbGl9+xQg2VMlBvD5nTOaK8axNpvvnef0yW1q2cIljB45Lqt2cQSfLKG6c6EY5aMRkgQ8YUy9cFQ==
Received: from MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16)
 by MN2PR12MB4127.namprd12.prod.outlook.com (2603:10b6:208:1d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 15:00:32 +0000
Received: from MN2PR12MB4517.namprd12.prod.outlook.com
 ([fe80::9de8:974e:7898:92da]) by MN2PR12MB4517.namprd12.prod.outlook.com
 ([fe80::9de8:974e:7898:92da%6]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:00:32 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     "po-hsu.lin@canonical.com" <po-hsu.lin@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>
Subject: RE: [PATCH] selftests: net: devlink_port_split.py: skip the test if
 no devlink device
Thread-Topic: [PATCH] selftests: net: devlink_port_split.py: skip the test if
 no devlink device
Thread-Index: AddNiMpRdAu6PdslSI2GNdJ2nay2fw==
Date:   Thu, 20 May 2021 15:00:32 +0000
Message-ID: <MN2PR12MB451797BED9B8D96FDD18C255D82A9@MN2PR12MB4517.namprd12.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 234c5f37-b523-4857-38cd-08d91ba003d8
x-ms-traffictypediagnostic: MN2PR12MB4127:
x-microsoft-antispam-prvs: <MN2PR12MB412766B4C6E2F14B0E22142ED82A9@MN2PR12MB4127.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRAjew5qfyTH1PcYLXRDy24xPaclGiHoewzgh6HQYPeinC+T/PtJS/9/63mLBNoYFI25OF5SOcXboTJlVV+pqE3SPloQgGxUgZNwQ1i371LbosENngtKwXPDFuaOMzqh2C0ButCMmkshFjq45Cwh6wmgG3SqENYl1r5Apix/F+ZdDzbERcTbba6zYxqsPsZsuF/kZCaX33ypoi2b7ZysKAMoOiddtcsLx+v5IBIqhomAxyFKbM3PfO1qVeDZbFc+CzvoqDWL2PSk2swKJuxeRcVFqvqVZATGE4qzNsdGeTB7z3j1JdQ3vVoU4zNeemlkwvbMd1Uz8x2ieodyWq3PavRTRN2XJ7WEuI4GoSXDSRGo3xbPNTwgqGyArpcddjsW5qeIPt5+Cvj01lhxsbP33bMAAdkVugIZ6HgRTXi+U/sWPPBUfrrWV/mxYED4a/+zmTQqdQTLSi3glDvlSbyIakelcRwk9F7GwsnFB9AJOmfFQCHVfIdQiMjl9X9MPYHA32HMBIvbJTSgyszv0MOialdu3PFn6/Vb+ygyLMxegd40kV5A03ReUFQvDHBGUzb6K82T2+rMZSICKZv8m6d8G4XWeiaU0zhlXy3lslH3OozeAPnRoiSQi+k1G0bxp98FQMnAeMvIDsmlBw+KhI42MtKuRw7fqK0ytBx8y+f0fOYnt7sUbAAEfyKK8p5+Ph8g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4517.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(53546011)(8676002)(33656002)(478600001)(83380400001)(71200400001)(54906003)(4326008)(5660300002)(6506007)(966005)(186003)(8936002)(110136005)(38100700002)(122000001)(55016002)(7696005)(2906002)(9686003)(52536014)(26005)(316002)(86362001)(66446008)(66946007)(64756008)(4744005)(76116006)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?d1hVFBPXt3DEF+IVAls61lbq3Rimj/6Pq7hm/XkCt77n+8NwpaExYr3ELexk?=
 =?us-ascii?Q?RaTx5I/gOL8/romtNGVbyBATWC5rCLFKFrtOUMiUKcT8Li4p5rWuWJAb+FJb?=
 =?us-ascii?Q?l5OOkVQFeeBheh5q7RFErV4lU6af0udfkjUvCML0UoCtYiFaCQdZqo1cgvSA?=
 =?us-ascii?Q?f6EcYR9BaoiFxy3MSI6luoiUEVr4PLW0bUX2yRCZno6mjTk5vXyekLl/9NSb?=
 =?us-ascii?Q?c2B1Bied4mpzyHBYHcyEGWbhIVmK21vxLMw4qM6oIZhxds5iUSKYEiLKkaO8?=
 =?us-ascii?Q?h4Fo4xycaQXpBjy7TvgspDrbxymKCN4ScJ6zjyroY0u6elmT9T94J7tqVrDG?=
 =?us-ascii?Q?U/lJfUmn90HRcjkgAMXzqYZPCd7sQHLQtXrxHTLVrlyxSLq2gwDl6f5n/92/?=
 =?us-ascii?Q?pioJ7AaL3JL3bd4VtkJI+OdE3X32Xud00BpQKTrf0aAHGIXv/XiDk/tZE7o0?=
 =?us-ascii?Q?GTvxIlFDMi1b0dHNZS+V6XKDngoOw2q/OipYAeNPl7uEXFwMHZCXLczmR2GV?=
 =?us-ascii?Q?fjC7170DO+qQ1jv+hF4jjS80eeudhjDMWeLC3xvSBrgEFvuQJ/MkNazDENWK?=
 =?us-ascii?Q?8sQC/HPnQTWLPbRe8V9XxXYHaiol0Q+tPbambryKp/sV2Oa8cD8JmW+tffzg?=
 =?us-ascii?Q?UxXEFRJKcL4Y5AyyRHjcP58kJkfSSUhtne8PaQ/c3XEAL0MfCGlg9LY2+v1z?=
 =?us-ascii?Q?HdhyiZXFRCEiIITDKzunkChtyrodqiNRm1xMnU3Pt8CUo6wVEpVzzCqzywMm?=
 =?us-ascii?Q?e+B20p2Pf7osgPhyib5MwseXSBXCZ7WZcBN9VvQWlc4sno9U9np5K4z6AXvv?=
 =?us-ascii?Q?uGu53J3sXlWB3yU8HiznAtEFKjdnNz0abNqExe4LiPJ65eBK9+E/lkgfyzDt?=
 =?us-ascii?Q?Dgvb8+ZSbQdfpowEPbXeMhUsmjBDjrDhZBiQJx3robeHHJNPTDurYVYuJZch?=
 =?us-ascii?Q?tvlwW1IDSrqSZhBMQ4ffeQNyM0CQv1yonJrZI5a+Xq8C3JGEz47F+gq7bE8V?=
 =?us-ascii?Q?ElD9IJvpV+RFWqndoQKG6oH0UxkKyFmXm7hjpy4o1yW00WMGSUlLg284qjgH?=
 =?us-ascii?Q?klUjj2hxq7JF0Z0BMkXys5R2F+RATL4T+Xah00lCTJIXkr8AkogwoIemhKH4?=
 =?us-ascii?Q?N6Raq4wHrvQiHtPCU7QK+olPsmdbnNFc95sL/y4/AZYtlmhxRHcXvBSCnXT3?=
 =?us-ascii?Q?nFJoGeutjeu7hXR98kcrESia1jOOTa+Vd9HYC8jlvQqkwb11Qk83OLoEx7+Q?=
 =?us-ascii?Q?VBYruVPTDLiR3hpUqSOYCiXMCJ5aFrTlAo6v/aa+riww2XE8nFASm+v3Ptrb?=
 =?us-ascii?Q?7qLJFdNUWgRqadP+dfojYlol?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4517.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234c5f37-b523-4857-38cd-08d91ba003d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 15:00:32.1122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UusaTlXhIS4II9HWNwezhXYumXt6qtGljunXYdOe4wBHV1LUN9WvlVs2vw8sVlCrzqXTEEMHmTUSTc7uPnb3Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Sent: Thursday, May 20, 2021 1:50 PM
> To: linux-kernel@vger.kernel.org; linux-kselftest@vger.kernel.org; netdev=
@vger.kernel.org
> Cc: po-hsu.lin@canonical.com; shuah@kernel.org; kuba@kernel.org; davem@da=
vemloft.net; skhan@linuxfoundation.org
> Subject: [PATCH] selftests: net: devlink_port_split.py: skip the test if =
no devlink device
>=20
> When there is no devlink device, the following command will return:
>   $ devlink -j dev show
>   {dev:{}}
>=20
> This will cause IndexError when trying to access the first element in dev=
 of this json dataset. Use the kselftest framework skip code to
> skip this test in this case.
>=20
> Example output with this change:
>   # selftests: net: devlink_port_split.py
>   # no devlink device was found, test skipped
>   ok 7 selftests: net: devlink_port_split.py # SKIP
>=20
> Link: https://bugs.launchpad.net/bugs/1928889
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Reviewed-by: Danielle Ratson <danieller@nvidia.com>

