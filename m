Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7053039E6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 11:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390618AbhAZKLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 05:11:30 -0500
Received: from mail-eopbgr130108.outbound.protection.outlook.com ([40.107.13.108]:55822
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391515AbhAZKKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 05:10:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxrK5L/VLDRPlwCe5oYqNhMhTDdb1dKd2ZvbpNJ31ZC6LHwwCotvcLg62flWBFgISpoU2RCdkYX7oGBIacsDoav6L407HQAKt8JIjmlwU61ranNJa+YSiqFtM2ax4PPjgiojQipAcVUVGcMCt/fTLP8oRKGSLxcM3w+42yP6eTVZk0ufTMPDKXCT7DJR4SNmOJcPrPnq8TqDqXXZrI1viZhNh0z2E+kDgR7VzDMQWcPFr8VHjTtPKZUReHJjk8IXD5qittSmcYmqDI2YrxJdBncQ1xbxcInDcgSx/zWpCse85W9IBmERHbm+g4GPq5qSyJXTyL8ht3kUj3G1DZ5KTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uc2eAJ2NbX1NVyWiCRPpMctd5wfiVoAYYGa4AKN94uY=;
 b=ftZxJnUFOAa2PJeJyxgj3xYgd+IFFFgJ/89mypGuw1RDMKHNtUrFPvrjmCVkxOBsNxoZHBqa9iKjytWh5hi9SaJp9CidsmXOuR83im5soNQVAuDGB2W2c/W+NRzmN2iaEQOiCnblZQ4vx3oq1yr3VsxcfEcN2FunRe9llRgG9We0dg4kKLtB7q5EHq2xzh7rJ4FjCRAqQZUy53C4dmZLmEFhdlFPnDP1osdngR63irQZSDMLXQyM5InYyn9Sn/Ek6VTXoE8C8sd6Y5gi/R/l96TMZIY61uyy6sU5o3TaCFcJlJhegRiAECh9Rb0KI6OR/1vxx8U7U8ZIhNc7axYtjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uc2eAJ2NbX1NVyWiCRPpMctd5wfiVoAYYGa4AKN94uY=;
 b=bxIFUm5Y61Jv4NHtezt2i8oJ6MVrvu1y06tiCTAOn2ipl0Um/hwD6m169gghmgR/k2eJbFImOq8HPwTc7eiKonzwo5k131tNtgeVuaKYmr4atY4UVGGohka9pcBNGar3JPdfwW+rm737OqRpt0XLEYrO7RzepeFGueB0aaThLOE=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM8P190MB0947.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 26 Jan
 2021 10:10:06 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 10:10:06 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Thread-Topic: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Thread-Index: AQHW8xcXY5euT+iepUq2JFXYOtkL6Ko42mmAgADVue0=
Date:   Tue, 26 Jan 2021 10:10:06 +0000
Message-ID: <AM0P190MB07380476D3B89CDB50BA4151E4BC0@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>,<20210125132317.418a4e35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125132317.418a4e35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [213.174.16.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06941239-417a-49fb-d9ff-08d8c1e28e0a
x-ms-traffictypediagnostic: AM8P190MB0947:
x-microsoft-antispam-prvs: <AM8P190MB094779362CE0BB053773C5E6E4BC0@AM8P190MB0947.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nyG2XC3nvMi3HBpd2Wy3MtcJOK0VuvEIARYGMKzC3mjVszHc9bh7v3crjkrDG/25tyBw7zvRl2xFTX2p6ZZbu26xLDuSS0LGoQOJWePTWuStVMZ6e6Ru4pMoY0Pd3UzVZdwCAPiSqvdTw4wEeyzpZufRS6neQxoksluwk234JZEggsnbudnhr01MStE1ENfy3++Bq6o6bu1udBmfwSF4J3HVSNdn+aG8r4ooNcTzuo5eFfUsb7FtF9DyYjU5no/w8a+2w1SxgVHfXzn195m+G8T3PkAK99HEBzVCLorI6va4WNXfyk3rir9M0zu1m17QZSn24Rx/QHv5F8TWd5Iun5lHhKcm4xqL49tMUFPlqfgsb3L3Xc+QF5m8tSluQW0OEk8aRF9kAAxeL/DCnZPsmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(39830400003)(376002)(396003)(136003)(346002)(9686003)(52536014)(55016002)(478600001)(6916009)(4326008)(4744005)(54906003)(186003)(66476007)(8936002)(66556008)(76116006)(66946007)(64756008)(66446008)(86362001)(83380400001)(6506007)(2906002)(316002)(33656002)(5660300002)(26005)(71200400001)(8676002)(44832011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?grU7DoD5JHfiioci4u/WJ18JR073LzmN3paZlaULpNuEG5iEfldSikNlhu?=
 =?iso-8859-1?Q?trXZhOdV8QBMX80tzAxHVD95eyib8uICFAp00lEe3YNUGvD1J467fnqjFH?=
 =?iso-8859-1?Q?r1Rk86TH8ao3yvv9/Phefl6GLeUqfz4W34iI4BKdjL2Uv3qAhfW7v5XDNu?=
 =?iso-8859-1?Q?jQWOfmA+ZuIheieMydy0NLRjehleZyN2rhH2AlV5MnACg2qjlFmodUvywD?=
 =?iso-8859-1?Q?QHIU9kBHkv0kLBzIGO2szq2KoPMfUbTnGFvFutriorP8INCrW4XuUTkVK4?=
 =?iso-8859-1?Q?uidjGpfIpBzjNWh3/+vifmlM+cDtLDkbpi6c6vS40v1vkg916gpwLpZ78A?=
 =?iso-8859-1?Q?Q233DXAU5j40KKS8nKC0ev4Pcb88d0JSLM3x1+ChmOMAYWCwRo2rUhZ/cM?=
 =?iso-8859-1?Q?4UqVKAdtEsu0MKsl5fjdVwmvPg9tDNCUayOEyBIQ1OaqF9tr6mUBuIwOdT?=
 =?iso-8859-1?Q?2XBoZuuHpf19Nf/+15nTlkOPjA+3wNyFmqSjnSZvIYDFLhEko8DT+JXg7V?=
 =?iso-8859-1?Q?/JXJrEATP1kELoEIbk7sJxHno4vZ3SzxhKuik0m81rHSQsbEvE4Ei77AAd?=
 =?iso-8859-1?Q?K+8awwnvEDmlRRB+PfhWaB+LUU9KrP4k5V8CkA83MjsBketAEyMiyne7wN?=
 =?iso-8859-1?Q?ZqMrL4JnGSeGAvnaVT3emU9NZR77Cw7lKe5Y4j3BdTTeb2jX8rxZXns6QM?=
 =?iso-8859-1?Q?WfpVSsS2nM2TLn8oF2Zmy+p3chR5UrXj20QDfrlLrFLHBncuxcrMB3FTZd?=
 =?iso-8859-1?Q?TlxLVIS+nzYHn7Sva51ppevnOXKZAL3WkULxRwtnyi7oWs4+gaqhubiaFw?=
 =?iso-8859-1?Q?/QGITekbH3XBfMX+5ndyuzNJfp3BtboayTJkY3sluZ8qUZ12v4HfPQM0a7?=
 =?iso-8859-1?Q?6Aiwm/cHknNLEY3ypIdxfX9loe1ICjjrencmd2+TLiS2oBZq3LBVz4Dw9M?=
 =?iso-8859-1?Q?FRdy9eR407BLu4FUEBjcdychtXJGqcNYxmtgKEdPDI/LyJtwSJC2bHrJdD?=
 =?iso-8859-1?Q?8EMn2uZaYs/rJ5a/cKNmP3B+7sJW/0B3ZTCFSDqUoNOCwav2G9xDr2YmDm?=
 =?iso-8859-1?Q?bbuIpUT7R1AeGU+mM5gJd10JlkMgm5Wvajx30wmw2R9i?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 06941239-417a-49fb-d9ff-08d8c1e28e0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 10:10:06.2252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCdWyXVkuXnBANVpm4nHIrceNK0ROaCAhvdOsbXM8iO23q+6dJjhMWB9G+ecQQ2btEPUWO4Pd0KglSJgE+UbW7DOVa8nyKpjtccWsTTBH/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0947
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:38:56 +0200 Oleksandr Mazur wrote:=0A=
> +=A0=A0=A0=A0 if (trap_item->action =3D=3D DEVLINK_TRAP_ACTION_DROP &&=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0 devlink->ops->trap_drop_counter_get) {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 err =3D devlink->ops->trap_drop_cou=
nter_get(devlink,=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 trap_item->trap,=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &drops);=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (err)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return err;=
=0A=
> +=A0=A0=A0=A0 }=0A=
=0A=
> Why only report this counter when action is set to drop?=0A=
=0A=
> Thinking about it again - if the action can be changed wouldn't it =0A=
> be best for the user to actually get a "HW condition hit" counter,=0A=
> which would increment regardless of SW config (incl. policers)?=0A=
=0A=
> Otherwise if admin logs onto the box and temporarily enables a trap =0A=
> for debug this count would disappear.=0A=
=0A=
Okay, so should it become like generic HW counter - trap_hw_counter_get?=
