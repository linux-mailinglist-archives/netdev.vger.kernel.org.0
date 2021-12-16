Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54AA47780A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhLPQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:17:35 -0500
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:57313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239316AbhLPQRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 11:17:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbYytdUw7/M8J1RCKCh3lgj0FYSVFhLh2entTrjhUMSVsu7vdPVVMBB4sFdMv0XZZE6IF2I86SDc8ritLlk05l0EU+0HaXCKiU6zllw098KWuq9GEHImYPOVqN6PYDjORVCh/rccvX8OYQME/bWm4KgpJEaNxTpiZMfRol07U6vX+9hnLzLf6QlZzK/qVzvM5N5ARyzMtspefIonyvsoYe+ETlXWnM4+N5FpqR0CA9xi09jBGyD5EkM2pyNUZnW73sXzFmFCmL2OBgfd/yLhiM8DGFR21E/DMH0Z/eGEftSnEe+y8GnqumXXWQiLAEjPU38hFIFuODN/hx35yqFuiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ly7arDAx3v4/kb2/GRn32DfZR0dhMKy34n2ul8CDggQ=;
 b=a7KOjfKAgtWsl0meK3A5KzlynYD23K9HdjRz47qplmDhp0wbQvwPQ4/XJ1qMaDnLSSX0fZCewxaiQtdWcxfTinD3Fad4pKC13lcwjLeBCodvVRzDo7s+24HkhO449phZ/3hsTVHlj0XzHSI2zWNL+gHWfJZ+AKTMGANhHQFrhoXvweBWFDlmYNNjzTy7Px6dwFYbM105ymCTQPsure16ngu0PTC/jLtSG5/bOIPl99BZ+ebhmBy/XXB4bV6FJpgHlh11JuN1aMsFzxdwqWASz462cJXHAiaWopa/rZZdswqzSHOC4ozfmyy2RWk4MtZfaHaxwrqMjjxZ4odz+oT/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly7arDAx3v4/kb2/GRn32DfZR0dhMKy34n2ul8CDggQ=;
 b=OeTavm/IzPYa55kcQubYimTFbYghjoU6W/dI2GuAx7HgxLa81N8YFciT5Cbzy+g7wfY3LoJiWE7nMG2pkGQOysqOdT5dFEBg7zhxWdTaXYItkx1++jzP6NhrOAsUqMF2zYznYMA+B2J3BBwwlk+Za5P/SEAZLekxIs8MaIvKgmbFfIl7mrUNEKDnlLY8kJ4Nj12/D0pbFm4xGHdO80iIsxIEFsMSvBxf2bLc8+3WehCqjzf7dykU5KJNdX0OeTEAJXWF+cYLoZ0gwuM4Wg4WR7DAdIde+/VHGPvlvv4H8KEZW1igQFOtvJd1XglYl5KPKtToBz7iK1AfKFg3JnY8Sg==
Received: from SN1PR12MB2574.namprd12.prod.outlook.com (2603:10b6:802:26::32)
 by SN6PR12MB2701.namprd12.prod.outlook.com (2603:10b6:805:6f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 16:17:29 +0000
Received: from SN1PR12MB2574.namprd12.prod.outlook.com
 ([fe80::d1a5:5fd8:7ea7:a2f1]) by SN1PR12MB2574.namprd12.prod.outlook.com
 ([fe80::d1a5:5fd8:7ea7:a2f1%4]) with mapi id 15.20.4778.019; Thu, 16 Dec 2021
 16:17:29 +0000
From:   Sunil Sudhakar Rani <sunrani@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dSCkqeEA8GEywETLk9s8QvqwQUeyAgAxeb9CAAFLZgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIDpQ
Date:   Thu, 16 Dec 2021 16:17:29 +0000
Message-ID: <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
 <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0351cfac-1cfc-471c-b547-08d9c0af8ea8
x-ms-traffictypediagnostic: SN6PR12MB2701:EE_
x-microsoft-antispam-prvs: <SN6PR12MB2701C342CE4FEA61068C44DAD4779@SN6PR12MB2701.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T1uT4F1GMF5r0A35z1Nhi28Wjf7tuZnbAgSOCzbQHPQSbJeJNhyu0j9IQ2LZYK19DDFRoLsHxQ7pOAtffKJS2H+zQjkzz20C0HffnnIChv+wz6w38I40sg4QUNuwurxIVm9E46j9b0KGw4vP1Qx/WjJZe7myr/MAg9LhohPIvYjuI8zuueOoK8M5Nv+cGPlEhtq4KoUglt6YU7jZaFOSPmiVEHPkhBTJJEtHK0vhzktJdj5PL1UEXA4jjcUU7ehd4mEiPBABmGqmFd3nB2cfsFfdstvj/jAG/a1QYQyIoIis+J/6gw+swzXHztAAmIsyQeLKNU5LgudHFe4tbyzDTQcXnozsr9TSMNehRRXw/0F8OcaRbeCcJEjB/OLMEJHcU3sWMwOA9LDkw1bmdUCSuAIL5UgiPmRsLmyW8hYxvj0txWgoRauTZK/icDV5Il906gdl4lfnpu9ZQC1e5l1yq9awLrB1trq21zBDCtjYbzN0IkzinFuI17QBQPIcJsso0uOfm5EcFelt1K2ynvPhCb9JayYOkqZwape8pBV3E+9wy0QwrQXV2sdqXT9QXWQLrWDMfhXKxq8QNbfLWrdAsShGXbkmfsif9hTn6cbFJvaYwNusDLkroD0X7eceHFylP7TXREvHZ2bUbV8xdNJXGcOVkeZ8JbG6n1TeZIfgXt5vRXJ/R/uQ4YtwKypjJXQCKg4ZGrPkyTu1lTUszviaDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2574.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(66446008)(64756008)(66556008)(66476007)(5660300002)(7696005)(508600001)(8936002)(55016003)(83380400001)(107886003)(86362001)(71200400001)(316002)(8676002)(38070700005)(76116006)(4001150100001)(186003)(66946007)(38100700002)(122000001)(52536014)(6506007)(33656002)(110136005)(54906003)(4326008)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O/ie54KX5FawVDmfn4W081cAvPF6hHYJb+GsS8VRPA/fN5Rgx4hnBBHbxxyU?=
 =?us-ascii?Q?k5IgFyd4MB2gGdIxQuOrPgZKAaWP97bceNB49OmbN7VWe3+erVVzHxhXlQPB?=
 =?us-ascii?Q?fP+Jw0I/5gzTUqRe2mRfpn4QtIgFWrY2Dku72QH590nMiYOqOFFMjrRPh+hV?=
 =?us-ascii?Q?xxZhxoHKIQm++KzgDN/ZKjSdqBKRGPyXwLNB/nTCqXiE46zto/tELkeULM4t?=
 =?us-ascii?Q?/rypKpVI8nGHF56YsDXRaZAh0nT9LIg7v2N5qV6zrG5tmo9ay7kQIloI+g/c?=
 =?us-ascii?Q?j1q2ZZdxm4iCTMoFFyEPDBCt8xXkwTx/2kDjLbm0Tbkm/FZT+aBCbd+4tMX5?=
 =?us-ascii?Q?XI8Gg3ck270Zm4uKbC5H0awj7QSHOZl20G8n00aBc8RW3vS8ll2Xceb0PWD6?=
 =?us-ascii?Q?iYPkyflrkvauIdkRjPObfE29SqPLypcGbcQ3USWWmdIG6kJZ2xMGUrKSeFJd?=
 =?us-ascii?Q?xNzzlaYRnHIYe1kdgS6uab7ZYLwPgunh6mB00k29/uAXd0chL8BN/009N+3l?=
 =?us-ascii?Q?TIryt04eUeOk283XTUVyU9/ToWVkZmpNQRZCmlYqnUzXjpNMVJ5+Y9roC4Ju?=
 =?us-ascii?Q?6IDtn/+nNQM8rMGCzGvszbYfAwlauDGUMzMKsUGKIsdo9caI65ejRxmO2nP5?=
 =?us-ascii?Q?xGfBTmY6xqrtP0BMOdbdhWAnZqB5SYWEt8UET751NoGEB1rzn4b9R2FvrnFJ?=
 =?us-ascii?Q?JjWX/wGSrg5XL0e7G6scv75uS6A4lKjFz90VQc3/FJOGPOuqLNnA/iBrKPkn?=
 =?us-ascii?Q?nUTLjVM5qMRwtxvQd4QS1oJbhLXSjD1vmNIGnnLuxmf5dCtdQu+ZlTNyW5/H?=
 =?us-ascii?Q?P8KIJyS4Vq8oQL+le091AD5odce3d/40mc7BW61G2+MHe819gUazWRBn1k7s?=
 =?us-ascii?Q?HeJa3gSkz7ZKCA28RFsHe2uvys5VdPcmeMoQ6FO8ClsJvWxRMA5wOxLBaCka?=
 =?us-ascii?Q?2jrjQBosVjCPuqP1Om7tHNbY/T3P7uLVrUOvgAOCkmZoYhW4vd90Eht2xNHR?=
 =?us-ascii?Q?sDaSNNVlUUaaH6QX/LWveATt3E+oNvYxKbTrzV9h778nq1/9+BGSkXapftfC?=
 =?us-ascii?Q?5yzQoN2XBPFTygWyRMVczY9Y6FDVL2EO66E89cPnkDi9io40RjQMqT96Ul/D?=
 =?us-ascii?Q?ydqdA2iEco/hzf8sSvHJKiBKylVRAHSved51hRl6HYGexXhQDHfVVixQmjyi?=
 =?us-ascii?Q?0MYfaFRr6PiP3dUFHluiDGXWKH6epOFknNgikKyU+NUfF5saWn7pqCiBjV34?=
 =?us-ascii?Q?XZXa4hFV5gGr0LH43VgwtVnk18GvcbekCzA0iz3iVDTnGtN5S1iNQz92e+VS?=
 =?us-ascii?Q?iITQmlBqVpSKYKDjWHw4zO9a4Al+VWXcsSzHfy3JTnw0FdL10jfVqeVJVOhA?=
 =?us-ascii?Q?p16OZmFqblFHTSe4XvmS3w9f6lEJH3n5wMNRP94CLqDd5adPJjIPiohOSQ+J?=
 =?us-ascii?Q?bd9K48q9+RBSwP+ah7IRUc+82DA0W4orLBosKwPXy/YiRGSEG7vsYWWg76Gb?=
 =?us-ascii?Q?GD1Pl7OYMVajlIbic4Ap82b7X9LNKCSFOiLzpWDrRu7KVnRmLe9wpQipU9WD?=
 =?us-ascii?Q?PR+mge7fmhBu8m6bv+VWGi+mbiOWRRwbQrigS8GUnB6N1MraecF+Y3s8WEpD?=
 =?us-ascii?Q?3C/0RYQTKryh0/2NIWWbnYQz5R0ILzZw8OO+I3HemRq6STPLinUSvfEVJ9os?=
 =?us-ascii?Q?Lc4xuw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2574.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0351cfac-1cfc-471c-b547-08d9c0af8ea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 16:17:29.2991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UkeVJ1aYmh7xSxTfmaw1LCiwB9IRaqIM6h8rzRwXmriFDTAiEec/OkcNOBEGwrh5lM9A8npLzWpJJtVidNnViQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 15 Dec 2021 22:15:10 +0000 Saeed Mahameed wrote:
> > On Wed, 2021-12-15 at 11:22 -0800, Jakub Kicinski wrote:
> > > On Wed, 15 Dec 2021 18:19:16 +0000 Saeed Mahameed wrote:
> > > > After some internal discussions, the plan is to not push new
> > > > interfaces, but to utilize the existing devlink params interface
> > > > for devlink port functions.
> > > >
> > > > We will suggest a more fine grained parameters to control a port
> > > > function (SF/VF) well-defined capabilities.
> > > >
> > > > devlink port function param set/get DEV/PORT_INDEX name
> PARAMETER
> > > > value VALUE cmode { runtime | driverinit | permanent }
> > > >
> > > > Jiri is already on-board. Jakub I hope you are ok with this, let
> > > > us know if you have any concerns before we start implementation.
> > >
> > > You can use mail pigeon to configure this, my questions were about
> > > the feature itself not the interface.
> >
> > We will have a parameter per feature we want to enable/disable instead
> > of a global "trust" knob.
>=20
> So you're just asking me if I'm okay with devlink params regardless if I'=
m okay
> with what they control? Not really, I prefer an API as created by this pa=
tches.
What shortcomings do you see in the finer granular approach we want to go t=
o enable/disable
On a per feature basis instead of global knob?
