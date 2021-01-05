Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F472EAA50
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbhAEMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:03:20 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:14650 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhAEMDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 07:03:19 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff4555d0003>; Tue, 05 Jan 2021 20:02:37 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 12:02:37 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 5 Jan 2021 12:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNWP7Kng+DquaOQ4S96kWY2dE+rJznDNoslfBpMbSeiGnq2mhHlQ/Wn4cFhOwc34zSYgFuwdlPzKnM4BFkuKOi8rUmsq7X/x2CCwBd+53sEm0nBiD1KLmp5CxtmqRcHEpAYWC8MFXT6vcnxxcAbC75K76B5BYylboRpJ1a/Th9O4G0Uj/VUKdyiQv62JbXqUtvu5J9INqRZPSoHQU+AKt1hMFMlnJmNJ9tnmqh0SQPQFwUG4s9R9007I4JdvHItRrZjucGZ1RFmzb19VrckZ1gcnSmpCouuS+b2PjladwXLnpRwAANrJquSvbwvnVtGZU6eh0LK66ScjRzXYOJLCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/jx5WFk3vyY8ySxdOkqFOctXNER6PQlggFn/Ps04KQ=;
 b=BRSXkGTI/BKFvpTW8Dk+P8O5feIElF9qCGwq8iyAmZiVSwQSsJPNKitr7R22iEkCkE0Xep3p9xRziOSFWTjeeaWVGlP82MvfeUIjUvSgnAu8w6cqSmeXS9x0po6K0x9AXl0YS31l7pP5JFUzNJgmo0flfAWKsCE7Y2gHwg5PfYeVhaxQMjueRv9WZn8WEnyhUpkK4GF0C9mTLgk8WFJIisdi59JTJmVPYFm0ddBX2foYdH3rAf7yS3Wnhjyy01kSB9K3h6yKNsQSluJ+z7dX/AhLygtbvTOFOMAQ8p31DVSPn66SL17MuACAvdH9P0vxjkUh29z2Iy1Gil+xudhScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3431.namprd12.prod.outlook.com (2603:10b6:a03:da::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Tue, 5 Jan
 2021 12:02:33 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 12:02:33 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW404ZeuD1Nrf6EkKQQnhYNrY/9qoY6uQAgAAB4oA=
Date:   Tue, 5 Jan 2021 12:02:33 +0000
Message-ID: <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210105064707-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7821fff7-cdc6-47e6-2930-08d8b171c8fd
x-ms-traffictypediagnostic: BYAPR12MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB343193F631256C24A8437368DCD10@BYAPR12MB3431.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KqZg2OpvvCkMOBG5G/l5URp4XJBJojfX54aE1G4gW0N4bLToMWGLrV6ob1lbZ5H/9c0Oqec3HBzce4Dgl/X5C9vqtcr30N+7er4V2Kmt0QJyZViYJr/thjjlV21Npd1YwZNsbr07DVbQILeZ4Po0HQ/kUjh6VzgoETfFT90IJDHa+wGY6Hy3gYwuCxPdru8NixoJLb66HXXLOo46tMWaTkWWbsS7MAJNPzoPS4h4iSyJfgaIJHEXc3XZuEDqE9wRwH8u6Fd1nv2BbLcp+6eTD8S1CFKgJ24sKBAjWOuP94SWtP0vKSvrroAw0Eut1drl4HpPGlnwZ2uyPwDVTxng1MFkGWJF4j0uhFN03No1RoFEPacqmGANUDiytC9TLgOElOx3Wi7D7gDgbB341YQzYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(55016002)(9686003)(54906003)(66446008)(64756008)(86362001)(66946007)(66476007)(66556008)(76116006)(4326008)(5660300002)(26005)(7696005)(71200400001)(33656002)(6916009)(6506007)(8936002)(316002)(478600001)(52536014)(55236004)(186003)(2906002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/pzd1A+37WG6cZLM+OZmnx4PzFJTS9qj8iHvSWOaNfhHdxsDLIkoav1N1fL9?=
 =?us-ascii?Q?kTTwf28e78vVhb8KQxmfUFGyYXOkFzLt2nnuxuPNlXbDNMddUs4ZafYM6ejV?=
 =?us-ascii?Q?8KnmBchRawsv0Od/MuTogqD2wANawMpKnsim1fK8u6rJ8BtF6xxLACx1mg6J?=
 =?us-ascii?Q?KZEjYtSGUUbP1+R6wcvqRqypEOOQd9dN6TqMVBqQts90nrF79Bn/tTPLVren?=
 =?us-ascii?Q?qI4ou82UPCYhywpIEcxRMw7ZvKJu2IajWgXT13+wI4BEZfmzIg7UtooJAlxH?=
 =?us-ascii?Q?eo/iCpV94GTiH2nh8e51DndZ9/C1DHCki7ke2i6HeQBphEDGwffvc380n6Qy?=
 =?us-ascii?Q?q2GmtwPaJyLmtqKf5+Ngt598a2Z6t3BTzkcFu6Zuxv5p5w8/5mlU/AgFJ3ze?=
 =?us-ascii?Q?AiwX99v2jOsc/cO7zWeUvg9dzVcKJMhNERY03jBxVu4e8yvBlq57EdRT7/uj?=
 =?us-ascii?Q?hv2bTA0d+QlNbAbQQ8kfBBZPsjsr66XDXjwoNVFSWG017ptxKGs4IKrWr+pS?=
 =?us-ascii?Q?FbxS5SZwxVbZV8CSg66fx6s5VbldtzD7Z/yVSa5xSrj5fsAkrcNIdahw4D+Z?=
 =?us-ascii?Q?GX06A929YYmll28kQ51FzYLLNluEcdwzIdPYYuS5mzXVnkG2ljoO/e1/rKNY?=
 =?us-ascii?Q?xxk8UYzgG9nGVatxecoB4m1MHqPlwVhv0esu0UNZD1iyI5Fj3DB9Ntb2KKX5?=
 =?us-ascii?Q?r2Ei6M0Q8/jJp+Dc2pYGIaskYP98G+WVcIqzkCDJix4DpIzwSFCJY+NRcjsy?=
 =?us-ascii?Q?ZM7py4py+dBJaUrXiOyyPQK8VawAUcT6bXCsoII4LxM8EcWFbPYPyshPnrP8?=
 =?us-ascii?Q?H3/CTI0z4cwElQ1l4C3NYa19SnItjH4jPlb3HSEYV+66H7uxV5zuDPiKywnP?=
 =?us-ascii?Q?caSJW1i+C1vO189rwoIZHj8OCEEDminJ4R4CgRGeEHXd+n4eqahcBkaIrkd2?=
 =?us-ascii?Q?v7cEBiGaLQMPv0HjBy4y1uuxGYwhLZ4Nwg/yEB+xJKc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7821fff7-cdc6-47e6-2930-08d8b171c8fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 12:02:33.3165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6hZTIBMZHqS+K529/zQPhIHFyumm8yIpCfiE3ltnSgrH3wpfkBnKn/9UYTOQ+3XWugMK+AzjXpQ1BRrsrQBQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3431
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609848157; bh=0/jx5WFk3vyY8ySxdOkqFOctXNER6PQlggFn/Ps04KQ=;
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
        b=KUX25S6qJY/3USHEc/oaPrFttiq7pq/C8sNNHj7NAwsr7loEAx4DgPsZKh8lpDedK
         9fV+mMULr09PpyPb75fwn0fPbJo8LrUARdJJZNDVJkVpippumPR+OFGY21abp8jGz5
         m2HMo0zbJc1+iJrHvWdGVUYIBx1m9tyfmq3tFOVNp0XG6k2OZjSMgSp5pfBrV2sshs
         oOCtY6BSePBQxgRNJW9IUyYAHAxYRbK7uvk0zmIRuTAjHsFNxnDU57+qMiAs8LXLbz
         Otv6IstY0TDKmnXIrmLU1ZqW25XS3O6785RiWW2A8HN3P9NLVrADdXU0mSbxO1w2x/
         EptWgcxp0aNDw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Tuesday, January 5, 2021 5:19 PM
>=20
> On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
> > Enable user to create vdpasim net simulate devices.
> >
> >

> > $ vdpa dev add mgmtdev vdpasim_net name foo2
> >
> > Show the newly created vdpa device by its name:
> > $ vdpa dev show foo2
> > foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2
> > max_vq_size 256
> >
> > $ vdpa dev show foo2 -jp
> > {
> >     "dev": {
> >         "foo2": {
> >             "type": "network",
> >             "mgmtdev": "vdpasim_net",
> >             "vendor_id": 0,
> >             "max_vqs": 2,
> >             "max_vq_size": 256
> >         }
> >     }
> > }
>=20
>=20
> I'd like an example of how do device specific (e.g. net specific) interfa=
ces tie
> in to this.
Not sure I follow your question.
Do you mean how to set mac address or mtu of this vdpa device of type net?
If so, dev add command will be extended shortly in subsequent series to set=
 this net specific attributes.
(I did mention in the next steps in cover letter).

> > +static int __init vdpasim_net_init(void) {
> > +	int ret;
> > +
> > +	if (macaddr) {
> > +		mac_pton(macaddr, macaddr_buf);
> > +		if (!is_valid_ether_addr(macaddr_buf))
> > +			return -EADDRNOTAVAIL;
> > +	} else {
> > +		eth_random_addr(macaddr_buf);
> >  	}
>=20
> Hmm so all devices start out with the same MAC until changed? And how is
> the change effected?
Post this patchset and post we have iproute2 vdpa in the tree, will add the=
 mac address as the input attribute during "vdpa dev add" command.
So that each different vdpa device can have user specified (different) mac =
address.
