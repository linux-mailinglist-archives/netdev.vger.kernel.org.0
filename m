Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3632B169E4D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 07:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBXGOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 01:14:15 -0500
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:6194
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgBXGOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 01:14:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJgU1uKI1xdLScBkLPJaXeYX5ynoyD0LU5rVKQWZ5qmV9E/r4ZUzYOrZwFz0oAQKCuOr9MdV/5C8TUtGNPtIDZNU9FVC8r3THqEA3YDJmMyQClTK9xHxRbuhTAavBbESPARf1d6fSS8jNOQay1N7uMdTWVRiJVzGbc7F+8QyX9DWl7AREM0PFEa9FPN8gs70AOxXQGwIBgNC9X37PKHJJKPKwR3SvJuaYcS3atnKSOe74HFJyFf2Qs+K6UqvcqprZrEs3tTWkHJAqBffaXG8SBl/OuUxsoWmwzikfj2ODmwXEgh00gROgMvc9oDKjoDULgSEHUaRymQnMGjdBOZ8bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alMWLtXvWLUFiKKeBW4jwPDU97fzPDrvvlOB4SsHxU0=;
 b=L+utFhOOYdh47zfAVWnZmrBsZB5NwrQZpOjVqeoZ7L2Zl7FSe85crSbIYUKJvtc8tt3m3KpbHy+3CmLgNOw45AxzFbBcZdURLB9o2OwlRvQk5/73hZ8eAcrpG9qQBF8008t5OWR8VPGJDMw5AzvvUvMoQARunncEO3Usr19iaobfq0lwI8ZULsmmMirfpamrDOzOXVU6+5+pjlnA6SF5gxlRIl4aYOBROGTbErH2VuXVYpe+UlqqBFzeT2buYNXDnQ2K8DJ7GLHhfukNQ7ukvUu/3ICGbG7Ai88A3knlcBPlJsWl3SjsMuk5z7DQyFMFvcZfwrcuW/Qs4l+jwI9IUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alMWLtXvWLUFiKKeBW4jwPDU97fzPDrvvlOB4SsHxU0=;
 b=BN8nYHuCTjd6Wm6msxBxq4NJNaaY+kijUK3YD7YkP3zDjso3WfeFJ41XT1H8cpyS+WdXSjBBYjbter0S3CAU7yU5nEwRDBTvg28hITpwRx5yrCYNTPqAl16ofvW94Mh9VLM0ag6wxRUw22OfTDif4nUQyaBpeP5l9ikG/lKlu/0=
Received: from BY5PR02MB6371.namprd02.prod.outlook.com (2603:10b6:a03:1fd::30)
 by BY5PR02MB6612.namprd02.prod.outlook.com (2603:10b6:a03:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Mon, 24 Feb
 2020 06:14:11 +0000
Received: from BY5PR02MB6371.namprd02.prod.outlook.com
 ([fe80::a9b0:3f4f:bc1b:6af9]) by BY5PR02MB6371.namprd02.prod.outlook.com
 ([fe80::a9b0:3f4f:bc1b:6af9%7]) with mapi id 15.20.2729.033; Mon, 24 Feb 2020
 06:14:11 +0000
From:   Harpreet Singh Anand <hanand@xilinx.com>
To:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH V4 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH V4 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHV57TR1Z0KZ5FfHE6YGohVy6yJOKgp4y6Q
Date:   Mon, 24 Feb 2020 06:14:11 +0000
Message-ID: <BY5PR02MB63714A03B7135F8C4054C1E8BBEC0@BY5PR02MB6371.namprd02.prod.outlook.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-4-jasowang@redhat.com>
In-Reply-To: <20200220061141.29390-4-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hanand@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a47f951c-5785-4eea-b3ce-08d7b8f0c3ff
x-ms-traffictypediagnostic: BY5PR02MB6612:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB66127B421DAE5F59DF2FFFCCBBEC0@BY5PR02MB6612.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(189003)(199004)(4326008)(6506007)(7696005)(76116006)(4744005)(7416002)(186003)(66446008)(86362001)(66476007)(66556008)(64756008)(66946007)(26005)(55016002)(9686003)(5660300002)(478600001)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(54906003)(110136005)(52536014)(71200400001)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6612;H:BY5PR02MB6371.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PPFarlK54GWEwrRZ4vqRoPDwaWRBpGf1Kqn9feiCY11G0pNG4/UprdPR5fIMosqyto8bz5s19afY0K3B+OdZUxsb4R/rRjaXApTzmIsJ8I8kSD7nV6ZFFuiHVfwgF2z5iO17/T5ZALqhIkQZoxrkjZunTpJdh1hb/eKnZf45r+O4tEKq4NvtYGUE4ovWrloLG/Ec0/UwAA/tb4jc5WkSw9b2v6gxdesLjZAHozyvnFqNVCB1JFexBOyvHAYKGLKy9AokKHDASvAe+M3mW6VPhIyoxjV5LPqLEuzwVgrNGJuB4R1vnWpBJ/aj7gDYrDk2FidcdSjssPfhvSdsg7onzXD5CiywYb+t6/9uE4NUKdFFZtMnmGXnahE9VDUnEH219IpjRxxvm7aerI2HD1Wu1gG3jFDOMGhSW0v+t7FBj+nVcsBFlCNfjkpGXXr0sf+U
x-ms-exchange-antispam-messagedata: mjlywQv6V1vH+xE6nA4S4yQaRcAbRXK8Zjez6kN7rBxfPZMU3GtOo/iQuxCyqNQa0vcCn8WTCem1AGyKPx7j07vubR7KnVaH4j97wbHZ2ilsqWBHn2XNj6wldD8qLP6wFZKhMGnyWklUvE/nlJdzDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47f951c-5785-4eea-b3ce-08d7b8f0c3ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 06:14:11.4702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+N+9MB+sVvisll2J45o00lDUeKW29fM4+ThRJQvn8Wts//GPBCqiUO41fvmGX7iDQU5lN+8P7RHnTl6u7t8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is there a plan to add an API in vDPA_config_ops for getting the notificati=
on area from the VDPA device (something similar to get_notify_area in the V=
DPA DPDK case)? This will make the notifications from the guest  (vhost_vdp=
a use case) to the VDPA device more efficient - at least for virtio 1.0+ dr=
ivers in the VM.

I believe this would require enhancement to the vhost ioctl (something simi=
lar to the  VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG).


Regards,
Harpreet

