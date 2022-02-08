Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24A74AE341
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376682AbiBHWVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386192AbiBHTnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 14:43:17 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A6AC0613CB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 11:43:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSZi8F4yn5BIO0gRnrt2hSv1IV4h/EAjrHYhqFsN2RxmD2KntdjRj5YurOsWLs3tH8+JjPhIdWa/2nxajAOGu46zjPCXrx88UWSPDB5yH3jPXJZBwlBYayqcwux/p+HUcfG7Dk9TkcWXo8sY9GJxNHHAM26ewf40QaXfbP0scuuz98cWhqoYOMquZ6cNxxRz2/tQjepnYMeSz2/l/11SPsEW+9sYrgpFLPdUlf379DFsp6QQQq614G3YkXbi/CBuVyPHvUL+bNL4iyrivki0+vbpuzeUx14g/SFTSr6JQKMcE0DPADOqpy5V6kljZKpnv/oah6U51xYGsJ5gvVg+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wj6+qJUz5W5p5l34leMWbOs8Qs/YbS+ONGsXetgicIs=;
 b=idDhirFIYuTBT6K4ZLLdTJy6dcyxHRmNdvVotTng7TBny/bJdhR28kPsx3CQ2+XdVT7J72P2UWI1g+duya0WMV282BVruMwmnC+zbZBjY5/md+pZ4ouOTFNdVO+ZIOoX1mEI1885sGsxbhxI4OOeZ/GRiEwjURo8yCMyNKz0ZyVvr8+Cp+Vr25JNhyPL6yCfyKKTbvG2HjnCQpc7snjokfguVtYk3opOz2hWCM+CI3lNQ1kB3A/wHYDkvWeJkkFxatN+ZRepE1YqI4iWH4FyIYoAB5dePXXid3+sWaaRa5qhbHmoP/Fbix3dEvJGqvi7WWK7eoB69txl60j+whrfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj6+qJUz5W5p5l34leMWbOs8Qs/YbS+ONGsXetgicIs=;
 b=RFOeWJe8ZFeejMRVga4rhcBHgZKW3bjSNOOBaLb6DLJsv4kUgaFWU+/aM47DdSciPKF42bqgihl4f2lc1q95IJl+DFAa5LMXwxqCC+O5Ra5ZU3Yke8pjcIvuoWpvvhCBfLS8FOpn2ZnRKhFNKlZRdyTq3DQ+TAVh7dRUBZQUujypW/nVbBnw04XBaiLZ2g7UyMxf3otHDNVYppkOi2DAil+iyAdospK63h1SYbgl3EOItrqY99Gk+Q86bqS3646hbfne+CK+89+ltiOP/Sl0bEPj2FRz84VMPM/j+hmTV9C8qEXROyDsdL49lp2WDixc+E8kd1urI8FJuHHaNFLUIw==
Received: from BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16)
 by BN6PR12MB1732.namprd12.prod.outlook.com (2603:10b6:404:107::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Tue, 8 Feb
 2022 19:43:14 +0000
Received: from BYAPR12MB2998.namprd12.prod.outlook.com
 ([fe80::783a:7f67:bce:67e3]) by BYAPR12MB2998.namprd12.prod.outlook.com
 ([fe80::783a:7f67:bce:67e3%5]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:43:13 +0000
From:   Maciek Machnikowski <maciejm@nvidia.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "marta.a.plantykow@intel.com" <marta.a.plantykow@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "people@netdevconf.info" <people@netdevconf.info>,
        "milena.olech@intel.com" <milena.olech@intel.com>
Subject: RE: PTP-optimization code upstreamed
Thread-Topic: PTP-optimization code upstreamed
Thread-Index: AQHYHO86ChW5gJ1oiUOPKQouPfEMvayJ8AaAgAAZ+oCAAAKSsA==
Date:   Tue, 8 Feb 2022 19:43:13 +0000
Message-ID: <BYAPR12MB2998E6F31AAAFBDF9294A092CC2D9@BYAPR12MB2998.namprd12.prod.outlook.com>
References: <20220208132341.10743-1-marta.a.plantykow@intel.com>
 <20220208095441.3316ec13@hermes.local>
 <MWHPR11MB177519F17F8BF5145DC773BBA82D9@MWHPR11MB1775.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB177519F17F8BF5145DC773BBA82D9@MWHPR11MB1775.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec77fd03-49ae-439f-af3e-08d9eb3b3eca
x-ms-traffictypediagnostic: BN6PR12MB1732:EE_
x-microsoft-antispam-prvs: <BN6PR12MB173240E203620AD863189FE0CC2D9@BN6PR12MB1732.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwv+eqA9pdpERSRZM2Q4un9l19fc7F6/4ryzdwKYj01dpYdTlL9vOwocRHp+HM76UU17s2zQRyjKuIgM+2VBCpCPX5mgU5F+N0E6LSgK4Cs3IiqotV8VtCSg0nlM1/ck1hWO2JRC+g07X3rdtKAXoJelW4WGkW1RyzNbs95cfH+0K14dZuS7cbpcvKZ7kJ0eu8x4aByumc/hLB7GmCYZ4vRRm682l9w1srgGebgo51BFmBPEkQP+r8wzjKxnDYCkGnQlEGaJGmsrt4WIBfp9NKXdyLXc2CbkZybtSojeIrVsbNFNV7MZGUlls0Oc6OP6MVmUWjqCYURny7yYCUfKVEAD1BxGBJMkKTHC3CiGhu2FpkM2UxwBPM9fGqPUgSS2fzhO4uQgCjAg27eYpXFVoE6XeycpSJeftBdfSb0lMfnGptbpD9QdTXAUNQK5gm2F3FDVuQ+0SgHvRXjs6VdvjQ/+UtfskKeAtRA5+6nR2IVU8GWfLrbNrt0tJ/ay9nL2cUpB2joprZv86BoExBSwwix0rS06/4lhqXtJMgSi0KTf13CHm7VxFFDdr5HmkcjSC1QGtMjvTjpd54IsaVl99VZwNczF6qJJHbFMt3d7cknXrtJUTNUXF8+faxqlL3szhMmM0V2TZtmwWD/QQS563yzWhzRaktikSckk8uTLc2ey4bxBTSA986fUvb7NiLBT/GoxGGjrq0U4fFxvUz1+kBfkTT4r9lZYUCnZjZDCAODnVAWxWDVUItK8HKOe6KZ41qKQ7QRV9dPwhYMfJlaRw8Oo+/qR6M1LCnuez10VOmk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2998.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(52536014)(9686003)(71200400001)(76116006)(83380400001)(8676002)(33656002)(53546011)(8936002)(508600001)(3480700007)(5660300002)(66476007)(86362001)(66446008)(66556008)(64756008)(26005)(6506007)(7696005)(2906002)(66946007)(38100700002)(186003)(316002)(54906003)(38070700005)(4326008)(55016003)(110136005)(122000001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TQCGD5TWrI4Piy/7YnxtiwjMX+CqshCq+D6NCMroCPY7uj8Q6EYhTOWiiclC?=
 =?us-ascii?Q?Trdekvt6LcR6oC7W8O1sO4yq3dZUbQ9LS9nmABf9U68ghdIdGp2bqY8UxoC3?=
 =?us-ascii?Q?IeUEBmKs4eFnCuLjTN6WNDXFRdpZNYAUqS0udu8w3xG5DGK2jStlECjRZgRc?=
 =?us-ascii?Q?FedcTN4cGngln7d3L+QnH06B+PpuPhiwl/ib+Q9XG4yrdqWZek86uN/qUyzK?=
 =?us-ascii?Q?kgLlL5TD2CiEoi6ptT61piMZrc3k5Od9RzpX1i2W87j8BH+jSF2tfqeLoud1?=
 =?us-ascii?Q?6z1P3frSNDgbklC4p+/zHqtBR9AFewPadjPlDmYAliy/2ytYIGokPhT3YPdQ?=
 =?us-ascii?Q?QtWNFnsd418Wp49UVUHpcQ2hYAfxabcBYoMnX1NboHgohepqsb7I/mVkTyNh?=
 =?us-ascii?Q?uJWCdR6jlWJozasC/wQwCernij+NXur1Kh9D6m4AhaSyu7l+zeXBr3CPn1mc?=
 =?us-ascii?Q?SiyjG2X9Uj8EmYecOyx4zGOkW0jkFCKeJEExujLHXiW9txuxUfkFF2LTSD6A?=
 =?us-ascii?Q?EitoGGuMuxUCAC9aKmD2k5teencIhbyX5/ro3myjcdmoYf5dgMIOnSytaGSH?=
 =?us-ascii?Q?DpgG8iVqOWrx/3ITBaUGwE+o5MYvD2QpA90ZNv3xl8OnZ/t+ryW0N6qDEmCx?=
 =?us-ascii?Q?u+phfiS/9Ui4BauCRrzBMymTa+N6Fi40p4iY2RJIiamGLuJJ2FLk4oiwolmu?=
 =?us-ascii?Q?aW4kqqTmxRwNz+BcLEMISPRjjzrnkJQ6+lpVypF2I/qAuzBQ16EvOCcRn5bn?=
 =?us-ascii?Q?E6zkBMNWERcIETcDURkZmyqK/XN5cDqSTf+t0jArM4/eeLdiJL141kErH3DT?=
 =?us-ascii?Q?cCZQkAxzuH0xkCc4ctwNzllrQX6LDWLnZ9GTAoq03b5E5oNT/XMlU6/SBGIR?=
 =?us-ascii?Q?hpENcztzA5uTM1XzvVio2KOVpUeb+sxj0QEi+g0LVUi1nXSv0MqXp/XQ/9nm?=
 =?us-ascii?Q?9U10IgL54cyyhM1S7svuFyLavw+fM+S/XKjN11geAKdaFnBXP8nacZ6xQGXu?=
 =?us-ascii?Q?U/j5LC9fIhOhp3riHivpggq5GFOraSwxkgZ2ew0jWWbO4T9dcFakPfIxPvG9?=
 =?us-ascii?Q?2i+Hppm4u4jtAzWYiYgEFI/5irfxlJfB10XZbrDx+E+DheD+hHHvBvDB+Xrf?=
 =?us-ascii?Q?rGWkzrXOAgGS6c+A9TVSNGuEHLRxVUGNgu5XycEavOXd5S55tWCOmYBsgWGo?=
 =?us-ascii?Q?vP1lv5YxSIgK7ybI2bqziet86iS9T5bRi9BjOgN5ONmHOsOkPXvGGol1NLCm?=
 =?us-ascii?Q?MuR9XEQtv07qePHC/Vfo5fVL1UHIOxBUjhhqNM9qWazvDkhJQ+T2H+AJXDpP?=
 =?us-ascii?Q?5MVcH2SALSku2JB67kx73tlH2pBbjA0+r8OXHkAns29K46WqogwYHoV530hB?=
 =?us-ascii?Q?r/xId6Xyu59o+Dz2bTg1ISCP46c7SGCb3Eo7i61mKmnjCHocwwrzqF9L0rnl?=
 =?us-ascii?Q?swPjstKCQFSWNOiynoaV5wZU+9z3FXLcYOU+HDxo3aOtpM/Wh7DrZjgjI+qo?=
 =?us-ascii?Q?JTZxMKKxbEyCXuqGClRFfj8rfchYc7KDCUrZnPJfv+seZhjzn3wHyuIPVat2?=
 =?us-ascii?Q?ZignLw/aZnY/ZvFzlxUvmnO0HWq6c4IMxbaayPK5+dNlNzRjTguzbWyYhrNt?=
 =?us-ascii?Q?zWCogWq5QmpeshMlZ1DuXw0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2998.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec77fd03-49ae-439f-af3e-08d9eb3b3eca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:43:13.7923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zmbLXFweNeKczYSUreP02JnmSHggpquHYNpg+cpTfyrPlddNe3KFVZyckeh29ld1PiXq8psTVEHkM+YWA/SE4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1732
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Tuesday, February 8, 2022 6:55 PM=20
> Subject: Re: PTP-optimization code upstreamed
>=20
> On Tue,  8 Feb 2022 14:23:41 +0100=20
>=20
> The process for contributing to upstream kernel is very well documented.
> Links to github is useful, but does not start the upstream process.
>=20
> https://www.kernel.org/doc/html/latest/process/submitting-
> patches.html#submittingpatches
>=20
> When can we expect patch set to show up on this mailing list?

Hi Stephen,

This code is not intended to be upstreamed, since it is a set of python scr=
ipts
optimizing phc2sys and ptp4l servo.
It reached the netdev mail list because it was presented on the NetDev=20
conference, and some people were interested in them during the presentation=
.

Have a great day!
Maciek=20
