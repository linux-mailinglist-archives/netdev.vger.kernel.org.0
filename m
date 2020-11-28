Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B52C6DF4
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgK1A2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:28:40 -0500
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:24308
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730166AbgK1A10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 19:27:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPXMCX5xSk+nsfftw1fAoa9YDvPzGBW90nh1WtZaXVV3CGbQS09BbkEvH7mOnPZcoPL+Z1Dby2SYh9Qsz+KZt/mUN/XzGndrPNzsxhISZqsxPj8yNlWZTuRT1Y47jjLukgDXi7QHumj6qZmF3XG2oQ8krLyB+bDTMZbOyxXiIL7pk3afYV7HszJT09jIyWhdL+QSRCWb8D/iGcw2RNmLzS0e/1dqAXlmIuAc1R3atNU0lkV0W007JUbAsTS++zr0gfY6vbvaTRz788/VNLVxthRFuTtApx7dawiRf1EAkMdfMbjx8JBzDPUKL5s/F3Ogz2UWsU9sCYoAgj1uo0VWAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zd24bvB1OQO5KuimkeMWE5TTzR8L+JP6hAe1r4kj6A=;
 b=GroDIBBOnUe+grBkpP06xll0u8izXFLkscERla48aKeQmoRwRRuVLyh+qQMIYjmlczyNyzs5Sxd3yfGOjecY3tkCJzjX8AGMzKSllI0aYyy6w5M9LiW1Kiych6fu62g4vOSYEl/VUVff/EE1CKBDWo0znwsQL0Uv7o3hmRA6ugRHrzKTaE5kEihcgB7gIseMxxEVlTOokso9sjXBPRnT10xSvATVRS/fGSckLpisthauEgzvcSAOOPmBdoI5CgAuapiyRXHzVih7RR9rrakTllLRnbCOa2spnkioIjjADjgdGSxS4L6qCwChymOoaeWve8KLYo9aZ5GVET+WsdUBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zd24bvB1OQO5KuimkeMWE5TTzR8L+JP6hAe1r4kj6A=;
 b=iGuzz+jv+Pk+IPeyMtRbSNjLzMfDxbk9F5vxEUyx52A3jjqQJbrP9TJCSWxlIArLXijkNKdmaf8hcqjCFWLhDhr5/OnPSigr69aShnUuBoAY0ojer9b3MBpybD0EkFXijdiAm3u8JoViS2+7dU6SzjiJKZbIiSwZmNr12gky4TI=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB6328.eurprd04.prod.outlook.com (2603:10a6:20b:b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Sat, 28 Nov
 2020 00:27:18 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66%3]) with mapi id 15.20.3611.024; Sat, 28 Nov 2020
 00:27:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Topic: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Index: AQHWozn45OsHCx59Jk67oCoKlCMeg6nc690AgAAIIoA=
Date:   Sat, 28 Nov 2020 00:27:18 +0000
Message-ID: <20201128002717.buvgy3unu6af5ejj@skbuf>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
 <87im9q8i99.fsf@waldekranz.com>
In-Reply-To: <87im9q8i99.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e994c7c5-5e42-40c5-cd70-08d893345d24
x-ms-traffictypediagnostic: AM6PR04MB6328:
x-microsoft-antispam-prvs: <AM6PR04MB6328C316454943329581E1D9E0F70@AM6PR04MB6328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7umV+UMQhAyi+jY9XXumnj6Pe/bM5uQhyv8fPZL0X0pvEhSOdlztVq95fBkL+aTNbviH5hjUXMBx/CIwrmTazcrYcoV/M7uzpRX4dON+Nb4O7Z3LadComE8/VsIoqDHm9W3nAX9+1svl4AaXNMlWA/TErlU8htT4YaFlBgNxRvtrypWFkNW41u9CwXE1/h+LWLVa2yHb90KMW198ouPvEKyXuPdeOEzE5oEnT0pfyWlC1hr4ImXjHigPz9JjArqMAUK4gaKFiKVOAzE7rPS1Ii3G2UnaCg1W5/3j6dDVoRPQlZGJyhopbj+fjVy85jEYNVY1P4wMvKeScg81jy8Lsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(186003)(66574015)(86362001)(1076003)(6916009)(5660300002)(478600001)(66556008)(71200400001)(91956017)(64756008)(66446008)(76116006)(66946007)(66476007)(2906002)(33716001)(44832011)(8936002)(6506007)(8676002)(6512007)(9686003)(6486002)(4326008)(54906003)(26005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o5m59TsYpgZu1P+sNMUPXfi4HGAso+iVbh02lniebb4ulHytym/5+zqi8+PY?=
 =?us-ascii?Q?YE4XpY5o5dsQHTXLpDcQiQchiN25LD1RJi3FKv8OXR5QHhLlsitG4bB6UmEV?=
 =?us-ascii?Q?fzMXD3OHC79htW5qfMXrHMa7WW0xdeaObQ0gHWIf/YrSUoF6i0Eg5oWGP18F?=
 =?us-ascii?Q?M6NMMlGZ20D8lWpH/+ySHdohC+Yoy1+JaLCAyHmLlha88MSA/MvVTf6V6k/s?=
 =?us-ascii?Q?4i+Z8C65fQGWqz9sO2uNL1V7eP8vScQNSsDb08iWXqQVAapkqSDpINteR+xU?=
 =?us-ascii?Q?Yrror++ioX14cbeE4EU7ujhz3WuZEF3/qDlMfMkXhHwB4Ruh/x3GyGxsDmXV?=
 =?us-ascii?Q?crhF1REDd9GCIxaHRCGvqAXs9eiHA5UDox531VIniscqcQ7sPRxnP5RYeLFi?=
 =?us-ascii?Q?JnSYL6ZIXUy9wJQR3yXYaxA551k+/83HwvEkhrR67E/V2AifUQwzu3Ynqs7/?=
 =?us-ascii?Q?M51fKkNmVODVnSveKceqsl+khqbrC412gn67iE1CmkUE6B2DEo7BCdyvd9NR?=
 =?us-ascii?Q?BsBha0wboUM/dwLyRlZI9Le8hrQIkC8qpps/3WGdVxTUA9h/vVt+RK9nWp7x?=
 =?us-ascii?Q?MkYq5T4XDJgVQo2g7+VwK/cWG2yIFR5RYKVfBPsBQgVDBf0VAN5W/jX385+z?=
 =?us-ascii?Q?x14yPt9TCLQ/isHPHyH7vthn9NQTCqPCT+MLapk1OCqnZTCwdTOse8rONtKT?=
 =?us-ascii?Q?+mrdJ1QzvQ5KJ35fYUCvHdiq9y1nYmEte8nrO3Jpnura8emb2W0uXTXMmxoJ?=
 =?us-ascii?Q?XZhyJSuMejHffOEE1ysewFLy+hzr1bqLTMcW4umcQFnUI19HoVlQZKlBVxKa?=
 =?us-ascii?Q?lHQx/5pXdXTdu+wiwr41vUbocMGaTkKzNYqFywdkZJCirH89e8YeSze4MNzQ?=
 =?us-ascii?Q?z9DRcNlPluYlNaLUhHaKF/kmanQQvcrp/eO7NuC74bCC8dsOH1edCRSpxQPx?=
 =?us-ascii?Q?aaCw13+7rIqgEts1z67qOdzuXtUIpQ80knWgmvaz3J/OoFA2+cwCRhg95B/7?=
 =?us-ascii?Q?de0y?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DC163D3990FCF498E8989BEFC379373@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e994c7c5-5e42-40c5-cd70-08d893345d24
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2020 00:27:18.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KkEO5AukdGLy3XbuhtoAEUSwITKoXhOTiSwGppA1ZHmTcw8ZtKxUNbOFdavU0vuE/wOkdP9E0iFRMDo4AxgxWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 12:58:10AM +0100, Tobias Waldekranz wrote:
> That sounds like a good idea. We have run into another issue with the
> MDB that maybe could be worked into this changeset. This is what we have
> observed on 4.19, but from looking at the source it does not look like
> anything has changed with respect to this issue.
>
> The DSA driver handles the addition/removal of router ports by
> enabling/disabling multicast flooding to the port in question. On
> mv88e6xxx at least, this is only part of the solution. It only takes
> care of the unregistered multicast. You also have to iterate through all
> _registered_ groups and add the port to the destination vector.

And this observation is based on what? Based on this paragraph from RFC4541=
?

2.1.2.  Data Forwarding Rules

   1) Packets with a destination IP address outside 224.0.0.X which are
      not IGMP should be forwarded according to group-based port
      membership tables and must also be forwarded on router ports.

Let me ask you a different question. Why would DSA be in charge of
updating the MDB records, and not the bridge? Or why DSA and not the end
driver? Ignore my patch. I'm just trying to understand what you're
saying. Why precisely DSA, the mid layer? I don't know, this is new
information to me, I'm still digesting it.=
