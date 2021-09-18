Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BD4107B9
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhIRRHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 13:07:48 -0400
Received: from mail-oln040093003015.outbound.protection.outlook.com ([40.93.3.15]:4559
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233210AbhIRRHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 13:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzYtJ6ZJEZF4X6Kd6HcT0jFs6OZgzrBzv9QlZ9e/gFU5VuWyH3TzWgVmFQNo/lvdM8sqU8C6q6MsTf4RbpN9ZF2UVkj5GC7Eyaw31yLfYTSvQWJJPaIUBGoVEFzrEuS3ejaulhJs2HDLXkJSpk8vdLQOwbOVnzEDS2OhhbqbpGQOoryRrtgSiAYpc5ckBdsm7QeqYrroAN4P8dU4rCJmi0XhyuAow0a+sAw3fdBA8hmJSL2ogTXFZdEgw7FqL3XU9r8UaPYAsPACK/yvq7wDE8zuGR8jCBUh8gDTKFYCDDoQ7ob+4b5MFsQ6ASpr7HCfVUfvfiyioDQ+g46ju4E3aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XO/weqKAmKC2sogCtXWVk1NVPOtDM6CB+7KbNm4DiGw=;
 b=OAqZcN4itxyFlueL8gS7zopBI4XY1FXbJMd/7gnKvp377zqBsmwo8eX06JsxhJ9e8n8SQSKqO9lyef3uGvycM44OkJV05SAFFLqDVZvcIETN72jjiu1hk7yAHUeRf/KbOZh1EWpX8LN+t8FCxoP72l9Mtdx5zV2zDwi2iKkMZ25f1wxgNStXp4HFDLXwL2fU7NO0YvzVSJV5vJzVDM0wnQYDzCcXehsW3HK+N7+HjI6WhQyokhF/lIz9reoea79qSUKm3ZS4tRN+3BO1w6TqGT46oZJoArlyZejbl+pqJVa50tzL8xHfeQeYcn6Gm+PvAHJoWbi+46l0QhFhMsxA6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO/weqKAmKC2sogCtXWVk1NVPOtDM6CB+7KbNm4DiGw=;
 b=NunsGhn3H62eBbxXz3W0INPY29LV/N67oGtMhURLNjvTrQvpkvXfV6/QMXYggSv5hvpWXyLkeDbfLNU2aFiOFg0KnEmaoJ9zyx0h9C4r/wlgJ1+Y6ao1RJzexaFgo3e49kbhjPEi0g+5UuiL1cuWFVCyfPy1mN8wu/v141M+7ok=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1142.namprd21.prod.outlook.com (2603:10b6:a03:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.9; Sat, 18 Sep
 2021 17:06:17 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e56b:9b01:9633:78c0]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e56b:9b01:9633:78c0%7]) with mapi id 15.20.4544.011; Sat, 18 Sep 2021
 17:06:16 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Len Baker <len.baker@gmx.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Kees Cook <keescook@chromium.org>
CC:     Colin Ian King <colin.king@canonical.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: RE: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Thread-Topic: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Thread-Index: AQHXrI/1VJuJVYedPEudSKeULZsdEKuqBYFA
Date:   Sat, 18 Sep 2021 17:06:16 +0000
Message-ID: <BYAPR21MB1270797B518555DF5DC87871BFDE9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20210911102818.3804-1-len.baker@gmx.com>
 <20210918132010.GA15999@titan>
In-Reply-To: <20210918132010.GA15999@titan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7f8b8111-1a02-4b74-b775-c4b2eac605e3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-18T17:05:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4abae2d-1ce2-42cf-2acb-08d97ac6a0b6
x-ms-traffictypediagnostic: BYAPR21MB1142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR21MB114246C70ED794714AFEB6CEBFDE9@BYAPR21MB1142.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VD/G3To4uTnw8rnJvDjYKA5A+WGouct77MFHuuEq3hu28oV850Nt8w9W6CM6PzzYbsZNeiI//i2Q6ZiMJz9im/nJyLTei+juLPEd6NaCVJqw3CTkZ2rnH0NyKvPgDxB+vvNGXvdcwK6GlnxWElg66Fo27fld977SOmCeeSSaPNModti3CPH0A7xYT+U6VCvd4KO1xofGmpHIEmzDesjoT20s3ck2aSA5M9OzpX2nJQ4jyibrp4ugcgdcVpe5BeqVUT9zNoXfIV0RCiDe58Clh4ARTfpVbApedQkVbGXtaC9f4WyUVzNqQ9FyMG2kNB1/b2nBiNyVOhLbjkMMCyQ/gRnQODdynqkha/cDq6mS/soAB4NFxCqZFwzR2mGvNZA6vyopxDfXmtamplz4BcWkcrv+/RqNvMCsCOVLzPojhipgAuFhDNvShmv2An5R1V4WEjlv1TnzD8FowIw79q9xjwbmhZEr/5h7UxbQOhBx1HDam0/Ntw304wkXRPfxSZNPll3yEwhu394JtVuRxB+C+U4vH/xiJy0JcAs30IDtEolF4jXBd4wabOXyP1FT6JcDHc2LUMbisXaD9qs5S1zBA48Di2eHoQYEQKSVbkc6JKDiLXxjbaFsG+zbTqnl3gh64kC20y9PdrGOGPpA4RFMd7IrOAlqtJLO0AELH7ExlG/xA0Icb8qGsrRNq9n7uLh81HYs8rl7a7xLPyaC8y47ex9EaCWOt3ryYxPnheo2pvJpW+MvFcW4Ee8D4Q/34tfiUWPnzAYfoD4zwyKKYEUx0GcYvdR2nanx4fFa5lPHpEGYWjoNBYCAr/iPawOXY9xG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(316002)(8936002)(9686003)(26005)(66446008)(55016002)(8990500004)(4326008)(8676002)(66946007)(7416002)(38070700005)(71200400001)(54906003)(7696005)(64756008)(66476007)(66556008)(6506007)(110136005)(2906002)(10290500003)(966005)(76116006)(52536014)(921005)(86362001)(508600001)(122000001)(186003)(82960400001)(33656002)(82950400001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fgKLOm0FDaNO33FytolhtJVqpkmk4aEDBn4BIZj0ikyjT49KcCLUBM9tKu?=
 =?iso-8859-1?Q?T63AA3SAHY3/qOxHXS4XyAhxFh+RyTp1vveVsOqcc04ECX/LtL4hVsLVjO?=
 =?iso-8859-1?Q?9jM0LWao8a0HnKdjNah3aY95M0FIpTxqxaRyCJ3bQeRaz4LOhalr9AdOkP?=
 =?iso-8859-1?Q?kujqVJityVh/BpACmuPbjWMk41mQO3GTifhfGXkIdEdD8FGVqTHiYJS4tw?=
 =?iso-8859-1?Q?kRp6LaINPT5HWTC9Deyb/i1LafMve7y54b13dh4suiBJcotq7cINHhUp1b?=
 =?iso-8859-1?Q?tRSsuOrWtcmK4b4JbjdUBHEntsqHwUgVeS426tbXe6UfHABe1kLJli9yqS?=
 =?iso-8859-1?Q?f3BVymziVYUkd7VMqdEIKSOvIN2QJnjigyqw2XEKp3vBAxwpSgwngqz4fL?=
 =?iso-8859-1?Q?/5tffWDjkeS85lMgjlX4yyFzp9eR0azhaVy480bVaXABQXyxeK1BP0CieE?=
 =?iso-8859-1?Q?hLF72SlGhhUmBFwqPFMYK+d4mAmiFuXkQ7fGPnOB46ApAECG1CAD/xJAuw?=
 =?iso-8859-1?Q?ikx6PF31ThYG5MgjcoH3lyMhHO5+f95GnsxXDDkiFcnVDzMbdSCehA2sVx?=
 =?iso-8859-1?Q?5om9ySHcuoKPmgTxslX3aoUyhdIrwuVZ6eCieoPUeKZD24JyuArOpO/Gdy?=
 =?iso-8859-1?Q?tzsCdIkndnBNE/X164KmSz7zUFySIzMdb/qF98KevIAvWq47lDTntZLeGG?=
 =?iso-8859-1?Q?wGyQsTSOZoEBnnyzIz3CInzgX4g2dL9LXoVHC0xeh0MKKfV3p9ZSmRVXCQ?=
 =?iso-8859-1?Q?T5n7riJLL0+NY1Zm1wBgPbP64VKJ1krjo+PESpYk8Lqm63pCj7sxMP2MG+?=
 =?iso-8859-1?Q?wKk0BHaTtTsOSAK+ylDiOA08m+M8xeEyufZCO+h92Ur8VNeKmmvjKovt2N?=
 =?iso-8859-1?Q?6tw5hQtWdsZaw1F/8k93yx2z3X001/GmUHiGN2Nq1o0lFXpDfbtAsS1UEv?=
 =?iso-8859-1?Q?YOmEAUyMDkOd4yWZThSzfrFGTCYf2Xk9PiCS+FpZPZgCKnX3NnKhEkI458?=
 =?iso-8859-1?Q?gCkOSnRuLBQKi/UPPfILvYR7emcqzzsRtE+PwcyxlWZfa2UbG0Y5Y+4f7P?=
 =?iso-8859-1?Q?GqVxMX6fMdQXdy9vpSUW1rGLKeTa4p3gVGq9ydS654qUptWpN4i4XN9tKN?=
 =?iso-8859-1?Q?d056yjmNiByK3mi+0rXwUn35xO4dIjx5gOXnvg35L/b87FPad4PUkvNt4A?=
 =?iso-8859-1?Q?lz0XlxQtNWmzq8CQP1KzYqarVLVDgXhOXE8KUtKJ1d+qXWU3y/vptB5Qba?=
 =?iso-8859-1?Q?6Z5jpn8hlLytkg0YCzxGs0tj/ktfduek2kfY6LKXbCGTCA9ipkUOx/Koor?=
 =?iso-8859-1?Q?GzwmbzJr3+yyaA9CdwEzG+KV849kto1cgbDs6OH3nAmoAOJgBfqPUc8KZP?=
 =?iso-8859-1?Q?ou4Xcg2e9M?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4abae2d-1ce2-42cf-2acb-08d97ac6a0b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2021 17:06:16.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EQl2uMC5qrAZ/iENv2zUWc8Q2LISpyYvPuUOIf6mxZA33uwkbVnlqdtqMqRNtFZq+Fjf91ktU29mYk1E8ndVmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Len Baker <len.baker@gmx.com>
> Sent: Saturday, September 18, 2021 6:20 AM
>  ...
> I have received a email from the linux-media subsystem telling that this
> patch is not applicable. The email is the following:
>=20
> Regards,
> Len

The patch is already in the net-next tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3Df11ee2ad25b22c2ee587045dd6999434375532f7
