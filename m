Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0180C2C3DC1
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgKYKfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:35:41 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:60976 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgKYKfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 05:35:41 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe337a0000>; Wed, 25 Nov 2020 18:35:38 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 10:35:38 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 10:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIrFELAI/pK0rX4pe6ZgMFOjpi04NvMuQdHlxvQKjdhDzBuj9Z890aALBkk2Nm8ChNHM4xRxq1fFSd2D99jgJDz7JxVsaEvJGKDcvLz/jHyPc2O4lcntnxej5MPAp7pFZhr4EDSo7q3luanTwt7lzPmHK8J+x1NSOsV7AJcCFyp+4w+lWTam0LnZ2eEz8h6HQ4Zka8Rp5siO3XvM6Ii7p6bZbNbAyLW7j1LS81zyCh7AmSE9fo7pKXFBHjERytnkkjouZO3zC0tPbo7xTKd0BTSOR7wKDCDf7uB6Qe140F2Dhewy01PALzq8v1mgr5QYTLfYmakxNi5N3+zr0bfXVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMOEu6X2tvX+tDlYnR8VJ2UEuWxWXVEKCSW0FmDGcV4=;
 b=Tl1ds1NrfnBk46XxH9tyw9Vm27V+kMeMzpN+7vw+gTTqV7OCeZ5wD1fvSkHjgvd8AomR02VbumnWvsWafBeJnTuUTuGcJU5ksQ3eIyzPBcQ+Xa3wRHBQ2wMMTPaJjzS1Eva7AUjI5mQw77Zco2libDwX+TYy9gVDjNZN5lHieBspjg90j5CunyikgFeakL2eH8N0ZK2fXEoQHs01g7U8OCxFl6AsncK+QgHxSl3Ur3pGb9eezlP93UoR25xqjx0OMtjV37zUvDG6PEMR2WJGZLGOhwZ7wsMIOFtirYDYVnQzrFbQtn7abvsMKAuimxSnzBloBW601oL8/vOdnBGx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3180.namprd12.prod.outlook.com (2603:10b6:5:182::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Wed, 25 Nov
 2020 10:35:35 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017%5]) with mapi id 15.20.3589.022; Wed, 25 Nov 2020
 10:35:35 +0000
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
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7AgAGKzwCAAAKJEIAAGTCAgAFm0UCAAKwSAIAx19swgAJlZ4CAAMul4A==
Date:   Wed, 25 Nov 2020 10:35:35 +0000
Message-ID: <DM6PR12MB4516B65021D4107188447282D8FA0@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
 <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20201124221225.6ae444gcl7npoazh@lion.mk-sys.cz>
In-Reply-To: <20201124221225.6ae444gcl7npoazh@lion.mk-sys.cz>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.144.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efe9b75f-3527-45b8-d65d-08d8912dd827
x-ms-traffictypediagnostic: DM6PR12MB3180:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB31806674613F276EF6F59D19D8FA0@DM6PR12MB3180.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aXtJJENaNl6iZjg96wvcPQpjQftA/xHpqpbF/RzEm5u7j2ydDa/YUefoS6ZOsSaflq9UCSkJstlGA51Pc7BXvAX0Tv76pG++llvMz43zd6ZU96NJh9fVktDDuGzLflil1rdMBoO9enfsp9x17GUlti3ZZXZgQnuJmsLV4UKkvQVqAk3cDC0pvfP2UjWfuHJXgs6SuzoHOQQ/6EyzWkspbvCEUjAnM4FkAOrIgGVqjCw/ZEA8eqruihhlpME2DwJ9hAOIcYjY04ksYz2E5pQItHklGO2jX74ZK1eY5Bfky7A64bLNSjYoA/pVq+Kkqsh67dcDFrvlExv2MFX5H400jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(346002)(366004)(376002)(9686003)(316002)(4326008)(33656002)(19627235002)(26005)(53546011)(76116006)(66476007)(186003)(66946007)(7696005)(478600001)(66556008)(8936002)(64756008)(54906003)(66446008)(6506007)(55016002)(6916009)(52536014)(86362001)(83380400001)(5660300002)(8676002)(71200400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?josJgQheITQWxgvKtA0UKTJm9kZJkfbWlztU6CDg4rPWC9V31MOr0y+GtWBy?=
 =?us-ascii?Q?sOWENwHMqYLr6/UlLGIWx2ltwGGOyzn9vTexBxmM7TfKVDL1TJxwJ3GYjm2x?=
 =?us-ascii?Q?c05KqzYoSSIDcslOO+6RCp+EDBWVtaBL1DlYz9VC7KDH0idyJfYxjWyp9PAe?=
 =?us-ascii?Q?YVkDFWQKfnxj/yRHiRer2Yf/iRFGjFcUXYhmanxSEVAOPY4muWEhXff6CY1V?=
 =?us-ascii?Q?en6m517g1z2iWKRCDbiyFQeO7zmI4De8qLWB86k5pbVWqvGngjxBoIazecST?=
 =?us-ascii?Q?a17tNk8c4TT9pKtPMTb7p6oQlMEYbdkUsJztnx2q6PTKWQMU1tg3+bn4eGt6?=
 =?us-ascii?Q?few0qWyxLk4aPyX7IygKPtuamyGxD+XXhWESXCx+izfhGoah722/Ptu6/BNF?=
 =?us-ascii?Q?wjfNpov8xuTjZ5V9oIamogrRKYB+u9RbxWCNxCX+LQ0Jcq+vhu8t+KI8B+To?=
 =?us-ascii?Q?Z5n/4582PnfNu6tLmTzBUlYG2FM60e2yM5CSblwxiYfaLYJmEuvwF27tI9ye?=
 =?us-ascii?Q?/k8u7S59dL+G44AUjf3/9SK8x3UPaZxMCJn2qZ3szv9nL5zaN8Vlaj+TMVKq?=
 =?us-ascii?Q?HzxeQx8ZnIs+Ap0dW5Qqiw5JUNp3ScKijotXqQLJNV6rcNcg0O1wL6SddmPb?=
 =?us-ascii?Q?C1w7Vfi3FSDBJfnVKua3h1K0zb0jBORD/NLx4XVmyYMj80gQPdLhkXOnl6PX?=
 =?us-ascii?Q?F83G9Fq5WeXC4ZEuEDaaNNcpgoO25RnC76G6a+81ND/HntOs6fZ97/I8Wnqx?=
 =?us-ascii?Q?COTWyG5wN68nTlfTa0BCmsYsdrGTJ87/ZNoyILT8pj7iDvfi1ypoWRU08quW?=
 =?us-ascii?Q?1AFsI+gIbG/HcKrcf8E9MBRtVhUpN3/eWMxfmfNluvRtBhRdg7nd1HfFcGYN?=
 =?us-ascii?Q?ulRRKYhpYkJR847kBr3zsZN5rBlffxnA+8Vkuhog5s3r2N60UmsM7Nhkk9xP?=
 =?us-ascii?Q?SCRRULU9yvo/jdZRwZYk5XTwk4H+RRwf2V62P5+QupU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efe9b75f-3527-45b8-d65d-08d8912dd827
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 10:35:35.7327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nn+6yG3jCX2+p8vAj4dF69CSH+ovcU+Au2P5C6jmD3J6MhifviQVRc3EdvzwsdnIbJX/GngS8wlmF7p0OteOpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3180
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606300538; bh=gMOEu6X2tvX+tDlYnR8VJ2UEuWxWXVEKCSW0FmDGcV4=;
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
        b=oeaKAUf3ictc+nWPJvzGwACRW0GuJWJ8u4AecgTzA+Of5M9dCtxY9aSPO41l53Zny
         3UOiO5Yv08m/DDhhCpSAlHQpB4nEC9p5WN1i5R/cCsttlsSyrtfit4k2vK5gudLgKW
         cbw2d9ApIcjzpLFBSUuE9yYtr5vnpdJlXxiihCZ0B45Fzx6e9q6Mq4UZft8Z5d5G/v
         z0MdTuFrI+2ioYrwQi5Fq2Kq+rYguwh0H7PrxpE3TQJ8jPr7ZZRyjxcyX6+l0Z3dBv
         ByxK9ILfXy7OG3rIAG4qBjX+QawodWy1VtpWBWYM/x1TxL43m5xNpTCMabzn4FPzic
         ld9m4ap3mgeug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Wednesday, November 25, 2020 12:12 AM
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
> On Mon, Nov 23, 2020 at 09:47:53AM +0000, Danielle Ratson wrote:
> >
> >
> > > -----Original Message-----
> > > From: Michal Kubecek <mkubecek@suse.cz>
> > > Sent: Thursday, October 22, 2020 7:28 PM
> > > To: Danielle Ratson <danieller@nvidia.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>; Andrew Lunn <andrew@lunn.ch>;
> > > Jakub Kicinski <kuba@kernel.org>; Ido Schimmel <idosch@idosch.org>;
> > > netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> > > <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw <mlxsw@nvidia.com>;
> > > Ido Schimmel <idosch@nvidia.com>; johannes@sipsolutions.net
> > > Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes
> > > settings uAPI with lanes
> > >
> > > On Thu, Oct 22, 2020 at 06:15:48AM +0000, Danielle Ratson wrote:
> > > > > -----Original Message-----
> > > > > From: Michal Kubecek <mkubecek@suse.cz>
> > > > > Sent: Wednesday, October 21, 2020 11:48 AM
> > > > >
> > > > > Ah, right, it does. But as you extend struct
> > > > > ethtool_link_ksettings and drivers will need to be updated to
> > > > > provide this information, wouldn't it be more useful to let the
> > > > > driver provide link mode in use instead (and derive number of lan=
es from it)?
> > > >
> > > > This is the way it is done with the speed parameter, so I have
> > > > aligned it to it. Why the lanes should be done differently
> > > > comparing to the speed?
> > >
> > > Speed and duplex have worked this way since ages and the interface
> > > was probably introduced back in times when combination of speed and
> > > duplex was sufficient to identify the link mode. This is no longer
> > > the case and even adding number of lanes wouldn't make the combinatio=
n unique. So if we are going to extend the interface now
> and update drivers to provide extra information, I believe it would be mo=
re useful to provide full information.
> > >
> > > Michal
> >
> > Hi Michal,
> >
> > What do you think of passing the link modes you have suggested as a
> > bitmask, similar to "supported", that contains only one positive bit?
> > Something like that:

Hi Michal,

Thanks for your response.

Actually what I said is not very accurate.=20
In ethtool, for speed 100G and 4 lanes for example, there are few link mode=
s that fits:
ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT
ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT
ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT

The difference is the media. And in the driver we shrink into one bit.
But maybe that makes passing a bitmask more sense, or am I missing somethin=
g?

> >
> > diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h index
> > afae2beacbc3..dd946c88daa3 100644
> > --- a/include/linux/ethtool.h
> > +++ b/include/linux/ethtool.h
> > @@ -127,6 +127,7 @@ struct ethtool_link_ksettings {
> >                 __ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
> >                 __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
> >                 __ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
> > +               __ETHTOOL_DECLARE_LINK_MODE_MASK(chosen);
> >         } link_modes;
> >         u32     lanes;
> >  };
> >
> > Do you have perhaps a better suggestion?
>=20
> Not sure if it's better but as we know there is only one mode, we could s=
imply pass the index. We would still need to reserve a special
> value for none/unknown but getting an index would make lookup easier.
>=20
> > And the speed and duplex parameters should be removed from being
> > passed like as well, right?
>=20
> We cannot remove them from struct ethtool_link_settings and the ioctl and=
 netlink messages as those are part of UAPI and we have
> to preserve backward compatibility. But drivers which provide link mode w=
ould not need to fill speed and duplex in their -
> >get_link_ksettings() as the common code could do that for them.

Yes of course I didn't mean to remove the parameters from the struct, just =
to not prepare them for passing to ethtool when getting the link settings.

Thanks.

>=20
> Michal
