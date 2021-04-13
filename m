Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC735E51E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347246AbhDMRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:36:58 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:56673
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240167AbhDMRg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 13:36:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMB3JlfHp/uRUdUvnfFYdYQ3dlNbqqRCe1JNlW1HGbSaUn50PU7T9PuavB+3c32smIp8AngTyZG19K/V862omCmvVLTCezG5X2yIg8T9dDjFF38w5qBLayMlphW8UALh8SWQUCKiE72wBVeB3wh7vRpIUCj6tegMlhQBKyPemysKB30rsBrVNBYVuSS3AfKFmpPjDgxdCHBxZTvQhOGIazBVZSxNjb/rTIAGVZ6xza8rVwPadNXIU1TGa/6iRXiuGrVvQkNnL9EKaJfef+BqFxm2YnDhhCElLk+yeyF1ljit+JVvTJL/eytNUJjG3xcRlhA0gCcZhCH5TrlTRW+4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzZvfCOsZKXHqCKp5AYhUnosLvMGtRvoi2PDu9EQ54g=;
 b=FA2ZGT3+EPKJkVekejxzHyaeYyxMZth9NLOOiaFuwVIhMN5xKp11NVzjNYrX5BaV9bNnbJFv8vXczY7ip1ba6l3ZpxghNXM6Jvo30kxRBd0szytjw1RuoUBuaF259WIQbDtCwoENbYYdvyKvwjU7isyeu8cJEzOqPTJWwHNoz7kcxsekCAf+6NlXq/XF7w+0dMMnXZtU2K9jlxbEpZslVdx8idNUOPOXC+SfzMPe7nXYYHaH/9Kne57Vj5/53zV5DKnMoFzNxhQjNqGLdeAjUHtK2fvHKrJ+dfIWdg4CZi/v4Cfrc3jpwCtE/BUXX9MzLx+abApPBVl8kQAoIFYOdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzZvfCOsZKXHqCKp5AYhUnosLvMGtRvoi2PDu9EQ54g=;
 b=hS2u2kFvsNfnnSf06KPdA4wKP6OWCt54/rPHOGTtst7Jnv7sV0vypsNlUjUPtDYOGw0kdezXF4wZAmmi8yEUBqdDWw4xodzH+flZlOE7cCaRqSR1XoSunTY3DY3dWfrb8ZvUOS9UNPxYXZ5fkLrvAIhtYHFIkW+q29dK3gBwJv8rg/zuBBAvMRGSAMXYZCDHt8dd4dUxHcsUDTtlJpgqxjsew9I0EySM1RkbKVAS3f3DZCs8XQrN2eyYhEW68HeGJbRzPHLIurEhPEJj1bb3vv7EGd8gSbRPkT4T4zHV/qwPFAvVCgbISDFO4hJ5bzIm7nFqPt7naV/yG764I6QfIw==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2647.namprd12.prod.outlook.com (2603:10b6:a03:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 17:36:36 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 17:36:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKygnOko9SmU6R0GbDW2iBlZsF6qpJjuAgABk9YCAAB40gIAHVsKAgABDgiCAAUwCgIAALvwA
Date:   Tue, 13 Apr 2021 17:36:36 +0000
Message-ID: <BY5PR12MB4322A28E6678CBB8A6544026DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
 <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
In-Reply-To: <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70273e8b-2c07-4767-dcd5-08d8fea2aff9
x-ms-traffictypediagnostic: BYAPR12MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB264738384C224FC7E80872A6DC4F9@BYAPR12MB2647.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qpzlEf17ez3yBKrZGYJvXFd7wULuLZNt9zaM7G1NezwHbBEtsI3FxX4GvGwSt5VoyHlz8Aaxbec8HMx5N9MR8j2cVkr5g4o6jFIGkmLuU9Ui8QrdZdZT+2618DTrjSy8LRetUDwE9nIRvdkR1S0gR4a6bItgMOjByyy8EHJcjygqIzjPr3906eeeKeYWJ6dd1mfrzkjftJb45zFpulyZYojgXlOkMCvOUTsjfht++m730i1EFIr5bIwkAvgAC/cvT5A88R6R9253Iep/ABmG/s7oCFmI9ygcCRu43oGzsUKzjEqw6zL8CUNS1vmqnQqOxfXgMlG5vxAHFc70/oJ4N13WgStmJFaIfWBJSo6B6KpmlOdGe4nmK3e21+msGSmkBmWGgOgspGu6pGP587Bj/zx+upq3datBYoOuWgaAtB0kIs87zAsUkti3lrb8E2w73pV6hRz2jEjQIrbkOJiWdmExiunrZOBSCWpDjdMeLTRZJSrZMChA6g/maaMK11tbq9kFm9DcPVazD/6vkwIAPNBRYT9gaZOJVA2CXwH/YL/MufEmKSOGbBsrYxWSjzixV7/UPr4/raJbNfLHgTS/oJpDn/90ILvS/lza31x/D6Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(66446008)(186003)(7416002)(66946007)(26005)(7696005)(8936002)(5660300002)(33656002)(9686003)(64756008)(71200400001)(6636002)(52536014)(66476007)(38100700002)(6506007)(76116006)(110136005)(86362001)(66556008)(4326008)(2906002)(83380400001)(478600001)(316002)(8676002)(122000001)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hWq54leJTqp0/mG0Sl/jmo+0fMJ12o+gz02ZWFvsXPi3JDx/ZbpbxaqlYPNO?=
 =?us-ascii?Q?pvgBAzN8NB2oT6sQ6MhMg7aA6udnuPrtHRMbMAg9bDyeqlBq02Z2zNYIBx8N?=
 =?us-ascii?Q?qOD9dozX+3rikQ8zsPr5w6zf99GpW+OFvPvQ59Z4rvoO3XQg/b9UHUJBsUNv?=
 =?us-ascii?Q?UfIe/D6uiB5XLtjmRYhve/jzlrRjrz3pW4/runRT+G/0AOQ5KbPraQv7bgOu?=
 =?us-ascii?Q?34z7aksXaE5AWWwYJZmR2UcxG/fY3rn4mO+6BYkUXwFTDLthqcIbWzlVvYW0?=
 =?us-ascii?Q?L+GMM6gUBdx03rq6/KRMkQ67gVcXmdK4wK/BmnJKfBBN7sclysIv5x4D6W6r?=
 =?us-ascii?Q?+BZANLSlktfdwWx+nfGYFTnpgTI7UM9sjtVGgYDsdiBdbpM1EO4LXnE6x3gi?=
 =?us-ascii?Q?7vvEi9pZhLJFw+JYYBULg1FlV1wk0H414iDN8o+oKCb8350EZ6+N9o7JiOud?=
 =?us-ascii?Q?SNzdZpa7LLMelByhtXqyrDHVDvkTZu0hCWUPdL/ewyRTEYAVTH2ooQoOQL+L?=
 =?us-ascii?Q?QeZ9yWdV2Ltm/feMYpg0rPcO2jGvyUVqkqPmsrQGYPIL0kOzgh9Syve4UGhZ?=
 =?us-ascii?Q?+UDVs11MDcxdkKjTrkGLKwGVsJU8lf6u+QL6HErHXYwwhpelmj3LSgampfNu?=
 =?us-ascii?Q?WyUVIQDPzGsy8LJ1nL7hsAt11dL1Sw/pJPWCsK4BswCkI7g7Q9f3M8ao8V6d?=
 =?us-ascii?Q?MwNWV4M/iUIr61xT2KdWo5WM6H2TC1kjQz9wI2U8BnKZZi9DP8RZDHtljKBT?=
 =?us-ascii?Q?vj2oPQ4ap5N8uDiAProKroPjVsgyreV6CrE7874s5GO4wUb9/+6WA2ibikha?=
 =?us-ascii?Q?4yqkaiYnuFb8OVYdwcKg18s2IDSp4uLYuL1BAN1WdWqus5l2vYMR6UuVdt7p?=
 =?us-ascii?Q?4u/zGCMQFvu2RaYxfIuMBZN+Q+3XhZ0AiYR6v7hUvRTDo2ePauEc7sNRcrIH?=
 =?us-ascii?Q?J7mKXIpRH/YQc+ribCFT4MvFL6jV83+WgFLEWz0X0Q26GeXsG83pWwwU20Vi?=
 =?us-ascii?Q?3Ru//zv0VkQUjX2vP0DMefWNANgxbwQXyjmD0D93AOZq1LN6l+533S855Eg/?=
 =?us-ascii?Q?v+pZe7OblEKCznjH+KJv7KBEaZMzZA7EFfQqI5c7qC/uLfCknKgFyfJg1N71?=
 =?us-ascii?Q?ZOV9nOqSJa+GpiipqKn3Lmpn/NATzpr33iC52GMWm9N/VV4dnvga2YKNfBdf?=
 =?us-ascii?Q?9WiHmQEI3umD+ahrOX0eMCrRDfiMRamUBx+zoGopUP3e4cj68jYBwryrg4UF?=
 =?us-ascii?Q?5vWL4IsRYpz9b8PNZYGipKyBLgH+EX8kWa5qXRu49JPdzeI/eXYG0RL2fOoY?=
 =?us-ascii?Q?hPf6A6KSwvDIikG8ZgxOahv5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70273e8b-2c07-4767-dcd5-08d8fea2aff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 17:36:36.1070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q52jhI3U2outSk2rhiTjG4ZmjgLKvUirZJ1TjNdAT5mVh2NIOYjDCMSD17xA6Bu65ne0bJGdaTVaxvImEfUF+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2647
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Tuesday, April 13, 2021 8:11 PM
[..]

> > > > Parav is talking about generic ways to customize the aux devices
> > > > created and that would seem to serve the same function as this.
> > >
> > > Is there an RFC or something posted for us to look at?
> > I do not have polished RFC content ready yet.
> > But coping the full config sequence snippet from the internal draft
> > (changed for ice
> > example) here as I like to discuss with you in this context.
>=20
> Thanks Parav! Some comments below.
>=20
> >
> > # (1) show auxiliary device types supported by a given devlink device.
> > # applies to pci pf,vf,sf. (in general at devlink instance).
> > $ devlink dev auxdev show pci/0000:06.00.0
> > pci/0000:06.00.0:
> >   current:
> >     roce eth
> >   new:
> >   supported:
> >     roce eth iwarp
> >
> > # (2) enable iwarp and ethernet type of aux devices and disable roce.
> > $ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on
> >
> > # (3) now see which aux devices will be enable on next reload.
> > $ devlink dev auxdev show pci/0000:06:00.0
> > pci/0000:06:00.0:
> >   current:
> >     roce eth
> >   new:
> >     eth iwarp
> >   supported:
> >     roce eth iwarp
> >
> > # (4) now reload the device and see which aux devices are created.
> > At this point driver undergoes reconfig for removal of roce and adding
> iwarp.
> > $ devlink reload pci/0000:06:00.0
>=20
> I see this is modeled like devlink resource.
>=20
> Do we really to need a PCI driver re-init to switch the type of the auxde=
v
> hanging off the PCI dev?
>=20
I don't see a need to re-init the whole PCI driver. Since only aux device c=
onfig is changed only that piece to get reloaded.

> Why not just allow the setting to apply dynamically during a 'set' itself=
 with an
> unplug/plug of the auxdev with correct type.
>=20
This suggestion came up in the internal discussion too.
However such task needs to synchronize with devlink reload command and also=
 with driver remove() sequence.
So locking wise and depending on amount of config change, it is close to wh=
at reload will do.
For example other resource config or other params setting also to take effe=
ct.
So to avoid defining multiple config sequence, doing as part of already exi=
sting devlink reload, it brings simple sequence to user.

For example,
1. enable/disable desired aux devices
2. configure device resources
3. set some device params
4. do devlink reload and apply settings done in #1 to #3
