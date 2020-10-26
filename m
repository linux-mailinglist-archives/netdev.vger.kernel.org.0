Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235EE298656
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 06:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768373AbgJZFYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 01:24:07 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:11312 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768351AbgJZFYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 01:24:06 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f965d740002>; Mon, 26 Oct 2020 13:24:04 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 05:23:52 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 05:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP+9bidxNVRZPCeIYcrgqDiVBhlURUe4mvJh8BCpwtn8k48AcsSn3mSt+0yNOv5xOTw9n2pCGmo/b00j6JP93lIA7NnboxH0rypaMnTvzAJvmkAtc0/DV3Rf/4hwUDdR5YAPCxgcIj6asK/6IEaFrINdP5I5nXwB/JNzqW/nL4NWhA+GkKGqUEFHmMN9Ujzs+XmtJmZ1QlaYdKjHD4qPzAfIjLxNgS9n7BGQSwEE++BGhF5gvWCrtK1bOi6MLEcrKctQXx8Mbjpv7pwJycBO7ywyK8qCturi6m41Qcq9d8h2bm4DjlF+0D7LjgSn5bjv2RPyp+8pI3UEc99d7IAsMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbMLpDqrsvU0+iByqjIAN0xatWbwA6AlnyCh2OwMIvU=;
 b=KDNG1u7F/Vqz1klep1mD6dQU3nw/9NdSXYalEe6W//2lyfUzVwwNp9rzQ7zgELAze2nNUyrHfbKH7wSR1nMXOhDp/TMQqnd/qEf/NxWWLFdOD4HPDxYhTPTe79WUNmTRPDBNGQtCDPBKOCUFiyRzBOdn7cpF3pWGGepPFkt7WfaLSmPCGLE7yZw3wHQ4Ou+Orb8xCJNDp8kpfGJvfY4pC4CWqEHEpT4zcurDpDi4C/iaV0ZfE86qWfSGqytps+bFd1MNKf1DY3K2aR5JDz5/VFdk16wGHg4d4rkeRX5T8eegcxUlTqPZjwI5ET7bRo+9CGNE6U3/vYhMCRDFzVkiAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3842.namprd12.prod.outlook.com (2603:10b6:a03:1ab::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 05:23:48 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 05:23:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>
CC:     "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "hch@lst.de" <hch@lst.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linaro-mm-sig-owner@lists.linaro.org" 
        <linaro-mm-sig-owner@lists.linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: WARNING in dma_map_page_attrs
Thread-Topic: WARNING in dma_map_page_attrs
Thread-Index: AQHWqbLPPEPI9mnwmUSeVEeL/Zim3qmnD9kAgAJKk0A=
Date:   Mon, 26 Oct 2020 05:23:48 +0000
Message-ID: <BY5PR12MB4322CC03CE0D34B83269676ADC190@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <000000000000335adc05b23300f6@google.com>
        <000000000000a0f8a305b261fe4a@google.com>
 <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1011120-8eb3-4bd9-1576-08d8796f5156
x-ms-traffictypediagnostic: BY5PR12MB3842:
x-microsoft-antispam-prvs: <BY5PR12MB38420528634827441C4D31F2DC190@BY5PR12MB3842.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y+3F1SaWjx/zRrb0K3rSjRkyshOOTTlkfAS0S1MJ4igzSWAV2f3LtcEhi460dXZxxU2pN8pUb78Y4T6P41a8xczXqoWyEzM62ZnocZI0JrJFE/G8d/WGfU1MgvGDJ6AjP+Lfy3iRMawvAGBlJG2tqBehHhS2Gbu81eJvuuz75CMDrSSKWHtUUoBOJalPislzN9Asp3iph7H6eWt5ZPoWl/iJJbrzcJyOvnhCsBYaka4S0WOUsGdN+BJKO2z5wHM16cr4v0W5MczTGyteinrPQMtzu8lN2Ki50G2i6ES7iqde6hDO4j3V7T5WocvsNiZV/36238gDctiW4ESwprkSwi6YB0X+rMADd9WJKhb/7WPHttI7xXKPSsda5aEHJa19iTJlQ+jnc9OYvhyZVQfjRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(7116003)(2906002)(7416002)(66946007)(4326008)(8936002)(5660300002)(55016002)(33656002)(478600001)(45080400002)(83380400001)(966005)(110136005)(66476007)(64756008)(66556008)(86362001)(52536014)(76116006)(66446008)(186003)(71200400001)(316002)(26005)(54906003)(6506007)(55236004)(8676002)(7696005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: um3a6/B+qi795WTVO+zikuAuO8OsftQsFvKddYoBgSHg2hFOq3JYHAg3cBbzLf3ZEVu6879ppX1b+qU0dGbCyPSdK9K3yn/lI3+N16kTt+hHJX/B6rZoXJK1dorMF/hczLrQAZsYLrsywJ03tA0WRdir4A39dVBQfOtUqOsbEG/+WK+4+wkBRh6zPVPTtY8JdDr0dhXzNVn6oa8+s/vDapiBpC4Ovupjo+tQJFDITjSN21v2NOP86elQzuqS8G4RFGttTqycN2/adA4eDdhkgytvVPHEeaGJO3Y2QpRIrDztz+i6XFsLODOz+SoJShDuVONjPJlScYY85FpJajOi+xoBlBndq5TzCFSH62ZyndokB4tdAI8xJhmwV5cgBJUi3eYox6aZZEBhaG2tElYDLhQ0uHbTon2V9MCJTnFPG9dRFhubTuoNOkVbfI7rm+/srWBwXT3tJUWWgDCa8/76YXcq8inTMbx9PpZ97H07g4vOo8dWj2izaFahSUZOGXmgj8FlQxgrEvZqa3Rqjnl5xUbb4WFR6gzzzK3sjovsb3pqh4Aq93/iCyubG/JgZ9GzzzuEI33e/kSQdBw/9hUsP/rtUtA82maaQAnA/jS2JRt7Hz/VRSSqEn9hkL+rHK9kAW4UroyhPhhUTr5RiYLjMA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1011120-8eb3-4bd9-1576-08d8796f5156
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 05:23:48.4438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34yrQB1V5yaoAvaBs06eEUzOtttYEuGETHA7nEqHb+pxirXG1j7n/hCF44Wjy4VsQlyitKkXvStD+e0K612ohA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3842
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603689844; bh=tbMLpDqrsvU0+iByqjIAN0xatWbwA6AlnyCh2OwMIvU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=IAOVmhswVe83Qe3IsX4Xt7Ei3P+qa6kSxmgtT6+zEwaQyqKnS+BiXAA1ymF2RTzzf
         RPYBKBKp4vRRAzwLESbu/NUG+f9jdcgOQvzEser5dWyVDxsG2c1/eM0olFqrq8kT0d
         ZnD2OlDb/OlbBJRjrbi52t6BdIsFKe/vsgw9UtauzK2POwYvoDA02eTJWIoNBGlmRZ
         nbXRj4qKCASD4U2f0kWTd68wv7lonaxkQLXALrD4Z5gPAHUTOe9wWhj4D+JrONuDT0
         qS7b7wwKknKCpSKq8VcuHXm7eplpBzEP9W1wDzEY8ZG0YiH5jmX0h6WFdybRtK1kDn
         VWyqhRUUqEnUg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, October 24, 2020 11:45 PM
>=20
> CC: rdma, looks like rdma from the stack trace
>=20
> On Fri, 23 Oct 2020 20:07:17 -0700 syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of git://git.kernel.o=
rg/..

In [1] you mentioned that dma_mask should not be set for dma_virt_ops.
So patch [2] removed it.

But check to validate the dma mask for all dma_ops was added in [3].

What is the right way? Did I misunderstood your comment about dma_mask in [=
1]?

[1] https://www.spinics.net/lists/linux-rdma/msg96374.html
[2] e0477b34d9d ("RDMA: Explicitly pass in the dma_device to ib_register_de=
vice")
[3] f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")

> > WARNING: CPU: 1 PID: 8488 at kernel/dma/mapping.c:149
> > dma_map_page_attrs+0x493/0x700 kernel/dma/mapping.c:149 Modules
> linked in:
> >  dma_map_single_attrs include/linux/dma-mapping.h:279 [inline]
> > ib_dma_map_single include/rdma/ib_verbs.h:3967 [inline]
> >  ib_mad_post_receive_mads+0x23f/0xd60
> > drivers/infiniband/core/mad.c:2715
> >  ib_mad_port_start drivers/infiniband/core/mad.c:2862 [inline]
> > ib_mad_port_open drivers/infiniband/core/mad.c:3016 [inline]
> >  ib_mad_init_device+0x72b/0x1400 drivers/infiniband/core/mad.c:3092
> >  add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:680
> >  enable_device_and_get+0x1d5/0x3c0
> > drivers/infiniband/core/device.c:1301
> >  ib_register_device drivers/infiniband/core/device.c:1376 [inline]
> >  ib_register_device+0x7a7/0xa40 drivers/infiniband/core/device.c:1335
> >  rxe_register_device+0x46d/0x570
> > drivers/infiniband/sw/rxe/rxe_verbs.c:1182
> >  rxe_add+0x12fe/0x16d0 drivers/infiniband/sw/rxe/rxe.c:247
> >  rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:507
> >  rxe_newlink drivers/infiniband/sw/rxe/rxe.c:269 [inline]
> >  rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:250
> >  nldev_newlink+0x30e/0x540 drivers/infiniband/core/nldev.c:1555
> >  rdma_nl_rcv_msg+0x367/0x690 drivers/infiniband/core/netlink.c:195
> >  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
> >  rdma_nl_rcv+0x2f2/0x440 drivers/infiniband/core/netlink.c:259
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
> >  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
> > sock_sendmsg_nosec net/socket.c:651 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:671
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x443699
> > Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 0f 83 db 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007ffc067db418 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002e
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443699
> > RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000003
> > RBP: 00007ffc067db420 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc067db430
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> >

