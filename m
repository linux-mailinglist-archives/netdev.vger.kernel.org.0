Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC52C027F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgKWJsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:48:00 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:42310 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgKWJr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 04:47:59 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbb854e0000>; Mon, 23 Nov 2020 17:47:58 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 09:47:58 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 23 Nov 2020 09:47:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knZiuLnnq8LGwScv+qTNuCUsGkrfxuIM98PMx0S3dmC2tUYKC2BZhs5DfxjTtqWM34GnoTOb9OlzfflcndzfluLzBc8fmXBO366AsRDNstDvsMcqNgea/xZ0HE99sbFOOyNXTFmtp2xqdd6W4aRHnn7HdAgpgFrDgc6y5HEsOzeSqsY7oKcGV2uinc8hMfFq4VtQT9JGO6WtGoUjP/13vXb3wI40FWYRgq7189ZTmZh/uq323uP/TDkCqvJwyPZxlfdqFPzySUwUGh7gLzduYtY/Zl344ldFkPH2dPXn/MKBYGLn29LcQbIc3ce0Nfw1QOvSLTKg1EIkjUpV+PogJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pRJ0qW2EoHurDiUTsERqc5qVAfYQkMZAWP5RSS+7og=;
 b=cI9NrOhezJZPVcVs8SM9fnU19IN2/fRzCz47bP6fQnJXKBnox/mvuXaq0PPLUc4BoxqJnBRDZLVkwlN5PZ5iyOA6g404JphhpZIHq3oDSShfQ8cLXq78jQKxg7Z6xsWtdgHKJj4h9Y9GaElkPO94TScgwSS92d+jB4/kkDu/i0eK+65sBjEXxLo03MP9+IYXFlwWQgiria96yA2Yzpm19EK3wr0lSu0Mfs2FjMp+cQJNhdbOFiaQnRReFt+nxo1YeSYv4o5FVE/h7/z5qk8KDhY6PZ0piPHmKu++EGQ0QfK+BfJAHZwTjYeb5tOnD2wwp6kxj3ltRF90TWD/M9c1hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3579.namprd12.prod.outlook.com (2603:10b6:5:11f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 23 Nov
 2020 09:47:53 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017%5]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 09:47:53 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7AgAGKzwCAAAKJEIAAGTCAgAFm0UCAAKwSAIAx19sw
Date:   Mon, 23 Nov 2020 09:47:53 +0000
Message-ID: <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
In-Reply-To: <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.144.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a780fc55-aeaf-4ef5-7974-08d88f94d95a
x-ms-traffictypediagnostic: DM6PR12MB3579:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3579B673E429DA20EE6A2D67D8FC0@DM6PR12MB3579.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Ih25HLbneBKSjRuZebSre+x4LJSHrTTB/dgOx655S2wyds/wq3ZpXJwElVLWGj0XvAhT3Gb3x1071XVqkJkbBQipMcbJuW5PG3WH7MRW2HYuB/eNzR74cZ2XEoJRiWEwR3FtVxxNjIFvn7Ub0EcAWbMDtPo6kpW42bOUI7Xy+kAkUyn8mcPDbrBDR+D9bacBWfTLbs2/qQV77BE41gSAy7gHKM3HpXWJvD/m4EKwHVWw1dpu762u8Dgp4R+eS1DUECJTk7i8TwqR4M1h8WuYrZaCZywDk+h0DzslPbJHslbdsDgn422EGhlOZIZE9jqh6xRqHWebKNdSujVXjkYZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(316002)(54906003)(26005)(478600001)(55016002)(9686003)(5660300002)(2906002)(76116006)(52536014)(66446008)(66946007)(66556008)(64756008)(66476007)(8936002)(71200400001)(6916009)(83380400001)(33656002)(7696005)(8676002)(4326008)(53546011)(6506007)(186003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qce18u/CjFUuBWOPob9OqmZsdj4vLy0qc1IK6VRD/+DoFRx56dTQaoaA4M9Ci1PhQSXNSPiDDL+4W2x9OTH88d4s0+FWzEfy1nkMKsMKkHbPpC8Xo7EvsXal3Xt1l5zT5+aTHzM5OU4+8lThR3xNci0cpzMlvqL/ufzM1z8P+qXca5++j4bu63EQSWV9p0NaX/uZvZyh+p8q4Q896c2H90qeGbz8BRbbaj4gq+A9L6fQL9o7CJRcAsrNLcAfjnwZBFqb9e/b7WJDiJFwVC9FvSYGf57scWSfm2gkMDq2OEQWxOGjcMTTyAza89gJsxIKBLyp/KP2vljZf7YqhOIp9nsI0uekz69aZNbIRQvKKsVEJzJnvjSA8TooEAlROCILR8b8oFuOgjtamn+POSmZta/OP+AT6TvGuXD5ppke5T0cJoV2IaEyKLiGirEMRL+eIAcBNZogqjr5DSHSWs9VNENfczb4b++DOz2wGwyqYl5oIAAc47zPxLXgKh8CYhqLf33mYNEieLxHdxOx9c3kBMfSSVZ1icgUk7fLxRy/Cd86woUkknd52FRGvoUR1+YW7i7RSorrbmVmx40NMrUcBswPGoC5t/nY3pNeTqizq1iGi7zlG0TSAh9kfr+d4BbgrfvW+zkclaaenXaPu+ccaA5XLMsDWvdbJw4+au6+Ry9qO0P6uETHXC9rwyXWzeizko2AOnV/9iJGBVIpUwwUMSd/lYetSpLkoPm8mnvi0zccFdxFlvSnSMq0CoZKBRLsUUL1c3oyzdLC2ZwHFYNPpLhV/QHcfXwoKV0PmDGUD1w8bTDlWOAPs2gm2MqSzzGDMlaKm0k1i4rQ6WACsjsicl8RfueEl1e3NBU6+zMCOaT7SotXB2ed8YqOxtt/HHZjvlkShGj97lvXeDQSVe57Vg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a780fc55-aeaf-4ef5-7974-08d88f94d95a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 09:47:53.6098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IPzvTJCdHe7DSgekRXXjcg4BW2U1s7GynglQnnwhLTCV985kZK1nG2hhk6qIkZ4UHdPzdpCjARiKR3IE0o0Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3579
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606124878; bh=7pRJ0qW2EoHurDiUTsERqc5qVAfYQkMZAWP5RSS+7og=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=P3/z3goSnO1e3IYXQAYFmdLiWqa5EB/ZLBW9zPH/tzBqfvywIXPGzh9/6NMPSvriL
         qZkRw2k4v6uqvvqasYjSxjw5Jc22pi1AMbnnVXaD350SPPi93kX2J+MbDcJxgR30Rr
         OOl7VsKawVastGFAVKDyG1ix4+Ty0XkzutxFpZd48CKUNDc5U78empQPWqc2CXzMyr
         PVIwnu9UmLsh4pL6zrDvO38o7+Xvmz4R35MyQuxhEtpCt2MZu4w5l73V12WBvLIH0f
         jCqq38ESZl+QUQtrvmZFFi3dRVPZ2IyqWPjo50hmKuPEBeicrICsY0l+qNmAFWzcYd
         latviBAQAe1Yw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, October 22, 2020 7:28 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Andrew Lunn <andrew@lunn.ch>; Jakub Ki=
cinski <kuba@kernel.org>; Ido Schimmel
> <idosch@idosch.org>; netdev@vger.kernel.org; davem@davemloft.net; Jiri Pi=
rko <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw
> <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>; johannes@sipsolutio=
ns.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I with lanes
>=20
> On Thu, Oct 22, 2020 at 06:15:48AM +0000, Danielle Ratson wrote:
> > > -----Original Message-----
> > > From: Michal Kubecek <mkubecek@suse.cz>
> > > Sent: Wednesday, October 21, 2020 11:48 AM
> > >
> > > Ah, right, it does. But as you extend struct ethtool_link_ksettings
> > > and drivers will need to be updated to provide this information,
> > > wouldn't it be more useful to let the driver provide link mode in
> > > use instead (and derive number of lanes from it)?
> >
> > This is the way it is done with the speed parameter, so I have aligned
> > it to it. Why the lanes should be done differently comparing to the
> > speed?
>=20
> Speed and duplex have worked this way since ages and the interface was pr=
obably introduced back in times when combination of
> speed and duplex was sufficient to identify the link mode. This is no lon=
ger the case and even adding number of lanes wouldn't make
> the combination unique. So if we are going to extend the interface now an=
d update drivers to provide extra information, I believe it
> would be more useful to provide full information.
>=20
> Michal

Hi Michal,

What do you think of passing the link modes you have suggested as a bitmask=
, similar to "supported", that contains only one positive bit?
Something like that:

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index afae2beacbc3..dd946c88daa3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -127,6 +127,7 @@ struct ethtool_link_ksettings {
                __ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
                __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
                __ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
+               __ETHTOOL_DECLARE_LINK_MODE_MASK(chosen);
        } link_modes;
        u32     lanes;
 };

Do you have perhaps a better suggestion?

And the speed and duplex parameters should be removed from being passed lik=
e as well, right?

Thanks,
Danielle
