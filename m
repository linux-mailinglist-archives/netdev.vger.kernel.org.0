Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8422D438034
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 00:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhJVW31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 18:29:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233793AbhJVW31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 18:29:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MKamcg002968;
        Fri, 22 Oct 2021 15:27:03 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3buu21ajtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 15:27:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbSedIuOcbpPvj46xNn4Vi2qQDkC3NZ9ColGzT2QU/e6/fmBNq33LWT7UrOo1p2EtD/y8mDk61+iKKXDyzyHTvJbZ89iljBE5lLc2Pxg5I/i4XONRlywOOOgm8Mt/vII4UgqjdZJpgbKRoIZEVLoKHoai3RI42CGwzT7Bb5snuKj01aDewDASL/MkPYfOVkiIzftLZ4x7hy4jgvUh1U/UKbR4QQZ7ED0mZxVB8SrUVXbDOFw8085WV8SomKVGL1gFs1kfgViDXoGBfnsnUa61C+G5AwJWflwkbFFoxhyp68XxpQu8eTsvbuH94WtnZtUrFCFO+yEC29j83aidaYYBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xn+rGfsJQIdv4a23u86LawGVhJvs+R2bN+JW4Ne9lyQ=;
 b=AHuxH0ibbS5YcXx8H+HdL+Ow4hO5qSAVXrIyYVM+Nmv2e1JvtOEymMXXT3K8Y6zb4vO0pntSKhJPokoWkSwk1KfpwATDTcRYCDBqoWRvSskpwRTTceLyiF1/c/DwNV0MeTwyzhlib/pfIfGO92S+verI6e9WubOVfkA5DlIYkkAqlSi1c7oZqBUAEMK2Sj5/TNR3bWRzZkEIQpuuOtw4T91EpsON3iXIYfZLJR26g/BG+OKFWc8Dl+J7EPA54ny0RGqzzALEoy41fj9F6aPdvZeyiLlD9e36gp2rx4sXhFcGsQw5AwgM2opUqaPJ8i/rzpV+vJjFC/hP4X7uMz0ovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn+rGfsJQIdv4a23u86LawGVhJvs+R2bN+JW4Ne9lyQ=;
 b=KpPmu3LjDMbMjxZ1Dc/Eps0SnQcQ48DLQB4bXDSRULkNX+bjesS/C1BjzcmHF9KdiYGRJxGbjmDmnmg7Z4A7gXCLgq6dO7STacK2JwRDLSdy4Mwh9HhOm04wgUUleH2fQe9+yOJllKYDq+nMcAougsZlwbLjDmicU4AkD1LK3M8=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by SJ0PR18MB3913.namprd18.prod.outlook.com (2603:10b6:a03:2ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 22:27:01 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%8]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 22:27:01 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXx5PuZAeJN1SxmU6bEwmj7rv/2Q==
Date:   Fri, 22 Oct 2021 22:27:01 +0000
Message-ID: <SJ0PR18MB400940A0C69DEC9836A4F610B2809@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YXKuOSDraUsaN75U@lunn.ch>
In-Reply-To: <YXKuOSDraUsaN75U@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 8ad3394b-64fe-c39f-3dfa-a0f679a10de7
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eaa06b4-003d-4191-74da-08d995ab1184
x-ms-traffictypediagnostic: SJ0PR18MB3913:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR18MB3913E212CB0D6AAC255DD8B5B2809@SJ0PR18MB3913.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UaKTcP/TmcBF0UCRvEg4h+6PnQh5OwvICwcaYe5O3LpnkUvakTjFuQdzIDCB96ZUraWauomtZh1NgSBmlcam+mvIcsRffYSyVYvwuy+WujhnQya8as6SbmRBPG5jwMmYPWoT1bZMC+o+eHjrw4qc1WF+XxgpD5JbI5JtMXp+fNEJQwtkM5TeIP0wE8WpJ0i7A79/p/lW5OpRg2CS9fggziz64lwVudYaoxhuSXeDDdYJMSMFy5Y8t8DX7JT3Jk0OHXU01sTUzVfL9HK8kTYpEEu4bECc4SE1A+Eyta6NRDwm3nePpOQfvHmgpA7PylRDvR3FLoUc0z6sJ8AeTz03hK/ZcNbNpKsViLIKEjgAakTVItIVB4udIjhneM7FFR+9JwDFPNP+vyaFq8zfiVNnwk47W8lN8T+HspvYn0bcAjMMx7Qg43PqqpTI0dIGWP4eFLF2CJDb77Ot0ywgu45kwur1jGOEFOYN9F8GOD9AYXvZoA/XmeWQgUX2P09pVf9EZ4gHK3zNr5jjPcdSuIyJCAFoJFU7+MPpXUhw0iW7t2eiBzE5htgePJzL3/Q5chJmcpwvD8/Po0XNxI9yn3ZrG+UMKfQUhBzMRK6G79OMx7V5HzyCnlcVto50AscIUsbLrOD0VmkNev5L2dbX/RbpUyFplwAkeHpvOt2llGUIBXbbVeJh+JgyWiDel6dP3QzPtQlBKINkURPJcQM/IpCgCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66446008)(6916009)(8936002)(2906002)(508600001)(76116006)(316002)(33656002)(38100700002)(64756008)(66476007)(38070700005)(66946007)(54906003)(6506007)(8676002)(71200400001)(66556008)(26005)(5660300002)(122000001)(9686003)(55236004)(7696005)(86362001)(52536014)(4326008)(55016002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uQlD6cLcYsn7BTgVgQ5nKgM03lMQIXoorVdn3nESQwLU4kc8qZjOR0gHrQ?=
 =?iso-8859-1?Q?o3DnipXgKWIydolw4+hSCspaOP1Q2oJn+sVNh+MOTEni+7ep/MD6WsAkfT?=
 =?iso-8859-1?Q?lKAc5wPniPN5t1+tsPo6fMyKirJ4pEu7E+as2qovi59iuhVCGWH6gmPZJq?=
 =?iso-8859-1?Q?1MsGog6I7nOXI5qAIZbvUmXAbNNiWFTv68REURGJu/txdI66OnemetMio2?=
 =?iso-8859-1?Q?vVPRI7ls75aqa2mFn1zlHyqI846IKoqTYumxkis9DQ6ysN8Sn92WpWT3D8?=
 =?iso-8859-1?Q?jpGwUzG6htveq/S6ypRJmRAi13qtjG4BDsmwX8iDgepac5f5xwneVIZ1/X?=
 =?iso-8859-1?Q?eiMiXIG+MEfDVyteewoVy4DjIRtWY4TrcpfFa01OzEKg9D7g6fhI8Qp4Py?=
 =?iso-8859-1?Q?zjqRog8ioNdCJMcNVjAtBGnyTO5n2avXzaEd+0K+luYAKSg7uexN2AoflM?=
 =?iso-8859-1?Q?7kpS5MpLydQTd/RnBXmBjX46qKKkpTkIctOMe24yk6BYulosyxoA6YCAnv?=
 =?iso-8859-1?Q?zPXMWa4QjCzN4qPp/uhmVtbwEd++8Ek6VhVW+JNIfBw2w8/QwoTER9cjh9?=
 =?iso-8859-1?Q?2mk62WpoLgMJOMhdRFcIiZUgxn8oP2lfqh+3KpVsl4p52vg3N95PfbiIn7?=
 =?iso-8859-1?Q?B6BN2QGgH4OT/0RkLgIET8x4g8E1snpAVxQE7yqUbhEtgPUX71GCL1ny3W?=
 =?iso-8859-1?Q?EoI5rAlUSzPI+Cpsn2br4EaWcnLPDztyPmBG1mEIPEvIVuFm9LqqHf+0Oy?=
 =?iso-8859-1?Q?tblFaUQ5uDVF2B+H7TBQyrYVjpxvzQyP8+I9svjt14EXyYdu9dlcKwo0dk?=
 =?iso-8859-1?Q?McLAgxd3K93dL57M96I7ysTxz1X6NKGD9EMf42MwsK8p8ujufZbortDFFu?=
 =?iso-8859-1?Q?3y32a8QEHQCzmzk/V092xzDf4d60yXwA0ZHs4HlbScAkNHTBSTm9qN11Gw?=
 =?iso-8859-1?Q?WhmHikNTMC64XtQwFIPkrjHU8mkeuaS65j7cFPZKXjeuuYLfToUhoLKryc?=
 =?iso-8859-1?Q?qvGdBzMpVf1m6ABUsJAuZ6BwQxjO7T/MLS83zFLqoCuJM7asfStIiRZ91S?=
 =?iso-8859-1?Q?f9pj0QZCN/FF0LY5YnP7zV6HBY1XxAh/zvGuS4VrrUfAeE5M3fRtHFb6v2?=
 =?iso-8859-1?Q?ni2CLhM1MrczBZ532soKLPPuu5HzGQ5JWA8xOQad7W+KlQjZezjy9KaXJu?=
 =?iso-8859-1?Q?fCnhWcITbbeD+pfhJMkOBY7V0BHNUqe0dlocTL/W2dbgVhz9qhpoHIpTIa?=
 =?iso-8859-1?Q?vrZ3bF1jDdXuxYZyJiZl/r412gmqe69d8ga+E4n+6Kv8E8yacT7osc+Yc+?=
 =?iso-8859-1?Q?97+3E9XJBVD33kCTwiFnoCljcnU89ikpe23mnoOC5xtCOLIe44YQlIFxqH?=
 =?iso-8859-1?Q?XdCPGYgdeyPrRcfdqUPB3uLfqtr+WeLvQeo9HOba7n+mL2gdse8dZ9I4Uw?=
 =?iso-8859-1?Q?c0a/UU+xk0bOGN3kLWukLUHszlB+6LAGHE390YP+DRqTLhQDkODMTzoW2M?=
 =?iso-8859-1?Q?Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eaa06b4-003d-4191-74da-08d995ab1184
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 22:27:01.2846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmytnyk@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3913
X-Proofpoint-GUID: bv2slD64Jq5N3bmgnUutma6D8Cy1cXRv
X-Proofpoint-ORIG-GUID: bv2slD64Jq5N3bmgnUutma6D8Cy1cXRv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Oct 20, 2021 at 12:32:28PM +0300, Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > Add firmware (FW) version 4.0 support for Marvell Prestera=0A=
> > driver.=0A=
> > =0A=
> > Major changes have been made to new v4.0 FW ABI to add support=0A=
> > of new features, introduce the stability of the FW ABI and ensure=0A=
> > better forward compatibility for the future driver vesrions.=0A=
> > =0A=
> > Current v4.0 FW feature set support does not expect any changes=0A=
> > to ABI, as it was defined and tested through long period of time.=0A=
> > The ABI may be extended in case of new features, but it will not=0A=
> > break the backward compatibility.=0A=
> > =0A=
> > ABI major changes done in v4.0:=0A=
> > - L1 ABI, where MAC and PHY API configuration are split.=0A=
> > - ACL has been split to low-level TCAM and Counters ABI=0A=
> >=A0=A0 to provide more HW ACL capabilities for future driver=0A=
> >=A0=A0 versions.=0A=
> > =0A=
> > To support backward support, the addition compatibility layer is=0A=
> > required in the driver which will have two different codebase under=0A=
> > "if FW-VER elif FW-VER else" conditions that will be removed=0A=
> > in the future anyway, So, the idea was to break backward support=0A=
> > and focus on more stable FW instead of supporting old version=0A=
> > with very minimal and limited set of features/capabilities.=0A=
> =A0=0A=
> > +/* TODO: add another parameters here: modes, etc... */=0A=
> > +struct prestera_port_phy_config {=0A=
> > +=A0=A0=A0=A0 bool admin;=0A=
> > +=A0=A0=A0=A0 u32 mode;=0A=
> > +=A0=A0=A0=A0 u8 mdix;=0A=
> > +};=0A=
> =0A=
> > @@ -242,10 +246,44 @@ union prestera_msg_port_param {=0A=
> >=A0=A0=A0=A0=A0=A0=A0 u8=A0 duplex;=0A=
> >=A0=A0=A0=A0=A0=A0=A0 u8=A0 fec;=0A=
> >=A0=A0=A0=A0=A0=A0=A0 u8=A0 fc;=0A=
> > -=A0=A0=A0=A0 struct prestera_msg_port_mdix_param mdix;=0A=
> > -=A0=A0=A0=A0 struct prestera_msg_port_autoneg_param autoneg;=0A=
> > +=0A=
> > +=A0=A0=A0=A0 union {=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: =
merge it with "mode" */=0A=
> =0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: =
merge it with "mode" */=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 admin:=
1;=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 adv_en=
able;=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 modes=
;=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: =
merge it with modes */=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 mode;=
=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 mdix;=
=0A=
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } phy;=0A=
> =0A=
> You claim this is stable, yet there are four TODOs. Please could you=0A=
> convince us you can actually do these TODO without breaking the=0A=
> ABI. Can you add more members to the end of these structures, and the=0A=
> firmware/driver can know they are there? Since these are often unions,=0A=
> you might not be able to tell from the length of the message=0A=
> exchanged.=0A=
=0A=
Those TODOs are not valid anymore, will just remove the comments. No merge=
=0A=
is needed :) Adding new members to the end will be fine for the firmware=0A=
& driver.=0A=
=0A=
> =0A=
> As Jakub pointed out, your structures have horrible alignment. Have=0A=
> you run this on both 32 and 64 bit systems? It would be good to add=0A=
> =0A=
> BUILD_BUG_ON(sizeof(*foo) !=3D 42)=0A=
> =0A=
> for all the structures that get passed to/from the firmware.=0A=
> =0A=
> =A0=A0=A0 Andrew=0A=
=0A=
Most of the testing is done on 64 bit system. On 32 should be fine also, as=
=0A=
the structure is packed & aligned. Anyway, I think to add build checking is=
=0A=
good idea to make sure the size is fine on both systems. Thanks.=0A=
=0A=
  Volodymyr=
