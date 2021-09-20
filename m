Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356F0411665
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhITOKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:10:08 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:52672
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229667AbhITOKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 10:10:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PV0zL0dHqkL65dw6DLp/gMttvUdhHQyRqEmiOjW69GQh6BUZkdaCt6/QO8U32dzWYETPUjnhf6PH5hx9uOK3+EEfYqCAoQ39rkArnYgHL2F43t6j/GpzhF8YNLPsx/4Aw+cK66lY0cNPQJlzBYk1tDFXO/8XUXt88NUmoWUykXrYlP1U+Z3p4jjzJ/B0e6fAp2sIQA5a6uKHkSNFKrlD3LxnLQKRa/Uu1CPNWX+TSBdM913XuZQpc1ORBG8Kz4C+JoU0kWEdji+eOXUq4GareTiAp/26kzjusHcqR1YWaBGqRt2vLkOZ3DtgETGsUMrslhdsQ/zNoTIe3AqPMxaOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hdv5dNxEZFUB2AwYNzTVb09Fb1JrHqWwaq6/2mwsQsQ=;
 b=Ue5isJtVooQlA6hPaLkn/3DTXoOLbxwfy1axZ2GaudAsW8KNup8BHfnNWLWtaGyXlTZXRD/IPuxnv+eTJjsE+G/VyBWGbZza5zuXxkIj3RGL80zvIDh3G+CBdtuiBBUB5OV5cxAmwL9nukxjUKE0hzWTlznOV31k3WA1LsMm3izOw59pKwgfiupF7ahG4C7O0KqUyscxoraBkJ7kp008CUKEheyCSqW1pgA8BAkhhIPSgP8ZeQ8JwL9UEllO0r84ouauS9qKP+1PI/J8fdE8KoVNQ+OUyFWkjlQMXs2wkfuUbT58I2a7Tg+mp4iv6aWzhsxIASyUd6bnUKNheRdHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdv5dNxEZFUB2AwYNzTVb09Fb1JrHqWwaq6/2mwsQsQ=;
 b=j+KZGy+q5xSkZVtcrL5R7TPyd1bZhLYgRlaV/2P2GvOP4mudl2aFL/aX5ZiLQ41LXWbMD8xanFEa33Cbnee4saV4Dd49W7y1w2Rz3vtulc2w7fT3uB8PZxRAF/HOme46yZMiNG/v+bSKi4YzvVl1vfGjZuZUciKT1v8p6aZDMR0=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSYPR01MB5301.jpnprd01.prod.outlook.com (2603:1096:604:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 14:08:37 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 14:08:37 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Topic: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Index: AQHXq9Hw5KOUR0ss3UKvyfLSiPV3fKuoo+GAgAAE1HCAAA9tgIAENlNw
Date:   Mon, 20 Sep 2021 14:08:37 +0000
Message-ID: <OS3PR01MB65935EC20F350036340F3348BAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
        <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9037e0b2-6a69-46da-8478-08d97c402434
x-ms-traffictypediagnostic: OSYPR01MB5301:
x-microsoft-antispam-prvs: <OSYPR01MB530192EE2E07E170F07B73B3BAA09@OSYPR01MB5301.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7ttWuAgB+j4KmqOsrt3Isl+o4i9tlz0zKS2Iwbt4SqtHc/WByqoIHeXVnphKtfNZe1QlzOx0nVGPzY7Gn+LnmAq+eEwmu0OS/nS1WC+5E6MoVLVV4lszMWEQu5UjF99sLx88eddmf31Ibs7wVB3SGmfE5vWSAz6bOdyod3n/5yVHGQL7Y6oZrBWIbCoFA56WGq9GIl74lJIrCTmUWMit5isT3VAy09ZyEh9QYpTxR92DjLSGz37sWBO6tyy/EYXdETXJFutWFdGTLJRIGXSJvyJct/c024j6tIcw4l4zOMIqyvlEbkdgR0q3hAHjefSDNgqV3Kh1jOXlKKsAKLKfMaMZrLb6t3zzzamjUXJBGekaavc2/ojaDvElgyF/9loBMR9cuZ5rKckAZ39dkcHn49AAerRimbKHYsAkUBJ1qRNFRgOrGztTR1s3EWlS0Sz05XeHGRoLHqIxjtLtbdEpIZgcdlB2bq9jVO1l4E1UMaig2oYi69etjpHPlWQWMx19A2DRhKTZat/G+/dkWlg2BDfiXC3Un3tCmpn6PzKBM2fYOHdPFssiVCjJtYd4kWlXltzvg+P0kTRA9Tz7bZEclqACxwmfUxRYkFsS0g7vHMOnf4+8Y99AdN7bxFh0tGHX/JpnTlRbyKR1ewE6n8H8VBh7Q2+1S/sVgUoHZ5CuIx239Q/uljGgORLHe8DfYPPo5tndSdKXjiZFMyVESD6Hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(8676002)(64756008)(66556008)(8936002)(66476007)(66946007)(7696005)(54906003)(6916009)(33656002)(316002)(478600001)(76116006)(122000001)(66446008)(38070700005)(2906002)(26005)(52536014)(4326008)(6506007)(83380400001)(38100700002)(5660300002)(55016002)(86362001)(71200400001)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?38bxnzEhYNrpxt8cD2TPFxuNtbfPDURuDOEMP9p/g8W2IKG2WF+MGARpLgfH?=
 =?us-ascii?Q?jH9rZ0/eoIJQLZbK3R8j1ZU+R0rww+UIQpLcrA7TWhuhS6RIkRhk4+ozuMSt?=
 =?us-ascii?Q?6zKBHEcKOFAbZBDMps15m/IK2qCKnUT2d8YpHbIRCvGF+GZT8wi00hS50KZQ?=
 =?us-ascii?Q?iExOxdozzWamgNQp+RePJ1kV9wcHJXC8Gp9TshlGoyuQ/uVvXVG4m1izG4ZC?=
 =?us-ascii?Q?R8oY4pxb0SDTQphgEZnfa9lUtyMCX/7e77XvQYYUISAf0J9BiNhY8Nszv9Y7?=
 =?us-ascii?Q?SHrCFVYWl+HOMgaAJhzq0bSILP3ESvzY/jnd+B89fg3SKaH76L0/ypbOwisl?=
 =?us-ascii?Q?BdR4gcbVpB1Glt3672Ed97MD6aNs1tCuZPJ4CuhyWAjfVrSN4T8z/ti1qdY5?=
 =?us-ascii?Q?O1l9iGFnH3XHj3AW5Jr4ESh/AlZGo9JVItcg2AafBesiwhuwSAE3RrR/h5Kh?=
 =?us-ascii?Q?BIIls5rOMS72W6dLjyZw2HwLjh7OqrTIa7dTyxEuvY2xe5u2Uhz4/DeHMaWl?=
 =?us-ascii?Q?NK7hvvXVKskchjQsBSd5/TFEc9Ik72aNIhVUFDQuzCqBE6DRfFl6Qb3qWFE6?=
 =?us-ascii?Q?Tjiz+hx6YOGII+PFI54BMBaeiq2WoD1KydqZayjxC03PH6cVQIUXyRMzoKjX?=
 =?us-ascii?Q?0FtLknnhNwswONX8kq7HuyifKeZR+ScBeTXfyuCCttNMXt+7Jp0IM/cMlafY?=
 =?us-ascii?Q?ePhzoUA/akK2Ow8tfITq7gBYTNHslc19DRiq2DT4dEguxse5twPXY1REmIXA?=
 =?us-ascii?Q?Zn4H+pJm3NrZlekGTw/9sCsU7pYWtxOq2E8PA2C17WrTMSXQ74v94tCFVNbU?=
 =?us-ascii?Q?dJ0dhIIsVvkZPq5QUo7Zejg1IfNIwxrnmt5N04JXJe+cz/TJM92VmXcihnnP?=
 =?us-ascii?Q?poXWVeG7+KIEWKwFOBTFlj72ZgmLyTFTeFIMAkap3XDSN8J6npkXQ0syWv6o?=
 =?us-ascii?Q?CWNc/f+126Xd2M2JS6biTNusYEnX34GXemKIP0PJmUvULftZKMAhNk9Ci6Lc?=
 =?us-ascii?Q?MfZfG+ENMvJ0ZDXltZOE5aTPEa8G72n6MR67yBr/+H8PUgTguYj/4/RQs6p+?=
 =?us-ascii?Q?2m+SxlHqxYIb4tSMlugL1B+fEF5OPWlgt8tCV+BNpcf6GBDFSFRBumRWAdN6?=
 =?us-ascii?Q?jkskUqj4Y+Xa/g31rB43EHkdEvNeDF20nOJj0ke1cGQy+BEBZUW+TGap8vXc?=
 =?us-ascii?Q?eQesm8gPPgi7w8yQWqgSnP3vgua623C3gnR/2DoYgzOLBW7R4IUGm4AEZuRz?=
 =?us-ascii?Q?B55x9waSC2IoGiZ07Q4UT6Hb8uCGAaumyGSVRALxaGvCYL5nb+lPskqPmucf?=
 =?us-ascii?Q?tKYZqddD6SHXwbbwe3qaY/GC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9037e0b2-6a69-46da-8478-08d97c402434
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 14:08:37.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Z1Zsh+EsDT9sWnJmsLUa0wVDhsGLlJPmWo02mMrB59VrjMHYvOtCHh8wdykTJoZ17Jt21HXSlrxrpgvzI3Krw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   > On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
>   > > How would you suggest to implement the change that make the new
> driver behavior optional?
>   > I would say, module parameter or debugfs knob.
>=20
> Aright, in which case devlink or debugfs, please.
>=20
> > > What's the point of this? Just rename the file in the filesystem.
> >
> > We use this parameter to specify firmware so that module can be
> > autoloaded /etc/modprobe.d/modname.conf
>=20
> Sorry, I don't understand. The firmware is in /lib/firmware.
> Previously you used a card coded name (whatever FW_FILENAME is,
> "idt82p33xxx.bin"?). This patch adds the ability to change the firmware f=
ile
> name by a module param.
>=20
> Now let me repeat the question - what's the point of user changing the
> requested firmware name if they can simply rename the file?

We have different firmware named after different 1588 profiles. If we renam=
e firmware, it would make
every profile  look same and confusing. On the other hand, with this module=
 parameter, we can have phc
module auto start with correct firmware.

Thanks

Min
