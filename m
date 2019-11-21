Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D336B1058A7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfKURgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:36:43 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:61668
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfKURgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 12:36:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuM0zyoODYaxSN67KLzq/oLmiDzOsn61HXVFZkZ0DwEIRB/7YOhBI0N5M2gQ5RGqndnab66l0J/xekbUEDA8mpn7/JmhL1bNUlv/VTGLSPdD7iO3LyVjJ5mENXhcddmmz5dG7whrHuHZVlOs1tDHbgXIhUU5AJdkzSl2MPwoC/QklUdgBSyCCtZ5BOK3KcGRQEODYMjc8UHoyAppO8zvZKl42DvVVHjmMt3JjF86220453jfjqR3o8z1RWvDNxOWXe+kSS2KYbuvnUTHP4bbNqFx8AD8hDnXJysI4Oe+4dOmh1eZW2XzYD1fo/qWIC+j7dqrctD+aaOG9iUT2IXwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCy13xVXiGyn7F2nCljvUIczWHxN7Gn3eM7O/fEsBEY=;
 b=MDH1nJSIA+YQgKsLOcDQ7XV0in0JAL/jtHSMzMSjsUwE/tsjn2bptEHsGHNkvcyYqh7++J0QpuesaBHPwK3JQoiCVpPRcwg2EWIiBaWsIxoQSysrgdUhxPxWiCS/AYAE53VNPZxegswxHfe0kKA+XFQBB54CXY5T4lRZI9gi2SNiaYiBTZWHeY6xQCHR4WHupa9aIo7jZj7fvXGt7fOyh5akIqH+VRhxIpuk1XmuLbtpDCgdIxvzq6SfZAutIwqcJfjwvnsQMYAICkrlJf58+dLuo/jNLUj6HFDQY3PV3DtP0XYdBeJ+39ETej+0OtICtlqDdZ2rsU6HDbU9O8900w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCy13xVXiGyn7F2nCljvUIczWHxN7Gn3eM7O/fEsBEY=;
 b=KQg4x3GFqvVMPEaqaU/u2eLVnoB9EY4Zr1QvVufctts8lI3tegM7Fvwx6kl/Gb1mhXiN+UHVs6zMa7IPaza4ZxgQYGIxLN93lb14x2vl7Ye38fjNP8sM5wKdhggj7byJcxl5pIDhY/P7reknbotRaYfrqP5aEGGtApvljCEGrRA=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3252.eurprd05.prod.outlook.com (10.171.186.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 21 Nov 2019 17:36:39 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493%7]) with mapi id 15.20.2474.015; Thu, 21 Nov 2019
 17:36:39 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Topic: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Index: AQHVmu/Vfdk+oqiBkUy0e40m6XWwa6eQjLIAgAVh4AA=
Date:   Thu, 21 Nov 2019 17:36:39 +0000
Message-ID: <20191121173636.GC107486@unreal>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191118072500.GI4716@unreal>
In-Reply-To: <20191118072500.GI4716@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0087.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::28) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.29.147.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3d0bbab-e1bd-49e8-135e-08d76ea95d59
x-ms-traffictypediagnostic: AM4PR05MB3252:|AM4PR05MB3252:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB325298A0D3E08DE2EF6258C3B04E0@AM4PR05MB3252.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(189003)(199004)(33656002)(81156014)(478600001)(5660300002)(86362001)(81166006)(7736002)(6916009)(8936002)(14444005)(9686003)(25786009)(256004)(229853002)(66946007)(6512007)(11346002)(99286004)(8676002)(66066001)(1076003)(71200400001)(71190400001)(6486002)(26005)(66446008)(64756008)(66556008)(66476007)(316002)(2906002)(33716001)(446003)(6436002)(54906003)(6246003)(305945005)(6506007)(52116002)(386003)(14454004)(3846002)(6116002)(76176011)(186003)(4326008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3252;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cD8b9MoYtWUuXJ+2O3Au6jQUtGcVAHG4N/TSi7Mrvvt5peBPqglDzHSJ63L3v82nVVPOPyxpDmL2adUjV6nkR9rRbTOIyhfQj5Rm/FB05KOpd1SdKG5N5diBo8/a5R3ZLrxnQwQ1ys2As9H12TV95OqjkCY24yqwAoTL+re/sxEyjsztD19LVIGFp+ToyLC63y0byisnsNxr9YbW3A91rwXHoH8q4q4OhbXa4Ek1ec3epy2vFWknYDoXwNYxjwyCS5L7wtJN+fz2w/r7xd04/2F6AWwarAWxJVox3iYD1amSEeXirji3aZJSxd7cuBctytri9P0D8rnVbJ7v7MT5a3a2hGhLU9wOQVun3h9wyWSBzXsON14wMjVm1NgMAnY5l0YnzQ3QKVy/oiFhtpC/1PcYxNmi/QZ7IlYHkR86zvHMXEw/L3JhffR2xQ3JMZ+1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A869D72D8870F40851757ED895AE818@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d0bbab-e1bd-49e8-135e-08d76ea95d59
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 17:36:39.3160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOwmWD0VwQldvy5/IMg3y8hAtB/iXC3KmUqjYBEeX0DPZuGme9DSmBMfh62VBUPe7wZbj6n/Y3qH7wvLQfMydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3252
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 07:25:02AM +0000, Leon Romanovsky wrote:
> On Thu, Nov 14, 2019 at 03:31:21PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This series from Danit extends RTNETLINK to provide IB port and node
> > GUIDs, which were configured for Infiniband VFs.
> >
> > The functionality to set VF GUIDs already existed for a long time, and =
here
> > we are adding the missing "get" so that netlink will be symmetric
> > and various cloud orchestration tools will be able to manage such
> > VFs more naturally.
> >
> > The iproute2 was extended too to present those GUIDs.
> >
> > - ip link show <device>
> >
> > For example:
> > - ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
> > - ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
> > - ip link show ib4
> >     ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFA=
ULT group default qlen 256
> >     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:=
44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> >     vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:=
9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff=
:ff:ff,
> >     spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10=
:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off
> >
> > Due to the fact that this series touches both net and RDMA, we assume
> > that it needs to be applied to our shared branch (mlx5-next) and pulled
> > later by Dave and Doug/Jason.
> >
> > Thanks
> >
> > Danit Goldberg (4):
> >   net/core: Add support for getting VF GUIDs
> >   IB/core: Add interfaces to get VF node and port GUIDs
> >   IB/ipoib: Add ndo operation for getting VFs GUID attributes
> >   IB/mlx5: Implement callbacks for getting VFs GUID attributes
>
> Dave,
>
> I see that you marked these patches as "not applicable" in patchworks.
>
> Can I assume that you are OK with them and we can take them through RDMA
> tree? If yes, can you give your Ack on the first patch?

Kindly reminder.

Thanks

>
> Thanks
