Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7190122B6FF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGWTz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:55:26 -0400
Received: from mail-co1nam11on2135.outbound.protection.outlook.com ([40.107.220.135]:40449
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbgGWTzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 15:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXVB5iYA0wZOFExhIHQO2wf6R4LXWwUIioxgiCIySi/1N2So17mnrED95BBYvqlPGpZImkC8YpuItabZuaIdCeN4SrTpg31l2E/+ZiyrblapcbvJncJkF2EynQDpdxZQxcDlNbZICv4+nDcbfeHRAlYGs6V++l7BRnzhwP0qQmpubUiY4T9Bv9Gm2gw2GaNtgXdHIOs7laX2oaCkVVbY/ikwc/krnD8H7g54cCJEEih1LNIsQzTtsLQYVxhT6FT0XLZ6YPhjav3AoOtVfVACR8KbAbrOmo+ySfVfUk9xgbmg344cwj3E+8Eu7sZ93pZ6527Hs89JDH3nCkC/r0vGEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRMVBy+LIEzF1uKsYT8klw0+LEGkOnRtojCwM82GAZQ=;
 b=NZsvoneaJZK7lr+e01MnHd1l8cefFbsueEGcQunQZg0BLkSdzZWJAOZaZkda+JQ79GR25J0P5MEY3X3VBLgrElDMMddHRyu8LBBSHGDTiMEkFFHbZhwULjq6v7CNoB5g4NiBq4QwQw6Y5hRWLpFNpbnEvbTcSguQ6wncqor2D7VNoCuBX8rWVGvQF3aSntBlysJnm6bqpCnwo3tggYOOyaxXp6TK+Tag8JSG7hSAq4FscmIPXsdTsHXt0L8Tvwqcgbp3CeGAwRBCJ7C0uD8ONenVqd1RiOlRqaCKG0iiygxnqQ2gUHo4Eg3vyyLQHHmyM0q7H4o6aTyn+pqzz7BTGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRMVBy+LIEzF1uKsYT8klw0+LEGkOnRtojCwM82GAZQ=;
 b=O0I3aUBxNxpUu4IVOOGWB34KSYApbs+lR7dv/3hjA7J+5RG+wlr+d5rAYCdBIZzaJVL2jmd65UzRQEosjyn+5B2AOHWtsXa5rER//LGWTPrRbub766r+dZVOw2Z5cDT+Gqv/a1lhoqq+IcozCqgeSRNU2bRgO56h1KPfEzn4wH0=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0900.namprd21.prod.outlook.com
 (2603:10b6:207:36::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Thu, 23 Jul
 2020 19:55:21 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.007; Thu, 23 Jul 2020
 19:55:21 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        Chi Song <Song.Chi@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Thread-Topic: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Thread-Index: AQHWYL7EarZGJgwXE0O1xrmSwXiMI6kVj2kAgAADMbA=
Date:   Thu, 23 Jul 2020 19:55:20 +0000
Message-ID: <BL0PR2101MB09308AB4F78EA5B1B27B1CCBCA760@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <20200723193542.6vwu4cbokbihw3nh@lion.mk-sys.cz>
In-Reply-To: <20200723193542.6vwu4cbokbihw3nh@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-23T19:55:19Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=36674a39-8aab-4e9d-a159-4d8b5b4bd8e7;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6aa8d0e2-ecee-4ef6-fb97-08d82f425500
x-ms-traffictypediagnostic: BL0PR2101MB0900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB0900C920572DB4B03E5B8712CA760@BL0PR2101MB0900.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +J6MVmfqhd65A5HfP0qtf59gfQno69/bX4Gz3VS20E+nbtVSeatWHMOOefc6T7Fo5V2HxLxwB6jVOHw+JUNA+64FQzEcylWOJoiy61btqNR4TtSCRee7nwFvH+nb+nTE6VA3fsfnt+sGJ7OOlydBHU16XvQnwMogo7Mqs1zuuO9smFdgoolSNYrRczQWmHgPrP9297/KCIeUpL+zp/PYq/56LhVACeptjmTcN6aNtincB0Ojk8nbWb+n7tQILS8jqABS4OiU+NPBALkfNXLb6KkbrXtlkc1y9t7jAXC/jck1XAVvlpoclDWoNPNRJaSo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(8990500004)(83380400001)(71200400001)(52536014)(86362001)(7696005)(66476007)(66946007)(5660300002)(186003)(64756008)(6506007)(66556008)(66446008)(10290500003)(82960400001)(82950400001)(26005)(4326008)(76116006)(53546011)(478600001)(54906003)(110136005)(8676002)(316002)(55016002)(2906002)(8936002)(33656002)(6636002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OeSEA958MCXV3U3wBYjbLZ4d+EMjVZXs+6OXQkILh0+CLvzz0mXjJexAiD5b41Sc5UbMcHQdfQ4I/i5Ekag4feUYbRuLvQGdxp5/yyxKfihbJucYqTbZyRITxovuhtFWzu57roZo47PFma7ABWYeE/NjelpDOZWR94+TBtVbpwLoTuPNpUtYO6K3Hy+ftQXPeHD2jlqcoHVYYNAzOjDgsRATYtsgSqzqKWR7ze7S4a7tbvW0is9kXWXzN/pptTf/gVdYOKQ8m7sGPmSdJoRN652mQrenIY3zz75sfzOYkGUk1UE6e5WT2v+xBbqt048gOfGqz0DuN0T9NMIL7mPm2wPPssWyS3CvEIb9G98oDHq9EFgEi4X6fr84sz1G6cDikgn5+RaELisiAjmvtC0eYTZqHVE6fMcFhMLg+xXEXVBTFxU3n4wz3pOOFzGukruSLVh8Asawrgt89R/IA9I6vdzJ0rR621752yDI2JeTSbezvYbqca0teIydIMyOrECH8WA4cR2PUTTeZGhsZAui3Mf0gLLnrd0JaptNXBt4A1dv0wk+tulpN5Pwjg6am2AoM0QvUdF+dNaz+5IuIHjUfN9z395PtcvIvsi7YxU7hTayhDlo0erlvAe0yfssSlj2Fi4aSO4aMMzRUwlpUIbvpw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa8d0e2-ecee-4ef6-fb97-08d82f425500
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 19:55:21.0691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSc8wLUk6qlK4tkZcdi3SZPTQDjghYG7/mx26jTZ65Hg6CyEIs3gvKzFuqPbn8SyhcBk4HYvRalz8xzBAGZCHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0900
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, July 23, 2020 3:36 PM
> To: Chi Song <Song.Chi@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 net-next] net: hyperv: dump TX indirection table t=
o
> ethtool regs
>=20
> On Wed, Jul 22, 2020 at 11:59:09PM -0700, Chi Song wrote:
> > An imbalanced TX indirection table causes netvsc to have low
> > performance. This table is created and managed during runtime. To help
> > better diagnose performance issues caused by imbalanced tables, it need=
s
> > make TX indirection tables visible.
> >
> > Because TX indirection table is driver specified information, so
> > display it via ethtool register dump.
>=20
> Is the Tx indirection table really unique to netvsc or can we expect
> other drivers to support similar feature? Also, would it make sense to
> allow also setting the table with ethtool? (AFAICS it can be only set
> from hypervisor at the moment.)

Currently, TX indirection table is only used by the Hyper-V synthetic NIC. =
I'm=20
not aware of any other NIC planning to use this.
This table is created by host dynamically based on host side CPU usage,=20
and provided to the VM periodically. Our protocol doesn't let the guest sid=
e=20
to change it.

Thanks,
- Haiyang

